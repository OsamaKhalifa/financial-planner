/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/period_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

final afterYear = day(2027, 1, 15);

Future<void> seedAc15(
  Harness h, {
  String endValue = '23000',
  bool setup = true,
}) async {
  if (setup) await h.setup();
  await h.addItem(
    item(
      'stock',
      name: 'EGX stock',
      type: AssetType.stock,
      market: Market.egx,
      start: day(2025, 12, 31),
    ),
    [
      moneyIn('stock', day(2025, 12, 31), '20000'),
      value('stock', day(2026, 12, 31), endValue),
    ],
  );
}

Finder figure(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first;

String? valueIn(WidgetTester tester, String label) {
  final row = tester.widget<Row>(
    find.descendant(of: figure(label), matching: find.byType(Row)).first,
  );
  final texts = row.children.whereType<Text>().toList();
  return plain(texts.last.data!);
}

Future<void> scrollTo(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(
    f,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in [en, ar]) {
    group('S7 period view (${locale.languageCode})', () {
      testScreen(
        'AC-15: the ladder from return to real return, and the kept verdict',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            now: afterYear,
            seed: seedAc15,
          );
          final l10n = l10nOf(tester);
          expect(valueIn(tester, l10n.rowReturn), '+15.00 %');
          expect(valueIn(tester, l10n.rowSetAside), '−592.25 EGP');
          expect(find.text(l10n.setAsideNote), findsOneWidget);
          expect(valueIn(tester, l10n.rowReturnAfter), '+12.04 %');
          expect(
            valueIn(tester, l10n.rowInflation(l10n.countryName('EGY'))),
            '+10.00 %',
          );
          expect(valueIn(tester, l10n.rowRealAfter), '+1.85 %');
          expect(
            textPlain(plain(l10n.rowRealBefore('+4.55 %'))),
            findsOneWidget,
          );
          expect(find.text(l10n.verdictKeptTitle), findsOneWidget);
          expect(
            plain(
              tester
                  .widget<Text>(find.byKey(const ValueKey('verdict-amount')))
                  .data!,
            ),
            '+407.75 EGP',
          );
          expect(
            textPlain(plain(l10n.neededEnd('22,581.48 EGP', '+12.91 %'))),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-35: every real figure carries the purchasing-power label; the inflation source is tagged',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            now: afterYear,
            seed: seedAc15,
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.realLabel), findsNWidgets(2));
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

      testScreen(
        'AC-17: a lost year shows the loss with a word, a sign and an icon',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            now: afterYear,
            seed: (h) => seedAc15(h, endValue: '22000'),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.verdictLostTitle), findsOneWidget);
          expect(
            plain(
              tester
                  .widget<Text>(find.byKey(const ValueKey('verdict-amount')))
                  .data!,
            ),
            '−566.50 EGP',
          );
          expect(valueIn(tester, l10n.rowSetAside), '−566.50 EGP');
          expect(valueIn(tester, l10n.rowRealAfter), '−2.58 %');
          expect(find.byIcon(Icons.arrow_downward), findsWidgets);
        },
      );

      testScreen(
        'AC-18: the no-zakat switch is off by default, never set for the user, and zeroes the set-aside',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            now: afterYear,
            seed: seedAc15,
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('no-zakat-2026')));
          expect(
            tester
                .widget<SwitchListTile>(
                  find.byKey(const ValueKey('no-zakat-2026')),
                )
                .value,
            isFalse,
          );
          expect(find.text(l10n.noZakatHelp), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('no-zakat-2026')));
          await settle(tester);
          late Set<int> years;
          await tester.runAsync(
            () async => years = await h.assumptions.watchNoZakatYears().first,
          );
          expect(years, {2026});
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, 3000),
          );
          await tester.pumpAndSettle();
          expect(valueIn(tester, l10n.rowSetAside), l10n.noZakatEffect);
          expect(valueIn(tester, l10n.rowReturnAfter), '+15.00 %');
          expect(valueIn(tester, l10n.rowRealAfter), '+4.55 %');
        },
      );

      testScreen(
        'AC-45: the nisab hint and the zakatable total, from the user\'s own rates',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            now: afterYear,
            seed: (h) async {
              await h.setup();
              await h.rate(xauG, egp, '5000', afterYear);
              await h.rate(xagG, egp, '60', afterYear);
              await h.addItem(
                item(
                  'cash',
                  type: AssetType.cashDeposit,
                  intent: null,
                  rule: ZakatRule.cash100,
                ),
                [
                  moneyIn('cash', day(2026, 1, 1), '100000'),
                  value('cash', day(2026, 12, 31), '100000'),
                ],
              );
              await h.addItem(
                item(
                  'lt',
                  type: AssetType.stock,
                  market: Market.egx,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermProxy25,
                ),
                [
                  moneyIn('lt', day(2026, 1, 1), '50000'),
                  value('lt', day(2026, 12, 31), '50000'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('no-zakat-2026')));
          expect(
            textPlain(plain(l10n.nisabGold('425,000.00 EGP'))),
            findsOneWidget,
          );
          expect(
            textPlain(plain(l10n.nisabSilver('35,700.00 EGP'))),
            findsOneWidget,
          );
          expect(
            textPlain(plain(l10n.zakatableTotal('112,500.00 EGP'))),
            findsOneWidget,
          );
          expect(
            tester
                .widget<SwitchListTile>(
                  find.byKey(const ValueKey('no-zakat-2026')),
                )
                .value,
            isFalse,
          );
        },
      );

      testScreen('AC-45: without a gold rate the hint says to add one', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const PeriodScreen(initialYear: 2026),
          locale: locale,
          now: afterYear,
          seed: seedAc15,
        );
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('no-zakat-2026')));
        expect(find.text(l10n.nisabNoGold), findsOneWidget);
        expect(find.text(l10n.nisabNoSilver), findsOneWidget);
      });

      testScreen(
        'AC-21: a month with an item that has no rate names it and what the totals are based on',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026, initialMonth: 4),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('eg', name: 'Fund'), [
                moneyIn('eg', day(2026, 1, 1), '2000'),
              ]);
              await h.addItem(
                item(
                  'us',
                  name: 'US stock',
                  type: AssetType.stock,
                  unit: usd,
                  market: Market.nasdaq,
                ),
                [moneyIn('us', day(2026, 1, 1), '1000', usd)],
              );
            },
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('excluded-us')));
          expect(
            find.text(l10n.excludedLine('US stock', 'USD', 'EGP')),
            findsOneWidget,
          );
          expect(textPlain(l10n.basedOn('1', '2')), findsOneWidget);
        },
      );

      testScreen('AC-22: an old rate is used and the period says so', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const PeriodScreen(initialYear: 2026, initialMonth: 5),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.rate(usd, egp, '50', day(2026, 1, 15));
            await h.addItem(
              item(
                'us',
                name: 'US stock',
                type: AssetType.stock,
                unit: usd,
                market: Market.nasdaq,
                start: day(2026, 1, 15),
              ),
              [moneyIn('us', day(2026, 1, 15), '1000', usd)],
            );
          },
        );
        final l10n = l10nOf(tester);
        expect(textPlain(l10n.markerStaleRate), findsOneWidget);
        expect(textPlain('50,000.00'), findsNothing);
      });

      testScreen(
        'AC-39: the gold-grams view shows the loss in grams, no inflation step, and the yardstick note',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            now: afterYear,
            seed: (h) async {
              await h.setup();
              await h.rate(xauG, egp, '4000', day(2025, 12, 31));
              await h.rate(xauG, egp, '5000', day(2026, 12, 31));
              await h.addItem(
                item(
                  'gold',
                  type: AssetType.gold,
                  unit: xauG,
                  intent: Intent.longTerm,
                  rule: ZakatRule.bullion100,
                  karat: 21,
                  start: day(2025, 12, 31),
                ),
                [
                  moneyIn('gold', day(2025, 12, 31), '70000'),
                  value('gold', day(2025, 12, 31), '17.5'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(valueIn(tester, l10n.rowReturn), '+25.00 %');
          await tester.tap(find.text(l10n.viewGold));
          await tester.pumpAndSettle();
          expect(valueIn(tester, l10n.rowReturnAfter), '−2.58 %');
          expect(find.byKey(const ValueKey('yardstick')), findsOneWidget);
          expect(find.text(l10n.yardstick), findsOneWidget);
          expect(
            find.text(l10n.rowInflation(l10n.countryName('EGY'))),
            findsNothing,
          );
          expect(find.text(l10n.verdictLostTitle), findsOneWidget);
          expect(textPlain(plain(l10n.lostGrams('0.45 g'))), findsOneWidget);
          expect(find.byKey(const ValueKey('no-zakat-2026')), findsNothing);
        },
      );

      testScreen(
        'AC-41: with nothing invested the return is not available, not an error',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(
              initialYear: 2026,
              initialMonth: 3,
              scopeItemId: 'a',
            ),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('a'), [
                moneyIn('a', day(2026, 1, 10), '1000'),
                moneyOut('a', day(2026, 2, 15), '1000'),
                value('a', day(2026, 2, 15), '0'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.byKey(const ValueKey('not-available')), findsOneWidget);
          expect(find.text(l10n.notAvailable), findsWidgets);
        },
      );

      testScreen(
        'the stepper moves between months and years; a row of other periods jumps there',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026, initialMonth: 4),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('f'), [
                moneyIn('f', day(2026, 1, 1), '1000'),
                value('f', day(2026, 10, 5), '1500'),
              ]);
            },
          );
          final ml = MaterialLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );
          expect(find.text(ml.formatMonthYear(day(2026, 4, 30))), findsWidgets);
          await tester.tap(find.byKey(const ValueKey('next')));
          await tester.pumpAndSettle();
          expect(find.text(ml.formatMonthYear(day(2026, 5, 31))), findsWidgets);
          await tester.tap(find.byKey(const ValueKey('prev')));
          await tester.tap(find.byKey(const ValueKey('prev')));
          await tester.pumpAndSettle();
          expect(find.text(ml.formatMonthYear(day(2026, 3, 31))), findsWidgets);
          await scrollTo(tester, find.byKey(const ValueKey('other-2026-9')));
          await tester.tap(find.byKey(const ValueKey('other-2026-9')));
          await tester.pumpAndSettle();
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, 3000),
          );
          await tester.pumpAndSettle();
          expect(find.text(ml.formatMonthYear(day(2026, 9, 30))), findsWidgets);
        },
      );

      testScreen(
        'switching a current-year view to Month opens on the current month',
        (tester) async {
          await pumpScreen(
            tester,
            const PeriodScreen(initialYear: 2026),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('f'), [
                moneyIn('f', day(2026, 1, 1), '1000'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.text(l10n.monthLabel));
          await tester.pumpAndSettle();
          final ml = MaterialLocalizations.of(
            tester.element(find.byType(Scaffold)),
          );
          expect(
            find.text(ml.formatMonthYear(day(2026, 10, 16))),
            findsWidgets,
          );
        },
      );

      testScreen('the scope picker narrows the view to one item', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const PeriodScreen(initialYear: 2026),
          locale: locale,
          now: afterYear,
          seed: seedAc15,
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.byKey(const ValueKey('scope')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('EGX stock').last);
        await tester.pumpAndSettle();
        expect(valueIn(tester, l10n.rowReturn), '+15.00 %');
        expect(find.byKey(const ValueKey('no-zakat-2026')), findsNothing);
        expect(find.text(l10n.viewGold), findsNothing);
      });
    });
  }
}
