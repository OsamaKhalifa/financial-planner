/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/assumptions_providers.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('C2 a cycle change waits for the years: with cycles saved and the years not loaded it throws and saves nothing', () async {
    final c = ProviderContainer(
      overrides: [
        zakatCyclesProvider.overrideWith(
          (ref) => Stream.value([
            ZakatCycle(
              calendar: ZakatYear.lunar,
              month: 9,
              day: 1,
              from: day(2026, 1, 5),
            ),
          ]),
        ),
        zakatYearsProvider.overrideWithValue(null),
      ],
    );
    addTearDown(c.dispose);
    c.listen(zakatCyclesProvider, (_, _) {});
    await expectLater(
      c
          .read(zakatActionsProvider)
          .saveCycle(calendar: ZakatYear.solar, month: 10, day: 20),
      throwsStateError,
    );
  });
}
