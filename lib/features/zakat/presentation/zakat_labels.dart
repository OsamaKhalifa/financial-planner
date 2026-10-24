/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../core/dates.dart';
import '../../investments/presentation/widgets/labels.dart';
import '../domain/yearly_zakat.dart';

/// "1448 AH" or "2027": a year in the language on screen.
extension ZakatLabels on BuildContext {
  String yearLabel(YearSlot s) =>
      l10n.zakatYearLabel(s.calendar.name, '${s.number}');

  /// "1 Ramadan 1448 AH". Month names come from the app texts only.
  String hijriDate(DateTime d) {
    final h = hijriOf(d);
    return '${h.d} ${l10n.hijriMonth('${h.m}')} '
        '${l10n.zakatYearLabel('lunar', '${h.y}')}';
  }

  String stateName(YearView v) => l10n.zakatState(stateKey(v));

  /// "2.5 %", "2.577 %", "100 %": as many decimals as the number has.
  String percentPlain(Decimal fraction) {
    final parts = (fraction * Decimal.fromInt(100)).toString().split('.');
    return percent(
      fraction,
      digits: parts.length < 2 ? 0 : parts[1].length,
    ).replaceAll('+', '');
  }

  /// At least 2 and at most 4 decimals: a typed rate is shown as typed.
  String rateText(Decimal rate) {
    final fraction = rate.toString().split('.');
    final digits = fraction.length < 2 ? 2 : fraction[1].length.clamp(2, 4);
    return amount(rate, digits: digits);
  }

  /// The notification text. The date has no left-to-right isolates: a
  /// notification is plain text.
  String reminderText({
    required String label,
    required int daysBefore,
    required DateTime due,
  }) => daysBefore == 0
      ? l10n.reminderBodyToday(label)
      : l10n.reminderBodyOn(
          label,
          MaterialLocalizations.of(this).formatMediumDate(due),
        );

  String clockText(int minute) => MaterialLocalizations.of(this)
      .formatTimeOfDay(
        TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
        alwaysUse24HourFormat: true,
      );
}

/// A frozen year with nothing due never reads "Settled" alone (C11, AC-31).
String stateKey(YearView v) =>
    v.frozen && v.result.z == Decimal.zero ? 'belowNisab' : v.state.name;

String yearKeyText(DateTime key) => key.toIso8601String().substring(0, 10);

DateTime parseYearKey(String text) => DateTime.parse('${text}T00:00:00Z');
