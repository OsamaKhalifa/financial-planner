/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../reference/units.dart';

final class Money {
  const Money(this.amount, this.unit);

  final Decimal amount;
  final Unit unit;

  @override
  bool operator ==(Object other) =>
      other is Money && other.amount == amount && other.unit == unit;

  @override
  int get hashCode => Object.hash(amount, unit);

  @override
  String toString() => '$amount ${unit.code}';
}
