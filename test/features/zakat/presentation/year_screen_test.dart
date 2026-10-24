/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/item_detail_screen.dart';
import 'package:financial_planner/features/investments/presentation/record_sheet.dart';
import 'package:financial_planner/features/investments/presentation/why_builders.dart';
import 'package:financial_planner/features/zakat/domain/yearly_zakat.dart';
import 'package:financial_planner/features/zakat/presentation/year_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<Harness> pumpYear(
  WidgetTester tester,
  Locale locale, {
  Future<void> Function(Harness h)? seed,
  DateTime? key,
  DateTime? now,
}) => pumpScreen(
  tester,
  YearScreen(yearKey: key ?? yasminDue),
  now: now ?? yasminToday,
  locale: locale,
  seed: seed ?? seedYasmin,
);

String zakatDueText(WidgetTester tester) =>
    textOf(tester, find.byKey(const ValueKey('zakat-due')));

void main() {
  for (final locale in [en, ar]) {
    group('Z2 year screen (${locale.languageCode})', () {
      testScreen(
        'header: label, state chip, both calendars, the Umm al-Qura line and Move date',
        (tester) async {
          await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          final hijri = hijriOf(yasminDue);
          expect(find.text(l10n.zakatYearLabel('lunar', '1448')), findsWidgets);
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('due'),
          );
          expect(
            textPlain(
              '${hijri.d} ${l10n.hijriMonth('${hijri.m}')} '
              '${l10n.zakatYearLabel('lunar', '${hijri.y}')}',
            ),
            findsOneWidget,
          );
          expect(textPlain(shownDate(tester, yasminDue)), findsWidgets);
          expect(find.text(l10n.zakatUmmAlQuraLine), findsOneWidget);
          expect(find.text(l10n.zakatMoveDate), findsOneWidget);
          expect(find.byKey(const ValueKey('moved-from')), findsNothing);
        },
      );

      testScreen(
        'AC-9: every line with its parts, the totals, and no day count',
        (tester) async {
          await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          final on = shownDate(tester, yasminDue);
          expect(zakatDueText(tester), '12,500.00 EGP');
          expect(textPlain('520,000.00'), findsWidgets);
          expect(textPlain('500,000.00'), findsWidgets);
          expect(textPlain('425,000.00'), findsWidgets);
          expect(
            textPlain(l10n.zakatResultRateOf('2.5 %', '500,000.00 EGP')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineConverted('2,000.00 USD', '48.00', on)),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineShare('100 %', '96,000.00 EGP')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineShare('25 %', '80,000.00 EGP')),
            findsOneWidget,
          );
          expect(textPlain(l10n.zakatLineZakat('2,400.00')), findsOneWidget);
          expect(
            textPlain(l10n.zakatLineShare('0 %', '3,000,000.00 EGP')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineConverted('500.00 USD', '48.00', on)),
            findsOneWidget,
          );
          expect(textPlain('354'), findsNothing);
        },
      );

      testScreen('AC-9: items are ordered by zakatable amount, zero last', (
        tester,
      ) async {
        await pumpYear(tester, locale);
        double top(String name) => tester.getTopLeft(find.text(name)).dy;
        final order = [
          'Gold bar',
          'Savings',
          'US shares',
          'EGX shares',
          'Home',
        ];
        for (var i = 0; i + 1 < order.length; i++) {
          expect(top(order[i]), lessThan(top(order[i + 1])), reason: order[i]);
        }
      });

      testScreen('AC-10: a solar year works out 2.577 % from the same wealth', (
        tester,
      ) async {
        await pumpYear(
          tester,
          locale,
          key: yasminDue,
          seed: (h) async {
            await seedYasmin(h);
            await h.setup(
              zakatPrefs: gold,
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            );
          },
        );
        expect(zakatDueText(tester), '12,885.00 EGP');
        expect(textPlain('2.577 %'), findsWidgets);
      });

      testScreen(
        'AC-21: a line opens its investment and the year follows a new value',
        (tester) async {
          final h = await pumpYear(tester, locale);
          await openLine(tester, 'Savings');
          expect(find.byType(ItemDetailScreen), findsOneWidget);
          expect(find.byKey(const ValueKey('frozen-note')), findsNothing);
          await write(
            tester,
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 15), '140000'),
            ]),
          );
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          expect(find.byType(ItemDetailScreen), findsNothing);
          expect(textPlain('140,000.00'), findsWidgets);
          expect(zakatDueText(tester), '13,000.00 EGP');
          expect(textPlain('520,000.00'), findsWidgets);
        },
      );

      testScreen('AC-21: the extra line and the debts line open their sheets', (
        tester,
      ) async {
        await pumpYear(tester, locale);
        await scrollTo(tester, find.byKey(const ValueKey('extra-cash')));
        await tester.tap(find.byKey(const ValueKey('extra-cash')));
        await tester.pumpAndSettle();
        expect(fieldText(tester, 'extra-label'), 'Cash at home');
        await closeSheet(tester);
        await scrollTo(tester, find.byKey(const ValueKey('debts-row')));
        await tester.tap(find.byKey(const ValueKey('debts-row')));
        await tester.pumpAndSettle();
        expect(fieldText(tester, 'debts-amount'), '20000');
      });

      testScreen(
        'AC-45: a value from before the due date is marked and can be updated for the due date',
        (tester) async {
          await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          final due = shownDate(tester, yasminDue);
          expect(
            textPlain(
              l10n.zakatLineValueDate(shownDate(tester, day(2026, 10, 1))),
            ),
            findsOneWidget,
          );
          expect(textPlain(l10n.zakatOldDateNote(due)), findsOneWidget);
          expect(textPlain(l10n.zakatLineNotRateOf(due)), findsNothing);
          expect(find.text(l10n.zakatStart), findsOneWidget);
          await tester.tap(textPlain(l10n.zakatAddValueFor(due)));
          await tester.pumpAndSettle();
          expect(find.byType(RecordSheet), findsOneWidget);
          expect(textPlain(due), findsWidgets);
          await enter(
            tester,
            find.byKey(const ValueKey('record-amount')),
            '140000',
          );
          await tapKey(tester, 'record-save');
          expect(find.byType(RecordSheet), findsNothing);
          expect(textPlain(l10n.zakatLineValueDate(due)), findsNothing);
          expect(textPlain(l10n.zakatOldDateNote(due)), findsNothing);
          expect(zakatDueText(tester), '13,000.00 EGP');
        },
      );

      testScreen(
        'AC-45: only a USD rate of 47.00 dated 10-10 marks both USD lines',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h, usdRate: false);
              await h.rate(usd, egp, '47', day(2026, 10, 10));
            },
          );
          final l10n = l10nOf(tester);
          final due = shownDate(tester, yasminDue);
          final old = shownDate(tester, day(2026, 10, 10));
          expect(
            textPlain(l10n.zakatLineConverted('2,000.00 USD', '47.00', old)),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineConverted('500.00 USD', '47.00', old)),
            findsOneWidget,
          );
          expect(textPlain(l10n.zakatLineNotRateOf(due)), findsNWidgets(2));
          expect(textPlain(l10n.zakatOldDateNote(due)), findsOneWidget);
          expect(zakatDueText(tester), '12,437.50 EGP');
          expect(find.text(l10n.zakatStart), findsOneWidget);
        },
      );

      testScreen('AC-45: a gold rate dated 10-15 marks the nisab', (
        tester,
      ) async {
        await pumpYear(
          tester,
          locale,
          seed: (h) async {
            await seedYasmin(h, goldRate: false);
            await h.rate(xauG, egp, '5000', day(2026, 10, 15));
          },
        );
        final l10n = l10nOf(tester);
        expect(
          textPlain(l10n.zakatLineNotRateOf(shownDate(tester, yasminDue))),
          findsWidgets,
        );
        expect(find.text(l10n.zakatStart), findsOneWidget);
      });

      testScreen('AC-22: every figure links to its section', (tester) async {
        await pumpYear(tester, locale);
        final l10n = l10nOf(tester);
        Future<void> opens(Finder at, String source) async {
          await scrollTo(tester, at);
          await tester.tap(at);
          await tester.pumpAndSettle();
          expect(find.text(source), findsOneWidget);
          await closeSheet(tester);
        }

        String two(String a, String b) =>
            [zakatSource(l10n, a), zakatSource(l10n, b)].join('\n\n');
        await opens(find.byKey(const ValueKey('zakat-due')), l10n.src_A1A2);
        await opens(find.text(l10n.zakatAddsLines), two('A7', 'A8'));
        await opens(find.text('= ${l10n.zakatAddsBase}'), two('A5', 'C4'));
        await opens(find.text(l10n.zakatAddsNisab('gold')), two('A3', 'Z4'));
        await opens(find.text(l10n.zakatAddsReaches), two('A3', 'C4'));
        await opens(
          find.text('× ${l10n.zakatAddsRate('lunar')}'),
          l10n.src_A1A2,
        );
        await opens(
          find.byKey(const ValueKey('delay-line')),
          zakatSource(l10n, 'C2'),
        );
        final usSource = find.descendant(
          of: find.byKey(const ValueKey('line-US shares')),
          matching: find.text(l10n.source),
        );
        await opens(
          usSource,
          [
            zakatSource(l10n, 'B3', type: AssetType.stock),
            zakatSource(l10n, 'A7'),
          ].join('\n\n'),
        );
        await opens(
          find.descendant(
            of: find.byKey(const ValueKey('extra-loan')),
            matching: find.text(l10n.source),
          ),
          [
            zakatSource(l10n, 'B9'),
            zakatSource(l10n, 'C5'),
            zakatSource(l10n, 'A7'),
          ].join('\n\n'),
        );
        await opens(find.text(l10n.zakatNoteA4), zakatSource(l10n, 'A4'));
        await opens(find.text(l10n.zakatNoteA8), zakatSource(l10n, 'A8'));
        await opens(find.text(l10n.zakatNoteZ4), zakatSource(l10n, 'Z4'));
        await scrollTo(tester, find.byKey(const ValueKey('debts-row')));
        await tester.tap(
          find
              .descendant(
                of: find.byType(ListView),
                matching: find.text(l10n.source),
              )
              .last,
        );
        await tester.pumpAndSettle();
        expect(find.text(two('A5', 'C4')), findsOneWidget);
        expect(find.text(l10n.zakatDebtsWhy), findsWidgets);
      });

      testScreen('AC-22: a rule still to verify says so in its source', (
        tester,
      ) async {
        await pumpYear(tester, en);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.text(l10n.zakatAddsNisab('gold')));
        await tester.tap(find.text(l10n.zakatAddsNisab('gold')));
        await tester.pumpAndSettle();
        expect(textPlain('not yet verified'), findsOneWidget);
        expect(allText(tester), isNot(contains('inflation')));
      });

      testScreen('AC-23: an open year is an estimate and cannot be started', (
        tester,
      ) async {
        final hijri = hijriOf(yasminDue);
        final next = dueDate(ZakatYear.lunar, hijri.m, hijri.d, hijri.y + 1)!;
        await pumpYear(tester, locale, key: next);
        final l10n = l10nOf(tester);
        final on = shownDate(tester, next);
        expect(
          textOf(tester, find.byKey(const ValueKey('state-chip'))),
          l10n.zakatState('open'),
        );
        expect(find.text(l10n.zakatEstimateTag), findsOneWidget);
        expect(
          textOf(tester, find.byKey(const ValueKey('zakat-estimate'))),
          '12,250.00 EGP',
        );
        expect(textPlain(l10n.zakatResultOpenLine(on)), findsOneWidget);
        expect(find.text(l10n.zakatResultUsesToday), findsOneWidget);
        expect(textPlain(l10n.zakatResultStartFrom(on)), findsOneWidget);
        expect(find.byKey(const ValueKey('start-year')), findsNothing);
        expect(find.text(l10n.zakatMoveDate), findsOneWidget);
        expect(find.byKey(const ValueKey('delay-line')), findsNothing);
      });

      testScreen(
        'AC-23: a due year with nothing in it says so and offers no start',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await h.setup(zakatPrefs: gold, cycle: yasminCycle());
              await seedYasminRates(h);
              await seedYasminRecord(h, extras: false);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatResultEmpty), findsOneWidget);
          expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
          expect(find.text(l10n.zakatResultBelow), findsNothing);
          expect(find.byKey(const ValueKey('start-year')), findsNothing);
          expect(find.byKey(const ValueKey('add-investment')), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('add-line-here')));
          await tester.pumpAndSettle();
          expect(find.text(l10n.zakatExtraSheetTitle), findsOneWidget);
        },
      );

      testScreen(
        'AC-23 AC-43: Start is one tap, Undo within 10 s brings back the live year',
        (tester) async {
          final h = await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatStart), findsOneWidget);
          await tapKey(tester, 'start-year');
          expect(find.byType(AlertDialog), findsNothing);
          expect(
            find.text(
              l10n.zakatStartedSnack(l10n.zakatYearLabel('lunar', '1448')),
            ),
            findsOneWidget,
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('distributing'),
          );
          expect(find.byKey(const ValueKey('frozen-banner')), findsOneWidget);
          expect(find.byKey(const ValueKey('add-gift')), findsOneWidget);
          await write(
            tester,
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 15), '140000'),
            ]),
          );
          expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
          await tester.tap(find.text(l10n.undo));
          await tester.pumpAndSettle();
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('due'),
          );
          expect(zakatDueText(tester), '13,000.00 EGP');
          expect(find.byKey(const ValueKey('add-gift')), findsNothing);
        },
      );

      testScreen('AC-43: after 10 seconds Undo is gone', (tester) async {
        await pumpYear(tester, locale);
        final l10n = l10nOf(tester);
        await tapKey(tester, 'start-year');
        expect(find.text(l10n.undo), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 11));
        await tester.pumpAndSettle();
        expect(find.text(l10n.undo), findsNothing);
        expect(
          textOf(tester, find.byKey(const ValueKey('state-chip'))),
          l10n.zakatState('distributing'),
        );
      });

      testScreen(
        'AC-18: deduction off shows "not deducted" and the full total',
        (tester) async {
          await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('debts-deduct')));
          await tester.tap(find.byKey(const ValueKey('debts-deduct')));
          await settle(tester);
          expect(find.text(l10n.zakatAddsNotDeducted), findsWidgets);
          expect(zakatDueText(tester), '13,000.00 EGP');
          expect(textPlain('−20,000.00'), findsNothing);
        },
      );

      testScreen('AC-18: debts above the lines leave 0.00, below nisab', (
        tester,
      ) async {
        await pumpYear(tester, locale);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('debts-row')));
        await tester.tap(find.byKey(const ValueKey('debts-row')));
        await tester.pumpAndSettle();
        await enter(tester, inKey('debts-amount'), '600000');
        await tapKey(tester, 'debts-save');
        expect(find.byType(BottomSheet), findsNothing);
        expect(find.text(l10n.zakatResultBelow), findsOneWidget);
        expect(
          textPlain(l10n.zakatResultBelowFigures('0.00 EGP', '425,000.00 EGP')),
          findsOneWidget,
        );
      });

      testScreen(
        'AC-19: debts of 100,000 leave 420,000.00, below nisab, and the close action',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) => seedYasmin(h, debts: '100000'),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatResultBelow), findsOneWidget);
          expect(
            textPlain(
              l10n.zakatResultBelowFigures('420,000.00 EGP', '425,000.00 EGP'),
            ),
            findsOneWidget,
          );
          expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
          expect(find.text(l10n.zakatClose), findsOneWidget);
          expect(find.text(l10n.zakatStart), findsNothing);
          expect(find.text(l10n.zakatCloseExplain), findsOneWidget);
          expect(find.byKey(const ValueKey('delay-line')), findsNothing);
          await scrollTo(tester, find.text(l10n.zakatNoteZ4));
          expect(find.text(l10n.zakatNoteA4), findsOneWidget);
          expect(find.text(l10n.zakatNoteA8), findsOneWidget);
          await scrollTo(tester, find.text(l10n.zakatResultBelow));
          await tester.tap(find.text(l10n.zakatResultBelow));
          await tester.pumpAndSettle();
          expect(find.text(l10n.zakatWhyBelow), findsOneWidget);
          expect(
            find.text(
              [zakatSource(l10n, 'A3'), zakatSource(l10n, 'C4')].join('\n\n'),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-19: with silver the same wealth reaches nisab and owes 10,500.00',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) => seedYasmin(
              h,
              debts: '100000',
              prefs: const ZakatPrefs(nisab: NisabMetal.silver),
            ),
          );
          expect(zakatDueText(tester), '10,500.00 EGP');
          expect(textPlain('35,700.00'), findsWidgets);
        },
      );

      testScreen('AC-19: wealth equal to the nisab owes zakat', (tester) async {
        await pumpYear(
          tester,
          locale,
          seed: (h) => seedYasmin(h, debts: '95000'),
        );
        expect(zakatDueText(tester), '10,625.00 EGP');
      });

      testScreen(
        'AC-31: below nisab the action is Close this year and the year reads below nisab',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) => seedYasmin(h, debts: '100000'),
          );
          final l10n = l10nOf(tester);
          await tapKey(tester, 'start-year');
          expect(
            find.text(
              l10n.zakatClosedSnack(l10n.zakatYearLabel('lunar', '1448')),
            ),
            findsOneWidget,
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('belowNisab'),
          );
          expect(find.text(l10n.zakatFrozenBelow), findsOneWidget);
          expect(find.byKey(const ValueKey('add-gift')), findsNothing);
          expect(find.text(l10n.zakatState('settled')), findsNothing);
        },
      );

      testScreen(
        'AC-12: a missing USD rate names both lines, hides Z, and adding it completes the year',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) => seedYasmin(h, usdRate: false),
          );
          final l10n = l10nOf(tester);
          final on = shownDate(tester, yasminDue);
          expect(
            textPlain(
              l10n.zakatFixRate('USD→EGP', on, 'US shares, Loan to my brother'),
            ),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatResultIncomplete(1)), findsOneWidget);
          expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
          expect(find.byKey(const ValueKey('delay-line')), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('start-year')));
          await tester.pumpAndSettle();
          expect(find.byType(BottomSheet), findsOneWidget);
          await closeSheet(tester);
          await tester.tap(find.text(l10n.zakatFixAddRate).first);
          await tester.pumpAndSettle();
          await enter(tester, find.byKey(const ValueKey('rate-value')), '48');
          await tapKey(tester, 'rate-save');
          await settle(tester);
          expect(zakatDueText(tester), '12,500.00 EGP');
          expect(find.text(l10n.zakatResultIncomplete(1)), findsNothing);
        },
      );

      testScreen('AC-8: no gold rate: the nisab asks for one and no Z shows', (
        tester,
      ) async {
        await pumpYear(
          tester,
          locale,
          seed: (h) => seedYasmin(h, goldRate: false),
        );
        final l10n = l10nOf(tester);
        final on = shownDate(tester, yasminDue);
        expect(textPlain(l10n.zakatFixMetalRate('gold', on)), findsOneWidget);
        expect(
          textPlain(l10n.zakatFixRate('XAU-g→EGP', on, 'Gold bar')),
          findsOneWidget,
        );
        expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
        expect(find.text(l10n.zakatResultIncomplete(2)), findsOneWidget);
        await tester.tap(find.text(l10n.zakatFixAddRate).first);
        await tester.pumpAndSettle();
        await enter(tester, find.byKey(const ValueKey('rate-value')), '5000');
        await tapKey(tester, 'rate-save');
        await settle(tester);
        expect(zakatDueText(tester), '12,500.00 EGP');
      });

      testScreen(
        'AC-7: no nisab standard is asked as a sheet and then the year works',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) => seedYasmin(h, prefs: const ZakatPrefs()),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatFixNisab), findsOneWidget);
          expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
          await tester.tap(find.text(l10n.zakatFixChoose));
          await tester.pumpAndSettle();
          expect(radioChecked(tester, l10n.zakatNisabGold), isFalse);
          expect(radioChecked(tester, l10n.zakatNisabSilver), isFalse);
          await tester.tap(find.byKey(const ValueKey('nisab-gold')));
          await settle(tester);
          expect(find.byType(BottomSheet), findsNothing);
          expect(zakatDueText(tester), '12,500.00 EGP');
        },
      );

      testScreen(
        'AC-16: an unanswered jewellery question is named, hides Z, and answering completes the year',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await h.addItem(
                item(
                  'Wedding ring',
                  type: AssetType.gold,
                  unit: xauG,
                  intent: Intent.personalUse,
                  rule: ZakatRule.jewelleryPerSetting,
                ),
                [
                  moneyIn('Wedding ring', day(2026, 1, 1), '20', xauG),
                  value('Wedding ring', yasminDue, '20'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(
            find.text(l10n.zakatFixJewellery('Wedding ring')),
            findsOneWidget,
          );
          expect(find.byKey(const ValueKey('zakat-due')), findsNothing);
          expect(
            textPlain(
              '${l10n.zakatQuestionName('jewellery')} · ${l10n.zakatNotAnswered}',
            ),
            findsOneWidget,
          );
          await tester.tap(find.text(l10n.zakatFixAnswer).first);
          await tester.pumpAndSettle();
          await scrollTo(
            tester,
            find.byKey(const ValueKey('assumptions-jewellery-no')),
          );
          await tester.tap(
            find.byKey(const ValueKey('assumptions-jewellery-no')),
          );
          await settle(tester);
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          expect(
            find.text(l10n.zakatFixJewellery('Wedding ring')),
            findsNothing,
          );
          expect(zakatDueText(tester), '12,500.00 EGP');
        },
      );

      testScreen(
        'AC-24: a started year keeps its figures and its deleted item, and opens the others with a note',
        (tester) async {
          final h = await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await startYears(h, [yasminDue]);
            },
          );
          final l10n = l10nOf(tester);
          await writes(tester, [
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 18), '200000'),
            ]),
            () => h.rate(xauG, egp, '6000', yasminDue),
            () => h.assumptions.saveSettings(
              const Settings(
                baseCurrency: egp,
                zakatYear: ZakatYear.lunar,
                zakat: ZakatPrefs(nisab: NisabMetal.silver),
              ),
            ),
            () => h.investments.delete('Home'),
          ]);
          expect(find.byKey(const ValueKey('frozen-banner')), findsOneWidget);
          expect(textPlain('425,000.00'), findsWidgets);
          expect(
            textPlain('${l10n.zakatResultDue} 12,500.00 EGP'),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatAddsNisab('gold')), findsOneWidget);
          expect(find.text(l10n.zakatAddsNisab('silver')), findsNothing);
          expect(find.text('Home'), findsOneWidget);
          expect(find.text(l10n.zakatLineDeleted), findsOneWidget);
          await openLine(tester, 'Home');
          expect(find.byType(ItemDetailScreen), findsNothing);
          expect(find.byKey(const ValueKey('move-date')), findsNothing);
          await openLine(tester, 'Savings');
          expect(find.byType(ItemDetailScreen), findsOneWidget);
          expect(
            find.text(
              l10n.zakatLineFrozenBanner(l10n.zakatYearLabel('lunar', '1448')),
            ),
            findsOneWidget,
          );
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          await write(
            tester,
            () => h.assumptions.saveSettings(
              const Settings(
                baseCurrency: usd,
                zakatYear: ZakatYear.lunar,
                zakat: ZakatPrefs(nisab: NisabMetal.silver),
              ),
            ),
          );
          expect(
            textPlain('${l10n.zakatResultDue} 12,500.00 EGP'),
            findsOneWidget,
          );
          expect(textPlain('425,000.00'), findsWidgets);
        },
      );

      testScreen(
        'AC-25 AC-27: recompute uses new data, keeps the log, and the remaining follows',
        (tester) async {
          final h = await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await startYears(h, [yasminDue]);
              await h.zakat.saveGift(
                yasminDue,
                gift('2026-10-21', '5000', note: 'Masjid'),
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(textPlain('7,500.00'), findsWidgets);
          await writes(tester, [
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 18), '200000'),
            ]),
            () => h.rate(xauG, egp, '6000', yasminDue),
          ]);
          await tapKey(tester, 'recompute');
          expect(
            textPlain(
              l10n.zakatRecomputePreview(
                '12,500.00 EGP',
                '15,750.00 EGP',
                '5,000.00 EGP',
              ),
            ),
            findsOneWidget,
          );
          await tapKey(tester, 'recompute-confirm');
          await settle(tester);
          expect(textPlain('650,000.00'), findsWidgets);
          expect(textPlain('630,000.00'), findsWidgets);
          expect(textPlain('510,000.00'), findsWidgets);
          expect(
            textPlain('${l10n.zakatResultDue} 15,750.00 EGP'),
            findsOneWidget,
          );
          expect(textPlain('10,750.00'), findsWidgets);
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('distributing'),
          );
          expect(
            find.byKey(Key('gift-row-${await _onlyGiftId(tester, h)}')),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-42: recompute after a change of the base currency keeps the year in its own base and its log',
        (tester) async {
          final h = await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await startYears(h, [yasminDue]);
              await h.zakat.saveGift(yasminDue, gift('2026-10-21', '5000'));
            },
          );
          final l10n = l10nOf(tester);
          await write(
            tester,
            () => h.assumptions.saveSettings(
              const Settings(
                baseCurrency: usd,
                zakatYear: ZakatYear.lunar,
                zakat: ZakatPrefs(nisab: NisabMetal.gold),
              ),
            ),
          );
          await writes(tester, [
            () => h.rate(xauG, usd, '100', yasminDue),
            () => h.rate(xagG, usd, '1', yasminDue),
            () => h.rate(egp, usd, '0.02', yasminDue),
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 18), '200000'),
            ]),
          ]);
          await tapKey(tester, 'recompute');
          await tapKey(tester, 'recompute-confirm');
          await settle(tester);
          expect(tester.takeException(), isNull);
          expect(
            textPlain('${l10n.zakatResultDue} 14,500.00 EGP'),
            findsOneWidget,
          );
          expect(textPlain('9,500.00'), findsWidgets);
        },
      );

      testScreen(
        'AC-27: a settled year recomputed to more is distributing again, to less it gives more than due',
        (tester) async {
          final h = await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await startYears(h, [yasminDue]);
              await h.zakat.saveGift(yasminDue, gift('2026-10-21', '5000'));
              await h.zakat.saveGift(yasminDue, gift('2026-10-22', '7500'));
            },
          );
          final l10n = l10nOf(tester);
          expect(find.byKey(const ValueKey('settled')), findsOneWidget);
          await writes(tester, [
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 18), '200000'),
            ]),
            () => h.rate(xauG, egp, '6000', yasminDue),
          ]);
          await tapKey(tester, 'recompute');
          await tapKey(tester, 'recompute-confirm');
          await settle(tester);
          expect(find.byKey(const ValueKey('settled')), findsNothing);
          expect(textPlain('3,250.00'), findsWidgets);
          await writes(tester, [
            () => h.investments.saveEntries([
              value('Savings', day(2026, 10, 19), '100000'),
            ]),
            () => h.rate(xauG, egp, '5000', yasminDue),
          ]);
          await tapKey(tester, 'recompute');
          await tapKey(tester, 'recompute-confirm');
          await settle(tester);
          expect(find.byKey(const ValueKey('settled')), findsOneWidget);
          expect(
            textOf(tester, find.byKey(const ValueKey('given-over'))),
            l10n.zakatGiftOver('500.00 EGP'),
          );
          expect(find.text(l10n.zakatGiftOverHelp), findsOneWidget);
        },
      );

      testScreen(
        'C11: a settled year shows the line, and no text claims the zakat is accepted',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await startYears(h, [yasminDue]);
              await h.zakat.saveGift(
                yasminDue,
                gift('2026-10-21', '5000', note: 'Masjid'),
              );
              await h.zakat.saveGift(yasminDue, gift('2026-10-23', '7500'));
            },
          );
          final l10n = l10nOf(tester);
          expect(
            textOf(tester, find.byKey(const ValueKey('settled'))),
            l10n.zakatState('settled'),
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('c11-line'))),
            l10n.zakatGiftLogNote,
          );
          expect(find.text(l10n.zakatSettledLine), findsOneWidget);
          expect(find.byKey(const ValueKey('add-gift')), findsOneWidget);
          expect(find.byKey(const ValueKey('delay-line')), findsNothing);
          final text = allText(tester).toLowerCase();
          for (final banned in [
            'zakat paid',
            'accepted',
            'fulfilled',
            'your duty is done',
            'برئت الذمة',
            'تقبّل',
          ]) {
            expect(text, isNot(contains(banned)), reason: banned);
          }
          final newer = tester
              .getTopLeft(textPlain(shownDate(tester, day(2026, 10, 23))).first)
              .dy;
          final older = tester
              .getTopLeft(textPlain(shownDate(tester, day(2026, 10, 21))).first)
              .dy;
          expect(newer, lessThan(older));
        },
      );

      testScreen(
        'AC-33: a moved, started year shows everything it was counted with',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await h.zakat.saveYear(
                yasminDue,
                movedDue: day(2026, 10, 21),
                debts: d('20000'),
                deductDebts: true,
              );
              await startYears(h, [yasminDue]);
              await h.zakat.saveGift(
                yasminDue,
                gift('2026-10-21', '5000', note: 'Masjid'),
              );
              await h.zakat.saveGift(
                yasminDue,
                gift(
                  '2026-10-22',
                  '100',
                  unit: usd,
                  rate: d('50'),
                  rateDate: day(2026, 10, 21),
                  view: GivingRateView.dayGiven,
                ),
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(
            textPlain(
              l10n.zakatMovedFrom('lunar', shownDate(tester, yasminDue)),
            ),
            findsOneWidget,
          );
          expect(textPlain(shownDate(tester, day(2026, 10, 21))), findsWidgets);
          expect(
            textPlain(
              l10n.zakatStartedHeader(
                shownDate(tester, yasminToday),
                'lunar',
                '2.5 %',
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(
              l10n.zakatAddsNisabCalc(
                '85',
                '5,000.00',
                shownDate(tester, yasminDue),
              ),
            ),
            findsOneWidget,
          );
          expect(textPlain('425,000.00'), findsWidgets);
          expect(textPlain('Masjid'), findsOneWidget);
          expect(
            textPlain(
              l10n.zakatGiftCountedAt(
                '100.00 USD',
                '50.00',
                shownDate(tester, day(2026, 10, 21)),
                'dayGiven',
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatGiftRemaining('2,625.00 EGP')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatGiftGivenOf('10,000.00', '12,625.00 EGP')),
            findsOneWidget,
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('distributing'),
          );
          expect(find.text('Gold bar'), findsOneWidget);
          expect(find.text('Home'), findsOneWidget);
          expect(
            plain(
              tester
                  .widget<LinearProgressIndicator>(
                    find.byType(LinearProgressIndicator),
                  )
                  .semanticsLabel!,
            ),
            l10n.zakatGiftSemantics(
              '10,000.00 EGP',
              '12,625.00 EGP',
              '2,625.00 EGP',
            ),
          );
        },
      );
    });
  }
}

Future<String> _onlyGiftId(WidgetTester tester, Harness h) async {
  final years = await tester.runAsync(() => h.zakat.watchYears().first);
  return years!.single.gifts.single.id;
}
