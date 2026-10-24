/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/units.dart';
import '../../investments/domain/zakat_rules.dart';
import '../../investments/presentation/investment_form_screen.dart';
import '../../investments/presentation/rate_history_screen.dart';
import '../../investments/presentation/why_builders.dart';
import '../../investments/presentation/why_sheet.dart';
import '../../investments/presentation/widgets/labels.dart';
import '../domain/yearly_zakat.dart';
import '../domain/zakat_year.dart';
import 'gift_sheet.dart';
import 'year_sections.dart';
import 'zakat_labels.dart';
import 'zakat_providers.dart';
import 'zakat_sheets.dart';

/// Z2 for any year and any state (U1), pushed from History, a due text or a
/// notification.
class YearScreen extends ConsumerWidget {
  const YearScreen({super.key, required this.yearKey});

  final DateTime yearKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(yearViewProvider(yearKey));
    return Scaffold(
      appBar: AppBar(
        title: Text(view == null ? '' : context.yearLabel(view.slot)),
      ),
      floatingActionButton: view == null ? null : yearFab(context, view),
      body: view == null
          ? const Center(child: CircularProgressIndicator())
          : YearContent(view: view),
    );
  }
}

/// Amounts can be logged on a started year that has zakat to give (AC-26,
/// AC-31).
bool canLog(YearView v) =>
    v.frozen && (v.result.z ?? Decimal.zero) > Decimal.zero;

Widget? yearFab(BuildContext context, YearView v) => canLog(v)
    ? FloatingActionButton.extended(
        key: const ValueKey('add-gift'),
        // The Investments tab keeps its own button in the same route.
        heroTag: 'zakat-add-gift',
        onPressed: () => showGiftSheet(context, v),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.zakatGiftAdd),
      )
    : null;

/// Everything of one year, top to bottom (UX 2.4). [top] sits above the
/// header (the due texts of the tab root).
class YearContent extends StatelessWidget {
  const YearContent({super.key, required this.view, this.top = const []});

  final YearView view;
  final List<Widget> top;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        ...top,
        _Header(view),
        if (view.frozen) _FrozenBanner(view),
        _ResultCard(view),
        if (hasOldDate(view))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: MarkerRow(
              context.l10n.zakatOldDateNote(context.date(view.slot.due)),
            ),
          ),
        if (canLog(view)) _GivenCard(view),
        AddsUpSection(view),
        InvestmentsSection(view),
        ExtraLinesSection(view),
        DebtsSection(view),
        const FixedNotes(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.view);

  final YearView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slot = view.slot;
    final lunar = slot.calendar == ZakatYear.lunar;
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(context.yearLabel(slot), style: theme.headlineSmall),
            ),
            Chip(
              key: const ValueKey('state-chip'),
              label: Text(context.stateName(view)),
            ),
          ],
        ),
        Text(
          lunar ? context.hijriDate(slot.key) : context.date(slot.due),
          style: theme.titleMedium,
        ),
        Text(lunar ? context.date(slot.due) : context.hijriDate(slot.due)),
        if (lunar) Text(l10n.zakatUmmAlQuraLine, style: theme.bodySmall),
        if (slot.due != slot.key)
          Text(
            l10n.zakatMovedFrom(slot.calendar.name, context.date(slot.key)),
            key: const ValueKey('moved-from'),
          ),
        if (view.frozen)
          Text(
            l10n.zakatStartedHeader(
              context.date(view.record!.frozen!.startedOn),
              slot.calendar.name,
              context.percentPlain(slot.calendar.r),
            ),
          )
        else
          TextButton(
            key: const ValueKey('move-date'),
            onPressed: () => showMoveDueSheet(context, view),
            child: Text(l10n.zakatMoveDate),
          ),
      ],
    );
  }
}

class _FrozenBanner extends ConsumerWidget {
  const _FrozenBanner(this.view);

  final YearView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Card(
      key: const ValueKey('frozen-banner'),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(
          l10n.zakatFrozenBanner(context.date(view.record!.frozen!.startedOn)),
        ),
        trailing: TextButton(
          key: const ValueKey('recompute'),
          onPressed: () => recomputeYear(context, ref, view),
          child: Text(l10n.zakatRecompute),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- actions

Future<void> startYear(BuildContext context, WidgetRef ref, YearView v) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final actions = ref.read(zakatActionsProvider);
  final label = context.yearLabel(v.slot);
  final closing = v.result.z == Decimal.zero;
  if (!await writeOrTell(context, () => actions.start(v))) return;
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        closing ? l10n.zakatClosedSnack(label) : l10n.zakatStartedSnack(label),
      ),
      duration: const Duration(seconds: 10),
      // A snack bar with an action stays until dismissed unless told not to;
      // AC-43 gives Undo 10 seconds.
      persist: false,
      action: SnackBarAction(
        label: l10n.undo,
        onPressed: () => actions.undoStart(v.slot.key),
      ),
    ),
  );
}

Future<void> recomputeYear(
  BuildContext context,
  WidgetRef ref,
  YearView v,
) async {
  final actions = ref.read(zakatActionsProvider);
  final after = compute(await actions.liveInputsOf(v));
  if (!context.mounted) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => _RecomputeDialog(view: v, after: after),
  );
  if (confirmed == true && context.mounted) {
    await writeOrTell(context, () => actions.recompute(v));
  }
}

class _RecomputeDialog extends StatelessWidget {
  const _RecomputeDialog({required this.view, required this.after});

  final YearView view;
  final YearResult after;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final base = view.inputs.base;
    return AlertDialog(
      title: Text(
        l10n.zakatRecomputeTitle(
          context.yearLabel(view.slot),
          context.date(view.slot.due),
        ),
      ),
      content: after.canStart
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key: const ValueKey('recompute-preview'),
                  l10n.zakatRecomputePreview(
                    context.money(view.result.z!, base),
                    context.money(after.z!, base),
                    context.money(view.progress.distributed, base),
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.zakatRecomputeHelp),
              ],
            )
          : Text(l10n.zakatResultIncomplete(after.missing.length)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('recompute-confirm'),
          onPressed: after.canStart ? () => Navigator.pop(context, true) : null,
          child: Text(l10n.zakatRecompute),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ result card

typedef _Fix = ({String text, String action, VoidCallback onTap});

/// One row per thing a year is missing (AC-8, AC-12, AC-16, AC-7).
List<_Fix> _fixesOf(BuildContext context, YearView v, Settings settings) {
  final l10n = context.l10n;
  final base = v.inputs.base;
  final on = v.inputs.on;
  final fixes = <_Fix>[];
  for (final (reason, lines) in v.result.missing) {
    switch (reason) {
      case Missing.rate:
        for (final unit in lines.map((l) => l.unit).toSet()) {
          fixes.add((
            text: l10n.zakatFixRate(
              context.pair(unit, base),
              context.date(on),
              _names(lines.where((l) => l.unit == unit)),
            ),
            action: l10n.zakatFixAddRate,
            onTap: () => showRateDialog(context, from: unit, to: base, on: on),
          ));
        }
      case Missing.question:
        fixes.addAll(_questionFixes(context, lines, settings));
      case Missing.nisabStandard:
        fixes.add((
          text: l10n.zakatFixNisab,
          action: l10n.zakatFixChoose,
          onTap: () => showNisabSheet(context),
        ));
      case Missing.metalRate:
        final metal = v.inputs.nisab!;
        fixes.add((
          text: l10n.zakatFixMetalRate(metal.name, context.date(on)),
          action: l10n.zakatFixAddRate,
          onTap: () => showRateDialog(
            context,
            from: metal == NisabMetal.gold ? xauG : xagG,
            to: base,
            on: on,
          ),
        ));
    }
  }
  return fixes;
}

String _names(Iterable<ZakatLine> lines) => lines.map((l) => l.name).join(', ');

List<_Fix> _questionFixes(
  BuildContext context,
  List<ZakatLine> lines,
  Settings settings,
) {
  final l10n = context.l10n;
  final jewellery = lines.where((l) => l.question == ZakatQuestion.jewellery);
  final longTerm = lines.where(
    (l) => l.question == ZakatQuestion.longTermMethod,
  );
  final perItem = settings.longTermMethod == LongTermMethod.perItem;
  return [
    if (jewellery.isNotEmpty)
      (
        text: l10n.zakatFixJewellery(_names(jewellery)),
        action: l10n.zakatFixAnswer,
        onTap: () => pushAssumptions(context),
      ),
    if (longTerm.isNotEmpty)
      (
        text: l10n.zakatFixLongTerm(_names(longTerm)),
        action: l10n.zakatFixChoose,
        onTap: perItem
            ? () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      InvestmentFormScreen(editId: longTerm.first.refId),
                ),
              )
            : () => pushAssumptions(context),
      ),
  ];
}

class _FixRows extends StatelessWidget {
  const _FixRows(this.fixes);

  final List<_Fix> fixes;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final f in fixes)
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            children: [
              const Icon(Icons.edit_note, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(f.text)),
              TextButton(onPressed: f.onTap, child: Text(f.action)),
            ],
          ),
        ),
    ],
  );
}

class _DelayLine extends StatelessWidget {
  const _DelayLine();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      key: const ValueKey('delay-line'),
      onTap: () => showWhy(
        context,
        Why(
          title: l10n.zakatDueDelayLine,
          what: l10n.zakatDueDelayLine,
          source: zakatSource(l10n, 'C2'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.zakatDueDelayLine,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Due years with zakat to give or things to complete, and years being
/// distributed (C2, PM-Q6).
bool _showsDelay(YearView v) => switch (v.state) {
  YearState.due =>
    !v.result.complete || (v.result.z ?? Decimal.zero) > Decimal.zero,
  YearState.distributing => true,
  _ => false,
};

class _ResultCard extends ConsumerWidget {
  const _ResultCard(this.view);

  final YearView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = view.result;
    final children = view.frozen
        ? _frozen(context)
        : r.empty
        ? _empty(context)
        : !r.complete
        ? _incomplete(context, ref)
        : view.state == YearState.open
        ? _open(context)
        : _due(context, ref);
    return Card(
      key: const ValueKey('result-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...children, if (_showsDelay(view)) const _DelayLine()],
        ),
      ),
    );
  }

  String _money(BuildContext context, Decimal v) =>
      context.money(v, view.inputs.base);

  Widget _big(BuildContext context, String text, {Key? key}) =>
      Text(text, key: key, style: Theme.of(context).textTheme.headlineMedium);

  Why _rateWhy(BuildContext context) => Why(
    title: context.l10n.zakatAddsRate(view.inputs.calendar.name),
    what: context.l10n.zakatWhyRate,
    source: context.l10n.src_A1A2,
  );

  Why _belowWhy(BuildContext context) => Why(
    title: context.l10n.zakatResultBelow,
    what: context.l10n.zakatWhyBelow,
    source: [
      zakatSource(context.l10n, 'A3'),
      zakatSource(context.l10n, 'C4'),
    ].join('\n\n'),
  );

  List<Widget> _frozen(BuildContext context) {
    final l10n = context.l10n;
    final z = view.result.z!;
    if (z == Decimal.zero) {
      return [_big(context, _money(context, z)), Text(l10n.zakatFrozenBelow)];
    }
    if (view.state == YearState.settled) {
      return [
        _big(
          context,
          l10n.zakatState('settled'),
          key: const ValueKey('settled'),
        ),
        Text(l10n.zakatSettledLine),
        const SizedBox(height: 8),
        Text(
          l10n.zakatGiftLogNote,
          key: const ValueKey('c11-line'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ];
    }
    return [
      Text(l10n.zakatRemaining, style: Theme.of(context).textTheme.labelLarge),
      _big(context, _money(context, view.progress.remaining)),
      Text(
        '${l10n.zakatResultDue} ${_money(context, z)} · '
        '${l10n.zakatHistoryGiven(_money(context, view.progress.distributed))}',
      ),
    ];
  }

  List<Widget> _empty(BuildContext context) {
    final l10n = context.l10n;
    return [
      Text(
        l10n.zakatResultEmpty,
        key: const ValueKey('nothing-to-count'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      FilledButton(
        key: const ValueKey('add-investment'),
        onPressed: () => pushAddInvestment(context),
        child: Text(l10n.zakatAddInvestment),
      ),
      TextButton(
        key: const ValueKey('add-line-here'),
        onPressed: () => showExtraLineSheet(context, view),
        child: Text(l10n.zakatAddLineHere),
      ),
    ];
  }

  List<Widget> _incomplete(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value!;
    final fixes = _fixesOf(context, view, settings);
    return [
      Text(
        l10n.zakatResultIncomplete(fixes.length),
        key: const ValueKey('cannot-work-out'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      _FixRows(fixes),
      if (view.state == YearState.due)
        FilledButton.tonal(
          key: const ValueKey('start-year'),
          onPressed: () => showZakatSheet<void>(
            context,
            (_) => SheetBody(
              children: [
                Text(l10n.zakatResultIncomplete(fixes.length)),
                _FixRows(fixes),
              ],
            ),
          ),
          child: Text(l10n.zakatStart),
        ),
    ];
  }

  List<Widget> _open(BuildContext context) {
    final l10n = context.l10n;
    final r = view.result;
    return [
      Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _big(
            context,
            _money(context, r.z!),
            key: const ValueKey('zakat-estimate'),
          ),
          Chip(label: Text(l10n.zakatEstimateTag)),
        ],
      ),
      Text(l10n.zakatResultOpenLine(context.date(view.slot.due))),
      Text(l10n.zakatResultUsesToday),
      Text(l10n.zakatResultStartFrom(context.date(view.slot.due))),
      if (r.z == Decimal.zero)
        Text(
          l10n.zakatResultBelowFigures(_money(context, r.b), _nisab(context)),
        ),
    ];
  }

  String _nisab(BuildContext context) => _money(context, view.result.nisab!);

  List<Widget> _due(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final r = view.result;
    final z = r.z!;
    if (z == Decimal.zero) {
      return [
        _big(context, _money(context, z)),
        InkWell(
          onTap: () => showWhy(context, _belowWhy(context)),
          child: Text(
            l10n.zakatResultBelow,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Text(
          l10n.zakatResultBelowFigures(_money(context, r.b), _nisab(context)),
        ),
        const SizedBox(height: 8),
        _startButton(context, ref, l10n.zakatClose),
        Text(l10n.zakatCloseExplain),
      ];
    }
    return [
      Text(l10n.zakatResultDue, style: Theme.of(context).textTheme.labelLarge),
      InkWell(
        onTap: () => showWhy(context, zakatDueWhy(context, view)),
        child: _big(
          context,
          _money(context, z),
          key: const ValueKey('zakat-due'),
        ),
      ),
      InkWell(
        onTap: () => showWhy(context, _rateWhy(context)),
        child: Text(
          l10n.zakatResultRateOf(
            context.percentPlain(view.inputs.calendar.r),
            _money(context, r.b),
          ),
        ),
      ),
      const SizedBox(height: 8),
      _startButton(context, ref, l10n.zakatStart),
      Text(l10n.zakatStartExplain),
    ];
  }

  Widget _startButton(BuildContext context, WidgetRef ref, String label) =>
      FilledButton(
        key: const ValueKey('start-year'),
        onPressed: () => startYear(context, ref, view),
        child: Text(label),
      );
}

// -------------------------------------------------------------- given card

class _GivenCard extends StatelessWidget {
  const _GivenCard(this.view);

  final YearView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final base = view.inputs.base;
    final z = view.result.z!;
    final p = view.progress;
    final gifts = [...view.record!.gifts]
      ..sort((a, b) => b.date.compareTo(a.date));
    return Card(
      key: const ValueKey('given-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => showWhy(context, _givenWhy(context)),
              child: Text(
                l10n.zakatGiftGivenOf(
                  context.amount(p.distributed),
                  context.money(z, base),
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressOf(divide(p.distributed, z)),
              semanticsLabel: l10n.zakatGiftSemantics(
                context.money(p.distributed, base),
                context.money(z, base),
                context.money(p.remaining, base),
              ),
            ),
            const SizedBox(height: 4),
            Text(l10n.zakatGiftRemaining(context.money(p.remaining, base))),
            if (p.over > Decimal.zero) ..._over(context),
            const Divider(),
            if (gifts.isEmpty) Text(l10n.zakatGiftEmpty),
            for (final g in gifts) _GiftRow(view: view, gift: g),
          ],
        ),
      ),
    );
  }

  Why _givenWhy(BuildContext context) => Why(
    title: context.l10n.zakatGiftTitle,
    what: context.l10n.zakatWhyGiven,
    source: zakatSource(context.l10n, 'C11'),
  );

  List<Widget> _over(BuildContext context) {
    final l10n = context.l10n;
    return [
      const SizedBox(height: 8),
      Text(
        l10n.zakatGiftOver(context.money(view.progress.over, view.inputs.base)),
        key: const ValueKey('given-over'),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      InkWell(
        onTap: () => showWhy(
          context,
          Why(
            title: l10n.zakatGiftTitle,
            what: l10n.zakatGiftOverHelp,
            source: zakatSource(l10n, 'C7'),
          ),
        ),
        child: Text(
          l10n.zakatGiftOverHelp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ];
  }
}

class _GiftRow extends StatelessWidget {
  const _GiftRow({required this.view, required this.gift});

  final YearView view;
  final Gift gift;

  @override
  Widget build(BuildContext context) {
    final base = view.inputs.base;
    final style = Theme.of(context).textTheme.bodySmall;
    return InkWell(
      key: ValueKey('gift-row-${gift.id}'),
      onTap: () => showGiftSheet(context, view, editing: gift),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(context.date(gift.date))),
                Text(
                  context.money(counted(gift, base), base),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            if (gift.amount.unit != base) ..._foreign(context),
            if (gift.note != null) Text(gift.note!, style: style),
            if (givenEarly(gift, view.slot)) _early(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _foreign(BuildContext context) {
    final l10n = context.l10n;
    final wanted = giftRateDate(gift.view!, gift, view.slot);
    return [
      Text(
        l10n.zakatGiftCountedAt(
          context.money(gift.amount.amount, gift.amount.unit),
          context.rateText(gift.rate!),
          context.date(gift.rateDate!),
          gift.view!.name,
        ),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      if (gift.rateDate!.isBefore(wanted))
        MarkerRow(l10n.zakatLineNotRateOf(context.date(wanted))),
    ];
  }

  Widget _early(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: () => showWhy(
        context,
        Why(
          title: l10n.zakatGiftEarly,
          what: l10n.zakatGiftEarlyHelp,
          source: zakatSource(l10n, 'C6'),
        ),
      ),
      child: Row(
        children: [
          Text(
            l10n.zakatGiftEarly,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.info_outline, size: 16),
        ],
      ),
    );
  }
}
