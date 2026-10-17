/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:drift/drift.dart';

import 'converters.dart';

@DataClassName('InvestmentRow')
class Investments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get assetType => text()();
  TextColumn get intent => text().nullable()();
  TextColumn get market => text().nullable()();
  TextColumn get marketCountry => text().nullable()();
  TextColumn get unit => text()();
  TextColumn get startDate => text().map(const CalendarDateConverter())();
  TextColumn get quantity => text().map(const DecimalConverter()).nullable()();
  IntColumn get purityKarat => integer().nullable()();
  IntColumn get purityFineness => integer().nullable()();
  TextColumn get zakatRule => text()();
  TextColumn get customZakatShare =>
      text().map(const DecimalConverter()).nullable()();
  TextColumn get inflationOverride => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// v2 (story §5.5, §5.6): the plan and the P-2/P-3 answers, all optional.
  TextColumn get payoutSchedule => text().nullable()();
  TextColumn get expectedProfit =>
      text().map(const DecimalConverter()).nullable()();
  TextColumn get valueCheckSchedule => text().nullable()();
  TextColumn get expectedGrowth =>
      text().map(const DecimalConverter()).nullable()();
  TextColumn get profitBasis => text().nullable()();
  TextColumn get capitalBack => text().nullable()();
  TextColumn get accountKind => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HistoryEntryRow')
@TableIndex(name: 'history_by_investment_date', columns: {#investmentId, #date})
// One value update per item and day; flows and interest may repeat.
@TableIndex.sql(
  'CREATE UNIQUE INDEX history_one_value_update_per_day '
  'ON history_entries (investment_id, date) '
  "WHERE kind = 'value_update'",
)
// One decision per pending row: a second Skip on it throws Conflict.
@TableIndex.sql(
  'CREATE UNIQUE INDEX history_one_skip_per_plan_date '
  'ON history_entries (investment_id, kind, date) '
  "WHERE kind IN ('payout_skipped', 'value_skipped')",
)
class HistoryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get investmentId =>
      text().references(Investments, #id, onDelete: KeyAction.cascade)();

  /// money_in, sale, income, interest_*, value_update, *_skipped
  TextColumn get kind => text()();
  TextColumn get date => text().map(const CalendarDateConverter())();

  /// For value_update: the value in the item unit.
  TextColumn get amount => text().map(const DecimalConverter())();

  /// Null for value_update.
  TextColumn get unit => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RateRow')
@TableIndex(name: 'rates_by_pair', columns: {#fromUnit, #toUnit, #asOf})
class Rates extends Table {
  TextColumn get id => text()();
  TextColumn get fromUnit => text()();
  TextColumn get toUnit => text()();
  TextColumn get rate => text().map(const DecimalConverter())();
  TextColumn get asOf => text().map(const CalendarDateConverter())();

  /// typed or currencyApi
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  /// One typed and one fetched rate per pair and day (AC-28).
  @override
  List<Set<Column>> get uniqueKeys => [
    {fromUnit, toUnit, asOf, source},
  ];
}

@DataClassName('InflationOverrideRow')
class InflationOverrides extends Table {
  TextColumn get id => text()();
  TextColumn get country => text()();
  IntColumn get year => integer()();
  TextColumn get rate => text().map(const DecimalConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {country, year},
  ];
}

/// Singleton row, id = 'settings'.
@DataClassName('SettingsRow')
class AppSettings extends Table {
  @override
  String get tableName => 'settings';

  TextColumn get id => text()();
  TextColumn get baseCurrency => text().nullable()();
  TextColumn get homeInflation => text().nullable()();
  TextColumn get zakatYear => text().nullable()();
  TextColumn get longTermMethod => text().nullable()();
  BoolColumn get jewelleryZakatable => boolean().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NoZakatYearRow')
class NoZakatYears extends Table {
  TextColumn get id => text()();
  IntColumn get year => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {year},
  ];
}
