/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import '../../reference/countries.dart';
import '../../storage_exceptions.dart';
import 'inflation.dart';
import 'rate.dart';
import 'settings.dart';

import 'package:decimal/decimal.dart';

abstract interface class AssumptionsRepository {
  Stream<List<Rate>> watchRates();

  /// Upsert on (from, to, asOf, typed); the stored id is kept.
  Future<void> saveTypedRate(Rate rate);

  /// One transaction. Skips a rate whose (from, to, asOf, currencyApi) exists
  /// and returns how many were inserted.
  Future<int> saveFetchedRates(List<Rate> rates);

  /// Throws [NotFound].
  Future<void> deleteRate(String id);

  Stream<List<InflationOverride>> watchInflationOverrides();

  Future<void> setInflationOverride(Country c, int year, Decimal rate);

  Future<void> clearInflationOverride(Country c, int year);

  /// An empty store emits `Settings()` (nothing answered yet).
  Stream<Settings> watchSettings();

  Future<void> saveSettings(Settings s);

  Stream<Set<int>> watchNoZakatYears();

  Future<void> setNoZakatYear(int year, {required bool noZakat});
}
