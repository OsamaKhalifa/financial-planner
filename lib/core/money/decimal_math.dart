/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:math' as math;

import 'package:decimal/decimal.dart';

const _scale = 20;
final _ten = BigInt.from(10);

/// a / b truncated toward zero at 20 decimals. Done on BigInts: the Rational
/// route (`a / b`) normalises with a gcd on every call, which dominated the
/// engine's time.
Decimal divide(Decimal a, Decimal b) {
  final an = a.shift(a.scale).toBigInt();
  final bn = b.shift(b.scale).toBigInt();
  final q = (an * _ten.pow(_scale + b.scale)) ~/ (bn * _ten.pow(a.scale));
  return Decimal.fromBigInt(q).shift(-_scale);
}

Decimal sumOf(Iterable<Decimal> values) =>
    values.fold(Decimal.zero, (a, b) => a + b);

/// The only floating-point code in lib/: `decimal` has integer powers only.
/// Inputs and output are growth factors, never amounts of money.
Decimal powRatio(Decimal base, Decimal exponent) {
  final result = math.pow(base.toDouble(), exponent.toDouble()).toDouble();
  return Decimal.parse(result.toStringAsPrecision(15));
}

/// A 0..1 fraction for drawing a bar; never used for money.
double progressOf(Decimal fraction) => fraction.toDouble().clamp(0, 1);

/// A chart coordinate; for drawing only, never money math. Tooltips and labels
/// read the Decimal kept next to each point.
double toChart(Decimal value) => value.toDouble();
