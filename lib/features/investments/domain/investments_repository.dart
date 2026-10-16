/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import '../../../core/storage_exceptions.dart';
import 'history_entry.dart';
import 'investment.dart';

abstract interface class InvestmentsRepository {
  /// Emits again after every change; items are ordered by creation time and
  /// each history by date.
  Stream<List<InvestmentWithHistory>> watchAll();

  /// One transaction: the item and its first entries.
  Future<void> create(Investment item, List<HistoryEntry> initial);

  /// Throws [NotFound] for an unknown id.
  Future<void> update(Investment item);

  /// Deletes the item and its whole history. Throws [NotFound].
  Future<void> delete(String id);

  /// Undo after [delete]: puts the whole aggregate back.
  Future<void> restore(InvestmentWithHistory aggregate);

  /// Insert or replace by id, in one transaction. A second value update on the
  /// same item and day throws [Conflict]; an unknown item throws [NotFound].
  Future<void> saveEntries(List<HistoryEntry> entries);

  /// Throws [NotFound].
  Future<void> deleteEntry(String id);
}
