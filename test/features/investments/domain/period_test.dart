/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/domain/period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = day(2026, 10, 16);

  test('a month runs from the last day of the month before', () {
    final p = Period.month(2026, 4, today);
    expect(p.s, day(2026, 3, 31));
    expect(p.e, day(2026, 4, 30));
    expect(p.days, 30);
    expect(Period.month(2026, 1, today).s, day(2025, 12, 31));
  });

  test('the current month and year end today', () {
    expect(Period.month(2026, 10, today).e, today);
    expect(Period.year(2026, today).e, today);
    expect(Period.year(2025, today).e, day(2025, 12, 31));
  });

  test('periodsBetween is oldest first and includes the current one', () {
    final months = periodsBetween(day(2025, 11, 20), today, Granularity.month);
    expect(months.length, 12);
    expect(months.first, Period.month(2025, 11, today));
    expect(months.last, Period.month(2026, 10, today));
    expect(periodsBetween(day(2024, 5, 1), today, Granularity.year).length, 3);
  });
}
