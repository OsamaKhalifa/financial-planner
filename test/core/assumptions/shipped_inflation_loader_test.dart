/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/shipped_inflation_loader.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AC-32: the shipped asset shows its source and "as of" year', () async {
    final shipped = await loadShippedInflation(rootBundle);
    expect(shipped.source, contains('World Bank'));
    expect(shipped.source, contains('CC BY 4.0'));
    expect(shipped.asOfNote, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(shipped.lastYear(const Country('EGY')), greaterThanOrEqualTo(2025));
  });

  test(
    'every country of the v1 units and markets has a series from 2000 or later',
    () async {
      final shipped = await loadShippedInflation(rootBundle);
      for (final c in v1Countries) {
        final years = shipped.series[c]?.keys.toList() ?? const <int>[];
        expect(years, isNotEmpty, reason: c.iso3);
        expect(years.every((y) => y >= 2000), isTrue, reason: c.iso3);
      }
      expect(shipped.series.keys.toSet(), v1Countries.toSet());
    },
  );

  test('values are fractions, not percent', () async {
    final shipped = await loadShippedInflation(rootBundle);
    final egypt2025 = shipped.series[const Country('EGY')]![2025]!;
    expect(
      egypt2025 > Decimal.parse('0.01') && egypt2025 < Decimal.parse('0.6'),
      isTrue,
    );
    for (final s in shipped.series.values) {
      for (final v in s.values) {
        expect(v.abs() < Decimal.parse('3'), isTrue, reason: '$v');
      }
    }
  });

  test('a user override still wins over the freshly loaded asset', () async {
    final shipped = await loadShippedInflation(rootBundle);
    const egy = Country('EGY');
    final book = InflationBook(shipped, [
      InflationOverride(country: egy, year: 2025, rate: Decimal.parse('0.30')),
    ]);
    expect(book.forYear(egy, 2025)!.rate, Decimal.parse('0.30'));
    expect(book.forYear(egy, 2025)!.provenance, InflationProvenance.user);
    expect(
      InflationBook(shipped, const []).forYear(egy, 2025)!.provenance,
      InflationProvenance.shipped,
    );
  });
}
