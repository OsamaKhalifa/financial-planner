/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // One value update per item and day; flows and interest may repeat.
      await customStatement(
        'CREATE UNIQUE INDEX history_one_value_update_per_day '
        'ON history_entries (investment_id, date) '
        "WHERE kind = 'value_update'",
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
