/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/investment_form_screen.dart';
import 'package:financial_planner/features/investments/presentation/item_detail_screen.dart';
import 'package:financial_planner/features/investments/presentation/period_screen.dart';
import 'package:financial_planner/features/investments/presentation/record_sheet.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';
import 'package:financial_planner/core/money/money.dart';

import '../../../support/app_harness.dart';
import '../../../support/plan_seeds.dart';

Future<void> seedUsStock(Harness h) async {
  await h.setup();
  await h.rate(usd, egp, '50', day(2025, 12, 31));
  await h.rate(usd, egp, '55', day(2026, 10, 10));
  await h.addItem(
    item(
      'us',
      name: 'US stock',
      type: AssetType.stock,
      unit: usd,
      market: Market.nasdaq,
      start: day(2025, 12, 31),
      intent: Intent.trading,
    ),
    [
      moneyIn('us', day(2025, 12, 31), '1000', usd),
      value('us', day(2026, 10, 10), '1050'),
    ],
  );
}

Future<void> scrollTo(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(
    f,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in [en, ar]) {
    group('S4 item detail (${locale.languageCode})', () {
      testScreen(
        'shows the value in both units and the since-start figures in two columns',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'us'),
            locale: locale,
            seed: seedUsStock,
          );
          final l10n = l10nOf(tester);
          expect(
            plain(
              tester
                  .widget<Text>(find.byKey(const ValueKey('value-now')))
                  .data!,
            ),
            '1,050.00 USD',
          );
          expect(
            textPlain(plain(l10n.approxInBase('57,750.00 EGP'))),
            findsOneWidget,
          );
          expect(textPlain('+50.00'), findsOneWidget);
          expect(textPlain('+7,750.00'), findsOneWidget);
          expect(textPlain('+5.00 %'), findsOneWidget);
          expect(textPlain('+15.50 %'), findsWidgets);
          expect(find.text(l10n.colItem('USD')), findsOneWidget);
          expect(find.text(l10n.colItem('EGP')), findsOneWidget);
          expect(
            find.text(l10n.rowRealOwn(l10n.countryName('USA'))),
            findsOneWidget,
          );
          expect(
            find.text(l10n.rowRealBase(l10n.countryName('EGY'))),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-35: the real figures carry the purchasing-power label and an inflation tag',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'us'),
            locale: locale,
            seed: seedUsStock,
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.realLabel), findsOneWidget);
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
        },
      );

      testScreen('a number opens its why sheet with the user\'s own figures', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const ItemDetailScreen(investmentId: 'us'),
          locale: locale,
          seed: seedUsStock,
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.text(l10n.rowReturn));
        await tester.pumpAndSettle();
        expect(find.text(l10n.whyReturnTitle), findsWidgets);
        expect(find.text(l10n.whyReturnWhat), findsOneWidget);
        expect(find.text(l10n.whyNumbers), findsOneWidget);
        expect(textPlain('15.50 %'), findsWidgets);
      });

      testScreen(
        'the set-aside why sheet states the planning wording and the zakat sources',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'us'),
            locale: locale,
            seed: seedUsStock,
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.text(l10n.rowSetAside));
          await tester.pumpAndSettle();
          expect(find.text(l10n.whySetAsideWhat), findsOneWidget);
          expect(textPlain(l10n.src_A1A2), findsOneWidget);
        },
      );

      testScreen(
        'history is listed newest first; a row opens the sheet to edit it',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'us'),
            locale: locale,
            seed: seedUsStock,
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.text(l10n.kindMoneyIn));
          expect(
            tester.getTopLeft(find.text(l10n.kindValue)).dy,
            lessThan(tester.getTopLeft(find.text(l10n.kindMoneyIn)).dy),
          );
          await tester.tap(find.text(l10n.kindValue));
          await tester.pumpAndSettle();
          expect(find.byType(RecordSheet), findsOneWidget);
          expect(
            tester
                .widget<TextField>(
                  find.descendant(
                    of: find.byKey(const ValueKey('record-amount')),
                    matching: find.byType(TextField),
                  ),
                )
                .controller!
                .text,
            '1050',
          );
        },
      );

      testScreen(
        'AC-4: a closed item shows when it closed and offers no Record',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'a'),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('a'), [
                moneyIn('a', day(2026, 1, 10), '1000'),
                moneyOut('a', day(2026, 3, 15), '1000'),
                value('a', day(2026, 3, 15), '0'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(textPlain(plain(l10n.closedOn('15'))), findsNothing);
          expect(find.byIcon(Icons.lock_outline), findsOneWidget);
          expect(find.text(l10n.record), findsNothing);
        },
      );

      testScreen(
        'AC-19: interest to purify is its own card and leads to "given away"',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'dep'),
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
            textPlain(plain(l10n.toPurifyItem('500.00 EGP'))),
            findsOneWidget,
          );
          expect(
            plain(
              tester
                  .widget<Text>(find.byKey(const ValueKey('value-now')))
                  .data!,
            ),
            '10,000.00 EGP',
          );
          await tester.tap(find.text(l10n.recordGivenAway));
          await tester.pumpAndSettle();
          expect(find.byType(RecordSheet), findsOneWidget);
          expect(find.text(l10n.givenAwayNote), findsOneWidget);
        },
      );

      testScreen(
        'AC-5: a dividends-only stock says so, with the cash notice and its source',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'div'),
            locale: locale,
            seed: (h) async {
              await h.setup(method: LongTermMethod.dividendsOnly);
              await h.addItem(
                item(
                  'div',
                  type: AssetType.stock,
                  market: Market.egx,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermPerSetting,
                ),
                [
                  moneyIn('div', day(2026, 1, 1), '50000'),
                  value('div', day(2026, 10, 1), '50000'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatLineDividends), findsOneWidget);
          expect(find.text(l10n.noticeDividends), findsOneWidget);
          await scrollTo(tester, find.text(l10n.source).last);
          await tester.tap(find.text(l10n.source).last);
          await tester.pumpAndSettle();
          expect(find.textContaining(l10n.src_B3), findsOneWidget);
        },
      );

      testScreen(
        'C1: the zakat source follows the asset: crypto cites its own section, not the shares ruling',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'coin'),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(
                item(
                  'coin',
                  type: AssetType.crypto,
                  intent: null,
                  rule: ZakatRule.crypto100,
                ),
                [
                  moneyIn('coin', day(2026, 1, 1), '1000'),
                  value('coin', day(2026, 10, 1), '1200'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.text(l10n.source).last);
          await tester.tap(find.text(l10n.source).last);
          await tester.pumpAndSettle();
          expect(find.textContaining(l10n.src_B8), findsOneWidget);
          expect(find.textContaining(l10n.src_B3), findsNothing);
          expect(find.textContaining(l10n.src_A1A2), findsOneWidget);
        },
      );

      testScreen(
        'C5: an "other" item cites real estate, business and pension rulings',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'flat'),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(
                item(
                  'flat',
                  type: AssetType.other,
                  intent: Intent.rental,
                  rule: ZakatRule.custom,
                  customShare: Decimal.zero,
                ),
                [moneyIn('flat', day(2026, 1, 1), '1000')],
              );
            },
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.text(l10n.source).last);
          await tester.tap(find.text(l10n.source).last);
          await tester.pumpAndSettle();
          for (final src in [l10n.src_B5, l10n.src_B6, l10n.src_B7]) {
            expect(find.textContaining(src), findsOneWidget);
          }
        },
      );

      testScreen('C2: the set-aside formula includes the dividends received', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const ItemDetailScreen(investmentId: 'div'),
          locale: locale,
          seed: (h) async {
            await h.setup(method: LongTermMethod.dividendsOnly);
            await h.addItem(
              item(
                'div',
                type: AssetType.stock,
                market: Market.egx,
                intent: Intent.longTerm,
                rule: ZakatRule.longTermPerSetting,
                start: day(2025, 12, 31),
              ),
              [
                moneyIn('div', day(2025, 12, 31), '50000'),
                moneyOut(
                  'div',
                  day(2026, 3, 15),
                  '400',
                  kind: MoneyOutKind.income,
                ),
                value('div', day(2026, 10, 1), '50000'),
              ],
            );
          },
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.text(l10n.rowSetAside));
        await tester.pumpAndSettle();
        expect(find.text(l10n.whySetAsideWhat), findsOneWidget);
        expect(textPlain(plain('+ 2.50 % × 400.00 EGP')), findsOneWidget);
        expect(textPlain('10.00 EGP'), findsWidgets);
      });

      testScreen('AC-21: without the rate the base column asks for it', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const ItemDetailScreen(investmentId: 'us'),
          locale: locale,
          seed: (h) async {
            await seedUsStock(h);
            await h.assumptions.deleteRate(
              (await h.assumptions.watchRates().first).first.id,
            );
            await h.assumptions.deleteRate(
              (await h.assumptions.watchRates().first).first.id,
            );
          },
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.needsRate('USD', 'EGP')), findsOneWidget);
        expect(
          plain(
            tester.widget<Text>(find.byKey(const ValueKey('value-now'))).data!,
          ),
          '1,050.00 USD',
        );
      });

      testScreen(
        'Edit opens the form; "by month and year" opens the period view for this item',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'us'),
            locale: locale,
            seed: seedUsStock,
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.text(l10n.byMonthYear));
          await tester.pumpAndSettle();
          expect(find.byType(PeriodScreen), findsOneWidget);
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.edit));
          await tester.pumpAndSettle();
          expect(find.byType(InvestmentFormScreen), findsOneWidget);
          expect(find.text('US stock'), findsWidgets);
        },
      );
      final oct17 = day(2026, 10, 17);

      Future<List<HistoryEntry>> historyOf(
        WidgetTester tester,
        Harness h,
        String id,
      ) async {
        late List<HistoryEntry> out;
        await tester.runAsync(
          () async => out = (await h.items())
              .firstWhere((x) => x.investment.id == id)
              .history,
        );
        return out;
      }

      Future<void> tapKey(WidgetTester tester, String key) async {
        final f = find.byKey(ValueKey(key));
        await tester.ensureVisible(f);
        await tester.tap(f);
        await settle(tester);
      }

      Finder inCard(Pattern p) => find.descendant(
        of: find.byKey(const ValueKey('to-confirm')),
        matching: textPlain(p),
      );

      String keyText(WidgetTester tester, String key) =>
          plain(tester.widget<Text>(find.byKey(ValueKey(key))).data!);

      testScreen(
        'AC-51: three pending rows of 5,000.00, the line on April and July only; 15,000 / 0 / −15,000',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.toConfirmTitle(3)), findsOneWidget);
          expect(find.text(l10n.rowPayout), findsNWidgets(3));
          expect(inCard(RegExp(r'^5,000\.00 EGP$')), findsNWidgets(3));
          expect(find.text(l10n.confirmAllLine), findsOneWidget);
          for (final d in ['2026-04-15', '2026-07-15', '2026-10-15']) {
            expect(find.byKey(ValueKey('check-payout-$d')), findsOneWidget);
            final tip = tester.widget<IconButton>(
              find.byKey(ValueKey('check-payout-$d')),
            );
            expect(tip.tooltip, l10n.receivedThisAmount);
          }
          expect(textPlain(plain(l10n.noPayoutPartnership)), findsNWidgets(2));
          expect(keyText(tester, 'expected-so-far'), '15,000.00 EGP');
          expect(keyText(tester, 'received'), '0.00 EGP');
          expect(keyText(tester, 'difference'), contains('15,000.00 EGP'));
          expect(keyText(tester, 'difference'), isNot(startsWith('+')));
        },
      );

      testScreen(
        'AC-52, AC-72: ✓ April, edit July to 4,000, skip October; each Undo puts its row back',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          await tapKey(tester, 'check-payout-2026-04-15');
          var incomes = (await historyOf(
            tester,
            h,
            'fp',
          )).whereType<MoneyOut>().toList();
          expect(incomes.single.date, day(2026, 4, 15));
          expect(incomes.single.amount, Money(Decimal.parse('5000'), egp));
          expect(incomes.single.kind, MoneyOutKind.income);
          await tester.tap(find.text(l10n.undo));
          await settle(tester);
          expect(
            (await historyOf(tester, h, 'fp')).whereType<MoneyOut>(),
            isEmpty,
          );
          expect(find.text(l10n.toConfirmTitle(3)), findsOneWidget);
          expect(keyText(tester, 'received'), '0.00 EGP');

          await tapKey(tester, 'check-payout-2026-04-15');
          await tapKey(tester, 'row-payout-2026-07-15');
          expect(keyText(tester, 'expected-header'), contains('5,000.00 EGP'));
          await tester.enterText(
            find.descendant(
              of: find.byKey(const ValueKey('record-amount')),
              matching: find.byType(TextField),
            ),
            '4000',
          );
          await tester.tap(find.byKey(const ValueKey('record-save')));
          await settle(tester);
          incomes =
              (await historyOf(tester, h, 'fp')).whereType<MoneyOut>().toList()
                ..sort((a, b) => a.date.compareTo(b.date));
          expect(
            [for (final x in incomes) (x.date, x.amount.amount)],
            [
              (day(2026, 4, 15), Decimal.parse('5000')),
              (day(2026, 7, 15), Decimal.parse('4000')),
            ],
          );

          ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
              .clearSnackBars();
          await tester.pumpAndSettle();
          await tapKey(tester, 'menu-payout-2026-10-15');
          await tester.tap(find.text(l10n.skipRow).last);
          await settle(tester);
          expect(
            (await historyOf(
              tester,
              h,
              'fp',
            )).whereType<PlanSkip>().single.date,
            day(2026, 10, 15),
          );
          expect(find.byKey(const ValueKey('to-confirm')), findsNothing);
          expect(
            find.widgetWithText(ListTile, l10n.kindSkipped),
            findsOneWidget,
          );
          expect(textPlain(plain(l10n.noPayoutPartnership)), findsOneWidget);
          expect(keyText(tester, 'expected-so-far'), '15,000.00 EGP');
          expect(keyText(tester, 'received'), '9,000.00 EGP');
          expect(keyText(tester, 'difference'), contains('6,000.00 EGP'));
          await tester.tap(find.text(l10n.undo));
          await settle(tester);
          expect(
            (await historyOf(tester, h, 'fp')).whereType<PlanSkip>(),
            isEmpty,
          );
          expect(find.text(l10n.toConfirmTitle(1)), findsOneWidget);
        },
      );

      testScreen(
        'AC-53, AC-72: Confirm all writes three incomes at once; Undo removes all three',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.confirmAllLine), findsOneWidget);
          await tapKey(tester, 'confirm-all');
          final incomes = (await historyOf(
            tester,
            h,
            'fp',
          )).whereType<MoneyOut>().toList();
          expect(incomes.map((x) => x.date).toSet(), {
            day(2026, 4, 15),
            day(2026, 7, 15),
            day(2026, 10, 15),
          });
          expect(
            incomes.every((x) => x.amount.amount == Decimal.parse('5000')),
            isTrue,
          );
          expect(find.text(l10n.recordedAllSnack(3)), findsOneWidget);
          expect(keyText(tester, 'received'), '15,000.00 EGP');
          expect(keyText(tester, 'difference'), contains('0.00 EGP'));
          expect(find.byKey(const ValueKey('to-confirm')), findsNothing);
          await tester.tap(find.text(l10n.undo));
          await settle(tester);
          expect(
            (await historyOf(tester, h, 'fp')).whereType<MoneyOut>(),
            isEmpty,
          );
          expect(find.text(l10n.toConfirmTitle(3)), findsOneWidget);
        },
      );

      testScreen(
        'AC-57, AC-73: a row with no % offers Add amount, no ✓; adding 950 makes it received (3,050.00)',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'np'),
            locale: locale,
            now: day(2026, 5, 10),
            seed: (h) async {
              await h.setup();
              await h.addItem(noPctFund(), [
                moneyIn('np', day(2026, 1, 31), '50000'),
                moneyOut(
                  'np',
                  day(2026, 3, 5),
                  '1200',
                  kind: MoneyOutKind.income,
                ),
                moneyOut(
                  'np',
                  day(2026, 4, 2),
                  '900',
                  kind: MoneyOutKind.income,
                ),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(
            find.byKey(const ValueKey('check-payout-2026-04-30')),
            findsNothing,
          );
          expect(find.byKey(const ValueKey('confirm-all')), findsNothing);
          expect(find.text(l10n.rowsNeedAmount(1)), findsOneWidget);
          expect(
            keyText(tester, 'received-since-start'),
            plain(l10n.receivedSinceStart('2,100.00 EGP')),
          );
          expect(find.byKey(const ValueKey('expected-so-far')), findsNothing);
          await tapKey(tester, 'add-payout-2026-04-30');
          await tester.enterText(
            find.descendant(
              of: find.byKey(const ValueKey('record-amount')),
              matching: find.byType(TextField),
            ),
            '950',
          );
          await tester.tap(find.byKey(const ValueKey('record-save')));
          await settle(tester);
          final added = (await historyOf(tester, h, 'np'))
              .whereType<MoneyOut>()
              .firstWhere((x) => x.date == day(2026, 4, 30));
          expect(added.amount.amount, Decimal.parse('950'));
          expect(added.kind, MoneyOutKind.income);
          expect(
            keyText(tester, 'received-since-start'),
            plain(l10n.receivedSinceStart('3,050.00 EGP')),
          );
          expect(find.byKey(const ValueKey('to-confirm')), findsNothing);
        },
      );

      testScreen(
        'AC-58b: a conventional deposit row reads "Expected interest (to purify)"; ✓ stores interest paid out, not income',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'dep'),
            locale: locale,
            now: day(2026, 2, 9),
            seed: (h) async {
              await h.setup();
              await h.addItem(planDeposit(AccountKind.conventional), [
                moneyIn('dep', day(2026, 1, 1), '10000'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.rowInterest), findsOneWidget);
          expect(inCard(RegExp(r'^83\.33 EGP$')), findsOneWidget);
          await tapKey(tester, 'check-payout-2026-02-01');
          final hist = await historyOf(tester, h, 'dep');
          expect(hist.whereType<MoneyOut>(), isEmpty);
          final rec = hist.whereType<InterestRecord>().single;
          expect(
            (rec.kind, rec.date, rec.amount.amount),
            (InterestKind.paidOut, day(2026, 2, 1), Decimal.parse('83.33')),
          );
          expect(
            textPlain(plain(l10n.toPurifyItem('83.33 EGP'))),
            findsOneWidget,
          );
          expect(
            plain(
              tester
                  .widget<Text>(find.byKey(const ValueKey('value-now')))
                  .data!,
            ),
            '10,000.00 EGP',
          );
        },
      );

      testScreen(
        'AC-58: an Islamic deposit row reads "Expected payout" and interest does not resolve it',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'dep'),
            locale: locale,
            now: day(2026, 2, 9),
            seed: (h) async {
              await h.setup();
              await h.addItem(planDeposit(AccountKind.islamic), [
                moneyIn('dep', day(2026, 1, 1), '10000'),
                interest('dep', day(2026, 2, 1), '83.33', InterestKind.paidOut),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.rowPayout), findsOneWidget);
          expect(
            find.byKey(const ValueKey('check-payout-2026-02-01')),
            findsOneWidget,
          );
          expect(keyText(tester, 'received'), '0.00 EGP');
          expect(textPlain(plain(l10n.noPayoutPartnership)), findsNothing);
          expect(
            textPlain(
              plain(l10n.noPayoutLine('§', '§', '§')).split('§').first.trim(),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-61, AC-60: value rows 10,096.72 / 10,184.88; ✓ February, March edited to 9,800: −384.88 (−3.78 %) and "below your estimate"',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fund'),
            locale: locale,
            now: day(2026, 3, 5),
            seed: (h) async {
              await h.setup();
              await h.addItem(planFund(), [
                moneyIn('fund', day(2026, 1, 1), '10000'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.rowValue), findsNWidgets(2));
          expect(textPlain('10,096.72 EGP'), findsWidgets);
          expect(textPlain('10,184.88 EGP'), findsWidgets);
          await tapKey(tester, 'check-value-2026-02-01');
          final v = (await historyOf(
            tester,
            h,
            'fund',
          )).whereType<ValueUpdate>().single;
          expect(
            (v.date, v.value),
            (day(2026, 2, 1), Decimal.parse('10096.72')),
          );
          expect(textPlain('10,184.88 EGP'), findsWidgets);
          await tapKey(tester, 'row-value-2026-03-01');
          await tester.enterText(
            find.descendant(
              of: find.byKey(const ValueKey('record-amount')),
              matching: find.byType(TextField),
            ),
            '9800',
          );
          await tester.tap(find.byKey(const ValueKey('record-save')));
          await settle(tester);
          final text = keyText(tester, 'value-vs-estimate');
          expect(text, contains('9,800.00 EGP'));
          expect(text, contains('10,184.88 EGP'));
          expect(text, contains('384.88 EGP'));
          expect(text, contains('3.78 %'));
          expect(textPlain(plain(l10n.valueBelowEstimate)), findsNWidgets(2));
        },
      );

      testScreen(
        'AC-62, AC-74: payouts-only shows one chart and no switch; with both plans the switch shows one chart at a time',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: seedFriend,
          );
          expect(find.byKey(const ValueKey('payouts-chart')), findsOneWidget);
          expect(find.byKey(const ValueKey('plan-switch')), findsNothing);
          expect(find.byKey(const ValueKey('value-chart')), findsNothing);
        },
      );

      testScreen('AC-74: with both plans, Payouts | Value switches the chart', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const ItemDetailScreen(investmentId: 'fp'),
          locale: locale,
          now: oct17,
          seed: (h) =>
              seedFriend(h, investment: friendsProject(check: Schedule.yearly)),
        );
        final l10n = l10nOf(tester);
        expect(find.byKey(const ValueKey('plan-switch')), findsOneWidget);
        expect(find.byKey(const ValueKey('payouts-chart')), findsOneWidget);
        expect(find.byKey(const ValueKey('value-chart')), findsNothing);
        await tester.tap(find.text(l10n.tabValue).last);
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('value-chart')), findsOneWidget);
        expect(find.byKey(const ValueKey('payouts-chart')), findsNothing);
      });

      testScreen(
        'AC-65, AC-71: case C shows payouts as to purify (10,000.00), gain 0, the case C notice and 100 % zakat',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: (h) => seedFriend(
              h,
              investment: friendsProject(q2: CapitalBack.yes),
              more: [
                moneyOut(
                  'fp',
                  day(2026, 4, 15),
                  '5000',
                  kind: MoneyOutKind.income,
                ),
                moneyOut(
                  'fp',
                  day(2026, 7, 15),
                  '5000',
                  kind: MoneyOutKind.income,
                ),
              ],
            ),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.kindPayoutPurify), findsNWidgets(2));
          expect(find.text(l10n.caseCReturnsLine), findsOneWidget);
          expect(find.text(l10n.caseCReceived), findsOneWidget);
          expect(find.text(l10n.rowPayoutPurify), findsOneWidget);
          expect(
            textPlain(plain(l10n.toPurifyItem('10,000.00 EGP'))),
            findsOneWidget,
          );
          expect(
            textPlain(plain(l10n.toPurifyIncludesPayouts('10,000.00 EGP'))),
            findsOneWidget,
          );
          expect(find.text(l10n.noticeCaseC), findsOneWidget);
          expect(find.text(l10n.noticeCapitalBackIsDebt), findsOneWidget);
          expect(textPlain('100.00 %'), findsWidgets);
          expect(find.byKey(const ValueKey('shariah-risk-tag')), findsNothing);
          expect(textPlain('0.00 EGP'), findsWidgets);
        },
      );

      testScreen(
        'AC-71: on case C the give-away option reads "Given away from payouts (to purify)" with its help line; 4,000 leaves 6,000.00',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: (h) => seedFriend(
              h,
              investment: friendsProject(q2: CapitalBack.yes),
              more: [
                moneyOut(
                  'fp',
                  day(2026, 4, 15),
                  '5000',
                  kind: MoneyOutKind.income,
                ),
                moneyOut(
                  'fp',
                  day(2026, 7, 15),
                  '5000',
                  kind: MoneyOutKind.income,
                ),
              ],
            ),
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.text(l10n.recordGivenAway));
          await tester.pumpAndSettle();
          expect(find.text(l10n.givenAwayFromPayouts), findsOneWidget);
          expect(
            find.byKey(const ValueKey('payouts-given-help')),
            findsOneWidget,
          );
          expect(find.text(l10n.givenAwayFromPayoutsHelp), findsOneWidget);
          await tester.enterText(
            find.descendant(
              of: find.byKey(const ValueKey('record-amount')),
              matching: find.byType(TextField),
            ),
            '4000',
          );
          await tester.tap(find.byKey(const ValueKey('record-save')));
          await settle(tester);
          final rec = (await historyOf(
            tester,
            h,
            'fp',
          )).whereType<InterestRecord>().single;
          expect(rec.kind, InterestKind.givenAwayFromPaidOut);
          expect(
            textPlain(plain(l10n.toPurifyItem('6,000.00 EGP'))),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-66: case B carries the Shariah risk tag, the notice and "source not yet verified"; case A has none',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: (h) => seedFriend(
              h,
              investment: friendsProject(q1: ProfitBasis.fixedPctOfMoney),
            ),
          );
          final l10n = l10nOf(tester);
          expect(
            find.byKey(const ValueKey('shariah-risk-tag')),
            findsOneWidget,
          );
          expect(find.text(l10n.shariahRiskTag), findsOneWidget);
          expect(find.text(l10n.noticeCaseB), findsOneWidget);
          expect(find.text(l10n.caseBReturnLine), findsOneWidget);
          expect(find.text(l10n.changeAnswers), findsOneWidget);
        },
      );

      testScreen('AC-66: case A has no tag and no notice', (tester) async {
        await pumpScreen(
          tester,
          const ItemDetailScreen(investmentId: 'fp'),
          locale: locale,
          now: oct17,
          seed: seedFriend,
        );
        final l10n = l10nOf(tester);
        expect(find.byKey(const ValueKey('shariah-risk-tag')), findsNothing);
        expect(find.byKey(const ValueKey('case-notice')), findsNothing);
        expect(find.text(l10n.noticeCaseB), findsNothing);
      });

      testScreen(
        'AC-47: "profit received only" shows the payout notice on the item',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: (h) => seedFriend(
              h,
              investment: friendsProject(rule: ZakatRule.longTermDividendsOnly),
            ),
          );
          final l10n = l10nOf(tester);
          expect(
            textPlain(plain(l10n.noticeProfitPayoutsOnly('2.50 %'))),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-56: a closed item keeps its old rows to confirm and has no Record button',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
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
          final l10n = l10nOf(tester);
          expect(find.text(l10n.toConfirmTitle(3)), findsOneWidget);
          expect(
            find.byKey(const ValueKey('check-payout-2027-01-15')),
            findsNothing,
          );
          expect(find.byType(FloatingActionButton), findsNothing);
        },
      );

      testScreen(
        'AC-63: an item with no plan shows no To confirm and no Plan vs actual',
        (tester) async {
          await pumpScreen(
            tester,
            const ItemDetailScreen(investmentId: 'fp'),
            locale: locale,
            now: oct17,
            seed: (h) async {
              await h.setup();
              await h.addItem(
                Investment(
                  id: 'fp',
                  name: 'fp',
                  type: AssetType.privateEquity,
                  intent: Intent.longTerm,
                  unit: egp,
                  startDate: day(2026, 1, 15),
                  zakatRule: ZakatRule.longTermFullValue,
                  capitalBack: CapitalBack.no,
                ),
                [moneyIn('fp', day(2026, 1, 15), '100000')],
              );
            },
          );
          expect(find.byKey(const ValueKey('to-confirm')), findsNothing);
          expect(find.byKey(const ValueKey('plan-card')), findsNothing);
        },
      );
    });
  }
}
