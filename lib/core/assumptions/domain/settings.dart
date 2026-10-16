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

final class Settings {
  const Settings({
    this.baseCurrency,
    this.homeInflation,
    this.zakatYear,
    this.longTermMethod,
    this.jewelleryZakatable,
  });

  final Unit? baseCurrency;
  final Country? homeInflation;

  /// Null means the user has not answered yet (AC-8).
  final ZakatYear? zakatYear;
  final LongTermMethod? longTermMethod;
  final bool? jewelleryZakatable;

  bool get setupDone => baseCurrency != null && zakatYear != null;

  Country? get homeCountry =>
      homeInflation ??
      (baseCurrency == null ? null : defaultCountryOf(baseCurrency!));
}
