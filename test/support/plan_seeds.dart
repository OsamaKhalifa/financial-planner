/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';

import 'app_harness.dart';

/// "Friend's project" (story §10): private equity, long-term, EGP, start
/// 2026-01-15, 100,000 in, 20 % a year, paid every 3 months.
Investment friendsProject({
  String? profit = '0.20',
  ProfitBasis q1 = ProfitBasis.shareOfProfit,
  CapitalBack q2 = CapitalBack.no,
  ZakatRule rule = ZakatRule.longTermFullValue,
  Schedule? check,
}) => Investment(
  id: 'fp',
  name: "Friend's project",
  type: AssetType.privateEquity,
  intent: Intent.longTerm,
  unit: egp,
  startDate: day(2026, 1, 15),
  zakatRule: rule,
  payoutSchedule: Schedule.quarterly,
  expectedProfit: profit == null ? null : Decimal.parse(profit),
  profitBasis: profit == null ? null : q1,
  capitalBack: q2,
  valueCheckSchedule: check,
);

Future<void> seedFriend(
  Harness h, {
  Investment? investment,
  List<HistoryEntry> more = const [],
}) async {
  await h.setup();
  await h.addItem(investment ?? friendsProject(), [
    moneyIn('fp', day(2026, 1, 15), '100000'),
    ...more,
  ]);
}

/// AC-61's fund: start 2026-01-01, 10,000, growth 12 %, value check monthly.
Investment planFund({DateTime? start}) => Investment(
  id: 'fund',
  name: 'Growth fund',
  type: AssetType.fund,
  intent: Intent.trading,
  unit: egp,
  startDate: start ?? day(2026, 1, 1),
  zakatRule: ZakatRule.trading100,
  valueCheckSchedule: Schedule.monthly,
  expectedGrowth: Decimal.parse('0.12'),
);

/// AC-58's deposit: start 2026-01-01, 10,000, 10 %, monthly.
Investment planDeposit(AccountKind kind) => Investment(
  id: 'dep',
  name: 'Deposit',
  type: AssetType.cashDeposit,
  unit: egp,
  startDate: day(2026, 1, 1),
  zakatRule: ZakatRule.cash100,
  payoutSchedule: Schedule.monthly,
  expectedProfit: Decimal.parse('0.10'),
  accountKind: kind,
);

/// AC-57: monthly, no %, start 2026-01-31.
Investment noPctFund() => Investment(
  id: 'np',
  name: 'No %',
  type: AssetType.fund,
  intent: Intent.trading,
  unit: egp,
  startDate: day(2026, 1, 31),
  zakatRule: ZakatRule.trading100,
  payoutSchedule: Schedule.monthly,
);
