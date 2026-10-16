/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import '../../../core/dates.dart';

enum Granularity { month, year }

/// A period runs from the end of day [s] to the end of day [e] (story §9.1).
final class Period {
  const Period({required this.s, required this.e});

  /// Calendar month; the current one ends today (D10, "so far").
  factory Period.month(int year, int month, DateTime today) => Period(
        s: DateTime.utc(year, month, 0),
        e: earlier(DateTime.utc(year, month + 1, 0), today),
      );

  factory Period.year(int year, DateTime today) => Period(
        s: day(year - 1, 12, 31),
        e: earlier(day(year, 12, 31), today),
      );

  final DateTime s;
  final DateTime e;

  int get days => daysBetween(s, e);

  @override
  bool operator ==(Object other) =>
      other is Period && other.s == s && other.e == e;

  @override
  int get hashCode => Object.hash(s, e);
}

/// Oldest first, from the period holding [first] to the one holding [today].
List<Period> periodsBetween(
  DateTime first,
  DateTime today,
  Granularity granularity,
) {
  switch (granularity) {
    case Granularity.year:
      return [
        for (var y = first.year; y <= today.year; y++) Period.year(y, today),
      ];
    case Granularity.month:
      final result = <Period>[];
      var y = first.year;
      var m = first.month;
      while (y < today.year || (y == today.year && m <= today.month)) {
        result.add(Period.month(y, m, today));
        m++;
        if (m > 12) {
          m = 1;
          y++;
        }
      }
      return result;
  }
}
