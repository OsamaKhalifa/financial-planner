/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../money/decimal_math.dart';
import '../../money/money.dart';
import '../../reference/units.dart';
import 'rate.dart';

final class RateQuote {
  const RateQuote({
    required this.rate,
    required this.asOf,
    required this.source,
    required this.inverted,
  });

  /// Effective rate for the asked direction (already inverted when [inverted]).
  final Decimal rate;
  final DateTime asOf;
  final RateSource source;
  final bool inverted;
}

final class RateBook {
  RateBook(List<Rate> rates) : _rates = List.unmodifiable(rates);

  final List<Rate> _rates;

  /// Latest rate dated on or before [on], direct or inverse. No chaining
  /// through a third unit (story Q6). Same date: typed beats fetched, direct
  /// beats inverse (AC-23, AC-28).
  RateQuote? quote(Unit from, Unit to, DateTime on) {
    if (from == to) {
      return RateQuote(
        rate: Decimal.one,
        asOf: on,
        source: RateSource.typed,
        inverted: false,
      );
    }
    RateQuote? best;
    for (final r in _rates) {
      final direct = r.from == from && r.to == to;
      final inverse = r.from == to && r.to == from;
      if (!(direct || inverse) || r.asOf.isAfter(on)) continue;
      final candidate = RateQuote(
        rate: direct ? r.rate : divide(Decimal.one, r.rate),
        asOf: r.asOf,
        source: r.source,
        inverted: inverse,
      );
      if (best == null || _beats(candidate, best)) best = candidate;
    }
    return best;
  }

  /// Null means the rate is missing; callers must not fall back to 1:1.
  Money? convert(Money m, Unit to, DateTime on) {
    final q = quote(m.unit, to, on);
    return q == null ? null : Money(m.amount * q.rate, to);
  }

  static bool _beats(RateQuote a, RateQuote b) {
    if (a.asOf != b.asOf) return a.asOf.isAfter(b.asOf);
    if (a.source != b.source) return a.source == RateSource.typed;
    return !a.inverted && b.inverted;
  }
}
