/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/db/converters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const decimals = DecimalConverter();

  test('a Decimal survives text storage at 20 decimals and beyond', () {
    for (final s in [
      '0.12345678901234567890',
      '-0.00000000000000000001',
      '123456789012345678901234567890.12345678901234567890',
      '1000',
      '0',
    ]) {
      final d = Decimal.parse(s);
      expect(decimals.fromSql(decimals.toSql(d)), d, reason: s);
    }
  });

  test(
    'a Decimal column round-trips through SQLite without becoming REAL',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final value = Decimal.parse('1.10');
      await db
          .into(db.rates)
          .insert(
            RatesCompanion.insert(
              id: 'r',
              fromUnit: 'USD',
              toUnit: 'EGP',
              rate: value * Decimal.fromInt(3),
              asOf: DateTime.utc(2026, 1, 2),
              source: 'typed',
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
            ),
          );
      final raw = await db
          .customSelect('SELECT rate, as_of, typeof(rate) t FROM rates')
          .getSingle();
      expect(raw.read<String>('t'), 'text');
      expect(raw.read<String>('rate'), '3.3');
      expect(raw.read<String>('as_of'), '2026-01-02');
      final row = await db.select(db.rates).getSingle();
      expect(row.rate, Decimal.parse('3.3'));
      expect(row.asOf, DateTime.utc(2026, 1, 2));
    },
  );

  test('calendar dates are written as yyyy-MM-dd and read as UTC midnight', () {
    const dates = CalendarDateConverter();
    expect(dates.toSql(DateTime.utc(2026, 3, 5)), '2026-03-05');
    expect(dates.fromSql('2026-03-05'), DateTime.utc(2026, 3, 5));
    expect(dates.fromSql('2026-03-05').isUtc, isTrue);
  });
}
