/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/why_builders.dart';
import 'package:financial_planner/features/investments/presentation/why_sheet.dart';
import 'package:financial_planner/l10n/app_localizations_ar.dart';
import 'package:financial_planner/l10n/app_localizations_en.dart';
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

  group('AC-22 zakatSource for a yearly-zakat section is that section alone', () {
    for (final l10n in [AppLocalizationsEn(), AppLocalizationsAr()]) {
      test(
        '${l10n.localeName}: A3..A8, B9, C1..C11 and Z4 each have their own text',
        () {
          final texts = {
            'A3': l10n.src_A3,
            'A4': l10n.src_A4,
            'A5': l10n.src_A5,
            'A7': l10n.src_A7,
            'A8': l10n.src_A8,
            'B9': l10n.src_B9,
            'C1': l10n.src_C1,
            'C2': l10n.src_C2,
            'C3': l10n.src_C3,
            'C4': l10n.src_C4,
            'C5': l10n.src_C5,
            'C6': l10n.src_C6,
            'C7': l10n.src_C7,
            'C8': l10n.src_C8,
            'C9': l10n.src_C9,
            'C10': l10n.src_C10,
            'C11': l10n.src_C11,
            'Z4': l10n.src_Z4,
          };
          for (final e in texts.entries) {
            expect(zakatSource(l10n, e.key), e.value, reason: e.key);
            expect(e.value, isNotEmpty);
          }
          expect(texts.values.toSet().length, texts.length);
        },
      );
    }

    test(
      'an item section still starts with the rate rule, and B7 is now known',
      () {
        final l10n = AppLocalizationsEn();
        expect(zakatSource(l10n, 'B1'), '${l10n.src_A1A2}\n\n${l10n.src_B1}');
        expect(zakatSource(l10n, 'B7'), '${l10n.src_A1A2}\n\n${l10n.src_B7}');
        expect(
          zakatSource(l10n, 'B5', type: AssetType.other),
          contains(l10n.src_B7),
        );
      },
    );

    test('C6 marks the Maliki clause and C1/C3 mark their readings as not yet verified', () {
      final l10n = AppLocalizationsEn();
      expect(l10n.src_C6, contains('Maliki'));
      expect(l10n.src_C6, contains('not yet verified'));
      expect(l10n.src_C3, contains('not yet verified'));
    });
  });
}
