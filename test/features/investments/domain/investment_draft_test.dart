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

  InvestmentDraft draft(
    AssetType type, {
    Intent? intent,
    ZakatRule? rule,
    Schedule? payout,
    String? profit,
    Schedule? check,
    String? growth,
    ProfitBasis? q1,
    CapitalBack? q2,
    AccountKind? account,
  }) => InvestmentDraft(
    name: 'x',
    type: type,
    intent: intent,
    unit: egp,
    startDate: day(2026, 1, 1),
    firstPaid: Money(Decimal.parse('100'), egp),
    zakatRule: rule,
    payoutSchedule: payout,
    expectedProfit: profit == null ? null : Decimal.parse(profit),
    valueCheckSchedule: check,
    expectedGrowth: growth == null ? null : Decimal.parse(growth),
    profitBasis: q1,
    capitalBack: q2,
    accountKind: account,
  );

  List<DraftError> check(InvestmentDraft d) =>
      validate(d, today: today, settings: setup);

  test('private equity: intent is trading or long-term, Q2 always asked', () {
    expect(check(draft(AssetType.privateEquity, q2: CapitalBack.no)), [
      DraftError.missingIntent,
    ]);
    expect(
      check(
        draft(
          AssetType.privateEquity,
          intent: Intent.rental,
          q2: CapitalBack.no,
        ),
      ),
      [DraftError.missingIntent],
    );
    expect(check(draft(AssetType.privateEquity, intent: Intent.trading)), [
      DraftError.answerCapitalBack,
    ]);
    expect(
      check(
        draft(
          AssetType.privateEquity,
          intent: Intent.trading,
          q2: CapitalBack.notSure,
        ),
      ),
      isEmpty,
    );
  });

  test('private equity long-term: one of three methods, never the 25 % proxy; case C needs none', () {
    InvestmentDraft lt(ZakatRule? rule, {CapitalBack q2 = CapitalBack.no}) =>
        draft(
          AssetType.privateEquity,
          intent: Intent.longTerm,
          rule: rule,
          q2: q2,
        );
    expect(check(lt(null)), [DraftError.shareRequired]);
    expect(check(lt(ZakatRule.longTermProxy25)), [DraftError.shareRequired]);
    expect(check(lt(ZakatRule.custom)), [DraftError.shareRequired]);
    expect(check(lt(ZakatRule.longTermDividendsOnly)), isEmpty);
    expect(check(lt(ZakatRule.longTermFullValue)), isEmpty);
    expect(check(lt(null, q2: CapitalBack.yes)), isEmpty);
  });

  test('plan fields: hidden types, schedule needed, % limits (AC-48)', () {
    expect(
      check(draft(AssetType.crypto, payout: Schedule.monthly)),
      contains(DraftError.planNotForType),
    );
    expect(check(draft(AssetType.crypto, check: Schedule.monthly)), isEmpty);
    expect(
      check(draft(AssetType.cashDeposit, check: Schedule.monthly, growth: '0')),
      isEmpty,
    );
    expect(check(draft(AssetType.sukuk, profit: '0.1')), [
      DraftError.profitNeedsSchedule,
    ]);
    expect(check(draft(AssetType.sukuk, growth: '0.1')), [
      DraftError.growthNeedsSchedule,
    ]);
    expect(
      check(draft(AssetType.sukuk, payout: Schedule.yearly, profit: '0')),
      [DraftError.profitNotPositive],
    );
    expect(
      check(draft(AssetType.sukuk, check: Schedule.yearly, growth: '-1')),
      [DraftError.growthTooLow],
    );
    expect(
      check(draft(AssetType.sukuk, check: Schedule.yearly, growth: '-0.99')),
      isEmpty,
    );
  });

  test('Q1 is required only with a %; the account kind only with a payout schedule (AC-64, AC-70)', () {
    final pe = draft(
      AssetType.privateEquity,
      intent: Intent.trading,
      q2: CapitalBack.no,
      payout: Schedule.quarterly,
      profit: '0.2',
    );
    expect(check(pe), [DraftError.answerProfitBasis]);
    expect(
      check(
        draft(
          AssetType.privateEquity,
          intent: Intent.trading,
          q2: CapitalBack.no,
          payout: Schedule.quarterly,
          profit: '0.2',
          q1: ProfitBasis.notSure,
        ),
      ),
      isEmpty,
    );
    expect(check(draft(AssetType.cashDeposit, payout: Schedule.monthly)), [
      DraftError.answerAccountKind,
    ]);
    expect(
      check(
        draft(
          AssetType.cashDeposit,
          payout: Schedule.monthly,
          account: AccountKind.islamic,
        ),
      ),
      isEmpty,
    );
    expect(check(draft(AssetType.cashDeposit)), isEmpty);
  });
}
