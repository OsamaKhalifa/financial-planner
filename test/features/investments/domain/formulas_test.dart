/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/domain/formulas.dart';
import 'package:flutter_test/flutter_test.dart';

Decimal d(String s) => Decimal.parse(s);

void expectNear(Decimal? actual, String expected) {
  expect(actual, isNotNull);
  expect(
    (actual! - d(expected)).abs() < d('0.005'),
    isTrue,
    reason: '$actual vs $expected',
  );
}

void main() {
  test('modifiedDietz keeps each flow with its weight', () {
    final dz = modifiedDietz(
      bv: d('10000'),
      ev: d('14500'),
      flows: [Flow(date: day(2026, 4, 16), amount: d('4000'))],
      s: day(2026, 3, 31),
      e: day(2026, 4, 30),
    );
    expect(dz.flows.single.weight.toStringAsFixed(4), '0.4667');
    expectNear(dz.cf, '4000');
  });

  test('a negative D gives no return', () {
    final dz = modifiedDietz(
      bv: d('0'),
      ev: d('50'),
      flows: [Flow(date: day(2026, 4, 30), amount: d('-100'))],
      s: day(2026, 3, 31),
      e: day(2026, 4, 30),
    );
    expect(dz.r, isNull);
  });

  test('a period of zero days has no weights and D = BV', () {
    final dz = modifiedDietz(
      bv: d('10'),
      ev: d('11'),
      flows: const [],
      s: day(2026, 4, 30),
      e: day(2026, 4, 30),
    );
    expectNear(dz.r, '0.1');
  });

  test('setAside: dividends are charged without the T/Y factor, solar is a matched pair', () {
    expectNear(
      setAside(
        year: ZakatYear.solar,
        share: d('1'),
        ev: d('23000'),
        days: 365,
        dividends: d('0'),
      ),
      '592.71',
    );
    expectNear(
      setAside(
        year: ZakatYear.lunar,
        share: d('0'),
        ev: d('50000'),
        days: 30,
        dividends: d('400'),
      ),
      '10',
    );
  });

  test('annualised needs 365 days and positive growth', () {
    expect(annualised(d('0.1'), 364), isNull);
    expect(annualised(d('-1'), 400), isNull);
    expectNear(annualised(d('0.21'), 730), '0.1');
  });

  test('real return is (1 + r) / (1 + i) - 1', () {
    expectNear(real(d('0.15'), d('0.10')), '0.04545');
  });

  test('purchasingPower with no zakat: needed end = BV + CF + i x D', () {
    final dz = modifiedDietz(
      bv: d('1000'),
      ev: d('1100'),
      flows: const [],
      s: day(2025, 12, 31),
      e: day(2026, 12, 31),
    );
    final pp = purchasingPower(dz, d('0'), d('0.1'))!;
    expectNear(pp.neededEnd, '1100');
    expectNear(pp.neededReturn, '0.1');
    expect(pp.kept, isTrue);
  });

  test('AC-49 expectedPayout: 100,000 × 20 % × 3/12 = 5,000.00; 10,000 × 10 % / 12 = 83.33', () {
    expect(
      expectedPayout(capital: d('100000'), rate: d('0.20'), months: 3),
      d('5000.00'),
    );
    expect(
      expectedPayout(capital: d('10000'), rate: d('0.10'), months: 1),
      d('83.33'),
    );
  });

  test(
    'AC-48/60 expectedValue compounds by days ÷ 365 and is never below 0',
    () {
      final start = Flow(date: day(2026, 1, 1), amount: d('10000'));
      expect(
        expectedValue(flows: [start], growth: d('-0.10'), on: day(2027, 1, 1)),
        d('9000.00'),
      );
      expect(
        expectedValue(flows: [start], growth: d('0.12'), on: day(2027, 1, 1)),
        d('11200.00'),
      );
      final flows = [
        start,
        Flow(date: day(2026, 4, 1), amount: d('2000')),
        Flow(date: day(2026, 8, 15), amount: d('-3000')),
      ];
      expect(
        expectedValue(flows: flows, growth: d('0.12'), on: day(2026, 7, 1)),
        d('12635.39'),
      );
      expect(
        expectedValue(flows: flows, growth: d('0.12'), on: day(2026, 9, 28)),
        d('9948.16'),
      );
      expect(
        expectedValue(
          flows: [
            start,
            Flow(date: day(2026, 2, 1), amount: d('-20000')),
          ],
          growth: Decimal.zero,
          on: day(2026, 3, 1),
        ),
        Decimal.zero,
      );
    },
  );
}
