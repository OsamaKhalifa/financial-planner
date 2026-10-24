/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/format.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/home_screen.dart';
import 'package:financial_planner/features/investments/presentation/investment_form_screen.dart';
import 'package:financial_planner/features/investments/presentation/item_detail_screen.dart';
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

      testScreen('the app bar names the tab and carries one Settings gear', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: seedBasic,
        );
        final l10n = l10nOf(tester);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.text(l10n.tabInvestments),
          ),
          findsOneWidget,
        );
        expect(find.text(l10n.appTitle), findsNothing);
        expect(find.byIcon(Icons.tune), findsNothing);
        expect(find.byTooltip(l10n.settings), findsOneWidget);
      });

      testScreen('nothing stale: a quiet up-to-date line leads to Update all', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          now: day(2026, 10, 16),
          seed: (h) async {
            await h.setup();
            await h.addItem(item('fundA', name: 'Fund A'), [
              moneyIn('fundA', day(2026, 1, 1), '1000'),
              value('fundA', day(2026, 10, 10), '2000'),
            ]);
          },
        );
        final l10n = l10nOf(tester);
        expect(find.byKey(const ValueKey('up-to-date')), findsOneWidget);
        expect(find.textContaining(l10n.staleBanner('1', '0')), findsNothing);
        await tester.tap(find.text(l10n.updateAll));
        await tester.pumpAndSettle();
        expect(find.byType(UpdateAllScreen), findsOneWidget);
      });

      testScreen('an empty list shows neither banner nor up-to-date line', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(find.byKey(const ValueKey('up-to-date')), findsNothing);
        expect(find.text(l10n.updateAll), findsNothing);
      });

      testScreen('AC-21: an item with no rate is named on its row', (
        tester,
      ) async {
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
        expect(find.text(l10n.rateMissingAdd('USD', 'EGP')), findsOneWidget);
        await tester.tap(find.text(l10n.rateMissingAdd('USD', 'EGP')));
        await tester.pumpAndSettle();
        expect(find.byType(ItemDetailScreen), findsOneWidget);
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

      testScreen('no totals card; a row opens its detail', (tester) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: seedBasic,
        );
        expect(find.byKey(const ValueKey('total-value')), findsNothing);
        expect(find.text(l10nOf(tester).viewGold), findsNothing);
        await tester.tap(find.text('Fund A'));
        await tester.pumpAndSettle();
        expect(find.byType(ItemDetailScreen), findsOneWidget);
      });
      String rowText(WidgetTester tester, String key) =>
          plain(tester.widget<Text>(find.byKey(ValueKey(key))).data!);

      String pct(String fraction, {bool signed = true}) {
        final s = formatPercent(
          Decimal.parse(fraction),
          locale.languageCode,
          digits: 0,
        );
        return plain(signed ? s : s.replaceAll('+', ''));
      }

      Investment flat() => Investment(
        id: 'flat',
        name: 'شقة مدينتي',
        type: AssetType.other,
        intent: Intent.personalUse,
        unit: egp,
        startDate: day(2026, 1, 1),
        zakatRule: ZakatRule.custom,
        customZakatShare: Decimal.zero,
        valueCheckSchedule: Schedule.monthly,
        expectedGrowth: Decimal.parse('0.03'),
      );

      Investment madinty() => Investment(
        id: 'mre',
        name: 'Madinty real estate',
        type: AssetType.other,
        intent: Intent.rental,
        unit: egp,
        startDate: day(2026, 1, 15),
        zakatRule: ZakatRule.custom,
        customZakatShare: Decimal.zero,
        payoutSchedule: Schedule.quarterly,
        expectedProfit: Decimal.parse('0.32'),
      );

      Future<void> seedAc79(Harness h, {bool moved = false}) async {
        await h.setup(base: usd);
        if (moved) {
          await h.rate(usd, egp, '50', day(2026, 1, 15));
          await h.rate(usd, egp, '55', day(2026, 10, 15));
        } else {
          await h.rate(usd, egp, '52', day(2026, 1, 1));
        }
        await h.addItem(flat(), [moneyIn('flat', day(2026, 1, 1), '4913500')]);
        await h.addItem(madinty(), [
          moneyIn('mre', day(2026, 1, 15), '1000000'),
          value('mre', day(2026, 10, 15), '1100000'),
        ]);
      }

      testScreen(
        'AC-79: rows show type, own-unit value big, base value small, own-unit return and the estimate line',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: seedAc79,
          );
          final l10n = l10nOf(tester);
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-flat')),
              matching: find.text(l10n.typeOther),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-mre')),
              matching: find.text(l10n.typeOther),
            ),
            findsOneWidget,
          );
          expect(rowText(tester, 'value-own-flat'), '4,913,500.00 EGP');
          expect(rowText(tester, 'value-base-flat'), '94,490.38 USD');
          expect(rowText(tester, 'return-flat'), '0.00 %');
          expect(
            rowText(tester, 'plan-flat'),
            plain(l10n.rowPlanGrowth(pct('0.03'))),
          );
          expect(rowText(tester, 'value-own-mre'), '1,100,000.00 EGP');
          expect(rowText(tester, 'value-base-mre'), '21,153.85 USD');
          expect(rowText(tester, 'return-mre'), '+10.00 %');
          expect(
            rowText(tester, 'plan-mre'),
            plain(l10n.rowPlanProfit(pct('0.32', signed: false))),
          );
          for (final id in ['mre', 'flat']) {
            final big = tester.widget<Text>(
              find.byKey(ValueKey('value-own-$id')),
            );
            final small = tester.widget<Text>(
              find.byKey(ValueKey('value-base-$id')),
            );
            expect(
              big.style!.fontSize!,
              greaterThan(small.style!.fontSize!),
              reason: id,
            );
          }
          expect(
            tester.getTopLeft(find.byKey(const ValueKey('value-own-mre'))).dy,
            lessThan(
              tester
                  .getTopLeft(find.byKey(const ValueKey('value-base-mre')))
                  .dy,
            ),
          );
        },
      );

      testScreen(
        'AC-79: with 50 then 55 EGP per USD the row shows 20,000.00 USD and the EGP return +10.00 %, not 0.00 %',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: (h) => seedAc79(h, moved: true),
          );
          expect(rowText(tester, 'value-own-mre'), '1,100,000.00 EGP');
          expect(rowText(tester, 'value-base-mre'), '20,000.00 USD');
          expect(rowText(tester, 'return-mre'), '+10.00 %');
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-mre')),
              matching: textPlain(RegExp(r'^0\.00 %$')),
            ),
            findsNothing,
          );
        },
      );

      testScreen(
        'AC-79: gold at 100 then 110 USD per gram shows grams, 5,500.00 USD and the USD return +10.00 %; type, not grams, on the start side',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup(base: usd);
              await h.rate(xauG, usd, '100', day(2026, 1, 1));
              await h.rate(xauG, usd, '110', day(2026, 10, 16));
              await h.addItem(
                item(
                  'g',
                  name: 'My gold',
                  type: AssetType.gold,
                  unit: xauG,
                  intent: Intent.longTerm,
                  rule: ZakatRule.bullion100,
                  karat: 24,
                ),
                [
                  moneyIn('g', day(2026, 1, 1), '5000', usd),
                  value('g', day(2026, 1, 1), '50'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(rowText(tester, 'value-own-g'), '50.00 g');
          expect(rowText(tester, 'value-base-g'), '5,500.00 USD');
          expect(rowText(tester, 'return-g'), '+10.00 %');
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-g')),
              matching: textPlain(RegExp(r'^0\.00 %$')),
            ),
            findsNothing,
          );
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-g')),
              matching: find.text(l10n.typeGold),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-g')),
              matching: textPlain(RegExp(r'[0-9٠-٩] g$')),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-79: both estimates on one line; neither → no line; a base-currency item shows its value once',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup(base: usd);
              await h.addItem(
                Investment(
                  id: 'both',
                  name: 'Both',
                  type: AssetType.fund,
                  intent: Intent.trading,
                  unit: usd,
                  startDate: day(2026, 1, 1),
                  zakatRule: ZakatRule.trading100,
                  payoutSchedule: Schedule.monthly,
                  expectedProfit: Decimal.parse('0.32'),
                  valueCheckSchedule: Schedule.monthly,
                  expectedGrowth: Decimal.parse('0.03'),
                ),
                [moneyIn('both', day(2026, 1, 1), '1000', usd)],
              );
              await h.addItem(item('none', unit: usd), [
                moneyIn('none', day(2026, 1, 1), '1000', usd),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(
            rowText(tester, 'plan-both'),
            plain(l10n.rowPlanBoth(pct('0.32', signed: false), pct('0.03'))),
          );
          expect(find.byKey(const ValueKey('plan-none')), findsNothing);
          expect(find.byKey(const ValueKey('value-base-both')), findsNothing);
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('item-both')),
              matching: textPlain('1,000.00 USD'),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-79: on a 320 pt screen both estimates split into two lines and nothing overflows',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(
                Investment(
                  id: 'both',
                  name: 'شقة مدينتي',
                  type: AssetType.other,
                  intent: Intent.personalUse,
                  unit: egp,
                  startDate: day(2026, 1, 1),
                  zakatRule: ZakatRule.custom,
                  customZakatShare: Decimal.zero,
                  payoutSchedule: Schedule.monthly,
                  expectedProfit: Decimal.parse('0.32'),
                  valueCheckSchedule: Schedule.monthly,
                  expectedGrowth: Decimal.parse('0.03'),
                ),
                [moneyIn('both', day(2026, 1, 1), '4913500')],
              );
            },
          );
          tester.view.physicalSize = const Size(320, 2400);
          await tester.pumpAndSettle();
          final l10n = l10nOf(tester);
          expect(tester.takeException(), isNull);
          expect(
            rowText(tester, 'plan-both'),
            plain(l10n.rowPlanProfit(pct('0.32', signed: false))),
          );
          expect(
            rowText(tester, 'plan2-both'),
            plain(l10n.rowPlanGrowthOnly(pct('0.03'))),
          );
          expect(rowText(tester, 'value-own-both'), '4,913,500.00 EGP');
        },
      );

      testScreen(
        'AC-79: at text scale 1.3 the end column moves under the start column',
        (tester) async {
          await pumpScreen(
            tester,
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
              child: const HomeScreen(),
            ),
            locale: locale,
            seed: seedAc79,
          );
          expect(tester.takeException(), isNull);
          final type = find.descendant(
            of: find.byKey(const ValueKey('item-mre')),
            matching: find.text(l10nOf(tester).typeOther),
          );
          expect(
            tester.getTopLeft(find.byKey(const ValueKey('value-own-mre'))).dy,
            greaterThan(tester.getBottomLeft(type).dy),
          );
        },
      );

      testScreen(
        'AC-79: VoiceOver reads name, type, values, return, estimate, then status and pill',
        (tester) async {
          final handle = tester.ensureSemantics();
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            now: day(2026, 2, 5),
            seed: (h) async {
              await h.setup(base: usd);
              await h.rate(usd, egp, '52', day(2026, 1, 1));
              await h.addItem(flat(), [
                moneyIn('flat', day(2026, 1, 1), '4913500'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          final label = plain(
            tester.getSemantics(find.byKey(const ValueKey('item-flat'))).label,
          );
          final order = [
            'شقة مدينتي',
            l10n.typeOther,
            '4,913,500.00 EGP',
            '94,490.38 USD',
            '${l10n.sortReturn}: 0.00 %',
            plain(l10n.rowPlanGrowth(pct('0.03'))),
            l10n.toConfirmPill(1),
          ];
          var at = -1;
          for (final part in order) {
            final i = label.indexOf(part);
            expect(i, greaterThan(at), reason: '$part in $label');
            at = i;
          }
          handle.dispose();
        },
      );

      testScreen('AC-79: sort by Return uses the return shown on the row', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HomeScreen(),
          locale: locale,
          seed: (h) async {
            await h.setup(base: usd);
            await h.rate(usd, egp, '50', day(2026, 1, 15));
            await h.rate(usd, egp, '55', day(2026, 10, 15));
            await h.addItem(madinty(), [
              moneyIn('mre', day(2026, 1, 15), '1000000'),
              value('mre', day(2026, 10, 15), '1100000'),
            ]);
            await h.addItem(item('u', name: 'USD fund', unit: usd), [
              moneyIn('u', day(2026, 1, 15), '1000', usd),
              value('u', day(2026, 10, 15), '1050'),
            ]);
          },
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.byKey(const ValueKey('sort')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.sortReturn).last);
        await tester.pumpAndSettle();
        expect(
          tester.getTopLeft(find.text('Madinty real estate')).dy,
          lessThan(tester.getTopLeft(find.text('USD fund')).dy),
        );
      });

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
          expect(find.byKey(const ValueKey('to-confirm-fp')), findsOneWidget);
          expect(find.byKey(const ValueKey('to-confirm-fund')), findsOneWidget);
          expect(find.text(l10n.toConfirmPill(5)), findsNothing);
          await tester.tap(find.text("Friend's project"));
          await settle(tester);
          await tester.tap(find.byKey(const ValueKey('confirm-all')));
          await settle(tester);
          final fp = (await tester.runAsync(() => h.items()))!
              .firstWhere((x) => x.investment.id == 'fp');
          expect(fp.history.whereType<MoneyOut>().length, 3);
          Navigator.of(tester.element(find.byType(ItemDetailScreen))).pop();
          await settle(tester);
          expect(find.byKey(const ValueKey('to-confirm-fp')), findsNothing);
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
      testScreen(
        'A5: "oldest first" ignores skip dates (a skip is not an update)',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('a', name: 'Fund A'), [
                moneyIn('a', day(2026, 1, 1), '1000'),
                value('a', day(2026, 9, 1), '1000'),
              ]);
              await h.addItem(item('b', name: 'Fund B'), [
                moneyIn('b', day(2026, 1, 1), '1000'),
                value('b', day(2026, 8, 1), '1000'),
                PlanSkip(
                  investmentId: 'b',
                  date: day(2026, 10, 1),
                  plan: PlanKind.value,
                ),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.byKey(const ValueKey('sort')));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.sortOldest).last);
          await tester.pumpAndSettle();
          expect(
            tester.getTopLeft(find.text('Fund B')).dy,
            lessThan(tester.getTopLeft(find.text('Fund A')).dy),
          );
        },
      );
      testScreen(
        'AC-72: ✓ April then Undo: no income, April pending at 5,000.00, Home still "3 to confirm"',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            now: day(2026, 10, 17),
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.text("Friend's project"));
          await settle(tester);
          await tester.tap(
            find.byKey(const ValueKey('check-payout-2026-04-15')),
          );
          await settle(tester);
          await tester.tap(find.text(l10n.undo));
          await settle(tester);
          final history = (await tester.runAsync(() => h.items()))!
              .single
              .history;
          expect(history.whereType<MoneyOut>(), isEmpty);
          expect(
            find.byKey(const ValueKey('check-payout-2026-04-15')),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('row-payout-2026-04-15')),
              matching: textPlain(RegExp(r'^5,000\.00 EGP$')),
            ),
            findsOneWidget,
          );
          Navigator.of(tester.element(find.byType(ItemDetailScreen))).pop();
          await settle(tester);
          expect(find.text(l10n.toConfirmPill(3)), findsOneWidget);
        },
      );
    });
  }
}
