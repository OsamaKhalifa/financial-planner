/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/money/decimal_math.dart';
import '../../../investments/domain/portfolio_calculator.dart';
import '../../../investments/presentation/widgets/labels.dart';

/// One line of a [TrendChart]. [values] line up with the chart's months; a
/// null is a gap in the line.
final class ChartSeries {
  const ChartSeries(this.label, this.color, this.values);

  final String label;
  final Color color;
  final List<Decimal?> values;
}

const _height = 180.0;

String _month(BuildContext context, MonthPoint m) =>
    DateFormat.MMM(context.lang).format(m.period.e);

FlTitlesData _titles(BuildContext context, List<MonthPoint> months) =>
    FlTitlesData(
      leftTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          interval: months.length > 6 ? 2 : 1,
          getTitlesWidget: (v, meta) {
            final i = v.round();
            if (i < 0 || i >= months.length) return const SizedBox.shrink();
            return SideTitleWidget(
              meta: meta,
              child: Text(
                _month(context, months[i]),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        ),
      ),
    );

/// A line per series over the same months. Axes carry no numbers: touching a
/// month shows each series' exact amount.
class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    required this.months,
    required this.series,
    required this.format,
  });

  final List<MonthPoint> months;
  final List<ChartSeries> series;
  final String Function(Decimal) format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (series.length > 1)
          Wrap(
            spacing: 16,
            children: [
              for (final s in series)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 10, color: s.color),
                    const SizedBox(width: 4),
                    Text(s.label, style: theme.textTheme.bodySmall),
                  ],
                ),
            ],
          ),
        const SizedBox(height: 8),
        SizedBox(
          height: _height,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (months.length - 1).toDouble(),
              titlesData: _titles(context, months),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: theme.colorScheme.outlineVariant,
                  strokeWidth: 0.5,
                ),
              ),
              lineBarsData: [
                for (final s in series)
                  LineChartBarData(
                    color: s.color,
                    barWidth: 2.5,
                    dotData: FlDotData(show: months.length <= 3),
                    spots: [
                      for (var i = 0; i < s.values.length; i++)
                        s.values[i] == null
                            ? FlSpot.nullSpot
                            : FlSpot(i.toDouble(), toChart(s.values[i]!)),
                    ],
                  ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => [
                    for (final spot in spots)
                      LineTooltipItem(
                        spot.barIndex == 0
                            ? '${_month(context, months[spot.spotIndex])}\n'
                                  '${series[0].label}: '
                                  '${format(series[0].values[spot.spotIndex]!)}'
                            : '${series[spot.barIndex].label}: '
                                  '${format(series[spot.barIndex].values[spot.spotIndex]!)}',
                        TextStyle(
                          color: spot.bar.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Two bars a month: the return, and the return after the estimated zakat
/// set-aside. A loss hangs below the axis and is red; the signed amount is in
/// the tooltip, so colour is never the only signal.
class ReturnBars extends StatelessWidget {
  const ReturnBars({
    super.key,
    required this.months,
    required this.returnLabel,
    required this.afterLabel,
    required this.format,
  });

  final List<MonthPoint> months;
  final String returnLabel;
  final String afterLabel;
  final String Function(Decimal) format;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    BarChartRodData rod(Decimal? v, Color gain) => BarChartRodData(
      toY: v == null ? 0 : toChart(v),
      width: 7,
      borderRadius: BorderRadius.zero,
      color: v != null && v < Decimal.zero ? scheme.error : gain,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          children: [
            for (final (label, color) in [
              (returnLabel, scheme.primary),
              (afterLabel, scheme.tertiary),
            ])
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 10, color: color),
                  const SizedBox(width: 4),
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: _height,
          child: BarChart(
            BarChartData(
              titlesData: _titles(context, months),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: scheme.outlineVariant, strokeWidth: 0.5),
              ),
              barGroups: [
                for (var i = 0; i < months.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 2,
                    barRods: [
                      rod(months[i].r, scheme.primary),
                      rod(months[i].rz, scheme.tertiary),
                    ],
                  ),
              ],
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rodData, rodIndex) {
                    final m = months[group.x];
                    final v = rodIndex == 0 ? m.r : m.rz;
                    return BarTooltipItem(
                      '${_month(context, m)}\n'
                      '${rodIndex == 0 ? returnLabel : afterLabel}: '
                      '${v == null ? '—' : format(v)}',
                      const TextStyle(fontSize: 12, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
