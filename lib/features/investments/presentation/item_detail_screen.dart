/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/money/money.dart';
import '../domain/expected_plan.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../domain/item_timeline.dart';
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
import 'widgets/plan_chart.dart';

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
    final plan = ref.watch(expectedProvider(item.id));
    final today = ref.watch(todayProvider);
    final tl = ref.watch(calculatorProvider).value!.timeline(item.id);
    final toPurify = tl.toPurifyAt(today);
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
          if (item.shariahRisk)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ActionChip(
                key: const ValueKey('shariah-risk-tag'),
                avatar: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                label: Text(l10n.shariahRiskTag),
                onPressed: () => showWhy(context, whyCase(context, PeCase.b)!),
              ),
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
          if (plan != null && plan.hasPending) _ToConfirmCard(plan: plan),
          _returnsCard(context, ref, since, settings, differs),
          if (item.peCase == PeCase.c)
            Text(
              l10n.caseCReturnsLine,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (plan != null) _PlanCard(plan: plan),
          if (toPurify.amount > Decimal.zero)
            _purifyCard(context, toPurify, item, tl),
          _zakatLine(context, item, settings),
          const SizedBox(height: 8),
          Text(l10n.history, style: Theme.of(context).textTheme.titleMedium),
          for (final e in history)
            if (_shown(e, plan)) _historyTile(context, e, item, plan),
        ],
      ),
    );
  }

  DateTime _closeDate(InvestmentWithHistory h) => h.history
      .where((e) => e is! PlanSkip)
      .fold(h.investment.startDate, (a, e) => e.date.isAfter(a) ? e.date : a);

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

  /// A skip is listed only while it still decides its row (spec 12.10).
  bool _shown(HistoryEntry e, ExpectedVsActual? plan) =>
      e is! PlanSkip ||
      (plan != null &&
          [
            ...plan.payoutRows,
            ...plan.valueRows,
          ].any((r) => r.skip?.id == e.id));

  Widget _purifyCard(
    BuildContext context,
    Money toPurify,
    Investment item,
    ItemTimeline tl,
  ) {
    final l10n = context.l10n;
    final payouts = item.peCase == PeCase.c
        ? sumOf([
            for (final x in tl.aggregate.history)
              if (x is MoneyOut && x.kind == MoneyOutKind.income)
                ?tl.inItemUnit(x),
          ])
        : Decimal.zero;
    return Card(
      child: ListTile(
        title: Text(
          l10n.toPurifyItem(context.money(toPurify.amount, toPurify.unit)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (payouts > Decimal.zero)
              Text(
                l10n.toPurifyIncludesPayouts(context.money(payouts, item.unit)),
              ),
            TextButton(
              onPressed: () => showRecordSheet(
                context,
                investmentId: item.id,
                preset: RecordPreset.interestGivenAway,
              ),
              child: Text(l10n.recordGivenAway),
            ),
          ],
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
        ZakatNotice.profitPayoutsOnly => l10n.noticeProfitPayoutsOnly(
          context.percent(settings.zakatYear!.r).replaceAll('+', ''),
        ),
        ZakatNotice.capitalBackIsDebt => l10n.noticeCapitalBackIsDebt,
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
          if (whyCase(context, item.peCase) case final why?) ...[
            Text(why.what, key: const ValueKey('case-notice')),
            if (why.numbers != null) Text(why.numbers!),
            Wrap(
              children: [
                TextButton(
                  onPressed: () => showWhy(context, why),
                  child: Text(l10n.source),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => InvestmentFormScreen(editId: item.id),
                    ),
                  ),
                  child: Text(l10n.changeAnswers),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _historyTile(
    BuildContext context,
    HistoryEntry e,
    Investment item,
    ExpectedVsActual? plan,
  ) {
    final l10n = context.l10n;
    final skippedRow = e is PlanSkip
        ? [
            ...plan!.payoutRows,
            ...plan.valueRows,
          ].firstWhere((r) => r.skip?.id == e.id)
        : null;
    final below =
        e is ValueUpdate &&
        (plan?.valueChecks.any((c) => c.entry.id == e.id && c.below) ?? false);
    final note = skippedRow != null && skippedRow.noPayoutLine
        ? noPayoutText(context, skippedRow, item)
        : below
        ? l10n.valueBelowEstimate
        : null;
    final (label, amount) = switch (e) {
      MoneyIn(:final amount) => (
        l10n.kindMoneyIn,
        context.money(amount.amount, amount.unit, signed: true),
      ),
      MoneyOut(:final amount, :final kind) => (
        kind == MoneyOutKind.sale
            ? l10n.kindSale
            : item.peCase == PeCase.c
            ? l10n.kindPayoutPurify
            : l10n.kindIncome,
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
      PlanSkip() => (l10n.kindSkipped, ''),
    };
    return ListTile(
      key: ValueKey('history-${e.id}'),
      dense: true,
      title: Text(label),
      subtitle: Text(
        note == null ? context.date(e.date) : '${context.date(e.date)}\n$note',
      ),
      trailing: Text(amount),
      onTap: () => skippedRow != null
          ? showRecordSheet(context, investmentId: item.id, row: skippedRow)
          : showRecordSheet(context, investmentId: item.id, editing: e),
    );
  }
}

/// "No payout recorded for {from} – {to}. Expected around {date}." (P-3); on
/// private equity: "In a partnership, no profit means no payout."
String noPayoutText(BuildContext context, PlanRow r, Investment item) {
  final l10n = context.l10n;
  final line = l10n.noPayoutLine(
    context.date(r.from),
    context.date(r.date),
    context.date(r.date),
  );
  return item.type == AssetType.privateEquity
      ? '$line ${l10n.noPayoutPartnership}'
      : line;
}

String _rowLabel(BuildContext context, PlanRow r, Investment item) {
  final l10n = context.l10n;
  if (r.kind == PlanKind.value) return l10n.rowValueExpected;
  if (item.conventionalDeposit) return l10n.rowInterest;
  if (item.peCase == PeCase.c) return l10n.rowPayoutPurify;
  return l10n.rowPayout;
}

/// The record a check mark writes: at the shown amount, on the row date
/// (story §5.6); conventional deposit: interest paid out (P-4b).
HistoryEntry _recordOf(PlanRow r, ExpectedVsActual plan) {
  final item = plan.investment;
  final amount = Money(r.expected!, item.unit);
  if (r.kind == PlanKind.value) {
    // The estimate is net; a stored value is gross of interest kept inside.
    return ValueUpdate(
      investmentId: item.id,
      date: r.date,
      value: r.expected! + plan.timeline.heldInterestAt(r.date),
    );
  }
  return item.conventionalDeposit
      ? InterestRecord(
          investmentId: item.id,
          date: r.date,
          amount: amount,
          kind: InterestKind.paidOut,
        )
      : MoneyOut(
          investmentId: item.id,
          date: r.date,
          amount: amount,
          kind: MoneyOutKind.income,
        );
}

/// S4 "To confirm": pending rows, oldest first; ✓ is one tap, no form.
class _ToConfirmCard extends ConsumerStatefulWidget {
  const _ToConfirmCard({required this.plan});

  final ExpectedVsActual plan;

  @override
  ConsumerState<_ToConfirmCard> createState() => _ToConfirmCardState();
}

class _ToConfirmCardState extends ConsumerState<_ToConfirmCard> {
  var _all = false;

  /// One write at a time: a second tap must not record twice.
  var _busy = false;

  Investment get _item => widget.plan.investment;

  /// Writes [entries] in one transaction and offers one Undo for all of them.
  Future<void> _write(List<HistoryEntry> entries, String done) async {
    if (_busy) return;
    setState(() => _busy = true);
    final repo = ref.read(investmentsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final undo = l10n.undo;
    try {
      await repo.saveEntries(entries);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errSave)));
      return;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(done),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: undo,
          onPressed: () => repo.deleteEntries([for (final e in entries) e.id]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final rows = widget.plan.pendingRows.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final withAmount = rows.where((r) => r.expected != null).toList();
    final noAmount = rows.length - withAmount.length;
    final shown = _all ? rows : rows.take(3).toList();
    return Card(
      key: const ValueKey('to-confirm'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  l10n.toConfirmTitle(rows.length),
                  style: theme.textTheme.titleMedium,
                ),
                if (withAmount.isNotEmpty)
                  TextButton(
                    key: const ValueKey('confirm-all'),
                    onPressed: _busy
                        ? null
                        : () => _write([
                            for (final r in withAmount)
                              _recordOf(r, widget.plan),
                          ], l10n.recordedAllSnack(withAmount.length)),
                    child: Text(l10n.confirmAll),
                  ),
              ],
            ),
            if (rows.any((r) => r.kind == PlanKind.payout))
              Text(l10n.confirmAllLine, style: theme.textTheme.bodySmall),
            if (rows.any((r) => r.kind == PlanKind.value))
              Text(l10n.confirmValueLine, style: theme.textTheme.bodySmall),
            if (noAmount > 0)
              Text(
                l10n.rowsNeedAmount(noAmount),
                style: theme.textTheme.bodySmall,
              ),
            for (final r in shown) _row(context, r),
            if (!_all && rows.length > 3)
              TextButton(
                onPressed: () => setState(() => _all = true),
                child: Text(l10n.showMoreRows(rows.length - 3)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, PlanRow r) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final key = '${r.kind.name}-${r.date.toIso8601String().substring(0, 10)}';
    void edit() => showRecordSheet(context, investmentId: _item.id, row: r);
    // Small phones and large text: the date moves into the label column so
    // the check mark keeps its 48 dp (UX 2.12.7).
    final narrow =
        MediaQuery.sizeOf(context).width < 400 ||
        MediaQuery.textScalerOf(context).scale(1) > 1;
    final date = Text(context.date(r.date), key: ValueKey('date-$key'));
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (narrow) date,
        Text(_rowLabel(context, r, _item)),
        if (r.expected != null)
          Text(
            context.money(r.expected!, _item.unit),
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        if (r.noPayoutLine)
          Text(
            noPayoutText(context, r, _item),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
    return InkWell(
      key: ValueKey('row-$key'),
      onTap: edit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 8, top: 2),
              child: Icon(Icons.radio_button_unchecked, size: 18),
            ),
            Expanded(
              child: MergeSemantics(
                child: narrow
                    ? text
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 88, child: date),
                          Expanded(child: text),
                        ],
                      ),
              ),
            ),
            if (r.expected != null)
              IconButton.filledTonal(
                key: ValueKey('check-$key'),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                tooltip: r.kind == PlanKind.value
                    ? l10n.valueAsExpected
                    : l10n.receivedThisAmount,
                icon: const Icon(Icons.check),
                onPressed: _busy
                    ? null
                    : () => _write(
                        [_recordOf(r, widget.plan)],
                        l10n.recordedSnack(
                          context.money(r.expected!, _item.unit),
                          context.date(r.date),
                        ),
                      ),
              )
            else
              TextButton(
                key: ValueKey('add-$key'),
                onPressed: _busy ? null : edit,
                child: Text(
                  r.kind == PlanKind.value ? l10n.addValue : l10n.addAmount,
                ),
              ),
            PopupMenuButton<bool>(
              key: ValueKey('menu-$key'),
              enabled: !_busy,
              onSelected: (skip) => skip
                  ? _write([
                      PlanSkip(
                        investmentId: _item.id,
                        date: r.date,
                        plan: r.kind,
                      ),
                    ], l10n.skippedSnack)
                  : edit(),
              itemBuilder: (_) => [
                PopupMenuItem(value: false, child: Text(l10n.edit)),
                PopupMenuItem(value: true, child: Text(l10n.skipRow)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// S4 "Plan vs actual": one part at a time, Payouts | Value (UX 2.12.5).
class _PlanCard extends StatefulWidget {
  const _PlanCard({required this.plan});

  final ExpectedVsActual plan;

  @override
  State<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard> {
  PlanKind? _part;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = widget.plan;
    final parts = [
      if (p.hasPayoutPlan) PlanKind.payout,
      if (p.hasValuePlan) PlanKind.value,
    ];
    final part = parts.contains(_part) ? _part! : parts.first;
    return Card(
      key: const ValueKey('plan-card'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.planCardTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (parts.length > 1)
              SegmentedButton<PlanKind>(
                key: const ValueKey('plan-switch'),
                segments: [
                  ButtonSegment(
                    value: PlanKind.payout,
                    label: Text(l10n.blockPayouts),
                  ),
                  ButtonSegment(
                    value: PlanKind.value,
                    label: Text(l10n.tabValue),
                  ),
                ],
                selected: {part},
                onSelectionChanged: (s) => setState(() => _part = s.first),
              ),
            for (final m in p.missing.take(1))
              Text(
                l10n.needsRateForEstimates(
                  context.pair(m.from, m.to),
                  context.date(m.date),
                ),
              ),
            ...(part == PlanKind.payout ? _payouts(context) : _value(context)),
            Text(
              l10n.chartLegend,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              l10n.estimatesFooter,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _tooltip(
    BuildContext context,
    ChartPoint point,
    bool expected,
    PlanKind kind,
  ) {
    final l10n = context.l10n;
    final state = point.hollow
        ? l10n.stateToConfirm
        : expected
        ? l10n.expectedSoFar
        : kind == PlanKind.payout
        ? l10n.stateReceived
        : l10n.stateRecorded;
    final label = kind == PlanKind.payout ? l10n.blockPayouts : l10n.rowValue;
    return '${context.date(point.date)} · $label · '
        '${context.money(point.amount, widget.plan.investment.unit)} · $state';
  }

  List<Widget> _payouts(BuildContext context) {
    final l10n = context.l10n;
    final p = widget.plan;
    final unit = p.investment.unit;
    final pending = p.payoutRows.where((r) => r.pending).length;
    Widget line(String label, String value, String key) => Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, key: ValueKey(key)),
      ],
    );
    final expected = p.expectedSoFar;
    return [
      if (expected != null) ...[
        line(
          l10n.expectedSoFar,
          context.money(expected, unit),
          'expected-so-far',
        ),
        line(l10n.receivedLabel, context.money(p.received, unit), 'received'),
        line(
          l10n.differenceLabel,
          context.money(p.difference!, unit, signed: true),
          'difference',
        ),
      ] else
        Text(
          l10n.receivedSinceStart(context.money(p.received, unit)),
          key: const ValueKey('received-since-start'),
        ),
      if (p.investment.peCase == PeCase.c) Text(l10n.caseCReceived),
      PlanChart(
        key: const ValueKey('payouts-chart'),
        series: payoutSeries(p),
        semanticsLabel: l10n.chartPayoutsSummary(
          expected == null ? '—' : context.money(expected, unit),
          context.money(p.received, unit),
          pending,
        ),
        tooltip: (pt, e) => _tooltip(context, pt, e, PlanKind.payout),
      ),
    ];
  }

  List<Widget> _value(BuildContext context) {
    final l10n = context.l10n;
    final p = widget.plan;
    final unit = p.investment.unit;
    final last = p.valueChecks.lastOrNull;
    final pending = p.valueRows.where((r) => r.pending).length;
    final today = p.expectedValueAt(p.today);
    return [
      if (last != null) ...[
        Text(
          l10n.valueVsEstimate(
            context.money(last.actualNet, unit),
            context.money(last.expected, unit),
            context.money(last.diff, unit, signed: true),
            last.diffPct == null ? '—' : context.percent(last.diffPct!),
          ),
          key: const ValueKey('value-vs-estimate'),
        ),
        if (last.below) Text(l10n.valueBelowEstimate),
      ],
      PlanChart(
        key: const ValueKey('value-chart'),
        series: valueSeries(p),
        semanticsLabel: l10n.chartValueSummary(
          today == null ? '—' : context.money(today, unit),
          context.money(p.timeline.netValueAt(p.today), unit),
          pending,
        ),
        tooltip: (pt, e) => _tooltip(context, pt, e, PlanKind.value),
      ),
    ];
  }
}
