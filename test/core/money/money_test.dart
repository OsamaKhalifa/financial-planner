/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('money is equal by amount and unit, with numeric decimal equality', () {
    expect(
      Money(Decimal.parse('1.0'), const Unit('USD')),
      Money(Decimal.parse('1.00'), const Unit('USD')),
    );
    expect(
      Money(Decimal.one, const Unit('USD')),
      isNot(Money(Decimal.one, const Unit('EGP'))),
    );
  });
}
