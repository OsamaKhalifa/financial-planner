/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

/// The DB file lives only in the app sandbox (never in the repo). Tests
/// override this with `AppDatabase(NativeDatabase.memory())`.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(
    driftDatabase(
      name: 'financial_planner',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    ),
  );
  ref.onDispose(db.close);
  return db;
});
