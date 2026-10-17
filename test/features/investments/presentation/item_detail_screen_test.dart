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

import '../../../support/app_harness.dart';

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
    });
  }
}
