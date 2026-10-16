/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/reference/units.dart';
import '../domain/investment.dart';
import '../domain/period.dart';
import '../domain/portfolio_calculator.dart';
import 'investments_providers.dart';
import 'item_detail_screen.dart';
import 'why_builders.dart';
import 'why_sheet.dart';
import 'widgets/inflation_tag.dart';
import 'widgets/labels.dart';
import 'widgets/no_zakat_block.dart';

enum _Measure { ret, after, real }

/// S7: month or year, the ladder from return to real return after set-aside,
/// the purchasing-power verdict, and the other periods.
class PeriodScreen extends ConsumerStatefulWidget {
  const PeriodScreen({
    super.key,
    required this.initialYear,
    this.initialMonth,
    this.scopeItemId,
  });

  final int initialYear;
  final int? initialMonth;
  final String? scopeItemId;

  @override
  ConsumerState<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends ConsumerState<PeriodScreen> {
  late Granularity _gran = widget.initialMonth == null
      ? Granularity.year
      : Granularity.month;
  late int _year = widget.initialYear;
  late int _month = widget.initialMonth ?? 1;
  late String? _scope = widget.scopeItemId;
  var _view = ViewUnit.base;
  var _measure = _Measure.real;

  Period _period(DateTime today) => _gran == Granularity.year
      ? Period.year(_year, today)
      : Period.month(_year, _month, today);

  void _step(int delta, DateTime today) => setState(() {
    if (_gran == Granularity.year) {
      _year += delta;
    } else {
      var m = _month + delta;
      var y = _year;
      if (m < 1) {
        m = 12;
        y--;
      } else if (m > 12) {
        m = 1;
        y++;
      }
      _month = m;
      _year = y;
    }
  });

  String _label(BuildContext context, Period p) => _gran == Granularity.year
      ? '${p.e.year}'
      : MaterialLocalizations.of(context).formatMonthYear(p.e);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final today = ref.watch(todayProvider);
    final calc = ref.watch(calculatorProvider).value;
    final items = calc?.items;
    final settings = ref.watch(settingsProvider).value;
    if (items == null || settings == null || calc == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.periodTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final base = settings.baseCurrency!;
    final period = _period(today);
    final scoped = _scope != null;
    final view = scoped ? ViewUnit.base : _view;
    final portfolio = scoped
        ? null
        : ref.watch(portfolioFiguresProvider((period, view)));
    final itemFigures = scoped
        ? ref.watch(itemFiguresProvider((_scope!, period)))
        : null;
    final returns = scoped ? itemFigures?.base : portfolio?.totals;
    final unit = switch (view) {
      ViewUnit.base => base,
      ViewUnit.goldGrams => xauG,
      ViewUnit.silverGrams => xagG,
    };
    final names = {for (final h in items) h.investment.id: h.investment};
    final textTheme = Theme.of(context).textTheme;
    final first = items.isEmpty
        ? today
        : items
              .map((h) => h.investment.startDate)
              .reduce((a, b) => a.isBefore(b) ? a : b);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.periodTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButton<String?>(
            key: const ValueKey('scope'),
            value: _scope,
            isExpanded: true,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.allInvestments)),
              for (final i in names.values)
                DropdownMenuItem(value: i.id, child: Text(i.name)),
            ],
            onChanged: (v) => setState(() => _scope = v),
          ),
          SegmentedButton<Granularity>(
            segments: [
              ButtonSegment(
                value: Granularity.month,
                label: Text(l10n.monthLabel),
              ),
              ButtonSegment(
                value: Granularity.year,
                label: Text(l10n.yearLabel),
              ),
            ],
            selected: {_gran},
            onSelectionChanged: (s) => setState(() {
              _gran = s.first;
              // The month view of this year opens on the current month.
              if (_gran == Granularity.month && _year == today.year) {
                _month = today.month;
              }
            }),
          ),
          if (!scoped)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SegmentedButton<ViewUnit>(
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
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                key: const ValueKey('prev'),
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _step(-1, today),
              ),
              Text(_label(context, period), style: textTheme.titleMedium),
              IconButton(
                key: const ValueKey('next'),
                icon: const Icon(Icons.arrow_forward),
                onPressed: _canStepForward(period, today)
                    ? () => _step(1, today)
                    : null,
              ),
            ],
          ),
          if (returns == null)
            _unavailable(context, portfolio)
          else ...[
            _ladder(
              context,
              returns,
              unit,
              period,
              settings,
              itemFigures,
              portfolio,
            ),
            _verdict(context, returns, unit, view),
          ],
          if (portfolio != null && portfolio.toPurify.amount > Decimal.zero)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () => showWhy(context, whyToPurify(context)),
                child: Text(
                  l10n.toPurifyPeriod(
                    context.money(portfolio.toPurify.amount, base),
                  ),
                ),
              ),
            ),
          if (portfolio != null) _markers(context, portfolio, returns),
          if (_gran == Granularity.year &&
              !scoped &&
              view == ViewUnit.base) ...[
            const Divider(),
            NoZakatBlock(year: period.e.year),
          ],
          if (portfolio != null) ..._itemRows(context, portfolio, names, base),
          const Divider(),
          ..._others(context, first, today, view, base),
        ],
      ),
    );
  }

  bool _canStepForward(Period p, DateTime today) => p.e.isBefore(today);

  Widget _unavailable(BuildContext context, PortfolioFigures? p) {
    final l10n = context.l10n;
    final miss = p?.unavailable;
    return Card(
      child: ListTile(
        title: Text(l10n.notAvailable),
        subtitle: Text(
          miss == null
              ? l10n.notAvailableWhy
              : l10n.rateMissingAdd(miss.from.code, miss.to.code),
        ),
      ),
    );
  }

  Widget _ladder(
    BuildContext context,
    Returns r,
    Unit unit,
    Period period,
    Settings settings,
    ItemFigures? item,
    PortfolioFigures? portfolio,
  ) {
    final l10n = context.l10n;
    final year = settings.zakatYear ?? ZakatYear.lunar;
    final grams = unit.isMetal;
    final country = item?.homeCountry ?? portfolio?.homeCountry;
    final noZakat = ref.watch(noZakatYearsProvider).value ?? const <int>{};
    final zeroed = noZakat.contains(period.e.year) && r.z == Decimal.zero;
    Widget fig(String label, String? value, {Why? why, bool strong = false}) =>
        FigureRow(
          label: label,
          value: value ?? l10n.notAvailable,
          why: why,
          emphasis: strong,
        );
    String? pct(Decimal? v) => v == null ? null : context.percent(v);
    final tag = grams || country == null
        ? null
        : inflationTag(context, ref, country, r.inflation);
    final setAsideWhy = item != null
        ? whySetAside(context, r, item.zakat, year, period.days, unit)
        : Why(
            title: l10n.whySetAsideTitle,
            what: l10n.whySetAsideWhat,
            source: l10n.src_A1A2,
          );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (r.notAvailable)
              Text(l10n.notAvailable, key: const ValueKey('not-available'))
            else ...[
              fig(
                l10n.rowReturn,
                pct(r.dietz.r),
                why: whyReturn(context, r, unit),
              ),
              fig(
                l10n.rowSetAside,
                zeroed
                    ? l10n.noZakatEffect
                    : context.money(-r.z, unit, signed: true),
                why: setAsideWhy,
              ),
              Text(
                l10n.setAsideNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              fig(l10n.rowReturnAfter, pct(r.rz)),
              if (grams)
                Text(l10n.yardstick, key: const ValueKey('yardstick'))
              else if (country != null) ...[
                fig(
                  l10n.rowInflation(context.countryName(country)),
                  r.i == null ? null : context.percent(r.i!),
                ),
                if (tag != null)
                  Text(tag, style: Theme.of(context).textTheme.bodySmall),
                fig(
                  l10n.rowRealAfter,
                  pct(r.realAfterZakat),
                  strong: true,
                  why: whyReal(context, r, tag),
                ),
                Text(
                  l10n.rowRealBefore(pct(r.real) ?? l10n.notAvailable),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  l10n.realLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _verdict(BuildContext context, Returns r, Unit unit, ViewUnit view) {
    final l10n = context.l10n;
    final pp = r.pp;
    if (pp == null) return const SizedBox.shrink();
    final grams = view != ViewUnit.base;
    final amount = grams
        ? context.grams(pp.gap.abs())
        : context.money(pp.gap, unit, signed: true);
    return Card(
      color: pp.kept
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.errorContainer,
      child: InkWell(
        onTap: () => showWhy(context, whyGap(context, r, unit)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(pp.kept ? Icons.arrow_upward : Icons.arrow_downward),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pp.kept ? l10n.verdictKeptTitle : l10n.verdictLostTitle,
                      key: const ValueKey('verdict-title'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              Text(
                grams
                    ? (pp.kept
                          ? l10n.keptGrams(amount)
                          : l10n.lostGrams(amount))
                    : amount,
                key: const ValueKey('verdict-amount'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (!grams && pp.neededReturn != null)
                Text(
                  l10n.neededEnd(
                    context.money(pp.neededEnd, unit),
                    context.percent(pp.neededReturn!),
                  ),
                ),
              if (!grams)
                Text(
                  l10n.realLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _markers(BuildContext context, PortfolioFigures p, Returns? r) {
    final l10n = context.l10n;
    final lines = [
      if (p.staleValues.isNotEmpty)
        l10n.markersStale('${p.staleValues.length}'),
      if (p.staleRates.isNotEmpty) l10n.markerStaleRate,
      if (r?.inflation?.years.any((y) => y.assumedFrom != null) ?? false)
        l10n.inflationAssumed(
          '${r!.inflation!.years.firstWhere((y) => y.assumedFrom != null).assumedFrom}',
        ),
      if (p.excluded.isNotEmpty)
        l10n.basedOn(
          '${p.items.where((f) => f.base != null).length}',
          '${p.items.length}',
        ),
    ];
    if (lines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(lines.join(' · '), key: const ValueKey('markers')),
    );
  }

  List<Widget> _itemRows(
    BuildContext context,
    PortfolioFigures p,
    Map<String, Investment> names,
    Unit base,
  ) {
    final l10n = context.l10n;
    if (p.view != ViewUnit.base) return const [];
    return [
      Text(l10n.itemsHeading, style: Theme.of(context).textTheme.titleSmall),
      for (final f in p.items)
        if (f.base != null)
          ListTile(
            key: ValueKey('period-item-${f.id}'),
            dense: true,
            title: Text(names[f.id]?.name ?? f.id),
            subtitle: f.staleValue ? Text(l10n.markerNotUpdated) : null,
            trailing: Text(
              f.base!.dietz.r == null
                  ? l10n.notAvailable
                  : context.percent(f.base!.dietz.r!),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ItemDetailScreen(investmentId: f.id),
              ),
            ),
          ),
      if (p.excluded.isNotEmpty) ...[
        Text(
          l10n.excludedHeading,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        for (final e in p.excluded)
          ListTile(
            key: ValueKey('excluded-${e.itemId}'),
            dense: true,
            title: Text(
              l10n.excludedLine(
                names[e.itemId]?.name ?? e.itemId,
                e.from.code,
                e.to.code,
              ),
            ),
          ),
      ],
    ];
  }

  List<Widget> _others(
    BuildContext context,
    DateTime first,
    DateTime today,
    ViewUnit view,
    Unit base,
  ) {
    final l10n = context.l10n;
    final periods = periodsBetween(first, today, _gran).reversed.toList();
    final take = _gran == Granularity.month
        ? periods.take(12).toList()
        : periods;
    return [
      Text(l10n.otherPeriods, style: Theme.of(context).textTheme.titleSmall),
      Wrap(
        spacing: 8,
        children: [
          for (final (m, label) in [
            (_Measure.ret, l10n.measureReturn),
            (_Measure.after, l10n.measureAfter),
            (_Measure.real, l10n.measureReal),
          ])
            ChoiceChip(
              label: Text(label),
              selected: _measure == m,
              onSelected: (_) => setState(() => _measure = m),
            ),
        ],
      ),
      for (final p in take) _otherRow(context, p, view),
    ];
  }

  Widget _otherRow(BuildContext context, Period p, ViewUnit view) {
    final l10n = context.l10n;
    final fig = ref.watch(portfolioFiguresProvider((p, view)))?.totals;
    final value = switch (_measure) {
      _Measure.ret => fig?.dietz.r,
      _Measure.after => fig?.rz,
      _Measure.real =>
        fig?.realAfterZakat ?? (view == ViewUnit.base ? null : fig?.rz),
    };
    final kept = fig?.pp?.kept;
    return ListTile(
      key: ValueKey('other-${p.e.year}-${p.e.month}'),
      dense: true,
      title: Text(_label(context, p)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value == null ? l10n.notAvailable : context.percent(value)),
          if (kept != null)
            Icon(kept ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
        ],
      ),
      onTap: () => setState(() {
        _year = p.e.year;
        _month = p.e.month;
      }),
    );
  }
}
