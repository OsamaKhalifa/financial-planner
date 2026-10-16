/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/assumptions_providers.dart';
import 'package:financial_planner/core/assumptions/data/drift_assumptions_repository.dart';
import 'package:financial_planner/core/assumptions/data/rate_refresher.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/clock_provider.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/db/database_provider.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/data/drift_investments_repository.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:ui' show CheckedState;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
const sar = Unit('SAR');
const egy = Country('EGY');
const usa = Country('USA');

Decimal d(String s) => Decimal.parse(s);

final _quiet = () {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return true;
}();

const en = Locale('en');
const ar = Locale('ar');

ShippedInflation defaultShipped() => ShippedInflation(
  source: 'World Bank',
  asOfNote: '2026-10-08',
  series: {
    egy: {2025: d('0.14'), 2026: d('0.10')},
    usa: {2025: d('0.03'), 2026: d('0.03')},
    const Country('SAU'): {2025: d('0.02'), 2026: d('0.02')},
  },
);

/// An in-memory app: real repositories, a fixed clock, and an HTTP client that
/// records every request (no test may reach the network unless it says so).
class Harness {
  Harness(this.now) : db = AppDatabase(NativeDatabase.memory()) {
    investments = DriftInvestmentsRepository(db, () => now);
    assumptions = DriftAssumptionsRepository(db, () => now);
  }

  DateTime now;
  final AppDatabase db;
  late final DriftInvestmentsRepository investments;
  late final DriftAssumptionsRepository assumptions;
  final List<http.BaseRequest> requests = [];
  static Future<http.Response> _noNetwork(http.Request _) async =>
      throw StateError('unexpected network call');
  Future<http.Response> Function(http.Request) handler = _noNetwork;

  /// True when a test installed its own handler, i.e. expects network traffic.
  bool get networkExpected => !identical(handler, _noNetwork);

  Future<void> setup({
    Unit base = egp,
    ZakatYear year = ZakatYear.lunar,
    LongTermMethod? method,
    bool? jewellery,
    Country? home,
  }) => assumptions.saveSettings(
    Settings(
      baseCurrency: base,
      zakatYear: year,
      longTermMethod: method,
      jewelleryZakatable: jewellery,
      homeInflation: home,
    ),
  );

  Future<void> addItem(Investment item, List<HistoryEntry> history) =>
      investments.create(item, history);

  Future<void> rate(Unit from, Unit to, String r, DateTime on) =>
      assumptions.saveTypedRate(Rate(from: from, to: to, rate: d(r), asOf: on));

  Future<List<InvestmentWithHistory>> items() => investments.watchAll().first;
}

Investment item(
  String id, {
  AssetType type = AssetType.fund,
  Unit unit = egp,
  DateTime? start,
  Intent? intent = Intent.trading,
  ZakatRule rule = ZakatRule.trading100,
  Market? market,
  int? karat,
  Decimal? quantity,
  String? name,
}) => Investment(
  id: id,
  name: name ?? id,
  type: type,
  intent: intent,
  market: market,
  unit: unit,
  startDate: start ?? day(2026, 1, 1),
  zakatRule: rule,
  purityKarat: karat,
  quantity: quantity,
);

MoneyIn moneyIn(String id, DateTime on, String amount, [Unit unit = egp]) =>
    MoneyIn(investmentId: id, date: on, amount: Money(d(amount), unit));

ValueUpdate value(String id, DateTime on, String v) =>
    ValueUpdate(investmentId: id, date: on, value: d(v));

MoneyOut moneyOut(
  String id,
  DateTime on,
  String amount, {
  MoneyOutKind kind = MoneyOutKind.sale,
  Unit unit = egp,
}) => MoneyOut(
  investmentId: id,
  date: on,
  amount: Money(d(amount), unit),
  kind: kind,
);

InterestRecord interest(
  String id,
  DateTime on,
  String amount,
  InterestKind kind,
) => InterestRecord(
  investmentId: id,
  date: on,
  amount: Money(d(amount), egp),
  kind: kind,
);

/// Pumps [home] on a fresh [Harness]. [seed] runs before the first frame.
Future<Harness> pumpScreen(
  WidgetTester tester,
  Widget home, {
  Locale locale = en,
  Future<void> Function(Harness h)? seed,
  DateTime? now,
  ShippedInflation? shipped,
  bool settle = true,
}) async {
  assert(_quiet);
  final h = Harness(now ?? day(2026, 10, 16));
  await tester.runAsync(() async => seed?.call(h));
  tester.view.physicalSize = const Size(900, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(h.db),
        clockProvider.overrideWithValue(() => h.now),
        shippedInflationProvider.overrideWith(
          (ref) => shipped ?? defaultShipped(),
        ),
        httpClientProvider.overrideWithValue(
          MockClient((r) {
            h.requests.add(r);
            return h.handler(r);
          }),
        ),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  _active = h;
  return h;
}

Harness? _active;

/// Like [testWidgets], but disposes the tree and closes the database inside
/// the test: drift's stream timers must be gone before the framework checks.
void testScreen(
  String description,
  Future<void> Function(WidgetTester tester) body,
) => testWidgets(description, (tester) async {
  await body(tester);
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
  final h = _active;
  _active = null;
  // The refresher swallows errors, so a stray request would otherwise pass.
  if (h != null && !h.networkExpected) {
    expect(h.requests, isEmpty, reason: 'unexpected network request');
  }
  if (h != null) await tester.runAsync(h.db.close);
});

Future<void> settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 20)),
  );
  await tester.pumpAndSettle();
}

/// Text on screen without the left-to-right isolates around numbers.
String plain(String s) => s.replaceAll('\u2066', '').replaceAll('\u2069', '');

Finder textPlain(Pattern p) => find.byWidgetPredicate((w) {
  if (w is! Text) return false;
  final data = w.data ?? w.textSpan?.toPlainText();
  if (data == null) return false;
  final s = plain(data);
  return p is RegExp ? p.hasMatch(s) : s.contains(p as String);
}, description: 'text containing $p');

AppLocalizations l10nOf(WidgetTester tester, [Finder? at]) =>
    AppLocalizations.of(tester.element(at ?? find.byType(Scaffold).first));

/// Whether the radio row showing [label] is the selected one.
bool radioChecked(WidgetTester tester, String label) {
  final tile = find.ancestor(
    of: find.text(label),
    matching: find.byWidgetPredicate(
      (w) => w.runtimeType.toString().startsWith('RadioListTile<'),
    ),
  );
  final node = tester.getSemantics(tile.first);
  return node.getSemanticsData().flagsCollection.isChecked ==
      CheckedState.isTrue;
}

/// Taps [target] inside a scrollable that builds its children lazily.
Future<void> tapScrolled(
  WidgetTester tester,
  Finder target,
  Finder scrollable,
) async {
  await tester.scrollUntilVisible(target, 200, scrollable: scrollable);
  await tester.tap(target);
  await tester.pumpAndSettle();
}
