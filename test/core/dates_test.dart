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
}
