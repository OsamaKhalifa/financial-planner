/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/zakat/presentation/history_screen.dart';
import 'package:financial_planner/features/zakat/presentation/year_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<void> seedSolarYears(Harness h, {String debts = '0'}) async {
  await h.setup(zakatPrefs: gold, cycle: solarCycle(10, 20, day(2025, 1, 1)));
  await h.rate(xauG, egp, '5000', day(2025, 1, 1));
  await h.addItem(
    item(
      'Savings',
      type: AssetType.cashDeposit,
      intent: null,
      rule: ZakatRule.cash100,
      start: day(2025, 1, 1),
    ),
    [
      moneyIn('Savings', day(2025, 1, 1), '450000'),
      value('Savings', day(2025, 1, 1), '450000'),
      value('Savings', day(2026, 3, 1), '500000'),
    ],
  );
  if (debts != '0') {
    await h.zakat.saveYear(
      day(2025, 10, 20),
      debts: d(debts),
      deductDebts: true,
    );
  }
}

double top(WidgetTester tester, Finder f) => tester.getTopLeft(f.first).dy;

void main() {
  for (final locale in [en, ar]) {
    group('Z8 history (${locale.languageCode})', () {
      testScreen('AC-32: newest due date first, with figures and state', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const HistoryScreen(),
          now: yasminToday,
          locale: locale,
          seed: (h) async {
            await seedSolarYears(h);
            await startYears(h, [day(2025, 10, 20), day(2026, 10, 20)]);
            await h.zakat.saveGift(
              day(2025, 10, 20),
              gift('2025-10-25', '11596.50'),
            );
            await h.zakat.saveGift(
              day(2026, 10, 20),
              gift('2026-10-21', '5000'),
            );
          },
        );
        final l10n = l10nOf(tester);
        final rows = [
          for (final y in [2027, 2026, 2025])
            find.byKey(ValueKey('history-$y-10-20')),
        ];
        expect(top(tester, rows[0]), lessThan(top(tester, rows[1])));
        expect(top(tester, rows[1]), lessThan(top(tester, rows[2])));
        String inRow(int i) => allTextIn(tester, rows[i]);
        expect(inRow(0), contains('2027'));
        expect(inRow(0), contains('12,885.00 EGP · ${l10n.zakatEstimateTag}'));
        expect(inRow(0), contains(l10n.zakatHistoryGiven('0.00 EGP')));
        expect(inRow(0), contains(l10n.zakatState('open')));
        expect(inRow(0), contains(shownDate(tester, day(2027, 10, 20))));
        expect(inRow(1), contains('2026'));
        expect(inRow(1), contains('12,885.00 EGP'));
        expect(inRow(1), contains(l10n.zakatHistoryGiven('5,000.00 EGP')));
        expect(inRow(1), contains(l10n.zakatState('distributing')));
        expect(inRow(2), contains('11,596.50 EGP'));
        expect(inRow(2), contains(l10n.zakatHistoryGiven('11,596.50 EGP')));
        expect(inRow(2), contains(l10n.zakatState('settled')));
      });

      testScreen(
        'AC-32: a closed year with nothing due reads below nisab, not settled',
        (tester) async {
          await pumpScreen(
            tester,
            const HistoryScreen(),
            now: yasminToday,
            locale: locale,
            seed: (h) async {
              await seedSolarYears(h, debts: '450000');
              await startYears(h, [day(2025, 10, 20)]);
            },
          );
          final l10n = l10nOf(tester);
          final row = allTextIn(
            tester,
            find.byKey(const ValueKey('history-2025-10-20')),
          );
          expect(row, contains(l10n.zakatState('belowNisab')));
          expect(row, isNot(contains(l10n.zakatState('settled'))));
        },
      );

      testScreen(
        'AC-32: lunar and solar years sit together by due date, and a row opens its year',
        (tester) async {
          await pumpScreen(
            tester,
            const HistoryScreen(),
            now: yasminToday,
            locale: locale,
            seed: (h) async {
              await h.setup(
                zakatPrefs: gold,
                cycle: ZakatCycle(
                  calendar: ZakatYear.lunar,
                  month: 9,
                  day: 1,
                  from: day(2026, 1, 5),
                ),
              );
              final s = (await h.assumptions.watchSettings().first);
              await h.assumptions.saveZakatCycle(
                s,
                solarCycle(10, 20, day(2027, 2, 9)),
              );
            },
          );
          final l10n = l10nOf(tester);
          final keys = ['2027-10-20', '2027-02-08', '2026-02-18'];
          final tops = [
            for (final k in keys)
              top(tester, find.byKey(ValueKey('history-$k'))),
          ];
          expect(tops[0], lessThan(tops[1]));
          expect(tops[1], lessThan(tops[2]));
          expect(
            allTextIn(tester, find.byKey(const ValueKey('history-2027-02-08'))),
            contains(l10n.zakatYearLabel('lunar', '1448')),
          );
          await tester.tap(find.byKey(const ValueKey('history-2026-02-18')));
          await tester.pumpAndSettle();
          expect(find.byType(YearScreen), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AppBar),
              matching: find.text(l10n.zakatYearLabel('lunar', '1447')),
            ),
            findsOneWidget,
          );
        },
      );
    });
  }
}
