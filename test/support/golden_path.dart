/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/data/rate_refresher.dart';
import 'package:financial_planner/core/clock_provider.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/db/database_provider.dart';
import 'package:financial_planner/features/investments/presentation/investments_providers.dart';
import 'package:financial_planner/l10n/app_localizations.dart';
import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// The whole story through the real app, with a fixed clock and a fake
/// network (spec §8, phase 5):
///
/// 31 Mar 2026  set up (EGP, lunar, long-term = 25 % proxy), add Fund A with 10,000
/// 16 Apr 2026  record 4,000 money in
/// 30 Apr 2026  Update all (fake refresh) with Fund A worth 14,500
///              April view: return 4.21 %, set-aside 30.69 (AC-12, AC-14)
///
/// Each "day" restarts the app on the same database, as a user would.
Future<void> runGoldenPath(WidgetTester tester) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  tester.view.physicalSize = const Size(900, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = AppDatabase(NativeDatabase.memory());
  final requests = <http.BaseRequest>[];
  var now = DateTime(2026, 3, 31, 9);

  Future<void> startApp() async {
    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => now),
          httpClientProvider.overrideWithValue(
            MockClient((r) async {
              requests.add(r);
              return http.Response(
                '{"date":"2026-04-30","usd":{"usd":1,"egp":50,"xau":0.0003,"xag":0.02}}',
                200,
              );
            }),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(String text) async {
    final f = find.text(text).first;
    await tester.ensureVisible(f);
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(String key) async {
    final f = find.byKey(ValueKey(key));
    await tester.ensureVisible(f);
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Future<void> enter(Finder field, String text) async {
    await tester.ensureVisible(field);
    await tester.enterText(field, text);
    await tester.pumpAndSettle();
  }

  AppLocalizations l10n() =>
      AppLocalizations.of(tester.element(find.byType(Scaffold).first));
  Finder inKey(String key) => find.descendant(
    of: find.byKey(ValueKey(key)),
    matching: find.byType(TextField),
  );

  // 31 March: set up, then add Fund A.
  await startApp();
  expect(find.text(l10n().setupBaseTitle), findsOneWidget);
  await tapKey('unit-EGP');
  await tapText(l10n().next);
  await tapText(l10n().longTermProxy25);
  await tapText(l10n().done);
  expect(find.text(l10n().emptyTitle), findsOneWidget);

  await tapText(l10n().addInvestment);
  await tapText(l10n().typeFund);
  await enter(find.widgetWithText(TextField, l10n().fieldName), 'Fund A');
  await tapText(l10n().intentTrading);
  await enter(inKey('paid'), '10000');
  await tapKey('save');
  expect(find.text('Fund A'), findsWidgets);
  expect(find.byKey(const ValueKey('value-now')), findsOneWidget);

  // 16 April: 4,000 more money in.
  now = DateTime(2026, 4, 16, 9);
  await startApp();
  await tapText(l10n().tabInvestments);
  await tapText('Fund A');
  await tapText(l10n().record);
  await tapText(l10n().tabIn);
  await enter(inKey('record-amount'), '4000');
  await tapKey('record-save');
  expect(find.byType(BottomSheet), findsNothing);

  // 30 April: Update all.
  now = DateTime(2026, 4, 30, 9);
  await startApp();
  await tapText(l10n().tabInvestments);
  await tapText(l10n().updateAll);
  expect(requests, isEmpty, reason: 'nothing is fetched until asked');
  await tapKey('refresh');
  await tester.runAsync(() => pumpEventQueue(times: 50));
  await tester.pumpAndSettle();
  expect(find.byKey(const ValueKey('refresh-status')), findsOneWidget);
  await tester.tap(find.byType(Switch));
  await tester.pumpAndSettle();
  await enter(inKey('item-${await _firstItemId(tester)}'), '14500');
  await tapKey('update-save');
  expect(find.byKey(const ValueKey('update-save')), findsNothing);

  // The April view.
  await tapText(l10n().tabOverview);
  await tester.tap(find.byKey(const ValueKey('overview-verdict')));
  await tester.pumpAndSettle();
  await tapText(l10n().monthLabel);
  String plain(String s) => s.replaceAll('\u2066', '').replaceAll('\u2069', '');
  Finder shows(String text) => find.byWidgetPredicate(
    (w) => w is Text && w.data != null && plain(w.data!).contains(text),
  );
  expect(shows('+4.21 %'), findsWidgets);
  expect(shows('−30.69 EGP'), findsOneWidget);
  expect(find.text(l10n().setAsideNote), findsOneWidget);

  // The only network call of the whole story was the one the user asked for.
  expect(requests.length, 1);
  expect(requests.single.method, 'GET');
  expect(requests.single.url, primaryRatesUrl);

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(db.close);
}

Future<String> _firstItemId(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(Scaffold).first),
  );
  final items = await tester.runAsync(
    () => container.read(investmentsProvider.future),
  );
  return items!.single.investment.id;
}
