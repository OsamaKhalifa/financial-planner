/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:hijri/hijri_calendar.dart';

DateTime day(int year, int month, int dayOfMonth) =>
    DateTime.utc(year, month, dayOfMonth);

DateTime today(DateTime Function() clock) {
  final now = clock();
  return DateTime.utc(now.year, now.month, now.day);
}

int daysBetween(DateTime from, DateTime to) => to.difference(from).inDays;

DateTime endOfMonth(DateTime d) => DateTime.utc(d.year, d.month + 1, 0);

DateTime endOfYear(DateTime d) => DateTime.utc(d.year, 12, 31);

int daysInYear(int year) =>
    daysBetween(day(year - 1, 12, 31), day(year, 12, 31));

DateTime earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

DateTime later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

/// Same day [months] later, or that month's last day; always counted from
/// [start], never chained (story §5.6 dates, AC-50).
DateTime addMonths(DateTime start, int months) {
  final last = DateTime.utc(start.year, start.month + months + 1, 0);
  return start.day > last.day
      ? last
      : DateTime.utc(start.year, start.month + months, start.day);
}

/// Umm al-Qura (ADR-0007). The package covers 1356-1500 AH and throws
/// [ArgumentError] outside it; a date it cannot convert is null.
DateTime? hijriToDate(int y, int m, int d) {
  try {
    final g = HijriCalendar().hijriToGregorian(y, m, d);
    return DateTime.utc(g.year, g.month, g.day);
  } on ArgumentError {
    return null;
  }
}

int? hijriMonthLength(int y, int m) {
  try {
    return HijriCalendar().getDaysInMonth(y, m);
  } on ArgumentError {
    return null;
  }
}

({int y, int m, int d}) hijriOf(DateTime date) {
  final h = HijriCalendar.fromDate(DateTime(date.year, date.month, date.day));
  return (y: h.hYear, m: h.hMonth, d: h.hDay);
}
