/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../clock_provider.dart';
import '../reference/units.dart';
import '../storage_exceptions.dart';
import '../db/database_provider.dart';
import 'data/drift_assumptions_repository.dart';
import 'data/rate_refresher.dart';
import 'domain/assumptions_repository.dart';
import 'domain/inflation.dart';
import 'domain/rate.dart';
import 'domain/rate_book.dart';
import 'domain/settings.dart';
import 'shipped_inflation_loader.dart';

final assumptionsRepositoryProvider = Provider<AssumptionsRepository>(
  (ref) => DriftAssumptionsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(clockProvider),
  ),
);

final ratesProvider = StreamProvider<List<Rate>>(
  (ref) => ref.watch(assumptionsRepositoryProvider).watchRates(),
);

final rateBookProvider = FutureProvider<RateBook>(
  (ref) async => RateBook(await ref.watch(ratesProvider.future)),
);

final settingsProvider = StreamProvider<Settings>(
  (ref) => ref.watch(assumptionsRepositoryProvider).watchSettings(),
);

final zakatCyclesProvider = StreamProvider<List<ZakatCycle>>(
  (ref) => ref.watch(assumptionsRepositoryProvider).watchZakatCycles(),
);

final noZakatYearsProvider = StreamProvider<Set<int>>(
  (ref) => ref.watch(assumptionsRepositoryProvider).watchNoZakatYears(),
);

final inflationOverridesProvider = StreamProvider<List<InflationOverride>>(
  (ref) => ref.watch(assumptionsRepositoryProvider).watchInflationOverrides(),
);

final shippedInflationProvider = FutureProvider<ShippedInflation>(
  (ref) => loadShippedInflation(rootBundle),
);

final inflationBookProvider = FutureProvider<InflationBook>(
  (ref) async => InflationBook(
    await ref.watch(shippedInflationProvider.future),
    await ref.watch(inflationOverridesProvider.future),
  ),
);

final rateRefresherProvider = Provider<RateRefresher>(
  (ref) => RateRefresher(
    ref.watch(httpClientProvider),
    ref.watch(assumptionsRepositoryProvider),
  ),
);

sealed class RefreshState {
  const RefreshState();
}

final class RefreshIdle extends RefreshState {
  const RefreshIdle();
}

final class RefreshRunning extends RefreshState {
  const RefreshRunning();
}

final class RefreshDone extends RefreshState {
  const RefreshDone(this.result);

  final RefreshResult result;
}

/// The only caller of the network, and only on the user's request (S6/S8).
class RefreshController extends Notifier<RefreshState> {
  @override
  RefreshState build() => const RefreshIdle();

  Future<void> refresh(Set<UnitPair> neededPairs) async {
    if (state is RefreshRunning) return;
    state = const RefreshRunning();
    try {
      final result = await ref.read(rateRefresherProvider).refresh(neededPairs);
      state = RefreshDone(result);
    } on StorageException catch (e) {
      // Storing the answer failed: the refresh is over and nothing was saved.
      state = RefreshDone(RefreshFailed(e.message));
    }
  }
}

final refreshControllerProvider =
    NotifierProvider<RefreshController, RefreshState>(RefreshController.new);
