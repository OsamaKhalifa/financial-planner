/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/assumptions_providers.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/clock_provider.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/database_provider.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/presentation/investments_providers.dart';
import 'package:financial_planner/features/zakat/domain/yearly_zakat.dart';
import 'package:financial_planner/features/zakat/domain/zakat_year.dart';
import 'package:financial_planner/features/zakat/presentation/zakat_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_harness.dart';

/// Yasmin's year from the story (§11): base EGP, lunar, nisab gold 85 g, due
/// on D = 2026-10-20, today 2026-10-23.
final yasminDue = day(2026, 10, 20);
final yasminToday = day(2026, 10, 23);

const gold = ZakatPrefs(nisab: NisabMetal.gold);

/// The lunar cycle whose year 1448 AH ends on D.
ZakatCycle yasminCycle() {
  final h = hijriOf(yasminDue);
  final cycle = ZakatCycle(
    calendar: ZakatYear.lunar,
    month: h.m,
    day: h.d,
    from: day(2026, 1, 1),
  );
  if (dueDate(ZakatYear.lunar, h.m, h.d, h.y) != yasminDue) {
    throw StateError('The cycle does not end on $yasminDue.');
  }
  return cycle;
}

ZakatCycle solarCycle(int month, int dayOfMonth, DateTime from) => ZakatCycle(
  calendar: ZakatYear.solar,
  month: month,
  day: dayOfMonth,
  from: from,
);

ExtraLine cashAtHome() => ExtraLine(
  id: 'cash',
  label: 'Cash at home',
  kind: ExtraKind.cash,
  amount: Money(d('10000'), egp),
  goodDebtConfirmed: false,
);

ExtraLine loanToBrother() => ExtraLine(
  id: 'loan',
  label: 'Loan to my brother',
  kind: ExtraKind.owedToMe,
  amount: Money(d('500'), usd),
  goodDebtConfirmed: true,
);

Future<void> seedYasminItems(Harness h) async {
  await h.addItem(
    item(
      'Savings',
      type: AssetType.cashDeposit,
      intent: null,
      rule: ZakatRule.cash100,
    ),
    [
      moneyIn('Savings', day(2026, 1, 1), '120000'),
      value('Savings', day(2026, 10, 1), '120000'),
    ],
  );
  await h.addItem(
    item(
      'Gold bar',
      type: AssetType.gold,
      unit: xauG,
      intent: null,
      rule: ZakatRule.bullion100,
    ),
    [
      moneyIn('Gold bar', day(2026, 1, 1), '50', xauG),
      value('Gold bar', yasminDue, '50'),
    ],
  );
  await h.addItem(
    item(
      'US shares',
      type: AssetType.stock,
      unit: usd,
      market: Market.nasdaq,
      rule: ZakatRule.trading100,
    ),
    [
      moneyIn('US shares', day(2026, 1, 1), '3000', usd),
      value('US shares', yasminDue, '2000'),
    ],
  );
  await h.addItem(
    item(
      'EGX shares',
      type: AssetType.stock,
      market: Market.egx,
      intent: Intent.longTerm,
      rule: ZakatRule.longTermProxy25,
    ),
    [
      moneyIn('EGX shares', day(2026, 1, 1), '80000'),
      value('EGX shares', yasminDue, '80000'),
    ],
  );
  await h.addItem(
    item(
      'Home',
      type: AssetType.other,
      intent: Intent.personalUse,
      rule: ZakatRule.custom,
      customShare: Decimal.zero,
    ),
    [
      moneyIn('Home', day(2026, 1, 1), '3000000'),
      value('Home', yasminDue, '3000000'),
    ],
  );
}

Future<void> seedYasminRates(
  Harness h, {
  bool goldRate = true,
  bool usdRate = true,
}) async {
  if (goldRate) await h.rate(xauG, egp, '5000', yasminDue);
  await h.rate(xagG, egp, '60', yasminDue);
  if (usdRate) {
    await h.rate(usd, egp, '48', yasminDue);
    await h.rate(usd, egp, '50', day(2026, 10, 21));
  }
}

Future<void> seedYasminRecord(
  Harness h, {
  bool extras = true,
  String debts = '20000',
}) async {
  await h.zakat.saveYear(yasminDue, debts: d(debts), deductDebts: true);
  if (!extras) return;
  await h.zakat.saveExtraLine(yasminDue, cashAtHome());
  await h.zakat.saveExtraLine(yasminDue, loanToBrother());
}

/// Everything of Yasmin's year: Σ 520,000.00, B 500,000.00, Z 12,500.00.
Future<void> seedYasmin(
  Harness h, {
  ZakatPrefs prefs = gold,
  bool goldRate = true,
  bool usdRate = true,
  bool extras = true,
  String debts = '20000',
}) async {
  await h.setup(zakatPrefs: prefs, cycle: yasminCycle());
  await seedYasminItems(h);
  await seedYasminRates(h, goldRate: goldRate, usdRate: usdRate);
  await seedYasminRecord(h, extras: extras, debts: debts);
}

Gift gift(
  String date,
  String amount, {
  Unit unit = egp,
  String? note,
  Decimal? rate,
  DateTime? rateDate,
  GivingRateView? view,
}) => Gift(
  date: DateTime.parse('${date}T00:00:00Z'),
  amount: Money(d(amount), unit),
  note: note,
  rate: rate,
  rateDate: rateDate,
  view: view,
);

/// Starts the years with these due dates as the app would, on [Harness.now].
Future<void> startYears(Harness h, List<DateTime> keys) async {
  final c = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(h.db),
      clockProvider.overrideWithValue(() => h.now),
      shippedInflationProvider.overrideWith((ref) => defaultShipped()),
    ],
  );
  c.listen(zakatYearsProvider, (_, _) {});
  await c.read(calculatorProvider.future);
  await c.read(rateBookProvider.future);
  await c.read(zakatCyclesProvider.future);
  await c.read(zakatRecordsProvider.future);
  await c.read(settingsProvider.future);
  final years = c.read(zakatYearsProvider)!;
  for (final key in keys) {
    final view = years.firstWhere((y) => y.slot.key == key);
    await h.zakat.freeze(key, freeze(view.inputs, today(() => h.now)));
  }
  c.dispose();
  await Future<void>.delayed(Duration.zero);
}
