/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../reference/countries.dart';
import '../../reference/units.dart';

/// A matched pair (AC-9): the rate and the year length are never mixed.
enum ZakatYear {
  lunar('0.025', '354.367'),
  solar('0.02577', '365');

  const ZakatYear(this._r, this._days);

  final String _r;
  final String _days;

  Decimal get r => Decimal.parse(_r);
  Decimal get days => Decimal.parse(_days);
}

enum LongTermMethod { dividendsOnly, proxy25, fullValue, perItem }

/// Grams live in the zakat domain (A3).
enum NisabMetal { gold, silver }

enum GivingRateView { dayGiven, dueDate }

final class ZakatPrefs {
  const ZakatPrefs({
    this.nisab,
    this.reminderOn = true,
    this.reminderDays = 0,
    this.reminderMinute = 540,
    this.reminderAsked = false,
    this.givingRateView,
  });

  /// Null means not asked yet (AC-7).
  final NisabMetal? nisab;
  final bool reminderOn;
  final int reminderDays;
  final int reminderMinute;

  /// The OS prompt is shown once (AC-34).
  final bool reminderAsked;

  /// Null means not asked yet (AC-30).
  final GivingRateView? givingRateView;

  ZakatPrefs copyWith({
    NisabMetal? nisab,
    bool? reminderOn,
    int? reminderDays,
    int? reminderMinute,
    bool? reminderAsked,
    GivingRateView? givingRateView,
  }) => ZakatPrefs(
    nisab: nisab ?? this.nisab,
    reminderOn: reminderOn ?? this.reminderOn,
    reminderDays: reminderDays ?? this.reminderDays,
    reminderMinute: reminderMinute ?? this.reminderMinute,
    reminderAsked: reminderAsked ?? this.reminderAsked,
    givingRateView: givingRateView ?? this.givingRateView,
  );
}

/// In core because [AssumptionsRepository] speaks it.
final class ZakatCycle {
  const ZakatCycle({
    this.id,
    required this.calendar,
    required this.month,
    required this.day,
    required this.from,
  });

  final String? id;
  final ZakatYear calendar;
  final int month;
  final int day;
  final DateTime from;
}

final class Settings {
  const Settings({
    this.baseCurrency,
    this.homeInflation,
    this.zakatYear,
    this.longTermMethod,
    this.jewelleryZakatable,
    this.zakat = const ZakatPrefs(),
  });

  final Unit? baseCurrency;
  final Country? homeInflation;

  /// Null means the user has not answered yet (AC-8).
  final ZakatYear? zakatYear;
  final LongTermMethod? longTermMethod;
  final bool? jewelleryZakatable;
  final ZakatPrefs zakat;

  bool get setupDone => baseCurrency != null && zakatYear != null;

  Country? get homeCountry =>
      homeInflation ??
      (baseCurrency == null ? null : defaultCountryOf(baseCurrency!));
}
