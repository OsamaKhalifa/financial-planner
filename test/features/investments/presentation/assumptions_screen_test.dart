/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/assumptions_screen.dart';
import 'package:financial_planner/features/investments/presentation/inflation_series_screen.dart';
import 'package:financial_planner/features/investments/presentation/rate_history_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../support/app_harness.dart';

Future<void> seedUs(Harness h, {LongTermMethod? method}) async {
  await h.setup(method: method);
  await h.rate(usd, egp, '50', day(2026, 10, 3));
  await h.addItem(
    item(
      'us',
      name: 'US stock',
      type: AssetType.stock,
      unit: usd,
      market: Market.nasdaq,
    ),
    [
      moneyIn('us', day(2026, 1, 1), '100', usd),
      value('us', day(2026, 10, 3), '110'),
    ],
  );
}

Future<Settings> settingsOf(WidgetTester tester, Harness h) async {
  late Settings s;
  await tester.runAsync(
    () async => s = await h.assumptions.watchSettings().first,
  );
  return s;
}

Future<void> scrollTo(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(
    f,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in [en, ar]) {
    group('S8 assumptions (${locale.languageCode})', () {
      testScreen('base, home inflation and the rate in use with its origin', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          seed: seedUs,
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.baseLine('EGP')), findsOneWidget);
        expect(
          find.text(l10n.homeInflationLine(l10n.countryName('EGY'), 'EGP')),
          findsOneWidget,
        );
        final row = find.byKey(const ValueKey('rate-USD-EGP'));
        expect(row, findsOneWidget);
        expect(textPlain('1 USD = 50.0000 EGP'), findsOneWidget);
        expect(textPlain(l10n.rateTagTyped), findsOneWidget);
        expect(find.text(l10n.noRatesYet), findsNothing);
      });

      testScreen('a pair without a rate is shown as missing', (tester) async {
        await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          seed: (h) async {
            await seedUs(h);
            for (final r in await h.assumptions.watchRates().first) {
              await h.assumptions.deleteRate(r.id);
            }
          },
        );
        final l10n = l10nOf(tester);
        expect(find.text(l10n.rateMissingAdd('USD', 'EGP')), findsOneWidget);
        expect(find.text(l10n.rateMissingMarker), findsOneWidget);
      });

      testScreen(
        'AC-28: a typed and a fetched rate on one date: yours is used and the source value is named',
        (tester) async {
          await pumpScreen(
            tester,
            const AssumptionsScreen(),
            locale: locale,
            seed: (h) async {
              await seedUs(h);
              await h.assumptions.saveFetchedRates([
                Rate(
                  from: usd,
                  to: egp,
                  rate: Decimal.parse('48.5'),
                  asOf: day(2026, 10, 3),
                  source: RateSource.currencyApi,
                ),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(textPlain('1 USD = 50.0000 EGP'), findsOneWidget);
          expect(
            textPlain(plain(l10n.rateTypedUsed('48.5000'))),
            findsOneWidget,
          );
        },
      );

      testScreen('a rate older than this month carries the stale marker', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          now: day(2026, 11, 5),
          seed: seedUs,
        );
        expect(
          find.textContaining(l10nOf(tester).rateStaleMarker),
          findsOneWidget,
        );
      });

      testScreen('Refresh rates asks the network once and stores the answer', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          seed: seedUs,
        );
        h.handler = (_) async => http.Response(
          '{"date":"2026-10-15","usd":{"egp":48.5,"usd":1,"xau":0.0003,"xag":0.02}}',
          200,
        );
        await tester.tap(find.byKey(const ValueKey('assumptions-refresh')));
        await settle(tester);
        expect(h.requests.length, 1);
        late List<Rate> rates;
        await tester.runAsync(
          () async => rates = await h.assumptions.watchRates().first,
        );
        expect(
          rates.where((r) => r.source == RateSource.currencyApi).length,
          greaterThanOrEqualTo(2),
        );
      });

      testScreen(
        'zakat year and jewellery ruling are changed here and stored',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const AssumptionsScreen(),
            locale: locale,
            seed: seedUs,
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('year-solar')));
          expect(radioChecked(tester, l10n.zakatYearLunar), isTrue);
          await tester.tap(find.byKey(const ValueKey('year-solar')));
          await settle(tester);
          await scrollTo(
            tester,
            find.byKey(const ValueKey('assumptions-jewellery-yes')),
          );
          expect(find.text(l10n.jewelleryNotAsked), findsOneWidget);
          await tester.tap(
            find.byKey(const ValueKey('assumptions-jewellery-yes')),
          );
          await settle(tester);
          final s = await settingsOf(tester, h);
          expect(s.zakatYear, ZakatYear.solar);
          expect(s.jewelleryZakatable, isTrue);
          expect(s.baseCurrency, egp);
        },
      );

      testScreen(
        'switching the long-term method to "per item" writes the method into the items that followed it',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const AssumptionsScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup(method: LongTermMethod.proxy25);
              await h.addItem(
                item(
                  'follows',
                  type: AssetType.stock,
                  market: Market.egx,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermPerSetting,
                ),
                [moneyIn('follows', day(2026, 1, 1), '1000')],
              );
              await h.addItem(
                item(
                  'explicit',
                  type: AssetType.stock,
                  market: Market.egx,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermFullValue,
                ),
                [moneyIn('explicit', day(2026, 1, 1), '1000')],
              );
              await h.addItem(
                item('trader', type: AssetType.stock, market: Market.egx),
                [moneyIn('trader', day(2026, 1, 1), '1000')],
              );
            },
          );
          await scrollTo(tester, find.byKey(const ValueKey('method-perItem')));
          await tester.tap(find.byKey(const ValueKey('method-perItem')));
          await settle(tester);
          final byId = {
            for (final x in await _items(tester, h))
              x.investment.id: x.investment.zakatRule,
          };
          expect(byId['follows'], ZakatRule.longTermProxy25);
          expect(byId['explicit'], ZakatRule.longTermFullValue);
          expect(byId['trader'], ZakatRule.trading100);
          expect(
            (await settingsOf(tester, h)).longTermMethod,
            LongTermMethod.perItem,
          );
        },
      );

      testScreen(
        'switching between portfolio-wide methods leaves the items following it',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const AssumptionsScreen(),
            locale: locale,
            seed: (h) async {
              await h.setup(method: LongTermMethod.proxy25);
              await h.addItem(
                item(
                  'follows',
                  type: AssetType.stock,
                  market: Market.egx,
                  intent: Intent.longTerm,
                  rule: ZakatRule.longTermPerSetting,
                ),
                [moneyIn('follows', day(2026, 1, 1), '1000')],
              );
            },
          );
          await scrollTo(
            tester,
            find.byKey(const ValueKey('method-dividendsOnly')),
          );
          await tester.tap(find.byKey(const ValueKey('method-dividendsOnly')));
          await settle(tester);
          expect(
            (await _items(tester, h)).single.investment.zakatRule,
            ZakatRule.longTermPerSetting,
          );
          expect(
            (await settingsOf(tester, h)).longTermMethod,
            LongTermMethod.dividendsOnly,
          );
        },
      );

      testScreen('the home inflation series can be changed', (tester) async {
        final h = await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          seed: seedUs,
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.text(l10n.change).last);
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
          (await settingsOf(tester, h)).homeInflation,
          const Country('SAU'),
        );
      });

      testScreen('changing the base currency asks first; cancel keeps it', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          seed: seedUs,
        );
        final l10n = l10nOf(tester);
        await tester.tap(
          find.descendant(
            of: find.byKey(const ValueKey('base-row')),
            matching: find.byType(TextButton),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('unit-SAR')));
        await tester.pumpAndSettle();
        expect(find.text(l10n.baseChangeWarning), findsOneWidget);
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        expect((await settingsOf(tester, h)).baseCurrency, egp);

        await tester.tap(
          find.descendant(
            of: find.byKey(const ValueKey('base-row')),
            matching: find.byType(TextButton),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('unit-SAR')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.change).last);
        await settle(tester);
        final s = await settingsOf(tester, h);
        expect(s.baseCurrency, sar);
      });

      testScreen(
        'every investment year has its own no-zakat switch; Update all lives on Investments, not here',
        (tester) async {
          await pumpScreen(
            tester,
            const AssumptionsScreen(),
            locale: locale,
            seed: (h) async {
              await seedUs(h);
              await h.addItem(item('old', start: day(2025, 3, 1)), [
                moneyIn('old', day(2025, 3, 1), '10'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          await scrollTo(tester, find.byKey(const ValueKey('no-zakat-2025')));
          expect(find.byKey(const ValueKey('no-zakat-2026')), findsOneWidget);
          expect(find.text(l10n.updateAll), findsNothing);
        },
      );

      testScreen(
        'the inflation series in use are listed and open their year list',
        (tester) async {
          await pumpScreen(
            tester,
            const AssumptionsScreen(),
            locale: locale,
            seed: seedUs,
          );
          await scrollTo(tester, find.byKey(const ValueKey('series-EGY')));
          expect(find.byKey(const ValueKey('series-USA')), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('series-USA')));
          await tester.pumpAndSettle();
          expect(find.byType(InflationSeriesScreen), findsOneWidget);
        },
      );

      testScreen('a rate row opens its history and Add rate opens the dialog', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const AssumptionsScreen(),
          locale: locale,
          seed: seedUs,
        );
        final l10n = l10nOf(tester);
        await tester.tap(find.byKey(const ValueKey('rate-USD-EGP')));
        await tester.pumpAndSettle();
        expect(find.byType(RateHistoryScreen), findsOneWidget);
        expect(find.text(l10n.rateHistoryTitle('USD', 'EGP')), findsOneWidget);
      });
    });
  }
}

Future<List<InvestmentWithHistory>> _items(
  WidgetTester tester,
  Harness h,
) async {
  late List<InvestmentWithHistory> r;
  await tester.runAsync(() async => r = await h.items());
  return r;
}
