/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/presentation/why_builders.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<Harness> pumpZakat(
  WidgetTester tester,
  Locale locale, {
  ZakatPrefs prefs = gold,
  ZakatYear year = ZakatYear.lunar,
  DateTime? now,
  Future<void> Function(Harness h)? more,
}) => pumpScreen(
  tester,
  const ZakatScreen(),
  now: now ?? yasminToday,
  locale: locale,
  seed: (h) async {
    await h.setup(zakatPrefs: prefs, year: year);
    await more?.call(h);
  },
);

FilledButton nextButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(const ValueKey('setup-next')));

Future<Settings> storedSettings(WidgetTester tester, Harness h) async =>
    (await tester.runAsync(() => h.assumptions.watchSettings().first))!;

void main() {
  for (final locale in [en, ar]) {
    group('Z1 zakat setup (${locale.languageCode})', () {
      testScreen(
        'AC-1: lunar asks a Hijri month and day, empty, with the C1 help and no figure',
        (tester) async {
          await pumpZakat(tester, locale);
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatSetupCycleTitle), findsOneWidget);
          expect(find.text(l10n.zakatCycleHelp('lunar')), findsOneWidget);
          expect(
            l10n.zakatCycleHelp('lunar'),
            contains(locale == en ? 'Hijri months' : 'الأشهر الهجرية'),
          );
          expect(find.text(l10n.zakatCycleNotToday), findsOneWidget);
          expect(find.text(l10n.zakatCalendarLine('lunar')), findsOneWidget);
          final menus = tester
              .widgetList<DropdownMenu<int>>(find.byType(DropdownMenu<int>))
              .toList();
          expect(menus.map((m) => m.initialSelection), [null, null]);
          expect(nextButton(tester).onPressed, isNull);
          expect(find.byKey(const ValueKey('state-chip')), findsNothing);
          expect(find.byKey(const ValueKey('result-card')), findsNothing);
          expect(find.byKey(const ValueKey('next-due')), findsNothing);
        },
      );

      testScreen(
        'AC-1: lunar 1 Ramadan on 2026-10-23 names the year 1448 AH and its due date',
        (tester) async {
          await pumpZakat(tester, locale);
          final l10n = l10nOf(tester);
          await pickCycleDate(tester, locale, ZakatYear.lunar, 9, 1);
          final label = l10n.zakatYearLabel('lunar', '1448');
          expect(
            textPlain(l10n.zakatNextDue('1 ${l10n.hijriMonth('9')} $label')),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatThisYearCalled(label)), findsOneWidget);
          expect(find.text(l10n.zakatPastYears(label)), findsOneWidget);
          expect(textPlain(shownDate(tester, day(2027, 2, 8))), findsOneWidget);
          expect(nextButton(tester).onPressed, isNotNull);
        },
      );

      testScreen(
        'AC-1: solar asks a Gregorian day and month, accepts 29 February and refuses 31 April',
        (tester) async {
          await pumpZakat(tester, locale, year: ZakatYear.solar);
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatCycleHelp('solar')), findsOneWidget);
          expect(
            l10n.zakatCycleHelp('solar'),
            contains(locale == en ? 'Gregorian months' : 'الأشهر الميلادية'),
          );
          await tester.tap(find.byKey(const ValueKey('cycle-day-solar')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('31').last);
          await tester.pumpAndSettle();
          final april = DateFormat.MMMM(locale.languageCode)
              .format(DateTime(2000, 4));
          await tester.tap(find.byKey(const ValueKey('cycle-month-solar')));
          await tester.pumpAndSettle();
          await tester.tap(find.text(april).last);
          await tester.pumpAndSettle();
          expect(
            textOf(tester, find.byKey(const ValueKey('cycle-error'))),
            l10n.zakatBadDay(april, '30'),
          );
          expect(nextButton(tester).onPressed, isNull);
          await pickCycleDate(tester, locale, ZakatYear.solar, 2, 29);
          expect(find.text(l10n.zakatFeb29), findsOneWidget);
          expect(find.byKey(const ValueKey('cycle-error')), findsNothing);
          expect(nextButton(tester).onPressed, isNotNull);
        },
      );

      testScreen(
        'AC-1: solar 20 October saved on 2026-01-05 starts with 2026 and says earlier years are not counted',
        (tester) async {
          await pumpZakat(
            tester,
            locale,
            year: ZakatYear.solar,
            now: day(2026, 1, 5),
          );
          final l10n = l10nOf(tester);
          await pickCycleDate(tester, locale, ZakatYear.solar, 10, 20);
          expect(find.text(l10n.zakatPastYears('2026')), findsOneWidget);
          expect(find.text(l10n.zakatThisYearCalled('2026')), findsOneWidget);
          expect(
            textPlain(l10n.zakatNextDue(shownDate(tester, day(2026, 10, 20)))),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-7: the nisab is asked with both references, nothing selected, and answered once',
        (tester) async {
          final h = await pumpZakat(
            tester,
            locale,
            prefs: const ZakatPrefs(),
            more: (h) => h.rate(xauG, egp, '5000', yasminDue),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatSetupNisabTitle), findsOneWidget);
          expect(find.text(l10n.zakatNisabGold), findsOneWidget);
          expect(find.text(l10n.zakatNisabSilver), findsOneWidget);
          expect(radioChecked(tester, l10n.zakatNisabGold), isFalse);
          expect(radioChecked(tester, l10n.zakatNisabSilver), isFalse);
          expect(
            textPlain(
              l10n.zakatNisabAtRate(
                '425,000.00 EGP',
                shownDate(tester, yasminDue),
              ),
            ),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatNisabAddRate('silver')), findsOneWidget);
          expect(find.text(l10n.zakatNisabWhy), findsOneWidget);
          expect(nextButton(tester).onPressed, isNull);
          await tester.tap(find.text(l10n.source));
          await tester.pumpAndSettle();
          expect(find.text(zakatSource(l10n, 'A3')), findsOneWidget);
          await closeSheet(tester);
          await tester.tap(find.byKey(const ValueKey('nisab-gold')));
          await tester.pumpAndSettle();
          expect(nextButton(tester).onPressed, isNotNull);
          await tapKey(tester, 'setup-next');
          expect(
            (await storedSettings(tester, h)).zakat.nisab,
            NisabMetal.gold,
          );
          expect(find.text(l10n.zakatSetupCycleTitle), findsOneWidget);
          expect(find.text(l10n.zakatSetupNisabTitle), findsNothing);
        },
      );

      testScreen('AC-7: a nisab already answered is not asked again', (
        tester,
      ) async {
        await pumpZakat(tester, locale);
        final l10n = l10nOf(tester);
        expect(find.text(l10n.zakatSetupNisabTitle), findsNothing);
        expect(find.text(l10n.zakatSetupCycleTitle), findsOneWidget);
        expect(find.byKey(const ValueKey('setup-back')), findsNothing);
      });

      testScreen('Back returns to the step before', (tester) async {
        await pumpZakat(tester, locale);
        final l10n = l10nOf(tester);
        await pickCycleDate(tester, locale, ZakatYear.lunar, 9, 1);
        await tapKey(tester, 'setup-next');
        expect(find.text(l10n.zakatSetupRemindTitle), findsOneWidget);
        await tapKey(tester, 'setup-back');
        expect(find.text(l10n.zakatSetupCycleTitle), findsOneWidget);
      });

      testScreen(
        'AC-34 AC-35: Save writes the cycle with 0 days at 09:00 and the phone is asked once',
        (tester) async {
          final h = await pumpZakat(
            tester,
            locale,
            year: ZakatYear.solar,
            now: day(2026, 1, 5),
          );
          final l10n = l10nOf(tester);
          expect(h.reminder.permissionRequests, 0);
          await pickCycleDate(tester, locale, ZakatYear.solar, 10, 20);
          await tapKey(tester, 'setup-next');
          expect(h.reminder.permissionRequests, 0);
          expect(fieldText(tester, 'reminder-days'), '0');
          expect(
            textOf(tester, find.byKey(const ValueKey('reminder-time'))),
            '09:00',
          );
          expect(
            textPlain(
              l10n.reminderPreview(
                shownDate(tester, DateTime(2026, 10, 20)),
                '09:00',
                l10n.reminderBodyToday('2026'),
              ),
            ),
            findsOneWidget,
          );
          expect(find.text(l10n.reminderPermissionLine), findsOneWidget);
          await tapKey(tester, 'setup-next');
          expect(h.reminder.permissionRequests, 1);
          final saved = await storedSettings(tester, h);
          expect(saved.zakat.reminderAsked, isTrue);
          expect(saved.zakatYear, ZakatYear.solar);
          final cycles = await tester.runAsync(
            () => h.assumptions.watchZakatCycles().first,
          );
          expect(cycles!.map((c) => (c.calendar, c.month, c.day, c.from)), [
            (ZakatYear.solar, 10, 20, day(2026, 1, 5)),
          ]);
          expect(find.text(l10n.zakatSetupRemindTitle), findsNothing);
          expect(find.byKey(const ValueKey('state-chip')), findsOneWidget);
        },
      );

      testScreen(
        'AC-38: a refusal from the phone says so and the cycle date is still saved',
        (tester) async {
          final h = await pumpZakat(
            tester,
            locale,
            more: (h) async => h.reminder.permitted = false,
          );
          final l10n = l10nOf(tester);
          await pickCycleDate(tester, locale, ZakatYear.lunar, 9, 1);
          await tapKey(tester, 'setup-next');
          await tapKey(tester, 'setup-next');
          expect(h.reminder.permissionRequests, 1);
          expect(find.text(l10n.reminderDenied), findsOneWidget);
          final cycles = await tester.runAsync(
            () => h.assumptions.watchZakatCycles().first,
          );
          expect(cycles, hasLength(1));
          expect(h.reminder.pending, isNull);
        },
      );

      testScreen(
        'AC-40: days before must be 0 to 60, and the buttons stay inside',
        (tester) async {
          await pumpZakat(tester, locale);
          final l10n = l10nOf(tester);
          await pickCycleDate(tester, locale, ZakatYear.lunar, 9, 1);
          await tapKey(tester, 'setup-next');
          Future<void> type(String text) =>
              enter(tester, find.byKey(const ValueKey('reminder-days')), text);
          await type('61');
          expect(find.text(l10n.reminderDaysError), findsOneWidget);
          expect(nextButton(tester).onPressed, isNull);
          await type('-1');
          expect(find.text(l10n.reminderDaysError), findsOneWidget);
          await type('60');
          expect(find.text(l10n.reminderDaysError), findsNothing);
          expect(nextButton(tester).onPressed, isNotNull);
          await tapKey(tester, 'days-plus');
          expect(fieldText(tester, 'reminder-days'), '60');
          await type('0');
          await tapKey(tester, 'days-minus');
          expect(fieldText(tester, 'reminder-days'), '0');
          await tapKey(tester, 'days-plus');
          expect(fieldText(tester, 'reminder-days'), '1');
        },
      );

      testScreen(
        'AC-40: a reminder moment that has passed is said, not scheduled',
        (tester) async {
          final h = await pumpZakat(
            tester,
            locale,
            year: ZakatYear.solar,
            prefs: const ZakatPrefs(nisab: NisabMetal.gold, reminderDays: 5),
          );
          final l10n = l10nOf(tester);
          await pickCycleDate(tester, locale, ZakatYear.solar, 10, 25);
          await tapKey(tester, 'setup-next');
          expect(fieldText(tester, 'reminder-days'), '5');
          expect(find.text(l10n.reminderPast('2026')), findsOneWidget);
          await tapKey(tester, 'setup-next');
          expect(h.reminder.pending, isNull);
          expect(h.reminder.scheduled, isEmpty);
        },
      );
    });
  }
}
