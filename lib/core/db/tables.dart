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

  /// v3 (zakat spec §2.1): the zakat preferences.
  TextColumn get nisabMetal => text().nullable()();
  BoolColumn get reminderOn => boolean().withDefault(const Constant(true))();
  IntColumn get reminderDays => integer().withDefault(const Constant(0))();
  IntColumn get reminderMinute => integer().withDefault(const Constant(540))();
  BoolColumn get reminderAsked =>
      boolean().withDefault(const Constant(false))();
  TextColumn get givingRateView => text().nullable()();
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

@DataClassName('ZakatCycleRow')
class ZakatCycles extends Table {
  TextColumn get id => text()();
  TextColumn get calendar => text()();
  IntColumn get month => integer()();
  IntColumn get day => integer()();
  TextColumn get fromDate => text().map(const CalendarDateConverter())();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {fromDate},
  ];
}

@DataClassName('ZakatYearRow')
class ZakatYears extends Table {
  TextColumn get id => text()();

  /// The computed due date (Z4); a moved due date never changes it.
  TextColumn get dueKey => text().map(const CalendarDateConverter())();
  TextColumn get movedDue =>
      text().map(const CalendarDateConverter()).nullable()();
  TextColumn get debts =>
      text().map(const DecimalConverter()).withDefault(const Constant('0'))();
  BoolColumn get deductDebts => boolean().withDefault(const Constant(true))();
  TextColumn get startedOn =>
      text().map(const CalendarDateConverter()).nullable()();
  TextColumn get frozenBase => text().nullable()();
  TextColumn get frozenNisabMetal => text().nullable()();
  TextColumn get frozenMetalRate =>
      text().map(const DecimalConverter()).nullable()();
  TextColumn get frozenMetalRateDate =>
      text().map(const CalendarDateConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {dueKey},
  ];
}

@DataClassName('ZakatExtraLineRow')
@TableIndex(name: 'zakat_extra_lines_by_year', columns: {#yearId})
class ZakatExtraLines extends Table {
  TextColumn get id => text()();
  TextColumn get yearId =>
      text().references(ZakatYears, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();

  /// cash or owedToMe
  TextColumn get kind => text()();
  TextColumn get amount => text().map(const DecimalConverter())();
  TextColumn get unit => text()();
  BoolColumn get goodDebtConfirmed => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ZakatFrozenLineRow')
@TableIndex(name: 'zakat_frozen_lines_by_year', columns: {#yearId, #position})
class ZakatFrozenLines extends Table {
  TextColumn get id => text()();
  TextColumn get yearId =>
      text().references(ZakatYears, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();

  /// item or extra
  TextColumn get source => text()();

  /// The investment or extra-line id.
  TextColumn get refId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  TextColumn get value => text().map(const DecimalConverter())();
  TextColumn get heldInterest => text().map(const DecimalConverter())();
  TextColumn get valueDate =>
      text().map(const CalendarDateConverter()).nullable()();
  TextColumn get rate => text().map(const DecimalConverter()).nullable()();
  TextColumn get rateDate =>
      text().map(const CalendarDateConverter()).nullable()();
  TextColumn get share => text().map(const DecimalConverter())();
  TextColumn get section => text()();
  TextColumn get notice => text().nullable()();
  TextColumn get extraKind => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ZakatGiftRow')
@TableIndex(name: 'zakat_gifts_by_year_date', columns: {#yearId, #date})
class ZakatGifts extends Table {
  TextColumn get id => text()();
  TextColumn get yearId =>
      text().references(ZakatYears, #id, onDelete: KeyAction.cascade)();
  TextColumn get date => text().map(const CalendarDateConverter())();
  TextColumn get amount => text().map(const DecimalConverter())();
  TextColumn get unit => text()();

  /// Rate, rate date and rate view are all null when the unit is the year base.
  TextColumn get rate => text().map(const DecimalConverter()).nullable()();
  TextColumn get rateDate =>
      text().map(const CalendarDateConverter()).nullable()();
  TextColumn get rateView => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
