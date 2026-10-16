/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import '../../db/app_database.dart';
import '../../db/storage_guard.dart';
import '../../ids.dart';
import '../../reference/countries.dart';
import '../../reference/units.dart';
import '../../storage_exceptions.dart';
import '../domain/assumptions_repository.dart';
import '../domain/inflation.dart';
import '../domain/rate.dart';
import '../domain/settings.dart';

const _settingsId = 'settings';

class DriftAssumptionsRepository implements AssumptionsRepository {
  DriftAssumptionsRepository(this._db, this._now);

  final AppDatabase _db;
  final DateTime Function() _now;

  @override
  Stream<List<Rate>> watchRates() =>
      (_db.select(_db.rates)..orderBy([
            (t) => OrderingTerm.asc(t.asOf),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
          .watch()
          .map((rows) => [for (final r in rows) _rateOf(r)]);

  @override
  Future<void> saveTypedRate(Rate rate) => guardStorage(() async {
    final t = _db.rates;
    final now = _now().toUtc();
    await _db
        .into(t)
        .insert(
          _rateRow(rate, now),
          onConflict: DoUpdate(
            (_) =>
                RatesCompanion(rate: Value(rate.rate), updatedAt: Value(now)),
            target: [t.fromUnit, t.toUnit, t.asOf, t.source],
          ),
        );
  });

  @override
  Future<int> saveFetchedRates(List<Rate> rates) => guardStorage(
    () => _db.transaction(() async {
      var inserted = 0;
      final now = _now().toUtc();
      for (final r in rates) {
        final exists =
            await (_db.select(_db.rates)..where(
                  (t) =>
                      t.fromUnit.equals(r.from.code) &
                      t.toUnit.equals(r.to.code) &
                      t.asOf.equalsValue(r.asOf) &
                      t.source.equals(RateSource.currencyApi.name),
                ))
                .getSingleOrNull();
        if (exists != null) continue;
        await _db.into(_db.rates).insert(_rateRow(r, now));
        inserted++;
      }
      return inserted;
    }),
  );

  @override
  Future<void> deleteRate(String id) => guardStorage(() async {
    final n = await (_db.delete(_db.rates)..where((t) => t.id.equals(id))).go();
    if (n == 0) throw NotFound('rate $id');
  });

  @override
  Stream<List<InflationOverride>> watchInflationOverrides() => _db
      .select(_db.inflationOverrides)
      .watch()
      .map(
        (rows) => [
          for (final r in rows)
            InflationOverride(
              id: r.id,
              country: Country(r.country),
              year: r.year,
              rate: r.rate,
              createdAt: r.createdAt.toUtc(),
              updatedAt: r.updatedAt.toUtc(),
            ),
        ],
      );

  @override
  Future<void> setInflationOverride(Country c, int year, Decimal rate) =>
      guardStorage(() async {
        final t = _db.inflationOverrides;
        final now = _now().toUtc();
        await _db
            .into(t)
            .insert(
              InflationOverridesCompanion(
                id: Value(newId()),
                country: Value(c.iso3),
                year: Value(year),
                rate: Value(rate),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
              onConflict: DoUpdate(
                (_) => InflationOverridesCompanion(
                  rate: Value(rate),
                  updatedAt: Value(now),
                ),
                target: [t.country, t.year],
              ),
            );
      });

  @override
  Future<void> clearInflationOverride(Country c, int year) => guardStorage(
    () => (_db.delete(
      _db.inflationOverrides,
    )..where((t) => t.country.equals(c.iso3) & t.year.equals(year))).go(),
  );

  @override
  Stream<Settings> watchSettings() =>
      (_db.select(_db.appSettings)..where((t) => t.id.equals(_settingsId)))
          .watchSingleOrNull()
          .map((r) => r == null ? const Settings() : _settingsOf(r));

  @override
  Future<void> saveSettings(Settings s) => guardStorage(() async {
    final now = _now().toUtc();
    AppSettingsCompanion row({required bool withCreated}) =>
        AppSettingsCompanion(
          id: const Value(_settingsId),
          baseCurrency: Value(s.baseCurrency?.code),
          homeInflation: Value(s.homeInflation?.iso3),
          zakatYear: Value(s.zakatYear?.name),
          longTermMethod: Value(s.longTermMethod?.name),
          jewelleryZakatable: Value(s.jewelleryZakatable),
          createdAt: withCreated ? Value(now) : const Value.absent(),
          updatedAt: Value(now),
        );
    await _db
        .into(_db.appSettings)
        .insert(
          row(withCreated: true),
          onConflict: DoUpdate(
            (_) => row(withCreated: false),
            target: [_db.appSettings.id],
          ),
        );
  });

  @override
  Stream<Set<int>> watchNoZakatYears() => _db
      .select(_db.noZakatYears)
      .watch()
      .map((rows) => {for (final r in rows) r.year});

  @override
  Future<void> setNoZakatYear(int year, {required bool noZakat}) =>
      guardStorage(() async {
        if (!noZakat) {
          await (_db.delete(
            _db.noZakatYears,
          )..where((t) => t.year.equals(year))).go();
          return;
        }
        final now = _now().toUtc();
        await _db
            .into(_db.noZakatYears)
            .insert(
              NoZakatYearsCompanion(
                id: Value(newId()),
                year: Value(year),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      });
}

RatesCompanion _rateRow(Rate r, DateTime now) => RatesCompanion(
  id: Value(r.id),
  fromUnit: Value(r.from.code),
  toUnit: Value(r.to.code),
  rate: Value(r.rate),
  asOf: Value(r.asOf),
  source: Value(r.source.name),
  createdAt: Value(now),
  updatedAt: Value(now),
);

Rate _rateOf(RateRow r) => Rate(
  id: r.id,
  from: Unit(r.fromUnit),
  to: Unit(r.toUnit),
  rate: r.rate,
  asOf: r.asOf,
  source: RateSource.values.byName(r.source),
  createdAt: r.createdAt.toUtc(),
  updatedAt: r.updatedAt.toUtc(),
);

Settings _settingsOf(SettingsRow r) => Settings(
  baseCurrency: r.baseCurrency == null ? null : Unit(r.baseCurrency!),
  homeInflation: r.homeInflation == null ? null : Country(r.homeInflation!),
  zakatYear: r.zakatYear == null ? null : ZakatYear.values.byName(r.zakatYear!),
  longTermMethod: r.longTermMethod == null
      ? null
      : LongTermMethod.values.byName(r.longTermMethod!),
  jewelleryZakatable: r.jewelleryZakatable,
);
