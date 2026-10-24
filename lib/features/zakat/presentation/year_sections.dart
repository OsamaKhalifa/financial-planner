/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../investments/domain/investment.dart';
import '../../investments/domain/zakat_rules.dart';
import '../../investments/presentation/assumptions_screen.dart';
import '../../investments/presentation/investment_form_screen.dart';
import '../../investments/presentation/investments_providers.dart';
import '../../investments/presentation/item_detail_screen.dart';
import '../../investments/presentation/rate_history_screen.dart';
import '../../investments/presentation/record_sheet.dart';
import '../../investments/presentation/why_builders.dart';
import '../../investments/presentation/why_sheet.dart';
import '../../investments/presentation/widgets/labels.dart';
import '../domain/yearly_zakat.dart';
import '../domain/zakat_year.dart';
import 'zakat_labels.dart';
import 'zakat_providers.dart';
import 'zakat_sheets.dart';

Future<void> pushAssumptions(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const AssumptionsScreen()));

Future<void> pushAddInvestment(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const InvestmentFormScreen()));

/// An old-date marker (UX 2.4.3): text and a clock, never red.
class MarkerRow extends StatelessWidget {
  const MarkerRow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Row(
      children: [
        const Icon(Icons.schedule, size: 14),
        const SizedBox(width: 4),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}

bool _before(DateTime? d, DateTime on) => d != null && d.isBefore(on);

/// Values and rates dated before the due date. Open years are estimates on
/// today's data and have none.
bool hasOldDate(YearView v) {
  if (v.state == YearState.open) return false;
  final on = v.inputs.on;
  return v.inputs.lines.any(
        (l) =>
            (!l.isExtra && _before(l.valueDate, on)) || _before(l.rateDate, on),
      ) ||
      _before(v.inputs.metalRateDate, on);
}

Why oldDateWhy(BuildContext context, YearView v) {
  final l10n = context.l10n;
  return Why(
    title: l10n.zakatAddsTitle,
    what: l10n.zakatOldDateNote(context.date(v.slot.due)),
    assumptions: [if (v.frozen) l10n.zakatRecomputeForNewer],
    source: zakatSource(l10n, 'A7'),
  );
}

/// A label, a value and an info button; the value may wrap.
class AddsRow extends StatelessWidget {
  const AddsRow({
    super.key,
    required this.label,
    required this.value,
    required this.why,
    this.emphasis = false,
  });

  final String label;
  final String value;
  final Why why;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final style = emphasis
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return InkWell(
      onTap: () => showWhy(context, why),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: Text(label, style: style)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value, style: style, textAlign: TextAlign.end),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.only(start: 4),
              child: Icon(Icons.info_outline, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

Widget sectionHeading(BuildContext context, String text, {Widget? trailing}) =>
    Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.titleMedium),
          ),
          ?trailing,
        ],
      ),
    );

// ---------------------------------------------------------- how it adds up

class AddsUpSection extends StatelessWidget {
  const AddsUpSection(this.view, {super.key});

  final YearView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final i = view.inputs;
    final r = view.result;
    String money(Decimal? v) => v == null ? '—' : context.money(v, i.base);
    final src = zakatSource;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeading(context, l10n.zakatAddsTitle),
        AddsRow(
          label: l10n.zakatAddsLines,
          value: money(r.linesTotal),
          why: Why(
            title: l10n.zakatAddsLines,
            what: l10n.zakatWhyLinesTotal,
            source: [src(l10n, 'A7'), src(l10n, 'A8')].join('\n\n'),
          ),
        ),
        AddsRow(
          label: '− ${l10n.zakatAddsDebts}',
          value: i.deductDebts
              ? context.money(-r.debtsLine, i.base)
              : l10n.zakatAddsNotDeducted,
          why: debtsWhy(context),
        ),
        AddsRow(
          label: '= ${l10n.zakatAddsBase}',
          value: money(r.b),
          emphasis: true,
          why: Why(
            title: l10n.zakatAddsBase,
            what: l10n.zakatWhyBase,
            source: [src(l10n, 'A5'), src(l10n, 'C4')].join('\n\n'),
          ),
        ),
        _nisabRow(context),
        AddsRow(
          label: l10n.zakatAddsReaches,
          value: switch (r.reachesNisab) {
            null => '—',
            true => l10n.zakatAddsYes(money(r.b), money(r.nisab)),
            false => l10n.zakatAddsNo,
          },
          why: Why(
            title: l10n.zakatAddsReaches,
            what: l10n.zakatWhyReaches,
            source: [src(l10n, 'A3'), src(l10n, 'C4')].join('\n\n'),
          ),
        ),
        AddsRow(
          label: '× ${l10n.zakatAddsRate(i.calendar.name)}',
          value: context.percentPlain(i.calendar.r),
          why: Why(
            title: l10n.zakatAddsRate(i.calendar.name),
            what: l10n.zakatWhyRate,
            source: l10n.src_A1A2,
          ),
        ),
        AddsRow(
          label: '= ${l10n.zakatResultDue}',
          value: money(r.z),
          emphasis: true,
          why: zakatDueWhy(context, view),
        ),
      ],
    );
  }

  Widget _nisabRow(BuildContext context) {
    final l10n = context.l10n;
    final i = view.inputs;
    final rate = i.metalRate;
    final date = i.metalRateDate;
    final old = view.state != YearState.open && _before(date, i.on);
    final editable = !view.frozen;
    final label = i.nisab == null
        ? l10n.zakatSettingsNisab
        : l10n.zakatAddsNisab(i.nisab!.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddsRow(
          label: label,
          value: view.result.nisab == null
              ? '—'
              : context.money(view.result.nisab!, i.base),
          why: Why(
            title: label,
            what: l10n.zakatWhyNisab,
            assumptions: [if (view.frozen) l10n.zakatRecomputeForNewer],
            source: [
              zakatSource(l10n, 'A3'),
              zakatSource(l10n, 'Z4'),
            ].join('\n\n'),
          ),
        ),
        if (rate != null)
          Text(
            l10n.zakatAddsNisabCalc(
              context.amount(nisabGrams(i.nisab!), digits: 0),
              context.rateText(rate),
              context.date(date!),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (old) MarkerRow(l10n.zakatLineNotRateOf(context.date(i.on))),
        if (editable)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => pushAssumptions(context),
              child: Text(l10n.change),
            ),
          ),
      ],
    );
  }
}

Why zakatDueWhy(BuildContext context, YearView v) {
  final l10n = context.l10n;
  return Why(
    title: l10n.zakatResultDue,
    what: l10n.zakatAddsRounding,
    assumptions: [if (!v.inputs.deductDebts) l10n.zakatAddsDeductionOffWhy],
    source: l10n.src_A1A2,
  );
}

// ------------------------------------------------------------ investments

int _byWorth(ZakatLine a, ZakatLine b) {
  final x = a.zakatable;
  final y = b.zakatable;
  if (x == null || y == null) {
    return x == y ? a.name.compareTo(b.name) : (x == null ? -1 : 1);
  }
  final c = y.compareTo(x);
  return c != 0 ? c : a.name.compareTo(b.name);
}

class InvestmentsSection extends ConsumerWidget {
  const InvestmentsSection(this.view, {super.key});

  final YearView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final byId = {
      for (final h in ref.watch(investmentsProvider).value ?? const [])
        h.investment.id: h.investment,
    };
    final lines = view.inputs.lines.where((l) => !l.isExtra).toList()
      ..sort(_byWorth);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeading(context, l10n.zakatInvestmentsTitle(lines.length)),
        if (lines.isEmpty) ...[
          Text(l10n.zakatNoInvestments),
          if (!view.frozen)
            TextButton(
              onPressed: () => pushAddInvestment(context),
              child: Text(l10n.zakatAddInvestment),
            ),
        ] else
          for (final l in lines)
            _ItemLine(view: view, line: l, investment: byId[l.refId]),
      ],
    );
  }
}

class _ItemLine extends ConsumerWidget {
  const _ItemLine({
    required this.view,
    required this.line,
    required this.investment,
  });

  final YearView view;
  final ZakatLine line;
  final Investment? investment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final base = view.inputs.base;
    final worth = line.zakatable;
    final open = investment == null ? null : () => _open(context);
    return InkWell(
      key: ValueKey('line-${line.refId}'),
      onTap: open,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    line.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  worth == null ? '—' : context.money(worth, base),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (open != null) const Icon(Icons.chevron_right),
              ],
            ),
            _detail(context),
            if (line.heldInterest > Decimal.zero)
              Text(
                l10n.zakatLineNetInterest(
                  context.money(line.heldInterest, line.unit),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ..._notices(context),
            if (investment == null) Text(l10n.zakatLineDeleted),
            _rule(context),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    final note = view.frozen
        ? context.l10n.zakatLineFrozenBanner(context.yearLabel(view.slot))
        : null;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ItemDetailScreen(investmentId: line.refId!, frozenNote: note),
      ),
    );
  }

  Widget _detail(BuildContext context) {
    final l10n = context.l10n;
    final base = view.inputs.base;
    final style = Theme.of(context).textTheme.bodySmall;
    if (line.question != null) {
      return _withAction(
        Text(
          '${l10n.zakatQuestionName(line.question!.name)} · '
          '${l10n.zakatNotAnswered}',
        ),
        l10n.zakatFixAnswer,
        () => pushAssumptions(context),
      );
    }
    if (line.missingRate) {
      return _withAction(
        Text(l10n.zakatLineRateMissing(context.pair(line.unit, base))),
        l10n.zakatFixAddRate,
        () => showRateDialog(
          context,
          from: line.unit,
          to: base,
          on: view.inputs.on,
        ),
      );
    }
    final share = l10n.zakatLineShare(
      context.percentPlain(line.share!),
      context.money(line.inBase!, base),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(share, style: style)),
            Text(
              l10n.zakatLineZakat(
                context.amount(line.lineZakat(view.inputs.calendar.r)!),
              ),
              style: style,
            ),
          ],
        ),
        if (line.unit != base) _converted(context),
        ..._valueMarker(context),
      ],
    );
  }

  Widget _withAction(Widget text, String label, VoidCallback onTap) => Row(
    children: [
      Expanded(child: text),
      TextButton(onPressed: onTap, child: Text(label)),
    ],
  );

  Widget _converted(BuildContext context) {
    final l10n = context.l10n;
    final on = view.inputs.on;
    final showOld = view.state != YearState.open && _before(line.rateDate, on);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.zakatLineConverted(
            context.money(line.value, line.unit),
            context.rateText(line.rate!),
            context.date(line.rateDate!),
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (showOld) ...[
          MarkerRow(l10n.zakatLineNotRateOf(context.date(on))),
          if (!view.frozen)
            TextButton(
              onPressed: () => showRateDialog(
                context,
                from: line.unit,
                to: view.inputs.base,
                on: view.slot.due,
              ),
              child: Text(l10n.zakatAddRateFor(context.date(view.slot.due))),
            ),
        ],
      ],
    );
  }

  List<Widget> _valueMarker(BuildContext context) {
    final l10n = context.l10n;
    final on = view.inputs.on;
    if (view.state == YearState.open || !_before(line.valueDate, on)) {
      return const [];
    }
    return [
      InkWell(
        onTap: () => showWhy(context, oldDateWhy(context, view)),
        child: MarkerRow(
          l10n.zakatLineValueDate(context.date(line.valueDate!)),
        ),
      ),
      if (!view.frozen && line.refId != null)
        TextButton(
          onPressed: () => showRecordSheet(
            context,
            investmentId: line.refId!,
            date: view.slot.due,
          ),
          child: Text(l10n.zakatAddValueFor(context.date(view.slot.due))),
        ),
    ];
  }

  List<Widget> _notices(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.bodySmall;
    final text = switch (line.notice) {
      ZakatNotice.dividendsCountedWithCash => l10n.zakatLineDividendsNotice,
      ZakatNotice.cryptoDisputed => l10n.noticeCrypto,
      ZakatNotice.profitPayoutsOnly => l10n.noticeProfitPayoutsOnly(
        context.percentPlain(view.inputs.calendar.r),
      ),
      ZakatNotice.capitalBackIsDebt => l10n.noticeCapitalBackIsDebt,
      null => null,
    };
    return [
      if (text != null) Text(text, style: style),
      if (line.notice == ZakatNotice.dividendsCountedWithCash && !view.frozen)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () =>
                showExtraLineSheet(context, view, kind: ExtraKind.cash),
            child: Text(l10n.zakatAddCashLine),
          ),
        ),
    ];
  }

  Widget _rule(BuildContext context) {
    final l10n = context.l10n;
    final inv = investment;
    final label = inv == null
        ? line.section
        : [
            context.assetTypeName(inv.type),
            if (inv.intent != null) context.intentName(inv.intent!),
          ].join(' · ');
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        TextButton(
          onPressed: () => showWhy(
            context,
            Why(
              title: l10n.whyShareTitle,
              what: label,
              source: [
                zakatSource(l10n, line.section, type: inv?.type),
                if (line.unit != view.inputs.base) zakatSource(l10n, 'A7'),
              ].join('\n\n'),
            ),
          ),
          child: Text(l10n.source),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ extra lines

class ExtraLinesSection extends StatelessWidget {
  const ExtraLinesSection(this.view, {super.key});

  final YearView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lines = view.inputs.lines.where((l) => l.isExtra).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeading(
          context,
          l10n.zakatExtraTitle(lines.length),
          trailing: view.frozen
              ? null
              : TextButton(
                  key: const ValueKey('add-extra'),
                  onPressed: () => showExtraLineSheet(context, view),
                  child: Text(l10n.zakatAddLine),
                ),
        ),
        for (final l in lines) _ExtraLine(view: view, line: l),
      ],
    );
  }
}

class _ExtraLine extends StatelessWidget {
  const _ExtraLine({required this.view, required this.line});

  final YearView view;
  final ZakatLine line;

  ExtraLine? get _editing => view.frozen
      ? null
      : view.record?.extras.where((e) => e.id == line.refId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final base = view.inputs.base;
    final style = Theme.of(context).textTheme.bodySmall;
    final editing = _editing;
    final owed = line.extraKind == ExtraKind.owedToMe;
    return InkWell(
      key: ValueKey('extra-${line.refId}'),
      onTap: editing == null
          ? null
          : () => showExtraLineSheet(context, view, editing: editing),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    line.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  line.inBase == null ? '—' : context.money(line.inBase!, base),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (line.unit != base) _foreign(context),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${owed ? l10n.zakatExtraKindOwed : l10n.zakatExtraKindCash}'
                    ' · ${line.section}',
                    style: style,
                  ),
                ),
                TextButton(
                  onPressed: () => showWhy(context, _why(context, owed)),
                  child: Text(l10n.source),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _foreign(BuildContext context) {
    final l10n = context.l10n;
    final base = view.inputs.base;
    if (line.missingRate) {
      return Row(
        children: [
          Expanded(
            child: Text(
              l10n.zakatLineRateMissing(context.pair(line.unit, base)),
            ),
          ),
          TextButton(
            onPressed: () => showRateDialog(
              context,
              from: line.unit,
              to: base,
              on: view.inputs.on,
            ),
            child: Text(l10n.zakatFixAddRate),
          ),
        ],
      );
    }
    final on = view.inputs.on;
    final old = view.state != YearState.open && _before(line.rateDate, on);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.zakatLineConverted(
            context.money(line.value, line.unit),
            context.rateText(line.rate!),
            context.date(line.rateDate!),
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (old) ...[
          MarkerRow(l10n.zakatLineNotRateOf(context.date(on))),
          if (!view.frozen)
            TextButton(
              onPressed: () => showRateDialog(
                context,
                from: line.unit,
                to: view.inputs.base,
                on: view.slot.due,
              ),
              child: Text(l10n.zakatAddRateFor(context.date(view.slot.due))),
            ),
        ],
      ],
    );
  }

  Why _why(BuildContext context, bool owed) {
    final l10n = context.l10n;
    return Why(
      title: owed ? l10n.zakatExtraKindOwed : l10n.zakatExtraKindCash,
      what: owed ? l10n.zakatExtraDoubtful : l10n.zakatWhyExtra,
      source: [
        zakatSource(l10n, line.section),
        zakatSource(l10n, 'C5'),
        if (line.unit != view.inputs.base) zakatSource(l10n, 'A7'),
      ].join('\n\n'),
    );
  }
}

// ------------------------------------------------------------------ debts

class DebtsSection extends ConsumerWidget {
  const DebtsSection(this.view, {super.key});

  final YearView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final i = view.inputs;
    final debts = i.debts;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        InkWell(
          key: const ValueKey('debts-row'),
          onTap: view.frozen ? null : () => showDebtsSheet(context, view),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l10n.zakatDebtsTitle)),
                    Text(
                      i.deductDebts
                          ? context.money(-debts, i.base)
                          : l10n.zakatAddsNotDeducted,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
                if (i.deductDebts && debts > Decimal.zero)
                  Text(
                    l10n.zakatDebtsZakat(
                      context.amount(round2(i.calendar.r * debts)),
                    ),
                    style: textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
        SwitchListTile.adaptive(
          key: const ValueKey('debts-deduct'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.zakatDebtsDeduct),
          value: i.deductDebts,
          onChanged: view.frozen
              ? null
              : (v) => writeOrTell(
                  context,
                  () => ref
                      .read(zakatActionsProvider)
                      .saveDebts(view, debts, deduct: v),
                ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => showWhy(context, debtsWhy(context)),
            child: Text(l10n.source),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ notes

class FixedNotes extends StatelessWidget {
  const FixedNotes({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget note(String text, String section) => InkWell(
      onTap: () => showWhy(
        context,
        Why(title: text, what: text, source: zakatSource(l10n, section)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          note(l10n.zakatNoteA4, 'A4'),
          note(l10n.zakatNoteA8, 'A8'),
          note(l10n.zakatNoteZ4, 'Z4'),
        ],
      ),
    );
  }
}
