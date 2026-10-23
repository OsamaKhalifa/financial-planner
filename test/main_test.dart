/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/main.dart';
import 'package:flutter/material.dart';
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

      testScreen('once set up, Home is shown', (tester) async {
        await pumpScreen(
          tester,
          const RootGate(),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.emptyTitle), findsOneWidget);
        expect(find.text(l10n.setupBaseTitle), findsNothing);
        expect(
          Directionality.of(tester.element(find.byType(Scaffold).first)),
          rtl ? TextDirection.rtl : TextDirection.ltr,
        );
      });

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
        for (final title in [l10n.tabOverview, l10n.tabZakat, l10n.tabPlan]) {
          await tester.tap(
            find.descendant(
              of: find.byType(NavigationBar),
              matching: find.text(title),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text(l10n.comingSoon), findsOneWidget);
          expect(find.text(l10n.emptyTitle), findsNothing);
        }
        await tester.tap(find.text(l10n.tabInvestments));
        await tester.pumpAndSettle();
        expect(find.text(l10n.emptyTitle), findsOneWidget);
        expect(find.text(l10n.comingSoon), findsNothing);
      });
    });
  }
}
