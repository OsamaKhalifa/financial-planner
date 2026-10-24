/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import 'app_database.steps.dart';
import 'converters.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Investments,
    HistoryEntries,
    Rates,
    InflationOverrides,
    AppSettings,
    NoZakatYears,
    ZakatCycles,
    ZakatYears,
    ZakatExtraLines,
    ZakatFrozenLines,
    ZakatGifts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      // stepByStep does not open a transaction: a failed step must leave v1.
      from1To2: (m, schema) => transaction(() async {
        final i = schema.investments;
        for (final c in [
          i.payoutSchedule,
          i.expectedProfit,
          i.valueCheckSchedule,
          i.expectedGrowth,
          i.profitBasis,
          i.capitalBack,
          i.accountKind,
        ]) {
          await m.addColumn(i, c);
        }
        // Real v1 files have this index; the v1 schema dump does not, because
        // v1 made it by hand. IF NOT EXISTS covers both.
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS history_one_value_update_per_day '
          'ON history_entries (investment_id, date) '
          "WHERE kind = 'value_update'",
        );
        await m.create(schema.historyOneSkipPerPlanDate);
      }),
      from2To3: (m, schema) => transaction(() async {
        final s = schema.settings;
        for (final c in [
          s.nisabMetal,
          s.reminderOn,
          s.reminderDays,
          s.reminderMinute,
          s.reminderAsked,
          s.givingRateView,
        ]) {
          await m.addColumn(s, c);
        }
        await m.create(schema.zakatCycles);
        await m.create(schema.zakatYears);
        await m.create(schema.zakatExtraLines);
        await m.create(schema.zakatFrozenLines);
        await m.create(schema.zakatGifts);
        await m.create(schema.zakatExtraLinesByYear);
        await m.create(schema.zakatFrozenLinesByYear);
        await m.create(schema.zakatGiftsByYearDate);
      }),
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
