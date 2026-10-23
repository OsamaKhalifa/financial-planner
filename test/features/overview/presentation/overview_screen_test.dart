/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/home_screen.dart';
import 'package:financial_planner/features/investments/presentation/investment_form_screen.dart';
import 'package:financial_planner/features/investments/presentation/period_screen.dart';
import 'package:financial_planner/features/investments/presentation/update_all_screen.dart';
import 'package:financial_planner/features/overview/presentation/overview_screen.dart';
import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

/// Fund A 1,000 → 2,000 (updated this month), Fund B 500 → 600 (stale).
Future<void> seedBasic(Harness h) async {
  await h.setup();
  await h.addItem(item('fundA', name: 'Fund A'), [
    moneyIn('fundA', day(2026, 1, 1), '1000'),
    value('fundA', day(2026, 10, 10), '2000'),
  ]);
  await h.addItem(item('fundB', name: 'Fund B'), [
    moneyIn('fundB', day(2026, 1, 1), '500'),
    value('fundB', day(2026, 8, 1), '600'),
  ]);
}

String textOf(WidgetTester tester, String key) =>
    plain(tester.widget<Text>(find.byKey(ValueKey(key))).data!);

String rowValue(WidgetTester tester, String key) => plain(
  tester
      .widgetList<Text>(
        find.descendant(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(Text),
        ),
      )
      .last
      .data!,
);

void main() {
  for (final locale in [en, ar]) {
    group('Overview (${locale.languageCode})', () {
      testScreen('no items: the empty state, no 0.00 totals', (tester) async {
        await pumpScreen(
          tester,
          const OverviewScreen(),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.emptyTitle), findsOneWidget);
        expect(find.byKey(const ValueKey('overview-total')), findsNothing);
        expect(textPlain('0.00'), findsNothing);
        await tester.tap(find.text(l10n.addInvestment));
        await tester.pumpAndSettle();
        expect(find.byType(InvestmentFormScreen), findsOneWidget);
      });

      testScreen('total, this year, by type and since start match Home', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const OverviewScreen(),
          locale: locale,
          seed: seedBasic,
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.overviewTotal), findsOneWidget);
        expect(textOf(tester, 'overview-total'), contains('2,600.00'));
        expect(textOf(tester, 'overview-verdict'), contains('2026'));
        expect(find.text(l10n.rowSetAside), findsOneWidget);
        expect(find.text(l10n.setAsideNote), findsOneWidget);
        expect(find.text(l10n.realLabel), findsOneWidget);
        expect(find.byKey(const ValueKey('type-fund')), findsOneWidget);
        expect(textPlain('100.00 %'), findsWidgets);
        expect(rowValue(tester, 'since-gain'), contains('+1,100.00'));
        expect(rowValue(tester, 'since-roi'), contains('73.33 %'));
        expect(find.text(l10n.shariahCheckTitle), findsOneWidget);
        expect(find.text(l10n.shariahNoScreening), findsOneWidget);
        expect(find.text(l10n.exposureRisk), findsNothing);
        expect(find.text(l10n.exposureCrypto), findsNothing);
        expect(find.byKey(const ValueKey('overview-purify')), findsNothing);
      });

      testScreen('the stale line leads to Update all', (tester) async {
        await pumpScreen(
          tester,
          const OverviewScreen(),
          locale: locale,
          seed: seedBasic,
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.staleBanner('1', '0')), findsOneWidget);
        await tester.ensureVisible(find.text(l10n.updateAll));
        await tester.tap(find.text(l10n.updateAll));
        await tester.pumpAndSettle();
        expect(find.byType(UpdateAllScreen), findsOneWidget);
      });

      testScreen('this year opens the year view', (tester) async {
        await pumpScreen(
          tester,
          const OverviewScreen(),
          locale: locale,
          seed: seedBasic,
        );
        await tester.tap(find.byKey(const ValueKey('overview-verdict')));
        await tester.pumpAndSettle();
        expect(find.byType(PeriodScreen), findsOneWidget);
      });

      testScreen('crypto shows in the Shariah check with its notice', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const OverviewScreen(),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.addItem(
              item(
                'btc',
                name: 'Coin',
                type: AssetType.crypto,
                intent: null,
                rule: ZakatRule.crypto100,
              ),
              [
                moneyIn('btc', day(2026, 1, 1), '3000'),
                value('btc', day(2026, 10, 1), '2500'),
              ],
            );
          },
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.shariahCheckTitle), findsOneWidget);
        expect(find.text(l10n.exposureCrypto), findsOneWidget);
        expect(find.text(l10n.noticeCrypto), findsOneWidget);
        expect(find.text(l10n.exposureRisk), findsNothing);
      });

      testScreen('tapping the total opens the Investments tab', (tester) async {
        await pumpScreen(
          tester,
          const RootGate(),
          locale: locale,
          seed: seedBasic,
        );
        expect(find.byType(OverviewScreen), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('overview-total')));
        await tester.pumpAndSettle();
        expect(find.text('Fund A'), findsOneWidget);
        expect(find.byType(HomeScreen), findsOneWidget);
      });
    });
  }
}
