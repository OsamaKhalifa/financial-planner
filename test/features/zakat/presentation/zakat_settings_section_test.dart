/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/presentation/assumptions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<Harness> pumpS8(
  WidgetTester tester,
  Locale locale, {
  ZakatPrefs prefs = gold,
  bool cycle = true,
  Future<void> Function(Harness h)? more,
}) => pumpScreen(
  tester,
  const AssumptionsScreen(),
  now: yasminToday,
  locale: locale,
  seed: (h) async {
    await h.setup(
      zakatPrefs: prefs,
      cycle: cycle ? solarCycle(10, 20, day(2026, 1, 5)) : null,
    );
    await more?.call(h);
  },
);

Future<Settings> stored(WidgetTester tester, Harness h) async =>
    (await tester.runAsync(() => h.assumptions.watchSettings().first))!;

void main() {
  for (final locale in [en, ar]) {
    group('S8 zakat section (${locale.languageCode})', () {
      testScreen('the zakat year without a cycle changes at once', (
        tester,
      ) async {
        final h = await pumpS8(tester, locale, cycle: false);
        await scrollTo(tester, find.byKey(const ValueKey('year-solar')));
        await tester.tap(find.byKey(const ValueKey('year-solar')));
        await settle(tester);
        expect((await stored(tester, h)).zakatYear, ZakatYear.solar);
      });

      testScreen(
        'the zakat year with a cycle opens the change sheet and stays',
        (tester) async {
          final h = await pumpS8(tester, locale);
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('year-lunar')));
          await tester.tap(find.byKey(const ValueKey('year-lunar')));
          await tester.pumpAndSettle();
          expect(find.text(l10n.zakatChangeToTitle('lunar')), findsOneWidget);
          expect((await stored(tester, h)).zakatYear, ZakatYear.solar);
        },
      );

      testScreen('the nisab standard shows the choice and writes a new one', (
        tester,
      ) async {
        final h = await pumpS8(tester, locale);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('nisab-gold')));
        expect(radioChecked(tester, l10n.zakatNisabGold), isTrue);
        expect(find.text(l10n.zakatSettingsNisabHelp), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('nisab-silver')));
        await settle(tester);
        expect((await stored(tester, h)).zakat.nisab, NisabMetal.silver);
      });

      testScreen('the cycle date row names the date, or says it is not set', (
        tester,
      ) async {
        await pumpS8(tester, locale);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('cycle-row')));
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('cycle-row')),
            matching: find.textContaining('20'),
          ),
          findsWidgets,
        );
        expect(find.text(l10n.zakatNotSetYet), findsNothing);
      });

      testScreen('without a cycle the row says not set yet', (tester) async {
        await pumpS8(tester, locale, cycle: false);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('cycle-row')));
        expect(find.text(l10n.zakatNotSetYet), findsOneWidget);
      });

      testScreen(
        'AC-44: the reminder switch is stored and its subtitle follows',
        (tester) async {
          final h = await pumpS8(tester, locale);
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('reminder-switch')));
          expect(
            find.text(l10n.reminderOnSubtitle(0, '09:00')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const ValueKey('reminder-switch')));
          await settle(tester);
          expect((await stored(tester, h)).zakat.reminderOn, isFalse);
          expect(find.text(l10n.reminderOffSubtitle), findsOneWidget);
          expect(find.byKey(const ValueKey('reminder-change')), findsNothing);
        },
      );

      testScreen('the reminder sheet takes 0 to 60 days and a time', (
        tester,
      ) async {
        final h = await pumpS8(tester, locale);
        final l10n = l10nOf(tester);
        await scrollTo(tester, find.byKey(const ValueKey('reminder-change')));
        await tester.tap(find.byKey(const ValueKey('reminder-change')));
        await tester.pumpAndSettle();
        await enter(tester, find.byKey(const ValueKey('reminder-days')), '61');
        expect(find.text(l10n.reminderDaysError), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(find.byKey(const ValueKey('reminder-save')))
              .onPressed,
          isNull,
        );
        await enter(tester, find.byKey(const ValueKey('reminder-days')), '60');
        await tapKey(tester, 'reminder-save');
        final s = await stored(tester, h);
        expect((s.zakat.reminderDays, s.zakat.reminderMinute), (60, 540));
        expect(s.zakat.nisab, NisabMetal.gold);
      });

      testScreen(
        'AC-38: refused in the phone settings, the switch is off-limits and says why',
        (tester) async {
          await pumpS8(
            tester,
            locale,
            prefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              reminderAsked: true,
            ),
            more: (h) async => h.reminder.permitted = false,
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('reminder-switch')));
          expect(find.text(l10n.reminderBlocked), findsOneWidget);
          expect(
            tester
                .widget<SwitchListTile>(
                  find.byKey(const ValueKey('reminder-switch')),
                )
                .onChanged,
            isNull,
          );
        },
      );

      testScreen(
        'AC-30: the giving rate view is "not asked yet" until Z7 asks; a change is said',
        (tester) async {
          final h = await pumpS8(tester, locale);
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.text(l10n.zakatSettingsRateView));
          expect(find.text(l10n.zakatSettingsRateViewNone), findsWidgets);
          expect(
            find.byKey(const ValueKey('rate-view-dayGiven')),
            findsNothing,
          );
          await write(
            tester,
            () => h.assumptions.saveSettings(
              const Settings(
                baseCurrency: egp,
                zakatYear: ZakatYear.solar,
                zakat: ZakatPrefs(
                  nisab: NisabMetal.gold,
                  givingRateView: GivingRateView.dayGiven,
                ),
              ),
            ),
          );
          await scrollTo(
            tester,
            find.byKey(const ValueKey('rate-view-dueDate')),
          );
          expect(radioChecked(tester, l10n.zakatGiftViewDay), isTrue);
          await tester.tap(find.byKey(const ValueKey('rate-view-dueDate')));
          await settle(tester);
          expect(
            (await stored(tester, h)).zakat.givingRateView,
            GivingRateView.dueDate,
          );
          expect(find.text(l10n.zakatRateViewChanged), findsWidgets);
          expect(find.byType(SnackBar), findsOneWidget);
        },
      );
    });
  }
}
