/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'countries.dart';
import 'units.dart';

enum Market {
  tadawul(Country('SAU'), Unit('SAR')),
  egx(Country('EGY'), Unit('EGP')),
  nasdaq(Country('USA'), Unit('USD')),
  nyse(Country('USA'), Unit('USD')),
  lse(Country('GBR'), Unit('GBP')),
  dfm(Country('ARE'), Unit('AED')),
  adx(Country('ARE'), Unit('AED')),
  boursaKuwait(Country('KWT'), Unit('KWD')),
  qse(Country('QAT'), Unit('QAR')),
  bursaMalaysia(Country('MYS'), Unit('MYR')),
  bist(Country('TUR'), Unit('TRY')),
  psx(Country('PAK'), Unit('PKR')),
  other(null, null);

  const Market(this.country, this.currency);

  /// Null for [other]: the country is stored on the investment.
  final Country? country;
  final Unit? currency;
}
