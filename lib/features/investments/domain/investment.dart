/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/ids.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import 'history_entry.dart';

enum AssetType {
  stock,
  fund,
  sukuk,
  gold,
  silver,
  cashDeposit,
  crypto,
  privateEquity,
  other,
}

enum Intent { trading, longTerm, personalUse, rental }

/// What the user chose; resolved against the settings at calculation time.
enum ZakatRule {
  cash100,
  bullion100,
  jewelleryPerSetting,
  trading100,
  longTermPerSetting,
  longTermDividendsOnly,
  longTermProxy25,
  longTermFullValue,
  sukuk100,
  crypto100,
  companyPaysZakat,
  custom,
}

enum Schedule {
  monthly(1),
  quarterly(3),
  halfYearly(6),
  yearly(12);

  const Schedule(this.months);

  final int months;
}

/// P-2 Q1: is the % a share of the real profit or a fixed % of the money in?
enum ProfitBasis { shareOfProfit, fixedPctOfMoney, notSure }

/// P-2 Q2: does the money come back even if the project loses?
enum CapitalBack { no, yes, notSure }

/// P-3: asked on a cash deposit with a payout schedule.
enum AccountKind { islamic, conventional }

/// Shariah file B6.1 cases; [notSure] is the "?" notice.
enum PeCase { a, b, c, notSure }

final class Investment {
  Investment({
    String? id,
    required this.name,
    required this.type,
    this.intent,
    this.market,
    this.marketCountry,
    required this.unit,
    required this.startDate,
    this.quantity,
    this.purityKarat,
    this.purityFineness,
    required this.zakatRule,
    this.customZakatShare,
    this.inflationOverride,
    this.notes,
    this.payoutSchedule,
    this.expectedProfit,
    this.valueCheckSchedule,
    this.expectedGrowth,
    this.profitBasis,
    this.capitalBack,
    this.accountKind,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? newId(),
       createdAt = createdAt ?? DateTime.utc(1970),
       updatedAt = updatedAt ?? createdAt ?? DateTime.utc(1970);

  final String id;
  final String name;
  final AssetType type;
  final Intent? intent;
  final Market? market;
  final Country? marketCountry;
  final Unit unit;
  final DateTime startDate;
  final Decimal? quantity;
  final int? purityKarat;
  final int? purityFineness;
  final ZakatRule zakatRule;
  final Decimal? customZakatShare;
  final Country? inflationOverride;
  final String? notes;
  final Schedule? payoutSchedule;

  /// Fraction per year of the money in, > 0 (story §5.6).
  final Decimal? expectedProfit;
  final Schedule? valueCheckSchedule;

  /// Fraction per year, > −1.
  final Decimal? expectedGrowth;
  final ProfitBasis? profitBasis;
  final CapitalBack? capitalBack;
  final AccountKind? accountKind;
  final DateTime createdAt;
  final DateTime updatedAt;

  Investment withRule(ZakatRule rule, DateTime updatedAt) => Investment(
    id: id,
    name: name,
    type: type,
    intent: intent,
    market: market,
    marketCountry: marketCountry,
    unit: unit,
    startDate: startDate,
    quantity: quantity,
    purityKarat: purityKarat,
    purityFineness: purityFineness,
    zakatRule: rule,
    customZakatShare: customZakatShare,
    inflationOverride: inflationOverride,
    notes: notes,
    payoutSchedule: payoutSchedule,
    expectedProfit: expectedProfit,
    valueCheckSchedule: valueCheckSchedule,
    expectedGrowth: expectedGrowth,
    profitBasis: profitBasis,
    capitalBack: capitalBack,
    accountKind: accountKind,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Q2 first; Q1 counts only when a % is set (P-2, architect Q-E4).
  PeCase? get peCase {
    if (type != AssetType.privateEquity) return null;
    if (capitalBack == CapitalBack.yes) return PeCase.c;
    if (expectedProfit == null) {
      return switch (capitalBack) {
        CapitalBack.no => PeCase.a,
        CapitalBack.notSure => PeCase.notSure,
        _ => null,
      };
    }
    return switch ((profitBasis, capitalBack)) {
      (ProfitBasis.notSure, _) || (_, CapitalBack.notSure) => PeCase.notSure,
      (ProfitBasis.fixedPctOfMoney, CapitalBack.no) => PeCase.b,
      (ProfitBasis.shareOfProfit, CapitalBack.no) => PeCase.a,
      _ => null,
    };
  }

  /// Derived from the stored answers, so it follows every change (AC-66).
  bool get shariahRisk => peCase == PeCase.b;

  bool get conventionalDeposit =>
      type == AssetType.cashDeposit && accountKind == AccountKind.conventional;

  Country? get marketCountryResolved =>
      market == Market.other ? marketCountry : market?.country;
}

final class InvestmentWithHistory {
  const InvestmentWithHistory({
    required this.investment,
    this.history = const [],
  });

  final Investment investment;
  final List<HistoryEntry> history;
}

/// Pure metal in [gross] grams: gold grams × karat ÷ 24, silver × fineness ÷
/// 1000 (story §5). Every value of a metal item is pure grams.
Decimal pureGrams({
  required AssetType type,
  required Decimal gross,
  int? karat,
  int? fineness,
}) => type == AssetType.gold
    ? divide(gross * Decimal.fromInt(karat!), Decimal.fromInt(24))
    : divide(gross * Decimal.fromInt(fineness!), Decimal.fromInt(1000));

/// The gross grams that hold [pure] grams of metal; the inverse of [pureGrams].
Decimal grossGrams({
  required AssetType type,
  required Decimal pure,
  int? karat,
  int? fineness,
}) => type == AssetType.gold
    ? divide(pure * Decimal.fromInt(24), Decimal.fromInt(karat!))
    : divide(pure * Decimal.fromInt(1000), Decimal.fromInt(fineness!));
