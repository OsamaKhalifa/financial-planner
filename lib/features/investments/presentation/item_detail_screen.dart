/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../domain/portfolio_calculator.dart';
import '../domain/zakat_rules.dart';
import 'investment_form_screen.dart';
import 'investments_providers.dart';
import 'period_screen.dart';
import 'record_sheet.dart';
import 'why_builders.dart';
import 'why_sheet.dart';
import 'widgets/inflation_tag.dart';
import 'widgets/labels.dart';

/// S4: returns since start, zakat line and the whole history.
class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.investmentId});

  final String investmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(investmentsProvider).value;
    final settings = ref.watch(settingsProvider).value;
    final since = ref.watch(sinceStartProvider(investmentId));
    final matches = items?.where((h) => h.investment.id == investmentId);
    if (matches == null ||
        matches.isEmpty ||
        settings == null ||
        since == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final h = matches.first;
    final item = h.investment;
    final f = since.figures;
    final base = settings.baseCurrency!;
    final closed = f.closed;
    final history = [...h.history]
      ..sort((a, b) {
        final c = b.date.compareTo(a.date);
        return c != 0 ? c : b.createdAt.compareTo(a.createdAt);
      });
    final differs = item.unit != base;
    final ev = f.itemUnit?.dietz.ev;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => InvestmentFormScreen(editId: item.id),
              ),
            ),
            child: Text(l10n.edit),
          ),
        ],
      ),
      floatingActionButton: closed
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showRecordSheet(context, investmentId: item.id),
              icon: const Icon(Icons.add),
              label: Text(l10n.record),
            ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(
            _subtitle(context, item),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          if (closed)
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(l10n.closedOn(context.date(_closeDate(h)))),
              ),
            ),
          if (ev != null)
            Text(
              context.money(ev, item.unit),
              key: const ValueKey('value-now'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          if (differs && f.base != null)
            Text(l10n.approxInBase(context.money(f.base!.dietz.ev, base))),
          Text(l10n.valueFromDate(context.date(f.period.e))),
          const SizedBox(height: 12),
          _returnsCard(context, ref, since, settings, differs),
          if (f.toPurify.amount > Decimal.zero)
            _purifyCard(context, f, item.id),
          _zakatLine(context, item, settings),
          const SizedBox(height: 8),
          Text(l10n.history, style: Theme.of(context).textTheme.titleMedium),
          for (final e in history) _historyTile(context, e, item),
        ],
      ),
    );
  }

  DateTime _closeDate(InvestmentWithHistory h) => h.history.fold(
    h.investment.startDate,
    (a, e) => e.date.isAfter(a) ? e.date : a,
  );

  String _subtitle(BuildContext context, Investment item) {
    final parts = [
      context.assetTypeName(item.type),
      if (item.market != null) context.marketName(item.market!),
      if (item.intent != null) context.intentName(item.intent!),
    ];
    return parts.join(' · ');
  }

  Widget _returnsCard(
    BuildContext context,
    WidgetRef ref,
    SinceStartFigures since,
    Settings settings,
    bool differs,
  ) {
    final l10n = context.l10n;
    final f = since.figures;
    final unitReturns = f.itemUnit;
    final baseReturns = f.base;
    final item = ref
        .watch(investmentsProvider)
        .value!
        .firstWhere((h) => h.investment.id == investmentId)
        .investment;
    final base = settings.baseCurrency!;
    final year = settings.zakatYear ?? ZakatYear.lunar;
    String? pct(Decimal? v) => v == null ? null : context.percent(v);
    Widget row(
      String label, {
      String? itemValue,
      String? baseValue,
      Why? why,
      bool emphasis = false,
    }) {
      final style = emphasis ? Theme.of(context).textTheme.titleSmall : null;
      return InkWell(
        onTap: why == null ? null : () => showWhy(context, why),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(label, style: style)),
              if (differs)
                Expanded(
                  flex: 2,
                  child: Text(
                    itemValue ?? '—',
                    textAlign: TextAlign.end,
                    style: style,
                  ),
                ),
              Expanded(
                flex: 2,
                child: Text(
                  baseValue ?? '—',
                  textAlign: TextAlign.end,
                  style: style,
                ),
              ),
              SizedBox(
                width: 22,
                child: why == null
                    ? null
                    : const Icon(Icons.info_outline, size: 18),
              ),
            ],
          ),
        ),
      );
    }

    final needsRate = f.excluded;
    final ownTag = unitReturns == null
        ? null
        : inflationTag(context, ref, f.inflationCountry, unitReturns.inflation);
    final homeTag = baseReturns == null
        ? null
        : inflationTag(context, ref, f.homeCountry, baseReturns.inflation);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sinceStart,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (differs)
              Row(
                children: [
                  const Expanded(flex: 3, child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Text(
                      l10n.colItem(item.unit.code),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      l10n.colItem(base.code),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            row(
              l10n.rowGain,
              itemValue: context.money(since.gain, item.unit, signed: true),
              baseValue: since.gainBase == null
                  ? null
                  : context.money(since.gainBase!, base, signed: true),
            ),
            row(
              l10n.rowReturn,
              itemValue: pct(unitReturns?.dietz.r),
              baseValue: pct(baseReturns?.dietz.r),
              why: baseReturns == null
                  ? null
                  : whyReturn(context, baseReturns, base),
            ),
            if (since.annualised != null || since.annualisedBase != null)
              row(
                l10n.rowPerYear,
                itemValue: pct(since.annualised),
                baseValue: pct(since.annualisedBase),
              ),
            row(
              l10n.rowSetAside,
              baseValue: baseReturns == null
                  ? null
                  : context.money(-baseReturns.z, base, signed: true),
              why: baseReturns == null
                  ? null
                  : whySetAside(
                      context,
                      baseReturns,
                      f.zakat,
                      year,
                      f.period.days,
                      base,
                      type: item.type,
                    ),
            ),
            row(
              l10n.rowReturnAfter,
              itemValue: pct(unitReturns?.rz),
              baseValue: pct(baseReturns?.rz),
            ),
            if (differs)
              row(
                l10n.rowRealOwn(context.countryName(f.inflationCountry)),
                itemValue: pct(unitReturns?.real),
                why: unitReturns == null
                    ? null
                    : whyReal(context, unitReturns, ownTag),
              ),
            row(
              differs
                  ? l10n.rowRealBase(context.countryName(f.homeCountry))
                  : l10n.rowRealOwn(context.countryName(f.homeCountry)),
              itemValue: null,
              baseValue: pct(baseReturns?.real),
              why: baseReturns == null
                  ? null
                  : whyReal(context, baseReturns, homeTag),
            ),
            Text(l10n.realLabel, style: Theme.of(context).textTheme.bodySmall),
            if (homeTag != null)
              Text(homeTag, style: Theme.of(context).textTheme.bodySmall),
            if (needsRate != null)
              Text(l10n.needsRate(needsRate.from.code, needsRate.to.code)),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PeriodScreen(
                      initialYear: ref.read(todayProvider).year,
                      scopeItemId: item.id,
                    ),
                  ),
                ),
                child: Text(l10n.byMonthYear),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _purifyCard(BuildContext context, ItemFigures f, String id) {
    final l10n = context.l10n;
    return Card(
      child: ListTile(
        title: Text(
          l10n.toPurifyItem(context.money(f.toPurify.amount, f.toPurify.unit)),
        ),
        subtitle: TextButton(
          onPressed: () => showRecordSheet(
            context,
            investmentId: id,
            preset: RecordPreset.interestGivenAway,
          ),
          child: Text(l10n.recordGivenAway),
        ),
        trailing: const Icon(Icons.info_outline),
        onTap: () => showWhy(context, whyToPurify(context)),
      ),
    );
  }

  Widget _zakatLine(BuildContext context, Investment item, Settings settings) {
    final l10n = context.l10n;
    // A missing zakat answer throws here on purpose: it must not be hidden.
    final r = resolve(item, settings);
    final head = r.onDividends
        ? l10n.zakatLineDividends
        : item.zakatRule == ZakatRule.companyPaysZakat
        ? l10n.zakatLineCompany
        : l10n.zakatLinePercent(context.percent(r.share).replaceAll('+', ''));
    final notes = [
      switch (r.notice) {
        ZakatNotice.dividendsCountedWithCash => l10n.noticeDividends,
        ZakatNotice.cryptoDisputed => l10n.noticeCrypto,
        null => null,
      },
    ].nonNulls;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            key: const ValueKey('zakat-line'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final n in notes) Text(n),
          TextButton(
            onPressed: () => showWhy(
              context,
              Why(
                title: l10n.zakatSectionTitle,
                what: head,
                source: zakatSource(l10n, r.sourceSection, type: item.type),
              ),
            ),
            child: Text(l10n.source),
          ),
        ],
      ),
    );
  }

  Widget _historyTile(BuildContext context, HistoryEntry e, Investment item) {
    final l10n = context.l10n;
    final (label, amount) = switch (e) {
      MoneyIn(:final amount) => (
        l10n.kindMoneyIn,
        context.money(amount.amount, amount.unit, signed: true),
      ),
      MoneyOut(:final amount, :final kind) => (
        kind == MoneyOutKind.sale ? l10n.kindSale : l10n.kindIncome,
        context.money(-amount.amount, amount.unit, signed: true),
      ),
      InterestRecord(:final amount, :final kind) => (
        switch (kind) {
          InterestKind.keptInside => l10n.kindInterestKept,
          InterestKind.paidOut => l10n.kindInterestPaid,
          InterestKind.givenAwayFromInside => l10n.kindGivenInside,
          InterestKind.givenAwayFromPaidOut => l10n.kindGivenPaid,
        },
        context.money(amount.amount, amount.unit),
      ),
      ValueUpdate(:final value) => (
        l10n.kindValue,
        context.money(value, item.unit),
      ),
    };
    return ListTile(
      key: ValueKey('history-${e.id}'),
      dense: true,
      title: Text(label),
      subtitle: Text(context.date(e.date)),
      trailing: Text(amount),
      onTap: () => showRecordSheet(context, investmentId: item.id, editing: e),
    );
  }
}
