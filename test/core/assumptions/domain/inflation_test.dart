/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:flutter_test/flutter_test.dart';

const egy = Country('EGY');
const usa = Country('USA');

Decimal d(String s) => Decimal.parse(s);

void main() {
  test('parse turns the ADR-0004 percent strings into fractions', () {
    final s = ShippedInflation.parse('''
{"source":"World Bank","sourceLastUpdated":"2026-10-08","generatedOn":"2026-10-16",
 "series":{"EGY":{"2024":"28.27","2025":"14.07"},"USA":{"2024":"2.95"}}}''');
    expect(s.source, 'World Bank');
    expect(s.asOfNote, '2026-10-08');
    expect(s.series[egy]![2025], d('0.1407'));
    expect(s.lastYear(egy), 2025);
    expect(s.lastYear(usa), 2024);
    expect(s.lastYear(const Country('SAU')), isNull);
  });

  test('a year before all data has no rate', () {
    final book = InflationBook(
      ShippedInflation(series: {egy: {2025: d('0.25')}}),
      const [],
    );
    expect(book.forYear(egy, 2024), isNull);
  });

  test('assumed years follow a user override when that is the latest', () {
    final book = InflationBook(
      ShippedInflation(series: {egy: {2024: d('0.2')}}),
      [InflationOverride(country: egy, year: 2025, rate: d('0.3'))],
    );
    final y = book.forYear(egy, 2026)!;
    expect(y.rate, d('0.3'));
    expect(y.assumedFrom, 2025);
  });

  test('a period inside one year uses only that year, d / D of it', () {
    final book = InflationBook(
      ShippedInflation(series: {egy: {2026: d('0.10')}}),
      const [],
    );
    final p = book.forPeriod(egy, day(2025, 12, 31), day(2026, 12, 31))!;
    expect((p.i - d('0.10')).abs() < d('0.0000001'), isTrue);
    expect(p.years.length, 1);
  });

  test('a period touching a year with no data is unavailable', () {
    final book = InflationBook(
      ShippedInflation(series: {egy: {2026: d('0.10')}}),
      const [],
    );
    expect(book.forPeriod(egy, day(2025, 11, 30), day(2026, 1, 31)), isNull);
  });
}
