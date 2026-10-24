/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/presentation/rate_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

Future<List<Rate>> rates(WidgetTester tester, Harness h) async {
  late List<Rate> r;
  await tester.runAsync(() async => r = await h.assumptions.watchRates().first);
  return r;
}

Finder rateInput() => find.descendant(
  of: find.byKey(const ValueKey('rate-value')),
  matching: find.byType(TextField),
);

void main() {
  for (final locale in [en, ar]) {
    group('rate history (${locale.languageCode})', () {
      testScreen(
        'lists both directions of the pair, newest first, with their origin',
        (tester) async {
          await pumpScreen(
            tester,
            const RateHistoryScreen(from: usd, to: egp),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.rate(usd, egp, '48', day(2026, 9, 1));
              await h.rate(egp, usd, '0.02', day(2026, 10, 1));
              await h.rate(sar, egp, '13', day(2026, 10, 1));
              await h.assumptions.saveFetchedRates([
                Rate(
                  from: usd,
                  to: egp,
                  rate: Decimal.parse('49'),
                  asOf: day(2026, 8, 1),
                  source: RateSource.currencyApi,
                ),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          final tiles = tester
              .widgetList<ListTile>(find.byType(ListTile))
              .toList();
          expect(tiles.length, 3);
          expect(plain((tiles.first.title! as Text).data!), contains('0.0200'));
          expect(find.text(l10n.rateTagTyped), findsNWidgets(2));
          expect(
            find.text(l10n.rateTagFetched(l10n.refreshSource)),
            findsOneWidget,
          );
          expect(find.text(l10n.rateFetchedNote), findsOneWidget);
        },
      );

      testScreen(
        'add a rate: the inverse is shown live, swap flips the direction',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const RateHistoryScreen(from: usd, to: egp),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await tester.tap(find.byKey(const ValueKey('add-rate')));
          await tester.pumpAndSettle();
          await tester.enterText(rateInput(), '50');
          await tester.pumpAndSettle();
          expect(
            textPlain(l10n.inverseLine('USD', '0.0200', 'EGP')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const ValueKey('swap')));
          await tester.pumpAndSettle();
          expect(
            textPlain(l10n.inverseLine('EGP', '0.0200', 'USD')),
            findsOneWidget,
          );
          await tester.tap(find.byKey(const ValueKey('rate-save')));
          await tester.pumpAndSettle();
          final stored = await rates(tester, h);
          expect(
            (stored.single.from, stored.single.to, stored.single.rate),
            (egp, usd, Decimal.fromInt(50)),
          );
          expect(stored.single.asOf, day(2026, 10, 16));
          expect(
            find.byKey(ValueKey('rate-row-${stored.single.id}')),
            findsOneWidget,
          );
        },
      );

      testScreen('a rate of 0 is refused', (tester) async {
        final h = await pumpScreen(
          tester,
          const RateHistoryScreen(from: usd, to: egp),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.byKey(const ValueKey('add-rate')));
        await tester.pumpAndSettle();
        await tester.enterText(rateInput(), '0');
        await tester.tap(find.byKey(const ValueKey('rate-save')));
        await tester.pumpAndSettle();
        expect(find.text(l10n.errRate), findsOneWidget);
        expect(await rates(tester, h), isEmpty);
      });

      testScreen(
        'editing a typed rate\'s date keeps the row and its id (no conflict)',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const RateHistoryScreen(from: usd, to: egp),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.rate(usd, egp, '49', day(2026, 10, 15));
            },
          );
          final before = (await rates(tester, h)).single;
          await tester.tap(find.byKey(ValueKey('rate-row-${before.id}')));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.calendar_today));
          await tester.pumpAndSettle();
          await tester.tap(find.text('1').first);
          await tester.tap(
            find.text(
              MaterialLocalizations.of(
                tester.element(find.byType(Dialog).first),
              ).okButtonLabel,
            ),
          );
          await tester.pumpAndSettle();
          await tester.enterText(rateInput(), '51');
          await tester.tap(find.byKey(const ValueKey('rate-save')));
          await tester.pumpAndSettle();
          final after = await rates(tester, h);
          expect(after.single.id, before.id);
          expect(after.single.asOf, day(2026, 10, 1));
          expect(after.single.rate, Decimal.fromInt(51));
        },
      );

      testScreen('delete removes a typed rate and Undo brings it back', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const RateHistoryScreen(from: usd, to: egp),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.rate(usd, egp, '49', day(2026, 10, 15));
          },
        );
        final l10n = l10nOf(tester);
        final r = (await rates(tester, h)).single;
        await tester.tap(find.byKey(ValueKey('rate-row-${r.id}')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.delete));
        await tester.pumpAndSettle();
        expect(await rates(tester, h), isEmpty);
        await tester.tap(find.text(l10n.undo));
        await settle(tester);
        expect((await rates(tester, h)).single.rate, Decimal.fromInt(49));
      });

      testScreen('a fetched rate cannot be edited, only overridden by typing', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const RateHistoryScreen(from: usd, to: egp),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.assumptions.saveFetchedRates([
              Rate(
                from: usd,
                to: egp,
                rate: Decimal.parse('49'),
                asOf: day(2026, 10, 15),
                source: RateSource.currencyApi,
              ),
            ]);
          },
        );
        final tile = tester.widget<ListTile>(find.byType(ListTile).first);
        expect(tile.onTap, isNull);
      });
    });
  }

  group('Z18 showRateDialog(on:)', () {
    Widget opener(DateTime? on) => Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showRateDialog(context, from: usd, to: egp, on: on),
          child: const Text('open'),
        ),
      ),
    );

    testScreen('a new rate starts on the given date', (tester) async {
      await pumpScreen(tester, opener(day(2026, 10, 20)));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final shown = MaterialLocalizations.of(
        tester.element(find.byType(AlertDialog)),
      ).formatMediumDate(day(2026, 10, 20));
      expect(textPlain(shown), findsOneWidget);
    });

    testScreen('without a date it starts today', (tester) async {
      await pumpScreen(tester, opener(null));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final shown = MaterialLocalizations.of(
        tester.element(find.byType(AlertDialog)),
      ).formatMediumDate(day(2026, 10, 16));
      expect(textPlain(shown), findsOneWidget);
    });
  });
}
