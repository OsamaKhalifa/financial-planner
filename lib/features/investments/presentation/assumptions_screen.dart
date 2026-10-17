/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/rate.dart';
import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/dates.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/units.dart';
import '../domain/investment.dart';
import 'inflation_series_screen.dart';
import 'investments_providers.dart';
import 'rate_history_screen.dart';
import 'update_all_screen.dart';
import 'why_sheet.dart';
import 'widgets/labels.dart';
import 'widgets/no_zakat_block.dart';
import 'widgets/unit_picker_sheet.dart';

/// S8: the assumptions behind every number, in one place.
class AssumptionsScreen extends ConsumerWidget {
  const AssumptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final rates = ref.watch(ratesProvider).value;
    final items = ref.watch(investmentsProvider).value;
    if (settings == null || rates == null || items == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.assumptionsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final today = ref.watch(todayProvider);
    final actions = ref.read(settingsActionsProvider);
    final base = settings.baseCurrency!;
    final home = settings.homeCountry!;
    final firstYear = items.isEmpty
        ? today.year
        : items
              .map((h) => h.investment.startDate.year)
              .reduce((a, b) => a < b ? a : b);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.assumptionsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.baseAndHome, style: textTheme.titleSmall),
          ListTile(
            key: const ValueKey('base-row'),
            title: Text(l10n.baseLine(base.code)),
            trailing: TextButton(
              onPressed: () => _changeBase(context, ref, base),
              child: Text(l10n.change),
            ),
          ),
          ListTile(
            key: const ValueKey('home-row'),
            title: Text(
              l10n.homeInflationLine(context.countryName(home), base.code),
            ),
            trailing: TextButton(
              onPressed: () async {
                final c = await showCountryPicker(context);
                if (c != null) await actions.setHome(c);
              },
              child: Text(l10n.change),
            ),
          ),
          const Divider(),
          Text(l10n.ratesHeading, style: textTheme.titleSmall),
          _rates(context, ref, rates, items, base, today),
          const Divider(),
          Text(l10n.inflationHeading, style: textTheme.titleSmall),
          for (final c in _series(items, home))
            ListTile(
              key: ValueKey('series-${c.iso3}'),
              title: Text(l10n.inflationRow(context.countryName(c))),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => InflationSeriesScreen(country: c),
                ),
              ),
            ),
          const Divider(),
          Text(l10n.zakatHeading, style: textTheme.titleSmall),
          _zakat(context, settings, actions),
          const Divider(),
          Text(l10n.noZakatByYear, style: textTheme.titleSmall),
          for (var y = today.year; y >= firstYear; y--) NoZakatBlock(year: y),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const UpdateAllScreen()),
            ),
            child: Text(l10n.updateAll),
          ),
        ],
      ),
    );
  }

  Future<void> _changeBase(
    BuildContext context,
    WidgetRef ref,
    Unit base,
  ) async {
    final l10n = context.l10n;
    final actions = ref.read(settingsActionsProvider);
    final picked = await showUnitPicker(context, anchor: base, selected: base);
    if (picked == null || picked == base || !context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.baseChangeWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.change),
          ),
        ],
      ),
    );
    if (ok == true) await actions.setBase(picked);
  }

  /// Countries of the series in use: home, then each item's own series.
  List<Country> _series(List<InvestmentWithHistory> items, Country home) {
    final out = <Country>{home};
    for (final h in items) {
      final i = h.investment;
      final c =
          i.inflationOverride ??
          (i.type == AssetType.stock ||
                  i.type == AssetType.fund ||
                  i.type == AssetType.sukuk
              ? i.marketCountryResolved
              : null) ??
          (i.unit.isMetal ? home : defaultCountryOf(i.unit));
      out.add(c);
    }
    return out.toList();
  }

  Widget _rates(
    BuildContext context,
    WidgetRef ref,
    List<Rate> rates,
    List<InvestmentWithHistory> items,
    Unit base,
    DateTime today,
  ) {
    final l10n = context.l10n;
    final inUse = <(Unit, Unit)>{
      for (final h in items)
        if (h.investment.unit != base) (h.investment.unit, base),
    };
    final stored = <(Unit, Unit)>{
      for (final r in rates)
        if (!inUse.contains((r.from, r.to)) && !inUse.contains((r.to, r.from)))
          (r.from.code.compareTo(r.to.code) < 0)
              ? (r.from, r.to)
              : (r.to, r.from),
    };
    final book = RateBook(rates);
    final monthStart = day(today.year, today.month, 1);
    Widget row((Unit, Unit) pair) {
      final q = book.quote(pair.$1, pair.$2, today);
      final sameDay = q == null
          ? <Rate>[]
          : rates
                .where(
                  (r) =>
                      r.asOf == q.asOf &&
                      ((r.from == pair.$1 && r.to == pair.$2) ||
                          (r.from == pair.$2 && r.to == pair.$1)),
                )
                .toList();
      final fetched = sameDay.where((r) => r.source == RateSource.currencyApi);
      final typedAlso = sameDay.any((r) => r.source == RateSource.typed);
      return ListTile(
        key: ValueKey('rate-${pair.$1.code}-${pair.$2.code}'),
        title: Text(
          q == null
              ? l10n.rateMissingAdd(pair.$1.code, pair.$2.code)
              : l10n.rateLine(
                  pair.$1.code,
                  context.amount(q.rate, digits: 4),
                  pair.$2.code,
                  context.date(q.asOf),
                ),
        ),
        subtitle: q == null
            ? Text(l10n.rateMissingMarker)
            : Text(
                [
                  if (q.source == RateSource.typed)
                    l10n.rateTagTyped
                  else
                    l10n.rateTagFetched(l10n.refreshSource),
                  if (typedAlso && fetched.isNotEmpty)
                    l10n.rateTypedUsed(
                      context.amount(fetched.first.rate, digits: 4),
                    ),
                  if (q.asOf.isBefore(monthStart)) l10n.rateStaleMarker,
                ].join(' · '),
              ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RateHistoryScreen(from: pair.$1, to: pair.$2),
          ),
        ),
      );
    }

    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: FilledButton.tonal(
            key: const ValueKey('assumptions-refresh'),
            onPressed: () => ref
                .read(refreshControllerProvider.notifier)
                .refresh({...inUse, (xauG, base), (xagG, base)}),
            child: Text(l10n.refreshRates),
          ),
        ),
        if (inUse.isEmpty && stored.isEmpty) Text(l10n.noRatesYet),
        for (final p in inUse) row(p),
        for (final p in stored) row(p),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => showRateDialog(
              context,
              from: base == const Unit('USD')
                  ? const Unit('EUR')
                  : const Unit('USD'),
              to: base,
            ),
            child: Text(l10n.addRate),
          ),
        ),
      ],
    );
  }

  Widget _zakat(
    BuildContext context,
    Settings settings,
    SettingsActions actions,
  ) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.zakatYearTitle)),
            TextButton(
              onPressed: () => showWhy(
                context,
                Why(
                  title: l10n.zakatYearTitle,
                  what: l10n.zakatYearWhy,
                  source: l10n.src_A1A2,
                ),
              ),
              child: Text(l10n.source),
            ),
          ],
        ),
        RadioGroup<ZakatYear>(
          groupValue: settings.zakatYear,
          onChanged: (v) => actions.setZakatYear(v!),
          child: Column(
            children: [
              RadioListTile<ZakatYear>(
                key: const ValueKey('year-lunar'),
                value: ZakatYear.lunar,
                title: Text(l10n.zakatYearLunar),
              ),
              RadioListTile<ZakatYear>(
                key: const ValueKey('year-solar'),
                value: ZakatYear.solar,
                title: Text(l10n.zakatYearSolar),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: Text(l10n.longTermTitle)),
            TextButton(
              onPressed: () => showWhy(
                context,
                Why(
                  title: l10n.longTermTitle,
                  what: l10n.longTermWhy,
                  source: l10n.src_B3,
                ),
              ),
              child: Text(l10n.source),
            ),
          ],
        ),
        RadioGroup<LongTermMethod>(
          groupValue: settings.longTermMethod,
          onChanged: (v) => actions.setLongTermMethod(v),
          child: Column(
            children: [
              RadioListTile<LongTermMethod>(
                key: const ValueKey('method-dividendsOnly'),
                value: LongTermMethod.dividendsOnly,
                title: Text(l10n.longTermDividendsOnly),
              ),
              RadioListTile<LongTermMethod>(
                key: const ValueKey('method-proxy25'),
                value: LongTermMethod.proxy25,
                title: Text(l10n.longTermProxy25),
              ),
              RadioListTile<LongTermMethod>(
                key: const ValueKey('method-fullValue'),
                value: LongTermMethod.fullValue,
                title: Text(l10n.longTermFullValue),
              ),
              RadioListTile<LongTermMethod>(
                key: const ValueKey('method-perItem'),
                value: LongTermMethod.perItem,
                title: Text(l10n.longTermPerItem),
              ),
            ],
          ),
        ),
        Text(l10n.jewelleryAsk),
        if (settings.jewelleryZakatable == null) Text(l10n.jewelleryNotAsked),
        RadioGroup<bool>(
          groupValue: settings.jewelleryZakatable,
          onChanged: (v) => actions.setJewellery(zakatable: v!),
          child: Column(
            children: [
              RadioListTile<bool>(
                key: const ValueKey('assumptions-jewellery-yes'),
                value: true,
                title: Text(l10n.jewelleryYes),
              ),
              RadioListTile<bool>(
                key: const ValueKey('assumptions-jewellery-no'),
                value: false,
                title: Text(l10n.jewelleryNo),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
