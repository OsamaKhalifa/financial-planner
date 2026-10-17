/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:drift/drift.dart';

import '../storage_exceptions.dart';

/// Maps SQLite failures to the domain's storage exceptions.
Future<T> guardStorage<T>(Future<T> Function() body) async {
  try {
    return await body();
  } on StorageException {
    rethrow;
  } on Exception catch (e) {
    // SqliteException (package:sqlite3) is not a direct dependency; its text
    // names the failed constraint.
    final cause = '${e is DriftWrappedException ? e.cause : e}';
    if (cause.contains('UNIQUE constraint')) throw Conflict(cause);
    if (cause.contains('FOREIGN KEY constraint')) throw NotFound(cause);
    throw StorageUnavailable(cause);
  }
}
