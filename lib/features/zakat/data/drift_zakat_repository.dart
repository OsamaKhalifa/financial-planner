/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/storage_guard.dart';
import '../../../core/ids.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/units.dart';
import '../../../core/storage_exceptions.dart';
import '../../investments/domain/zakat_rules.dart';
import '../domain/zakat_repository.dart';
import '../domain/zakat_year.dart';

class DriftZakatRepository implements ZakatRepository {
  DriftZakatRepository(this._db, this._now);

  final AppDatabase _db;
  final DateTime Function() _now;

  /// One initial read, then one read per change to any of the four tables.
  /// `asyncMap` keeps the reads in order.
  @override
  Stream<List<ZakatYearRecord>> watchYears() {
    final updates = _db.tableUpdates(
      TableUpdateQuery.onAllTables([
        _db.zakatYears,
        _db.zakatExtraLines,
        _db.zakatFrozenLines,
        _db.zakatGifts,
      ]),
    );
    return Stream<void>.multi((c) {
      final sub = updates.listen((_) => c.add(null));
      c.onCancel = sub.cancel;
      c.add(null);
    }).asyncMap((_) => _readAll());
  }

  Future<List<ZakatYearRecord>> _readAll() => _db.transaction(() async {
    final years = await (_db.select(
      _db.zakatYears,
    )..orderBy([(t) => OrderingTerm.asc(t.dueKey)])).get();
    final extras = await _db.select(_db.zakatExtraLines).get();
    final lines = await (_db.select(
      _db.zakatFrozenLines,
    )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    final gifts = await (_db.select(
      _db.zakatGifts,
    )..orderBy([(t) => OrderingTerm.asc(t.date)])).get();
    return [
      for (final y in years)
        _recordOf(
          y,
          [
            for (final e in extras)
              if (e.yearId == y.id) _extraOf(e),
          ],
          [
            for (final l in lines)
              if (l.yearId == y.id) _frozenLineOf(l),
          ],
          [
            for (final g in gifts)
              if (g.yearId == y.id) _giftOf(g),
          ],
        ),
    ];
  });

  @override
  Future<void> saveYear(
    DateTime key, {
    DateTime? movedDue,
    required Decimal debts,
    required bool deductDebts,
  }) => guardStorage(
    () => _db.transaction(() async {
      final year = await _ensureYear(key);
      _mustBeOpen(year);
      await (_db.update(
        _db.zakatYears,
      )..where((t) => t.id.equals(year.id))).write(
        ZakatYearsCompanion(
          movedDue: Value(movedDue),
          debts: Value(debts),
          deductDebts: Value(deductDebts),
          updatedAt: Value(_now().toUtc()),
        ),
      );
    }),
  );

  @override
  Future<void> saveExtraLine(DateTime key, ExtraLine line) => guardStorage(
    () => _db.transaction(() async {
      final year = await _ensureYear(key);
      _mustBeOpen(year);
      final now = _now().toUtc();
      final edited =
          await (_db.update(
            _db.zakatExtraLines,
          )..where((t) => t.id.equals(line.id))).write(
            ZakatExtraLinesCompanion(
              yearId: Value(year.id),
              label: Value(line.label),
              kind: Value(line.kind.name),
              amount: Value(line.amount.amount),
              unit: Value(line.amount.unit.code),
              goodDebtConfirmed: Value(line.goodDebtConfirmed),
              updatedAt: Value(now),
            ),
          );
      if (edited > 0) return;
      await _db
          .into(_db.zakatExtraLines)
          .insert(
            ZakatExtraLinesCompanion.insert(
              id: line.id,
              yearId: year.id,
              label: line.label,
              kind: line.kind.name,
              amount: line.amount.amount,
              unit: line.amount.unit.code,
              goodDebtConfirmed: line.goodDebtConfirmed,
              createdAt: now,
              updatedAt: now,
            ),
          );
    }),
  );

  @override
  Future<void> deleteExtraLine(String id) => guardStorage(
    () => _db.transaction(() async {
      final line = await (_db.select(
        _db.zakatExtraLines,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (line == null) throw NotFound('extra line $id');
      final year = await (_db.select(
        _db.zakatYears,
      )..where((t) => t.id.equals(line.yearId))).getSingle();
      _mustBeOpen(year);
      await (_db.delete(
        _db.zakatExtraLines,
      )..where((t) => t.id.equals(id))).go();
    }),
  );

  @override
  Future<void> freeze(DateTime key, FrozenYear f) => guardStorage(
    () => _db.transaction(() async {
      final year = await _ensureYear(key);
      final now = _now().toUtc();
      await (_db.update(
        _db.zakatYears,
      )..where((t) => t.id.equals(year.id))).write(
        ZakatYearsCompanion(
          startedOn: Value(f.startedOn),
          frozenBase: Value(f.base.code),
          frozenNisabMetal: Value(f.nisab.name),
          frozenMetalRate: Value(f.metalRate),
          frozenMetalRateDate: Value(f.metalRateDate),
          updatedAt: Value(now),
        ),
      );
      await _replaceFrozenLines(year.id, f.lines, now);
    }),
  );

  Future<void> _replaceFrozenLines(
    String yearId,
    List<FrozenLine> lines,
    DateTime now,
  ) async {
    await (_db.delete(
      _db.zakatFrozenLines,
    )..where((t) => t.yearId.equals(yearId))).go();
    for (var i = 0; i < lines.length; i++) {
      final l = lines[i];
      await _db
          .into(_db.zakatFrozenLines)
          .insert(
            ZakatFrozenLinesCompanion.insert(
              id: newId(),
              yearId: yearId,
              position: i,
              source: l.isExtra ? 'extra' : 'item',
              refId: Value(l.refId),
              name: l.name,
              unit: l.unit.code,
              value: l.value,
              heldInterest: l.heldInterest,
              valueDate: Value(l.valueDate),
              rate: Value(l.rate),
              rateDate: Value(l.rateDate),
              share: l.share,
              section: l.section,
              notice: Value(l.notice?.name),
              extraKind: Value(l.extraKind?.name),
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
  }

  @override
  Future<void> unfreeze(DateTime key) => guardStorage(
    () => _db.transaction(() async {
      final year = await _yearOf(key);
      if (year == null || year.startedOn == null) {
        throw NotFound('started year $key');
      }
      final gift = await (_db.select(
        _db.zakatGifts,
      )..where((t) => t.yearId.equals(year.id))).get();
      if (gift.isNotEmpty) throw Conflict('year $key has a gift');
      await (_db.update(
        _db.zakatYears,
      )..where((t) => t.id.equals(year.id))).write(
        ZakatYearsCompanion(
          startedOn: const Value(null),
          frozenBase: const Value(null),
          frozenNisabMetal: const Value(null),
          frozenMetalRate: const Value(null),
          frozenMetalRateDate: const Value(null),
          updatedAt: Value(_now().toUtc()),
        ),
      );
      await (_db.delete(
        _db.zakatFrozenLines,
      )..where((t) => t.yearId.equals(year.id))).go();
    }),
  );

  @override
  Future<void> saveGift(DateTime key, Gift g) => guardStorage(
    () => _db.transaction(() async {
      final year = await _yearOf(key);
      if (year == null || year.startedOn == null) {
        throw Conflict('year $key is not started');
      }
      final now = _now().toUtc();
      final edited =
          await (_db.update(
            _db.zakatGifts,
          )..where((t) => t.id.equals(g.id))).write(
            ZakatGiftsCompanion(
              yearId: Value(year.id),
              date: Value(g.date),
              amount: Value(g.amount.amount),
              unit: Value(g.amount.unit.code),
              rate: Value(g.rate),
              rateDate: Value(g.rateDate),
              rateView: Value(g.view?.name),
              note: Value(g.note),
              updatedAt: Value(now),
            ),
          );
      if (edited > 0) return;
      await _db
          .into(_db.zakatGifts)
          .insert(
            ZakatGiftsCompanion.insert(
              id: g.id,
              yearId: year.id,
              date: g.date,
              amount: g.amount.amount,
              unit: g.amount.unit.code,
              rate: Value(g.rate),
              rateDate: Value(g.rateDate),
              rateView: Value(g.view?.name),
              note: Value(g.note),
              createdAt: now,
              updatedAt: now,
            ),
          );
    }),
  );

  @override
  Future<void> deleteGift(String id) => guardStorage(() async {
    final n = await (_db.delete(
      _db.zakatGifts,
    )..where((t) => t.id.equals(id))).go();
    if (n == 0) throw NotFound('gift $id');
  });

  Future<ZakatYearRow?> _yearOf(DateTime key) => (_db.select(
    _db.zakatYears,
  )..where((t) => t.dueKey.equalsValue(key))).getSingleOrNull();

  /// A year row exists only once the user decides something about it (Z3).
  Future<ZakatYearRow> _ensureYear(DateTime key) async {
    final existing = await _yearOf(key);
    if (existing != null) return existing;
    final now = _now().toUtc();
    await _db
        .into(_db.zakatYears)
        .insert(
          ZakatYearsCompanion.insert(
            id: newId(),
            dueKey: key,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await _yearOf(key))!;
  }

  void _mustBeOpen(ZakatYearRow year) {
    if (year.startedOn != null) throw Conflict('year ${year.dueKey} is frozen');
  }
}

ZakatYearRecord _recordOf(
  ZakatYearRow y,
  List<ExtraLine> extras,
  List<FrozenLine> lines,
  List<Gift> gifts,
) => ZakatYearRecord(
  dueKey: y.dueKey,
  movedDue: y.movedDue,
  debts: y.debts,
  deductDebts: y.deductDebts,
  extras: extras,
  frozen: y.startedOn == null
      ? null
      : FrozenYear(
          startedOn: y.startedOn!,
          base: Unit(y.frozenBase!),
          nisab: NisabMetal.values.byName(y.frozenNisabMetal!),
          metalRate: y.frozenMetalRate!,
          metalRateDate: y.frozenMetalRateDate!,
          lines: lines,
        ),
  gifts: gifts,
);

ExtraLine _extraOf(ZakatExtraLineRow e) => ExtraLine(
  id: e.id,
  label: e.label,
  kind: ExtraKind.values.byName(e.kind),
  amount: Money(e.amount, Unit(e.unit)),
  goodDebtConfirmed: e.goodDebtConfirmed,
);

FrozenLine _frozenLineOf(ZakatFrozenLineRow l) => FrozenLine(
  refId: l.refId,
  isExtra: l.source == 'extra',
  extraKind: l.extraKind == null ? null : ExtraKind.values.byName(l.extraKind!),
  name: l.name,
  unit: Unit(l.unit),
  value: l.value,
  heldInterest: l.heldInterest,
  valueDate: l.valueDate,
  rate: l.rate,
  rateDate: l.rateDate,
  share: l.share,
  section: l.section,
  notice: l.notice == null ? null : ZakatNotice.values.byName(l.notice!),
);

Gift _giftOf(ZakatGiftRow g) => Gift(
  id: g.id,
  date: g.date,
  amount: Money(g.amount, Unit(g.unit)),
  rate: g.rate,
  rateDate: g.rateDate,
  view: g.rateView == null ? null : GivingRateView.values.byName(g.rateView!),
  note: g.note,
);
