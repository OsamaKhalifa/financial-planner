/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/money/decimal_math.dart';
import 'package:flutter_test/flutter_test.dart';

Decimal d(String s) => Decimal.parse(s);

void main() {
  test('divide keeps 20 decimals', () {
    expect(divide(d('1'), d('3')), d('0.33333333333333333333'));
    expect(divide(d('1'), d('8')), d('0.125'));
  });

  test('divide truncates toward zero and handles signs and mixed scales', () {
    expect(divide(d('-2'), d('3')), d('-0.66666666666666666666'));
    expect(divide(d('2'), d('-3')), d('-0.66666666666666666666'));
    expect(divide(d('10.50'), d('0.5')), d('21'));
    expect(divide(d('0'), d('7')), Decimal.zero);
    expect(divide(d('100'), d('354.367')).scale, 20);
    expect(divide(d('1000'), d('4000')), d('0.25'));
  });

  test('divide by zero throws instead of returning infinity', () {
    expect(() => divide(d('1'), d('0')), throwsA(anything));
  });

  test('powRatio matches the story figures', () {
    expect(powRatio(d('1.10'), d('1')), d('1.1'));
    final i = powRatio(d('1.10'), divide(d('30'), d('365'))) - d('1');
    expect((i - d('0.00786')).abs() < d('0.00001'), isTrue);
  });

  test('sumOf of nothing is zero', () {
    expect(sumOf(const []), Decimal.zero);
  });
}
