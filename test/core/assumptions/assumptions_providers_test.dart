/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/assumptions_providers.dart';
import 'package:financial_planner/core/assumptions/data/drift_assumptions_repository.dart';
import 'package:financial_planner/core/assumptions/data/rate_refresher.dart';
import 'package:financial_planner/core/assumptions/domain/assumptions_repository.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/core/storage_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _FailingStore extends DriftAssumptionsRepository {
  _FailingStore(super.db, super.now);

  @override
  Future<int> saveFetchedRates(List<Rate> rates) =>
      throw const StorageUnavailable('disk full');
}

void main() {
  test('A2: when storing the fetched rates fails, the refresh ends as failed (it never stays running)', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        assumptionsRepositoryProvider.overrideWith(
          (ref) =>
              _FailingStore(db, () => DateTime.utc(2026, 10, 16))
                  as AssumptionsRepository,
        ),
        httpClientProvider.overrideWithValue(
          MockClient(
            (_) async => http.Response(
              '{"date":"2026-10-15","usd":{"egp":48.5,"usd":1}}',
              200,
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(refreshControllerProvider, (_, _) {});

    await container.read(refreshControllerProvider.notifier).refresh({
      (const Unit('USD'), const Unit('EGP')),
    });

    final state = container.read(refreshControllerProvider);
    expect(state, isA<RefreshDone>());
    final result = (state as RefreshDone).result;
    expect(result, isA<RefreshFailed>());
    expect((result as RefreshFailed).reason, contains('disk full'));
  });
}
