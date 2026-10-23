/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import 'history_entry.dart';
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
  startAfterRecord,
  shareRequired,
  answerLongTermMethod,
  answerJewellery,
  planNotForType,
  profitNeedsSchedule,
  growthNeedsSchedule,
  profitNotPositive,
  growthTooLow,
  answerProfitBasis,
  answerCapitalBack,
  answerAccountKind,
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
    this.payoutSchedule,
    this.expectedProfit,
    this.valueCheckSchedule,
    this.expectedGrowth,
    this.profitBasis,
    this.capitalBack,
    this.accountKind,
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
  final Schedule? payoutSchedule;
  final Decimal? expectedProfit;
  final Schedule? valueCheckSchedule;
  final Decimal? expectedGrowth;
  final ProfitBasis? profitBasis;
  final CapitalBack? capitalBack;
  final AccountKind? accountKind;
}

/// Gold, silver and crypto pay nothing in hand; gold and silver move with
/// the metal rate (story §5.6 table).
bool payoutPlanAllowed(AssetType t) =>
    t != AssetType.gold && t != AssetType.silver && t != AssetType.crypto;

bool valuePlanAllowed(AssetType t) =>
    t != AssetType.gold && t != AssetType.silver;

/// AC-1, AC-2, AC-7, AC-8: every problem is named; nothing is defaulted
/// silently.
List<DraftError> validate(
  InvestmentDraft d, {
  required DateTime today,
  required Settings settings,
  DateTime? latestStart,
}) {
  final errors = <DraftError>[];
  if (d.name == null || d.name!.trim().isEmpty) {
    errors.add(DraftError.missingName);
  }
  if (d.unit == null) errors.add(DraftError.missingUnit);
  _checkDates(d, today, latestStart, errors);
  _checkFirstPaid(d, errors);
  final type = d.type;
  if (type == null) {
    errors.addAll([DraftError.missingType, DraftError.shareRequired]);
    return errors;
  }
  _checkTypeFields(d, type, errors);
  _checkShare(d, type, settings, errors);
  _checkPlan(d, type, errors);
  return errors;
}

void _checkDates(
  InvestmentDraft d,
  DateTime today,
  DateTime? latestStart,
  List<DraftError> errors,
) {
  final start = d.startDate;
  if (start == null) {
    errors.add(DraftError.missingStartDate);
  } else if (start.isAfter(today)) {
    errors.add(DraftError.futureDate);
  } else if (latestStart != null && start.isAfter(latestStart)) {
    errors.add(DraftError.startAfterRecord);
  }
}

/// AC-77: the records the add form wrote on the start date, which move with
/// it — the first money in and, for metals, the value bought.
(MoneyIn?, ValueUpdate?) _onStart(Investment item, List<HistoryEntry> history) {
  final onStart = history.where((e) => e.date == item.startDate);
  return (
    onStart.whereType<MoneyIn>().firstOrNull,
    item.unit.isMetal ? onStart.whereType<ValueUpdate>().firstOrNull : null,
  );
}

List<HistoryEntry> startRecords(Investment item, List<HistoryEntry> history) {
  final (paid, bought) = _onStart(item, history);
  return [?paid, ?bought];
}

List<HistoryEntry> startRecordsMovedTo(
  Investment item,
  List<HistoryEntry> history,
  DateTime to,
) {
  final (paid, bought) = _onStart(item, history);
  return [
    if (paid != null)
      MoneyIn(
        id: paid.id,
        investmentId: paid.investmentId,
        date: to,
        amount: paid.amount,
        createdAt: paid.createdAt,
      ),
    if (bought != null)
      ValueUpdate(
        id: bought.id,
        investmentId: bought.investmentId,
        date: to,
        value: bought.value,
        createdAt: bought.createdAt,
      ),
  ];
}

/// AC-77: the start may not pass a record that stays where it is.
DateTime? latestStart(Investment item, List<HistoryEntry> history) {
  final moving = startRecords(item, history).toSet();
  return history
      .where((e) => !moving.contains(e))
      .map((e) => e.date)
      .fold<DateTime?>(null, (a, b) => a == null || b.isBefore(a) ? b : a);
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
  final needsIntent =
      type == AssetType.stock ||
      type == AssetType.fund ||
      type == AssetType.other;
  if (needsIntent && d.intent == null) errors.add(DraftError.missingIntent);
  if (type == AssetType.privateEquity &&
      d.intent != Intent.trading &&
      d.intent != Intent.longTerm) {
    errors.add(DraftError.missingIntent);
  }
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
  if (type == AssetType.privateEquity) {
    _checkPrivateEquityShare(d, errors);
    return;
  }
  final rule = d.zakatRule ?? defaultRule(type, d.intent, settings);
  final stockLike = type == AssetType.stock || type == AssetType.fund;
  if (rule == null) {
    if (stockLike && d.intent == null) return;
    final longTerm =
        stockLike &&
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

const _privateEquityLongTerm = {
  ZakatRule.custom,
  ZakatRule.longTermDividendsOnly,
  ZakatRule.longTermFullValue,
};

/// P-1: trading → 100 %; long-term → one of three methods, never the 25 %
/// proxy; case C needs no pick (spec E6).
void _checkPrivateEquityShare(InvestmentDraft d, List<DraftError> errors) {
  if (d.capitalBack == CapitalBack.yes || d.intent == Intent.trading) return;
  if (d.intent != Intent.longTerm) return;
  final rule = d.zakatRule;
  if (rule == null || !_privateEquityLongTerm.contains(rule)) {
    errors.add(DraftError.shareRequired);
  } else if (rule == ZakatRule.custom) {
    final share = d.customZakatShare;
    if (share == null || share < Decimal.zero || share > Decimal.one) {
      errors.add(DraftError.shareRequired);
    }
  }
}

/// AC-48, AC-64, AC-70.
void _checkPlan(InvestmentDraft d, AssetType type, List<DraftError> errors) {
  final payout = d.payoutSchedule != null || d.expectedProfit != null;
  final value = d.valueCheckSchedule != null || d.expectedGrowth != null;
  if ((payout && !payoutPlanAllowed(type)) ||
      (value && !valuePlanAllowed(type))) {
    errors.add(DraftError.planNotForType);
  }
  final profit = d.expectedProfit;
  if (profit != null && d.payoutSchedule == null) {
    errors.add(DraftError.profitNeedsSchedule);
  }
  if (profit != null && profit <= Decimal.zero) {
    errors.add(DraftError.profitNotPositive);
  }
  final growth = d.expectedGrowth;
  if (growth != null && d.valueCheckSchedule == null) {
    errors.add(DraftError.growthNeedsSchedule);
  }
  if (growth != null && growth <= -Decimal.one) {
    errors.add(DraftError.growthTooLow);
  }
  if (type == AssetType.privateEquity) {
    if (d.capitalBack == null) errors.add(DraftError.answerCapitalBack);
    if (profit != null && d.profitBasis == null) {
      errors.add(DraftError.answerProfitBasis);
    }
  }
  if (type == AssetType.cashDeposit &&
      d.payoutSchedule != null &&
      d.accountKind == null) {
    errors.add(DraftError.answerAccountKind);
  }
}
