/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:flutter_test/flutter_test.dart';

Decimal d(String s) => Decimal.parse(s);

void main() {
  test('gold: grams × karat ÷ 24', () {
    expect(
      pureGrams(type: AssetType.gold, gross: d('20'), karat: 21),
      d('17.5'),
    );
    expect(pureGrams(type: AssetType.gold, gross: d('12'), karat: 18), d('9'));
    expect(pureGrams(type: AssetType.gold, gross: d('10'), karat: 24), d('10'));
  });

  test('silver: grams × fineness ÷ 1000', () {
    expect(
      pureGrams(type: AssetType.silver, gross: d('100'), fineness: 925),
      d('92.5'),
    );
    expect(
      pureGrams(type: AssetType.silver, gross: d('100'), fineness: 999),
      d('99.9'),
    );
  });

  test('grossGrams is the inverse of pureGrams', () {
    expect(
      grossGrams(type: AssetType.gold, pure: d('17.5'), karat: 21),
      d('20'),
    );
    expect(
      grossGrams(type: AssetType.silver, pure: d('92.5'), fineness: 925),
      d('100'),
    );
  });

  Investment pe({ProfitBasis? q1, CapitalBack? q2, String? pct}) => Investment(
    name: 'p',
    type: AssetType.privateEquity,
    intent: Intent.longTerm,
    unit: const Unit('EGP'),
    startDate: day(2026, 1, 15),
    zakatRule: ZakatRule.longTermFullValue,
    expectedProfit: pct == null ? null : d(pct),
    payoutSchedule: pct == null ? null : Schedule.quarterly,
    profitBasis: q1,
    capitalBack: q2,
  );

  test('AC-64 private equity case table: Q2 first, Q1 only with a %', () {
    expect(pe(q2: CapitalBack.no).peCase, PeCase.a);
    expect(pe(q2: CapitalBack.yes).peCase, PeCase.c);
    expect(pe(q2: CapitalBack.notSure).peCase, PeCase.notSure);
    final withPct = {
      (ProfitBasis.shareOfProfit, CapitalBack.no): PeCase.a,
      (ProfitBasis.fixedPctOfMoney, CapitalBack.no): PeCase.b,
      (ProfitBasis.shareOfProfit, CapitalBack.yes): PeCase.c,
      (ProfitBasis.fixedPctOfMoney, CapitalBack.yes): PeCase.c,
      (ProfitBasis.notSure, CapitalBack.yes): PeCase.c,
      (ProfitBasis.notSure, CapitalBack.no): PeCase.notSure,
      (ProfitBasis.shareOfProfit, CapitalBack.notSure): PeCase.notSure,
      (ProfitBasis.fixedPctOfMoney, CapitalBack.notSure): PeCase.notSure,
    };
    for (final e in withPct.entries) {
      expect(
        pe(q1: e.key.$1, q2: e.key.$2, pct: '0.20').peCase,
        e.value,
        reason: '${e.key}',
      );
    }
  });

  test('AC-66 the Shariah risk tag is on for case B only and follows Q1', () {
    expect(
      pe(
        q1: ProfitBasis.fixedPctOfMoney,
        q2: CapitalBack.no,
        pct: '0.2',
      ).shariahRisk,
      isTrue,
    );
    expect(
      pe(
        q1: ProfitBasis.shareOfProfit,
        q2: CapitalBack.no,
        pct: '0.2',
      ).shariahRisk,
      isFalse,
    );
    expect(
      pe(q1: ProfitBasis.notSure, q2: CapitalBack.no, pct: '0.2').shariahRisk,
      isFalse,
    );
    expect(
      pe(
        q1: ProfitBasis.fixedPctOfMoney,
        q2: CapitalBack.yes,
        pct: '0.2',
      ).shariahRisk,
      isFalse,
    );
  });

  test('only private equity has a case', () {
    final fund = Investment(
      name: 'f',
      type: AssetType.fund,
      unit: const Unit('EGP'),
      startDate: day(2026, 1, 1),
      zakatRule: ZakatRule.trading100,
      capitalBack: CapitalBack.yes,
    );
    expect(fund.peCase, isNull);
    expect(fund.shariahRisk, isFalse);
  });

  test('withRule keeps every plan field', () {
    final i = pe(q1: ProfitBasis.shareOfProfit, q2: CapitalBack.no, pct: '0.2');
    final w = i.withRule(ZakatRule.custom, day(2026, 2, 1));
    expect(w.payoutSchedule, Schedule.quarterly);
    expect(w.expectedProfit, d('0.2'));
    expect(w.profitBasis, ProfitBasis.shareOfProfit);
    expect(w.capitalBack, CapitalBack.no);
  });
}
