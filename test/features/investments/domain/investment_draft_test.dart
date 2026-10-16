/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/investment_draft.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
final today = day(2026, 10, 16);
const setup = Settings(baseCurrency: egp, zakatYear: ZakatYear.lunar);

InvestmentDraft stock({
  Intent? intent = Intent.longTerm,
  Market? market = Market.egx,
}) => InvestmentDraft(
  name: 'S',
  type: AssetType.stock,
  intent: intent,
  market: market,
  unit: egp,
  startDate: day(2026, 1, 1),
  firstPaid: Money(Decimal.parse('100'), egp),
);

void main() {
  test(
    'a long-term stock asks for the long-term method before it can be saved',
    () {
      expect(validate(stock(), today: today, settings: setup), [
        DraftError.answerLongTermMethod,
      ]);
      const answered = Settings(
        baseCurrency: egp,
        zakatYear: ZakatYear.lunar,
        longTermMethod: LongTermMethod.proxy25,
      );
      expect(validate(stock(), today: today, settings: answered), isEmpty);
    },
  );

  test('per-item method: the user must pick the rule', () {
    const perItem = Settings(longTermMethod: LongTermMethod.perItem);
    expect(validate(stock(), today: today, settings: perItem), [
      DraftError.shareRequired,
    ]);
  });

  test('"other" market needs a country; a custom share must be 0..1', () {
    expect(
      validate(
        stock(market: Market.other, intent: Intent.trading),
        today: today,
        settings: setup,
      ),
      [DraftError.missingMarketCountry],
    );
  });

  test('personal-use gold asks the jewellery ruling once', () {
    final jewellery = InvestmentDraft(
      name: 'Ring',
      type: AssetType.gold,
      intent: Intent.personalUse,
      unit: xauG,
      startDate: day(2026, 1, 1),
      firstPaid: Money(Decimal.parse('100'), egp),
      grossGrams: Decimal.parse('10'),
      purityKarat: 21,
    );
    expect(validate(jewellery, today: today, settings: setup), [
      DraftError.answerJewellery,
    ]);
    const answered = Settings(jewelleryZakatable: false);
    expect(validate(jewellery, today: today, settings: answered), isEmpty);
  });

  test('a custom share outside 0..1 is rejected', () {
    InvestmentDraft custom(String share) => InvestmentDraft(
      name: 'x',
      type: AssetType.other,
      intent: Intent.rental,
      unit: egp,
      startDate: day(2026, 1, 1),
      firstPaid: Money(Decimal.parse('100'), egp),
      zakatRule: ZakatRule.custom,
      customZakatShare: Decimal.parse(share),
    );
    expect(validate(custom('1.5'), today: today, settings: setup), [
      DraftError.shareRequired,
    ]);
    expect(validate(custom('0.4'), today: today, settings: setup), isEmpty);
  });

  test('today itself is a valid start date', () {
    final d = InvestmentDraft(
      name: 'x',
      type: AssetType.cashDeposit,
      unit: egp,
      startDate: today,
      firstPaid: Money(Decimal.parse('1'), egp),
    );
    expect(validate(d, today: today, settings: setup), isEmpty);
  });
}
