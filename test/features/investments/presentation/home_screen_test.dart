/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/format.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/home_screen.dart';
import 'package:financial_planner/features/investments/presentation/investment_form_screen.dart';
import 'package:financial_planner/features/investments/presentation/item_detail_screen.dart';
import 'package:financial_planner/features/investments/presentation/period_screen.dart';
import 'package:financial_planner/features/investments/presentation/update_all_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/plan_seeds.dart';

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

void main() {
  for (final locale in [en, ar]) {
    final rtl = locale == ar;
    group('S2 home (${locale.languageCode})', () {
      testScreen(
        'an empty list offers to add the first investment, with presets',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.emptyTitle), findsOneWidget);
          expect(find.text(l10n.dataStaysOnPhone), findsOneWidget);
          expect(find.byType(FloatingActionButton), findsNothing);
          expect(
            Directionality.of(tester.element(find.byType(Scaffold))),
            rtl ? TextDirection.rtl : TextDirection.ltr,
          );
          await tester.tap(find.text(l10n.presetGold));
          await tester.pumpAndSettle();
          expect(find.byType(InvestmentFormScreen), findsOneWidget);
          expect(find.text(l10n.formTitleAdd), findsOneWidget);
        },
      );

      testScreen('totals, the verdict and its inflation tag', (tester) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: seedBasic,
        );
        final l10n = l10nOf(tester);
        final total = tester.widget<Text>(
          find.byKey(const ValueKey('total-value')),
        );
        expect(plain(total.data!), contains('2,600.00'));
        final asOf = isolateLtr(
          MaterialLocalizations.of(tester.element(find.byType(Scaffold)))
              .formatMediumDate(day(2026, 10, 16)),
        );
        expect(find.text(l10n.asOfDate(asOf)), findsOneWidget);
        final verdict = tester.widget<Text>(
          find.byKey(const ValueKey('verdict')),
        );
        expect(verdict.data, contains('2026'));
        expect(
          verdict.data,
          startsWith(l10n.verdictKept('2026', '').split(' ').first),
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
      });

      testScreen(
        'both items are listed with value and return; sort by name reorders',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: seedBasic,
          );
          final l10n = l10nOf(tester);
          double top(String name) => tester.getTopLeft(find.text(name)).dy;
          expect(top('Fund A'), lessThan(top('Fund B')));
          expect(textPlain('2,000.00'), findsWidgets);
          expect(textPlain('+100.00 %'), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('sort')));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.sortName).last);
          await tester.pumpAndSettle();
          expect(top('Fund A'), lessThan(top('Fund B')));
          await tester.tap(find.byKey(const ValueKey('sort')));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.sortOldest).last);
          await tester.pumpAndSettle();
          expect(top('Fund B'), lessThan(top('Fund A')));
        },
      );

      testScreen('stale values are marked and the banner leads to Update all', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: seedBasic,
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.notUpdatedThisMonth), findsOneWidget);
        expect(find.text(l10n.staleBanner('1', '0')), findsOneWidget);
        await tester.tap(find.text(l10n.updateAll));
        await tester.pumpAndSettle();
        expect(find.byType(UpdateAllScreen), findsOneWidget);
      });

      testScreen(
        'AC-21: an item with no rate is left out of the total and named',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
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
            findsOneWidget,
          );
          expect(textPlain('USD→EGP'), findsWidgets);
          expect(find.text(l10n.rateMissingAdd('USD', 'EGP')), findsOneWidget);
          final total = tester.widget<Text>(
            find.byKey(const ValueKey('total-value')),
          );
          expect(plain(total.data!), contains('2,600.00'));
          await tester.tap(find.text(l10n.rateMissingAdd('USD', 'EGP')));
          await tester.pumpAndSettle();
          expect(find.byType(ItemDetailScreen), findsOneWidget);
        },
      );

      testScreen('AC-19: interest to purify is shown on its own', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
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
        expect(
          textPlain(plain(l10n.toPurifyLine('500.00 EGP'))),
          findsOneWidget,
        );
        final total = tester.widget<Text>(
          find.byKey(const ValueKey('total-value')),
        );
        expect(plain(total.data!), contains('10,000.00'));
        await tester.tap(textPlain(plain(l10n.toPurifyLine('500.00 EGP'))));
        await tester.pumpAndSettle();
        expect(find.text(l10n.whyToPurifyTitle), findsOneWidget);
        expect(find.text(l10n.src_Z6), findsOneWidget);
      });

      testScreen('the grams view shows the total in grams of gold', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.rate(xauG, egp, '4000', day(2025, 12, 31));
            await h.rate(xauG, egp, '4000', day(2026, 10, 2));
            await h.addItem(item('fund', name: 'Fund'), [
              moneyIn('fund', day(2026, 1, 1), '40000'),
              value('fund', day(2026, 10, 3), '40000'),
            ]);
          },
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.text(l10n.viewGold));
        await tester.pumpAndSettle();
        final total = tester.widget<Text>(
          find.byKey(const ValueKey('total-value')),
        );
        expect(plain(total.data!), '10.00 g');
      });

      testScreen('closed investments are collapsed under their own heading', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: (h) async {
            await seedBasic(h);
            await h.addItem(item('old', name: 'Old fund'), [
              moneyIn('old', day(2026, 1, 1), '100'),
              moneyOut('old', day(2026, 3, 1), '100'),
              value('old', day(2026, 3, 1), '0'),
            ]);
          },
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.closedSection('1')), findsOneWidget);
        expect(find.text('Old fund'), findsNothing);
        await tester.tap(find.text(l10n.closedSection('1')));
        await tester.pumpAndSettle();
        expect(find.text('Old fund'), findsOneWidget);
      });

      testScreen(
        'tapping the verdict opens the year view; a row opens its detail',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: seedBasic,
          );
          await tester.tap(find.byKey(const ValueKey('verdict')));
          await tester.pumpAndSettle();
          expect(find.byType(PeriodScreen), findsOneWidget);
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          await tester.tap(find.text('Fund A'));
          await tester.pumpAndSettle();
          expect(find.byType(ItemDetailScreen), findsOneWidget);
        },
      );
      testScreen(
        'AC-51, AC-75: rows show "3 to confirm" and "2 to confirm" (5 in all); after Confirm all on the project only "2"',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            now: day(2026, 10, 17),
            seed: (h) async {
              await seedFriend(h);
              await h.addItem(planFund(start: day(2026, 8, 17)), [
                moneyIn('fund', day(2026, 8, 17), '10000'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.toConfirmPill(3)), findsOneWidget);
          expect(find.text(l10n.toConfirmPill(2)), findsOneWidget);
          await tester.runAsync(
            () => h.investments.saveEntries([
              for (final m in [4, 7, 10])
                moneyOut(
                  'fp',
                  day(2026, m, 15),
                  '5000',
                  kind: MoneyOutKind.income,
                ),
            ]),
          );
          await settle(tester);
          expect(find.text(l10n.toConfirmPill(3)), findsNothing);
          expect(find.text(l10n.toConfirmPill(2)), findsOneWidget);
        },
      );

      testScreen('AC-56: a closed item is not counted', (tester) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          now: day(2027, 2, 1),
          seed: (h) => seedFriend(
            h,
            more: [
              moneyOut('fp', day(2026, 12, 1), '100000'),
              value('fp', day(2026, 12, 1), '0'),
            ],
          ),
        );
        expect(find.byKey(const ValueKey('to-confirm-fp')), findsNothing);
      });
    });
  }
}
