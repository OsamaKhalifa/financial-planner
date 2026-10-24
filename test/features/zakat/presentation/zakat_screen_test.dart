/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/assumptions_screen.dart';
import 'package:financial_planner/features/settings/settings_screen.dart';
import 'package:financial_planner/features/zakat/domain/year_end_reminder.dart';
import 'package:financial_planner/features/zakat/presentation/history_screen.dart';
import 'package:financial_planner/features/zakat/presentation/year_screen.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_screen.dart';
import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<Harness> pumpZakatTab(
  WidgetTester tester,
  Locale locale, {
  required DateTime now,
  required Future<void> Function(Harness h) seed,
  Widget home = const ZakatScreen(),
}) => pumpScreen(tester, home, now: now, locale: locale, seed: seed);

Reminder nowAt(String yearKey) => Reminder(
  yearKey: yearKey,
  fireAt: DateTime(2000),
  title: 'stale',
  body: 'stale',
);

/// 2024, 2025 and 2026 are due (solar 20 October); 2027 is open. 2024 lacks
/// its USD rate, 2025 reaches nisab, 2026 does not (AC-39).
Future<void> seedThreeDueYears(Harness h) async {
  await h.setup(zakatPrefs: gold, cycle: solarCycle(10, 20, day(2024, 1, 1)));
  await h.rate(xauG, egp, '5000', day(2024, 1, 1));
  await h.rate(usd, egp, '48', day(2025, 1, 1));
  await h.addItem(
    item(
      'Savings',
      type: AssetType.cashDeposit,
      intent: null,
      rule: ZakatRule.cash100,
      start: day(2024, 1, 1),
    ),
    [
      moneyIn('Savings', day(2024, 1, 1), '500000'),
      value('Savings', day(2024, 1, 1), '500000'),
      value('Savings', day(2026, 6, 1), '100000'),
    ],
  );
  await h.addItem(
    item(
      'US shares',
      type: AssetType.stock,
      unit: usd,
      rule: ZakatRule.trading100,
      start: day(2024, 1, 1),
    ),
    [
      moneyIn('US shares', day(2024, 1, 1), '1000', usd),
      value('US shares', day(2024, 1, 1), '1000'),
    ],
  );
}

void main() {
  for (final locale in [en, ar]) {
    group('Zakat tab (${locale.languageCode})', () {
      testScreen('with nothing answered the tab asks, it shows no figure', (
        tester,
      ) async {
        await pumpZakatTab(
          tester,
          locale,
          now: yasminToday,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.zakatSetupNisabTitle), findsOneWidget);
        expect(find.byKey(const ValueKey('result-card')), findsNothing);
        expect(find.byKey(const ValueKey('zakat-history')), findsOneWidget);
        expect(find.byType(SettingsAction), findsOneWidget);
      });

      testScreen(
        'the focus year is shown with a due text, and the app bar opens History and the assumptions',
        (tester) async {
          await pumpZakatTab(
            tester,
            locale,
            now: yasminToday,
            seed: seedYasmin,
          );
          final l10n = l10nOf(tester);
          expect(
            find.text(l10n.zakatDueIs(l10n.zakatYearLabel('lunar', '1448'))),
            findsOneWidget,
          );
          expect(find.byKey(const ValueKey('result-card')), findsOneWidget);
          expect(find.byKey(const ValueKey('zakat-due')), findsOneWidget);
          await tapKey(tester, 'zakat-history');
          expect(find.byType(HistoryScreen), findsOneWidget);
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .push(
                MaterialPageRoute<void>(
                  builder: (_) => const AssumptionsScreen(),
                ),
              );
          await tester.pumpAndSettle();
          expect(find.byType(AssumptionsScreen), findsOneWidget);
        },
      );

      testScreen('an open year shows no due text', (tester) async {
        await pumpZakatTab(
          tester,
          locale,
          now: day(2026, 10, 10),
          seed: (h) async {
            await h.setup(zakatPrefs: gold, cycle: yasminCycle());
          },
        );
        final l10n = l10nOf(tester);
        expect(find.textContaining(l10n.zakatDueIs('')), findsNothing);
        expect(
          textOf(tester, find.byKey(const ValueKey('state-chip'))),
          l10n.zakatState('open'),
        );
        expect(find.byKey(const ValueKey('delay-line')), findsNothing);
      });

      testScreen(
        'AC-39: each due year has its text, with or without notifications, and starting one removes its text',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: yasminToday,
            seed: (h) async {
              await seedThreeDueYears(h);
              h.reminder.permitted = false;
            },
          );
          final l10n = l10nOf(tester);
          String on(int year) => shownDate(tester, day(year, 10, 20));
          final incomplete = l10n.zakatDueIncomplete('2024', on(2024));
          final owes = l10n.zakatDueIs('2025');
          final below = l10n.zakatDueBelow('2026', on(2026));
          expect(textPlain(incomplete), findsOneWidget);
          expect(find.text(owes), findsOneWidget);
          expect(textPlain(below), findsOneWidget);
          expect(
            tester.getTopLeft(textPlain(incomplete)).dy,
            lessThan(tester.getTopLeft(find.text(owes)).dy),
          );
          expect(
            tester.getTopLeft(find.text(owes)).dy,
            lessThan(tester.getTopLeft(textPlain(below)).dy),
          );
          expect(h.reminder.pending, isNull);
          expect(find.byKey(const ValueKey('delay-line')), findsOneWidget);
          await tester.tap(find.text(owes));
          await tester.pumpAndSettle();
          expect(find.byType(YearScreen), findsOneWidget);
          expect(find.byKey(const ValueKey('delay-line')), findsOneWidget);
          await tapKey(tester, 'start-year');
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          expect(find.text(owes), findsNothing);
          expect(textPlain(incomplete), findsOneWidget);
          expect(textPlain(below), findsOneWidget);
          await tester.tap(textPlain(below));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('delay-line')), findsNothing);
        },
      );

      testScreen(
        'AC-35: a solar cycle saved on 2026-01-05 gets one notification, on its due date at 09:00',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 1, 5, 8),
            seed: (h) => h.setup(
              zakatPrefs: gold,
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            ),
          );
          final l10n = l10nOf(tester);
          final sent = h.reminder.pending!;
          expect(sent.fireAt, DateTime(2026, 10, 20, 9));
          expect(sent.yearKey, '2026-10-20');
          expect(sent.title, l10n.reminderTitle);
          expect(sent.body, l10n.reminderBodyToday('2026'));
          expect(h.reminder.scheduled, hasLength(1));
          expect(h.requests, isEmpty);
        },
      );

      testScreen(
        'AC-35: lunar 1 Ramadan saved on 2026-10-23 is year 1448 AH on 2027-02-08',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 10, 23, 8),
            seed: (h) => h.setup(
              zakatPrefs: gold,
              cycle: ZakatCycle(
                calendar: ZakatYear.lunar,
                month: 9,
                day: 1,
                from: day(2026, 10, 23),
              ),
            ),
          );
          final l10n = l10nOf(tester);
          final sent = h.reminder.pending!;
          expect(sent.fireAt, DateTime(2027, 2, 8, 9));
          expect(
            sent.body,
            l10n.reminderBodyToday(l10n.zakatYearLabel('lunar', '1448')),
          );
          for (final banned in [
            'late',
            'missed',
            'overdue',
            'default',
            'is due',
          ]) {
            expect(sent.body.toLowerCase(), isNot(contains(banned)));
          }
        },
      );

      testScreen(
        'AC-37: at every start one reminder replaces whatever was pending',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 10, 23, 8),
            seed: (h) async {
              await h.setup(
                zakatPrefs: gold,
                cycle: solarCycle(10, 20, day(2026, 1, 5)),
              );
              h.reminder.pending = nowAt('2026-10-20');
            },
          );
          expect(h.reminder.scheduled, hasLength(1));
          expect(h.reminder.pending!.yearKey, '2027-10-20');
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 20, 9));
        },
      );

      testScreen(
        'AC-37: moving the due date, or the days and the time, reschedules; a new cycle does not',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 10, 23, 8),
            seed: (h) => h.setup(
              zakatPrefs: gold,
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            ),
          );
          final l10n = l10nOf(tester);
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 20, 9));
          await write(
            tester,
            () => h.zakat.saveYear(
              day(2027, 10, 20),
              movedDue: day(2027, 10, 18),
              debts: d('0'),
              deductDebts: true,
            ),
          );
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 18, 9));
          expect(h.reminder.pending!.yearKey, '2027-10-20');
          final count = h.reminder.scheduled.length;
          await write(
            tester,
            () async => h.assumptions.saveSettings(
              const Settings(
                baseCurrency: egp,
                zakatYear: ZakatYear.solar,
                zakat: ZakatPrefs(
                  nisab: NisabMetal.gold,
                  reminderDays: 3,
                  reminderMinute: 20 * 60 + 30,
                ),
              ),
            ),
          );
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 15, 20, 30));
          expect(
            h.reminder.pending!.body,
            l10n.reminderBodyOn('2027', shownDate(tester, day(2027, 10, 18))),
          );
          final after = h.reminder.scheduled.length;
          expect(after, count + 1);
          final settings = (await tester.runAsync(
            () => h.assumptions.watchSettings().first,
          ))!;
          await write(
            tester,
            () => h.assumptions.saveZakatCycle(
              settings,
              solarCycle(3, 1, day(2027, 10, 21)),
            ),
          );
          expect(h.reminder.scheduled, hasLength(after));
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 15, 20, 30));
        },
      );

      testScreen(
        'AC-40: three days before at 20:30 is 2027-10-17 and says when the year ends',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 10, 23, 8),
            seed: (h) => h.setup(
              zakatPrefs: const ZakatPrefs(
                nisab: NisabMetal.gold,
                reminderDays: 3,
                reminderMinute: 20 * 60 + 30,
              ),
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            ),
          );
          final l10n = l10nOf(tester);
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 17, 20, 30));
          expect(
            h.reminder.pending!.body,
            l10n.reminderBodyOn('2027', shownDate(tester, day(2027, 10, 20))),
          );
        },
      );

      testScreen(
        'AC-40: a moment already past gives no notification, and the due text shows once the year ends',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 10, 23, 8),
            seed: (h) => h.setup(
              zakatPrefs: const ZakatPrefs(
                nisab: NisabMetal.gold,
                reminderDays: 5,
              ),
              cycle: solarCycle(10, 25, day(2026, 1, 5)),
            ),
          );
          expect(h.reminder.pending, isNull);
          expect(h.reminder.scheduled, isEmpty);
        },
      );

      testScreen('AC-40: and on 2026-10-25 the due text shows', (tester) async {
        await pumpZakatTab(
          tester,
          locale,
          now: DateTime(2026, 10, 25, 8),
          seed: (h) => h.setup(
            zakatPrefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              reminderDays: 5,
            ),
            cycle: solarCycle(10, 25, day(2026, 1, 5)),
          ),
        );
        final l10n = l10nOf(tester);
        expect(
          textPlain(
            l10n.zakatDueIncomplete(
              '2026',
              shownDate(tester, day(2026, 10, 25)),
            ),
          ),
          findsOneWidget,
        );
      });

      testScreen('AC-38: without permission nothing is scheduled', (
        tester,
      ) async {
        final h = await pumpZakatTab(
          tester,
          locale,
          now: DateTime(2026, 10, 23, 8),
          seed: (h) async {
            await h.setup(
              zakatPrefs: gold,
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            );
            h.reminder.permitted = false;
          },
        );
        expect(h.reminder.pending, isNull);
        expect(h.reminder.scheduled, isEmpty);
      });

      testScreen(
        'AC-44: switched off, nothing is scheduled and the due text still shows; switched on, one is',
        (tester) async {
          final h = await pumpZakatTab(
            tester,
            locale,
            now: DateTime(2026, 10, 23, 8),
            seed: (h) => h.setup(
              zakatPrefs: const ZakatPrefs(
                nisab: NisabMetal.gold,
                reminderOn: false,
              ),
              cycle: solarCycle(10, 20, day(2026, 1, 5)),
            ),
          );
          final l10n = l10nOf(tester);
          expect(h.reminder.pending, isNull);
          expect(
            textPlain(
              l10n.zakatDueIncomplete(
                '2026',
                shownDate(tester, day(2026, 10, 20)),
              ),
            ),
            findsOneWidget,
          );
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .push(
                MaterialPageRoute<void>(
                  builder: (_) => const AssumptionsScreen(),
                ),
              );
          await tester.pumpAndSettle();
          await scrollTo(tester, find.byKey(const ValueKey('reminder-switch')));
          await tester.tap(find.byKey(const ValueKey('reminder-switch')));
          await settle(tester);
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 20, 9));
          await tester.tap(find.byKey(const ValueKey('reminder-switch')));
          await settle(tester);
          expect(h.reminder.pending, isNull);
          await tester.tap(find.byKey(const ValueKey('reminder-switch')));
          await settle(tester);
          expect(h.reminder.pending!.fireAt, DateTime(2027, 10, 20, 9));
        },
      );

      testScreen('AC-44: a started year has no reminder', (tester) async {
        final h = await pumpZakatTab(
          tester,
          locale,
          now: DateTime(2026, 10, 20, 8),
          seed: (h) async {
            await seedYasmin(h);
            await startYears(h, [yasminDue]);
          },
        );
        expect(h.reminder.pending, isNull);
      });
    });

    group('Notification routing (${locale.languageCode})', () {
      Future<Harness> pumpApp(WidgetTester tester, {String? launchKey}) =>
          pumpScreen(
            tester,
            const RootGate(),
            now: yasminToday,
            locale: locale,
            seed: (h) async {
              await seedYasmin(h);
              h.reminder.launchKey = launchKey;
            },
          );

      NavigationBar bar(WidgetTester tester) =>
          tester.widget<NavigationBar>(find.byType(NavigationBar));

      testScreen(
        'AC-36: opening the app from the notification lands on its year',
        (tester) async {
          await pumpApp(tester, launchKey: '2026-10-20');
          final l10n = l10nOf(tester);
          expect(find.byType(YearScreen), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text(l10n.zakatYearLabel('lunar', '1448')),
            ),
            findsOneWidget,
          );
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          expect(bar(tester).selectedIndex, AppShell.zakatTab);
        },
      );

      testScreen(
        'AC-36: a tap while the app runs selects the tab and opens the year',
        (tester) async {
          final h = await pumpApp(tester);
          final l10n = l10nOf(tester);
          expect(bar(tester).selectedIndex, 0);
          expect(find.byType(YearScreen), findsNothing);
          h.reminder.tap('2026-10-20');
          await settle(tester);
          expect(find.byType(YearScreen), findsOneWidget);
          tester.state<NavigatorState>(find.byType(Navigator)).pop();
          await tester.pumpAndSettle();
          expect(bar(tester).selectedIndex, AppShell.zakatTab);
          expect(
            find.descendant(
              of: find.byType(NavigationBar),
              matching: find.text(l10n.tabZakat),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'a notification of a year that no longer exists shows the focus year',
        (tester) async {
          final h = await pumpApp(tester);
          h.reminder.tap('2000-01-01');
          await settle(tester);
          expect(find.byType(YearScreen), findsNothing);
          expect(bar(tester).selectedIndex, AppShell.zakatTab);
          expect(find.byKey(const ValueKey('result-card')), findsOneWidget);
        },
      );
    });
  }
}
