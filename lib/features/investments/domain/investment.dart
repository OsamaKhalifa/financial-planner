/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/ids.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import 'history_entry.dart';

enum AssetType { stock, fund, sukuk, gold, silver, cashDeposit, crypto, other }

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
  final DateTime createdAt;
  final DateTime updatedAt;

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
