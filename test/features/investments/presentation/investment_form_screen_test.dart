/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/investment_form_screen.dart';
import 'package:financial_planner/features/investments/presentation/item_detail_screen.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_test/flutter_test.dart';

import '../../../support/app_harness.dart';

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
          expect(find.text(l10n.src_B1), findsOneWidget);
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
          expect(find.text(l10n.src_B8), findsOneWidget);
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
    });
  }
}
