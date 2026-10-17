/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../domain/expected_plan.dart';
import '../../domain/history_entry.dart';

/// One point of a series; [hollow] marks a pending row (UX 2.12.5).
final class ChartPoint {
  const ChartPoint(this.date, this.amount, {this.hollow = false});

  final DateTime date;
  final Decimal amount;
  final bool hollow;
}

/// What a chart draws: the estimate (dashed), the actual records (solid,
/// filled dots) and the rows still to confirm (hollow).
final class PlanSeries {
  const PlanSeries({
    required this.expected,
    required this.actual,
    required this.pending,
    required this.steps,
  });

  final List<ChartPoint> expected;
  final List<ChartPoint> actual;
  final List<ChartPoint> pending;

  /// Payouts are cumulative steps; values are straight lines.
  final bool steps;
}

/// V_exp sampled at the start, every check date, every value update and today
/// (spec 12.10); actual = the value at the start and at each update.
PlanSeries valueSeries(ExpectedVsActual p) {
  final tl = p.timeline;
  final start = p.investment.startDate;
  final updates = tl.aggregate.history.whereType<ValueUpdate>().where(
    (v) => v.date.isAfter(start) && !v.date.isAfter(p.today),
  );
  final dates = {
    start,
    for (final r in p.valueRows) r.date,
    for (final v in updates) v.date,
    p.today,
  }.toList()..sort();
  return PlanSeries(
    expected: [
      for (final d in dates)
        if (p.expectedValueAt(d) case final v?) ChartPoint(d, v),
    ],
    actual: [
      ChartPoint(start, tl.netValueAt(start)),
      for (final d in {for (final v in updates) v.date}.toList()..sort())
        ChartPoint(d, tl.netValueAt(d)),
    ],
    pending: [
      for (final r in p.valueRows)
        if (r.pending && r.expected != null)
          ChartPoint(r.date, r.expected!, hollow: true),
    ],
    steps: false,
  );
}

/// Cumulative expected payouts at row dates and cumulative actual income
/// (case C included) at record dates; pending rows sit on the expected step.
PlanSeries payoutSeries(ExpectedVsActual p) {
  final start = p.investment.startDate;
  var e = Decimal.zero;
  final expected = <ChartPoint>[ChartPoint(start, Decimal.zero)];
  final pending = <ChartPoint>[];
  for (final r in p.payoutRows) {
    if (r.expected == null) continue;
    e += r.expected!;
    expected.add(ChartPoint(r.date, e));
    if (r.pending) pending.add(ChartPoint(r.date, e, hollow: true));
  }
  var a = Decimal.zero;
  final actual = <ChartPoint>[ChartPoint(start, Decimal.zero)];
  for (final x in p.receivedRecords) {
    final amount = p.timeline.inItemUnit(x);
    if (amount == null) continue;
    a += amount;
    actual.add(ChartPoint(x.date, a));
  }
  return PlanSeries(
    expected: expected.length > 1 ? expected : const [],
    actual: actual,
    pending: pending,
    steps: true,
  );
}

/// The value chart's lowest and highest amounts (its two Y labels); null for
/// the payouts chart, which always starts at 0 (UX review U2).
({Decimal low, Decimal high})? valueRange(PlanSeries s) {
  final all = [...s.expected, ...s.actual, ...s.pending];
  if (s.steps || all.isEmpty) return null;
  var low = all.first.amount;
  var high = low;
  for (final p in all) {
    if (p.amount < low) low = p.amount;
    if (p.amount > high) high = p.amount;
  }
  return (low: low, high: high);
}

/// A short axis label ("10.2k", "1.5M"); exact amounts stay in the rows and
/// the tooltip.
String shortAmount(Decimal v) {
  final x = v.toDouble();
  if (x.abs() >= 1e6) return '${(x / 1e6).toStringAsFixed(1)}M';
  if (x.abs() >= 1e3) return '${(x / 1e3).toStringAsFixed(1)}k';
  return x.toStringAsFixed(0);
}

/// One chart, two callers (spec E10). Drawn with CustomPaint: no package.
class PlanChart extends StatefulWidget {
  const PlanChart({
    super.key,
    required this.series,
    required this.semanticsLabel,
    required this.tooltip,
  });

  final PlanSeries series;
  final String semanticsLabel;

  /// Exact text for a tapped point (date, kind, amount, state).
  final String Function(ChartPoint point, bool expected) tooltip;

  @override
  State<PlanChart> createState() => _PlanChartState();
}

class _PlanChartState extends State<PlanChart> {
  String? _tip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final narrow = MediaQuery.sizeOf(context).width < 360;
    return Semantics(
      container: true,
      label: widget.semanticsLabel,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, box) {
              final size = Size(box.maxWidth, narrow ? 160 : 180);
              final geometry = _Geometry(widget.series, size, rtl);
              return GestureDetector(
                onTapDown: (d) => setState(() {
                  final hit = geometry.nearest(d.localPosition);
                  _tip = hit == null ? null : widget.tooltip(hit.$1, hit.$2);
                }),
                child: CustomPaint(
                  size: size,
                  painter: _PlanPainter(
                    geometry,
                    actual: scheme.primary,
                    expected: scheme.outline,
                    grid: scheme.outlineVariant,
                    label: Theme.of(context).textTheme.labelSmall!
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
              );
            },
          ),
          if (_tip != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _tip!,
                key: const ValueKey('chart-tooltip'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

/// Maps dates and amounts to pixels; the time axis mirrors in RTL.
final class _Geometry {
  _Geometry(this.series, this.size, this.rtl) {
    final all = [...series.expected, ...series.actual, ...series.pending];
    if (all.isEmpty) return;
    _t0 = all.map((p) => p.date).reduce((a, b) => a.isBefore(b) ? a : b);
    _t1 = all.map((p) => p.date).reduce((a, b) => a.isAfter(b) ? a : b);
    final range = valueRange(series);
    if (range == null) {
      final max = all.map((p) => p.amount.toDouble()).reduce(math.max);
      _hi = max <= 0 ? 1.0 : max * 1.1;
    } else {
      final low = range.low.toDouble();
      final high = range.high.toDouble();
      final pad = high == low ? (high.abs() * 0.05 + 1) : (high - low) * 0.1;
      _lo = low - pad;
      _hi = high + pad;
    }
  }

  final PlanSeries series;
  final Size size;
  final bool rtl;
  DateTime? _t0;
  DateTime? _t1;
  var _lo = 0.0;
  var _hi = 1.0;
  static const _pad = 8.0;

  Offset at(ChartPoint p) {
    final span = _t1!.difference(_t0!).inDays;
    final fx = span == 0 ? 0.5 : p.date.difference(_t0!).inDays / span;
    final x = _pad + (rtl ? 1 - fx : fx) * (size.width - 2 * _pad);
    final y =
        size.height -
        _pad -
        (p.amount.toDouble() - _lo) / (_hi - _lo) * (size.height - 2 * _pad);
    return Offset(x, y);
  }

  /// The point under a tap, within 24 px; expected points report as such.
  (ChartPoint, bool)? nearest(Offset tap) {
    (ChartPoint, bool)? best;
    var bestD = 24.0;
    void check(ChartPoint p, bool expected) {
      final d = (at(p) - tap).distance;
      if (d < bestD) {
        bestD = d;
        best = (p, expected);
      }
    }

    if (_t0 == null) return null;
    for (final p in series.actual.skip(1)) {
      check(p, false);
    }
    for (final p in series.pending) {
      check(p, true);
    }
    for (final p in series.expected) {
      check(p, true);
    }
    return best;
  }
}

class _PlanPainter extends CustomPainter {
  _PlanPainter(
    this.g, {
    required this.actual,
    required this.expected,
    required this.grid,
    required this.label,
  });

  final _Geometry g;
  final Color actual;
  final Color expected;
  final Color grid;
  final TextStyle label;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    if (g._t0 == null) return;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final s = g.series;
    final dashed = _path(s.expected, s.steps);
    _drawDashed(canvas, dashed, line..color = expected);
    canvas.drawPath(_path(s.actual, s.steps), line..color = actual);
    final dot = Paint()..color = actual;
    for (final p in s.actual) {
      canvas.drawCircle(g.at(p), 3.5, dot);
    }
    _yLabels(canvas, size);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = expected;
    for (final p in s.pending) {
      canvas.drawCircle(g.at(p), 5, ring);
    }
  }

  /// Min and max on the start edge (the right edge in RTL).
  void _yLabels(Canvas canvas, Size size) {
    final range = valueRange(g.series);
    if (range == null) return;
    for (final v in [range.low, range.high]) {
      final tp = TextPainter(
        text: TextSpan(text: shortAmount(v), style: label),
        textDirection: TextDirection.ltr,
      )..layout();
      final y = g.at(ChartPoint(g._t0!, v)).dy - tp.height / 2;
      final x = g.rtl ? size.width - tp.width : 0.0;
      tp.paint(canvas, Offset(x, y.clamp(0, size.height - tp.height)));
    }
  }

  Path _path(List<ChartPoint> points, bool steps) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final o = g.at(points[i]);
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else if (steps) {
        path.lineTo(o.dx, g.at(points[i - 1]).dy);
        path.lineTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    return path;
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final ui.PathMetric m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + 6, m.length)), paint);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(_PlanPainter old) =>
      old.g.series != g.series || old.g.size != g.size || old.g.rtl != g.rtl;
}
