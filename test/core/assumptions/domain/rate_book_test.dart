/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:flutter_test/flutter_test.dart';

const usd = Unit('USD');
const egp = Unit('EGP');
const eur = Unit('EUR');

Decimal d(String s) => Decimal.parse(s);

Rate rate(Unit a, Unit b, String r, DateTime on,
        {RateSource source = RateSource.typed}) =>
    Rate(from: a, to: b, rate: d(r), asOf: on, source: source);

void main() {
  test('same unit converts 1:1 without any rate', () {
    final m = RateBook(const []).convert(Money(d('5'), usd), usd, day(2026, 1, 1));
    expect(m, Money(d('5'), usd));
  });

  test('uses the latest rate on or before the date, never a later one', () {
    final book = RateBook([
      rate(usd, egp, '50', day(2026, 1, 1)),
      rate(usd, egp, '55', day(2026, 6, 1)),
    ]);
    expect(book.quote(usd, egp, day(2026, 5, 31))!.rate, d('50'));
    expect(book.quote(usd, egp, day(2026, 6, 1))!.rate, d('55'));
    expect(book.quote(usd, egp, day(2025, 12, 31)), isNull);
  });

  test('same date: direct beats inverse, a later inverse beats an older direct', () {
    final same = RateBook([
      rate(egp, usd, '0.04', day(2026, 1, 1)),
      rate(usd, egp, '50', day(2026, 1, 1)),
    ]);
    final q = same.quote(usd, egp, day(2026, 1, 1))!;
    expect(q.rate, d('50'));
    expect(q.inverted, isFalse);

    final newerInverse = RateBook([
      rate(usd, egp, '50', day(2026, 1, 1)),
      rate(egp, usd, '0.02', day(2026, 2, 1)),
    ]);
    expect(newerInverse.quote(usd, egp, day(2026, 3, 1))!.inverted, isTrue);
  });

  test('a fetched rate wins only when it is newer than the typed one', () {
    final book = RateBook([
      rate(usd, egp, '49', day(2026, 10, 14)),
      rate(usd, egp, '48.5', day(2026, 10, 15), source: RateSource.currencyApi),
    ]);
    expect(book.quote(usd, egp, day(2026, 10, 15))!.rate, d('48.5'));
  });

  test('no chaining through a third unit', () {
    final book = RateBook([
      rate(usd, eur, '0.9', day(2026, 1, 1)),
      rate(eur, egp, '55', day(2026, 1, 1)),
    ]);
    expect(book.convert(Money(d('1'), usd), egp, day(2026, 1, 1)), isNull);
  });
}
