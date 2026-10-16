/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/core/storage_exceptions.dart';
import 'package:financial_planner/features/investments/data/drift_investments_repository.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/period.dart';
import 'package:financial_planner/features/investments/domain/portfolio_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
Decimal d(String s) => Decimal.parse(s);

late AppDatabase db;
late DriftInvestmentsRepository repo;
var clock = DateTime.utc(2026, 10, 16, 9);

Investment fund(String id, {DateTime? start}) => Investment(
  id: id,
  name: id,
  type: AssetType.fund,
  intent: Intent.trading,
  unit: egp,
  startDate: start ?? day(2026, 1, 1),
  zakatRule: ZakatRule.trading100,
);

ValueUpdate val(String id, String inv, DateTime on, String v) =>
    ValueUpdate(id: id, investmentId: inv, date: on, value: d(v));

Future<List<InvestmentWithHistory>> all() => repo.watchAll().first;

void main() {
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = DateTime.utc(2026, 10, 16, 9);
    repo = DriftInvestmentsRepository(db, () => clock);
  });
  tearDown(() => db.close());

  test(
    'every field and every entry kind round-trips, Decimals at 20 dp',
    () async {
      final item = Investment(
        id: 'x',
        name: 'Al Rajhi',
        type: AssetType.stock,
        intent: Intent.longTerm,
        market: Market.other,
        marketCountry: const Country('SAU'),
        unit: usd,
        startDate: day(2025, 2, 3),
        quantity: d('12.5'),
        purityKarat: 21,
        purityFineness: 999,
        zakatRule: ZakatRule.custom,
        customZakatShare: d('0.12345678901234567890'),
        inflationOverride: const Country('EGY'),
        notes: 'broker A',
      );
      final created = DateTime.utc(1999);
      final entries = <HistoryEntry>[
        MoneyIn(
          id: 'a',
          investmentId: 'x',
          date: day(2025, 2, 3),
          amount: Money(d('1000.00000000000000000001'), usd),
          createdAt: created,
          updatedAt: created,
        ),
        MoneyOut(
          id: 'b',
          investmentId: 'x',
          date: day(2025, 3, 3),
          amount: Money(d('5'), egp),
          kind: MoneyOutKind.income,
          createdAt: created,
          updatedAt: created,
        ),
        MoneyOut(
          id: 'c',
          investmentId: 'x',
          date: day(2025, 3, 4),
          amount: Money(d('6'), usd),
          createdAt: created,
          updatedAt: created,
        ),
        for (final (i, k) in InterestKind.values.indexed)
          InterestRecord(
            id: 'i$i',
            investmentId: 'x',
            date: day(2025, 4, 1 + i),
            amount: Money(d('1.5'), usd),
            kind: k,
            createdAt: created,
            updatedAt: created,
          ),
        ValueUpdate(
          id: 'v',
          investmentId: 'x',
          date: day(2025, 5, 1),
          value: d('0.00000000000000000001'),
          createdAt: created,
          updatedAt: created,
        ),
      ];
      await repo.create(item, entries);

      final back = (await all()).single;
      final i = back.investment;
      expect(
        (i.name, i.type, i.intent, i.market, i.marketCountry, i.unit),
        (
          item.name,
          item.type,
          item.intent,
          item.market,
          item.marketCountry,
          item.unit,
        ),
      );
      expect(
        (i.startDate, i.quantity, i.purityKarat, i.purityFineness),
        (item.startDate, item.quantity, item.purityKarat, item.purityFineness),
      );
      expect(
        (i.zakatRule, i.customZakatShare, i.inflationOverride, i.notes),
        (
          item.zakatRule,
          item.customZakatShare,
          item.inflationOverride,
          item.notes,
        ),
      );
      expect((i.createdAt, i.updatedAt), (clock, clock));
      expect(back.history.length, entries.length);

      final byId = {for (final e in back.history) e.id: e};
      final in0 = byId['a'] as MoneyIn;
      expect(in0.amount, Money(d('1000.00000000000000000001'), usd));
      expect((byId['b'] as MoneyOut).kind, MoneyOutKind.income);
      expect((byId['c'] as MoneyOut).kind, MoneyOutKind.sale);
      for (final (i, k) in InterestKind.values.indexed) {
        expect((byId['i$i'] as InterestRecord).kind, k);
      }
      expect((byId['v'] as ValueUpdate).value, d('0.00000000000000000001'));
      expect((in0.createdAt, in0.updatedAt), (clock, clock));
      expect(in0.date.isUtc, isTrue);
    },
  );

  test('an item without history is listed, with an empty history', () async {
    await repo.create(fund('a'), const []);
    final list = await all();
    expect(list.single.history, isEmpty);
  });

  test('items come in creation order, history in date order', () async {
    await repo.create(fund('late'), [val('l1', 'late', day(2026, 3, 1), '1')]);
    clock = clock.add(const Duration(seconds: 5));
    await repo.create(fund('early'), [
      val('e2', 'early', day(2026, 2, 20), '2'),
      val('e1', 'early', day(2026, 2, 10), '1'),
    ]);
    final list = await all();
    expect(list.map((e) => e.investment.id), ['late', 'early']);
    expect(list.last.history.map((e) => e.id), ['e1', 'e2']);
  });

  test('watchAll emits again after a change', () async {
    final emissions = <int>[];
    final sub = repo.watchAll().listen((l) => emissions.add(l.length));
    await repo.create(fund('a'), const []);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await repo.create(fund('b'), const []);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();
    expect(emissions.last, 2);
  });

  test('AC-3: a third value update keeps all three', () async {
    await repo.create(fund('a'), [
      val('1', 'a', day(2026, 1, 31), '1000'),
      val('2', 'a', day(2026, 2, 28), '1100'),
    ]);
    await repo.saveEntries([val('3', 'a', day(2026, 3, 31), '1050')]);
    final h = (await all()).single.history;
    expect(h.whereType<ValueUpdate>().map((v) => v.value), [
      d('1000'),
      d('1100'),
      d('1050'),
    ]);
  });

  test('saveEntries replaces an entry with the same id', () async {
    await repo.create(fund('a'), [val('1', 'a', day(2026, 1, 31), '1000')]);
    await repo.saveEntries([val('1', 'a', day(2026, 1, 31), '1234')]);
    final h = (await all()).single.history;
    expect((h.single as ValueUpdate).value, d('1234'));
  });

  test(
    'a second value update on the same day is a Conflict and nothing is saved',
    () async {
      await repo.create(fund('a'), [val('1', 'a', day(2026, 1, 31), '1000')]);
      await expectLater(
        repo.saveEntries([
          MoneyIn(
            id: 'ok',
            investmentId: 'a',
            date: day(2026, 2, 1),
            amount: Money(d('1'), egp),
          ),
          val('2', 'a', day(2026, 1, 31), '2000'),
        ]),
        throwsA(isA<Conflict>()),
      );
      expect((await all()).single.history.map((e) => e.id), ['1']);
    },
  );

  test('money in and interest may repeat on one day; only value updates are unique', () async {
    await repo.create(fund('a'), [
      MoneyIn(
        id: '1',
        investmentId: 'a',
        date: day(2026, 1, 1),
        amount: Money(d('1'), egp),
      ),
      MoneyIn(
        id: '2',
        investmentId: 'a',
        date: day(2026, 1, 1),
        amount: Money(d('2'), egp),
      ),
    ]);
    expect((await all()).single.history.length, 2);
  });

  test('entries of an unknown item are NotFound', () async {
    await expectLater(
      repo.saveEntries([val('1', 'nope', day(2026, 1, 1), '1')]),
      throwsA(isA<NotFound>()),
    );
  });

  test(
    'delete cascades to the history; undo restores the whole aggregate',
    () async {
      final agg = InvestmentWithHistory(
        investment: fund('a'),
        history: [
          val('1', 'a', day(2026, 1, 31), '1000'),
          MoneyIn(
            id: '2',
            investmentId: 'a',
            date: day(2026, 1, 1),
            amount: Money(d('5'), egp),
          ),
        ],
      );
      await repo.create(agg.investment, agg.history);
      await repo.delete('a');
      expect(await all(), isEmpty);
      final orphans = await db.select(db.historyEntries).get();
      expect(orphans, isEmpty);

      await repo.restore(agg);
      final back = (await all()).single;
      expect(back.history.map((e) => e.id).toSet(), {'1', '2'});
    },
  );

  test(
    'update, delete and deleteEntry of an unknown id are NotFound',
    () async {
      await expectLater(repo.update(fund('nope')), throwsA(isA<NotFound>()));
      await expectLater(repo.delete('nope'), throwsA(isA<NotFound>()));
      await expectLater(repo.deleteEntry('nope'), throwsA(isA<NotFound>()));
    },
  );

  test('update changes the item and keeps its history', () async {
    await repo.create(fund('a'), [val('1', 'a', day(2026, 1, 31), '1000')]);
    await repo.update(
      Investment(
        id: 'a',
        name: 'renamed',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        startDate: day(2026, 1, 1),
        zakatRule: ZakatRule.trading100,
      ),
    );
    final back = (await all()).single;
    expect(back.investment.name, 'renamed');
    expect(back.history.length, 1);
  });

  test(
    'create is one transaction: a failing entry leaves no item behind',
    () async {
      await expectLater(
        repo.create(fund('a'), [
          val('1', 'a', day(2026, 1, 31), '1'),
          val('1', 'a', day(2026, 2, 28), '2'),
        ]),
        throwsA(isA<Conflict>()),
      );
      expect(await all(), isEmpty);
    },
  );

  test('create stamps createdAt and updatedAt (UTC) from the clock, ignoring the caller', () async {
    await repo.create(
      Investment(
        id: 'a',
        name: 'a',
        type: AssetType.fund,
        unit: egp,
        startDate: day(2026, 1, 1),
        zakatRule: ZakatRule.trading100,
        createdAt: DateTime.utc(1990),
        updatedAt: DateTime.utc(1990),
      ),
      [val('v', 'a', day(2026, 1, 1), '1')],
    );
    final back = (await all()).single;
    expect(
      (back.investment.createdAt, back.investment.updatedAt),
      (clock, clock),
    );
    expect(back.investment.createdAt.isUtc, isTrue);
    expect(
      (back.history.single.createdAt, back.history.single.updatedAt),
      (clock, clock),
    );
  });

  test('update and saveEntries keep createdAt and move updatedAt; new entries get both', () async {
    final first = clock;
    await repo.create(fund('a'), [val('v', 'a', day(2026, 1, 1), '1')]);
    clock = clock.add(const Duration(hours: 2));
    await repo.update(fund('a'));
    await repo.saveEntries([
      val('v', 'a', day(2026, 1, 1), '2'),
      val('w', 'a', day(2026, 2, 1), '3'),
    ]);
    final back = (await all()).single;
    expect(
      (back.investment.createdAt, back.investment.updatedAt),
      (first, clock),
    );
    final byId = {for (final e in back.history) e.id: e};
    expect((byId['v']!.createdAt, byId['v']!.updatedAt), (first, clock));
    expect((byId['w']!.createdAt, byId['w']!.updatedAt), (clock, clock));
  });

  test('restore puts back the original timestamps', () async {
    final first = clock;
    await repo.create(fund('a'), [val('v', 'a', day(2026, 1, 1), '1')]);
    final agg = (await all()).single;
    await repo.delete('a');
    clock = clock.add(const Duration(days: 1));
    await repo.restore(agg);
    final back = (await all()).single;
    expect(
      (back.investment.createdAt, back.history.single.createdAt),
      (first, first),
    );
  });

  test(
    'AC-4: a closed item read back from storage still counts in past months',
    () async {
      await repo.create(fund('a', start: day(2026, 1, 10)), [
        MoneyIn(
          id: '1',
          investmentId: 'a',
          date: day(2026, 1, 10),
          amount: Money(d('1000'), egp),
        ),
        MoneyOut(
          id: '2',
          investmentId: 'a',
          date: day(2026, 3, 15),
          amount: Money(d('1000'), egp),
        ),
        val('3', 'a', day(2026, 3, 15), '0'),
      ]);
      final calc = PortfolioCalculator(
        items: await all(),
        rates: RateBook(const []),
        inflation: InflationBook(const ShippedInflation(series: {}), const []),
        settings: const Settings(baseCurrency: egp, zakatYear: ZakatYear.lunar),
        noZakatYears: const {},
        today: day(2026, 10, 16),
      );
      final today = day(2026, 10, 16);
      expect(
        calc.portfolio(Period.month(2026, 2, today), ViewUnit.base).dietz.ev,
        d('1000'),
      );
      expect(calc.item('a', Period.month(2026, 3, today)).closed, isTrue);
    },
  );

  test('D1 budget: 12k entries and 2k rates compute the month and year lists in under 200 ms', () async {
    final stored = <InvestmentWithHistory>[];
    for (var n = 0; n < 50; n++) {
      final id = 'i$n';
      final unit = n % 5 == 0 ? usd : egp;
      stored.add(
        InvestmentWithHistory(
          investment: Investment(
            id: id,
            name: id,
            type: AssetType.fund,
            intent: Intent.trading,
            unit: unit,
            startDate: day(2016, 1, 1),
            zakatRule: ZakatRule.trading100,
          ),
          history: [
            for (var m = 0; m < 120; m++) ...[
              MoneyIn(
                id: '$id-in$m',
                investmentId: id,
                date: day(2016, 1 + m, 5),
                amount: Money(d('100'), unit),
              ),
              ValueUpdate(
                id: '$id-v$m',
                investmentId: id,
                date: day(2016, 1 + m, 28),
                value: d('${1000 + m * 90}'),
              ),
            ],
          ],
        ),
      );
    }
    for (final s in stored) {
      await repo.create(s.investment, s.history);
    }
    final today = day(2026, 1, 15);
    final rates = [
      for (var k = 0; k < 2000; k++)
        Rate(
          id: 'r$k',
          from: usd,
          to: egp,
          rate: d('${15 + k ~/ 100}.5'),
          asOf: day(2016, 1, 1).add(Duration(days: k * 2)),
        ),
    ];
    final loaded = await all();
    expect(loaded.fold<int>(0, (n, e) => n + e.history.length), 12000);

    final watch = Stopwatch()..start();
    final calc = PortfolioCalculator(
      items: loaded,
      rates: RateBook(rates),
      inflation: InflationBook(const ShippedInflation(series: {}), const []),
      settings: const Settings(baseCurrency: egp, zakatYear: ZakatYear.lunar),
      noZakatYears: const {},
      today: today,
    );
    final months = periodsBetween(
      today.subtract(const Duration(days: 365)),
      today,
      Granularity.month,
    );
    final years = periodsBetween(day(2016, 1, 1), today, Granularity.year);
    for (final p in [...months, ...years]) {
      calc.portfolio(p, ViewUnit.base);
    }
    watch.stop();
    expect(watch.elapsedMilliseconds, lessThan(200));
  });
}
