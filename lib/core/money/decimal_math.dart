/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:math' as math;

import 'package:decimal/decimal.dart';

Decimal divide(Decimal a, Decimal b) =>
    (a / b).toDecimal(scaleOnInfinitePrecision: 20);

Decimal sumOf(Iterable<Decimal> values) =>
    values.fold(Decimal.zero, (a, b) => a + b);

/// The only floating-point code in lib/: `decimal` has integer powers only.
/// Inputs and output are growth factors, never amounts of money.
Decimal powRatio(Decimal base, Decimal exponent) {
  final result = math.pow(base.toDouble(), exponent.toDouble()).toDouble();
  return Decimal.parse(result.toStringAsPrecision(15));
}
