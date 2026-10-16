/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:convert';

import 'package:decimal/decimal.dart';

import '../../dates.dart';
import '../../ids.dart';
import '../../money/decimal_math.dart';
import '../../reference/countries.dart';

/// All rates in this file are fractions (0.10 = 10 %).
enum InflationProvenance { shipped, user, assumed }

final class YearInflation {
  const YearInflation({
    required this.rate,
    required this.year,
    required this.provenance,
    this.assumedFrom,
  });

  final Decimal rate;
  final int year;
  final InflationProvenance provenance;
  final int? assumedFrom;
}

final class PeriodInflation {
  const PeriodInflation(this.i, this.years);

  final Decimal i;
  final List<YearInflation> years;
}

final class ShippedInflation {
  const ShippedInflation({
    this.source = '',
    this.asOfNote = '',
    required this.series,
  });

  final String source;
  final String asOfNote;
  final Map<Country, Map<int, Decimal>> series;

  /// Asset format of ADR-0004: values are percent strings, stored as fractions.
  static ShippedInflation parse(String json) {
    final m = jsonDecode(json) as Map<String, dynamic>;
    final raw = m['series'] as Map<String, dynamic>;
    final hundred = Decimal.fromInt(100);
    return ShippedInflation(
      source: m['source'] as String,
      asOfNote: (m['sourceLastUpdated'] ?? '') as String,
      series: {
        for (final c in raw.entries)
          Country(c.key): {
            for (final y in (c.value as Map<String, dynamic>).entries)
              int.parse(y.key): divide(
                Decimal.parse(y.value as String),
                hundred,
              ),
          },
      },
    );
  }

  /// The "as of" year of a series: its last present year.
  int? lastYear(Country c) {
    final years = series[c]?.keys;
    return years == null || years.isEmpty ? null : years.reduce(_max);
  }
}

int _max(int a, int b) => a > b ? a : b;

final class InflationOverride {
  InflationOverride({
    String? id,
    required this.country,
    required this.year,
    required this.rate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? newId(),
       createdAt = createdAt ?? DateTime.utc(1970),
       updatedAt = updatedAt ?? createdAt ?? DateTime.utc(1970);

  final String id;
  final Country country;
  final int year;
  final Decimal rate;
  final DateTime createdAt;
  final DateTime updatedAt;
}

final class InflationBook {
  InflationBook(this.shipped, List<InflationOverride> overrides)
    : _overrides = {for (final o in overrides) (o.country, o.year): o.rate};

  final ShippedInflation shipped;
  final Map<(Country, int), Decimal> _overrides;

  /// Override, then shipped, then the latest earlier year (assumed), else null
  /// (AC-32, AC-33).
  YearInflation? forYear(Country c, int year) {
    final exact = _exact(c, year);
    if (exact != null) return exact;
    final years = <int>{
      ...?shipped.series[c]?.keys,
      for (final k in _overrides.keys)
        if (k.$1 == c) k.$2,
    }.where((y) => y < year);
    if (years.isEmpty) return null;
    final from = years.reduce(_max);
    final base = _exact(c, from)!;
    return YearInflation(
      rate: base.rate,
      year: year,
      provenance: InflationProvenance.assumed,
      assumedFrom: from,
    );
  }

  /// Story §8.2: product over the years touched of (1 + π)^(d / D) − 1, where
  /// d counts the days after [s] up to and including [e] that fall in the year.
  PeriodInflation? forPeriod(Country c, DateTime s, DateTime e) {
    var factor = Decimal.one;
    final years = <YearInflation>[];
    for (var y = s.year; y <= e.year; y++) {
      final lo = later(s, day(y - 1, 12, 31));
      final hi = earlier(e, day(y, 12, 31));
      final d = daysBetween(lo, hi);
      if (d <= 0) continue;
      final yi = forYear(c, y);
      if (yi == null) return null;
      years.add(yi);
      factor *= powRatio(
        Decimal.one + yi.rate,
        divide(Decimal.fromInt(d), Decimal.fromInt(daysInYear(y))),
      );
    }
    return PeriodInflation(factor - Decimal.one, years);
  }

  YearInflation? _exact(Country c, int year) {
    final user = _overrides[(c, year)];
    if (user != null) {
      return YearInflation(
        rate: user,
        year: year,
        provenance: InflationProvenance.user,
      );
    }
    final shippedRate = shipped.series[c]?[year];
    if (shippedRate == null) return null;
    return YearInflation(
      rate: shippedRate,
      year: year,
      provenance: InflationProvenance.shipped,
    );
  }
}
