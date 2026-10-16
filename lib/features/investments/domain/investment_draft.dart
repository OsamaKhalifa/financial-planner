/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import 'investment.dart';
import 'zakat_rules.dart';

enum DraftError {
  missingName,
  missingType,
  missingIntent,
  missingMarket,
  missingMarketCountry,
  missingUnit,
  missingStartDate,
  missingFirstPaid,
  missingGrams,
  missingPurity,
  zeroAmount,
  futureDate,
  shareRequired,
  answerLongTermMethod,
  answerJewellery,
}

final class InvestmentDraft {
  const InvestmentDraft({
    this.name,
    this.type,
    this.intent,
    this.market,
    this.marketCountry,
    this.unit,
    this.startDate,
    this.firstPaid,
    this.currentValue,
    this.grossGrams,
    this.purityKarat,
    this.purityFineness,
    this.quantity,
    this.zakatRule,
    this.customZakatShare,
  });

  final String? name;
  final AssetType? type;
  final Intent? intent;
  final Market? market;
  final Country? marketCountry;
  final Unit? unit;
  final DateTime? startDate;
  final Money? firstPaid;
  final Decimal? currentValue;
  final Decimal? grossGrams;
  final int? purityKarat;
  final int? purityFineness;
  final Decimal? quantity;

  /// The rule the user chose or confirmed; null = take the default.
  final ZakatRule? zakatRule;
  final Decimal? customZakatShare;
}

/// AC-1, AC-2, AC-7, AC-8: every problem is named; nothing is defaulted
/// silently.
List<DraftError> validate(
  InvestmentDraft d, {
  required DateTime today,
  required Settings settings,
}) {
  final errors = <DraftError>[];
  if (d.name == null || d.name!.trim().isEmpty) errors.add(DraftError.missingName);
  if (d.unit == null) errors.add(DraftError.missingUnit);
  _checkDates(d, today, errors);
  _checkFirstPaid(d, errors);
  final type = d.type;
  if (type == null) {
    errors.addAll([DraftError.missingType, DraftError.shareRequired]);
    return errors;
  }
  _checkTypeFields(d, type, errors);
  _checkShare(d, type, settings, errors);
  return errors;
}

void _checkDates(InvestmentDraft d, DateTime today, List<DraftError> errors) {
  final start = d.startDate;
  if (start == null) {
    errors.add(DraftError.missingStartDate);
  } else if (start.isAfter(today)) {
    errors.add(DraftError.futureDate);
  }
}

void _checkFirstPaid(InvestmentDraft d, List<DraftError> errors) {
  final paid = d.firstPaid;
  if (paid == null) {
    errors.add(DraftError.missingFirstPaid);
  } else if (paid.amount <= Decimal.zero) {
    errors.add(DraftError.zeroAmount);
  }
}

void _checkTypeFields(
  InvestmentDraft d,
  AssetType type,
  List<DraftError> errors,
) {
  if (type == AssetType.stock) {
    if (d.market == null) errors.add(DraftError.missingMarket);
    if (d.market == Market.other && d.marketCountry == null) {
      errors.add(DraftError.missingMarketCountry);
    }
  }
  final needsIntent = type == AssetType.stock ||
      type == AssetType.fund ||
      type == AssetType.other;
  if (needsIntent && d.intent == null) errors.add(DraftError.missingIntent);
  if (type == AssetType.gold || type == AssetType.silver) {
    if (d.grossGrams == null || d.grossGrams! <= Decimal.zero) {
      errors.add(DraftError.missingGrams);
    }
    final purity = type == AssetType.gold ? d.purityKarat : d.purityFineness;
    if (purity == null) errors.add(DraftError.missingPurity);
  }
}

void _checkShare(
  InvestmentDraft d,
  AssetType type,
  Settings settings,
  List<DraftError> errors,
) {
  final rule = d.zakatRule ?? defaultRule(type, d.intent, settings);
  final stockLike = type == AssetType.stock || type == AssetType.fund;
  if (rule == null) {
    if (stockLike && d.intent == null) return;
    final longTerm = stockLike &&
        d.intent == Intent.longTerm &&
        settings.longTermMethod == null;
    errors.add(
      longTerm ? DraftError.answerLongTermMethod : DraftError.shareRequired,
    );
    return;
  }
  if (rule == ZakatRule.custom) {
    final share = d.customZakatShare;
    if (share == null || share < Decimal.zero || share > Decimal.one) {
      errors.add(DraftError.shareRequired);
    }
  }
  if (rule == ZakatRule.jewelleryPerSetting &&
      settings.jewelleryZakatable == null) {
    errors.add(DraftError.answerJewellery);
  }
}
