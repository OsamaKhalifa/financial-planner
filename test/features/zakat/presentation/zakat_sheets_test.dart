/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/features/zakat/domain/zakat_year.dart';
import 'package:financial_planner/features/investments/presentation/assumptions_screen.dart';
import 'package:financial_planner/features/investments/presentation/home_screen.dart';
import 'package:financial_planner/features/zakat/presentation/year_screen.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_providers.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<Harness> pumpYasmin(WidgetTester tester, Locale locale) => pumpScreen(
  tester,
  YearScreen(yearKey: yasminDue),
  now: yasminToday,
  locale: locale,
  seed: seedYasmin,
);

String due(WidgetTester tester) =>
    textOf(tester, find.byKey(const ValueKey('zakat-due')));

Future<void> openAdd(WidgetTester tester) async {
  await scrollTo(tester, find.byKey(const ValueKey('add-extra')));
  await tester.tap(find.byKey(const ValueKey('add-extra')));
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in [en, ar]) {
    group('sheets (${locale.languageCode})', () {
      testScreen(
        'AC-5: a lunar date moves two days either way and the year follows',
        (tester) async {
          await pumpYasmin(tester, locale);
          final l10n = l10nOf(tester);
          await tapKey(tester, 'move-date');
          for (final d in [18, 19, 20, 21, 22]) {
            expect(find.byKey(ValueKey('move-2026-10-$d')), findsOneWidget);
          }
          expect(find.byKey(const ValueKey('move-2026-10-17')), findsNothing);
          expect(find.byKey(const ValueKey('move-2026-10-23')), findsNothing);
          expect(find.text(l10n.zakatUmmAlQuraLine), findsWidgets);
          await tester.tap(find.byKey(const ValueKey('move-2026-10-21')));
          await tester.pumpAndSettle();
          await tapKey(tester, 'move-save');
          expect(
            textPlain(
              l10n.zakatMovedFrom('lunar', shownDate(tester, yasminDue)),
            ),
            findsOneWidget,
          );
          expect(due(tester), '12,625.00 EGP');
        },
      );

      testScreen('AC-5: a solar date moves earlier only', (tester) async {
        await pumpScreen(
          tester,
          YearScreen(yearKey: day(2027, 10, 20)),
          now: yasminToday,
          locale: locale,
          seed: (h) async {
            await h.setup(
              zakatPrefs: gold,
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            );
            await seedYasminItems(h);
          },
        );
        final l10n = l10nOf(tester);
        await tapKey(tester, 'move-date');
        for (final d in [18, 19, 20]) {
          expect(find.byKey(ValueKey('move-2027-10-$d')), findsOneWidget);
        }
        for (final d in [17, 21]) {
          expect(find.byKey(ValueKey('move-2027-10-$d')), findsNothing);
        }
        expect(find.text(l10n.zakatMoveSolarLine), findsOneWidget);
        expect(find.text(l10n.zakatMoveInfo), findsOneWidget);
      });

      testScreen(
        'AC-17: an extra line needs its kind, an amount, and for owed money the good-debt tick',
        (tester) async {
          await pumpYasmin(tester, locale);
          final l10n = l10nOf(tester);
          await openAdd(tester);
          expect(
            tester
                .widget<FilledButton>(find.byKey(const ValueKey('extra-save')))
                .onPressed,
            isNull,
          );
          expect(find.text(l10n.zakatExtraOtherAssets), findsOneWidget);
          await tester.tap(find.text(l10n.zakatExtraKindOwed));
          await tester.pumpAndSettle();
          expect(find.text(l10n.zakatExtraDoubtful), findsOneWidget);
          await enter(
            tester,
            find.byKey(const ValueKey('extra-label')),
            'Friend',
          );
          await enter(tester, inKey('extra-amount'), '0');
          await tapKey(tester, 'extra-save');
          expect(find.text(l10n.zakatErrAmount), findsOneWidget);
          expect(find.text(l10n.zakatErrGoodDebt), findsOneWidget);
          await enter(tester, find.byKey(const ValueKey('extra-label')), '');
          await tapKey(tester, 'extra-save');
          expect(find.text(l10n.zakatErrExtraLabel), findsOneWidget);
        },
      );

      testScreen(
        'AC-17: a good debt in another currency is converted and saved for this year only',
        (tester) async {
          await pumpYasmin(tester, locale);
          final l10n = l10nOf(tester);
          await openAdd(tester);
          expect(
            find.text(
              l10n.zakatExtraCountedOnly(l10n.zakatYearLabel('lunar', '1448')),
            ),
            findsOneWidget,
          );
          await tester.tap(find.text(l10n.zakatExtraKindOwed));
          await tester.pumpAndSettle();
          await enter(
            tester,
            find.byKey(const ValueKey('extra-label')),
            'Friend',
          );
          await enter(tester, inKey('extra-amount'), '500');
          await pickUnit(tester, 'extra-unit', 'USD');
          expect(
            textPlain(
              l10n.zakatExtraLive(
                '24,000.00 EGP',
                '48.00',
                shownDate(tester, yasminDue),
              ),
            ),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const ValueKey('extra-good-debt')));
          await tester.pumpAndSettle();
          await tapKey(tester, 'extra-save');
          expect(find.byType(BottomSheet), findsNothing);
          expect(find.text(l10n.zakatExtraTitle(3)), findsOneWidget);
          expect(due(tester), '13,100.00 EGP');
        },
      );

      testScreen(
        'AC-17: a metal cannot be an extra line, and a rate-less currency asks for the rate',
        (tester) async {
          await pumpYasmin(tester, locale);
          final l10n = l10nOf(tester);
          await openAdd(tester);
          await tester.tap(find.text(l10n.zakatExtraKindCash));
          await tester.pumpAndSettle();
          await pickUnit(tester, 'extra-unit', 'XAU-g');
          expect(find.text(l10n.zakatErrExtraUnit), findsOneWidget);
          await pickUnit(tester, 'extra-unit', 'SAR');
          await enter(tester, inKey('extra-amount'), '100');
          expect(
            textPlain(l10n.zakatLineRateMissing('SAR→EGP')),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatFixAddRate), findsOneWidget);
        },
      );

      testScreen(
        'an extra line can be opened, deleted, and brought back with Undo',
        (tester) async {
          await pumpYasmin(tester, locale);
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('extra-cash')));
          await tester.tap(find.byKey(const ValueKey('extra-cash')));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.delete));
          await settle(tester);
          expect(find.text(l10n.zakatExtraTitle(1)), findsOneWidget);
          expect(due(tester), '12,250.00 EGP');
          await tester.tap(find.text(l10n.undo));
          await settle(tester);
          expect(find.text(l10n.zakatExtraTitle(2)), findsOneWidget);
          expect(due(tester), '12,500.00 EGP');
        },
      );

      testScreen('Open My Investments leaves the sheet for the investments', (
        tester,
      ) async {
        await pumpYasmin(tester, locale);
        final l10n = l10nOf(tester);
        await openAdd(tester);
        await tester.tap(find.text(l10n.zakatOpenInvestments));
        await tester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testScreen('AC-18: debts are edited in one amount and can be cleared', (
        tester,
      ) async {
        await pumpYasmin(tester, locale);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('debts-row')));
        await tester.tap(find.byKey(const ValueKey('debts-row')));
        await tester.pumpAndSettle();
        expect(find.text(l10n.zakatDebtsHelp), findsOneWidget);
        expect(find.text(l10n.zakatDebtsWhy), findsOneWidget);
        await enter(tester, inKey('debts-amount'), '-5');
        await tapKey(tester, 'debts-save');
        expect(find.text(l10n.zakatErrAmount), findsOneWidget);
        await enter(tester, inKey('debts-amount'), '');
        await tapKey(tester, 'debts-save');
        expect(due(tester), '13,000.00 EGP');
      });
    });

    group('calendar change (${locale.languageCode})', () {
      Future<Harness> pumpSettings(WidgetTester tester) => pumpScreen(
        tester,
        const AssumptionsScreen(),
        now: yasminToday,
        locale: locale,
        seed: (h) async {
          await h.setup(
            zakatPrefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              reminderAsked: true,
            ),
            cycle: ZakatCycle(
              calendar: ZakatYear.lunar,
              month: 9,
              day: 1,
              from: day(2026, 1, 5),
            ),
          );
          await h.zakat.saveExtraLine(
            day(2027, 2, 8),
            ExtraLine(
              id: 'e',
              label: 'Cash',
              kind: ExtraKind.cash,
              amount: Money(d('1000'), egp),
              goodDebtConfirmed: false,
            ),
          );
        },
      );

      testScreen(
        'AC-6: switching to solar keeps the existing years and starts after the open one',
        (tester) async {
          final h = await pumpSettings(tester);
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('year-solar')));
          await tester.tap(find.byKey(const ValueKey('year-solar')));
          await tester.pumpAndSettle();
          final l1447 = l10n.zakatYearLabel('lunar', '1447');
          final l1448 = l10n.zakatYearLabel('lunar', '1448');
          expect(find.text(l10n.zakatChangeToTitle('solar')), findsOneWidget);
          expect(
            textPlain(
              l10n.zakatChangeKeepRow(
                l1447,
                l10n.zakatState('due'),
                shownDate(tester, day(2026, 2, 18)),
                '2.5 %',
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(
              l10n.zakatChangeKeepRow(
                l1448,
                l10n.zakatState('open'),
                shownDate(tester, day(2027, 2, 8)),
                '2.5 %',
              ),
            ),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatChangeAppliesFrom(l1448)), findsOneWidget);
          expect(
            textPlain(
              l10n.zakatChangeStartsAfter(
                'solar',
                shownDate(tester, day(2027, 2, 8)),
              ),
            ),
            findsOneWidget,
          );
          expect(
            tester
                .widget<FilledButton>(find.byKey(const ValueKey('cycle-save')))
                .onPressed,
            isNull,
          );
          await pickCycleDate(tester, locale, ZakatYear.solar, 10, 20);
          expect(
            textPlain(
              l10n.zakatChangeFirstYear(
                'solar',
                '2027',
                shownDate(tester, day(2027, 10, 20)),
                '2.577 %',
              ),
            ),
            findsOneWidget,
          );
          final stored = (await tester.runAsync(
            () => h.assumptions.watchSettings().first,
          ))!;
          expect(stored.zakatYear, ZakatYear.lunar);
          await tapKey(tester, 'cycle-save');
          expect(h.reminder.permissionRequests, 0);
          final years = ProviderScope.containerOf(
            tester.element(find.byType(AssumptionsScreen)),
          ).read(zakatYearsProvider)!;
          expect(
            years.map((y) => (y.slot.number, y.slot.due, y.slot.calendar.r)),
            [
              (1447, day(2026, 2, 18), d('0.025')),
              (1448, day(2027, 2, 8), d('0.025')),
              (2027, day(2027, 10, 20), d('0.02577')),
            ],
          );
          expect(years[1].record!.extras.single.label, 'Cash');
          expect(
            (await tester.runAsync(() => h.assumptions.watchSettings().first))!
                .zakatYear,
            ZakatYear.solar,
          );
        },
      );

      testScreen('AC-6: cancelling changes nothing', (tester) async {
        final h = await pumpSettings(tester);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('year-solar')));
        await tester.tap(find.byKey(const ValueKey('year-solar')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        final cycles = await tester.runAsync(
          () => h.assumptions.watchZakatCycles().first,
        );
        expect(cycles, hasLength(1));
        expect(radioChecked(tester, l10n.zakatYearLunar), isTrue);
      });

      testScreen(
        'AC-6: a new cycle date after a solar one keeps 2027 and starts 2028',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const AssumptionsScreen(),
            now: yasminToday,
            locale: locale,
            seed: (h) => h.setup(
              zakatPrefs: const ZakatPrefs(
                nisab: NisabMetal.gold,
                reminderAsked: true,
              ),
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            ),
          );
          await scrollTo(tester, find.byKey(const ValueKey('cycle-change')));
          await tester.tap(find.byKey(const ValueKey('cycle-change')));
          await tester.pumpAndSettle();
          await pickCycleDate(tester, locale, ZakatYear.solar, 3, 1);
          await tapKey(tester, 'cycle-save');
          final years = ProviderScope.containerOf(
            tester.element(find.byType(AssumptionsScreen)),
          ).read(zakatYearsProvider)!;
          expect(years.map((y) => (y.slot.number, y.slot.due)), [
            (2026, day(2026, 10, 20)),
            (2027, day(2027, 10, 20)),
            (2028, day(2028, 3, 1)),
          ]);
          expect(h.reminder.permissionRequests, 0);
        },
      );
    });
  }
}
