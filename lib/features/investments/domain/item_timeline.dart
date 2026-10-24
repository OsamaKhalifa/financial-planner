/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/units.dart';
import 'formulas.dart';
import 'history_entry.dart';
import 'investment.dart';

/// A conversion that has no rate on or before [date]; never treated as 1:1.
final class MissingRate {
  const MissingRate(this.from, this.to, this.date);

  final Unit from;
  final Unit to;
  final DateTime date;
}

/// One item's history replayed in its own unit (story §5.4, §9). Amounts in
/// other units are converted at the entry's date.
final class ItemTimeline {
  ItemTimeline(this.aggregate, RateBook rates)
    : _entries = aggregate.history.where((e) => e is! PlanSkip).toList()
        ..sort(_byDate),
      _incomeIsPurify = aggregate.investment.peCase == PeCase.c {
    for (final e in _entries) {
      final m = switch (e) {
        MoneyIn(:final amount) => amount,
        MoneyOut(:final amount) => amount,
        InterestRecord(:final amount) => amount,
        ValueUpdate() || PlanSkip() => null,
      };
      if (m == null) continue;
      final c = rates.convert(m, unit, e.date);
      if (c == null) {
        missing.add(MissingRate(m.unit, unit, e.date));
      } else {
        _amount[e.id] = c.amount;
      }
    }
    _replay();
  }

  final InvestmentWithHistory aggregate;
  final List<MissingRate> missing = [];
  final List<HistoryEntry> _entries;

  /// Case C: every income payout is "to purify", never return (P-4, E5).
  final bool _incomeIsPurify;
  final Map<String, Decimal> _amount = {};
  final List<(DateTime, Decimal)> _values = [];
  final List<(DateTime, Decimal)> _held = [];

  Investment get investment => aggregate.investment;
  Unit get unit => investment.unit;

  static int _byDate(HistoryEntry a, HistoryEntry b) {
    final c = a.date.compareTo(b.date);
    return c != 0 ? c : a.createdAt.compareTo(b.createdAt);
  }

  void _replay() {
    var value = Decimal.zero;
    var held = Decimal.zero;
    var i = 0;
    while (i < _entries.length) {
      final date = _entries[i].date;
      Decimal? update;
      var delta = Decimal.zero;
      var heldDelta = Decimal.zero;
      for (; i < _entries.length && _entries[i].date == date; i++) {
        final e = _entries[i];
        final amount = _amount[e.id];
        switch (e) {
          case ValueUpdate(:final value):
            update = value;
          case MoneyIn() when amount != null:
            delta += amount;
          // Income is paid from profit; only a sale takes value out (Q12).
          case MoneyOut(kind: MoneyOutKind.sale) when amount != null:
            delta -= amount;
          case InterestRecord(:final kind) when amount != null:
            if (kind == InterestKind.keptInside) {
              delta += amount;
              heldDelta += amount;
            } else if (kind == InterestKind.givenAwayFromInside) {
              delta -= amount;
              heldDelta -= amount;
            }
          default:
        }
      }
      value = update ?? value + delta;
      held += heldDelta;
      _values.add((date, value));
      _held.add((date, held));
    }
  }

  /// Value of the last checkpoint on or before [d] (binary search).
  static Decimal _at(List<(DateTime, Decimal)> points, DateTime d) {
    var lo = 0;
    var hi = points.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (points[mid].$1.isAfter(d)) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }
    return lo == 0 ? Decimal.zero : points[lo - 1].$2;
  }

  Decimal recordedValueAt(DateTime d) => _at(_values, d);

  /// H: interest kept inside the item, less what was given away from inside.
  Decimal heldInterestAt(DateTime d) => _at(_held, d);

  Decimal netValueAt(DateTime d) => recordedValueAt(d) - heldInterestAt(d);

  /// Entries dated after [s] up to and including [e]; [_entries] is sorted.
  Iterable<HistoryEntry> _entriesIn(DateTime s, DateTime e) sync* {
    for (final x in _entries) {
      if (x.date.isAfter(e)) return;
      if (x.date.isAfter(s)) yield x;
    }
  }

  bool _isPurifyIncome(HistoryEntry x) =>
      _incomeIsPurify && x is MoneyOut && x.kind == MoneyOutKind.income;

  /// Amount in the item unit; null for a value update or a missing rate.
  Decimal? inItemUnit(HistoryEntry e) => _amount[e.id];

  /// Money in (+) and money out (−) dated after [s] up to [e]; never interest.
  List<Flow> flowsIn(DateTime s, DateTime e) => [
    for (final x in _entriesIn(s, e))
      if (_amount[x.id] != null && !_isPurifyIncome(x))
        switch (x) {
          MoneyIn() => Flow(date: x.date, amount: _amount[x.id]!),
          MoneyOut() => Flow(date: x.date, amount: -_amount[x.id]!),
          _ => null,
        },
  ].nonNulls.toList();

  /// Income received in hand, as positive amounts.
  List<Flow> incomeFlows(DateTime s, DateTime e) => [
    for (final x in _entriesIn(s, e))
      if (x is MoneyOut &&
          x.kind == MoneyOutKind.income &&
          !_incomeIsPurify &&
          _amount[x.id] != null)
        Flow(date: x.date, amount: _amount[x.id]!),
  ];

  Decimal incomeIn(DateTime s, DateTime e) =>
      sumOf(incomeFlows(s, e).map((f) => f.amount));

  /// All interest received less all given away, from both places (AC-19);
  /// on a case C item also every income payout (AC-65).
  Money toPurifyAt(DateTime d) {
    var total = Decimal.zero;
    for (final x in _entries) {
      final amount = _amount[x.id];
      if (amount == null || x.date.isAfter(d)) continue;
      if (_isPurifyIncome(x)) total += amount;
      if (x is! InterestRecord) continue;
      total += switch (x.kind) {
        InterestKind.keptInside || InterestKind.paidOut => amount,
        _ => -amount,
      };
    }
    return Money(total, unit);
  }

  /// A value update or a flow inside (s, e] (§9.3).
  bool activeIn(DateTime s, DateTime e) =>
      _entriesIn(s, e).any((x) => x is! InterestRecord);

  bool closedAt(DateTime d) =>
      _entries.isNotEmpty &&
      !_entries.first.date.isAfter(d) &&
      netValueAt(d) <= Decimal.zero;

  DateTime get latestValueDate => _entries
      .where((x) => x is! InterestRecord)
      .fold(investment.startDate, (a, x) => x.date.isAfter(a) ? x.date : a);

  /// The latest value update or money in/out on or before [d], else the start
  /// date. Interest does not move the value date (Z16).
  DateTime valueDateAt(DateTime d) => _entries
      .where((x) => x is! InterestRecord && !x.date.isAfter(d))
      .fold(investment.startDate, (a, x) => x.date.isAfter(a) ? x.date : a);
}
