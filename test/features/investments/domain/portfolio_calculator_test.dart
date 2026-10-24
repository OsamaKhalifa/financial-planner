/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/period.dart';
import 'package:financial_planner/features/investments/domain/portfolio_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/figures_view.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
Decimal d(String s) => Decimal.parse(s);
final today = day(2026, 10, 16);

PortfolioCalculator calc(
  List<InvestmentWithHistory> items, {
  List<Rate> rates = const [],
  Set<int> noZakatYears = const {},
  DateTime? now,
}) => PortfolioCalculator(
  items: items,
  rates: RateBook(rates),
  inflation: InflationBook(const ShippedInflation(series: {}), const []),
  settings: const Settings(baseCurrency: egp, zakatYear: ZakatYear.lunar),
  noZakatYears: noZakatYears,
  today: now ?? today,
);

InvestmentWithHistory fund(
  String id,
  Unit unit,
  DateTime start,
  String paid, {
  String? value,
  DateTime? valueOn,
  List<HistoryEntry> more = const [],
}) => InvestmentWithHistory(
  investment: Investment(
    id: id,
    name: id,
    type: AssetType.fund,
    unit: unit,
    startDate: start,
    zakatRule: ZakatRule.trading100,
  ),
  history: [
    MoneyIn(investmentId: id, date: start, amount: Money(d(paid), unit)),
    if (value != null)
      ValueUpdate(investmentId: id, date: valueOn!, value: d(value)),
    ...more,
  ],
);

void main() {
  test('without a rate the item is excluded from base totals but keeps its own-unit figures', () {
    final c = calc([
      fund(
        'us',
        usd,
        day(2026, 1, 1),
        '1000',
        value: '1100',
        valueOn: day(2026, 4, 30),
      ),
    ]);
    final p = c.portfolio(Period.month(2026, 4, today), ViewUnit.base);
    final ex = p.excluded.single;
    expect(
      (ex.itemId, ex.from, ex.to, ex.date),
      ('us', usd, egp, day(2026, 4, 30)),
    );
    expect(p.dietz.ev, Decimal.zero);
    expect(p.items.single.unitDietz.ev, d('1100'));
    expect(p.items.single.base, isNull);
  });

  test('an item not yet started or already closed is not part of a period', () {
    final c = calc([
      fund('late', egp, day(2026, 6, 1), '100'),
      fund(
        'gone',
        egp,
        day(2026, 1, 1),
        '100',
        value: '0',
        valueOn: day(2026, 2, 1),
      ),
    ]);
    final p = c.portfolio(Period.month(2026, 4, today), ViewUnit.base);
    expect(p.items, isEmpty);
    expect(p.staleValues, isEmpty);
  });

  test(
    'inflation is optional: no series means no real figures, return stays',
    () {
      final c = calc([
        fund(
          'a',
          egp,
          day(2026, 1, 1),
          '1000',
          value: '1100',
          valueOn: day(2026, 12, 31),
        ),
      ]);
      final f = c.item('a', Period.year(2026, day(2027, 1, 1)));
      expect(f.dietz.r, isNotNull);
      expect(f.inflation, isNull);
      expect(f.realBeforeZakat, isNull);
      expect(f.purchasingPower, isNull);
    },
  );

  test('since start: days in a no-zakat year are not charged (Q-3)', () {
    final item = fund(
      'a',
      egp,
      day(2025, 1, 1),
      '10000',
      value: '10000',
      valueOn: day(2026, 12, 31),
      more: [
        MoneyOut(
          investmentId: 'a',
          date: day(2026, 6, 1),
          amount: Money(d('100'), egp),
          kind: MoneyOutKind.income,
        ),
      ],
    );
    final all = calc([
      item,
    ], now: day(2027, 1, 1)).sinceStart('a').figures.setAside;
    final skip2026 = calc(
      [item],
      noZakatYears: {2026},
      now: day(2027, 1, 1),
    ).sinceStart('a').figures.setAside;
    // 729 days held (2025-01-01 to 2026-12-31), 365 of them in 2026.
    final expected = all * d('364') / d('729');
    expect(
      (skip2026 - expected.toDecimal(scaleOnInfinitePrecision: 10)).abs() <
          d('0.001'),
      isTrue,
    );
  });

  test('dividends-only income in a no-zakat year is not charged', () {
    final inv = Investment(
      id: 'dv',
      name: 'dv',
      type: AssetType.stock,
      unit: egp,
      startDate: day(2025, 12, 31),
      zakatRule: ZakatRule.longTermDividendsOnly,
    );
    final item = InvestmentWithHistory(
      investment: inv,
      history: [
        MoneyIn(
          investmentId: 'dv',
          date: day(2025, 12, 31),
          amount: Money(d('1000'), egp),
        ),
        MoneyOut(
          investmentId: 'dv',
          date: day(2026, 3, 1),
          amount: Money(d('400'), egp),
          kind: MoneyOutKind.income,
        ),
      ],
    );
    final period = Period.year(2026, day(2027, 1, 1));
    expect(
      calc([item], now: day(2027, 1, 1)).item('dv', period).setAside,
      d('10'),
    );
    expect(
      calc(
        [item],
        noZakatYears: {2026},
        now: day(2027, 1, 1),
      ).item('dv', period).setAside,
      Decimal.zero,
    );
  });

  test(
    'a dividend in another currency is charged at the rate of its own date',
    () {
      final inv = Investment(
        id: 'dv',
        name: 'dv',
        type: AssetType.stock,
        unit: usd,
        startDate: day(2025, 12, 31),
        zakatRule: ZakatRule.longTermDividendsOnly,
      );
      final item = InvestmentWithHistory(
        investment: inv,
        history: [
          MoneyIn(
            investmentId: 'dv',
            date: day(2025, 12, 31),
            amount: Money(d('1000'), usd),
          ),
          MoneyOut(
            investmentId: 'dv',
            date: day(2026, 3, 1),
            amount: Money(d('100'), usd),
            kind: MoneyOutKind.income,
          ),
        ],
      );
      final rates = [
        Rate(from: usd, to: egp, rate: d('50'), asOf: day(2025, 12, 31)),
        Rate(from: usd, to: egp, rate: d('40'), asOf: day(2026, 3, 1)),
        Rate(from: usd, to: egp, rate: d('60'), asOf: day(2026, 12, 31)),
      ];
      final f = calc(
        [item],
        rates: rates,
        now: day(2027, 1, 1),
      ).item('dv', Period.year(2026, day(2027, 1, 1)));
      expect(f.setAside, d('100') * d('40') * d('0.025'));
    },
  );

  group('stale now (calendar month of today)', () {
    test('lists open items without activity and rate pairs without an entry this month', () {
      final c = calc(
        [
          fund('quiet', egp, day(2026, 1, 1), '100'),
          fund(
            'busy',
            egp,
            day(2026, 1, 1),
            '100',
            value: '110',
            valueOn: day(2026, 10, 3),
          ),
          fund(
            'us',
            usd,
            day(2026, 1, 1),
            '100',
            value: '110',
            valueOn: day(2026, 10, 3),
          ),
          fund(
            'closed',
            egp,
            day(2026, 1, 1),
            '100',
            value: '0',
            valueOn: day(2026, 2, 1),
          ),
        ],
        rates: [
          Rate(from: usd, to: egp, rate: d('50'), asOf: day(2026, 9, 30)),
        ],
      );
      final s = c.staleNow();
      expect(s.itemIds, ['quiet']);
      expect(s.ratePairs, [(usd, egp)]);
    });

    test('a metal item is fresh when its rate was updated this month', () {
      final gold = InvestmentWithHistory(
        investment: Investment(
          id: 'g',
          name: 'g',
          type: AssetType.gold,
          unit: xauG,
          startDate: day(2026, 1, 1),
          zakatRule: ZakatRule.bullion100,
        ),
        history: [
          ValueUpdate(investmentId: 'g', date: day(2026, 1, 1), value: d('10')),
        ],
      );
      final c = calc(
        [gold],
        rates: [
          Rate(from: xauG, to: egp, rate: d('5000'), asOf: day(2026, 10, 2)),
        ],
      );
      expect(c.staleNow().itemIds, isEmpty);
      expect(c.staleNow().ratePairs, isEmpty);
    });
  });

  test('unitUsage counts open and closed items by item unit', () {
    final c = calc([
      fund('a', usd, day(2026, 1, 1), '1'),
      fund(
        'b',
        usd,
        day(2026, 1, 1),
        '1',
        value: '0',
        valueOn: day(2026, 2, 1),
      ),
      fund('c', egp, day(2026, 1, 1), '1'),
    ]);
    expect(c.unitUsage(), {usd: 2, egp: 1});
  });

  test('a metal rate that is missing makes the grams view unavailable and names the pair', () {
    final c = calc([
      fund(
        'a',
        egp,
        day(2026, 1, 1),
        '1000',
        value: '1100',
        valueOn: day(2026, 4, 30),
      ),
    ]);
    final p = c.portfolio(Period.month(2026, 4, today), ViewUnit.goldGrams);
    expect(p.totals, isNull);
    expect((p.unavailable!.from, p.unavailable!.to), (egp, xauG));
  });

  group('bug trail from the phase 1 review', () {
    InvestmentWithHistory goldItem(List<HistoryEntry> history) =>
        InvestmentWithHistory(
          investment: Investment(
            id: 'g',
            name: 'g',
            type: AssetType.gold,
            intent: Intent.longTerm,
            unit: xauG,
            startDate: day(2026, 3, 1),
            purityKarat: 24,
            zakatRule: ZakatRule.bullion100,
          ),
          history: history,
        );

    test('since-start return of a gold item bought above the market uses money in as its start value (-3.85 %)', () {
      final g = goldItem([
        MoneyIn(
          investmentId: 'g',
          date: day(2026, 3, 1),
          amount: Money(d('52000'), egp),
        ),
        ValueUpdate(investmentId: 'g', date: day(2026, 3, 1), value: d('10')),
      ]);
      const id = 'g';
      final s = calc(
        [g],
        rates: [
          Rate(from: xauG, to: egp, rate: d('5000'), asOf: day(2026, 3, 1)),
        ],
      ).sinceStart(id);
      expect(
        ((s.sinceStartReturn ?? Decimal.zero) * d('100') - d('-3.85')).abs() <=
            d('0.005'),
        isTrue,
        reason: 'got ${s.sinceStartReturn}',
      );
    });

    test('since-start of a gold item moves to a newer gold rate even without a value update', () {
      final g = goldItem([
        MoneyIn(
          investmentId: 'g',
          date: day(2026, 3, 1),
          amount: Money(d('50000'), egp),
        ),
        ValueUpdate(investmentId: 'g', date: day(2026, 3, 1), value: d('10')),
      ]);
      const id = 'g';
      final s = calc(
        [g],
        rates: [
          Rate(from: xauG, to: egp, rate: d('5000'), asOf: day(2026, 3, 1)),
          Rate(from: xauG, to: egp, rate: d('6000'), asOf: day(2026, 6, 1)),
        ],
      ).sinceStart(id);
      expect(s.days, 92);
      expect(
        ((s.simpleRoiBase ?? Decimal.zero) * d('100') - d('20')).abs() <=
            d('0.005'),
        isTrue,
        reason: 'got ${s.simpleRoiBase}',
      );
    });

    test('an item with a future flow that lacks a rate is not excluded from an earlier period', () {
      final f = fund(
        'a',
        egp,
        day(2026, 1, 1),
        '1000',
        more: [
          MoneyIn(
            investmentId: 'a',
            date: day(2026, 9, 1),
            amount: Money(d('100'), usd),
          ),
        ],
      );
      final p = calc([f])
          .portfolio(Period.month(2026, 4, today), ViewUnit.base);
      expect(p.excluded, isEmpty);
      expect(p.dietz.ev, d('1000'));
    });

    test('computing figures with no zakat year answered throws instead of defaulting to lunar', () {
      final f = fund(
        'a',
        egp,
        day(2026, 1, 1),
        '1000',
        value: '1100',
        valueOn: day(2026, 4, 30),
      );
      expect(
        () => PortfolioCalculator(
          items: [f],
          rates: RateBook(const []),
          inflation: InflationBook(
            const ShippedInflation(series: {}),
            const [],
          ),
          settings: const Settings(baseCurrency: egp),
          noZakatYears: const {},
          today: today,
        ).item(f.investment.id, Period.month(2026, 4, today)),
        throwsStateError,
      );
    });
  });

  group('Overview figures (UC-2)', () {
    InvestmentWithHistory held(
      String id,
      AssetType type,
      String paid,
      String value, {
      Unit unit = egp,
      ZakatRule rule = ZakatRule.trading100,
      ProfitBasis? basis,
      String? profit,
      CapitalBack? back,
    }) => InvestmentWithHistory(
      investment: Investment(
        id: id,
        name: id,
        type: type,
        unit: unit,
        startDate: day(2026, 1, 1),
        zakatRule: rule,
        profitBasis: basis,
        expectedProfit: profit == null ? null : d(profit),
        capitalBack: back,
      ),
      history: [
        MoneyIn(
          investmentId: id,
          date: day(2026, 1, 1),
          amount: Money(d(paid), unit),
        ),
        ValueUpdate(investmentId: id, date: day(2026, 10, 1), value: d(value)),
      ],
    );
    final year = Period.year(2026, today);

    test('by type: value and share per type, largest first, adding up to the total', () {
      final c = calc([
        held('s', AssetType.stock, '50000', '60000'),
        held(
          'c',
          AssetType.cashDeposit,
          '40000',
          '40000',
          rule: ZakatRule.cash100,
        ),
      ]);
      final slices = c.byType(year);
      expect(
        [for (final s in slices) (s.key, s.value, s.share)],
        [
          (AssetType.stock, d('60000'), d('0.6')),
          (AssetType.cashDeposit, d('40000'), d('0.4')),
        ],
      );
      expect(
        slices.fold(Decimal.zero, (a, s) => a + s.value),
        c.portfolio(year, ViewUnit.base).totals!.dietz.ev,
      );
    });

    test('by type leaves out an item with no rate, as the total does', () {
      final c = calc([
        held('s', AssetType.stock, '1000', '1000'),
        held('us', AssetType.fund, '10', '12', unit: usd),
      ]);
      expect([for (final s in c.byType(year)) s.key], [AssetType.stock]);
    });

    test('since start: gain over money paid in; an item with no rate is counted out', () {
      final c = calc([
        held('a', AssetType.fund, '1000', '1100'),
        held('b', AssetType.fund, '1000', '1300'),
        held('us', AssetType.fund, '10', '12', unit: usd),
      ]);
      final s = c.sinceStartTotal();
      expect((s.gain, s.roi, s.excluded), (d('400'), d('0.2'), 1));
    });

    test('exposure: Shariah-risk items and crypto, nothing else', () {
      final c = calc([
        held(
          'pe',
          AssetType.privateEquity,
          '5000',
          '5000',
          rule: ZakatRule.longTermFullValue,
          basis: ProfitBasis.fixedPctOfMoney,
          profit: '0.2',
          back: CapitalBack.no,
        ),
        held(
          'btc',
          AssetType.crypto,
          '3000',
          '2500',
          rule: ZakatRule.crypto100,
        ),
        held('s', AssetType.stock, '1000', '1000'),
      ]);
      final e = c.exposure(year);
      expect((e.shariahRisk, e.crypto), (d('5000'), d('2500')));
    });

    test('by currency: value in base per item currency, largest first', () {
      final c = calc(
        [
          held('e', AssetType.stock, '6000', '6000'),
          held('us', AssetType.fund, '80', '80', unit: usd),
        ],
        rates: [
          Rate(from: usd, to: egp, rate: d('50'), asOf: day(2025, 12, 31)),
        ],
      );
      expect(
        [for (final s in c.byCurrency(year)) (s.key, s.value, s.share)],
        [(egp, d('6000'), d('0.6')), (usd, d('4000'), d('0.4'))],
      );
    });

    group('monthly', () {
      final c = calc([
        fund(
          'a',
          egp,
          day(2026, 8, 10),
          '1000',
          value: '1100',
          valueOn: day(2026, 8, 31),
          more: [
            MoneyIn(
              investmentId: 'a',
              date: day(2026, 9, 15),
              amount: Money(d('500'), egp),
            ),
            ValueUpdate(
              investmentId: 'a',
              date: day(2026, 9, 30),
              value: d('1700'),
            ),
            ValueUpdate(
              investmentId: 'a',
              date: day(2026, 10, 10),
              value: d('1800'),
            ),
          ],
        ),
      ]);

      test(
        'one point per month from the first item, the last one ends today',
        () {
          final m = c.monthly();
          expect(
            [for (final x in m) x.period.e],
            [day(2026, 8, 31), day(2026, 9, 30), today],
          );
        },
      );

      test(
        'value, return and set-aside return equal the month portfolio figures',
        () {
          for (final x in c.monthly()) {
            final t = c.portfolio(x.period, ViewUnit.base).totals!;
            expect((x.value, x.r, x.rz), (t.dietz.ev, t.dietz.r, t.rz));
          }
          expect(c.monthly().map((x) => x.value), [
            d('1100'),
            d('1700'),
            d('1800'),
          ]);
        },
      );

      test('paid in steps up at a money-in and stays after', () {
        expect(c.monthly().map((x) => x.paidIn), [
          d('1000'),
          d('1500'),
          d('1500'),
        ]);
      });

      test('only the last months are returned', () {
        expect(c.monthly(months: 2).map((x) => x.period.e), [
          day(2026, 9, 30),
          today,
        ]);
      });

      test('no items, no points', () {
        expect(calc([]).monthly(), isEmpty);
      });

      test('an item with no rate is left out of value and paid in alike', () {
        final m = calc([
          fund(
            'e',
            egp,
            day(2026, 8, 10),
            '1000',
            value: '1000',
            valueOn: day(2026, 9, 1),
          ),
          fund(
            'us',
            usd,
            day(2026, 8, 10),
            '10',
            value: '12',
            valueOn: day(2026, 9, 1),
          ),
        ]).monthly();
        expect(m.last.value, d('1000'));
        expect(m.last.paidIn, d('1000'));
      });
    });
  });
}
