/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/ids.dart';
import '../../../core/money/money.dart';

sealed class HistoryEntry {
  HistoryEntry({
    String? id,
    required this.investmentId,
    required this.date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? newId(),
       createdAt = createdAt ?? DateTime.utc(1970),
       updatedAt = updatedAt ?? createdAt ?? DateTime.utc(1970);

  final String id;
  final String investmentId;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
}

final class MoneyIn extends HistoryEntry {
  MoneyIn({
    super.id,
    required super.investmentId,
    required super.date,
    required this.amount,
    super.createdAt,
    super.updatedAt,
  });

  final Money amount;
}

enum MoneyOutKind { sale, income }

final class MoneyOut extends HistoryEntry {
  MoneyOut({
    super.id,
    required super.investmentId,
    required super.date,
    required this.amount,
    this.kind = MoneyOutKind.sale,
    super.createdAt,
    super.updatedAt,
  });

  final Money amount;
  final MoneyOutKind kind;
}

enum InterestKind {
  keptInside,
  paidOut,
  givenAwayFromInside,
  givenAwayFromPaidOut,
}

final class InterestRecord extends HistoryEntry {
  InterestRecord({
    super.id,
    required super.investmentId,
    required super.date,
    required this.amount,
    required this.kind,
    super.createdAt,
    super.updatedAt,
  });

  final Money amount;
  final InterestKind kind;
}

/// Value in the item unit; for metals, pure grams.
final class ValueUpdate extends HistoryEntry {
  ValueUpdate({
    super.id,
    required super.investmentId,
    required super.date,
    required this.value,
    super.createdAt,
    super.updatedAt,
  });

  final Decimal value;
}

enum PlanKind { payout, value }

/// The user's "skip" on a pending row (story §5.6), dated on the schedule
/// date. A decision, never an actual record: the timeline drops it.
final class PlanSkip extends HistoryEntry {
  PlanSkip({
    super.id,
    required super.investmentId,
    required super.date,
    required this.plan,
    super.createdAt,
    super.updatedAt,
  });

  final PlanKind plan;
}
