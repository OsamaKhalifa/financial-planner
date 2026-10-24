/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/features/investments/presentation/home_screen.dart';
import 'package:financial_planner/features/overview/presentation/overview_screen.dart';
import 'package:financial_planner/features/settings/settings_screen.dart';
import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  for (final locale in [en, ar]) {
    final rtl = locale == ar;
    group('root gate (${locale.languageCode})', () {
      testScreen('first run shows the setup, in the right direction', (
        tester,
      ) async {
        await pumpScreen(tester, const RootGate(), locale: locale);
        final l10n = l10nOf(tester);
        expect(find.text(l10n.setupBaseTitle), findsOneWidget);
        expect(
          Directionality.of(tester.element(find.byType(Scaffold).first)),
          rtl ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(
          find.text(rtl ? 'المخطط المالي' : 'Financial Planner'),
          findsWidgets,
        );
      });

      testScreen('once set up, Overview is shown', (tester) async {
        await pumpScreen(
          tester,
          const RootGate(),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(find.byType(OverviewScreen), findsOneWidget);
        expect(find.text(l10n.emptyTitle), findsOneWidget);
        expect(find.text(l10n.setupBaseTitle), findsNothing);
        expect(
          Directionality.of(tester.element(find.byType(Scaffold).first)),
          rtl ? TextDirection.rtl : TextDirection.ltr,
        );
      });

      testScreen(
        'every tab has the Settings gear; it opens Settings and back',
        (tester) async {
          await pumpScreen(
            tester,
            const RootGate(),
            locale: locale,
            seed: (h) => h.setup(),
          );
          FlutterSecureStorage.setMockInitialValues({});
          final l10n = l10nOf(tester);
          for (final title in [
            l10n.tabOverview,
            l10n.tabInvestments,
            l10n.tabZakat,
            l10n.tabPlan,
          ]) {
            await tester.tap(
              find.descendant(
                of: find.byType(NavigationBar),
                matching: find.text(title),
              ),
            );
            await tester.pumpAndSettle();
            expect(find.byTooltip(l10n.settings), findsOneWidget);
            await tester.tap(find.byTooltip(l10n.settings));
            await tester.pumpAndSettle();
            expect(find.byType(SettingsScreen), findsOneWidget);
            await tester.tap(find.byType(BackButton));
            await tester.pumpAndSettle();
            expect(find.byType(SettingsScreen), findsNothing);
            expect(find.byType(NavigationBar), findsOneWidget);
          }
        },
      );

      testScreen('tabs switch pages and keep Investments state', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const RootGate(),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(find.byType(NavigationDestination), findsNWidgets(4));
        Future<void> tab(String title) async {
          await tester.tap(
            find.descendant(
              of: find.byType(NavigationBar),
              matching: find.text(title),
            ),
          );
          await tester.pumpAndSettle();
        }

        for (final title in [l10n.tabZakat, l10n.tabPlan]) {
          await tab(title);
          expect(find.text(l10n.comingSoon), findsOneWidget);
          expect(find.text(l10n.emptyTitle), findsNothing);
        }
        await tab(l10n.tabInvestments);
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.text(l10n.dataStaysOnPhone), findsOneWidget);
        await tab(l10n.tabOverview);
        expect(find.byType(OverviewScreen), findsOneWidget);
        expect(find.text(l10n.dataStaysOnPhone), findsNothing);
      });
    });
  }
}
