/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/domain/expected_plan.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/item_timeline.dart';
import 'package:financial_planner/features/investments/presentation/widgets/plan_chart.dart';
import 'package:financial_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/app_harness.dart';
import '../../../../support/plan_seeds.dart';

Decimal dd(String s) => Decimal.parse(s);

ExpectedVsActual plan(Investment i, List<HistoryEntry> h, DateTime on) =>
    expectedVsActual(
      ItemTimeline(
        InvestmentWithHistory(investment: i, history: h),
        RateBook(const []),
      ),
      on,
    )!;

List<(DateTime, Decimal)> pts(List<ChartPoint> p) => [
  for (final x in p) (x.date, x.amount),
];

void main() {
  final fundStart = moneyIn('fund', day(2026, 1, 1), '10000');

  test('AC-62 value chart before confirming: actual 10,000 at the start; hollow 10,096.72 and 10,184.88', () {
    final s = valueSeries(plan(planFund(), [fundStart], day(2026, 3, 5)));
    expect(pts(s.actual), [(day(2026, 1, 1), dd('10000'))]);
    expect(pts(s.pending), [
      (day(2026, 2, 1), dd('10096.72')),
      (day(2026, 3, 1), dd('10184.88')),
    ]);
    expect(s.pending.every((p) => p.hollow), isTrue);
    expect(pts(s.expected).take(3), [
      (day(2026, 1, 1), dd('10000')),
      (day(2026, 2, 1), dd('10096.72')),
      (day(2026, 3, 1), dd('10184.88')),
    ]);
  });

  test('AC-62 value chart after AC-61: actual 10,000 / 10,096.72 / 9,800.00 and no hollow point', () {
    final s = valueSeries(
      plan(planFund(), [
        fundStart,
        value('fund', day(2026, 2, 1), '10096.72'),
        value('fund', day(2026, 3, 1), '9800'),
      ], day(2026, 3, 5)),
    );
    expect(
      [for (final p in s.actual) p.amount],
      [dd('10000'), dd('10096.72'), dd('9800')],
    );
    expect(s.pending, isEmpty);
  });

  test('AC-62 payouts chart for AC-52: expected 5,000 / 10,000 / 15,000; actual 5,000 / 9,000', () {
    final s = payoutSeries(
      plan(friendsProject(), [
        moneyIn('fp', day(2026, 1, 15), '100000'),
        moneyOut('fp', day(2026, 4, 15), '5000', kind: MoneyOutKind.income),
        moneyOut('fp', day(2026, 7, 15), '4000', kind: MoneyOutKind.income),
        PlanSkip(
          investmentId: 'fp',
          date: day(2026, 10, 15),
          plan: PlanKind.payout,
        ),
      ], day(2026, 10, 17)),
    );
    expect(pts(s.expected).skip(1), [
      (day(2026, 4, 15), dd('5000')),
      (day(2026, 7, 15), dd('10000')),
      (day(2026, 10, 15), dd('15000')),
    ]);
    expect(pts(s.actual).skip(1), [
      (day(2026, 4, 15), dd('5000')),
      (day(2026, 7, 15), dd('9000')),
    ]);
    expect(s.pending, isEmpty);
    expect(s.steps, isTrue);
  });

  for (final locale in [en, ar]) {
    testWidgets(
      'the chart is one accessible element with its summary (${locale.languageCode}); a tap shows the exact amount',
      (tester) async {
        final s = valueSeries(plan(planFund(), [fundStart], day(2026, 3, 5)));
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Scaffold(
                  body: SizedBox(
                    width: 300,
                    child: PlanChart(
                      series: s,
                      semanticsLabel: l10n.chartValueSummary(
                        '10,184.88',
                        '10,000.00',
                        2,
                      ),
                      tooltip: (p, e) => 'tip ${p.amount}',
                    ),
                  ),
                );
              },
            ),
          ),
        );
        final l10n = AppLocalizations.of(
          tester.element(find.byType(PlanChart)),
        );
        expect(
          find.bySemanticsLabel(
            l10n.chartValueSummary('10,184.88', '10,000.00', 2),
          ),
          findsOneWidget,
        );
        final box = tester.getRect(find.byType(CustomPaint).last);
        // The March pending point (day 59 of 63); the axis mirrors in RTL.
        final max = s.expected.last.amount.toDouble() * 1.1;
        final f = 59 / 63;
        final x = box.left + 8 + (locale == ar ? 1 - f : f) * (box.width - 16);
        final top = box.top + 8 + (box.height - 16) * (1 - 10184.88 / max);
        await tester.tapAt(Offset(x, top));
        await tester.pump();
        expect(find.text('tip 10184.88'), findsOneWidget);
      },
    );
  }
}
