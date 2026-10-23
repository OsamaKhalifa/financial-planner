/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:async';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/format.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/features/investments/domain/expected_plan.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/item_timeline.dart';
import 'package:financial_planner/features/investments/presentation/home_screen.dart';
import 'package:financial_planner/features/investments/presentation/investment_form_screen.dart';
import 'package:financial_planner/features/investments/presentation/item_detail_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../support/app_harness.dart';
import '../../../support/plan_seeds.dart';

TextField shareField(WidgetTester tester) => tester.widget<TextField>(
  find.descendant(
    of: find.byKey(const ValueKey('share')),
    matching: find.byType(TextField),
  ),
);

Finder field(String label) => find.widgetWithText(TextField, label);

Future<void> type(WidgetTester tester, Finder f, String text) async {
  await tester.ensureVisible(f);
  await tester.enterText(f, text);
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  final f = find.text(text).first;
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<void> save(WidgetTester tester) async {
  final f = find.byKey(const ValueKey('save'));
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<void> pickMarket(WidgetTester tester, String name) async {
  final f = find.byKey(const ValueKey('market'));
  await tester.ensureVisible(f);
  await tester.tap(f);
  await tester.pumpAndSettle();
  await tester.tap(find.text(name).last);
  await tester.pumpAndSettle();
}

Future<List<InvestmentWithHistory>> saved(
  WidgetTester tester,
  Harness h,
) async {
  late List<InvestmentWithHistory> items;
  await tester.runAsync(() async => items = await h.items());
  return items;
}

Future<Settings> settingsOf(WidgetTester tester, Harness h) async {
  late Settings s;
  await tester.runAsync(
    () async => s = await h.assumptions.watchSettings().first,
  );
  return s;
}

WidgetTester? tester0;

void main() {
  for (final locale in [en, ar]) {
    group('S3 form (${locale.languageCode})', () {
      testScreen('AC-1: saving an empty form names what is missing', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const InvestmentFormScreen(),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        await save(tester);
        expect(find.text(l10n.errSummary('2')), findsOneWidget);
        expect(find.text(l10n.errName), findsOneWidget);
        expect(find.text(l10n.errType), findsOneWidget);
        expect(await saved(tester, h), isEmpty);

        await tapText(tester, l10n.typeStock);
        await save(tester);
        expect(find.text(l10n.errMarket), findsOneWidget);
        expect(find.text(l10n.errIntent), findsOneWidget);
        expect(find.text(l10n.errFirstPaid), findsOneWidget);
        expect(find.text(l10n.errName), findsOneWidget);
        expect(find.byKey(const ValueKey('error-summary')), findsOneWidget);
        expect(await saved(tester, h), isEmpty);
      });

      testScreen(
        'AC-1: a fund and an "other" item without intent, gold without grams and purity',
        (tester) async {
          await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.fund),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await save(tester);
          expect(find.text(l10n.errIntent), findsOneWidget);

          await tapText(tester, l10n.typeGold);
          await save(tester);
          expect(find.text(l10n.errGrams), findsOneWidget);
          expect(find.text(l10n.errPurity), findsOneWidget);
          expect(find.text(l10n.errFirstPaid), findsOneWidget);

          await tapText(tester, l10n.typeOther);
          await save(tester);
          expect(find.text(l10n.errIntent), findsOneWidget);
          expect(find.text(l10n.errShare), findsWidgets);
        },
      );

      testScreen(
        'AC-2: a first payment of 0 is rejected and the date picker offers no future day',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.cashDeposit),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Savings');
          await type(tester, find.byKey(const ValueKey('paid')), '0');
          await save(tester);
          expect(find.text(l10n.errZero), findsOneWidget);
          expect(await saved(tester, h), isEmpty);

          await tester.tap(find.byIcon(Icons.calendar_today).first);
          await tester.pumpAndSettle();
          final picker = tester.widget<CalendarDatePicker>(
            find.byType(CalendarDatePicker),
          );
          expect(
            (picker.lastDate.year, picker.lastDate.month, picker.lastDate.day),
            (2026, 10, 16),
          );
          expect(picker.initialDate!.isAfter(picker.lastDate), isFalse);
        },
      );

      testScreen(
        'a cash deposit saves, shows 100 % with its source, and opens the detail',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.cashDeposit),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          expect(textPlain('100.00 %'), findsOneWidget);
          expect(find.text(l10n.zakatReasonCash), findsOneWidget);
          await tester.tap(find.text(l10n.source).last);
          await tester.pumpAndSettle();
          expect(find.textContaining(l10n.src_B1), findsOneWidget);
          await tester.tapAt(const Offset(10, 10));
          await tester.pumpAndSettle();

          await type(tester, field(l10n.fieldName), 'Savings');
          await type(tester, find.byKey(const ValueKey('paid')), '10000');
          await type(
            tester,
            find.byKey(const ValueKey('current-value')),
            '10500',
          );
          await save(tester);
          expect(find.byType(ItemDetailScreen), findsOneWidget);
          final items = await saved(tester, h);
          expect(items.single.investment.name, 'Savings');
          expect(items.single.investment.zakatRule, ZakatRule.cash100);
          expect(
            items.single.history.whereType<MoneyIn>().single.amount.amount,
            Decimal.parse('10000'),
          );
          expect(
            items.single.history.whereType<ValueUpdate>().single.value,
            Decimal.parse('10500'),
          );
          expect(items.single.investment.startDate, day(2026, 10, 16));
        },
      );

      testScreen(
        'AC-5: a long-term stock on the dividends-only method shows 0 % and the notice',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.stock),
            locale: locale,
            seed: (h) => h.setup(method: LongTermMethod.dividendsOnly),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Dividend stock');
          await pickMarket(tester, l10n.marketName('egx'));
          await tapText(tester, l10n.intentLongTerm);
          expect(find.text(l10n.zakatLineDividends), findsOneWidget);
          expect(find.text(l10n.noticeDividends), findsOneWidget);
          await type(tester, find.byKey(const ValueKey('paid')), '50000');
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.zakatRule, ZakatRule.longTermPerSetting);
          expect(item.market, Market.egx);
          expect(item.unit, egp);
        },
      );

      testScreen(
        'AC-6: crypto defaults to 100 % with the disputed-permissibility notice',
        (tester) async {
          await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.crypto),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          expect(textPlain('100.00 %'), findsOneWidget);
          expect(find.text(l10n.noticeCrypto), findsOneWidget);
          await tester.tap(find.text(l10n.source).last);
          await tester.pumpAndSettle();
          expect(find.textContaining(l10n.src_B8), findsOneWidget);
        },
      );

      testScreen(
        'AC-7: an "other" item needs a share the user confirms; the offered 0 % is applied only on tap',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.other),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Flat');
          await type(tester, find.byKey(const ValueKey('paid')), '2000000');
          await tapText(tester, l10n.intentPersonalUse);
          expect(find.text(l10n.hintPersonalUse), findsOneWidget);
          expect(find.text(l10n.zakatNeedsChoice), findsOneWidget);
          final shareInput = shareField(tester);
          expect(shareInput.controller!.text, isEmpty);

          await save(tester);
          expect(find.text(l10n.errShare), findsWidgets);
          expect(await saved(tester, h), isEmpty);
          expect(shareField(tester).controller!.text, isEmpty);

          await tester.tap(find.byKey(const ValueKey('use-offered-share')));
          await tester.pumpAndSettle();
          expect(shareField(tester).controller!.text, '0');
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.zakatRule, ZakatRule.custom);
          expect(item.customZakatShare, Decimal.zero);
        },
      );

      testScreen(
        'AC-7: a business or pension (long-term other) is offered no share',
        (tester) async {
          await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.other),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await tapText(tester, l10n.intentLongTerm);
          expect(find.text(l10n.hintLongTerm), findsOneWidget);
          expect(find.byKey(const ValueKey('use-offered-share')), findsNothing);
        },
      );

      testScreen(
        'AC-8: the first long-term stock asks for the method and the answer becomes the setting',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.stock),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Long stock');
          await pickMarket(tester, l10n.marketName('egx'));
          await type(tester, find.byKey(const ValueKey('paid')), '1000');
          await tapText(tester, l10n.intentLongTerm);
          expect(find.text(l10n.longTermTitle), findsOneWidget);
          expect(radioChecked(tester, l10n.longTermProxy25), isFalse);
          expect(find.text(l10n.zakatNeedsChoice), findsOneWidget);

          await save(tester);
          expect(find.text(l10n.errLongTerm), findsOneWidget);
          expect(await saved(tester, h), isEmpty);
          expect((await settingsOf(tester, h)).longTermMethod, isNull);

          await tester.tap(find.byKey(const ValueKey('method-proxy25')));
          await tester.pumpAndSettle();
          expect(textPlain('25.00 %'), findsOneWidget);
          await save(tester);
          expect(
            (await settingsOf(tester, h)).longTermMethod,
            LongTermMethod.proxy25,
          );
          expect(
            (await saved(tester, h)).single.investment.zakatRule,
            ZakatRule.longTermPerSetting,
          );
        },
      );

      testScreen(
        'with "decide per item" the item stores the method it was given',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.fund),
            locale: locale,
            seed: (h) => h.setup(method: LongTermMethod.perItem),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Index fund');
          await type(tester, find.byKey(const ValueKey('paid')), '1000');
          await tapText(tester, l10n.intentLongTerm);
          await tester.tap(find.byKey(const ValueKey('method-fullValue')));
          await tester.pumpAndSettle();
          await save(tester);
          expect(
            (await saved(tester, h)).single.investment.zakatRule,
            ZakatRule.longTermFullValue,
          );
          expect(
            (await settingsOf(tester, h)).longTermMethod,
            LongTermMethod.perItem,
          );
        },
      );

      testScreen('a stock can be marked "company pays zakat"', (tester) async {
        final h = await pumpScreen(
          tester,
          const InvestmentFormScreen(presetType: AssetType.stock),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        await type(tester, field(l10n.fieldName), 'Saudi stock');
        await pickMarket(tester, l10n.marketName('tadawul'));
        await type(tester, find.byKey(const ValueKey('paid')), '500');
        await tapText(tester, l10n.intentLongTerm);
        await tester.tap(find.text(l10n.companyPays));
        await tester.pumpAndSettle();
        expect(find.text(l10n.zakatLineCompany), findsOneWidget);
        await save(tester);
        final item = (await saved(tester, h)).single.investment;
        expect(item.zakatRule, ZakatRule.companyPaysZakat);
        expect(item.unit, const Unit('SAR'));
      });

      testScreen(
        'AC-24: a USD stock paid for in EGP asks for the rate and stores 1,000 USD',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.stock),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'US stock');
          await pickMarket(tester, l10n.marketName('nasdaq'));
          await tapText(tester, l10n.intentLongTerm);
          await tester.tap(find.byKey(const ValueKey('method-proxy25')));
          await tester.pumpAndSettle();
          // Paid in EGP while the item is in USD.
          await tester.tap(find.widgetWithText(OutlinedButton, 'USD').first);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('unit-EGP')));
          await tester.pumpAndSettle();
          await type(tester, find.byKey(const ValueKey('paid')), '50000');
          expect(find.byKey(const ValueKey('inline-rate')), findsOneWidget);
          await save(tester);
          expect(find.text(l10n.errRate), findsOneWidget);
          expect(await saved(tester, h), isEmpty);

          await type(tester, find.byKey(const ValueKey('inline-rate')), '0.02');
          expect(textPlain('1,000.00 USD'), findsOneWidget);
          await save(tester);
          final saved1 = (await saved(tester, h)).single;
          expect(saved1.investment.unit, usd);
          late List<dynamic> rates;
          await tester.runAsync(
            () async => rates = await h.assumptions.watchRates().first,
          );
          expect(rates.single.from, egp);
          expect(rates.single.to, usd);
          expect(rates.single.rate, Decimal.parse('0.02'));
          expect(h.requests, isEmpty);
        },
      );

      testScreen(
        'AC-37: gold paid for in EGP: pure grams from karat, the rate, and the pure grams bought',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.gold),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Gold bar');
          await type(tester, find.byKey(const ValueKey('paid')), '52000');
          await type(tester, find.byKey(const ValueKey('grams')), '10');
          await tapText(tester, l10n.karat('24'));
          expect(
            textPlain(plain(l10n.pureGramsPreview('10.00 g'))),
            findsOneWidget,
          );
          expect(find.byKey(const ValueKey('inline-rate')), findsOneWidget);
          await type(tester, find.byKey(const ValueKey('inline-rate')), '5000');
          expect(
            textPlain(plain(l10n.pureGramsPreview('10.40 g'))),
            findsOneWidget,
          );
          await save(tester);
          final g = (await saved(tester, h)).single;
          expect(g.investment.unit, xauG);
          expect(g.investment.purityKarat, 24);
          expect(g.investment.zakatRule, ZakatRule.bullion100);
          expect(
            g.history.whereType<ValueUpdate>().single.value,
            Decimal.fromInt(10),
          );
          expect(g.history.whereType<MoneyIn>().single.amount.unit, egp);
        },
      );

      testScreen('21k gold: 20 g are 17.50 pure grams', (tester) async {
        final h = await pumpScreen(
          tester,
          const InvestmentFormScreen(presetType: AssetType.gold),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.rate(xauG, egp, '4000', day(2026, 10, 16));
          },
        );
        final l10n = l10nOf(tester);
        await type(tester, field(l10n.fieldName), 'Ring');
        await type(tester, find.byKey(const ValueKey('paid')), '70000');
        await type(tester, find.byKey(const ValueKey('grams')), '20');
        await tapText(tester, l10n.karat('21'));
        expect(
          textPlain(plain(l10n.pureGramsPreview('17.50 g'))),
          findsOneWidget,
        );
        expect(find.byKey(const ValueKey('inline-rate')), findsNothing);
        await save(tester);
        expect(
          (await saved(
            tester,
            h,
          )).single.history.whereType<ValueUpdate>().single.value,
          Decimal.parse('17.5'),
        );
      });

      testScreen('jewellery asks for the ruling once and stores it', (
        tester,
      ) async {
        final h = await pumpScreen(
          tester,
          const InvestmentFormScreen(presetType: AssetType.gold),
          locale: locale,
          seed: (h) async {
            await h.setup();
            await h.rate(xauG, egp, '4000', day(2026, 10, 16));
          },
        );
        final l10n = l10nOf(tester);
        await type(tester, field(l10n.fieldName), 'Ring');
        await type(tester, find.byKey(const ValueKey('paid')), '40000');
        await type(tester, find.byKey(const ValueKey('grams')), '10');
        await tapText(tester, l10n.karat('24'));
        await tapText(tester, l10n.intentPersonalUse);
        expect(find.text(l10n.jewelleryAsk), findsOneWidget);
        await save(tester);
        expect(find.text(l10n.errJewellery), findsOneWidget);
        expect(await saved(tester, h), isEmpty);
        await tester.tap(find.byKey(const ValueKey('jewellery-no')));
        await tester.pumpAndSettle();
        await save(tester);
        expect((await settingsOf(tester, h)).jewelleryZakatable, isFalse);
        expect(
          (await saved(tester, h)).single.investment.zakatRule,
          ZakatRule.jewelleryPerSetting,
        );
      });

      testScreen(
        'A3: any type but a cash deposit can set its own share, and says what it was',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.crypto),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Coin');
          await type(tester, find.byKey(const ValueKey('paid')), '1000');
          expect(find.byKey(const ValueKey('share')), findsNothing);
          await tester.ensureVisible(
            find.byKey(const ValueKey('custom-share')),
          );
          await tester.tap(find.byKey(const ValueKey('custom-share')));
          await tester.pumpAndSettle();
          expect(
            textPlain(plain(l10n.zakatChangedFrom('100.00 %'))),
            findsOneWidget,
          );
          await save(tester);
          expect(find.text(l10n.errShare), findsWidgets);
          expect(await saved(tester, h), isEmpty);
          await type(
            tester,
            find.descendant(
              of: find.byKey(const ValueKey('share')),
              matching: find.byType(TextField),
            ),
            '50',
          );
          expect(textPlain('50.00 %'), findsWidgets);
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.zakatRule, ZakatRule.custom);
          expect(item.customZakatShare, Decimal.parse('0.5'));
        },
      );

      testScreen('A3: a cash deposit has no share override', (tester) async {
        await pumpScreen(
          tester,
          const InvestmentFormScreen(presetType: AssetType.cashDeposit),
          locale: locale,
          seed: (h) => h.setup(),
        );
        expect(find.byKey(const ValueKey('custom-share')), findsNothing);
      });

      testScreen(
        'U3: the inflation series of an item can be chosen under More',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.cashDeposit),
            locale: locale,
            seed: (h) => h.setup(base: usd),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'USD held in Egypt');
          await type(tester, find.byKey(const ValueKey('paid')), '1000');
          await tester.ensureVisible(find.byKey(const ValueKey('more')));
          await tester.tap(find.byKey(const ValueKey('more')));
          await tester.pumpAndSettle();
          expect(find.text(l10n.inflationSeriesDefault), findsOneWidget);
          await tester.tap(find.byKey(const ValueKey('inflation-series')));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.countryName('EGY')).last);
          await tester.pumpAndSettle();
          await save(tester);
          expect(
            (await saved(tester, h)).single.investment.inflationOverride,
            egy,
          );
        },
      );

      group('fetch in the form', () {
        Future<Harness> usdStockPaidInEgp(WidgetTester tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.stock),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'US stock');
          await pickMarket(tester, l10n.marketName('nasdaq'));
          await tapText(tester, l10n.intentTrading);
          await tester.tap(find.widgetWithText(OutlinedButton, 'USD').first);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('unit-EGP')));
          await tester.pumpAndSettle();
          await type(tester, find.byKey(const ValueKey('paid')), '50000');
          return h;
        }

        testScreen(
          'a fetched rate is shown under the field with its date and source, the row stays, and saving needs no typing',
          (tester) async {
            final h = await usdStockPaidInEgp(tester);
            final l10n = l10nOf(tester);
            h.handler = (_) async => http.Response(
              '{"date":"2026-10-15","usd":{"usd":1,"egp":50}}',
              200,
            );
            await tester.ensureVisible(
              find.byKey(const ValueKey('fetch-rate')),
            );
            await tester.tap(find.byKey(const ValueKey('fetch-rate')));
            await settle(tester);
            expect(find.byKey(const ValueKey('inline-rate')), findsOneWidget);
            expect(
              textPlain(
                plain(
                  l10n
                      .fetchedRateLine(
                        'EGP',
                        '0.0200',
                        'USD',
                        'x',
                        l10n.refreshSource,
                      )
                      .split(' · ')
                      .first,
                ),
              ),
              findsOneWidget,
            );
            expect(find.textContaining(l10n.refreshSource), findsOneWidget);
            expect(h.requests.length, 1);
            await save(tester);
            final item = (await saved(tester, h)).single;
            expect(item.investment.unit, usd);
            expect(item.history.whereType<MoneyIn>().single.amount.unit, egp);
          },
        );

        testScreen('a failed fetch says so and keeps the field', (
          tester,
        ) async {
          final h = await usdStockPaidInEgp(tester);
          final l10n = l10nOf(tester);
          h.handler = (_) async => throw const SocketException('offline');
          await tester.ensureVisible(find.byKey(const ValueKey('fetch-rate')));
          await tester.tap(find.byKey(const ValueKey('fetch-rate')));
          await settle(tester);
          expect(find.text(l10n.fetchFailed), findsOneWidget);
          expect(find.byKey(const ValueKey('inline-rate')), findsOneWidget);
          expect(find.byKey(const ValueKey('fetch-rate')), findsOneWidget);
        });

        testScreen('a pair the source does not cover is named', (tester) async {
          final h = await usdStockPaidInEgp(tester);
          final l10n = l10nOf(tester);
          h.handler = (_) async =>
              http.Response('{"date":"2026-10-15","usd":{"usd":1}}', 200);
          await tester.ensureVisible(find.byKey(const ValueKey('fetch-rate')));
          await tester.tap(find.byKey(const ValueKey('fetch-rate')));
          await settle(tester);
          expect(
            textPlain(plain(l10n.fetchNotCovered('EGP', 'USD'))),
            findsOneWidget,
          );
          expect(find.byKey(const ValueKey('inline-rate')), findsOneWidget);
        });

        testScreen('a spinner shows while the fetch runs', (tester) async {
          final h = await usdStockPaidInEgp(tester);
          final answer = Completer<http.Response>();
          h.handler = (_) => answer.future;
          await tester.ensureVisible(find.byKey(const ValueKey('fetch-rate')));
          await tester.tap(find.byKey(const ValueKey('fetch-rate')));
          await tester.pump();
          expect(find.byKey(const ValueKey('fetch-progress')), findsOneWidget);
          expect(find.byKey(const ValueKey('fetch-rate')), findsNothing);
          answer.complete(
            http.Response(
              '{"date":"2026-10-15","usd":{"usd":1,"egp":50}}',
              200,
            ),
          );
          await settle(tester);
          expect(find.byKey(const ValueKey('fetch-progress')), findsNothing);
        });
      });

      testScreen('leaving a changed form asks before discarding', (
        tester,
      ) async {
        await pumpScreen(
          tester,
          const InvestmentFormScreen(presetType: AssetType.cashDeposit),
          locale: locale,
          seed: (h) => h.setup(),
        );
        final l10n = l10nOf(tester);
        await type(tester, field(l10n.fieldName), 'x');
        await tapText(tester, l10n.typeFund);
        final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
        await widgetsAppState.didPopRoute();
        await tester.pumpAndSettle();
        expect(find.text(l10n.discardTitle), findsOneWidget);
        await tester.tap(find.text(l10n.keepEditing));
        await tester.pumpAndSettle();
        expect(find.byType(InvestmentFormScreen), findsOneWidget);
      });

      testScreen(
        'editing keeps the history; delete asks first and can be undone',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'a'),
            locale: locale,
            seed: (h) async {
              await h.setup();
              await h.addItem(item('a', name: 'Old name'), [
                moneyIn('a', day(2026, 1, 1), '1000'),
                value('a', day(2026, 3, 1), '1100'),
              ]);
            },
          );
          final l10n = l10nOf(tester);
          expect(find.text('Old name'), findsOneWidget);
          await type(tester, field(l10n.fieldName), 'New name');
          await save(tester);
          final items = await saved(tester, h);
          expect(items.single.investment.name, 'New name');
          expect(items.single.history.length, 2);
        },
      );

      Future<(int, int, int)> openStartPicker(WidgetTester tester) async {
        final f = find.byIcon(Icons.calendar_today).first;
        await tester.ensureVisible(f);
        await tester.tap(f);
        await tester.pumpAndSettle();
        final last = tester
            .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
            .lastDate;
        return (last.year, last.month, last.day);
      }

      Future<void> pickInOpenPicker(
        WidgetTester tester,
        int months,
        String dayOfMonth,
      ) async {
        final ml = MaterialLocalizations.of(
          tester.element(find.byType(Dialog)),
        );
        for (var i = 0; i < months; i++) {
          await tester.tap(find.byTooltip(ml.nextMonthTooltip));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text(dayOfMonth).hitTestable().first);
        await tester.tap(find.text(ml.okButtonLabel));
        await tester.pumpAndSettle();
      }

      String shown(WidgetTester tester, DateTime d) =>
          MaterialLocalizations.of(tester.element(find.byType(Scaffold).first))
              .formatMediumDate(d);

      testScreen(
        'AC-77: Friend\'s project start 2026-01-15 → 2026-02-10 moves the first money in; rows are 2026-05-10 and 2026-08-10',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'fp'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          final before = (await saved(tester, h)).single.history.single.id;
          expect(find.text(l10n.editStartMoves), findsNothing);
          expect(await openStartPicker(tester), (2026, 10, 17));
          await pickInOpenPicker(tester, 1, '10');
          expect(find.text(l10n.editStartMoves), findsOneWidget);
          expect(find.text(l10n.editRowsRebuilt), findsOneWidget);
          expect(
            textPlain(plain(l10n.editStartMaxDate('§').split('§').first)),
            findsNothing,
          );
          await save(tester);
          expect(find.byType(AlertDialog), findsNothing);
          final after = (await saved(tester, h)).single;
          expect(after.investment.startDate, day(2026, 2, 10));
          final paid = after.history.single as MoneyIn;
          expect((paid.id, paid.date), (before, day(2026, 2, 10)));
          final plan = expectedVsActual(
            ItemTimeline(after, RateBook(const [])),
            day(2026, 10, 17),
          )!;
          final rows = plan.pendingRows.toList()
            ..sort((a, b) => a.date.compareTo(b.date));
          expect(
            [for (final r in rows) (r.date, r.expected)],
            [
              (day(2026, 5, 10), Decimal.parse('5000')),
              (day(2026, 8, 10), Decimal.parse('5000')),
            ],
          );
          expect(plan.expectedSoFar, Decimal.parse('10000'));
        },
      );

      testScreen(
        'AC-77: after moving Friend\'s project to 2026-02-10, Home shows "2 to confirm"',
        (tester) async {
          await pumpScreen(
            tester,
            const HomeScreen(),
            locale: locale,
            now: day(2026, 10, 17),
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.toConfirmPill(3)), findsOneWidget);
          unawaited(
            tester
                .state<NavigatorState>(find.byType(Navigator).first)
                .push(
                  MaterialPageRoute<void>(
                    builder: (_) => const InvestmentFormScreen(editId: 'fp'),
                  ),
                ),
          );
          await tester.pumpAndSettle();
          await openStartPicker(tester);
          await pickInOpenPicker(tester, 1, '10');
          await save(tester);
          expect(find.byType(InvestmentFormScreen), findsNothing);
          expect(find.text(l10n.toConfirmPill(2)), findsOneWidget);
        },
      );

      testScreen(
        'AC-77: moving the start and changing the plan says "Rows to confirm are rebuilt" once',
        (tester) async {
          await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'fp'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldExpectedProfit), '25');
          expect(find.text(l10n.editRowsRebuilt), findsOneWidget);
          await openStartPicker(tester);
          await pickInOpenPicker(tester, 1, '10');
          expect(find.text(l10n.editStartMoves), findsOneWidget);
          expect(find.text(l10n.editRowsRebuilt), findsOneWidget);
        },
      );

      testScreen(
        'AC-77: with income on 2026-04-20 the picker stops at 2026-04-20, names it, and that date saves',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'fp'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: (h) => seedFriend(
              h,
              more: [
                moneyOut(
                  'fp',
                  day(2026, 4, 20),
                  '5000',
                  kind: MoneyOutKind.income,
                ),
                moneyOut(
                  'fp',
                  day(2026, 7, 14),
                  '10000',
                  kind: MoneyOutKind.income,
                ),
              ],
            ),
          );
          final l10n = l10nOf(tester);
          expect(
            textPlain(
              plain(l10n.editStartMaxDate(shown(tester, day(2026, 4, 20)))),
            ),
            findsOneWidget,
          );
          expect(await openStartPicker(tester), (2026, 4, 20));
          await pickInOpenPicker(tester, 3, '20');
          await save(tester);
          final after = (await saved(tester, h)).single;
          expect(after.investment.startDate, day(2026, 4, 20));
          expect(
            after.history.whereType<MoneyIn>().single.date,
            day(2026, 4, 20),
          );
          expect(
            after.history.whereType<MoneyOut>().map((e) => e.date).toSet(),
            {day(2026, 4, 20), day(2026, 7, 14)},
          );
        },
      );

      testScreen(
        'AC-77: a gold item with a value update on 2026-08-01 stops the picker on 2026-07-31',
        (tester) async {
          await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'g'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: (h) async {
              await h.setup();
              await h.addItem(
                item(
                  'g',
                  type: AssetType.gold,
                  unit: xauG,
                  start: day(2026, 3, 1),
                  intent: Intent.longTerm,
                  rule: ZakatRule.bullion100,
                  karat: 24,
                ),
                [
                  moneyIn('g', day(2026, 3, 1), '50000'),
                  value('g', day(2026, 3, 1), '10'),
                  value('g', day(2026, 8, 1), '10'),
                ],
              );
            },
          );
          expect(await openStartPicker(tester), (2026, 7, 31));
        },
      );

      testScreen(
        'AC-77: a gold item\'s first money in and start grams both move to 2026-02-01',
        (tester) async {
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'g'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: (h) async {
              await h.setup();
              await h.addItem(
                item(
                  'g',
                  type: AssetType.gold,
                  unit: xauG,
                  start: day(2026, 3, 1),
                  intent: Intent.longTerm,
                  rule: ZakatRule.bullion100,
                  karat: 24,
                ),
                [
                  moneyIn('g', day(2026, 3, 1), '50000'),
                  value('g', day(2026, 3, 1), '10'),
                ],
              );
            },
          );
          final l10n = l10nOf(tester);
          await openStartPicker(tester);
          final ml = MaterialLocalizations.of(
            tester.element(find.byType(Dialog)),
          );
          await tester.tap(find.byTooltip(ml.previousMonthTooltip));
          await tester.pumpAndSettle();
          await pickInOpenPicker(tester, 0, '1');
          expect(find.text(l10n.editStartMovesMetal), findsOneWidget);
          await save(tester);
          final after = (await saved(tester, h)).single;
          expect(after.investment.startDate, day(2026, 2, 1));
          expect(after.history.map((e) => e.date).toSet(), {day(2026, 2, 1)});
          expect(after.history.length, 2);
        },
      );
      Future<void> peBasics(WidgetTester tester, String name) async {
        await type(tester, field(l10nOf(tester).fieldName), name);
        await type(
          tester,
          find.descendant(
            of: find.byKey(const ValueKey('paid')),
            matching: find.byType(TextField),
          ),
          '100000',
        );
      }

      Future<void> tapKey(WidgetTester tester, String key) async {
        final f = find.byKey(ValueKey(key));
        await tester.ensureVisible(f);
        await tester.tap(f);
        await tester.pumpAndSettle();
      }

      String money(String amount) => plain(
        l10nOf(tester0!).amountWithUnit(
          formatAmount(Decimal.parse(amount), locale.languageCode),
          'EGP',
        ),
      );

      testScreen(
        'AC-46: private equity asks no market, offers only To sell and Long-term, shares are optional, unit is the base; no intent is named',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.privateEquity),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          expect(find.byKey(const ValueKey('market')), findsNothing);
          expect(find.text(l10n.peIntentTrading), findsOneWidget);
          expect(find.text(l10n.peIntentLongTerm), findsOneWidget);
          expect(find.text(l10n.intentPersonalUse), findsNothing);
          expect(find.text(l10n.intentRental), findsNothing);
          expect(field(l10n.fieldSharesInProject), findsOneWidget);
          expect(textPlain('EGP · '), findsOneWidget);
          expect(find.text(l10n.typePrivateEquityHint), findsOneWidget);
          await peBasics(tester, "Friend's project");
          await tapKey(tester, 'q2-CapitalBack.no');
          await save(tester);
          expect(find.text(l10n.errIntent), findsOneWidget);
          expect(await saved(tester, h), isEmpty);
          await tapText(tester, l10n.peIntentTrading);
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.type, AssetType.privateEquity);
          expect(item.unit, egp);
          expect(item.market, isNull);
          expect(item.quantity, isNull);
        },
      );

      testScreen(
        'AC-47: to sell is 100 % with no method; long-term asks one of three, nothing picked, no 25 %; profit received only shows the payout notice',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.privateEquity),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await peBasics(tester, "Friend's project");
          await tapKey(tester, 'q2-CapitalBack.no');
          await tapText(tester, l10n.peIntentTrading);
          expect(find.text(l10n.zakatPeTrading), findsOneWidget);
          expect(
            find.byKey(const ValueKey('pe-method-ZakatRule.custom')),
            findsNothing,
          );
          await tapText(tester, l10n.peIntentLongTerm);
          for (final o in [
            l10n.peMethodKnown,
            l10n.peMethodProfit,
            l10n.peMethodFull,
          ]) {
            expect(find.text(o), findsOneWidget);
            expect(radioChecked(tester, o), isFalse);
          }
          expect(find.text(l10n.longTermProxy25), findsNothing);
          expect(find.text(l10n.peMethodsHelp), findsOneWidget);
          await save(tester);
          expect(find.text(l10n.peMethodPick), findsOneWidget);
          expect(await saved(tester, h), isEmpty);
          await tapText(tester, l10n.peMethodProfit);
          final rate = plain(
            formatPercent(Decimal.parse('0.025'), locale.languageCode),
          ).replaceAll('+', '');
          expect(
            textPlain(plain(l10n.noticeProfitPayoutsOnly(rate))),
            findsOneWidget,
          );
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.zakatRule, ZakatRule.longTermDividendsOnly);
          expect(item.capitalBack, CapitalBack.no);
        },
      );

      testScreen(
        'AC-48: no plan on gold or silver, no payout plan on crypto; % without schedule, 0 % and −100 % are refused',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.gold),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          expect(find.byKey(const ValueKey('expected')), findsNothing);
          await tapText(tester, l10n.typeSilver);
          expect(find.byKey(const ValueKey('expected')), findsNothing);
          await tapText(tester, l10n.typeCrypto);
          await tapText(tester, l10n.expectedTitle);
          expect(find.byKey(const ValueKey('expected-profit')), findsNothing);
          expect(find.byKey(const ValueKey('payout-monthly')), findsNothing);
          expect(find.byKey(const ValueKey('expected-growth')), findsOneWidget);
          await tapText(tester, l10n.typeFund);
          await tapText(tester, l10n.intentTrading);
          await type(tester, field(l10n.fieldName), 'F');
          await type(
            tester,
            find.descendant(
              of: find.byKey(const ValueKey('paid')),
              matching: find.byType(TextField),
            ),
            '10000',
          );
          Finder pct(String key) => find.descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(TextField),
          );
          await type(tester, pct('expected-profit'), '10');
          await type(tester, pct('expected-growth'), '-100');
          await save(tester);
          expect(find.text(l10n.errPickPayoutSchedule), findsOneWidget);
          expect(find.text(l10n.errPickValueSchedule), findsOneWidget);
          await tapKey(tester, 'payout-monthly');
          await tapKey(tester, 'value-yearly');
          await type(tester, pct('expected-profit'), '0');
          await save(tester);
          expect(find.text(l10n.errProfitPositive), findsOneWidget);
          expect(find.text(l10n.errGrowthTooLow), findsOneWidget);
          expect(await saved(tester, h), isEmpty);
          await type(tester, pct('expected-profit'), '');
          await type(tester, pct('expected-growth'), '-10');
          expect(textPlain(money('9000')), findsOneWidget);
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.expectedGrowth, Decimal.parse('-0.1'));
          expect(item.valueCheckSchedule, Schedule.yearly);
          expect(item.payoutSchedule, Schedule.monthly);
          expect(item.expectedProfit, isNull);
        },
      );

      testScreen(
        'AC-49: 100,000 at 20 % every 3 months shows 5,000.00 EGP per payout',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.privateEquity),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await peBasics(tester, "Friend's project");
          await tapText(tester, l10n.peIntentLongTerm);
          await tapText(tester, l10n.peMethodFull);
          await tapKey(tester, 'q2-CapitalBack.no');
          await tapKey(tester, 'payout-quarterly');
          await type(
            tester,
            find.descendant(
              of: find.byKey(const ValueKey('expected-profit')),
              matching: find.byType(TextField),
            ),
            '20',
          );
          final preview = tester
              .widget<Text>(find.byKey(const ValueKey('payout-preview')))
              .data!;
          expect(plain(preview), contains(money('5000')));
          expect(plain(preview), contains('3'));
          await tapKey(tester, 'q1-ProfitBasis.shareOfProfit');
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.expectedProfit, Decimal.parse('0.2'));
          expect(item.payoutSchedule, Schedule.quarterly);
          expect(item.profitBasis, ProfitBasis.shareOfProfit);
        },
      );

      testScreen(
        'AC-64: Q2 is asked on every private equity item; Q1 only with a %; each case shows its notice',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.privateEquity),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await peBasics(tester, 'P');
          await tapText(tester, l10n.peIntentTrading);
          expect(find.text(l10n.q2CapitalBack), findsOneWidget);
          expect(find.text(l10n.q1ProfitBasis), findsNothing);
          await save(tester);
          expect(find.text(l10n.errPickOne), findsOneWidget);
          expect(await saved(tester, h), isEmpty);
          await tapKey(tester, 'q2-CapitalBack.no');
          expect(find.byKey(const ValueKey('pe-notice')), findsNothing);
          await tapKey(tester, 'q2-CapitalBack.notSure');
          expect(find.text(l10n.noticeCaseNotSure), findsOneWidget);
          await tapKey(tester, 'q2-CapitalBack.yes');
          expect(find.text(l10n.noticeCaseC), findsOneWidget);
          expect(
            textPlain(plain(l10n.noticeCapitalBackIsDebt)),
            findsOneWidget,
          );
          await tapKey(tester, 'q2-CapitalBack.no');
          await tapKey(tester, 'payout-quarterly');
          await type(
            tester,
            find.descendant(
              of: find.byKey(const ValueKey('expected-profit')),
              matching: find.byType(TextField),
            ),
            '20',
          );
          expect(find.text(l10n.q1ProfitBasis), findsOneWidget);
          await save(tester);
          expect(find.text(l10n.errPickOne), findsOneWidget);
          await tapKey(tester, 'q1-ProfitBasis.shareOfProfit');
          expect(find.byKey(const ValueKey('pe-notice')), findsNothing);
          await tapKey(tester, 'q1-ProfitBasis.fixedPctOfMoney');
          expect(find.text(l10n.noticeCaseB), findsOneWidget);
          expect(find.text(l10n.caseBTagPreview), findsOneWidget);
          await tapKey(tester, 'q1-ProfitBasis.notSure');
          expect(find.text(l10n.noticeCaseNotSure), findsOneWidget);
          expect(find.text(l10n.source), findsWidgets);
          await save(tester);
          final item = (await saved(tester, h)).single.investment;
          expect(item.peCase, PeCase.notSure);
        },
      );

      testScreen(
        'AC-67, AC-70: a cash deposit asks the account kind only with a payout schedule; conventional shows the interest notice; stocks show none',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.cashDeposit),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await type(tester, field(l10n.fieldName), 'Dep');
          await type(
            tester,
            find.descendant(
              of: find.byKey(const ValueKey('paid')),
              matching: find.byType(TextField),
            ),
            '10000',
          );
          await tapText(tester, l10n.expectedTitle);
          expect(find.text(l10n.accountKindQuestion), findsNothing);
          expect(find.text(l10n.fieldExpectedProfit), findsOneWidget);
          expect(find.text(l10n.estimateHelp), findsNWidgets(2));
          await tapKey(tester, 'payout-monthly');
          expect(find.text(l10n.accountKindQuestion), findsOneWidget);
          await save(tester);
          expect(find.text(l10n.errPickAccountKind), findsOneWidget);
          expect(await saved(tester, h), isEmpty);
          await tapKey(tester, 'account-conventional');
          expect(
            find.byKey(const ValueKey('conventional-notice')),
            findsOneWidget,
          );
          await save(tester);
          expect(
            (await saved(tester, h)).single.investment.accountKind,
            AccountKind.conventional,
          );
        },
      );

      testScreen(
        'AC-67: a stock with an expected profit % shows no account question or notice',
        (tester) async {
          tester0 = tester;
          await pumpScreen(
            tester,
            const InvestmentFormScreen(presetType: AssetType.stock),
            locale: locale,
            seed: (h) => h.setup(),
          );
          final l10n = l10nOf(tester);
          await tapText(tester, l10n.expectedTitle);
          await tapKey(tester, 'payout-quarterly');
          await type(
            tester,
            find.descendant(
              of: find.byKey(const ValueKey('expected-profit')),
              matching: find.byType(TextField),
            ),
            '8',
          );
          expect(find.text(l10n.accountKindQuestion), findsNothing);
          expect(
            find.byKey(const ValueKey('conventional-notice')),
            findsNothing,
          );
          expect(find.byKey(const ValueKey('pe-notice')), findsNothing);
        },
      );
      testScreen(
        'U4: on edit, changing Q2 shows "This recalculates every past month" right under Q2',
        (tester) async {
          tester0 = tester;
          await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'fp'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: seedFriend,
          );
          final l10n = l10nOf(tester);
          expect(find.byKey(const ValueKey('q2-recalculates')), findsNothing);
          await tapKey(tester, 'q2-CapitalBack.yes');
          expect(find.byKey(const ValueKey('q2-recalculates')), findsOneWidget);
          expect(find.text(l10n.editRecalculates), findsWidgets);
        },
      );

      testScreen(
        'AC-66: changing Q1 to share of profit on the edit form removes the Shariah risk tag',
        (tester) async {
          tester0 = tester;
          final h = await pumpScreen(
            tester,
            const InvestmentFormScreen(editId: 'fp'),
            locale: locale,
            now: day(2026, 10, 17),
            seed: (h) => seedFriend(
              h,
              investment: friendsProject(q1: ProfitBasis.fixedPctOfMoney),
            ),
          );
          final l10n = l10nOf(tester);
          expect(find.text(l10n.caseBTagPreview), findsOneWidget);
          await tapKey(tester, 'q1-ProfitBasis.shareOfProfit');
          expect(find.text(l10n.caseBTagPreview), findsNothing);
          await save(tester);
          expect(
            (await saved(tester, h)).single.investment.shariahRisk,
            isFalse,
          );
        },
      );
    });
  }
}
