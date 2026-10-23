/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:convert';

import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/data/rate_refresher.dart';
import 'package:financial_planner/core/clock_provider.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/db/database_provider.dart';
import 'package:financial_planner/features/export/export_providers.dart';
import 'package:financial_planner/features/export/export_tables.dart';
import 'package:financial_planner/features/export/data/google_sheets_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fake_google_account.dart';

void main() {
  late List<http.Request> requests;
  late List<int> statuses;

  ProviderContainer container(FakeGoogleAccount account) {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => DateTime(2026, 10, 23, 14, 5)),
        googleAccountProvider.overrideWith(() => account),
        httpClientProvider.overrideWithValue(
          MockClient((r) async {
            requests.add(r);
            final status = statuses.isEmpty ? 200 : statuses.removeAt(0);
            return http.Response(
              jsonEncode({
                'spreadsheetId': 's1',
                'spreadsheetUrl': 'https://docs.google.com/spreadsheets/d/s1',
              }),
              status,
            );
          }),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() {
    requests = [];
    statuses = [];
  });

  test('full export: one new spreadsheet named by mode and time', () async {
    final c = container(FakeGoogleAccount(email: 'owner@example.com'));
    await c.read(googleAccountProvider.future);

    await c.read(exportControllerProvider.notifier).run(ExportMode.full);

    final state = c.read(exportControllerProvider);
    expect(state, isA<ExportDone>());
    expect(
      (state as ExportDone).url,
      Uri.parse('https://docs.google.com/spreadsheets/d/s1'),
    );
    final create = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(
      create['properties']['title'],
      'Financial Planner — Full — 2026-10-23 14:05',
    );
    expect(
      (create['sheets'] as List).map((s) => s['properties']['title']),
      contains('History'),
    );
  });

  test(
    'a refused token is forgotten and retried once with a fresh one',
    () async {
      final account = FakeGoogleAccount(
        email: 'owner@example.com',
        tokens: ['old', 'new'],
      );
      final c = container(account);
      statuses = [401];

      await c.read(exportControllerProvider.notifier).run(ExportMode.snapshot);

      expect(c.read(exportControllerProvider), isA<ExportDone>());
      expect(account.forgotten, ['old']);
      expect(requests.map((r) => r.headers['authorization']), [
        'Bearer old',
        'Bearer new',
        'Bearer new',
      ]);
    },
  );

  test('refused twice: an error that says what to do', () async {
    final account = FakeGoogleAccount(email: 'owner@example.com');
    final c = container(account);
    statuses = [401, 401];

    await c.read(exportControllerProvider.notifier).run(ExportMode.full);

    final state = c.read(exportControllerProvider);
    expect(state, isA<ExportError>());
    expect((state as ExportError).message, contains('Unlink and link again'));
    expect(account.forgotten, hasLength(2));
  });

  // The iOS SDK kills the app on an empty client id, so sign-in must not run.
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    test(
      'without client ids on ${platform.name}: not linked, Link explains',
      () async {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final c = ProviderContainer();
        addTearDown(c.dispose);

        expect(await c.read(googleAccountProvider.future), isNull);
        await expectLater(
          c.read(googleAccountProvider.notifier).link(),
          throwsA(
            isA<ExportFailed>().having(
              (e) => e.message,
              'message',
              'Google sign-in is not set up in this build.',
            ),
          ),
        );
      },
    );
  }
}
