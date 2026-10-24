/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/units.dart';
import '../../investments/presentation/investments_providers.dart';
import '../../investments/presentation/rate_history_screen.dart';
import '../../investments/presentation/why_builders.dart';
import '../../investments/presentation/why_sheet.dart';
import '../../investments/presentation/widgets/fields.dart';
import '../../investments/presentation/widgets/labels.dart';
import '../../investments/presentation/widgets/unit_picker_sheet.dart';
import '../domain/yearly_zakat.dart';
import '../domain/zakat_year.dart';
import 'zakat_labels.dart';
import 'year_sections.dart';
import 'zakat_providers.dart';
import 'zakat_sheets.dart';

/// Z7: one amount given. The same sheet edits and deletes an entry.
Future<void> showGiftSheet(
  BuildContext context,
  YearView view, {
  Gift? editing,
}) => showZakatSheet<void>(
  context,
  (_) => _GiftSheet(view: view, editing: editing),
);

class _GiftSheet extends ConsumerStatefulWidget {
  const _GiftSheet({required this.view, this.editing});

  final YearView view;
  final Gift? editing;

  @override
  ConsumerState<_GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends ConsumerState<_GiftSheet> {
  late final _amount = TextEditingController(
    text: widget.editing?.amount.amount.toString(),
  );
  late final _note = TextEditingController(text: widget.editing?.note);
  late DateTime _date = widget.editing?.date ?? ref.read(todayProvider);
  late Unit _unit = widget.editing?.amount.unit ?? widget.view.inputs.base;
  GivingRateView? _picked;
  var _tried = false;

  Unit get _base => widget.view.inputs.base;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Money get _money => Money(parseAmount(_amount.text) ?? Decimal.zero, _unit);

  Gift _draft({Decimal? rate, DateTime? rateDate, GivingRateView? view}) =>
      Gift(
        id: widget.editing?.id,
        date: _date,
        amount: _money,
        rate: rate,
        rateDate: rateDate,
        view: view,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      );

  GivingRateView? get _view =>
      ref.read(settingsProvider).value?.zakat.givingRateView ?? _picked;

  RateQuote? _quote(GivingRateView view) {
    final on = giftRateDate(view, _draft(), widget.view.slot);
    return ref.read(rateBookProvider).value?.quote(_unit, _base, on);
  }

  /// PM-Q5: an edit that leaves amount, currency and date alone keeps the rate
  /// and view the entry was saved with.
  bool get _ratesKept {
    final e = widget.editing;
    return e != null && e.amount == _money && e.date == _date;
  }

  Gift _toSave() {
    final e = widget.editing;
    if (_ratesKept) {
      return _draft(rate: e!.rate, rateDate: e.rateDate, view: e.view);
    }
    final view = _unit == _base ? null : _view;
    final quote = view == null ? null : _quote(view);
    return _draft(rate: quote?.rate, rateDate: quote?.asOf, view: view);
  }

  bool get _blocked {
    if (_unit == _base || _ratesKept) return false;
    final view = _view;
    return view == null || _quote(view) == null;
  }

  Future<void> _save() async {
    final today = ref.read(todayProvider);
    final gift = _toSave();
    final view = gift.view;
    if (validateGift(gift, widget.view.slot, today, _base).isNotEmpty) {
      return setState(() => _tried = true);
    }
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final reached = context.l10n.zakatReachedSnack(
      context.yearLabel(widget.view.slot),
    );
    final actions = ref.read(zakatActionsProvider);
    final settled = _settles(gift);
    final ok = await writeOrTell(context, () async {
      if (view != null && _picked != null) {
        await actions.setGivingRateView(view);
      }
      await actions.saveGift(widget.view, gift);
    });
    if (!ok) return;
    messenger.hideCurrentSnackBar();
    nav.pop();
    if (settled) messenger.showSnackBar(SnackBar(content: Text(reached)));
  }

  /// Whether this entry is the one that reaches the zakat due.
  bool _settles(Gift gift) {
    final p = widget.view.progress;
    final before = widget.editing == null
        ? p.distributed
        : p.distributed - counted(widget.editing!, _base);
    final z = widget.view.result.z!;
    return before < z && before + counted(gift, _base) >= z;
  }

  Future<void> _delete() async {
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final actions = ref.read(zakatActionsProvider);
    final gift = widget.editing!;
    if (!await writeOrTell(context, () => actions.deleteGift(gift.id))) return;
    messenger.hideCurrentSnackBar();
    nav.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.deleted),
        duration: const Duration(seconds: 10),
        persist: false,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => actions.saveGift(widget.view, gift),
        ),
      ),
    );
  }

  Future<void> _pickUnit() async {
    final u = await showUnitPicker(context, anchor: _base, selected: _unit);
    if (u != null) setState(() => _unit = u);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slot = widget.view.slot;
    final today = ref.watch(todayProvider);
    ref.watch(settingsProvider);
    ref.watch(rateBookProvider);
    final draft = _draft();
    final errors = validateGift(draft, slot, today, _base);
    String? error(GiftError e, String text) =>
        errors.contains(e) && (_tried || e != GiftError.amount) ? text : null;
    return SheetBody(
      children: [
        Text(
          l10n.zakatGiftTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        DateField(
          key: const ValueKey('gift-date'),
          label: l10n.fieldDate,
          value: _date,
          firstDate: earliestGiftDate(slot),
          lastDate: today,
          error:
              error(
                GiftError.dateTooEarly,
                l10n.zakatGiftDateError(context.date(slot.previousDue)),
              ) ??
              error(GiftError.dateInFuture, l10n.zakatGiftDateFuture),
          onChanged: (d) => setState(() => _date = d),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AmountField(
                key: const ValueKey('gift-amount'),
                controller: _amount,
                label: l10n.fieldAmount,
                error: error(GiftError.amount, l10n.errZero),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              key: const ValueKey('gift-unit'),
              onPressed: _pickUnit,
              child: Text(_unit.code),
            ),
          ],
        ),
        if (error(GiftError.unit, l10n.zakatErrExtraUnit) case final text?)
          Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (_unit != _base) ..._foreign(context),
        TextField(
          key: const ValueKey('gift-note'),
          controller: _note,
          decoration: InputDecoration(labelText: l10n.fieldNotes),
        ),
        if (givenEarly(draft, slot)) ..._early(context),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(l10n.zakatGiftAbout),
          children: [Text(l10n.zakatGiftLogNote)],
        ),
        Row(
          children: [
            if (widget.editing != null)
              TextButton(onPressed: _delete, child: Text(l10n.delete)),
            const Spacer(),
            FilledButton(
              key: const ValueKey('gift-save'),
              onPressed: _blocked ? null : _save,
              child: Text(l10n.save),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _early(BuildContext context) {
    final l10n = context.l10n;
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(l10n.zakatGiftEarlyHelp, key: const ValueKey('early-help')),
      ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          onPressed: () => showWhy(
            context,
            Why(
              title: l10n.zakatGiftEarly,
              what: l10n.zakatGiftEarlyHelp,
              source: zakatSource(l10n, 'C6'),
            ),
          ),
          child: Text(l10n.source),
        ),
      ),
    ];
  }

  List<Widget> _foreign(BuildContext context) {
    final saved = ref.watch(settingsProvider).value?.zakat.givingRateView;
    final view = saved ?? _picked;
    return [
      if (saved == null) _viewQuestion(context),
      if (view != null) _rateLine(context, view),
    ];
  }

  Widget _viewQuestion(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.zakatGiftViewTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        RadioGroup<GivingRateView>(
          groupValue: _picked,
          onChanged: (v) => setState(() => _picked = v),
          child: Column(
            children: [
              RadioListTile<GivingRateView>(
                key: const ValueKey('view-dayGiven'),
                value: GivingRateView.dayGiven,
                title: Text(l10n.zakatGiftViewDay),
              ),
              RadioListTile<GivingRateView>(
                key: const ValueKey('view-dueDate'),
                value: GivingRateView.dueDate,
                title: Text(l10n.zakatGiftViewDue),
              ),
            ],
          ),
        ),
        Text(l10n.zakatGiftViewHelp),
        TextButton(
          onPressed: () => showWhy(
            context,
            Why(
              title: l10n.zakatGiftViewTitle,
              what: l10n.zakatGiftViewHelp,
              source: zakatSource(l10n, 'C8'),
            ),
          ),
          child: Text(l10n.source),
        ),
      ],
    );
  }

  ({Decimal rate, DateTime asOf})? _shown(GivingRateView view) {
    final stored = _ratesKept ? widget.editing! : null;
    if (stored?.rate != null) {
      return (rate: stored!.rate!, asOf: stored.rateDate!);
    }
    final live = _quote(view);
    return live == null ? null : (rate: live.rate, asOf: live.asOf);
  }

  Widget _rateLine(BuildContext context, GivingRateView view) {
    final l10n = context.l10n;
    final on = giftRateDate(view, _draft(), widget.view.slot);
    final quote = _shown(view);
    final amount = parseAmount(_amount.text);
    if (quote == null) {
      return Row(
        key: const ValueKey('gift-rate-needed'),
        children: [
          Expanded(
            child: Text(
              l10n.zakatGiftTypeRate(_unit.code, _base.code, context.date(on)),
            ),
          ),
          TextButton(
            onPressed: () =>
                showRateDialog(context, from: _unit, to: _base, on: on),
            child: Text(l10n.zakatFixAddRate),
          ),
        ],
      );
    }
    if (amount == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key: const ValueKey('gift-live'),
            l10n.zakatGiftLive(
              context.money(round2(amount * quote.rate), _base),
              context.rateText(quote.rate),
              context.date(quote.asOf),
            ),
          ),
          if (quote.asOf.isBefore(on))
            MarkerRow(l10n.zakatLineNotRateOf(context.date(on))),
        ],
      ),
    );
  }
}
