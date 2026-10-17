/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
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
}
