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

  String percent(Decimal fraction) => formatPercent(fraction, lang);

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

  String assetTypeName(AssetType t) => switch (t) {
    AssetType.stock => l10n.typeStock,
    AssetType.fund => l10n.typeFund,
    AssetType.sukuk => l10n.typeSukuk,
    AssetType.gold => l10n.typeGold,
    AssetType.silver => l10n.typeSilver,
    AssetType.cashDeposit => l10n.typeCash,
    AssetType.crypto => l10n.typeCrypto,
    AssetType.other => l10n.typeOther,
  };

  String intentName(Intent i) => switch (i) {
    Intent.trading => l10n.intentTrading,
    Intent.longTerm => l10n.intentLongTerm,
    Intent.personalUse => l10n.intentPersonalUse,
    Intent.rental => l10n.intentRental,
  };
}

DateTime dateOnly(DateTime d) => day(d.year, d.month, d.day);
