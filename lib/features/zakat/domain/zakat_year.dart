/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/ids.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/units.dart';
import '../../investments/domain/zakat_rules.dart';

enum ExtraKind { cash, owedToMe }

/// Wealth outside My Investments, typed on one year (story §6.2).
final class ExtraLine {
  ExtraLine({
    String? id,
    required this.label,
    required this.kind,
    required this.amount,
    required this.goodDebtConfirmed,
  }) : id = id ?? newId();

  final String id;
  final String label;
  final ExtraKind kind;
  final Money amount;

  /// The user said the debtor is able and willing to pay (B9).
  final bool goodDebtConfirmed;
}

/// The inputs of one line as they stood when the year was started (Z10).
final class FrozenLine {
  const FrozenLine({
    this.refId,
    this.isExtra = false,
    this.extraKind,
    required this.name,
    required this.unit,
    required this.value,
    required this.heldInterest,
    this.valueDate,
    this.rate,
    this.rateDate,
    required this.share,
    required this.section,
    this.notice,
  });

  /// The investment or extra-line id; an item deleted since stays here.
  final String? refId;
  final bool isExtra;
  final ExtraKind? extraKind;
  final String name;
  final Unit unit;
  final Decimal value;
  final Decimal heldInterest;
  final DateTime? valueDate;
  final Decimal? rate;
  final DateTime? rateDate;
  final Decimal share;
  final String section;
  final ZakatNotice? notice;
}

final class FrozenYear {
  const FrozenYear({
    required this.startedOn,
    required this.base,
    required this.nisab,
    required this.metalRate,
    required this.metalRateDate,
    required this.lines,
  });

  final DateTime startedOn;
  final Unit base;
  final NisabMetal nisab;
  final Decimal metalRate;
  final DateTime metalRateDate;
  final List<FrozenLine> lines;
}

/// One amount given. [rate], [rateDate] and [view] are all null when the unit
/// is the year's base (Z11).
final class Gift {
  Gift({
    String? id,
    required this.date,
    required this.amount,
    this.rate,
    this.rateDate,
    this.view,
    this.note,
  }) : id = id ?? newId();

  final String id;
  final DateTime date;
  final Money amount;
  final Decimal? rate;
  final DateTime? rateDate;
  final GivingRateView? view;
  final String? note;
}

/// Everything the user decided about one year. A year with no record reads as:
/// no move, debts 0, deduction on, no extras, not frozen, no gifts (AC-18).
final class ZakatYearRecord {
  const ZakatYearRecord({
    required this.dueKey,
    this.movedDue,
    required this.debts,
    required this.deductDebts,
    this.extras = const [],
    this.frozen,
    this.gifts = const [],
  });

  final DateTime dueKey;
  final DateTime? movedDue;
  final Decimal debts;
  final bool deductDebts;
  final List<ExtraLine> extras;
  final FrozenYear? frozen;
  final List<Gift> gifts;
}
