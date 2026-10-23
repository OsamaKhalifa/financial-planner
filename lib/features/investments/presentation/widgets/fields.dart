/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

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
