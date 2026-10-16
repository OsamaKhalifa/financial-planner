/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/widgets/unit_picker_sheet.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

Unit? picked;

class _Opener extends StatelessWidget {
  const _Opener(this.anchor);

  final Unit anchor;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () async =>
            picked = await showUnitPicker(context, anchor: anchor),
        child: const Text('open'),
      ),
    ),
  );
}

Future<void> seedUnits(
  Harness h,
  Map<Unit, int> counts, {
  Unit base = egp,
}) async {
  await h.setup(base: base);
  for (final e in counts.entries) {
    for (var k = 0; k < e.value; k++) {
      final id = '${e.key.code}$k';
      await h.addItem(
        item(
          id,
          type: AssetType.cashDeposit,
          intent: null,
          unit: e.key,
          rule: ZakatRule.cash100,
        ),
        [moneyIn(id, day(2026, 1, 1), '100', e.key)],
      );
    }
  }
}

Future<List<String>> openAndRead(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return [
    for (final t in tester.widgetList<ListTile>(find.byType(ListTile)))
      ((t.title! as Text).data!),
  ];
}

void main() {
  for (final locale in [en, ar]) {
    group('unit picker (${locale.languageCode})', () {
      testScreen('AC-42: most used first, then all others by code', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const _Opener(egp),
          locale: locale,
          seed: (h) => seedUnits(h, {usd: 3, egp: 2, sar: 1, xauG: 1}),
        );
        final codes = await openAndRead(tester);
        expect(codes.take(4).toList(), ['USD', 'EGP', 'SAR', 'XAU-g']);
        expect(codes.skip(4).first, 'AED');
        expect(codes.skip(4), isNot(contains('USD')));
        final l10n = l10nOf(tester);
        expect(find.text(l10n.mostUsed), findsOneWidget);
        expect(find.text(l10n.allUnits), findsOneWidget);
      });

      testScreen(
        'AC-43: six units, none in the base: the base plus the 4 most used lead',
        (tester) async {
          await pumpScreen(
            tester,
            const _Opener(egp),
            locale: locale,
            seed: (h) => seedUnits(h, {
              usd: 3,
              sar: 2,
              const Unit('EUR'): 2,
              const Unit('GBP'): 1,
              const Unit('AED'): 1,
              const Unit('CHF'): 1,
            }),
          );
          final codes = await openAndRead(tester);
          expect(codes.take(5).toSet(), {'EGP', 'USD', 'EUR', 'SAR', 'AED'});
          expect(codes.skip(5), isNot(contains('EGP')));
        },
      );

      testScreen(
        'AC-44: a new user with base SAR sees SAR first, then everything by code',
        (tester) async {
          await pumpScreen(
            tester,
            const _Opener(sar),
            locale: locale,
            seed: (h) => h.setup(base: sar),
          );
          final codes = await openAndRead(tester);
          expect(codes.first, 'SAR');
          expect(codes[1], 'AED');
          final l10n = l10nOf(tester);
          expect(find.text(l10n.mostUsed), findsOneWidget);
        },
      );

      testScreen(
        'search finds a unit by code or by its name in the app language',
        (tester) async {
          await pumpScreen(
            tester,
            const _Opener(egp),
            locale: locale,
            seed: (h) => h.setup(),
          );
          await tester.tap(find.text('open'));
          await tester.pumpAndSettle();
          final l10n = l10nOf(tester);
          await tester.enterText(find.byType(TextField), 'kwd');
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('unit-KWD')), findsOneWidget);
          expect(find.byKey(const ValueKey('unit-USD')), findsNothing);
          await tester.enterText(find.byType(TextField), l10n.unitName('SAR'));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('unit-SAR')), findsOneWidget);
        },
      );

      testScreen('tapping a unit returns it', (tester) async {
        picked = null;
        await pumpScreen(
          tester,
          const _Opener(egp),
          locale: locale,
          seed: (h) => h.setup(),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('unit-EGP')));
        await tester.pumpAndSettle();
        expect(picked, egp);
      });
    });
  }
}
