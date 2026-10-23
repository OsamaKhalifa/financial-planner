/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('today drops the time of day and builds a UTC midnight', () {
    expect(today(() => DateTime(2026, 10, 16, 23, 59)), day(2026, 10, 16));
    expect(today(() => DateTime(2026, 10, 16)).isUtc, isTrue);
  });

  test('daysBetween does not shift over a daylight-saving change', () {
    expect(daysBetween(day(2026, 3, 1), day(2026, 4, 1)), 31);
  });

  test('month and year bounds', () {
    expect(endOfMonth(day(2026, 2, 10)), day(2026, 2, 28));
    expect(endOfMonth(day(2028, 2, 10)), day(2028, 2, 29));
    expect(endOfYear(day(2026, 5, 5)), day(2026, 12, 31));
    expect(daysInYear(2028), 366);
    expect(daysInYear(2026), 365);
  });

  test('AC-50 addMonths keeps the day or takes the last day of the month', () {
    expect(
      [for (var k = 1; k <= 3; k++) addMonths(day(2026, 1, 31), k)],
      [day(2026, 2, 28), day(2026, 3, 31), day(2026, 4, 30)],
    );
    expect(
      [for (var k = 1; k <= 4; k++) addMonths(day(2024, 2, 29), 12 * k)],
      [day(2025, 2, 28), day(2026, 2, 28), day(2027, 2, 28), day(2028, 2, 29)],
    );
    expect(addMonths(day(2026, 11, 15), 3), day(2027, 2, 15));
  });
}
