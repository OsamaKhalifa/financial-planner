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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
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
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
