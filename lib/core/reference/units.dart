/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'countries.dart';

extension type const Unit(String code) {
  static const xauG = Unit('XAU-g');
  static const xagG = Unit('XAG-g');

  bool get isMetal => code.endsWith('-g');
}

const xauG = Unit.xauG;
const xagG = Unit.xagG;

const _countryOfCurrency = <Unit, Country>{
  Unit('AED'): Country('ARE'),
  Unit('AUD'): Country('AUS'),
  Unit('BDT'): Country('BGD'),
  Unit('BHD'): Country('BHR'),
  Unit('CAD'): Country('CAN'),
  Unit('CHF'): Country('CHE'),
  Unit('CNY'): Country('CHN'),
  Unit('DKK'): Country('DNK'),
  Unit('DZD'): Country('DZA'),
  Unit('EGP'): Country('EGY'),
  Unit('EUR'): Country('EMU'),
  Unit('GBP'): Country('GBR'),
  Unit('HKD'): Country('HKG'),
  Unit('IDR'): Country('IDN'),
  Unit('INR'): Country('IND'),
  Unit('JOD'): Country('JOR'),
  Unit('JPY'): Country('JPN'),
  Unit('KWD'): Country('KWT'),
  Unit('MAD'): Country('MAR'),
  Unit('MYR'): Country('MYS'),
  Unit('NGN'): Country('NGA'),
  Unit('NOK'): Country('NOR'),
  Unit('OMR'): Country('OMN'),
  Unit('PKR'): Country('PAK'),
  Unit('QAR'): Country('QAT'),
  Unit('SAR'): Country('SAU'),
  Unit('SEK'): Country('SWE'),
  Unit('SGD'): Country('SGP'),
  Unit('TND'): Country('TUN'),
  Unit('TRY'): Country('TUR'),
  Unit('USD'): Country('USA'),
  Unit('ZAR'): Country('ZAF'),
};

/// 32 currencies: the ADR-0002 list plus SEK, NOK, DKK (story §6.3), by code.
final List<Unit> v1Currencies = List.unmodifiable(
  <Unit>[..._countryOfCurrency.keys]..sort(_byCode),
);

final List<Unit> allUnits = List.unmodifiable(
  <Unit>[...v1Currencies, xauG, xagG]..sort(_byCode),
);

int _byCode(Unit a, Unit b) => a.code.compareTo(b.code);

Country defaultCountryOf(Unit unit) {
  final country = _countryOfCurrency[unit];
  if (country == null) {
    throw ArgumentError.value(unit.code, 'unit', 'has no default country');
  }
  return country;
}

/// Top group: [topAnchor] plus the 4 most used units, ordered by use then code;
/// then every other unit by code (story §6.3).
List<Unit> orderedUnits({
  required Map<Unit, int> usage,
  required Unit topAnchor,
}) {
  int uses(Unit u) => usage[u] ?? 0;
  int byUse(Unit a, Unit b) {
    final c = uses(b).compareTo(uses(a));
    return c != 0 ? c : _byCode(a, b);
  }

  final others = usage.keys.where((u) => u != topAnchor && uses(u) > 0).toList()
    ..sort(byUse);
  final top = [topAnchor, ...others.take(4)]..sort(byUse);
  final rest = allUnits.where((u) => !top.contains(u));
  return [...top, ...rest];
}
