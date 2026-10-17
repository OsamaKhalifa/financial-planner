/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/data/rate_refresher.dart';
import '../../../core/assumptions/domain/rate.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/units.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../domain/portfolio_calculator.dart';
import 'investments_providers.dart';
import 'widgets/fields.dart';
import 'widgets/labels.dart';

/// S6: refresh rates, type what is still old, one Save.
class UpdateAllScreen extends ConsumerStatefulWidget {
  const UpdateAllScreen({super.key});

  @override
  ConsumerState<UpdateAllScreen> createState() => _UpdateAllState();
}

class _UpdateAllState extends ConsumerState<UpdateAllScreen> {
  final _controllers = <String, TextEditingController>{};
  DateTime? _asOf;
  var _showAll = false;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _ctl(String key) =>
      _controllers.putIfAbsent(key, TextEditingController.new);

  /// Every pair the open items need, plus the metals against the base.
  Set<UnitPair> _pairsInUse(List<InvestmentWithHistory> items, Unit base) => {
    for (final h in items)
      if (h.investment.unit != base) (h.investment.unit, base),
    (xauG, base),
    (xagG, base),
  };

  Future<void> _save(
    List<UnitPair> ratePairs,
    List<InvestmentWithHistory> staleItems,
    int stillOld,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final DateTime asOf = _asOf ?? ref.read(todayProvider);
    final assumptions = ref.read(assumptionsRepositoryProvider);
    final investments = ref.read(investmentsRepositoryProvider);
    var rateWrites = 0;
    try {
      for (final (from, to) in ratePairs) {
        final v = parseAmount(_ctl('rate-${from.code}-${to.code}').text);
        if (v == null || v <= Decimal.zero) continue;
        await assumptions.saveTypedRate(
          Rate(from: from, to: to, rate: v, asOf: asOf),
        );
        rateWrites++;
      }
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errSave)));
      return;
    }
    final entries = <HistoryEntry>[];
    for (final h in staleItems) {
      final v = parseAmount(_ctl('item-${h.investment.id}').text);
      if (v == null) continue;
      final same = h.history
          .whereType<ValueUpdate>()
          .where((e) => e.date == asOf)
          .firstOrNull;
      entries.add(
        ValueUpdate(
          id: same?.id,
          investmentId: h.investment.id,
          date: asOf,
          value: v,
          createdAt: same?.createdAt,
        ),
      );
    }
    try {
      if (entries.isNotEmpty) await investments.saveEntries(entries);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.ratesSavedValuesNot)));
      return;
    }
    if (!mounted) return;
    final left =
        (staleItems.length - entries.length) + (ratePairs.length - rateWrites);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.updatedToast('${entries.length}', '${left < 0 ? 0 : left}'),
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final calc = ref.watch(calculatorProvider).value;
    final items = calc?.items;
    final settings = ref.watch(settingsProvider).value;
    final rates = ref.watch(ratesProvider).value;
    if (calc == null || items == null || settings == null || rates == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.updateAllTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final base = settings.baseCurrency!;
    final today = ref.watch(todayProvider);
    final asOfDate = _asOf ?? today;
    final stale = calc.staleNow();
    final open = [
      for (final h in items)
        if (!calc.timeline(h.investment.id).closedAt(today)) h,
    ];
    final allPairs = _pairsInUse(open, base).toList();
    final ratePairs = _showAll ? allPairs : stale.ratePairs;
    final staleItems = [
      for (final h in open)
        if (!h.investment.unit.isMetal &&
            (_showAll || stale.itemIds.contains(h.investment.id)))
          h,
    ];
    final filled = [
      for (final (f, t) in ratePairs) 'rate-${f.code}-${t.code}',
      for (final h in staleItems) 'item-${h.investment.id}',
    ].where((k) => parseAmount(_ctl(k).text) != null).length;
    final total = ratePairs.length + staleItems.length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.updateAllTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _refreshCard(context, rates, open, base),
                const SizedBox(height: 8),
                DateField(
                  label: l10n.asOfLabel,
                  value: asOfDate,
                  lastDate: today,
                  onChanged: (d) => setState(() => _asOf = d),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.showAll),
                  value: _showAll,
                  onChanged: (v) => setState(() => _showAll = v),
                ),
                if (total == 0)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.allUpToDate(
                        MaterialLocalizations.of(context)
                            .formatMonthYear(today),
                      ),
                    ),
                  ),
                if (ratePairs.isNotEmpty) ...[
                  Text(
                    l10n.ratesStillOld,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  for (final (from, to) in ratePairs)
                    _rateRow(context, rates, from, to, today),
                ],
                if (staleItems.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.valuesHeading,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  for (final h in staleItems) _valueRow(context, calc, h),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text(l10n.filledCount('$filled', '$total'))),
                FilledButton(
                  key: const ValueKey('update-save'),
                  onPressed: () => _save(ratePairs, staleItems, total - filled),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _refreshCard(
    BuildContext context,
    List<Rate> rates,
    List<InvestmentWithHistory> open,
    Unit base,
  ) {
    final l10n = context.l10n;
    final state = ref.watch(refreshControllerProvider);
    final fetched = rates.where((r) => r.source == RateSource.currencyApi);
    final lastFetched = fetched.isEmpty
        ? null
        : fetched.map((r) => r.asOf).reduce((a, b) => a.isAfter(b) ? a : b);
    final status = switch (state) {
      RefreshRunning() => l10n.refreshRunning,
      RefreshDone(result: RefreshSucceeded(:final asOf, :final inserted)) =>
        l10n.refreshDone(context.date(asOf), l10n.refreshSource, '$inserted'),
      RefreshDone(result: RefreshFailed()) => l10n.refreshFailed,
      RefreshIdle() =>
        lastFetched == null
            ? null
            : l10n.lastRefresh(context.date(lastFetched), l10n.refreshSource),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              key: const ValueKey('refresh'),
              onPressed: state is RefreshRunning
                  ? null
                  : () => ref
                        .read(refreshControllerProvider.notifier)
                        .refresh(_pairsInUse(open, base)),
              child: Text(l10n.refreshRates),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.refreshHelp,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (state is RefreshRunning) const LinearProgressIndicator(),
            if (status != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(status, key: const ValueKey('refresh-status')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _rateRow(
    BuildContext context,
    List<Rate> rates,
    Unit from,
    Unit to,
    DateTime today,
  ) {
    final l10n = context.l10n;
    final last = rates
        .where(
          (r) =>
              (r.from == from && r.to == to) || (r.from == to && r.to == from),
        )
        .fold<Rate?>(
          null,
          (a, r) => a == null || r.asOf.isAfter(a.asOf) ? r : a,
        );
    final hint = last == null
        ? null
        : l10n.lastHint(
            context.amount(
              last.from == from ? last.rate : divide(Decimal.one, last.rate),
              digits: 4,
            ),
            context.date(last.asOf),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AmountField(
        key: ValueKey('rate-${from.code}-${to.code}'),
        controller: _ctl('rate-${from.code}-${to.code}'),
        label: l10n.rateRowLabel(from.code, to.code),
        suffix: hint,
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _valueRow(
    BuildContext context,
    PortfolioCalculator calc,
    InvestmentWithHistory h,
  ) {
    final l10n = context.l10n;
    final item = h.investment;
    final tl = calc.timeline(item.id);
    final last = tl.recordedValueAt(ref.read(todayProvider));
    final lastDate = tl.latestValueDate;
    final ctl = _ctl('item-${item.id}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AmountField(
              key: ValueKey('item-${item.id}'),
              controller: ctl,
              label: '${item.name} (${item.unit.code})',
              suffix: l10n.lastHint(
                context.amount(last),
                context.date(lastDate),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            key: ValueKey('same-${item.id}'),
            onPressed: () => setState(() => ctl.text = last.toString()),
            child: Text(l10n.same),
          ),
        ],
      ),
    );
  }
}
