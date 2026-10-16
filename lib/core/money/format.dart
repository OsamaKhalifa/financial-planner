/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:intl/number_symbols_data.dart';

const _lri = '\u2066';
const _pdi = '\u2069';
const _minus = '−';

/// Keeps "+15.50 %" and "1,050.00 USD" in left-to-right order inside Arabic
/// text (UX §6).
String isolateLtr(String s) => '$_lri$s$_pdi';

/// Rounds half-up to [digits] places, groups with the language's symbols and
/// never goes through a binary float.
String formatAmount(
  Decimal value,
  String languageCode, {
  int digits = 2,
  bool signed = false,
}) => isolateLtr(_number(value, languageCode, digits, signed));

/// [fraction] is 0.1550 for 15.50 %. Always shows the sign.
String formatPercent(
  Decimal fraction,
  String languageCode, {
  int digits = 2,
}) => isolateLtr(
  '${_number(fraction * Decimal.fromInt(100), languageCode, digits, true)} %',
);

String formatGrams(Decimal grams, String languageCode, {bool signed = false}) =>
    isolateLtr('${_number(grams, languageCode, 2, signed)} g');

String _number(Decimal value, String languageCode, int digits, bool signed) {
  final symbols =
      numberFormatSymbols[languageCode] ?? numberFormatSymbols['en']!;
  final rounded = value.round(scale: digits);
  final text = rounded.abs().toStringAsFixed(digits);
  final parts = text.split('.');
  final grouped = _group(parts[0], symbols.GROUP_SEP);
  final body = parts.length > 1
      ? '$grouped${symbols.DECIMAL_SEP}${parts[1]}'
      : grouped;
  final zero = symbols.ZERO_DIGIT.codeUnitAt(0);
  final digitsLocalised = body.replaceAllMapped(
    RegExp('[0-9]'),
    (m) => String.fromCharCode(zero + int.parse(m[0]!)),
  );
  final sign = rounded < Decimal.zero
      ? _minus
      : (signed && rounded > Decimal.zero ? '+' : '');
  return '$sign$digitsLocalised';
}

String _group(String digits, String separator) {
  final out = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write(separator);
    out.write(digits[i]);
  }
  return out.toString();
}
