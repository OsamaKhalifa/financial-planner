/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/clock_provider.dart';
import '../../../core/db/database_provider.dart';
import '../../investments/domain/portfolio_calculator.dart';
import '../../investments/presentation/investments_providers.dart';
import '../data/drift_zakat_repository.dart';
import '../data/local_year_end_reminder.dart';
import '../domain/year_end_reminder.dart';
import '../domain/yearly_zakat.dart';
import '../domain/zakat_repository.dart';
import '../domain/zakat_year.dart';

final zakatRepositoryProvider = Provider<ZakatRepository>(
  (ref) => DriftZakatRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  ),
);

final zakatRecordsProvider = StreamProvider<List<ZakatYearRecord>>(
  (ref) => ref.watch(zakatRepositoryProvider).watchYears(),
);

/// Oldest first. Null until every source has loaded. An open year uses
/// today's position, a due year the position on its due date, a started year
/// its frozen inputs (story §7).
final zakatYearsProvider = Provider<List<YearView>?>((ref) {
  final cycles = ref.watch(zakatCyclesProvider).value;
  final records = ref.watch(zakatRecordsProvider).value;
  final calc = ref.watch(calculatorProvider).value;
  final rates = ref.watch(rateBookProvider).value;
  final settings = ref.watch(settingsProvider).value;
  if (cycles == null ||
      records == null ||
      calc == null ||
      rates == null ||
      settings == null) {
    return null;
  }
  final today = ref.watch(todayProvider);
  final byKey = {for (final r in records) r.dueKey: r};
  final slots = yearSlots(cycles, {
    for (final r in records)
      if (r.movedDue != null) r.dueKey: r.movedDue!,
  }, today);
  return [
    for (final s in slots)
      yearViewOf(
        s,
        byKey[s.key],
        _inputsOf(s, byKey[s.key], calc, rates, settings.zakat, today),
        today,
      ),
  ];
});

YearInputs _inputsOf(
  YearSlot s,
  ZakatYearRecord? r,
  PortfolioCalculator calc,
  RateBook rates,
  ZakatPrefs prefs,
  DateTime today,
) {
  if (r?.frozen != null) return frozenInputs(s, r!);
  final on = s.due.isAfter(today) ? today : s.due;
  return liveInputs(s, r, calc.zakatPosition(on), rates, prefs);
}

final yearViewProvider = Provider.family<YearView?, DateTime>(
  (ref, key) => ref
      .watch(zakatYearsProvider)
      ?.where((y) => y.slot.key == key)
      .firstOrNull,
);

final focusYearProvider = Provider<YearView?>((ref) {
  final years = ref.watch(zakatYearsProvider);
  return years == null || years.isEmpty ? null : focusYear(years);
});

final yearEndReminderProvider = Provider<YearEndReminder>(
  (ref) => LocalYearEndReminder(),
);

/// The phone's answer, read again after the app asks.
final reminderPermittedProvider = FutureProvider<bool>(
  (ref) => ref.watch(yearEndReminderProvider).isPermitted(),
);

final reminderPlanProvider = FutureProvider<ReminderPlan?>((ref) async {
  final years = ref.watch(zakatYearsProvider);
  final prefs = ref.watch(settingsProvider).value?.zakat;
  if (years == null || prefs == null) return null;
  return reminderPlan(
    years,
    prefs,
    permitted: await ref.watch(reminderPermittedProvider.future),
    now: ref.watch(clockProvider)(),
  );
});

final zakatActionsProvider = Provider<ZakatActions>((ref) => ZakatActions(ref));

/// Every write of the Zakat tab. Screens call these; the repositories and
/// the pure functions of `yearly_zakat.dart` do the rest.
class ZakatActions {
  ZakatActions(this._ref);

  final Ref _ref;

  ZakatRepository get _repo => _ref.read(zakatRepositoryProvider);
  SettingsActions get _settings => _ref.read(settingsActionsProvider);
  DateTime get _today => _ref.read(todayProvider);

  Future<void> setNisab(NisabMetal metal) =>
      _settings.setZakatPrefs((p) => p.copyWith(nisab: metal));

  Future<void> setReminder({bool? on, int? days, int? minute}) =>
      _settings.setZakatPrefs(
        (p) => p.copyWith(
          reminderOn: on,
          reminderDays: days,
          reminderMinute: minute,
        ),
      );

  Future<void> setGivingRateView(GivingRateView view) =>
      _settings.setZakatPrefs((p) => p.copyWith(givingRateView: view));

  /// First cycle or a change (C2): the new cycle starts after the open year.
  /// The phone is asked for notifications once, on the first save (AC-34);
  /// the result is true when it said no.
  Future<bool> saveCycle({
    required ZakatYear calendar,
    required int month,
    required int day,
    int? reminderDays,
    int? reminderMinute,
  }) async {
    final slots = _ref.read(zakatYearsProvider)?.map((y) => y.slot).toList();
    await _settings.saveZakatCycle(
      ZakatCycle(
        calendar: calendar,
        month: month,
        day: day,
        from: newCycleFrom(slots ?? const [], _today),
      ),
      prefs: (p) => p.copyWith(
        reminderDays: reminderDays,
        reminderMinute: reminderMinute,
      ),
    );
    final settings = await _ref.read(settingsProvider.future);
    if (settings.zakat.reminderAsked) return false;
    final granted = await _ref
        .read(yearEndReminderProvider)
        .requestPermission();
    await _settings.setZakatPrefs((p) => p.copyWith(reminderAsked: true));
    _ref.invalidate(reminderPermittedProvider);
    return !granted;
  }

  Future<void> moveDue(YearView v, DateTime to) => _repo.saveYear(
    v.slot.key,
    movedDue: to == v.slot.key ? null : to,
    debts: v.record?.debts ?? Decimal.zero,
    deductDebts: v.record?.deductDebts ?? true,
  );

  Future<void> saveDebts(YearView v, Decimal debts, {required bool deduct}) =>
      _repo.saveYear(
        v.slot.key,
        movedDue: v.record?.movedDue,
        debts: debts,
        deductDebts: deduct,
      );

  Future<void> saveExtra(YearView v, ExtraLine line) =>
      _repo.saveExtraLine(v.slot.key, line);

  Future<void> deleteExtra(String id) => _repo.deleteExtraLine(id);

  Future<void> start(YearView v) =>
      _repo.freeze(v.slot.key, freeze(v.inputs, _today));

  Future<void> undoStart(DateTime key) => _repo.unfreeze(key);

  /// The year as today's data gives it on its due date (C9).
  Future<YearInputs> liveInputsOf(YearView v) async {
    final calc = (await _ref.read(calculatorProvider.future))!;
    final rates = await _ref.read(rateBookProvider.future);
    final settings = await _ref.read(settingsProvider.future);
    return liveInputs(
      v.slot,
      v.record,
      calc.zakatPosition(v.slot.due),
      rates,
      settings.zakat,
    );
  }

  Future<void> recompute(YearView v) async =>
      _repo.freeze(v.slot.key, freeze(await liveInputsOf(v), _today));

  Future<void> saveGift(YearView v, Gift g) => _repo.saveGift(v.slot.key, g);

  Future<void> deleteGift(String id) => _repo.deleteGift(id);
}
