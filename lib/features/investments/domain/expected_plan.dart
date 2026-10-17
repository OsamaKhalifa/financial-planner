/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/dates.dart';
import '../../../core/money/decimal_math.dart';
import 'formulas.dart';
import 'history_entry.dart';
import 'investment.dart';
import 'item_timeline.dart';
import 'period.dart';

/// Rows are rebuilt on every read and never stored (spec E1): only the user's
/// own records and skips are written. Nothing here feeds return or zakat.
enum RowState { pending, resolved, skipped }

const _window = 7;

final class PlanRow {
  const PlanRow({
    required this.kind,
    required this.k,
    required this.from,
    required this.date,
    required this.expected,
    required this.state,
    this.actual,
    this.actualAmount,
    this.skip,
    required this.noPayoutLine,
  });

  final PlanKind kind;
  final int k;

  /// The day after the previous schedule date: "No payout recorded for
  /// {from} – {date}" (story §5.6 words).
  final DateTime from;
  final DateTime date;

  /// Null without a % or when a rate is missing.
  final Decimal? expected;
  final RowState state;
  final HistoryEntry? actual;

  /// The matched record's amount, in the item unit.
  final Decimal? actualAmount;
  final PlanSkip? skip;

  /// Payout row: skipped, or still pending from date + 8 days (AC-51).
  final bool noPayoutLine;

  bool get pending => state == RowState.pending;
}

/// At every value update after the start (AC-60).
final class ValueCheck {
  const ValueCheck({
    required this.date,
    required this.entry,
    required this.actualNet,
    required this.expected,
  });

  final DateTime date;
  final ValueUpdate entry;
  final Decimal actualNet;
  final Decimal expected;

  Decimal get diff => actualNet - expected;

  Decimal? get diffPct =>
      expected == Decimal.zero ? null : divide(diff, expected);

  bool get below => actualNet < expected;
}

final class ExpectedVsActual {
  ExpectedVsActual._({
    required this.timeline,
    required this.today,
    required this.payoutRows,
    required this.valueRows,
    required this.valueChecks,
    required this.received,
    required this.missing,
    required this.receivedRecords,
    required this.valueFlows,
  });

  final ItemTimeline timeline;
  final DateTime today;
  final List<PlanRow> payoutRows;
  final List<PlanRow> valueRows;
  final List<ValueCheck> valueChecks;

  /// All income since start, matched or not, case C included (§5.5, AC-54);
  /// conventional deposit: interest received.
  final Decimal received;

  /// Non-empty: every expected amount is null and the pair is named (§5.6).
  final List<MissingRate> missing;

  /// The records counted in [received], oldest first.
  final List<HistoryEntry> receivedRecords;

  /// Money in (+) and sales (−) in the item unit: what V_exp compounds.
  final List<Flow> valueFlows;

  Investment get investment => timeline.investment;

  bool get hasPayoutPlan => investment.payoutSchedule != null;

  bool get hasValuePlan => investment.valueCheckSchedule != null;

  bool get _amounts => missing.isEmpty && investment.expectedProfit != null;

  /// Σ P_k with d_k on or before today, pending and skipped included.
  Decimal? get expectedSoFar =>
      _amounts ? sumOf(payoutRows.map((r) => r.expected!)) : null;

  Decimal? get difference {
    final e = expectedSoFar;
    return e == null ? null : received - e;
  }

  /// Item scope of a month or year view (AC-52).
  ({Decimal? expected, Decimal received}) payoutsIn(Period p) {
    bool inside(DateTime d) => d.isAfter(p.s) && !d.isAfter(p.e);
    return (
      expected: _amounts
          ? sumOf([
              for (final r in payoutRows)
                if (inside(r.date)) r.expected!,
            ])
          : null,
      received: sumOf([
        for (final x in receivedRecords)
          if (inside(x.date)) ?timeline.inItemUnit(x),
      ]),
    );
  }

  /// The chart's expected line; null without a growth %.
  Decimal? expectedValueAt(DateTime t) {
    final g = investment.expectedGrowth;
    if (g == null || missing.isNotEmpty) return null;
    return expectedValue(flows: valueFlows, growth: g, on: t);
  }

  Iterable<PlanRow> get pendingRows =>
      [...payoutRows, ...valueRows].where((r) => r.pending);

  bool get hasPending => pendingRows.isNotEmpty;

  /// Home's "N to confirm": a closed item is never counted (AC-56).
  int get toConfirm => _closed(timeline, today) ? 0 : pendingRows.length;

  /// A pending row whose window holds [d]: S5 by hand says the record also
  /// resolves it (UX 2.12.3).
  PlanRow? pendingRowNear(DateTime d, PlanKind kind) =>
      (kind == PlanKind.payout ? payoutRows : valueRows)
          .where((r) => r.pending && _near(r.date, d))
          .firstOrNull;
}

/// With a missing rate the value reads 0, which is not a full sale.
bool _closed(ItemTimeline tl, DateTime d) =>
    tl.missing.isEmpty && tl.closedAt(d);

bool _near(DateTime a, DateTime b) => daysBetween(a, b).abs() <= _window;

/// Null when the item has no schedule (AC-48).
ExpectedVsActual? expectedVsActual(ItemTimeline tl, DateTime today) {
  final inv = tl.investment;
  if (inv.payoutSchedule == null && inv.valueCheckSchedule == null) {
    return null;
  }
  final history = tl.aggregate.history;
  final missing = List.of(tl.missing);
  final conventional = inv.conventionalDeposit;
  final received = _sorted([
    for (final x in history)
      if (_isPayoutRecord(x, conventional) && !x.date.isAfter(today)) x,
  ]);
  final valueFlows = [
    for (final x in history)
      if (_isCapitalFlow(x) && tl.inItemUnit(x) != null)
        Flow(
          date: x.date,
          amount: x is MoneyIn ? tl.inItemUnit(x)! : -tl.inItemUnit(x)!,
        ),
  ];
  final skips = history.whereType<PlanSkip>().toList();
  final growth = missing.isEmpty ? inv.expectedGrowth : null;
  Decimal? vExp(DateTime t) => growth == null
      ? null
      : expectedValue(flows: valueFlows, growth: growth, on: t);

  final payoutRows = inv.payoutSchedule == null
      ? <PlanRow>[]
      : _rows(
          tl,
          today,
          PlanKind.payout,
          inv.payoutSchedule!,
          records: received,
          skips: skips,
          amountAt: (k, prev) =>
              inv.expectedProfit == null || missing.isNotEmpty
              ? null
              : expectedPayout(
                  capital: _capitalAt(valueFlows, prev),
                  rate: inv.expectedProfit!,
                  months: inv.payoutSchedule!.months,
                ),
        );
  final valueRows = inv.valueCheckSchedule == null
      ? <PlanRow>[]
      : _rows(
          tl,
          today,
          PlanKind.value,
          inv.valueCheckSchedule!,
          records: _sorted([
            for (final x in history)
              if (x is ValueUpdate && !x.date.isAfter(today)) x,
          ]),
          skips: skips,
          amountAt: (k, _) => vExp(
            addMonths(inv.startDate, k * inv.valueCheckSchedule!.months),
          ),
        );
  return ExpectedVsActual._(
    timeline: tl,
    today: today,
    payoutRows: payoutRows,
    valueRows: valueRows,
    valueChecks: [
      if (growth != null)
        for (final v in history.whereType<ValueUpdate>())
          if (v.date.isAfter(inv.startDate) && !v.date.isAfter(today))
            ValueCheck(
              date: v.date,
              entry: v,
              actualNet: tl.netValueAt(v.date),
              expected: vExp(v.date)!,
            ),
    ]..sort((a, b) => a.date.compareTo(b.date)),
    received: sumOf([for (final x in received) ?tl.inItemUnit(x)]),
    missing: missing,
    receivedRecords: received,
    valueFlows: valueFlows,
  );
}

/// Income resolves payout rows; on a conventional deposit only interest
/// received does (P-4b, architect Q-E1).
bool _isPayoutRecord(HistoryEntry x, bool conventional) => conventional
    ? x is InterestRecord &&
          (x.kind == InterestKind.paidOut || x.kind == InterestKind.keptInside)
    : x is MoneyOut && x.kind == MoneyOutKind.income;

/// The entries that move the recorded value after Q12: money in and sales.
bool _isCapitalFlow(HistoryEntry x) =>
    x is MoneyIn || (x is MoneyOut && x.kind == MoneyOutKind.sale);

/// C(d): money in − sales on or before [d], never below 0 (AC-55).
Decimal _capitalAt(List<Flow> flows, DateTime d) {
  final c = sumOf([
    for (final f in flows)
      if (!f.date.isAfter(d)) f.amount,
  ]);
  return c < Decimal.zero ? Decimal.zero : c;
}

List<HistoryEntry> _sorted(List<HistoryEntry> xs) => xs
  ..sort((a, b) {
    final c = a.date.compareTo(b.date);
    return c != 0 ? c : a.createdAt.compareTo(b.createdAt);
  });

List<PlanRow> _rows(
  ItemTimeline tl,
  DateTime today,
  PlanKind kind,
  Schedule schedule, {
  required List<HistoryEntry> records,
  required List<PlanSkip> skips,
  required Decimal? Function(int k, DateTime previous) amountAt,
}) {
  final start = tl.investment.startDate;
  final used = <String>{};
  final rows = <PlanRow>[];
  var previous = start;
  for (var k = 1; ; k++) {
    final date = addMonths(start, k * schedule.months);
    if (date.isAfter(today)) break;
    final from = previous.add(const Duration(days: 1));
    final expected = amountAt(k, previous);
    previous = date;
    if (_closed(tl, date)) continue;
    final match = records
        .where((r) => !used.contains(r.id) && _near(r.date, date))
        .firstOrNull;
    final skip = skips
        .where((s) => s.plan == kind && s.date == date)
        .firstOrNull;
    if (match != null) used.add(match.id);
    final state = match != null
        ? RowState.resolved
        : skip != null
        ? RowState.skipped
        : RowState.pending;
    rows.add(
      PlanRow(
        kind: kind,
        k: k,
        from: from,
        date: date,
        expected: expected,
        state: state,
        actual: match,
        actualAmount: match == null
            ? null
            : match is ValueUpdate
            ? tl.netValueAt(match.date)
            : tl.inItemUnit(match),
        skip: match == null ? skip : null,
        noPayoutLine:
            kind == PlanKind.payout &&
            (state == RowState.skipped ||
                (state == RowState.pending &&
                    daysBetween(date, today) >= _window + 1)),
      ),
    );
  }
  return rows;
}
