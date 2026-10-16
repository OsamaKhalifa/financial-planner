/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/money/format.dart';
import 'package:flutter_test/flutter_test.dart';

Decimal d(String s) => Decimal.parse(s);
String plain(String s) => s.replaceAll('\u2066', '').replaceAll('\u2069', '');

void main() {
  test('amounts are rounded half-up, grouped and keep full precision', () {
    expect(plain(formatAmount(d('1240500'), 'en')), '1,240,500.00');
    expect(plain(formatAmount(d('592.245'), 'en')), '592.25');
    expect(plain(formatAmount(d('0.004'), 'en')), '0.00');
    expect(
      plain(formatAmount(d('12345678901234567890.126'), 'en')),
      '12,345,678,901,234,567,890.13',
    );
  });

  test('signs: plus only when asked, a real minus sign, never -0.00', () {
    expect(plain(formatAmount(d('5'), 'en', signed: true)), '+5.00');
    expect(plain(formatAmount(d('-566.5'), 'en')), '−566.50');
    expect(plain(formatAmount(d('-0.001'), 'en', signed: true)), '0.00');
  });

  test('percent takes a fraction and always shows its sign', () {
    expect(plain(formatPercent(d('0.1550'), 'en')), '+15.50 %');
    expect(plain(formatPercent(d('-0.0375'), 'en')), '−3.75 %');
    expect(plain(formatPercent(d('0'), 'en')), '0.00 %');
  });

  test('grams', () {
    expect(plain(formatGrams(d('17.5'), 'en')), '17.50 g');
  });

  test('every number is isolated so it stays left-to-right inside Arabic', () {
    final s = formatPercent(d('0.15'), 'ar');
    expect(s.startsWith('\u2066'), isTrue);
    expect(s.endsWith('\u2069'), isTrue);
  });

  test('the language decides the separators; an unknown language falls back to English', () {
    expect(plain(formatAmount(d('1234.5'), 'de')), '1.234,50');
    expect(plain(formatAmount(d('1234.5'), 'xx')), '1,234.50');
  });
}
