/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('v1 units: 32 currencies plus two metals, sorted by code', () {
    expect(v1Currencies.length, 32);
    expect(allUnits.length, 34);
    final codes = allUnits.map((u) => u.code).toList();
    expect(codes, [...codes]..sort());
    expect(
      v1Currencies,
      containsAll([const Unit('SEK'), const Unit('NOK'), const Unit('DKK')]),
    );
  });

  test('metals are flagged and have no default country', () {
    expect(xauG.isMetal, isTrue);
    expect(const Unit('USD').isMetal, isFalse);
    expect(() => defaultCountryOf(xauG), throwsArgumentError);
  });

  test('every currency maps to a shipped-inflation country', () {
    for (final u in v1Currencies) {
      expect(v1Countries, contains(defaultCountryOf(u)), reason: u.code);
    }
    expect(defaultCountryOf(const Unit('EUR')), const Country('EMU'));
  });

  test('every market country is a shipped-inflation country', () {
    for (final m in Market.values.where((m) => m != Market.other)) {
      expect(v1Countries, contains(m.country), reason: m.name);
      expect(v1Currencies, contains(m.currency), reason: m.name);
    }
  });

  test('a unit used only by the anchor is not repeated', () {
    final list = orderedUnits(
      usage: {const Unit('EGP'): 5},
      topAnchor: const Unit('EGP'),
    );
    expect(list.where((u) => u == const Unit('EGP')).length, 1);
    expect(list.first, const Unit('EGP'));
  });
}
