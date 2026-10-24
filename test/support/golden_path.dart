/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/data/rate_refresher.dart';
import 'package:financial_planner/core/clock_provider.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/db/database_provider.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/presentation/investments_providers.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_providers.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_settings_section.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/l10n/app_localizations.dart';
import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fake_year_end_reminder.dart';
import 'zakat_seeds.dart' show seedYasmin;
import 'zakat_ui.dart' as zui;
import 'app_harness.dart' show Harness;

/// The whole story through the real app, with a fixed clock and a fake
/// network (spec §8, phase 5):
///
/// 31 Mar 2026  set up (EGP, lunar, long-term = 25 % proxy), add Fund A with 10,000
/// 16 Apr 2026  record 4,000 money in
/// 30 Apr 2026  Update all (fake refresh) with Fund A worth 14,500
///              April view: return 4.21 %, set-aside 30.69 (AC-12, AC-14)
/// 30 Apr 2026  zakat: nisab gold, lunar cycle date ending 3 May (permission asked)
///  3 May 2026  the year is due; open Fund A, record 1,000,000, Zakat is 25,000.00;
///              start distribution, log 10,000 and 15,000: settled
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
  final reminder = FakeYearEndReminder();

  Future<void> startApp() async {
    await tester.pumpWidget(
      _realApp(
        db: db,
        now: () => now,
        reminder: reminder,
        onRequest: requests.add,
        response: '{"date":"2026-04-30","usd":{"usd":1,"egp":50,"xau":0.0003,"xag":0.02}}',
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

  // 30 April: the zakat tab asks nisab and cycle date, then the reminder.
  await startApp();
  await tapText(l10n().tabZakat);
  expect(find.text(l10n().zakatSetupNisabTitle), findsOneWidget);
  await tapKey('nisab-gold');
  await tapKey('setup-next');
  final dueOn = day(2026, 5, 3);
  final hijri = hijriOf(dueOn);
  expect(reminder.permissionRequests, 0);
  await zui.pickCycleDate(
    tester,
    const Locale('en'),
    ZakatYear.lunar,
    hijri.m,
    hijri.d,
  );
  await tapKey('setup-next');
  await tapKey('setup-next');
  expect(reminder.permissionRequests, 1);
  expect(reminder.pending!.fireAt, DateTime(2026, 5, 3, 9));
  expect(find.byKey(const ValueKey('result-card')), findsOneWidget);

  // 3 May: the year is due. Fund A is far below nisab until it is updated.
  now = DateTime(2026, 5, 3, 9);
  await startApp();
  await tapText(l10n().tabZakat);
  final yearLabel = l10n().zakatYearLabel('lunar', '${hijri.y}');
  expect(find.text(l10n().zakatResultBelow), findsOneWidget);
  await tapText('Fund A');
  await tapText(l10n().record);
  await enter(inKey('record-amount'), '1000000');
  await tapKey('record-save');
  tester.state<NavigatorState>(find.byType(Navigator)).pop();
  await tester.pumpAndSettle();
  expect(
    plain(tester.widget<Text>(find.byKey(const ValueKey('zakat-due'))).data!),
    '25,000.00 EGP',
  );

  await tapKey('start-year');
  expect(find.text(l10n().zakatStartedSnack(yearLabel)), findsOneWidget);
  // The snack bar sits over the button for its 10 seconds; Undo ends with it.
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 11));
  await tester.pumpAndSettle();
  expect(find.text(l10n().undo), findsNothing);
  await tapKey('add-gift');
  await enter(inKey('gift-amount'), '10000');
  await tapKey('gift-save');
  await tapKey('add-gift');
  await enter(inKey('gift-amount'), '15000');
  await tapKey('gift-save');
  expect(
    plain(tester.widget<Text>(find.byKey(const ValueKey('settled'))).data!),
    l10n().zakatState('settled'),
  );
  expect(find.byKey(const ValueKey('c11-line')), findsOneWidget);
  await tapKey('zakat-history');
  expect(find.byKey(ValueKey('history-${yearKeyOf(dueOn)}')), findsOneWidget);

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

String yearKeyOf(DateTime d) => d.toIso8601String().substring(0, 10);

/// The real app on [db] with a fixed clock, a fake phone and a fake network
/// that answers every request with [response] and reports it to [onRequest].
Widget _realApp({
  required AppDatabase db,
  required DateTime Function() now,
  required FakeYearEndReminder reminder,
  required void Function(http.BaseRequest) onRequest,
  String response = '{}',
}) => ProviderScope(
  key: UniqueKey(),
  overrides: [
    appDatabaseProvider.overrideWithValue(db),
    clockProvider.overrideWithValue(now),
    yearEndReminderProvider.overrideWithValue(reminder),
    zakatSettingsSectionProvider.overrideWithValue(zakatSettingsSectionBuilder),
    httpClientProvider.overrideWithValue(
      MockClient((r) async {
        onRequest(r);
        return http.Response(response, 200);
      }),
    ),
  ],
  child: const App(),
);

/// Yasmin's zakat year (story §11) through the real app, the part of the
/// story's integration path that needs the seeded lines:
///
/// 23 Oct 2026  the app is opened from the year-end notification (AC-36) and
///              lands on year 1448 AH, due 20 Oct, Z 12,500.00; open Savings
///              and come back (AC-21); start distribution (AC-23, AC-43);
///              log 5,000 EGP, then 100 USD (the rate view is asked once,
///              AC-30: day given, counted at 50.00), then 2,500 EGP: settled
///              (AC-26); History shows it; the detail lists the entries
///              (AC-32, AC-33); a new launch from the same payload opens it.
Future<void> runZakatGoldenPath(WidgetTester tester) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  tester.view.physicalSize = const Size(900, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final h = Harness(DateTime(2026, 10, 23, 9));
  await tester.runAsync(() => seedYasmin(h));
  h.reminder.launchKey = '2026-10-20';
  final requests = <http.BaseRequest>[];

  Future<void> startApp() async {
    await tester.pumpWidget(
      _realApp(
        db: h.db,
        now: () => h.now,
        reminder: h.reminder,
        onRequest: requests.add,
      ),
    );
    await tester.pumpAndSettle();
  }

  AppLocalizations l10n() =>
      AppLocalizations.of(tester.element(find.byType(Scaffold).first));
  String plain(String s) => s.replaceAll('\u2066', '').replaceAll('\u2069', '');
  String textAt(String key) => zui.textOf(tester, find.byKey(ValueKey(key)));
  Finder shows(String text) => find.byWidgetPredicate(
    (w) => w is Text && w.data != null && plain(w.data!).contains(text),
  );
  void back() => tester.state<NavigatorState>(find.byType(Navigator)).pop();

  // The notification opens the app on the year (AC-36).
  await startApp();
  expect(find.byKey(const ValueKey('zakat-due')), findsOneWidget);
  final label = l10n().zakatYearLabel('lunar', '1448');
  expect(
    find.descendant(of: find.byType(AppBar), matching: find.text(label)),
    findsOneWidget,
  );
  expect(textAt('zakat-due'), '12,500.00 EGP');
  expect(textAt('state-chip'), l10n().zakatState('due'));
  expect(h.reminder.permissionRequests, 0);

  // Savings opens its investment, and back it is the same year (AC-21).
  await zui.openLine(tester, 'Savings');
  expect(find.byKey(const ValueKey('value-now')), findsOneWidget);
  back();
  await tester.pumpAndSettle();
  expect(textAt('zakat-due'), '12,500.00 EGP');

  // Start: one tap, no question, Undo offered for 10 seconds (AC-43).
  await zui.tapKey(tester, 'start-year');
  expect(find.byType(AlertDialog), findsNothing);
  expect(textAt('state-chip'), l10n().zakatState('distributing'));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 11));
  await tester.pumpAndSettle();

  // 5,000 EGP on the 21st.
  await zui.tapKey(tester, 'add-gift');
  await zui.pickDate(tester, 'gift-date', 21);
  await zui.enter(tester, zui.inKey('gift-amount'), '5000');
  await zui.enter(tester, find.byKey(const ValueKey('gift-note')), 'Masjid');
  await zui.tapKey(tester, 'gift-save');
  expect(shows(l10n().zakatGiftRemaining('7,500.00 EGP')), findsOneWidget);

  // 100 USD on the 22nd: the rate view is asked, nothing pre-selected.
  await zui.tapKey(tester, 'add-gift');
  await zui.pickDate(tester, 'gift-date', 22);
  await zui.enter(tester, zui.inKey('gift-amount'), '100');
  await zui.pickUnit(tester, 'gift-unit', 'USD');
  expect(find.byKey(const ValueKey('view-dayGiven')), findsOneWidget);
  await tester.tap(find.byKey(const ValueKey('view-dayGiven')));
  await tester.pumpAndSettle();
  await zui.tapKey(tester, 'gift-save');
  expect(shows(l10n().zakatGiftRemaining('2,500.00 EGP')), findsOneWidget);

  // The last 2,500 EGP settles the year (AC-26).
  await zui.tapKey(tester, 'add-gift');
  await zui.pickDate(tester, 'gift-date', 23);
  await zui.enter(tester, zui.inKey('gift-amount'), '2500');
  await zui.tapKey(tester, 'gift-save');
  expect(textAt('settled'), l10n().zakatState('settled'));
  expect(find.byKey(const ValueKey('c11-line')), findsOneWidget);
  expect(h.reminder.permissionRequests, 0);

  // History, then the detail with every entry (AC-32, AC-33).
  back();
  await tester.pumpAndSettle();
  await zui.tapKey(tester, 'zakat-history');
  final row = find.byKey(const ValueKey('history-2026-10-20'));
  expect(row, findsOneWidget);
  await tester.tap(row);
  await tester.pumpAndSettle();
  expect(shows('12,500.00'), findsWidgets);
  expect(shows('Masjid'), findsOneWidget);
  final rateDay = MaterialLocalizations.of(
    tester.element(find.byType(Scaffold).first),
  ).formatMediumDate(day(2026, 10, 21));
  expect(
    shows(
      l10n().zakatGiftCountedAt('100.00 USD', '50.00', rateDay, 'dayGiven'),
    ),
    findsOneWidget,
  );
  expect(find.byKey(const ValueKey('settled')), findsOneWidget);

  // A new launch from the same payload opens the year again.
  await startApp();
  expect(find.byKey(const ValueKey('settled')), findsOneWidget);
  expect(
    find.descendant(of: find.byType(AppBar), matching: find.text(label)),
    findsOneWidget,
  );

  expect(requests, isEmpty, reason: 'no network request for the zakat flow');

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(h.db.close);
}
