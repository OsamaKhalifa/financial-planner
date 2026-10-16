/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/dates.dart';
import '../../../core/money/decimal_math.dart';

final class Flow {
  const Flow({required this.date, required this.amount});

  /// Positive = money in, negative = money out; one unit.
  final DateTime date;
  final Decimal amount;
}

final class WeightedFlow {
  const WeightedFlow(this.flow, this.weight);

  final Flow flow;

  /// W = (E − t) / T
  final Decimal weight;
}

final class DietzResult {
  const DietzResult({
    required this.bv,
    required this.ev,
    required this.cf,
    required this.d,
    required this.r,
    this.flows = const [],
  });

  final Decimal bv;
  final Decimal ev;
  final Decimal cf;
  final Decimal d;

  /// Null when D <= 0: "not available" (AC-41).
  final Decimal? r;
  final List<WeightedFlow> flows;
}

DietzResult modifiedDietz({
  required Decimal bv,
  required Decimal ev,
  required List<Flow> flows,
  required DateTime s,
  required DateTime e,
}) {
  final t = Decimal.fromInt(daysBetween(s, e));
  final weighted = [
    for (final f in flows)
      WeightedFlow(
        f,
        t == Decimal.zero
            ? Decimal.zero
            : divide(Decimal.fromInt(daysBetween(f.date, e)), t),
      ),
  ];
  final cf = sumOf(flows.map((f) => f.amount));
  final d = bv + sumOf(weighted.map((w) => w.weight * w.flow.amount));
  return DietzResult(
    bv: bv,
    ev: ev,
    cf: cf,
    d: d,
    r: d <= Decimal.zero ? null : divide(ev - bv - cf, d),
    flows: weighted,
  );
}

/// r × s × EV × days / Y + r × dividends. [dividends] is the sum of income
/// that is charged once, on its own date, without the T/Y factor (§9.4).
Decimal setAside({
  required ZakatYear year,
  required Decimal share,
  required Decimal ev,
  required int days,
  required Decimal dividends,
}) {
  final onValue = divide(
    year.r * share * ev * Decimal.fromInt(days),
    year.days,
  );
  return onValue + year.r * dividends;
}

Decimal? afterSetAsideReturn(DietzResult dz, Decimal z) =>
    dz.d <= Decimal.zero ? null : divide(dz.ev - dz.bv - dz.cf - z, dz.d);

Decimal real(Decimal r, Decimal i) =>
    divide(Decimal.one + r, Decimal.one + i) - Decimal.one;

Decimal? annualised(Decimal r, int days) {
  final growth = Decimal.one + r;
  if (days < 365 || growth <= Decimal.zero) return null;
  return powRatio(growth, divide(Decimal.fromInt(365), Decimal.fromInt(days))) -
      Decimal.one;
}

final class PurchasingPower {
  const PurchasingPower({
    required this.neededEnd,
    required this.neededReturn,
    required this.gap,
    required this.kept,
  });

  final Decimal neededEnd;
  final Decimal? neededReturn;
  final Decimal gap;
  final bool kept;
}

PurchasingPower? purchasingPower(DietzResult dz, Decimal z, Decimal i) {
  if (dz.d <= Decimal.zero) return null;
  final target = dz.bv + dz.cf + i * dz.d;
  final q = dz.ev == Decimal.zero ? Decimal.zero : divide(z, dz.ev);
  final neededEnd = divide(target, Decimal.one - q);
  final gap = dz.ev - z - target;
  return PurchasingPower(
    neededEnd: neededEnd,
    neededReturn: divide(neededEnd - dz.bv - dz.cf, dz.d),
    gap: gap,
    kept: gap >= Decimal.zero,
  );
}
