/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/assumptions/assumptions_providers.dart';
import '../../../../core/assumptions/domain/inflation.dart';
import '../../../../core/reference/countries.dart';
import 'labels.dart';

/// Where an inflation figure comes from (UX 2.9); null when there is nothing
/// to say.
String? inflationTag(
  BuildContext context,
  WidgetRef ref,
  Country country,
  PeriodInflation? inflation,
) {
  final l10n = context.l10n;
  final name = context.countryName(country);
  if (inflation == null) return l10n.inflationEmpty(name);
  for (final y in inflation.years) {
    if (y.provenance == InflationProvenance.assumed) {
      return l10n.inflationAssumed('${y.assumedFrom}');
    }
  }
  if (inflation.years.any((y) => y.provenance == InflationProvenance.user)) {
    return l10n.inflationYours(name);
  }
  final shipped = ref.watch(shippedInflationProvider).value;
  final asOf = shipped?.lastYear(country);
  if (asOf == null) return null;
  return l10n.inflationShipped(name, l10n.sourceName, '$asOf');
}
