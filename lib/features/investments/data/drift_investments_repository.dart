/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/storage_guard.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import '../../../core/storage_exceptions.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../domain/investments_repository.dart';

class DriftInvestmentsRepository implements InvestmentsRepository {
  DriftInvestmentsRepository(this._db, this._now);

  final AppDatabase _db;
  final DateTime Function() _now;

  @override
  Stream<List<InvestmentWithHistory>> watchAll() {
    final query =
        _db.select(_db.investments).join([
          leftOuterJoin(
            _db.historyEntries,
            _db.historyEntries.investmentId.equalsExp(_db.investments.id),
          ),
        ])..orderBy([
          OrderingTerm.asc(_db.investments.createdAt),
          OrderingTerm.asc(_db.investments.id),
          OrderingTerm.asc(_db.historyEntries.date),
          OrderingTerm.asc(_db.historyEntries.createdAt),
        ]);
    return query.watch().map((rows) {
      final items = <String, Investment>{};
      final history = <String, List<HistoryEntry>>{};
      for (final row in rows) {
        final item = _investmentOf(row.readTable(_db.investments));
        items.putIfAbsent(item.id, () => item);
        final entry = row.readTableOrNull(_db.historyEntries);
        final list = history.putIfAbsent(item.id, () => []);
        if (entry != null) list.add(_entryOf(entry));
      }
      return [
        for (final e in items.entries)
          InvestmentWithHistory(investment: e.value, history: history[e.key]!),
      ];
    });
  }

  @override
  Future<void> create(Investment item, List<HistoryEntry> initial) =>
      guardStorage(
        () => _db.transaction(() async {
          final now = _now().toUtc();
          await _db
              .into(_db.investments)
              .insert(_investmentRow(item, created: Value(now), updated: now));
          await _insertEntries(initial, created: (_) => now, updated: now);
        }),
      );

  @override
  Future<void> update(
    Investment item, {
    List<HistoryEntry> entries = const [],
  }) => guardStorage(
    () => _db.transaction(() async {
      final now = _now().toUtc();
      final n =
          await (_db.update(
            _db.investments,
          )..where((t) => t.id.equals(item.id))).write(
            _investmentRow(item, created: const Value.absent(), updated: now),
          );
      if (n == 0) throw NotFound('investment ${item.id}');
      await _upsertEntries(entries, now);
    }),
  );

  @override
  Future<void> delete(String id) => guardStorage(() async {
    final n = await (_db.delete(
      _db.investments,
    )..where((t) => t.id.equals(id))).go();
    if (n == 0) throw NotFound('investment $id');
  });

  @override
  Future<void> restore(InvestmentWithHistory aggregate) => guardStorage(
    () => _db.transaction(() async {
      final item = aggregate.investment;
      await _db
          .into(_db.investments)
          .insert(
            _investmentRow(
              item,
              created: Value(item.createdAt),
              updated: item.updatedAt,
            ),
          );
      await _insertEntries(
        aggregate.history,
        created: (e) => e.createdAt,
        updated: null,
      );
    }),
  );

  @override
  Future<void> saveEntries(List<HistoryEntry> entries) => guardStorage(
    () => _db.transaction(() => _upsertEntries(entries, _now().toUtc())),
  );

  Future<void> _upsertEntries(List<HistoryEntry> entries, DateTime now) async {
    for (final e in entries) {
      final existing = await (_db.select(
        _db.historyEntries,
      )..where((t) => t.id.equals(e.id))).getSingleOrNull();
      await _db
          .into(_db.historyEntries)
          .insertOnConflictUpdate(
            _entryRow(e, created: existing?.createdAt ?? now, updated: now),
          );
    }
  }

  @override
  Future<void> deleteEntries(List<String> ids) => guardStorage(
    () => _db.transaction(() async {
      final n = await (_db.delete(
        _db.historyEntries,
      )..where((t) => t.id.isIn(ids))).go();
      if (n != ids.toSet().length) throw NotFound('entries $ids');
    }),
  );

  /// [updated] null keeps each entry's own value (restore).
  Future<void> _insertEntries(
    List<HistoryEntry> entries, {
    required DateTime Function(HistoryEntry) created,
    required DateTime? updated,
  }) async {
    for (final e in entries) {
      await _db
          .into(_db.historyEntries)
          .insert(
            _entryRow(e, created: created(e), updated: updated ?? e.updatedAt),
          );
    }
  }
}

InvestmentsCompanion _investmentRow(
  Investment i, {
  required Value<DateTime> created,
  required DateTime updated,
}) => InvestmentsCompanion(
  id: Value(i.id),
  name: Value(i.name),
  assetType: Value(i.type.name),
  intent: Value(i.intent?.name),
  market: Value(i.market?.name),
  marketCountry: Value(i.marketCountry?.iso3),
  unit: Value(i.unit.code),
  startDate: Value(i.startDate),
  quantity: Value(i.quantity),
  purityKarat: Value(i.purityKarat),
  purityFineness: Value(i.purityFineness),
  zakatRule: Value(i.zakatRule.name),
  customZakatShare: Value(i.customZakatShare),
  inflationOverride: Value(i.inflationOverride?.iso3),
  notes: Value(i.notes),
  payoutSchedule: Value(i.payoutSchedule?.name),
  expectedProfit: Value(i.expectedProfit),
  valueCheckSchedule: Value(i.valueCheckSchedule?.name),
  expectedGrowth: Value(i.expectedGrowth),
  profitBasis: Value(i.profitBasis?.name),
  capitalBack: Value(i.capitalBack?.name),
  accountKind: Value(i.accountKind?.name),
  createdAt: created,
  updatedAt: Value(updated),
);

Investment _investmentOf(InvestmentRow r) => Investment(
  id: r.id,
  name: r.name,
  type: AssetType.values.byName(r.assetType),
  intent: r.intent == null ? null : Intent.values.byName(r.intent!),
  market: r.market == null ? null : Market.values.byName(r.market!),
  marketCountry: r.marketCountry == null ? null : Country(r.marketCountry!),
  unit: Unit(r.unit),
  startDate: r.startDate,
  quantity: r.quantity,
  purityKarat: r.purityKarat,
  purityFineness: r.purityFineness,
  zakatRule: ZakatRule.values.byName(r.zakatRule),
  customZakatShare: r.customZakatShare,
  inflationOverride: r.inflationOverride == null
      ? null
      : Country(r.inflationOverride!),
  notes: r.notes,
  payoutSchedule: _byName(Schedule.values, r.payoutSchedule),
  expectedProfit: r.expectedProfit,
  valueCheckSchedule: _byName(Schedule.values, r.valueCheckSchedule),
  expectedGrowth: r.expectedGrowth,
  profitBasis: _byName(ProfitBasis.values, r.profitBasis),
  capitalBack: _byName(CapitalBack.values, r.capitalBack),
  accountKind: _byName(AccountKind.values, r.accountKind),
  createdAt: r.createdAt.toUtc(),
  updatedAt: r.updatedAt.toUtc(),
);

T? _byName<T extends Enum>(List<T> values, String? name) =>
    name == null ? null : values.byName(name);

/// A skip has no amount; the column is NOT NULL, so it stores 0 (spec E2).
const _skipKinds = {
  PlanKind.payout: 'payout_skipped',
  PlanKind.value: 'value_skipped',
};

const _interestKinds = {
  InterestKind.keptInside: 'interest_kept_inside',
  InterestKind.paidOut: 'interest_paid_out',
  InterestKind.givenAwayFromInside: 'interest_given_away_inside',
  InterestKind.givenAwayFromPaidOut: 'interest_given_away_paid_out',
};

HistoryEntriesCompanion _entryRow(
  HistoryEntry e, {
  required DateTime created,
  required DateTime updated,
}) {
  final (kind, amount, unit) = switch (e) {
    MoneyIn(:final amount) => ('money_in', amount.amount, amount.unit.code),
    MoneyOut(:final amount, :final kind) => (
      kind == MoneyOutKind.sale ? 'sale' : 'income',
      amount.amount,
      amount.unit.code,
    ),
    InterestRecord(:final amount, :final kind) => (
      _interestKinds[kind]!,
      amount.amount,
      amount.unit.code,
    ),
    ValueUpdate(:final value) => ('value_update', value, null),
    PlanSkip(:final plan) => (_skipKinds[plan]!, Decimal.zero, null),
  };
  return HistoryEntriesCompanion(
    id: Value(e.id),
    investmentId: Value(e.investmentId),
    kind: Value(kind),
    date: Value(e.date),
    amount: Value(amount),
    unit: Value(unit),
    createdAt: Value(created),
    updatedAt: Value(updated),
  );
}

HistoryEntry _entryOf(HistoryEntryRow r) {
  Money money() => Money(r.amount, Unit(r.unit!));
  final created = r.createdAt.toUtc();
  final updated = r.updatedAt.toUtc();
  InterestRecord interest(InterestKind kind) => InterestRecord(
    id: r.id,
    investmentId: r.investmentId,
    date: r.date,
    amount: money(),
    kind: kind,
    createdAt: created,
    updatedAt: updated,
  );
  return switch (r.kind) {
    'money_in' => MoneyIn(
      id: r.id,
      investmentId: r.investmentId,
      date: r.date,
      amount: money(),
      createdAt: created,
      updatedAt: updated,
    ),
    'sale' || 'income' => MoneyOut(
      id: r.id,
      investmentId: r.investmentId,
      date: r.date,
      amount: money(),
      kind: r.kind == 'sale' ? MoneyOutKind.sale : MoneyOutKind.income,
      createdAt: created,
      updatedAt: updated,
    ),
    'payout_skipped' || 'value_skipped' => PlanSkip(
      id: r.id,
      investmentId: r.investmentId,
      date: r.date,
      plan: r.kind == 'payout_skipped' ? PlanKind.payout : PlanKind.value,
      createdAt: created,
      updatedAt: updated,
    ),
    'value_update' => ValueUpdate(
      id: r.id,
      investmentId: r.investmentId,
      date: r.date,
      value: r.amount,
      createdAt: created,
      updatedAt: updated,
    ),
    final k => interest(
      _interestKinds.entries.firstWhere((e) => e.value == k).key,
    ),
  };
}
