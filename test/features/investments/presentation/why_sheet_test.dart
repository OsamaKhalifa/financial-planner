/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/features/investments/presentation/why_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

class _Page extends StatelessWidget {
  const _Page(this.why);

  final Why why;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FigureRow(
      label: 'Return',
      value: '+4.21 %',
      why: why,
      emphasis: true,
    ),
  );
}

void main() {
  for (final locale in [en, ar]) {
    group('S9 why sheet (${locale.languageCode})', () {
      testScreen(
        'shows what it is, the user\'s numbers, the assumptions and the source',
        (tester) async {
          await pumpScreen(
            tester,
            const _Page(
              Why(
                title: 'Return',
                what: 'WHAT',
                numbers: 'NUMBERS',
                assumptions: ['A1', 'A2'],
                source: 'SOURCE',
              ),
            ),
            locale: locale,
          );
          final l10n = l10nOf(tester);
          expect(find.text('+4.21 %'), findsOneWidget);
          await tester.tap(find.text('Return'));
          await tester.pumpAndSettle();
          for (final t in ['WHAT', 'NUMBERS', '• A1', '• A2', 'SOURCE']) {
            expect(find.text(t), findsOneWidget);
          }
          for (final heading in [
            l10n.whyWhat,
            l10n.whyNumbers,
            l10n.whyAssumptions,
            l10n.whySource,
          ]) {
            expect(find.text(heading), findsOneWidget);
          }
        },
      );

      testScreen('blocks without content are left out', (tester) async {
        await pumpScreen(
          tester,
          const _Page(Why(title: 'Return', what: 'WHAT')),
          locale: locale,
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.text('Return'));
        await tester.pumpAndSettle();
        expect(find.text(l10n.whyWhat), findsOneWidget);
        expect(find.text(l10n.whyNumbers), findsNothing);
        expect(find.text(l10n.whyAssumptions), findsNothing);
        expect(find.text(l10n.whySource), findsNothing);
      });

      testScreen('a row without a why is not tappable', (tester) async {
        await pumpScreen(
          tester,
          const Scaffold(
            body: FigureRow(label: 'Gain', value: '+1.00'),
          ),
          locale: locale,
        );
        await tester.tap(find.text('Gain'));
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsNothing);
        expect(find.byIcon(Icons.info_outline), findsNothing);
      });
    });
  }
}
