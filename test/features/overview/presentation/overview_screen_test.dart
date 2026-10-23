/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/format.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
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
        final asOf = isolateLtr(
          MaterialLocalizations.of(tester.element(find.byType(Scaffold)))
              .formatMediumDate(day(2026, 10, 16)),
        );
        expect(find.text(l10n.asOfDate(asOf)), findsOneWidget);
        expect(textOf(tester, 'overview-verdict'), contains('2026'));
        expect(
          textOf(tester, 'overview-verdict'),
          startsWith(plain(l10n.verdictKept('2026', '').split(' ').first)),
        );
        expect(
          find.text(
            l10n.inflationShipped(
              l10n.countryName('EGY'),
              l10n.sourceName,
              '2026',
            ),
          ),
          findsOneWidget,
        );
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

      testScreen(
        'AC-21: an item with no rate is left out of the total and named',
        (tester) async {
          await pumpScreen(
            tester,
            const OverviewScreen(),
            locale: locale,
            seed: (h) async {
              await seedBasic(h);
              await h.addItem(
                item(
                  'us',
                  name: 'US stock',
                  type: AssetType.stock,
                  unit: usd,
                  market: Market.nasdaq,
                ),
                [
                  moneyIn('us', day(2026, 2, 1), '100', usd),
                  value('us', day(2026, 10, 2), '120'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(
            textPlain(l10n.excludesItems('1', '').split(' — ').first),
            findsWidgets,
          );
          expect(find.text(l10n.sinceStartExcludes('1')), findsOneWidget);
          expect(textPlain('USD→EGP'), findsWidgets);
          expect(textOf(tester, 'overview-total'), contains('2,600.00'));
        },
      );

      testScreen('AC-19: interest to purify is shown on its own', (
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
                'dep',
                type: AssetType.cashDeposit,
                intent: null,
                rule: ZakatRule.cash100,
              ),
              [
                moneyIn('dep', day(2026, 1, 1), '10000'),
                interest(
                  'dep',
                  day(2026, 6, 30),
                  '500',
                  InterestKind.keptInside,
                ),
                value('dep', day(2026, 10, 5), '10500'),
              ],
            );
          },
        );
        final l10n = l10nOf(tester);
        expect(textOf(tester, 'overview-purify'), contains('500.00'));
        expect(textOf(tester, 'overview-total'), contains('10,000.00'));
        await tester.ensureVisible(
          find.byKey(const ValueKey('overview-purify')),
        );
        await tester.tap(find.byKey(const ValueKey('overview-purify')));
        await tester.pumpAndSettle();
        expect(find.text(l10n.whyToPurifyTitle), findsOneWidget);
        expect(find.text(l10n.src_Z6), findsOneWidget);
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
