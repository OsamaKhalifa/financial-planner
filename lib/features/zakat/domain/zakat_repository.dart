/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import 'zakat_year.dart';

/// Stores what the user decided about each zakat year (ADR-0001). A year is
/// keyed by its computed due date (Z4). Writes to a frozen year throw
/// `Conflict`.
abstract interface class ZakatRepository {
  Stream<List<ZakatYearRecord>> watchYears();

  Future<void> saveYear(
    DateTime key, {
    DateTime? movedDue,
    required Decimal debts,
    required bool deductDebts,
  });

  Future<void> saveExtraLine(DateTime key, ExtraLine line);

  Future<void> deleteExtraLine(String id);

  /// Start or recompute: one transaction; gifts are untouched.
  Future<void> freeze(DateTime key, FrozenYear f);

  /// Undo of a start; `Conflict` if the year has a gift (Z15).
  Future<void> unfreeze(DateTime key);

  /// `Conflict` if the year is not frozen (AC-26).
  Future<void> saveGift(DateTime key, Gift g);

  Future<void> deleteGift(String id);
}
