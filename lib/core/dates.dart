/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

DateTime day(int year, int month, int dayOfMonth) =>
    DateTime.utc(year, month, dayOfMonth);

DateTime today(DateTime Function() clock) {
  final now = clock();
  return DateTime.utc(now.year, now.month, now.day);
}

int daysBetween(DateTime from, DateTime to) => to.difference(from).inDays;

DateTime endOfMonth(DateTime d) => DateTime.utc(d.year, d.month + 1, 0);

DateTime endOfYear(DateTime d) => DateTime.utc(d.year, 12, 31);

int daysInYear(int year) => daysBetween(day(year - 1, 12, 31), day(year, 12, 31));

DateTime earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

DateTime later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
