/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../core/assumptions/domain/inflation.dart';
import '../../core/assumptions/domain/rate.dart';
import '../../core/assumptions/domain/settings.dart';
import '../../core/reference/countries.dart';
import '../../core/reference/markets.dart';
import '../../core/reference/units.dart';
import '../../l10n/app_localizations.dart';
import '../investments/domain/history_entry.dart';
import '../investments/domain/investment.dart';
import '../investments/domain/portfolio_calculator.dart';
import '../investments/presentation/widgets/labels.dart';

enum ExportMode { full, snapshot }

/// A fraction the sheet shows as a percent: 0.05 is 5%.
final class Percent {
  const Percent(this.fraction);

  final Decimal fraction;
}

/// A cell is a [String] (always text), a [Decimal] or [int] (number), a
/// [Percent], a [DateTime] (a calendar day when it is UTC midnight, else a
/// local time to the minute), or null (empty).
final class SheetTab {
  const SheetTab(this.title, this.header, this.rows);

  final String title;
  final List<String> header;
  final List<List<Object?>> rows;
}

final class ExportData {
  const ExportData({
    required this.items,
    required this.rates,
    required this.inflationOverrides,
    required this.settings,
    required this.noZakatYears,
    this.calculator,
  });

  final List<InvestmentWithHistory> items;
  final List<Rate> rates;
  final List<InflationOverride> inflationOverrides;
  final Settings settings;
  final Set<int> noZakatYears;

  /// Null before setup is done; the snapshot's figures are then empty.
  final PortfolioCalculator? calculator;
}

/// Human-readable tabs: names instead of ids, dates as yyyy-MM-dd, enums in
/// words. Ids stay in the last column so rows can be matched later.
List<SheetTab> exportTables(
  ExportData d,
  ExportMode mode,
  AppLocalizations l10n,
) {
  final full = mode == ExportMode.full;
  return [
    _investments(d, l10n, withFigures: !full),
    if (full) _history(d, l10n),
    _rates(full ? d.rates : _latestRates(d.rates)),
    _inflationOverrides(d.inflationOverrides, l10n),
    _settings(d.settings, l10n),
    SheetTab(
      'No-zakat years',
      const ['Year'],
      [
        for (final y in d.noZakatYears.toList()..sort()) [y],
      ],
    ),
  ];
}

SheetTab _investments(
  ExportData d,
  AppLocalizations l10n, {
  required bool withFigures,
}) {
  final base = d.settings.baseCurrency?.code ?? 'base';
  return SheetTab(
    'Investments',
    [
      'Name',
      'Type',
      'Intent',
      'Market',
      'Market country',
      'Unit',
      'Start date',
      'Quantity',
      'Purity (karat)',
      'Purity (fineness)',
      'Zakat rule',
      'Custom zakat share',
      'Inflation country',
      'Payout schedule',
      'Expected profit / year',
      'Value check schedule',
      'Expected growth / year',
      'Profit basis',
      'Capital back',
      'Account kind',
      'Notes',
      if (withFigures) ...[
        'Last value',
        'Last value date',
        'Value in $base',
        'Gain',
        'Gain in $base',
        'ROI',
        'ROI in $base',
        'Annualised',
        'Annualised in $base',
      ],
      'Created',
      'Updated',
      'Id',
    ],
    [
      for (final h in d.items)
        [
          ..._stored(h.investment, l10n),
          if (withFigures) ..._figures(h.investment.id, d.calculator),
          (h.investment.createdAt),
          (h.investment.updatedAt),
          h.investment.id,
        ],
    ],
  );
}

List<Object?> _stored(Investment i, AppLocalizations l10n) => [
  i.name,
  l10n.assetTypeName(i.type),
  i.intent == null ? null : l10n.intentName(i.intent!),
  i.market == null ? null : _market(i.market!, l10n),
  _country(i.marketCountry, l10n),
  i.unit.code,
  (i.startDate),
  i.quantity,
  i.purityKarat,
  i.purityFineness,
  words(i.zakatRule),
  _percent(i.customZakatShare),
  _country(i.inflationOverride, l10n),
  _words(i.payoutSchedule),
  _percent(i.expectedProfit),
  _words(i.valueCheckSchedule),
  _percent(i.expectedGrowth),
  _words(i.profitBasis),
  _words(i.capitalBack),
  _words(i.accountKind),
  i.notes,
];

List<Object?> _figures(String id, PortfolioCalculator? calc) {
  if (calc == null || !calc.hasItem(id)) return List.filled(9, null);
  final s = calc.sinceStart(id);
  final end = s.figures.period.e;
  return [
    calc.timeline(id).netValueAt(end),
    (end),
    s.figures.base?.dietz.ev,
    s.gain,
    s.gainBase,
    _percent(s.simpleRoi),
    _percent(s.simpleRoiBase),
    _percent(s.annualised),
    _percent(s.annualisedBase),
  ];
}

SheetTab _history(ExportData d, AppLocalizations l10n) => SheetTab(
  'History',
  const ['Item', 'Date', 'Kind', 'Amount', 'Unit', 'Created', 'Updated', 'Id'],
  [
    for (final h in d.items)
      for (final e in h.history)
        [
          h.investment.name,
          (e.date),
          _kind(e, l10n),
          ...switch (e) {
            MoneyIn(:final amount) ||
            MoneyOut(:final amount) ||
            InterestRecord(:final amount) => [amount.amount, amount.unit.code],
            ValueUpdate(:final value) => [value, h.investment.unit.code],
            PlanSkip() => [null, null],
          },
          (e.createdAt),
          (e.updatedAt),
          e.id,
        ],
  ],
);

String _kind(HistoryEntry e, AppLocalizations l10n) => switch (e) {
  MoneyIn() => l10n.kindMoneyIn,
  MoneyOut(kind: MoneyOutKind.sale) => l10n.kindSale,
  MoneyOut() => l10n.kindIncome,
  InterestRecord(:final kind) => switch (kind) {
    InterestKind.keptInside => l10n.kindInterestKept,
    InterestKind.paidOut => l10n.kindInterestPaid,
    InterestKind.givenAwayFromInside => l10n.kindGivenInside,
    InterestKind.givenAwayFromPaidOut => l10n.kindGivenPaid,
  },
  ValueUpdate() => l10n.kindValue,
  PlanSkip(:final plan) => '${l10n.kindSkipped} (${words(plan)})',
};

SheetTab _rates(List<Rate> rates) => SheetTab(
  'Rates',
  const ['From', 'To', 'Rate', 'As of', 'Source', 'Created', 'Updated', 'Id'],
  [
    for (final r in rates)
      [
        r.from.code,
        r.to.code,
        r.rate,
        (r.asOf),
        words(r.source),
        (r.createdAt),
        (r.updatedAt),
        r.id,
      ],
  ],
);

/// The newest rate per pair and source; a typed and a fetched rate can
/// differ, so both stay.
List<Rate> _latestRates(List<Rate> rates) {
  final latest = <(Unit, Unit, RateSource), Rate>{};
  for (final r in rates) {
    final key = (r.from, r.to, r.source);
    final seen = latest[key];
    if (seen == null || r.asOf.isAfter(seen.asOf)) latest[key] = r;
  }
  return latest.values.toList();
}

SheetTab _inflationOverrides(
  List<InflationOverride> overrides,
  AppLocalizations l10n,
) => SheetTab(
  'Inflation overrides',
  const ['Country', 'Year', 'Rate', 'Created', 'Updated', 'Id'],
  [
    for (final o in overrides)
      [
        _country(o.country, l10n),
        o.year,
        Percent(o.rate),
        (o.createdAt),
        (o.updatedAt),
        o.id,
      ],
  ],
);

SheetTab _settings(Settings s, AppLocalizations l10n) => SheetTab(
  'Settings',
  const [
    'Base currency',
    'Home inflation',
    'Zakat year',
    'Long-term method',
    'Jewellery zakatable',
  ],
  [
    [
      s.baseCurrency?.code,
      _country(s.homeCountry, l10n),
      _words(s.zakatYear),
      _words(s.longTermMethod),
      switch (s.jewelleryZakatable) {
        null => null,
        true => 'Yes',
        false => 'No',
      },
    ],
  ],
);

String _market(Market m, AppLocalizations l10n) =>
    l10n.marketName(m == Market.other ? 'otherMarket' : m.name);

String? _country(Country? c, AppLocalizations l10n) =>
    c == null ? null : l10n.countryName(c.iso3);

Percent? _percent(Decimal? fraction) =>
    fraction == null ? null : Percent(fraction);

String? _words(Enum? e) => e == null ? null : words(e);

/// `longTermProxy25` → `Long term proxy 25`.
String words(Enum e) {
  final spaced = e.name
      .replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z0-9])'), (_) => ' ')
      .toLowerCase();
  return spaced[0].toUpperCase() + spaced.substring(1);
}
