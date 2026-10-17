/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/settings.dart';
import 'investment.dart';

enum ZakatNotice { dividendsCountedWithCash, cryptoDisputed }

final class ResolvedZakat {
  ResolvedZakat({
    required this.share,
    required this.onDividends,
    required this.sourceSection,
    this.notice,
  });

  final Decimal share;
  final bool onDividends;
  final ZakatNotice? notice;

  /// Anchor in docs/product/shariah/zakat-on-investments.md (the "why" sheet).
  final String sourceSection;
}

/// A share the app may offer for an "other" item; used only once the user
/// confirms it (AC-7).
final class ZakatOffer {
  ZakatOffer(this.share, this.sourceSection);

  final Decimal share;
  final String sourceSection;
}

/// The per-item rule a portfolio-wide method stands for; null for perItem.
ZakatRule? explicitLongTermRule(LongTermMethod method) => switch (method) {
  LongTermMethod.dividendsOnly => ZakatRule.longTermDividendsOnly,
  LongTermMethod.proxy25 => ZakatRule.longTermProxy25,
  LongTermMethod.fullValue => ZakatRule.longTermFullValue,
  LongTermMethod.perItem => null,
};

/// Null means the user must choose (story §5.1).
ZakatRule? defaultRule(AssetType type, Intent? intent, Settings settings) {
  switch (type) {
    case AssetType.cashDeposit:
      return ZakatRule.cash100;
    case AssetType.gold:
    case AssetType.silver:
      return intent == Intent.personalUse
          ? ZakatRule.jewelleryPerSetting
          : ZakatRule.bullion100;
    case AssetType.stock:
    case AssetType.fund:
      return switch (intent) {
        Intent.trading => ZakatRule.trading100,
        Intent.longTerm => switch (settings.longTermMethod) {
          null || LongTermMethod.perItem => null,
          _ => ZakatRule.longTermPerSetting,
        },
        _ => null,
      };
    case AssetType.sukuk:
      return ZakatRule.sukuk100;
    case AssetType.crypto:
      return ZakatRule.crypto100;
    case AssetType.other:
      return null;
  }
}

ZakatOffer? offeredShare(AssetType type, Intent? intent) {
  if (type != AssetType.other) return null;
  return switch (intent) {
    Intent.personalUse || Intent.rental => ZakatOffer(Decimal.zero, 'B5'),
    Intent.trading => ZakatOffer(Decimal.one, 'B5'),
    _ => null,
  };
}

ResolvedZakat resolve(Investment item, Settings settings) {
  ResolvedZakat full(String section, [ZakatNotice? notice]) => ResolvedZakat(
    share: Decimal.one,
    onDividends: false,
    sourceSection: section,
    notice: notice,
  );
  ResolvedZakat part(String share, String section) => ResolvedZakat(
    share: Decimal.parse(share),
    onDividends: false,
    sourceSection: section,
  );
  final dividends = ResolvedZakat(
    share: Decimal.zero,
    onDividends: true,
    sourceSection: 'B3',
    notice: ZakatNotice.dividendsCountedWithCash,
  );

  switch (item.zakatRule) {
    case ZakatRule.cash100:
      return full('B1');
    case ZakatRule.bullion100:
      return full('B2');
    case ZakatRule.jewelleryPerSetting:
      return switch (settings.jewelleryZakatable) {
        true => full('B2'),
        false => part('0', 'B2'),
        null => throw StateError(
          'Jewellery ruling must be answered before "${item.name}" is used.',
        ),
      };
    case ZakatRule.trading100:
    case ZakatRule.longTermFullValue:
      return full('B3');
    case ZakatRule.longTermPerSetting:
      return switch (settings.longTermMethod) {
        LongTermMethod.dividendsOnly => dividends,
        LongTermMethod.proxy25 => part('0.25', 'B3'),
        LongTermMethod.fullValue => full('B3'),
        _ => throw StateError(
          'Long-term method must be answered before "${item.name}" is used.',
        ),
      };
    case ZakatRule.longTermDividendsOnly:
      return dividends;
    case ZakatRule.longTermProxy25:
      return part('0.25', 'B3');
    case ZakatRule.sukuk100:
      return full('B4');
    case ZakatRule.crypto100:
      return full('B8', ZakatNotice.cryptoDisputed);
    case ZakatRule.companyPaysZakat:
      return part('0', 'B3');
    case ZakatRule.custom:
      return ResolvedZakat(
        share: item.customZakatShare!,
        onDividends: false,
        sourceSection: 'A9',
      );
  }
}
