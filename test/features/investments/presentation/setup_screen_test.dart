/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/features/investments/presentation/setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

Future<Settings> stored(WidgetTester tester, Harness h) async {
  late Settings s;
  await tester.runAsync(
    () async => s = await h.assumptions.watchSettings().first,
  );
  return s;
}

Future<void> pickEgp(WidgetTester tester) async {
  final tile = find.byKey(const ValueKey('unit-EGP'));
  await tester.ensureVisible(tile);
  await tester.tap(tile);
  await tester.pumpAndSettle();
  await tester.fling(find.byType(ListView).first, const Offset(0, 5000), 5000);
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in [en, ar]) {
    final rtl = locale == ar;
    group('S1 setup (${locale.languageCode})', () {
      testScreen(
        'U1: step 1 asks for the base currency with the region currency already chosen, and has a search',
        (tester) async {
          await pumpScreen(tester, const SetupScreen(), locale: locale);
          final l10n = l10nOf(tester);
          expect(find.text(l10n.setupBaseTitle), findsOneWidget);
          expect(find.text(l10n.setupBaseHelp), findsOneWidget);
          expect(
            Directionality.of(tester.element(find.byType(Scaffold))),
            rtl ? TextDirection.rtl : TextDirection.ltr,
          );
          final next = find.widgetWithText(FilledButton, l10n.next);
          // The test device is in the US: USD is chosen before any tap.
          expect(tester.widget<FilledButton>(next).onPressed, isNotNull);
          expect(
            textPlain(l10n.homeInflationLine(l10n.countryName('USA'), 'USD')),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(TextField, l10n.searchUnits),
            findsOneWidget,
          );

          await tester.enterText(
            find.widgetWithText(TextField, l10n.searchUnits),
            'egp',
          );
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('unit-USD')), findsNothing);
          await tester.tap(find.byKey(const ValueKey('unit-EGP')));
          await tester.pumpAndSettle();
          await tester.fling(
            find.byType(ListView).first,
            const Offset(0, 5000),
            5000,
          );
          await tester.pumpAndSettle();
          expect(
            textPlain(l10n.homeInflationLine(l10n.countryName('EGY'), 'EGP')),
            findsOneWidget,
          );
        },
      );

      testScreen('the home inflation can be changed', (tester) async {
        final h = await pumpScreen(tester, const SetupScreen(), locale: locale);
        final l10n = l10nOf(tester);
        await pickEgp(tester);
        await tester.tap(find.text(l10n.change));
        await tester.pumpAndSettle();
        await tapScrolled(
          tester,
          find.byKey(const ValueKey('country-SAU')),
          find.descendant(
            of: find.byType(BottomSheet),
            matching: find.byType(Scrollable),
          ),
        );
        expect(
          find.text(l10n.homeInflationLine(l10n.countryName('SAU'), 'EGP')),
          findsOneWidget,
        );
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.done));
        await tester.pumpAndSettle();
        expect((await stored(tester, h)).homeInflation?.iso3, 'SAU');
      });

      testScreen(
        'AC-8: the zakat year is shown pre-selected; nothing is chosen for the long-term method',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const SetupScreen(),
            locale: locale,
          );
          final l10n = l10nOf(tester);
          await pickEgp(tester);
          await tester.tap(find.text(l10n.next));
          await tester.pumpAndSettle();
          expect(find.text(l10n.setupZakatTitle), findsOneWidget);
          expect(find.text(l10n.zakatYearLunar), findsOneWidget);
          expect(find.text(l10n.zakatYearSolar), findsOneWidget);
          expect(radioChecked(tester, l10n.zakatYearLunar), isTrue);
          expect(radioChecked(tester, l10n.zakatYearSolar), isFalse);
          for (final label in [
            l10n.longTermDividendsOnly,
            l10n.longTermProxy25,
            l10n.longTermFullValue,
            l10n.longTermPerItem,
            l10n.longTermNotNow,
          ]) {
            expect(radioChecked(tester, label), isFalse, reason: label);
          }
          await tester.tap(find.text(l10n.done));
          await tester.pumpAndSettle();
          final s = await stored(tester, h);
          expect(s.baseCurrency?.code, 'EGP');
          expect(s.zakatYear, ZakatYear.lunar);
          expect(s.longTermMethod, isNull);
          expect(s.homeInflation, isNull);
          expect(s.setupDone, isTrue);
        },
      );

      testScreen(
        'the chosen year and method are stored; the source of each is one tap away',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const SetupScreen(),
            locale: locale,
          );
          final l10n = l10nOf(tester);
          await pickEgp(tester);
          await tester.tap(find.text(l10n.next));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.zakatYearSolar));
          await tester.tap(find.text(l10n.longTermProxy25));
          await tester.pumpAndSettle();

          await tester.tap(find.text(l10n.source).first);
          await tester.pumpAndSettle();
          expect(find.text(l10n.src_A1A2), findsOneWidget);
          await tester.tapAt(const Offset(10, 10));
          await tester.pumpAndSettle();

          await tester.tap(find.text(l10n.done));
          await tester.pumpAndSettle();
          final s = await stored(tester, h);
          expect(s.zakatYear, ZakatYear.solar);
          expect(s.longTermMethod, LongTermMethod.proxy25);
        },
      );

      testScreen('back on step 2 returns to step 1', (tester) async {
        await pumpScreen(tester, const SetupScreen(), locale: locale);
        final l10n = l10nOf(tester);
        await pickEgp(tester);
        await tester.tap(find.text(l10n.next));
        await tester.pumpAndSettle();
        final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
        await widgetsAppState.didPopRoute();
        await tester.pumpAndSettle();
        expect(find.text(l10n.setupBaseTitle), findsOneWidget);
      });
    });
  }
}
