/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/reference/units.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../domain/period.dart';
import '../domain/portfolio_calculator.dart';
import '../../settings/settings_screen.dart';
import 'assumptions_screen.dart';
import 'investment_form_screen.dart';
import 'investments_providers.dart';
import 'item_detail_screen.dart';
import 'period_screen.dart';
import 'update_all_screen.dart';
import 'why_builders.dart';
import 'why_sheet.dart';
import 'widgets/inflation_tag.dart';
import 'widgets/labels.dart';

enum _Sort { value, ret, name, oldest }

/// S2: totals, this year's verdict, stale summary and the list.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _view = ViewUnit.base;
  var _sort = _Sort.value;

  void _push(Widget screen) =>
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final calc = ref.watch(calculatorProvider).value;
    final items = calc?.items;
    final base = ref.watch(settingsProvider).value?.baseCurrency;
    final today = ref.watch(todayProvider);
    Widget scaffold(Widget body, {Widget? fab}) => Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => _push(const SettingsScreen()),
          ),
          IconButton(
            tooltip: l10n.assumptions,
            icon: const Icon(Icons.tune),
            onPressed: () => _push(const AssumptionsScreen()),
          ),
        ],
      ),
      body: body,
      floatingActionButton: fab,
    );
    if (calc == null || items == null || base == null) {
      return scaffold(const Center(child: CircularProgressIndicator()));
    }
    final add = FloatingActionButton.extended(
      onPressed: () => _push(const InvestmentFormScreen()),
      icon: const Icon(Icons.add),
      label: Text(l10n.add),
    );
    if (items.isEmpty) return scaffold(_empty(context));

    final year = Period.year(today.year, today);
    final shown = ref.watch(portfolioFiguresProvider((year, _view)));
    final inBase = ref.watch(portfolioFiguresProvider((year, ViewUnit.base)));
    final stale = calc.staleNow();
    final rows = _rows(items, year);
    return scaffold(
      ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          if (shown != null && inBase != null)
            _totalsCard(context, shown, inBase, today, base),
          if (stale.itemIds.isNotEmpty || stale.ratePairs.isNotEmpty)
            _staleBanner(context, stale),
          const SizedBox(height: 8),
          _sortBar(context),
          ..._list(context, rows, stale, base),
        ],
      ),
      fab: add,
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
              onPressed: () => _push(const InvestmentFormScreen()),
              child: Text(l10n.addInvestment),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final (label, type) in [
                  (l10n.presetMonthlyFund, AssetType.fund),
                  (l10n.presetGold, AssetType.gold),
                  (l10n.presetStock, AssetType.stock),
                ])
                  ActionChip(
                    label: Text(label),
                    onPressed: () =>
                        _push(InvestmentFormScreen(presetType: type)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.dataStaysOnPhone),
          ],
        ),
      ),
    );
  }

  Widget _totalsCard(
    BuildContext context,
    PortfolioFigures shown,
    PortfolioFigures inBase,
    DateTime today,
    Unit base,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context).textTheme;
    final totals = shown.totals;
    final ev = totals?.dietz.ev;
    final value = ev == null
        ? '—'
        : shown.view == ViewUnit.base
        ? context.money(ev, base)
        : context.grams(ev);
    final pp = inBase.totals?.pp;
    final excluded = inBase.excluded;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.totalValue, style: theme.labelLarge),
            Text(
              value,
              key: const ValueKey('total-value'),
              style: theme.headlineSmall,
            ),
            Text(l10n.asOfDate(context.date(today))),
            const SizedBox(height: 8),
            SegmentedButton<ViewUnit>(
              segments: [
                ButtonSegment(value: ViewUnit.base, label: Text(base.code)),
                ButtonSegment(
                  value: ViewUnit.goldGrams,
                  label: Text(l10n.viewGold),
                ),
                ButtonSegment(
                  value: ViewUnit.silverGrams,
                  label: Text(l10n.viewSilver),
                ),
              ],
              selected: {_view},
              onSelectionChanged: (s) => setState(() => _view = s.first),
            ),
            if (excluded.isNotEmpty)
              InkWell(
                onTap: () => _push(const UpdateAllScreen()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.excludesItems(
                      '${excluded.length}',
                      excluded
                          .map((e) => context.pair(e.from, e.to))
                          .toSet()
                          .join(', '),
                    ),
                  ),
                ),
              ),
            if (inBase.toPurify.amount > Decimal.zero)
              InkWell(
                onTap: () => showWhy(context, whyToPurify(context)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.toPurifyLine(
                      context.money(inBase.toPurify.amount, base),
                    ),
                  ),
                ),
              ),
            const Divider(),
            InkWell(
              onTap: () => _push(PeriodScreen(initialYear: today.year)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key: const ValueKey('verdict'),
                      pp == null
                          ? l10n.verdictNotAvailable('${today.year}')
                          : pp.kept
                          ? l10n.verdictKept(
                              '${today.year}',
                              context.money(pp.gap, base, signed: true),
                            )
                          : l10n.verdictLost(
                              '${today.year}',
                              context.money(pp.gap, base, signed: true),
                            ),
                      style: theme.titleSmall,
                    ),
                    Text(l10n.verdictCaption, style: theme.bodySmall),
                    Consumer(
                      builder: (context, ref, _) {
                        final tag = inflationTag(
                          context,
                          ref,
                          inBase.homeCountry,
                          inBase.totals?.inflation,
                        );
                        return tag == null
                            ? const SizedBox.shrink()
                            : Text(tag, style: theme.bodySmall);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _staleBanner(BuildContext context, StaleNow stale) {
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
          onPressed: () => _push(const UpdateAllScreen()),
          child: Text(l10n.updateAll),
        ),
      ),
    );
  }

  Widget _sortBar(BuildContext context) {
    final l10n = context.l10n;
    final labels = {
      _Sort.value: l10n.sortValue,
      _Sort.ret: l10n.sortReturn,
      _Sort.name: l10n.sortName,
      _Sort.oldest: l10n.sortOldest,
    };
    return Row(
      children: [
        Text('${l10n.sortLabel}: '),
        Flexible(
          child: DropdownButton<_Sort>(
            key: const ValueKey('sort'),
            isExpanded: true,
            value: _sort,
            items: [
              for (final e in labels.entries)
                DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (v) => setState(() => _sort = v!),
          ),
        ),
      ],
    );
  }

  List<_Row> _rows(List<InvestmentWithHistory> items, Period year) => [
    for (final h in items)
      _Row(
        h.investment,
        ref.watch(itemFiguresProvider((h.investment.id, year)))!,
        ref.watch(sinceStartProvider(h.investment.id))!,
        // A skip is a decision, not an update: it never moves "oldest first".
        h.history
            .where((e) => e is! PlanSkip)
            .fold<DateTime>(
              h.investment.startDate,
              (a, e) => e.date.isAfter(a) ? e.date : a,
            ),
      ),
  ];

  List<Widget> _list(
    BuildContext context,
    List<_Row> rows,
    StaleNow stale,
    Unit base,
  ) {
    final open = rows.where((r) => !r.figures.closed).toList()..sort(_compare);
    final closed = rows.where((r) => r.figures.closed).toList()..sort(_compare);
    return [
      for (final r in open) _rowTile(context, r, stale, base),
      if (closed.isNotEmpty)
        ExpansionTile(
          title: Text(context.l10n.closedSection('${closed.length}')),
          children: [for (final r in closed) _rowTile(context, r, stale, base)],
        ),
    ];
  }

  int _compare(_Row a, _Row b) => switch (_sort) {
    _Sort.value => (b.figures.base?.dietz.ev ?? Decimal.zero).compareTo(
      a.figures.base?.dietz.ev ?? Decimal.zero,
    ),
    _Sort.ret => (b.shownReturn ?? Decimal.zero).compareTo(
      a.shownReturn ?? Decimal.zero,
    ),
    _Sort.name => a.item.name.compareTo(b.item.name),
    _Sort.oldest => a.lastDate.compareTo(b.lastDate),
  };

  /// UX 2.2 list row: start = name, type, status, pill; end = own value,
  /// base value, return, estimate.
  Widget _rowTile(BuildContext context, _Row r, StaleNow stale, Unit base) {
    final l10n = context.l10n;
    final item = r.item;
    final f = r.figures;
    final own = f.itemUnit?.dietz.ev;
    final inBase = item.unit == base ? null : f.base?.dietz.ev;
    final ret = r.shownReturn;
    final type = item.market == null
        ? context.assetTypeName(item.type)
        : l10n.typeAndMarket(
            context.assetTypeName(item.type),
            context.marketName(item.market!),
          );
    final status = f.excluded != null
        ? l10n.rateMissingAdd(f.excluded!.from.code, f.excluded!.to.code)
        : stale.itemIds.contains(item.id)
        ? (item.unit.isMetal
              ? l10n.metalRateNotUpdated
              : l10n.notUpdatedThisMonth)
        : null;
    final pending = ref.watch(pendingCountProvider(item.id));
    final row = _RowTexts(
      name: item.name,
      type: type,
      own: own == null ? '—' : context.money(own, item.unit),
      inBase: inBase == null ? null : context.money(inBase, base),
      ret: ret == null ? null : context.percent(ret),
      plan: _planTexts(context, item),
      status: status,
      pill: pending > 0 ? l10n.toConfirmPill(pending) : null,
    );
    return Semantics(
      key: ValueKey('item-${item.id}'),
      container: true,
      button: true,
      excludeSemantics: true,
      label: row.spoken,
      child: InkWell(
        onTap: () => _push(ItemDetailScreen(investmentId: item.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _RowLayout(id: item.id, texts: row),
        ),
      ),
    );
  }

  /// Consultant wording (UX 2.2): never "profit" or "plan" on the row.
  _PlanTexts _planTexts(BuildContext context, Investment item) {
    final l10n = context.l10n;
    String pct(Decimal v) => context.percent(
      v,
      digits: (v * Decimal.fromInt(100)).scale.clamp(0, 2),
    );
    final p = item.expectedProfit == null
        ? null
        : pct(item.expectedProfit!).replaceAll('+', '');
    final g = item.expectedGrowth == null ? null : pct(item.expectedGrowth!);
    return _PlanTexts(
      one: p != null && g != null
          ? l10n.rowPlanBoth(p, g)
          : p != null
          ? l10n.rowPlanProfit(p)
          : g != null
          ? l10n.rowPlanGrowth(g)
          : null,
      profit: p == null ? null : l10n.rowPlanProfit(p),
      growthOnly: p != null && g != null ? l10n.rowPlanGrowthOnly(g) : null,
    );
  }
}

final class _PlanTexts {
  const _PlanTexts({this.one, this.profit, this.growthOnly});

  final String? one;
  final String? profit;
  final String? growthOnly;
}

final class _RowTexts {
  const _RowTexts({
    required this.name,
    required this.type,
    required this.own,
    required this.inBase,
    required this.ret,
    required this.plan,
    required this.status,
    required this.pill,
  });

  final String name;
  final String type;
  final String own;
  final String? inBase;
  final String? ret;
  final _PlanTexts plan;
  final String? status;
  final String? pill;

  /// VoiceOver order (UX 2.2): start 1–2, end 1–4, start 3–4.
  String get spoken =>
      [name, type, own, ?inBase, ?ret, ?plan.one, ?status, ?pill].join('\n');
}

class _RowLayout extends StatelessWidget {
  const _RowLayout({required this.id, required this.texts});

  final String id;
  final _RowTexts texts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ownStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
    final small = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, c) {
        bool fits(String text, TextStyle? style, num width) =>
            (TextPainter(
              text: TextSpan(text: text, style: style),
              textDirection: Directionality.of(context),
              textScaler: scaler,
              maxLines: 1,
            )..layout()).width <=
            width;
        final endMax = c.maxWidth * 0.6;
        final stacked =
            scaler.scale(1) >= 1.3 || !fits(texts.own, ownStyle, endMax);
        final endWidth = stacked ? c.maxWidth : endMax;
        final both = texts.plan.one;
        final split =
            texts.plan.growthOnly != null &&
            both != null &&
            !fits(both, small, endWidth);
        final end = Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              texts.own,
              key: ValueKey('value-own-$id'),
              style: ownStyle,
              textAlign: TextAlign.end,
            ),
            if (texts.inBase != null)
              Text(
                texts.inBase!,
                key: ValueKey('value-base-$id'),
                style: small,
              ),
            if (texts.ret != null)
              Text(
                texts.ret!,
                key: ValueKey('return-$id'),
                style: theme.textTheme.bodyMedium,
              ),
            if (both != null)
              Text(
                split ? texts.plan.profit! : both,
                key: ValueKey('plan-$id'),
                style: small,
                textAlign: TextAlign.end,
              ),
            if (split)
              Text(
                texts.plan.growthOnly!,
                key: ValueKey('plan2-$id'),
                style: small,
                textAlign: TextAlign.end,
              ),
          ],
        );
        final start = _start(context);
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              start,
              Align(alignment: AlignmentDirectional.centerEnd, child: end),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: start),
            const SizedBox(width: 12),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: endMax),
              child: end,
            ),
          ],
        );
      },
    );
  }

  Widget _start(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texts.name,
          style: theme.textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(texts.type),
        if (texts.status != null) Text(texts.status!),
        if (texts.pill != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: DecoratedBox(
              key: ValueKey('to-confirm-$id'),
              decoration: ShapeDecoration(
                color: theme.colorScheme.secondaryContainer,
                shape: const StadiumBorder(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(texts.pill!),
              ),
            ),
          ),
      ],
    );
  }
}

class _Row {
  _Row(this.item, this.figures, this.since, this.lastDate);

  final Investment item;
  final ItemFigures figures;
  final SinceStartFigures since;
  final DateTime lastDate;

  /// The item-unit return (owner, 2026-10-23); metals use the base return,
  /// because a buy adds grams and value alike, so grams read ~0 %.
  Decimal? get shownReturn => item.unit.isMetal
      ? since.figures.base?.dietz.r
      : since.figures.itemUnit?.dietz.r;
}
