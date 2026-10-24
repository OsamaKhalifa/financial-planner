/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

// QA audit of the zakat story (docs/product/stories/zakat.md): the places where
// an AC names a number, a text or a negative ("never ...") that the other
// widget tests only touched. One test per gap, named after the AC.

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/zakat/presentation/history_screen.dart';
import 'package:financial_planner/features/zakat/presentation/year_screen.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_screen.dart';
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

void main() {
  for (final locale in [en, ar]) {
    group('QA audit (${locale.languageCode})', () {
      testScreen(
        'AC-9: each line shows the zakat on it, the debts line shows its negative zakat',
        (tester) async {
          await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          final onLine = {
            'line-Savings': '3,000.00',
            'line-Gold bar': '6,250.00',
            'line-US shares': '2,400.00',
            'line-EGX shares': '500.00',
            'line-Home': '0.00',
          };
          for (final e in onLine.entries) {
            final row = find.byKey(ValueKey(e.key));
            await scrollTo(tester, row);
            expect(
              find.descendant(
                of: row,
                matching: textPlain(l10n.zakatLineZakat(e.value)),
              ),
              findsOneWidget,
              reason: e.key,
            );
          }
          await scrollTo(tester, find.byKey(const ValueKey('debts-row')));
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('debts-row')),
              matching: textPlain(l10n.zakatDebtsZakat('500.00')),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('debts-row')),
              matching: textPlain('−20,000.00'),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-9: the extra lines show their share and the zakat on the line, like the other lines',
        (tester) async {
          await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          final onLine = {
            'extra-cash': ('10,000.00 EGP', '250.00'),
            'extra-loan': ('24,000.00 EGP', '600.00'),
          };
          for (final e in onLine.entries) {
            final row = find.byKey(ValueKey(e.key));
            await scrollTo(tester, row);
            expect(
              find.descendant(
                of: row,
                matching: textPlain(l10n.zakatLineShare('100 %', e.value.$1)),
              ),
              findsOneWidget,
              reason: '${e.key} share',
            );
            expect(
              find.descendant(
                of: row,
                matching: textPlain(l10n.zakatLineZakat(e.value.$2)),
              ),
              findsOneWidget,
              reason: '${e.key} zakat on the line',
            );
          }
        },
      );

      testScreen(
        'AC-15: a dividends-only line shows 0.00 and the dividends notice, and a profit-only private equity line its payout notice',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await seedYasmin(h);
              await h.addItem(
                item(
                  'Dividend shares',
                  type: AssetType.stock,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermDividendsOnly,
                ),
                [
                  moneyIn('Dividend shares', day(2026, 1, 1), '50000'),
                  value('Dividend shares', yasminDue, '50000'),
                ],
              );
              await h.addItem(
                item(
                  'Friend project',
                  type: AssetType.privateEquity,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermDividendsOnly,
                ),
                [
                  moneyIn('Friend project', day(2026, 1, 1), '70000'),
                  value('Friend project', yasminDue, '70000'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.zakatLineDividendsNotice), findsOneWidget);
          expect(
            textPlain(l10n.noticeProfitPayoutsOnly('2.5 %')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineShare('0 %', '50,000.00 EGP')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatLineShare('0 %', '70,000.00 EGP')),
            findsOneWidget,
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('zakat-due'))),
            '12,500.00 EGP',
          );
        },
      );

      testScreen(
        'AC-45: with the only gold rate dated 10-15 the nisab and the Gold bar each say "not the rate of" the due date, and one note shows',
        (tester) async {
          await pumpYear(
            tester,
            locale,
            seed: (h) async {
              await h.setup(zakatPrefs: gold, cycle: yasminCycle());
              await seedYasminItems(h);
              await h.rate(xauG, egp, '5000', day(2026, 10, 15));
              await h.rate(usd, egp, '48', yasminDue);
              await h.investments.saveEntries([
                value('Savings', yasminDue, '120000'),
              ]);
              await seedYasminRecord(h);
            },
          );
          final l10n = l10nOf(tester);
          final due = shownDate(tester, yasminDue);
          expect(textPlain(l10n.zakatLineNotRateOf(due)), findsNWidgets(2));
          expect(textPlain(l10n.zakatOldDateNote(due)), findsOneWidget);
          expect(
            textPlain(
              l10n.zakatAddsNisabCalc(
                '85',
                '5,000.00',
                shownDate(tester, day(2026, 10, 15)),
              ),
            ),
            findsOneWidget,
          );
          expect(find.text(l10n.zakatStart), findsOneWidget);
        },
      );

      testScreen(
        'AC-39: the do-not-delay line stays on a started year until it is settled, and is not in the notification',
        (tester) async {
          final h = await pumpYear(tester, locale);
          final l10n = l10nOf(tester);
          expect(find.byKey(const ValueKey('delay-line')), findsOneWidget);
          await tapKey(tester, 'start-year');
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('distributing'),
          );
          expect(find.byKey(const ValueKey('delay-line')), findsOneWidget);
          expect(find.text(l10n.zakatDueDelayLine), findsOneWidget);
          expect(h.reminder.pending, isNull);
          expect(
            l10n.reminderBodyToday('1448').contains(l10n.zakatDueDelayLine),
            isFalse,
          );
        },
      );

      testScreen(
        'AC-22: no inflation-adjusted or real-value figure appears on the year, the tab or the history',
        (tester) async {
          final banned = RegExp(
            'inflation|real return|real value|purchasing|تضخم|القوة الشرائية',
            caseSensitive: false,
          );
          Future<void> scan(Widget screen) async {
            await pumpScreen(
              tester,
              screen,
              now: yasminToday,
              locale: locale,
              seed: (h) async {
                await seedYasmin(h);
                await startYears(h, [yasminDue]);
                await h.zakat.saveGift(yasminDue, gift('2026-10-21', '500'));
              },
            );
            expect(banned.hasMatch(allText(tester)), isFalse);
          }

          await scan(const ZakatScreen());
          await scan(YearScreen(yearKey: yasminDue));
          await scan(const HistoryScreen());
        },
      );

      testScreen(
        'AC-41: no Zakat-tab text claims payment, acceptance or fulfilment, in a due, an incomplete, a below-nisab and an open year',
        (tester) async {
          final claims = RegExp(
            r'zakat paid|accepted|fulfilled|your duty is done|برئت الذمة|(^|[^ء-ي])[يتنأ]?تقبّ?ل',
            caseSensitive: false,
          );
          final tone = RegExp(
            r'\b(late|missed|overdue|default)\b',
            caseSensitive: false,
          );
          final cases = <(String, Future<void> Function(Harness), DateTime)>[
            ('due', seedYasmin, yasminToday),
            ('incomplete', (h) => seedYasmin(h, usdRate: false), yasminToday),
            ('below nisab', (h) => seedYasmin(h, debts: '100000'), yasminToday),
            ('open', seedYasmin, day(2026, 10, 10)),
          ];
          for (final (name, seed, now) in cases) {
            await pumpScreen(
              tester,
              const ZakatScreen(),
              now: now,
              locale: locale,
              seed: seed,
            );
            final text = allText(tester);
            expect(claims.hasMatch(text), isFalse, reason: name);
            expect(tone.hasMatch(text), isFalse, reason: name);
            await tester.pumpWidget(const SizedBox.shrink());
            await tester.pump(const Duration(seconds: 1));
          }
        },
      );

      testScreen(
        'AC-20: looking at the tab, the year and the history stores nothing the user did not decide',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const ZakatScreen(),
            now: yasminToday,
            locale: locale,
            seed: (h) async {
              await h.setup(cycle: yasminCycle());
              await seedYasminItems(h);
              await seedYasminRates(h);
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
          Future<void> openAndLeave(Widget screen) async {
            final nav = tester.state<NavigatorState>(find.byType(Navigator));
            nav.push(MaterialPageRoute<void>(builder: (_) => screen));
            await tester.pumpAndSettle();
            nav.pop();
            await tester.pumpAndSettle();
          }

          await openAndLeave(YearScreen(yearKey: yasminDue));
          await openAndLeave(const HistoryScreen());
          if (find.text(l10n.zakatFixChoose).evaluate().isNotEmpty) {
            await tester.tap(find.text(l10n.zakatFixChoose).first);
            await tester.pumpAndSettle();
            await closeSheet(tester);
          }
          final s = (await tester.runAsync(
            () => h.assumptions.watchSettings().first,
          ))!;
          expect(s.zakat.nisab, isNull);
          expect(s.zakat.givingRateView, isNull);
          expect(s.zakat.reminderAsked, isFalse);
          expect(s.jewelleryZakatable, isNull);
          expect(s.longTermMethod, isNull);
          expect(h.reminder.permissionRequests, 0);
          final records = (await tester.runAsync(
            () => h.zakat.watchYears().first,
          ))!;
          expect(records, isEmpty);
          expect(
            await tester.runAsync(
              () => h.assumptions.watchNoZakatYears().first,
            ),
            isEmpty,
          );
          expect(
            (await tester.runAsync(() => h.db.select(h.db.zakatGifts).get()))!,
            isEmpty,
          );
          expect(
            (await tester.runAsync(
              () => h.db.select(h.db.zakatFrozenLines).get(),
            ))!,
            isEmpty,
          );
        },
      );

      testScreen(
        'AC-33: a moved, started year with a USD and a SAR entry shows all eight lines, B, Z, both rates and what is left',
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
                gift(
                  '2026-10-22',
                  '100',
                  unit: usd,
                  note: 'Masjid',
                  rate: d('50'),
                  rateDate: day(2026, 10, 21),
                  view: GivingRateView.dayGiven,
                ),
              );
              await h.zakat.saveGift(
                yasminDue,
                gift(
                  '2026-10-22',
                  '200',
                  unit: sar,
                  note: 'Neighbour',
                  rate: d('13'),
                  rateDate: day(2026, 10, 22),
                  view: GivingRateView.dayGiven,
                ),
              );
            },
          );
          final l10n = l10nOf(tester);
          for (final name in [
            'Savings',
            'Gold bar',
            'US shares',
            'EGX shares',
            'Home',
            'Cash at home',
            'Loan to my brother',
          ]) {
            await scrollTo(tester, find.text(name).first);
            expect(find.text(name), findsWidgets, reason: name);
          }
          expect(find.text(l10n.zakatDebtsTitle), findsOneWidget);
          expect(textPlain('525,000.00'), findsWidgets);
          expect(textPlain('505,000.00'), findsWidgets);
          expect(textPlain('425,000.00'), findsWidgets);
          expect(
            textPlain('${l10n.zakatResultDue} 12,625.00 EGP'),
            findsOneWidget,
          );
          final rows = giftRows.evaluate().length;
          expect(rows, 2);
          final all =
              allTextIn(tester, giftRows.first) +
              allTextIn(tester, giftRows.last);
          expect(all, contains('Masjid'));
          expect(all, contains('Neighbour'));
          expect(all, contains(shownDate(tester, day(2026, 10, 22))));
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
            textPlain(
              l10n.zakatGiftCountedAt(
                '200.00 SAR',
                '13.00',
                shownDate(tester, day(2026, 10, 22)),
                'dayGiven',
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatGiftGivenOf('7,600.00', '12,625.00 EGP')),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatGiftRemaining('5,025.00 EGP')),
            findsOneWidget,
          );
        },
      );
    });
  }
}
