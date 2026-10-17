/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/expected_plan.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/item_timeline.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
Decimal d(String s) => Decimal.parse(s);
final _epoch = DateTime.utc(2026);
var _seq = 0;

Investment plan({
  AssetType type = AssetType.fund,
  Unit unit = egp,
  Schedule? payout = Schedule.monthly,
  String? profit = '0.12',
  Schedule? check,
  String? growth,
  AccountKind? account,
}) => Investment(
  id: 'a',
  name: 'a',
  type: type,
  unit: unit,
  startDate: day(2026, 1, 1),
  zakatRule: ZakatRule.trading100,
  payoutSchedule: payout,
  expectedProfit: profit == null ? null : d(profit),
  valueCheckSchedule: check,
  expectedGrowth: growth == null ? null : d(growth),
  accountKind: account,
);

MoneyIn mIn(DateTime on, String a, [Unit u = egp]) => MoneyIn(
  id: 'e${_seq++}',
  investmentId: 'a',
  date: on,
  amount: Money(d(a), u),
  createdAt: _epoch,
);

MoneyOut income(DateTime on, String a, {DateTime? created}) => MoneyOut(
  id: 'e${_seq++}',
  investmentId: 'a',
  date: on,
  amount: Money(d(a), egp),
  kind: MoneyOutKind.income,
  createdAt: created ?? _epoch,
);

ExpectedVsActual of(
  Investment i,
  List<HistoryEntry> h,
  DateTime today, [
  List<Rate> rates = const [],
]) => expectedVsActual(
  ItemTimeline(
    InvestmentWithHistory(investment: i, history: h),
    RateBook(rates),
  ),
  today,
)!;

void main() {
  final start = mIn(day(2026, 1, 1), '10000');

  test('no schedule: no plan at all', () {
    final i = plan(payout: null, profit: null);
    expect(
      expectedVsActual(
        ItemTimeline(
          InvestmentWithHistory(investment: i, history: [start]),
          RateBook(const []),
        ),
        day(2026, 6, 1),
      ),
      isNull,
    );
  });

  test(
    'windows never overlap: monthly rows across February take one record each',
    () {
      final p = of(plan(), [
        start,
        income(day(2026, 2, 8), '100'),
        income(day(2026, 2, 20), '100'),
        income(day(2026, 3, 8), '100'),
      ], day(2026, 3, 20));
      expect(p.payoutRows.map((r) => r.date), [
        day(2026, 2, 1),
        day(2026, 3, 1),
      ]);
      expect(p.payoutRows[0].actual!.date, day(2026, 2, 8));
      expect(p.payoutRows[1].actual!.date, day(2026, 3, 8));
      expect(p.received, d('300'));
    },
  );

  test('oldest record first inside a window, by date then created time', () {
    final late = income(day(2026, 1, 29), '1', created: DateTime.utc(2026, 5));
    final early = income(day(2026, 1, 29), '2', created: DateTime.utc(2026, 4));
    final p = of(plan(), [start, late, early], day(2026, 2, 3));
    expect(p.payoutRows.single.actual!.id, early.id);
    expect(p.payoutRows.single.actualAmount, d('2'));
  });

  test(
    'a matched record beats a skip; a skip counts only on its exact date',
    () {
      final skip = PlanSkip(
        investmentId: 'a',
        date: day(2026, 2, 1),
        plan: PlanKind.payout,
      );
      final offDay = PlanSkip(
        investmentId: 'a',
        date: day(2026, 3, 2),
        plan: PlanKind.payout,
      );
      final p = of(plan(), [
        start,
        skip,
        offDay,
        income(day(2026, 2, 3), '100'),
      ], day(2026, 3, 5));
      expect(p.payoutRows[0].state, RowState.resolved);
      expect(p.payoutRows[0].skip, isNull);
      expect(p.payoutRows[1].state, RowState.pending);
    },
  );

  test('a value skip does not skip the payout row of the same date', () {
    final p = of(plan(check: Schedule.monthly), [
      start,
      PlanSkip(investmentId: 'a', date: day(2026, 2, 1), plan: PlanKind.value),
    ], day(2026, 2, 3));
    expect(p.payoutRows.single.state, RowState.pending);
    expect(p.valueRows.single.state, RowState.skipped);
    expect(p.valueRows.single.noPayoutLine, isFalse);
  });

  test('a closed item has no row after its closing date', () {
    final p = of(plan(), [
      start,
      MoneyOut(
        investmentId: 'a',
        date: day(2026, 2, 10),
        amount: Money(d('10000'), egp),
      ),
    ], day(2026, 5, 1));
    expect(p.payoutRows.map((r) => r.date), [day(2026, 2, 1)]);
    expect(p.toConfirm, 0);
  });

  test('a missing rate: every expected amount is null, the pair is named', () {
    final p = of(plan(unit: usd, check: Schedule.monthly, growth: '0.1'), [
      mIn(day(2026, 1, 1), '5000', egp),
    ], day(2026, 2, 3));
    expect(p.missing.single.from, egp);
    expect(p.payoutRows.single.expected, isNull);
    expect(p.valueRows.single.expected, isNull);
    expect(p.expectedSoFar, isNull);
    expect(p.expectedValueAt(day(2026, 2, 1)), isNull);
  });

  test('money in another unit is converted at its own date', () {
    final p = of(
      plan(unit: usd),
      [mIn(day(2026, 1, 1), '5000', egp)],
      day(2026, 2, 3),
      [Rate(from: usd, to: egp, rate: d('50'), asOf: day(2026, 1, 1))],
    );
    expect(p.payoutRows.single.expected, d('1.00'));
  });

  test('no %: rows with no amount, no expected total', () {
    final p = of(plan(profit: null), [start], day(2026, 2, 3));
    expect(p.payoutRows.single.expected, isNull);
    expect(p.expectedSoFar, isNull);
    expect(p.difference, isNull);
  });

  test(
    'conventional deposit: only interest received resolves a payout row',
    () {
      final dep = plan(
        type: AssetType.cashDeposit,
        account: AccountKind.conventional,
      );
      final interest = InterestRecord(
        investmentId: 'a',
        date: day(2026, 2, 3),
        amount: Money(d('100'), egp),
        kind: InterestKind.paidOut,
      );
      final p = of(dep, [start, interest], day(2026, 2, 5));
      expect(p.payoutRows.single.actual, interest);
      expect(p.received, d('100'));
      final q = of(dep, [
        start,
        income(day(2026, 2, 3), '100'),
      ], day(2026, 2, 5));
      expect(q.payoutRows.single.pending, isTrue);
      expect(q.received, Decimal.zero);
    },
  );

  test(
    'pendingRowNear finds a pending row within 7 days, of the asked kind',
    () {
      final p = of(plan(check: Schedule.monthly), [start], day(2026, 2, 3));
      expect(
        p.pendingRowNear(day(2026, 2, 8), PlanKind.payout)!.date,
        day(2026, 2, 1),
      );
      expect(
        p.pendingRowNear(day(2026, 1, 25), PlanKind.value)!.date,
        day(2026, 2, 1),
      );
      expect(p.pendingRowNear(day(2026, 2, 9), PlanKind.payout), isNull);
    },
  );
}
