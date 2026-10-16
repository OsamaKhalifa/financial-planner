/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/features/investments/presentation/inflation_series_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

Future<List<InflationOverride>> overrides(
  WidgetTester tester,
  Harness h,
) async {
  late List<InflationOverride> r;
  await tester.runAsync(
    () async => r = await h.assumptions.watchInflationOverrides().first,
  );
  return r;
}

void main() {
  for (final locale in [en, ar]) {
    group('inflation series (${locale.languageCode})', () {
      testScreen(
        'AC-32/33: shipped years are tagged; a year after the last one is "assumed"',
        (tester) async {
          await pumpScreen(
            tester,
            const InflationSeriesScreen(country: egy),
            locale: locale,
            seed: (h) => h.setup(),
            shipped: ShippedInflation(
              source: 'World Bank',
              asOfNote: '2026-10-08',
              series: {
                egy: {2025: Decimal.parse('0.25')},
              },
            ),
          );
          final l10n = l10nOf(tester);
          expect(
            textPlain(
              plain(
                l10n.inflationYearLine('2025', '+25.00 %', l10n.tagShipped),
              ),
            ),
            findsOneWidget,
          );
          expect(
            textPlain(
              plain(
                l10n.inflationYearLine(
                  '2026',
                  '+25.00 %',
                  l10n.tagAssumed('2025'),
                ),
              ),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen(
        'AC-32: typing a year overrides it; resetting brings the shipped value back',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InflationSeriesScreen(country: egy),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.byKey(const ValueKey('year-2025')));
          await tester.pumpAndSettle();
          await tester.enterText(
            find.descendant(
              of: find.byKey(const ValueKey('override-field')),
              matching: find.byType(TextField),
            ),
            '30',
          );
          await tester.tap(find.byKey(const ValueKey('override-save')));
          await settle(tester);
          final o = (await overrides(tester, h)).single;
          expect(
            (o.country, o.year, o.rate),
            (egy, 2025, Decimal.parse('0.3')),
          );
          expect(
            textPlain(
              plain(l10n.inflationYearLine('2025', '+30.00 %', l10n.tagYours)),
            ),
            findsOneWidget,
          );

          await tester.tap(find.text(l10n.resetToShipped));
          await settle(tester);
          expect(await overrides(tester, h), isEmpty);
          expect(
            textPlain(
              plain(
                l10n.inflationYearLine('2025', '+14.00 %', l10n.tagShipped),
              ),
            ),
            findsOneWidget,
          );
        },
      );

      testScreen('an absurd rate is refused', (tester) async {
        final h = await pumpScreen(
          tester,
          const InflationSeriesScreen(country: egy),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.byKey(const ValueKey('year-2025')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.descendant(
            of: find.byKey(const ValueKey('override-field')),
            matching: find.byType(TextField),
          ),
          '5000',
        );
        await tester.tap(find.byKey(const ValueKey('override-save')));
        await tester.pumpAndSettle();
        expect(find.text(l10n.errInflation), findsOneWidget);
        expect(await overrides(tester, h), isEmpty);
      });

      testScreen('a series with no data says so', (tester) async {
        await pumpScreen(
          tester,
          const InflationSeriesScreen(country: Country('NOR')),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        expect(
          find.text(l10n.emptySeries(l10n.countryName('NOR'))),
          findsOneWidget,
        );
      });
    });
  }
}
