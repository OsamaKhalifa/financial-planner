/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/clock_provider.dart';
import '../../../core/dates.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/units.dart';
import '../data/drift_investments_repository.dart';
import '../domain/expected_plan.dart';
import '../domain/investment.dart';
import '../domain/investments_repository.dart';
import '../domain/period.dart';
import '../domain/portfolio_calculator.dart';
import '../domain/zakat_rules.dart';

final investmentsRepositoryProvider = Provider<InvestmentsRepository>(
  (ref) => DriftInvestmentsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  ),
);

final investmentsProvider = StreamProvider<List<InvestmentWithHistory>>(
  (ref) => ref.watch(investmentsRepositoryProvider).watchAll(),
);

final todayProvider = Provider<DateTime>(
  (ref) => today(ref.watch(clockProvider)),
);

/// Null until the setup is done: figures need a base currency and zakat year.
final calculatorProvider = FutureProvider<PortfolioCalculator?>((ref) async {
  final settings = await ref.watch(settingsProvider.future);
  if (!settings.setupDone) return null;
  return PortfolioCalculator(
    items: await ref.watch(investmentsProvider.future),
    rates: await ref.watch(rateBookProvider.future),
    inflation: await ref.watch(inflationBookProvider.future),
    settings: settings,
    noZakatYears: await ref.watch(noZakatYearsProvider.future),
    today: ref.watch(todayProvider),
  );
});

typedef PeriodKey = (Period, ViewUnit);

final portfolioFiguresProvider = Provider.family<PortfolioFigures?, PeriodKey>(
  (ref, key) => ref.watch(calculatorProvider).value?.portfolio(key.$1, key.$2),
);

final itemFiguresProvider = Provider.family<ItemFigures?, (String, Period)>((
  ref,
  key,
) {
  final calc = ref.watch(calculatorProvider).value;
  return calc != null && calc.hasItem(key.$1)
      ? calc.item(key.$1, key.$2)
      : null;
});

final sinceStartProvider = Provider.family<SinceStartFigures?, String>((
  ref,
  id,
) {
  final calc = ref.watch(calculatorProvider).value;
  return calc != null && calc.hasItem(id) ? calc.sinceStart(id) : null;
});

final byTypeProvider = Provider.family<List<Slice<AssetType>>?, Period>(
  (ref, p) => ref.watch(calculatorProvider).value?.byType(p),
);

final byCurrencyProvider = Provider.family<List<Slice<Unit>>?, Period>(
  (ref, p) => ref.watch(calculatorProvider).value?.byCurrency(p),
);

final monthlyProvider = Provider<List<MonthPoint>?>(
  (ref) => ref.watch(calculatorProvider).value?.monthly(),
);

final sinceStartTotalProvider = Provider<SinceStartTotal?>(
  (ref) => ref.watch(calculatorProvider).value?.sinceStartTotal(),
);

final exposureProvider = Provider.family<Exposure?, Period>(
  (ref, p) => ref.watch(calculatorProvider).value?.exposure(p),
);

/// Rebuilt from the item on every read; nothing is cached or written (E1).
final expectedProvider = Provider.family<ExpectedVsActual?, String>((ref, id) {
  final calc = ref.watch(calculatorProvider).value;
  return calc != null && calc.hasItem(id)
      ? expectedVsActual(calc.timeline(id), calc.today)
      : null;
});

/// Home's "N to confirm" for one item; 0 for a closed item (AC-56).
final pendingCountProvider = Provider.family<int, String>(
  (ref, id) => ref.watch(expectedProvider(id))?.toConfirm ?? 0,
);

typedef UnitOrder = ({List<Unit> units, int topCount});

/// The unit picker order (AC-42..44): the base, or the phone's region currency
/// before setup, always in the top group; [topCount] is that group's size.
final unitOrderProvider = Provider.family<UnitOrder, Unit>((ref, anchor) {
  final items = ref.watch(investmentsProvider).value ?? const [];
  final usage = <Unit, int>{};
  for (final h in items) {
    usage.update(h.investment.unit, (n) => n + 1, ifAbsent: () => 1);
  }
  final used = usage.keys.where((u) => u != anchor).length;
  return (
    units: orderedUnits(usage: usage, topAnchor: anchor),
    topCount: 1 + (used > 4 ? 4 : used),
  );
});

final settingsActionsProvider = Provider<SettingsActions>(
  (ref) => SettingsActions(ref),
);

/// Changes that touch both settings and items.
class SettingsActions {
  SettingsActions(this._ref);

  final Ref _ref;

  /// Switching to "decide per item" first writes the method each affected item
  /// was following into the item, so nothing changes silently (architect note
  /// on D7). The items are saved before the setting, so figures never see
  /// "per item" with an unresolved rule.
  Future<void> setLongTermMethod(LongTermMethod? method) async {
    final repo = _ref.read(assumptionsRepositoryProvider);
    final old = await _ref.read(settingsProvider.future);
    if (method == LongTermMethod.perItem && old.longTermMethod != null) {
      final explicit = explicitLongTermRule(old.longTermMethod!);
      if (explicit != null) {
        final items = await _ref.read(investmentsProvider.future);
        final now = _ref.read(clockProvider)();
        final investments = _ref.read(investmentsRepositoryProvider);
        for (final h in items) {
          if (h.investment.zakatRule == ZakatRule.longTermPerSetting) {
            await investments.update(h.investment.withRule(explicit, now));
          }
        }
      }
    }
    await repo.saveSettings(_with(old, longTermMethod: method));
  }

  Future<void> _update(Settings Function(Settings old) change) async {
    final old = await _ref.read(settingsProvider.future);
    await _ref.read(assumptionsRepositoryProvider).saveSettings(change(old));
  }

  Future<void> setBase(Unit base) => _update(
    (o) => _with(
      o,
      baseCurrency: base,
      keepMethod: true,
      clearHome: o.homeInflation == null,
    ),
  );

  Future<void> setHome(Country c) =>
      _update((o) => _with(o, homeInflation: c, keepMethod: true));

  Future<void> setZakatYear(ZakatYear y) =>
      _update((o) => _with(o, zakatYear: y, keepMethod: true));

  Future<void> setJewellery({required bool zakatable}) =>
      _update((o) => _with(o, jewelleryZakatable: zakatable, keepMethod: true));

  Future<void> saveSettings(Settings s) =>
      _ref.read(assumptionsRepositoryProvider).saveSettings(s);
}

Settings _with(
  Settings s, {
  Unit? baseCurrency,
  Country? homeInflation,
  ZakatYear? zakatYear,
  LongTermMethod? longTermMethod,
  bool? jewelleryZakatable,
  bool keepMethod = false,
  bool clearHome = false,
}) => Settings(
  baseCurrency: baseCurrency ?? s.baseCurrency,
  homeInflation: clearHome ? null : (homeInflation ?? s.homeInflation),
  zakatYear: zakatYear ?? s.zakatYear,
  longTermMethod: keepMethod ? s.longTermMethod : longTermMethod,
  jewelleryZakatable: jewelleryZakatable ?? s.jewelleryZakatable,
);
