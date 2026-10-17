/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/reference/units.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/investment.dart';
import '../domain/portfolio_calculator.dart';
import '../domain/zakat_rules.dart';
import 'why_sheet.dart';
import 'widgets/labels.dart';

/// The "why" content of the figures the Shariah file and the story require
/// to be explained (spec §10 concern 2).
Why whyReturn(BuildContext context, Returns r, Unit unit) {
  final l10n = context.l10n;
  String m(Decimal v) => context.money(v, unit);
  final dz = r.dietz;
  return Why(
    title: l10n.whyReturnTitle,
    what: l10n.whyReturnWhat,
    numbers: dz.r == null
        ? null
        : l10n.whyReturnNumbers(
            context.percent(dz.r!),
            m(dz.ev),
            m(dz.bv),
            m(dz.cf),
            m(dz.d),
          ),
  );
}

/// The ruling text behind a zakat share: the rate and year (A1/A2) plus the
/// asset section the item resolved to (Part B).
String zakatSource(AppLocalizations l10n, String section, {AssetType? type}) {
  final asset = type == AssetType.other
      ? '${l10n.src_B5}\n\n${l10n.src_B6}\n\n${l10n.src_B7}'
      : switch (section) {
          'B1' => l10n.src_B1,
          'B2' => l10n.src_B2,
          'B3' => l10n.src_B3,
          'B4' => l10n.src_B4,
          'B5' => l10n.src_B5,
          'B6' => l10n.src_B6,
          'B8' => l10n.src_B8,
          _ => null,
        };
  return [l10n.src_A1A2, ?asset].join('\n\n');
}

Why whySetAside(
  BuildContext context,
  Returns r,
  ResolvedZakat zakat,
  ZakatYear year,
  int days,
  Unit unit, {
  AssetType? type,
}) {
  final l10n = context.l10n;
  return Why(
    title: l10n.whySetAsideTitle,
    what: l10n.whySetAsideWhat,
    numbers: l10n.whySetAsideNumbers(
      context.money(r.z, unit),
      context.percent(year.r).replaceAll('+', ''),
      context.percent(zakat.share).replaceAll('+', ''),
      context.money(r.dietz.ev, unit),
      '$days',
      year.days.toString(),
      context.money(r.dividends, unit),
    ),
    assumptions: [
      l10n.zakatYearTitle,
      if (zakat.onDividends) l10n.noticeDividends,
    ],
    source: zakatSource(l10n, zakat.sourceSection, type: type),
  );
}

Why whyReal(BuildContext context, Returns r, String? inflationTag) {
  final l10n = context.l10n;
  final ret = r.dietz.r;
  final real = r.realAfterZakat ?? r.real;
  return Why(
    title: l10n.whyRealTitle,
    what: l10n.whyRealWhat,
    numbers: ret == null || r.i == null || real == null
        ? null
        : l10n.whyRealNumbers(
            context.percent(r.rz ?? ret),
            context.percent(r.i!),
            context.percent(real),
          ),
    assumptions: [?inflationTag],
    source: l10n.src_A6,
  );
}

Why whyGap(BuildContext context, Returns r, Unit unit) {
  final l10n = context.l10n;
  final pp = r.pp;
  return Why(
    title: l10n.whyGapTitle,
    what: l10n.whyGapWhat,
    numbers: pp == null
        ? null
        : l10n.whyGapNumbers(
            context.money(pp.gap, unit, signed: true),
            context.money(pp.neededEnd, unit),
          ),
    source: l10n.src_A6,
  );
}

Why whyToPurify(BuildContext context) => Why(
  title: context.l10n.whyToPurifyTitle,
  what: context.l10n.whyToPurifyWhat,
  source: context.l10n.src_Z6,
);
