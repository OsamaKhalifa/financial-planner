/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/zakat_rules.dart';
import 'package:flutter_test/flutter_test.dart';

const base = Settings(baseCurrency: Unit('EGP'), zakatYear: ZakatYear.lunar);

Investment withRule(AssetType type, ZakatRule rule, {Decimal? share}) =>
    Investment(
      name: 'x',
      type: type,
      unit: const Unit('EGP'),
      startDate: day(2026, 1, 1),
      zakatRule: rule,
      customZakatShare: share,
    );

void main() {
  test('defaults per asset type and intent (story §5.1)', () {
    expect(defaultRule(AssetType.cashDeposit, null, base), ZakatRule.cash100);
    expect(
      defaultRule(AssetType.gold, Intent.longTerm, base),
      ZakatRule.bullion100,
    );
    expect(
      defaultRule(AssetType.silver, Intent.personalUse, base),
      ZakatRule.jewelleryPerSetting,
    );
    expect(
      defaultRule(AssetType.stock, Intent.trading, base),
      ZakatRule.trading100,
    );
    expect(defaultRule(AssetType.sukuk, null, base), ZakatRule.sukuk100);
  });

  test('a long-term stock must ask until a method is chosen, and per-item always asks', () {
    expect(defaultRule(AssetType.stock, Intent.longTerm, base), isNull);
    const perItem = Settings(longTermMethod: LongTermMethod.perItem);
    expect(defaultRule(AssetType.fund, Intent.longTerm, perItem), isNull);
    const set = Settings(longTermMethod: LongTermMethod.proxy25);
    expect(
      defaultRule(AssetType.fund, Intent.longTerm, set),
      ZakatRule.longTermPerSetting,
    );
  });

  test('per-setting rules follow the portfolio method (D7)', () {
    final i = withRule(AssetType.stock, ZakatRule.longTermPerSetting);
    expect(
      resolve(i, const Settings(longTermMethod: LongTermMethod.proxy25)).share,
      Decimal.parse('0.25'),
    );
    expect(
      resolve(
        i,
        const Settings(longTermMethod: LongTermMethod.fullValue),
      ).share,
      Decimal.one,
    );
    expect(
      resolve(
        i,
        const Settings(longTermMethod: LongTermMethod.dividendsOnly),
      ).onDividends,
      isTrue,
    );
    expect(() => resolve(i, base), throwsStateError);
  });

  test(
    'jewellery follows the user ruling; unanswered counts as not zakatable',
    () {
      final i = withRule(AssetType.gold, ZakatRule.jewelleryPerSetting);
      expect(
        resolve(i, const Settings(jewelleryZakatable: true)).share,
        Decimal.one,
      );
      expect(
        resolve(i, const Settings(jewelleryZakatable: false)).share,
        Decimal.zero,
      );
    },
  );

  test('every resolved rule names its source section', () {
    for (final rule in ZakatRule.values) {
      if (rule == ZakatRule.longTermPerSetting) continue;
      final r = resolve(
        withRule(AssetType.other, rule, share: Decimal.parse('0.5')),
        const Settings(
          jewelleryZakatable: true,
          longTermMethod: LongTermMethod.proxy25,
        ),
      );
      expect(r.sourceSection, isNotEmpty, reason: '$rule');
    }
  });

  test('company pays zakat: 0 % and no dividend charge', () {
    final r = resolve(
      withRule(AssetType.stock, ZakatRule.companyPaysZakat),
      base,
    );
    expect(r.share, Decimal.zero);
    expect(r.onDividends, isFalse);
  });

  test('"other" items get an offer only for personal use, rental, trading', () {
    expect(
      offeredShare(AssetType.other, Intent.personalUse)!.share,
      Decimal.zero,
    );
    expect(
      offeredShare(AssetType.other, Intent.personalUse)!.sourceSection,
      'B5',
    );
    expect(offeredShare(AssetType.other, Intent.trading)!.share, Decimal.one);
    expect(offeredShare(AssetType.other, Intent.longTerm), isNull);
    expect(offeredShare(AssetType.stock, Intent.trading), isNull);
  });

  test('jewellery with no ruling answered throws instead of counting as not zakatable', () {
    final i = withRule(AssetType.gold, ZakatRule.jewelleryPerSetting);
    expect(() => resolve(i, base), throwsStateError);
  });

  Investment pe(ZakatRule rule, {CapitalBack q2 = CapitalBack.no}) =>
      Investment(
        name: 'p',
        type: AssetType.privateEquity,
        intent: Intent.longTerm,
        unit: const Unit('EGP'),
        startDate: day(2026, 1, 15),
        zakatRule: rule,
        customZakatShare: rule == ZakatRule.custom
            ? Decimal.parse('0.4')
            : null,
        capitalBack: q2,
      );

  test('AC-47 private equity: trading is 100 %, long-term must be picked', () {
    expect(
      defaultRule(AssetType.privateEquity, Intent.trading, base),
      ZakatRule.trading100,
    );
    expect(defaultRule(AssetType.privateEquity, Intent.longTerm, base), isNull);
    const fullValue = Settings(longTermMethod: LongTermMethod.fullValue);
    expect(
      defaultRule(AssetType.privateEquity, Intent.longTerm, fullValue),
      isNull,
    );
    expect(offeredShare(AssetType.privateEquity, Intent.trading), isNull);
  });

  test('AC-47 every private-equity rule cites B6', () {
    final trading = resolve(pe(ZakatRule.trading100), base);
    expect((trading.share, trading.sourceSection), (Decimal.one, 'B6'));
    final known = resolve(pe(ZakatRule.custom), base);
    expect((known.share, known.sourceSection), (Decimal.parse('0.4'), 'B6'));
    final profit = resolve(pe(ZakatRule.longTermDividendsOnly), base);
    expect(profit.share, Decimal.zero);
    expect(profit.onDividends, isTrue);
    expect(profit.notice, ZakatNotice.profitPayoutsOnly);
    expect(profit.sourceSection, 'B6');
    final full = resolve(pe(ZakatRule.longTermFullValue), base);
    expect((full.share, full.sourceSection), (Decimal.one, 'B6'));
  });

  test('AC-65 case C is 100 % as a debt whatever rule is stored (E6)', () {
    for (final rule in [
      ZakatRule.longTermDividendsOnly,
      ZakatRule.custom,
      ZakatRule.trading100,
    ]) {
      final r = resolve(pe(rule, q2: CapitalBack.yes), base);
      expect(r.share, Decimal.one);
      expect(r.onDividends, isFalse);
      expect(r.sourceSection, 'B6');
      expect(r.notice, ZakatNotice.capitalBackIsDebt);
    }
  });

  test(
    'pendingQuestion names the two answers resolve() would throw without',
    () {
      final jewellery = withRule(AssetType.gold, ZakatRule.jewelleryPerSetting);
      final longTerm = withRule(AssetType.stock, ZakatRule.longTermPerSetting);
      expect(pendingQuestion(jewellery, base), ZakatQuestion.jewellery);
      expect(
        pendingQuestion(jewellery, const Settings(jewelleryZakatable: false)),
        isNull,
      );
      expect(pendingQuestion(longTerm, base), ZakatQuestion.longTermMethod);
      expect(
        pendingQuestion(
          longTerm,
          const Settings(longTermMethod: LongTermMethod.perItem),
        ),
        ZakatQuestion.longTermMethod,
      );
      expect(
        pendingQuestion(
          longTerm,
          const Settings(longTermMethod: LongTermMethod.proxy25),
        ),
        isNull,
      );
      expect(
        pendingQuestion(
          withRule(AssetType.cashDeposit, ZakatRule.cash100),
          base,
        ),
        isNull,
      );
    },
  );

  test('pendingQuestion is null exactly where resolve() does not throw', () {
    final items = [
      for (final r in ZakatRule.values)
        if (r != ZakatRule.custom) withRule(AssetType.stock, r),
      withRule(AssetType.privateEquity, ZakatRule.longTermPerSetting),
    ];
    for (final i in items) {
      final asks = pendingQuestion(i, base) != null;
      expect(() => resolve(i, base), asks ? throwsStateError : returnsNormally);
    }
  });
}
