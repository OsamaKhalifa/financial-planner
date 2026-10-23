/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/units.dart';
import '../../../main.dart';
import '../../investments/domain/investment.dart';
import '../../investments/domain/period.dart';
import '../../investments/domain/portfolio_calculator.dart';
import '../../investments/presentation/investment_form_screen.dart';
import '../../investments/presentation/investments_providers.dart';
import '../../investments/presentation/period_screen.dart';
import '../../investments/presentation/update_all_screen.dart';
import '../../investments/presentation/why_builders.dart';
import '../../investments/presentation/why_sheet.dart';
import '../../investments/presentation/widgets/inflation_tag.dart';
import '../../investments/presentation/widgets/labels.dart';

/// Overview tab (UC-2). Every figure comes from [PortfolioCalculator]; this
/// screen only lays them out.
class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final calc = ref.watch(calculatorProvider).value;
    final base = ref.watch(settingsProvider).value?.baseCurrency;
    final today = ref.watch(todayProvider);
    Widget scaffold(Widget body) => Scaffold(
      appBar: AppBar(title: Text(l10n.tabOverview)),
      body: body,
    );
    if (calc == null || base == null) {
      return scaffold(const Center(child: CircularProgressIndicator()));
    }
    if (calc.items.isEmpty) return scaffold(_empty(context));

    final year = Period.year(today.year, today);
    final p = ref.watch(portfolioFiguresProvider((year, ViewUnit.base)));
    final slices = ref.watch(byTypeProvider(year)) ?? const [];
    final since = ref.watch(sinceStartTotalProvider);
    final exposure = ref.watch(exposureProvider(year));
    final stale = calc.staleNow();
    final totals = p?.totals;
    void toYear() => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PeriodScreen(initialYear: today.year),
      ),
    );
    return scaffold(
      ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (p != null) _totalCard(context, p, base, today),
          if (totals != null)
            _thisYearCard(context, ref, p!, totals, base, today, toYear),
          if (slices.isNotEmpty) _byTypeCard(context, slices, base),
          if (since != null) _sinceStartCard(context, since, base),
          if (exposure != null && p != null)
            _shariahCard(context, exposure, p, base),
          if (stale.itemIds.isNotEmpty || stale.ratePairs.isNotEmpty)
            _staleCard(context, stale),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.emptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const InvestmentFormScreen(),
                ),
              ),
              child: Text(l10n.addInvestment),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(Widget child, {VoidCallback? onTap}) => Card(
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );

  Widget _totalCard(
    BuildContext context,
    PortfolioFigures p,
    Unit base,
    DateTime today,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context).textTheme;
    final ev = p.totals?.dietz.ev;
    return _card(
      onTap: () => AppShell.select(context, AppShell.investmentsTab),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.overviewTotal, style: theme.labelLarge),
          Text(
            ev == null ? '—' : context.money(ev, base),
            key: const ValueKey('overview-total'),
            style: theme.headlineMedium,
          ),
          Text(l10n.asOfDate(context.date(today))),
          if (p.excluded.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.excludesItems(
                  '${p.excluded.length}',
                  p.excluded
                      .map((e) => context.pair(e.from, e.to))
                      .toSet()
                      .join(', '),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _thisYearCard(
    BuildContext context,
    WidgetRef ref,
    PortfolioFigures p,
    Returns r,
    Unit base,
    DateTime today,
    VoidCallback toYear,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context).textTheme;
    final pp = r.pp;
    final y = '${today.year}';
    String pct(Decimal? v) =>
        v == null ? l10n.notAvailable : context.percent(v);
    final tag = inflationTag(context, ref, p.homeCountry, r.inflation);
    return _card(
      onTap: toYear,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.thisYearTitle(y), style: theme.titleMedium),
          const SizedBox(height: 4),
          Text(
            key: const ValueKey('overview-verdict'),
            pp == null
                ? l10n.verdictNotAvailable(y)
                : pp.kept
                ? l10n.verdictKept(y, context.money(pp.gap, base, signed: true))
                : l10n.verdictLost(
                    y,
                    context.money(pp.gap, base, signed: true),
                  ),
            style: theme.titleSmall,
          ),
          Text(l10n.verdictCaption, style: theme.bodySmall),
          const Divider(),
          FigureRow(label: l10n.rowReturn, value: pct(r.dietz.r)),
          FigureRow(
            label: l10n.rowSetAside,
            value: context.money(-r.z, base, signed: true),
            why: Why(
              title: l10n.whySetAsideTitle,
              what: l10n.whySetAsideWhat,
              source: l10n.src_A1A2,
            ),
          ),
          Text(l10n.setAsideNote, style: theme.bodySmall),
          FigureRow(label: l10n.rowReturnAfter, value: pct(r.rz)),
          FigureRow(
            label: l10n.rowRealAfter,
            value: pct(r.realAfterZakat),
            emphasis: true,
            why: whyReal(context, r, tag),
          ),
          if (tag != null) Text(tag, style: theme.bodySmall),
          Text(l10n.realLabel, style: theme.bodySmall),
        ],
      ),
    );
  }

  Widget _byTypeCard(BuildContext context, List<TypeSlice> slices, Unit base) {
    final l10n = context.l10n;
    final theme = Theme.of(context).textTheme;
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.byTypeTitle, style: theme.titleMedium),
          for (final s in slices)
            Padding(
              key: ValueKey('type-${s.type.name}'),
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(context.assetTypeName(s.type))),
                      Text(
                        l10n.typeShare(
                          context.money(s.value, base),
                          context.percent(s.share),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: progressOf(s.share)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _sinceStartCard(BuildContext context, SinceStartTotal s, Unit base) {
    final l10n = context.l10n;
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.sinceStart, style: Theme.of(context).textTheme.titleMedium),
          FigureRow(
            key: const ValueKey('since-gain'),
            label: l10n.sinceStartGain,
            value: context.money(s.gain, base, signed: true),
          ),
          FigureRow(
            key: const ValueKey('since-roi'),
            label: l10n.sinceStartRoi,
            value: s.roi == null ? l10n.notAvailable : context.percent(s.roi!),
          ),
          if (s.excluded > 0) Text(l10n.sinceStartExcludes('${s.excluded}')),
        ],
      ),
    );
  }

  /// Always shown, so a missing card is never read as "passed": there is no
  /// halal screening yet (UC-4). To purify is never netted (Z-6).
  Widget _shariahCard(
    BuildContext context,
    Exposure e,
    PortfolioFigures p,
    Unit base,
  ) {
    final l10n = context.l10n;
    final small = Theme.of(context).textTheme.bodySmall;
    final purify = p.toPurify.amount;
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.shariahCheckTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(l10n.shariahNoScreening, style: small),
          if (e.shariahRisk > Decimal.zero)
            FigureRow(
              label: l10n.exposureRisk,
              value: context.money(e.shariahRisk, base),
              why: whyCase(context, PeCase.b),
            ),
          if (e.crypto > Decimal.zero) ...[
            FigureRow(
              label: l10n.exposureCrypto,
              value: context.money(e.crypto, base),
              why: Why(
                title: l10n.typeCrypto,
                what: l10n.noticeCrypto,
                source: l10n.src_B8,
              ),
            ),
            Text(l10n.noticeCrypto, style: small),
          ],
          if (purify > Decimal.zero)
            InkWell(
              onTap: () => showWhy(context, whyToPurify(context)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.toPurifyPeriod(context.money(purify, base)),
                  key: const ValueKey('overview-purify'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _staleCard(BuildContext context, StaleNow stale) {
    final l10n = context.l10n;
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: ListTile(
        leading: const Icon(Icons.circle, size: 12),
        title: Text(
          l10n.staleBanner(
            '${stale.itemIds.length}',
            '${stale.ratePairs.length}',
          ),
        ),
        trailing: TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const UpdateAllScreen()),
          ),
          child: Text(l10n.updateAll),
        ),
      ),
    );
  }
}
