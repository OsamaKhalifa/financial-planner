/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/assumptions/domain/settings.dart';
import '../../../../core/dates.dart';
import 'labels.dart';

/// Parses what the user typed; Latin and Arabic-Indic digits, "," or "٫" as the
/// decimal mark are accepted. Null when it is not a number.
Decimal? parseAmount(String text) {
  var t = text.trim().replaceAll(RegExp('[\\s,٬]'), '').replaceAll('٫', '.');
  t = t.replaceAllMapped(
    RegExp('[٠-٩]'),
    (m) => '${m[0]!.codeUnitAt(0) - 0x0660}',
  );
  return Decimal.tryParse(t);
}

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    this.error,
    this.suffix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? error;
  final String? suffix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    textDirection: TextDirection.ltr,
    decoration: InputDecoration(
      labelText: label,
      errorText: error,
      suffixText: suffix,
    ),
    onChanged: onChanged,
  );
}

/// A date shown as text; tapping opens a picker that offers no future days
/// (AC-2).
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.lastDate,
    required this.onChanged,
    this.firstDate,
    this.error,
    this.helper,
  });

  final String label;
  final DateTime value;
  final DateTime lastDate;
  final DateTime? firstDate;
  final String? error;
  final String? helper;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: value.isAfter(lastDate) ? lastDate : value,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate,
      );
      if (picked != null) onChanged(dateOnly(picked));
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        helperText: helper,
        helperMaxLines: 2,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      child: Text(context.date(value)),
    ),
  );
}

/// A day of the month fits the month; a lunar month may always have 30 days
/// (the 29th is used when it has 29, C3), and February always has 29 because
/// the date has no year.
bool cycleDateFits(ZakatYear calendar, int month, int dayOfMonth) =>
    dayOfMonth <= _cycleDays(calendar, month);

int _cycleDays(ZakatYear calendar, int? month) => switch (calendar) {
  ZakatYear.lunar => 30,
  ZakatYear.solar => month == null ? 31 : endOfMonth(day(2000, month, 1)).day,
};

/// A month of the zakat calendar by its own names: Hijri names from the app
/// texts, Gregorian ones from the locale.
String cycleMonthName(BuildContext context, ZakatYear calendar, int m) =>
    switch (calendar) {
      ZakatYear.lunar => context.l10n.hijriMonth('$m'),
      ZakatYear.solar => DateFormat.MMMM(
        Localizations.localeOf(context).toString(),
      ).format(DateTime(2000, m)),
    };

/// Z3: the zakat cycle date has no year, so it is two dropdowns, Month and
/// Day, in the calendar of the zakat year. Both start empty (AC-1).
class CycleDateField extends StatelessWidget {
  const CycleDateField({
    super.key,
    required this.calendar,
    required this.month,
    required this.day,
    required this.onChanged,
  });

  final ZakatYear calendar;
  final int? month;
  final int? day;
  final void Function(int? month, int? day) onChanged;

  @override
  Widget build(BuildContext context) {
    final error = _error(context);
    final hint = _hint(context);
    // Stacked at every width: half a phone is too narrow for "Jumada
    // al-Akhirah" or its Arabic name, and the menu has no ellipsis.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _monthMenu(context),
            const SizedBox(height: 12),
            _dayMenu(context),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              key: const ValueKey('cycle-error'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          )
        else if (hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              hint,
              key: const ValueKey('cycle-hint'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  String _monthName(BuildContext context, int m) =>
      cycleMonthName(context, calendar, m);

  String _monthLabel(BuildContext context, int m) => calendar == ZakatYear.lunar
      ? '$m · ${_monthName(context, m)}'
      : _monthName(context, m);

  Widget _monthMenu(BuildContext context) {
    final m = month;
    final menu = _monthDropdown(context);
    return m == null
        ? menu
        : Semantics(
            label: context.l10n.zakatMonthSemantics(
              _monthName(context, m),
              '$m',
            ),
            child: menu,
          );
  }

  Widget _monthDropdown(BuildContext context) => DropdownMenu<int>(
    key: ValueKey('cycle-month-${calendar.name}'),
    expandedInsets: EdgeInsets.zero,
    initialSelection: month,
    label: Text(context.l10n.zakatSetupMonth),
    requestFocusOnTap: false,
    onSelected: (m) => onChanged(m, day),
    dropdownMenuEntries: [
      for (var m = 1; m <= 12; m++)
        DropdownMenuEntry(value: m, label: _monthLabel(context, m)),
    ],
  );

  Widget _dayMenu(BuildContext context) {
    final d = day;
    final menu = _dayDropdown(context);
    return d == null
        ? menu
        : Semantics(label: context.l10n.zakatDaySemantics('$d'), child: menu);
  }

  Widget _dayDropdown(BuildContext context) {
    final days = _cycleDays(calendar, month);
    return DropdownMenu<int>(
      key: ValueKey('cycle-day-${calendar.name}'),
      expandedInsets: EdgeInsets.zero,
      initialSelection: day,
      label: Text(context.l10n.zakatSetupDay),
      requestFocusOnTap: false,
      onSelected: (d) => onChanged(month, d),
      dropdownMenuEntries: [
        for (var d = 1; d <= 31; d++)
          DropdownMenuEntry(value: d, label: '$d', enabled: d <= days),
      ],
    );
  }

  String? _error(BuildContext context) {
    final m = month;
    final d = day;
    if (m == null || d == null || cycleDateFits(calendar, m, d)) return null;
    return context.l10n.zakatBadDay(
      _monthName(context, m),
      '${_cycleDays(calendar, m)}',
    );
  }

  String? _hint(BuildContext context) {
    final l10n = context.l10n;
    if (calendar == ZakatYear.lunar && day == 30) return l10n.zakatDay30;
    if (calendar == ZakatYear.solar && month == 2 && day == 29) {
      return l10n.zakatFeb29;
    }
    return null;
  }
}
