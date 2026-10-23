/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' hide Intent;

import '../../../../core/dates.dart';
import '../../../../core/money/format.dart';
import '../../../../core/reference/countries.dart';
import '../../../../core/reference/markets.dart';
import '../../../../core/reference/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/investment.dart';

/// Names and number formats, always for the language on screen.
extension LabelContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get lang => Localizations.localeOf(this).languageCode;

  String amount(Decimal v, {bool signed = false, int digits = 2}) =>
      formatAmount(v, lang, signed: signed, digits: digits);

  String percent(Decimal fraction, {int digits = 2}) =>
      formatPercent(fraction, lang, digits: digits);

  String grams(Decimal v, {bool signed = false}) =>
      formatGrams(v, lang, signed: signed);

  String money(Decimal v, Unit unit, {bool signed = false}) => unit.isMetal
      ? grams(v, signed: signed)
      : l10n.amountWithUnit(amount(v, signed: signed), unit.code);

  String date(DateTime d) =>
      isolateLtr(MaterialLocalizations.of(this).formatMediumDate(d));

  String unitName(Unit u) => l10n.unitName(u.code.replaceAll('-', '_'));

  String countryName(Country c) => l10n.countryName(c.iso3);

  String marketName(Market m) =>
      l10n.marketName(m == Market.other ? 'otherMarket' : m.name);

  String pair(Unit from, Unit to) => isolateLtr('${from.code}→${to.code}');

  String assetTypeName(AssetType t) => l10n.assetTypeName(t);

  String intentName(Intent i) => l10n.intentName(i);
}

/// Without a [BuildContext], e.g. the English names of a sheet export.
extension LabelNames on AppLocalizations {
  String assetTypeName(AssetType t) => switch (t) {
    AssetType.stock => typeStock,
    AssetType.fund => typeFund,
    AssetType.sukuk => typeSukuk,
    AssetType.gold => typeGold,
    AssetType.silver => typeSilver,
    AssetType.cashDeposit => typeCash,
    AssetType.crypto => typeCrypto,
    AssetType.privateEquity => typePrivateEquity,
    AssetType.other => typeOther,
  };

  String intentName(Intent i) => switch (i) {
    Intent.trading => intentTrading,
    Intent.longTerm => intentLongTerm,
    Intent.personalUse => intentPersonalUse,
    Intent.rental => intentRental,
  };
}

DateTime dateOnly(DateTime d) => day(d.year, d.month, d.day);
