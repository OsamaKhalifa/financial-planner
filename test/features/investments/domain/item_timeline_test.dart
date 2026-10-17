/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/item_timeline.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
Decimal d(String s) => Decimal.parse(s);

Investment inv(Unit unit) => Investment(
  id: 'a',
  name: 'a',
  type: AssetType.fund,
  unit: unit,
  startDate: day(2026, 1, 1),
  zakatRule: ZakatRule.trading100,
);

MoneyIn mIn(DateTime on, String amount, Unit unit) =>
    MoneyIn(investmentId: 'a', date: on, amount: Money(d(amount), unit));

void main() {
  test('money in raises and money out lowers the value, unless a value is recorded that day', () {
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: inv(egp),
        history: [
          mIn(day(2026, 1, 1), '1000', egp),
          MoneyOut(
            investmentId: 'a',
            date: day(2026, 2, 1),
            amount: Money(d('300'), egp),
          ),
          mIn(day(2026, 3, 1), '500', egp),
          ValueUpdate(
            investmentId: 'a',
            date: day(2026, 3, 1),
            value: d('2000'),
          ),
        ],
      ),
      RateBook(const []),
    );
    expect(tl.recordedValueAt(day(2025, 12, 31)), Decimal.zero);
    expect(tl.recordedValueAt(day(2026, 1, 15)), d('1000'));
    expect(tl.recordedValueAt(day(2026, 2, 1)), d('700'));
    expect(tl.recordedValueAt(day(2026, 3, 1)), d('2000'));
  });

  test('entry order inside one day does not matter', () {
    final entries = [
      mIn(day(2026, 1, 1), '100', egp),
      mIn(day(2026, 1, 1), '200', egp),
    ];
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: inv(egp),
        history: entries.reversed.toList(),
      ),
      RateBook(const []),
    );
    expect(tl.recordedValueAt(day(2026, 1, 1)), d('300'));
  });

  test(
    'flows exclude interest and the start of the period, include its end',
    () {
      final tl = ItemTimeline(
        InvestmentWithHistory(
          investment: inv(egp),
          history: [
            mIn(day(2026, 1, 1), '100', egp),
            mIn(day(2026, 1, 31), '50', egp),
            InterestRecord(
              investmentId: 'a',
              date: day(2026, 1, 20),
              amount: Money(d('5'), egp),
              kind: InterestKind.paidOut,
            ),
          ],
        ),
        RateBook(const []),
      );
      final flows = tl.flowsIn(day(2026, 1, 1), day(2026, 1, 31));
      expect(flows.single.amount, d('50'));
    },
  );

  test('income is summed separately from sales', () {
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: inv(egp),
        history: [
          mIn(day(2026, 1, 1), '1000', egp),
          MoneyOut(
            investmentId: 'a',
            date: day(2026, 3, 1),
            amount: Money(d('40'), egp),
            kind: MoneyOutKind.income,
          ),
          MoneyOut(
            investmentId: 'a',
            date: day(2026, 3, 2),
            amount: Money(d('100'), egp),
          ),
        ],
      ),
      RateBook(const []),
    );
    expect(tl.incomeIn(day(2025, 12, 31), day(2026, 12, 31)), d('40'));
    expect(tl.flowsIn(day(2025, 12, 31), day(2026, 12, 31)).length, 3);
  });

  test('income keeps the recorded value; a sale lowers it (Q12)', () {
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: inv(egp),
        history: [
          mIn(day(2026, 1, 1), '1000', egp),
          MoneyOut(
            investmentId: 'a',
            date: day(2026, 3, 1),
            amount: Money(d('1500'), egp),
            kind: MoneyOutKind.income,
          ),
          MoneyOut(
            investmentId: 'a',
            date: day(2026, 4, 1),
            amount: Money(d('300'), egp),
          ),
        ],
      ),
      RateBook(const []),
    );
    expect(tl.recordedValueAt(day(2026, 3, 1)), d('1000'));
    expect(tl.closedAt(day(2026, 3, 1)), isFalse);
    expect(tl.recordedValueAt(day(2026, 4, 1)), d('700'));
  });

  test('a skip is not an actual record: no value, no flow, no activity', () {
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: inv(egp),
        history: [
          mIn(day(2026, 1, 1), '1000', egp),
          PlanSkip(
            investmentId: 'a',
            date: day(2026, 2, 1),
            plan: PlanKind.payout,
          ),
        ],
      ),
      RateBook(const []),
    );
    expect(tl.activeIn(day(2026, 1, 31), day(2026, 2, 28)), isFalse);
    expect(tl.latestValueDate, day(2026, 1, 1));
    expect(tl.flowsIn(day(2025, 12, 31), day(2026, 12, 31)).length, 1);
  });

  test('case C: income leaves flows and income, and is to purify (E5)', () {
    final pe = Investment(
      id: 'a',
      name: 'a',
      type: AssetType.privateEquity,
      intent: Intent.longTerm,
      unit: egp,
      startDate: day(2026, 1, 1),
      zakatRule: ZakatRule.longTermFullValue,
      capitalBack: CapitalBack.yes,
    );
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: pe,
        history: [
          mIn(day(2026, 1, 1), '1000', egp),
          MoneyOut(
            investmentId: 'a',
            date: day(2026, 3, 1),
            amount: Money(d('50'), egp),
            kind: MoneyOutKind.income,
          ),
          InterestRecord(
            investmentId: 'a',
            date: day(2026, 4, 1),
            amount: Money(d('20'), egp),
            kind: InterestKind.givenAwayFromPaidOut,
          ),
        ],
      ),
      RateBook(const []),
    );
    final all = (day(2025, 12, 31), day(2026, 12, 31));
    expect(tl.flowsIn(all.$1, all.$2).single.amount, d('1000'));
    expect(tl.incomeFlows(all.$1, all.$2), isEmpty);
    expect(tl.toPurifyAt(day(2026, 3, 1)).amount, d('50'));
    expect(tl.toPurifyAt(day(2026, 4, 1)).amount, d('30'));
    expect(tl.recordedValueAt(day(2026, 4, 1)), d('1000'));
  });

  test('a missing rate is collected, never converted 1:1', () {
    final tl = ItemTimeline(
      InvestmentWithHistory(
        investment: inv(usd),
        history: [mIn(day(2026, 1, 1), '5000', egp)],
      ),
      RateBook([
        Rate(from: usd, to: egp, rate: d('50'), asOf: day(2026, 2, 1)),
      ]),
    );
    expect(tl.missing.single.from, egp);
    expect(tl.missing.single.to, usd);
    expect(tl.missing.single.date, day(2026, 1, 1));
    expect(tl.recordedValueAt(day(2026, 1, 1)), Decimal.zero);
  });

  test(
    'activeIn ignores interest; latestValueDate falls back to the start date',
    () {
      final only = ItemTimeline(
        InvestmentWithHistory(
          investment: inv(egp),
          history: [
            InterestRecord(
              investmentId: 'a',
              date: day(2026, 5, 1),
              amount: Money(d('5'), egp),
              kind: InterestKind.paidOut,
            ),
          ],
        ),
        RateBook(const []),
      );
      expect(only.activeIn(day(2026, 4, 30), day(2026, 5, 31)), isFalse);
      expect(only.latestValueDate, day(2026, 1, 1));
    },
  );

  test('closedAt is false before anything is recorded', () {
    final tl = ItemTimeline(
      InvestmentWithHistory(investment: inv(egp)),
      RateBook(const []),
    );
    expect(tl.closedAt(day(2026, 6, 1)), isFalse);
  });
}
