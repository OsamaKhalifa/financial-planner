/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/export/export_tables.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/portfolio_calculator.dart';
import 'package:financial_planner/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
Decimal d(String s) => Decimal.parse(s);
final today = day(2026, 10, 16);
const settings = Settings(baseCurrency: egp, zakatYear: ZakatYear.lunar);

final fundA = InvestmentWithHistory(
  investment: Investment(
    id: 'a',
    name: 'Fund A',
    type: AssetType.fund,
    intent: Intent.longTerm,
    unit: egp,
    startDate: day(2025, 1, 1),
    zakatRule: ZakatRule.longTermProxy25,
    notes: '=1/2',
  ),
  history: [
    MoneyIn(
      investmentId: 'a',
      date: day(2025, 1, 1),
      amount: Money(d('1000'), egp),
    ),
    MoneyOut(
      investmentId: 'a',
      date: day(2025, 6, 1),
      amount: Money(d('10'), egp),
      kind: MoneyOutKind.income,
    ),
    ValueUpdate(investmentId: 'a', date: day(2026, 4, 30), value: d('1100')),
    PlanSkip(investmentId: 'a', date: day(2026, 5, 1), plan: PlanKind.payout),
  ],
);

final rates = [
  Rate(id: 'r1', from: usd, to: egp, rate: d('48'), asOf: day(2026, 1, 1)),
  Rate(id: 'r2', from: usd, to: egp, rate: d('50'), asOf: day(2026, 3, 1)),
  Rate(
    id: 'r3',
    from: usd,
    to: egp,
    rate: d('49'),
    asOf: day(2026, 2, 1),
    source: RateSource.currencyApi,
  ),
];

ExportData data({PortfolioCalculator? calculator}) => ExportData(
  items: [fundA],
  rates: rates,
  inflationOverrides: [
    InflationOverride(
      id: 'i1',
      country: const Country('EGY'),
      year: 2025,
      rate: d('0.3'),
    ),
  ],
  settings: settings,
  noZakatYears: {2026, 2024},
  calculator: calculator,
);

PortfolioCalculator calculator() => PortfolioCalculator(
  items: [fundA],
  rates: RateBook(rates),
  inflation: InflationBook(const ShippedInflation(series: {}), const []),
  settings: settings,
  noZakatYears: const {},
  today: today,
);

SheetTab tab(List<SheetTab> tabs, String title) =>
    tabs.singleWhere((t) => t.title == title);

Map<String, Object?> row(SheetTab t, int i) => {
  for (var c = 0; c < t.header.length; c++) t.header[c]: t.rows[i][c],
};

void main() {
  final l10n = AppLocalizationsEn();

  test('every row has one cell per header', () {
    for (final mode in ExportMode.values) {
      for (final t in exportTables(
        data(calculator: calculator()),
        mode,
        l10n,
      )) {
        for (final r in t.rows) {
          expect(
            r,
            hasLength(t.header.length),
            reason: '${mode.name} ${t.title}',
          );
        }
      }
    }
  });

  test('full: every record, names and words instead of ids and codes', () {
    final tabs = exportTables(data(), ExportMode.full, l10n);
    expect(tabs.map((t) => t.title), [
      'Investments',
      'History',
      'Rates',
      'Inflation overrides',
      'Settings',
      'No-zakat years',
    ]);

    final inv = tab(tabs, 'Investments');
    expect(inv.header, isNot(contains('ROI')));
    expect(row(inv, 0), containsPair('Name', 'Fund A'));
    expect(row(inv, 0), containsPair('Type', 'Fund / ETF'));
    expect(row(inv, 0), containsPair('Intent', 'Long-term'));
    expect(row(inv, 0), containsPair('Zakat rule', 'Long term proxy 25'));
    expect(row(inv, 0), containsPair('Start date', day(2025, 1, 1)));
    expect(row(inv, 0), containsPair('Notes', '=1/2'));
    expect(inv.header.last, 'Id');
    expect(inv.rows.single.last, 'a');

    final history = tab(tabs, 'History');
    expect(
      [for (var i = 0; i < history.rows.length; i++) row(history, i)['Kind']],
      ['Money in', 'Income received', 'Value update', 'Skipped (Payout)'],
    );
    expect(row(history, 0), containsPair('Item', 'Fund A'));
    expect(row(history, 2), containsPair('Amount', d('1100')));
    expect(row(history, 2), containsPair('Unit', 'EGP'));
    expect(row(history, 3), containsPair('Amount', null));

    expect(tab(tabs, 'Rates').rows, hasLength(3));
    final override = row(tab(tabs, 'Inflation overrides'), 0);
    expect(override['Country'], 'Egypt');
    expect((override['Rate']! as Percent).fraction, d('0.3'));
    expect(tab(tabs, 'No-zakat years').rows, [
      [2024],
      [2026],
    ]);
    expect(row(tab(tabs, 'Settings'), 0), {
      'Base currency': 'EGP',
      'Home inflation': 'Egypt',
      'Zakat year': 'Lunar',
      'Long-term method': null,
      'Jewellery zakatable': null,
    });
  });

  test(
    'snapshot: no history, latest rate per pair and source, and figures',
    () {
      final tabs = exportTables(
        data(calculator: calculator()),
        ExportMode.snapshot,
        l10n,
      );
      expect(tabs.map((t) => t.title), isNot(contains('History')));
      expect(
        tab(tabs, 'Rates').rows.map((r) => r.last),
        unorderedEquals(['r2', 'r3']),
      );

      final item = row(tab(tabs, 'Investments'), 0);
      expect(item['Last value'], d('1100'));
      expect(item['Last value date'], day(2026, 4, 30));
      expect(item['Value in EGP'], d('1100'));
      // 1000 in, 10 income out, worth 1100: gain = 1100 − (1000 − 10).
      expect(item['Gain'], d('110'));
      expect(item['Gain in EGP'], d('110'));
      expect((item['ROI']! as Percent).fraction, d('0.11'));
      expect(item['Annualised'], isA<Percent>());
    },
  );

  test('snapshot before setup: the figure columns stay empty', () {
    final item = row(
      tab(exportTables(data(), ExportMode.snapshot, l10n), 'Investments'),
      0,
    );
    expect(item['Last value'], isNull);
    expect(item['ROI'], isNull);
    expect(item['Name'], 'Fund A');
  });

  test('words splits camelCase and digits', () {
    expect(words(ZakatRule.cash100), 'Cash 100');
    expect(words(ZakatRule.longTermDividendsOnly), 'Long term dividends only');
    expect(words(RateSource.currencyApi), 'Currency api');
  });
}
