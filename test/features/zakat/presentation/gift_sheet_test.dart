/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/presentation/why_builders.dart';
import 'package:financial_planner/features/zakat/domain/yearly_zakat.dart';
import 'package:financial_planner/features/zakat/presentation/year_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';
import '../../../support/zakat_seeds.dart';
import '../../../support/zakat_ui.dart';

Future<Harness> pumpStarted(
  WidgetTester tester,
  Locale locale, {
  ZakatPrefs prefs = gold,
  Future<void> Function(Harness h)? more,
  DateTime? key,
}) => pumpScreen(
  tester,
  YearScreen(yearKey: key ?? yasminDue),
  now: yasminToday,
  locale: locale,
  seed: (h) async {
    await seedYasmin(h, prefs: prefs);
    await startYears(h, [yasminDue]);
    await more?.call(h);
  },
);

Future<void> addGift(
  WidgetTester tester, {
  required String amount,
  int? onDay,
  String? note,
}) async {
  await tapKey(tester, 'add-gift');
  if (onDay != null) await pickDate(tester, 'gift-date', onDay);
  await enter(tester, inKey('gift-amount'), amount);
  if (note != null) {
    await enter(tester, find.byKey(const ValueKey('gift-note')), note);
  }
  await tapKey(tester, 'gift-save');
}

void main() {
  for (final locale in [en, ar]) {
    group('Z7 amount given (${locale.languageCode})', () {
      testScreen(
        'AC-26: entries add up to the zakat due and the year settles',
        (tester) async {
          await pumpStarted(tester, locale);
          final l10n = l10nOf(tester);
          await addGift(tester, amount: '5000', onDay: 21, note: 'Masjid');
          expect(find.byType(BottomSheet), findsNothing);
          expect(
            textPlain(l10n.zakatGiftRemaining('7,500.00 EGP')),
            findsOneWidget,
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('distributing'),
          );
          expect(find.text('Masjid'), findsOneWidget);
          await addGift(tester, amount: '7500');
          expect(
            find.text(
              l10n.zakatReachedSnack(l10n.zakatYearLabel('lunar', '1448')),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatGiftRemaining('0.00 EGP')),
            findsOneWidget,
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('settled'),
          );
          expect(
            textOf(tester, find.byKey(const ValueKey('c11-line'))),
            l10n.zakatGiftLogNote,
          );
        },
      );

      testScreen(
        'AC-26: an entry of 0 is refused, and deleting an entry can be undone',
        (tester) async {
          await pumpStarted(tester, locale);
          final l10n = l10nOf(tester);
          await tapKey(tester, 'add-gift');
          await enter(tester, inKey('gift-amount'), '0');
          await tapKey(tester, 'gift-save');
          expect(find.text(l10n.errZero), findsOneWidget);
          expect(find.byType(BottomSheet), findsOneWidget);
          await enter(tester, inKey('gift-amount'), '12500');
          await tapKey(tester, 'gift-save');
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('settled'),
          );
          await tester.tap(giftRows.first);
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.delete));
          await tester.pumpAndSettle();
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('distributing'),
          );
          expect(
            textPlain(l10n.zakatGiftRemaining('12,500.00 EGP')),
            findsOneWidget,
          );
          await tester.tap(find.text(l10n.undo));
          await settle(tester);
          expect(
            textOf(tester, find.byKey(const ValueKey('state-chip'))),
            l10n.zakatState('settled'),
          );
        },
      );

      testScreen(
        'AC-43: once an entry exists the start can no longer be undone',
        (tester) async {
          await pumpScreen(
            tester,
            YearScreen(yearKey: yasminDue),
            now: yasminToday,
            locale: locale,
            seed: seedYasmin,
          );
          final l10n = l10nOf(tester);
          await tapKey(tester, 'start-year');
          expect(find.text(l10n.undo), findsOneWidget);
          await addGift(tester, amount: '100');
          expect(find.text(l10n.undo), findsNothing);
        },
      );

      testScreen(
        'AC-26 AC-28: the date window starts the day after the previous due date and ends today',
        (tester) async {
          await pumpStarted(tester, locale);
          await tapKey(tester, 'add-gift');
          await tapKey(tester, 'gift-date');
          final hijri = hijriOf(yasminDue);
          final previous = dueDate(
            ZakatYear.lunar,
            hijri.m,
            hijri.d,
            hijri.y - 1,
          )!;
          final (first, last) = pickerBounds(tester);
          expect(first, previous.add(const Duration(days: 1)));
          expect(last, yasminToday);
        },
      );

      testScreen(
        'AC-28: a moved previous due date moves the first day with it',
        (tester) async {
          await pumpScreen(
            tester,
            YearScreen(yearKey: day(2026, 10, 20)),
            now: yasminToday,
            locale: locale,
            seed: (h) async {
              await h.setup(
                zakatPrefs: gold,
                cycle: solarCycle(10, 20, day(2025, 1, 1)),
              );
              await seedYasminItems(h);
              await seedYasminRates(h);
              await h.zakat.saveYear(
                day(2025, 10, 20),
                movedDue: day(2025, 10, 18),
                debts: d('0'),
                deductDebts: true,
              );
              await h.zakat.saveYear(
                yasminDue,
                debts: d('20000'),
                deductDebts: true,
              );
              await startYears(h, [yasminDue]);
            },
          );
          await tapKey(tester, 'add-gift');
          await tapKey(tester, 'gift-date');
          expect(pickerBounds(tester).$1, day(2025, 10, 19));
        },
      );

      testScreen(
        'AC-46: in the first year the window starts the day after the cycle date a year earlier',
        (tester) async {
          await pumpScreen(
            tester,
            YearScreen(yearKey: yasminDue),
            now: yasminToday,
            locale: locale,
            seed: (h) async {
              await h.setup(
                zakatPrefs: gold,
                cycle: solarCycle(10, 20, day(2026, 1, 5)),
              );
              await seedYasminItems(h);
              await seedYasminRates(h);
              await seedYasminRecord(h);
              await startYears(h, [yasminDue]);
            },
          );
          await tapKey(tester, 'add-gift');
          await tapKey(tester, 'gift-date');
          expect(pickerBounds(tester).$1, day(2025, 10, 21));
        },
      );

      testScreen(
        'AC-28: a gift before the due date is accepted, marked, and carries the early line',
        (tester) async {
          await pumpStarted(tester, locale);
          final l10n = l10nOf(tester);
          await tapKey(tester, 'add-gift');
          await pickDate(tester, 'gift-date', 19);
          expect(find.byKey(const ValueKey('early-help')), findsOneWidget);
          expect(
            textOf(tester, find.byKey(const ValueKey('early-help'))),
            l10n.zakatGiftEarlyHelp,
          );
          await enter(tester, inKey('gift-amount'), '2000');
          await tapKey(tester, 'gift-save');
          expect(find.text(l10n.zakatGiftEarly), findsOneWidget);
          await tester.tap(find.text(l10n.zakatGiftEarly));
          await tester.pumpAndSettle();
          expect(find.text(zakatSource(l10n, 'C6')), findsOneWidget);
          expect(find.text(l10n.zakatGiftEarlyHelp), findsWidgets);
        },
      );

      testScreen('C11: the log help carries the line', (tester) async {
        await pumpStarted(tester, locale);
        final l10n = l10nOf(tester);
        await tapKey(tester, 'add-gift');
        await tester.tap(find.text(l10n.zakatGiftAbout));
        await tester.pumpAndSettle();
        expect(find.text(l10n.zakatGiftLogNote), findsOneWidget);
      });

      testScreen(
        'AC-30: the first other-currency entry asks the rate view, saves nothing until answered, and asks once',
        (tester) async {
          final h = await pumpStarted(tester, locale);
          final l10n = l10nOf(tester);
          await tapKey(tester, 'add-gift');
          await enter(tester, inKey('gift-amount'), '5000');
          expect(find.byKey(const ValueKey('view-dayGiven')), findsNothing);
          await pickDate(tester, 'gift-date', 22);
          await enter(tester, inKey('gift-amount'), '100');
          await pickUnit(tester, 'gift-unit', 'USD');
          expect(find.byKey(const ValueKey('view-dayGiven')), findsOneWidget);
          expect(radioChecked(tester, l10n.zakatGiftViewDay), isFalse);
          expect(radioChecked(tester, l10n.zakatGiftViewDue), isFalse);
          expect(find.text(l10n.zakatGiftViewHelp), findsOneWidget);
          expect(
            tester
                .widget<FilledButton>(find.byKey(const ValueKey('gift-save')))
                .onPressed,
            isNull,
          );
          await tester.tap(find.byKey(const ValueKey('view-dayGiven')));
          await tester.pumpAndSettle();
          expect(
            textPlain(
              l10n.zakatGiftLive(
                '5,000.00 EGP',
                '50.00',
                shownDate(tester, day(2026, 10, 21)),
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(
              l10n.zakatLineNotRateOf(shownDate(tester, day(2026, 10, 22))),
            ),
            findsOneWidget,
          );
          await tapKey(tester, 'gift-save');
          final l = l10n;
          expect(
            textPlain(
              l.zakatGiftCountedAt(
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
              l.zakatLineNotRateOf(shownDate(tester, day(2026, 10, 22))),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(l.zakatGiftRemaining('7,500.00 EGP')),
            findsOneWidget,
          );
          final stored = await tester.runAsync(
            () => h.assumptions.watchSettings().first,
          );
          expect(stored!.zakat.givingRateView, GivingRateView.dayGiven);
          await tapKey(tester, 'add-gift');
          await pickUnit(tester, 'gift-unit', 'USD');
          expect(find.byKey(const ValueKey('view-dayGiven')), findsNothing);
        },
      );

      testScreen(
        'AC-30: with the due-date view the rate of the due date counts and there is no "not the rate of" text',
        (tester) async {
          await pumpStarted(
            tester,
            locale,
            prefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              givingRateView: GivingRateView.dueDate,
            ),
          );
          final l10n = l10nOf(tester);
          await tapKey(tester, 'add-gift');
          await pickDate(tester, 'gift-date', 22);
          await enter(tester, inKey('gift-amount'), '100');
          await pickUnit(tester, 'gift-unit', 'USD');
          expect(find.byKey(const ValueKey('view-dueDate')), findsNothing);
          expect(
            textPlain(
              l10n.zakatLineNotRateOf(shownDate(tester, day(2026, 10, 22))),
            ),
            findsNothing,
          );
          await tapKey(tester, 'gift-save');
          expect(
            textPlain(
              l10n.zakatGiftCountedAt(
                '100.00 USD',
                '48.00',
                shownDate(tester, yasminDue),
                'dueDate',
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(l10n.zakatGiftRemaining('7,700.00 EGP')),
            findsOneWidget,
          );
          expect(textPlain(l10n.zakatLineNotRateOf('')), findsNothing);
        },
      );

      testScreen(
        'AC-30: a changed view keeps old entries and recounts an entry when it is edited',
        (tester) async {
          final h = await pumpStarted(
            tester,
            locale,
            prefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              givingRateView: GivingRateView.dayGiven,
            ),
            more: (h) => h.zakat.saveGift(
              yasminDue,
              gift(
                '2026-10-22',
                '100',
                unit: usd,
                rate: d('50'),
                rateDate: day(2026, 10, 21),
                view: GivingRateView.dayGiven,
              ),
            ),
          );
          final l10n = l10nOf(tester);
          expect(
            textPlain(l10n.zakatGiftRemaining('7,500.00 EGP')),
            findsOneWidget,
          );
          await write(
            tester,
            () => h.assumptions.saveSettings(
              const Settings(
                baseCurrency: egp,
                zakatYear: ZakatYear.lunar,
                zakat: ZakatPrefs(
                  nisab: NisabMetal.gold,
                  givingRateView: GivingRateView.dueDate,
                ),
              ),
            ),
          );
          expect(
            textPlain(l10n.zakatGiftRemaining('7,500.00 EGP')),
            findsOneWidget,
          );
          await tester.tap(giftRows.first);
          await tester.pumpAndSettle();
          await enter(tester, inKey('gift-amount'), '200');
          expect(
            textPlain(
              l10n.zakatGiftLive(
                '9,600.00 EGP',
                '48.00',
                shownDate(tester, yasminDue),
              ),
            ),
            findsOneWidget,
          );
          await tapKey(tester, 'gift-save');
          expect(
            textPlain(l10n.zakatGiftRemaining('2,900.00 EGP')),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'PM-Q5: editing only the note keeps the rate, its date, the view and the counted amount',
        (tester) async {
          final h = await pumpStarted(
            tester,
            locale,
            prefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              givingRateView: GivingRateView.dueDate,
            ),
            more: (h) => h.zakat.saveGift(
              yasminDue,
              gift(
                '2026-10-22',
                '100',
                unit: usd,
                rate: d('50'),
                rateDate: day(2026, 10, 21),
                view: GivingRateView.dayGiven,
              ),
            ),
          );
          final l10n = l10nOf(tester);
          await tester.tap(giftRows.first);
          await tester.pumpAndSettle();
          expect(
            textPlain(
              l10n.zakatGiftLive(
                '5,000.00 EGP',
                '50.00',
                shownDate(tester, day(2026, 10, 21)),
              ),
            ),
            findsOneWidget,
          );
          await enter(
            tester,
            find.byKey(const ValueKey('gift-note')),
            'Masjid',
          );
          await tapKey(tester, 'gift-save');
          expect(
            textPlain(l10n.zakatGiftRemaining('7,500.00 EGP')),
            findsOneWidget,
          );
          final years = await tester.runAsync(() => h.zakat.watchYears().first);
          final saved = years!.single.gifts.single;
          expect(
            (
              saved.amount.amount,
              saved.rate,
              saved.rateDate,
              saved.view,
              saved.note,
            ),
            (
              d('100'),
              d('50'),
              day(2026, 10, 21),
              GivingRateView.dayGiven,
              'Masjid',
            ),
          );
        },
      );

      testScreen(
        'AC-42: with no SAR rate the entry waits for a typed one, which is stored dated for the day given',
        (tester) async {
          final h = await pumpStarted(
            tester,
            locale,
            prefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              givingRateView: GivingRateView.dayGiven,
            ),
          );
          final l10n = l10nOf(tester);
          await tapKey(tester, 'add-gift');
          await pickDate(tester, 'gift-date', 22);
          await enter(tester, inKey('gift-amount'), '200');
          await pickUnit(tester, 'gift-unit', 'SAR');
          expect(
            textPlain(
              l10n.zakatGiftTypeRate(
                'SAR',
                'EGP',
                shownDate(tester, day(2026, 10, 22)),
              ),
            ),
            findsOneWidget,
          );
          expect(
            tester
                .widget<FilledButton>(find.byKey(const ValueKey('gift-save')))
                .onPressed,
            isNull,
          );
          await tester.tap(find.text(l10n.zakatFixAddRate));
          await tester.pumpAndSettle();
          await enter(
            tester,
            find.byKey(const ValueKey('rate-value')),
            '13.00',
          );
          await tapKey(tester, 'rate-save');
          await settle(tester);
          expect(
            textPlain(
              l10n.zakatGiftLive(
                '2,600.00 EGP',
                '13.00',
                shownDate(tester, day(2026, 10, 22)),
              ),
            ),
            findsOneWidget,
          );
          await tapKey(tester, 'gift-save');
          expect(
            textPlain(l10n.zakatGiftRemaining('9,900.00 EGP')),
            findsOneWidget,
          );
          final rates = await tester.runAsync(
            () => h.assumptions.watchRates().first,
          );
          final typed = rates!
              .where((r) => r.from == sar && r.to == egp)
              .single;
          expect(
            (typed.rate, typed.asOf, typed.source),
            (d('13.00'), day(2026, 10, 22), RateSource.typed),
          );
        },
      );

      testScreen(
        'AC-42: with the due-date view the rate asked for is dated on the due date',
        (tester) async {
          await pumpStarted(
            tester,
            locale,
            prefs: const ZakatPrefs(
              nisab: NisabMetal.gold,
              givingRateView: GivingRateView.dueDate,
            ),
          );
          final l10n = l10nOf(tester);
          await tapKey(tester, 'add-gift');
          await pickDate(tester, 'gift-date', 22);
          await enter(tester, inKey('gift-amount'), '200');
          await pickUnit(tester, 'gift-unit', 'SAR');
          expect(
            textPlain(
              l10n.zakatGiftTypeRate(
                'SAR',
                'EGP',
                shownDate(tester, yasminDue),
              ),
            ),
            findsOneWidget,
          );
        },
      );
    });
  }
}
