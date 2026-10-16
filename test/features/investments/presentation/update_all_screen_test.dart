/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/update_all_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../support/app_harness.dart';

Future<void> seedStale(Harness h) async {
  await h.setup();
  await h.rate(usd, egp, '50', day(2026, 9, 30));
  await h.addItem(
    item(
      'us',
      name: 'US stock',
      unit: usd,
      intent: Intent.trading,
      type: AssetType.stock,
    ),
    [
      moneyIn('us', day(2026, 1, 1), '100', usd),
      value('us', day(2026, 9, 30), '120'),
    ],
  );
  await h.addItem(item('fund', name: 'Fund A'), [
    moneyIn('fund', day(2026, 1, 1), '1000'),
    value('fund', day(2026, 9, 30), '1100'),
  ]);
  await h.addItem(item('fresh', name: 'Fresh fund'), [
    moneyIn('fresh', day(2026, 1, 1), '1000'),
    value('fresh', day(2026, 10, 5), '1100'),
  ]);
  await h.addItem(
    item(
      'gold',
      name: 'Gold',
      type: AssetType.gold,
      unit: xauG,
      intent: Intent.longTerm,
      rule: ZakatRule.bullion100,
      karat: 24,
    ),
    [
      moneyIn('gold', day(2026, 1, 1), '40000'),
      value('gold', day(2026, 1, 1), '10'),
    ],
  );
}

Finder input(String key) => find.descendant(
  of: find.byKey(ValueKey(key)),
  matching: find.byType(TextField),
);

Future<List<Rate>> rates(WidgetTester tester, Harness h) async {
  late List<Rate> r;
  await tester.runAsync(() async => r = await h.assumptions.watchRates().first);
  return r;
}

Future<List<InvestmentWithHistory>> items(
  WidgetTester tester,
  Harness h,
) async {
  late List<InvestmentWithHistory> r;
  await tester.runAsync(() async => r = await h.items());
  return r;
}

void main() {
  for (final locale in [en, ar]) {
    group('S6 update all (${locale.languageCode})', () {
      testScreen(
        'AC-25: opening the screen makes no network call; it lists what is stale',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const UpdateAllScreen(),
            locale: locale,
            seed: seedStale,
          );
          final l10n = l10nOf(tester);
          expect(h.requests, isEmpty);
          expect(find.byKey(const ValueKey('item-us')), findsOneWidget);
          expect(find.byKey(const ValueKey('item-fund')), findsOneWidget);
          expect(find.byKey(const ValueKey('item-fresh')), findsNothing);
          expect(find.byKey(const ValueKey('item-gold')), findsNothing);
          expect(find.byKey(const ValueKey('rate-USD-EGP')), findsOneWidget);
          expect(find.text(l10n.filledCount('0', '4')), findsOneWidget);
          expect(find.text(l10n.refreshHelp), findsOneWidget);
        },
      );

      testScreen(
        'Same copies the last value; the counter follows what is filled',
        (tester) async {
          await pumpScreen(
            tester,
            const UpdateAllScreen(),
            locale: locale,
            seed: seedStale,
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.byKey(const ValueKey('same-fund')));
          await tester.pumpAndSettle();
          expect(
            tester.widget<TextField>(input('item-fund')).controller!.text,
            '1100',
          );
          expect(find.text(l10n.filledCount('1', '4')), findsOneWidget);
          await tester.enterText(input('rate-USD-EGP'), '51');
          await tester.pumpAndSettle();
          expect(find.text(l10n.filledCount('2', '4')), findsOneWidget);
        },
      );

      testScreen(
        'Save writes typed rates (via the fixed upsert) and value updates on the chosen day',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const UpdateAllScreen(),
            locale: locale,
            seed: seedStale,
          );
          await tester.enterText(input('rate-USD-EGP'), '51.5');
          await tester.enterText(input('item-us'), '130');
          await tester.enterText(input('item-fund'), '1250');
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('update-save')));
          await tester.pumpAndSettle();
          final r = await rates(tester, h);
          final fresh = r.firstWhere((x) => x.asOf == day(2026, 10, 16));
          expect(
            (fresh.from, fresh.to, fresh.rate),
            (usd, egp, Decimal.parse('51.5')),
          );
          expect(fresh.source, RateSource.typed);
          final all = await items(tester, h);
          Decimal? latest(String id) =>
              (all
                      .firstWhere((x) => x.investment.id == id)
                      .history
                      .whereType<ValueUpdate>()
                      .toList()
                    ..sort((a, b) => a.date.compareTo(b.date)))
                  .last
                  .value;
          expect(latest('us'), Decimal.parse('130'));
          expect(latest('fund'), Decimal.parse('1250'));
          expect(h.requests, isEmpty);
        },
      );

      testScreen('blank rows are skipped, not errors', (tester) async {
        final h = await pumpScreen(
          tester,
          const UpdateAllScreen(),
          locale: locale,
          seed: seedStale,
        );
        await tester.enterText(input('item-fund'), '1250');
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('update-save')));
        await tester.pumpAndSettle();
        final r = await rates(tester, h);
        expect(r.length, 1);
        final us = (await items(
          tester,
          h,
        )).firstWhere((x) => x.investment.id == 'us');
        expect(us.history.whereType<ValueUpdate>().length, 1);
      });

      testScreen('AC-29: offline, the refresh changes nothing and says so', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const UpdateAllScreen(),
          locale: locale,
          seed: seedStale,
        );
        h.handler = (_) async => throw const SocketException('offline');
        final l10n = l10nOf(tester);
        final before = (await rates(tester, h)).map((r) => r.id).toList();
        await tester.tap(find.byKey(const ValueKey('refresh')));
        await settle(tester);
        expect(find.text(l10n.refreshFailed), findsOneWidget);
        expect(h.requests.length, 2);
        expect((await rates(tester, h)).map((r) => r.id).toList(), before);
        expect(find.byKey(const ValueKey('rate-USD-EGP')), findsOneWidget);
      });

      testScreen(
        'AC-27: a refresh stores the source date, tells how many rates it updated, and clears the stale row',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const UpdateAllScreen(),
            locale: locale,
            seed: seedStale,
          );
          h.handler = (_) async => http.Response(
            '{"date":"2026-10-15","usd":{"egp":48.5,"usd":1}}',
            200,
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.byKey(const ValueKey('refresh')));
          await settle(tester);
          final status = tester.widget<Text>(
            find.byKey(const ValueKey('refresh-status')),
          );
          expect(plain(status.data!), contains('1'));
          expect(status.data, contains(l10n.refreshSource));
          final stored = (await rates(
            tester,
            h,
          )).where((r) => r.source == RateSource.currencyApi).toList();
          expect(stored.single.asOf, day(2026, 10, 15));
          expect(stored.single.rate, Decimal.parse('48.5'));
          expect(h.requests.length, 1);
          expect(find.byKey(const ValueKey('rate-USD-EGP')), findsNothing);
          expect(find.text(l10n.filledCount('0', '3')), findsOneWidget);
        },
      );

      testScreen('Show all lists every open item and every rate in use', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const UpdateAllScreen(),
          locale: locale,
          seed: seedStale,
        );
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('item-fresh')), findsOneWidget);
        expect(find.byKey(const ValueKey('rate-XAU-g-EGP')), findsOneWidget);
      });

      testScreen(
        'with nothing stale the screen says everything is up to date',
        (tester) async {
          await pumpScreen(
            tester,
            const UpdateAllScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('f'), [
                moneyIn('f', day(2026, 1, 1), '10'),
                value('f', day(2026, 10, 3), '11'),
              ]);
            },
          );
          expect(
            textPlain(
              plain(l10nOf(tester).allUpToDate('').split('2026').first.trim()),
            ),
            findsOneWidget,
          );
        },
      );
    });
  }
}
