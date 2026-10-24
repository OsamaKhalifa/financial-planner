/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/clock_provider.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/units.dart';
import '../../../core/storage_exceptions.dart';
import '../../investments/presentation/home_screen.dart';
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
import 'zakat_providers.dart';

/// Runs a write; a failed one is told to the user and nothing is changed
/// (the repositories write in one transaction).
Future<bool> writeOrTell(
  BuildContext context,
  Future<void> Function() write,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final message = context.l10n.errSave;
  try {
    await write();
    return true;
  } on StorageException {
    messenger.showSnackBar(SnackBar(content: Text(message)));
    return false;
  }
}

Future<T?> showZakatSheet<T>(BuildContext context, WidgetBuilder builder) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: builder,
    );

class SheetBody extends StatelessWidget {
  const SheetBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  );
}

/// Saves the cycle; the phone's "no" to notifications is told once, and the
/// date is saved either way (AC-38).
Future<bool> saveCycleTelling(
  BuildContext context,
  WidgetRef ref, {
  required ZakatYear calendar,
  required int month,
  required int day,
  int? reminderDays,
  int? reminderMinute,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final denied = context.l10n.reminderDenied;
  var refused = false;
  final ok = await writeOrTell(context, () async {
    refused = await ref
        .read(zakatActionsProvider)
        .saveCycle(
          calendar: calendar,
          month: month,
          day: day,
          reminderDays: reminderDays,
          reminderMinute: reminderMinute,
        );
  });
  if (ok && refused) messenger.showSnackBar(SnackBar(content: Text(denied)));
  return ok;
}

// ----------------------------------------------------------------- nisab

/// Gold and silver, nothing selected until the user chooses (AC-7). Each
/// shows the nisab at the rate on file, or says a rate is needed.
class NisabRadios extends ConsumerWidget {
  const NisabRadios({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final NisabMetal? selected;
  final ValueChanged<NisabMetal> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return RadioGroup<NisabMetal>(
      groupValue: selected,
      onChanged: (m) => onChanged(m!),
      child: Column(
        children: [
          _tile(context, ref, NisabMetal.gold, l10n.zakatNisabGold, xauG),
          _tile(context, ref, NisabMetal.silver, l10n.zakatNisabSilver, xagG),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    WidgetRef ref,
    NisabMetal metal,
    String title,
    Unit unit,
  ) {
    final base = ref.watch(settingsProvider).value?.baseCurrency;
    final rates = ref.watch(rateBookProvider).value;
    final quote = base == null
        ? null
        : rates?.quote(unit, base, ref.watch(todayProvider));
    return RadioListTile<NisabMetal>(
      key: ValueKey('nisab-${metal.name}'),
      value: metal,
      title: Text(title),
      subtitle: Text(
        quote == null
            ? context.l10n.zakatNisabAddRate(metal.name)
            : context.l10n.zakatNisabAtRate(
                context.money(nisabGrams(metal) * quote.rate, base!),
                context.date(quote.asOf),
              ),
      ),
    );
  }
}

Why nisabWhy(BuildContext context) => Why(
  title: context.l10n.zakatSetupNisabTitle,
  what: context.l10n.zakatNisabWhy,
  source: zakatSource(context.l10n, 'A3'),
);

/// The "Choose" fix row of a year without a nisab standard.
Future<void> showNisabSheet(BuildContext context) =>
    showZakatSheet<void>(context, (_) => const _NisabSheet());

class _NisabSheet extends ConsumerWidget {
  const _NisabSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SheetBody(
      children: [
        Text(
          l10n.zakatSetupNisabTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        NisabRadios(
          selected: ref.watch(settingsProvider).value?.zakat.nisab,
          onChanged: (m) async {
            final nav = Navigator.of(context);
            if (await writeOrTell(
              context,
              () => ref.read(zakatActionsProvider).setNisab(m),
            )) {
              nav.pop();
            }
          },
        ),
        Text(l10n.zakatNisabWhy),
        TextButton(
          onPressed: () => showWhy(context, nisabWhy(context)),
          child: Text(l10n.source),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------- reminder

/// Days before and time of the one notification (step c, S8): both fields and
/// the line that says when it will show. [onChanged] gets null days while
/// the typed value is outside 0 to 60.
class ReminderFields extends ConsumerStatefulWidget {
  const ReminderFields({
    super.key,
    required this.days,
    required this.minute,
    required this.onChanged,
    this.coming,
  });

  final int days;
  final int minute;

  /// The year the notification is for, if known.
  final YearSlot? coming;
  final void Function(int? days, int minute) onChanged;

  @override
  ConsumerState<ReminderFields> createState() => _ReminderFieldsState();
}

class _ReminderFieldsState extends ConsumerState<ReminderFields> {
  late final _days = TextEditingController(text: '${widget.days}');
  late int _minute = widget.minute;

  @override
  void dispose() {
    _days.dispose();
    super.dispose();
  }

  int? get _parsed {
    final v = parseAmount(_days.text);
    if (v == null || !v.isInteger) return null;
    final n = v.toBigInt().toInt();
    return n < 0 || n > 60 ? null : n;
  }

  void _changed() {
    setState(() {});
    widget.onChanged(_parsed, _minute);
  }

  void _step(int delta) {
    _days.text = '${((_parsed ?? 0) + delta).clamp(0, 60)}';
    _changed();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minute ~/ 60, minute: _minute % 60),
    );
    if (picked == null) return;
    _minute = picked.hour * 60 + picked.minute;
    _changed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = _parsed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              key: const ValueKey('days-minus'),
              icon: const Icon(Icons.remove),
              onPressed: () => _step(-1),
            ),
            SizedBox(
              width: 120,
              child: TextField(
                key: const ValueKey('reminder-days'),
                controller: _days,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.reminderDaysLabel,
                  errorText: days == null ? l10n.reminderDaysError : null,
                ),
                onChanged: (_) => _changed(),
              ),
            ),
            IconButton(
              key: const ValueKey('days-plus'),
              icon: const Icon(Icons.add),
              onPressed: () => _step(1),
            ),
          ],
        ),
        Text(
          l10n.reminderDaysHelp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        InkWell(
          key: const ValueKey('reminder-time'),
          onTap: _pickTime,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.reminderTimeLabel,
              suffixIcon: const Icon(Icons.schedule),
            ),
            child: Text(context.clockText(_minute)),
          ),
        ),
        if (days != null && widget.coming != null) _preview(context, days),
      ],
    );
  }

  Widget _preview(BuildContext context, int days) {
    final l10n = context.l10n;
    final slot = widget.coming!;
    final label = context.yearLabel(slot);
    final fireAt = reminderFireAt(slot.due, days, _minute);
    final isFuture = fireAt.isAfter(ref.watch(clockProvider)());
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        key: const ValueKey('reminder-preview'),
        isFuture
            ? l10n.reminderPreview(
                context.date(fireAt),
                context.clockText(_minute),
                context.reminderText(
                  label: label,
                  daysBefore: days,
                  due: slot.due,
                ),
              )
            : l10n.reminderPast(label),
      ),
    );
  }
}

// -------------------------------------------------------------- move due

Future<void> showMoveDueSheet(BuildContext context, YearView view) =>
    showZakatSheet<void>(context, (_) => _MoveDueSheet(view));

class _MoveDueSheet extends ConsumerStatefulWidget {
  const _MoveDueSheet(this.view);

  final YearView view;

  @override
  ConsumerState<_MoveDueSheet> createState() => _MoveDueSheetState();
}

class _MoveDueSheetState extends ConsumerState<_MoveDueSheet> {
  late DateTime _picked = widget.view.slot.due;

  Future<void> _save() async {
    final nav = Navigator.of(context);
    final actions = ref.read(zakatActionsProvider);
    if (await writeOrTell(
      context,
      () => actions.moveDue(widget.view, _picked),
    )) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slot = widget.view.slot;
    final lunar = slot.calendar == ZakatYear.lunar;
    final years = ref.watch(zakatYearsProvider) ?? const <YearView>[];
    final next = years.where((y) => y.slot.key.isAfter(slot.key));
    final bounds = moveBounds(
      slot.calendar,
      slot.key,
      previousDue: slot.previousDue,
      nextDue: next.isEmpty ? null : next.first.slot.due,
    );
    final options = [
      for (
        var d = bounds.from;
        !d.isAfter(bounds.to);
        d = d.add(const Duration(days: 1))
      )
        d,
    ];
    return SheetBody(
      children: [
        Text(
          l10n.zakatMoveTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        RadioGroup<DateTime>(
          groupValue: _picked,
          onChanged: (d) => setState(() => _picked = d!),
          child: Column(
            children: [
              for (final d in options)
                RadioListTile<DateTime>(
                  key: ValueKey('move-${yearKeyText(d)}'),
                  value: d,
                  title: Text(
                    d == slot.key && lunar
                        ? '${context.date(d)} · ${l10n.zakatMoveUmmAlQura}'
                        : context.date(d),
                  ),
                ),
            ],
          ),
        ),
        Text(lunar ? l10n.zakatUmmAlQuraLine : l10n.zakatMoveSolarLine),
        const SizedBox(height: 8),
        Text(l10n.zakatMoveInfo),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            key: const ValueKey('move-save'),
            onPressed: _save,
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ extra line

Future<void> showExtraLineSheet(
  BuildContext context,
  YearView view, {
  ExtraLine? editing,
  ExtraKind? kind,
}) => showZakatSheet<void>(
  context,
  (_) => _ExtraLineSheet(view: view, editing: editing, kind: kind),
);

class _ExtraLineSheet extends ConsumerStatefulWidget {
  const _ExtraLineSheet({required this.view, this.editing, this.kind});

  final YearView view;
  final ExtraLine? editing;

  /// The kind to start with when adding.
  final ExtraKind? kind;

  @override
  ConsumerState<_ExtraLineSheet> createState() => _ExtraLineSheetState();
}

class _ExtraLineSheetState extends ConsumerState<_ExtraLineSheet> {
  late final _label = TextEditingController(text: widget.editing?.label);
  late final _amount = TextEditingController(
    text: widget.editing?.amount.amount.toString(),
  );
  late ExtraKind? _kind = widget.editing?.kind ?? widget.kind;
  late Unit _unit = widget.editing?.amount.unit ?? widget.view.inputs.base;
  late bool _confirmed = widget.editing?.goodDebtConfirmed ?? false;
  var _tried = false;

  @override
  void dispose() {
    _label.dispose();
    _amount.dispose();
    super.dispose();
  }

  ExtraLine get _line => ExtraLine(
    id: widget.editing?.id,
    label: _label.text.trim(),
    kind: _kind!,
    amount: Money(parseAmount(_amount.text) ?? Decimal.zero, _unit),
    goodDebtConfirmed: _kind == ExtraKind.owedToMe && _confirmed,
  );

  Future<void> _save() async {
    final errors = validateExtra(_line);
    if (errors.isNotEmpty) return setState(() => _tried = true);
    final nav = Navigator.of(context);
    final actions = ref.read(zakatActionsProvider);
    if (await writeOrTell(
      context,
      () => actions.saveExtra(widget.view, _line),
    )) {
      nav.pop();
    }
  }

  Future<void> _delete() async {
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final actions = ref.read(zakatActionsProvider);
    final line = widget.editing!;
    if (!await writeOrTell(context, () => actions.deleteExtra(line.id))) return;
    nav.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.deleted),
        duration: const Duration(seconds: 10),
        persist: false,
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => actions.saveExtra(widget.view, line),
        ),
      ),
    );
  }

  Future<void> _pickUnit() async {
    final base = widget.view.inputs.base;
    final u = await showUnitPicker(context, anchor: base, selected: _unit);
    if (u != null) setState(() => _unit = u);
  }

  String? _error(List<ExtraLineError> errors, ExtraLineError e, String text) =>
      errors.contains(e) && (_tried || e == ExtraLineError.unit) ? text : null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errors = _kind == null ? <ExtraLineError>[] : validateExtra(_line);
    return SheetBody(
      children: [
        Text(
          l10n.zakatExtraSheetTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SegmentedButton<ExtraKind>(
          emptySelectionAllowed: true,
          segments: [
            ButtonSegment(
              value: ExtraKind.cash,
              label: Text(l10n.zakatExtraKindCash),
            ),
            ButtonSegment(
              value: ExtraKind.owedToMe,
              label: Text(l10n.zakatExtraKindOwed),
            ),
          ],
          selected: {?_kind},
          onSelectionChanged: (s) => setState(() => _kind = s.firstOrNull),
        ),
        const SizedBox(height: 8),
        Text(l10n.zakatExtraOtherAssets),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const HomeScreen()));
          },
          child: Text(l10n.zakatOpenInvestments),
        ),
        TextField(
          key: const ValueKey('extra-label'),
          controller: _label,
          decoration: InputDecoration(
            labelText: l10n.zakatExtraLabel,
            errorText: _error(
              errors,
              ExtraLineError.label,
              l10n.zakatErrExtraLabel,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AmountField(
                key: const ValueKey('extra-amount'),
                controller: _amount,
                label: l10n.fieldAmount,
                error: _error(
                  errors,
                  ExtraLineError.amount,
                  l10n.zakatErrAmount,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              key: const ValueKey('extra-unit'),
              onPressed: _pickUnit,
              child: Text(_unit.code),
            ),
          ],
        ),
        if (_error(errors, ExtraLineError.unit, l10n.zakatErrExtraUnit)
            case final text?)
          Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (_kind == ExtraKind.owedToMe) ..._goodDebt(context, errors),
        _liveLine(context),
        Text(l10n.zakatExtraCountedOnly(context.yearLabel(widget.view.slot))),
        TextButton(
          onPressed: () => showWhy(
            context,
            Why(
              title: l10n.zakatExtraSheetTitle,
              what: l10n.zakatWhyExtra,
              source: [
                zakatSource(l10n, _kind == ExtraKind.owedToMe ? 'B9' : 'B1'),
                l10n.src_C5,
              ].join('\n\n'),
            ),
          ),
          child: Text(l10n.source),
        ),
        Row(
          children: [
            if (widget.editing != null)
              TextButton(onPressed: _delete, child: Text(l10n.delete)),
            const Spacer(),
            FilledButton(
              key: const ValueKey('extra-save'),
              onPressed: _kind == null ? null : _save,
              child: Text(l10n.save),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _goodDebt(BuildContext context, List<ExtraLineError> errors) {
    final l10n = context.l10n;
    return [
      CheckboxListTile(
        key: const ValueKey('extra-good-debt'),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: _confirmed,
        title: Text(l10n.zakatExtraGoodDebt),
        onChanged: (v) => setState(() => _confirmed = v!),
      ),
      if (_error(errors, ExtraLineError.goodDebt, l10n.zakatErrGoodDebt)
          case final text?)
        Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      Text(l10n.zakatExtraDoubtful),
    ];
  }

  Widget _liveLine(BuildContext context) {
    final l10n = context.l10n;
    final view = widget.view;
    final amount = parseAmount(_amount.text);
    final base = view.inputs.base;
    if (_unit == base || amount == null) return const SizedBox.shrink();
    final quote = ref
        .watch(rateBookProvider)
        .value
        ?.quote(_unit, base, view.inputs.on);
    if (quote == null) {
      return Row(
        key: const ValueKey('extra-live'),
        children: [
          Expanded(
            child: Text(l10n.zakatLineRateMissing(context.pair(_unit, base))),
          ),
          TextButton(
            onPressed: () => showRateDialog(
              context,
              from: _unit,
              to: base,
              on: view.inputs.on,
            ),
            child: Text(l10n.zakatFixAddRate),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        key: const ValueKey('extra-live'),
        l10n.zakatExtraLive(
          context.money(amount * quote.rate, base),
          context.rateText(quote.rate),
          context.date(quote.asOf),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- debts

Future<void> showDebtsSheet(BuildContext context, YearView view) =>
    showZakatSheet<void>(context, (_) => _DebtsSheet(view));

class _DebtsSheet extends ConsumerStatefulWidget {
  const _DebtsSheet(this.view);

  final YearView view;

  @override
  ConsumerState<_DebtsSheet> createState() => _DebtsSheetState();
}

class _DebtsSheetState extends ConsumerState<_DebtsSheet> {
  late final _amount = TextEditingController(
    text: (widget.view.record?.debts ?? Decimal.zero) == Decimal.zero
        ? ''
        : widget.view.record!.debts.toString(),
  );
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final typed = _amount.text.trim().isEmpty
        ? Decimal.zero
        : parseAmount(_amount.text);
    if (typed == null || typed < Decimal.zero) {
      return setState(() => _error = l10n.zakatErrAmount);
    }
    final nav = Navigator.of(context);
    final actions = ref.read(zakatActionsProvider);
    final deduct = widget.view.record?.deductDebts ?? true;
    if (await writeOrTell(
      context,
      () => actions.saveDebts(widget.view, typed, deduct: deduct),
    )) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SheetBody(
      children: [
        Text(
          l10n.zakatDebtsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        AmountField(
          key: const ValueKey('debts-amount'),
          controller: _amount,
          label: l10n.zakatDebtsTitle,
          suffix: widget.view.inputs.base.code,
          error: _error,
          onChanged: (_) => setState(() => _error = null),
        ),
        Text(l10n.zakatDebtsHelp, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Text(l10n.zakatDebtsWhy),
        TextButton(
          onPressed: () => showWhy(context, debtsWhy(context)),
          child: Text(l10n.source),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            key: const ValueKey('debts-save'),
            onPressed: _save,
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }
}

Why debtsWhy(BuildContext context) => Why(
  title: context.l10n.zakatDebtsTitle,
  what: context.l10n.zakatDebtsWhy,
  source: [
    zakatSource(context.l10n, 'A5'),
    zakatSource(context.l10n, 'C4'),
  ].join('\n\n'),
);

// ---------------------------------------------------------- cycle change

/// Before a calendar or cycle-date change is saved: what keeps its date and
/// where the new cycle starts (U8, C2). [calendar] is the new calendar; null
/// keeps the current one.
Future<void> showCycleChangeSheet(
  BuildContext context, {
  ZakatYear? calendar,
}) => showZakatSheet<void>(context, (_) => _CycleChangeSheet(calendar));

class _CycleChangeSheet extends ConsumerStatefulWidget {
  const _CycleChangeSheet(this.calendar);

  final ZakatYear? calendar;

  @override
  ConsumerState<_CycleChangeSheet> createState() => _CycleChangeSheetState();
}

class _CycleChangeSheetState extends ConsumerState<_CycleChangeSheet> {
  int? _month;
  int? _day;

  bool _fits(ZakatYear calendar) =>
      _month != null && _day != null && cycleDateFits(calendar, _month!, _day!);

  Future<void> _save(ZakatYear calendar) async {
    final nav = Navigator.of(context);
    if (await saveCycleTelling(
      context,
      ref,
      calendar: calendar,
      month: _month!,
      day: _day!,
    )) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final years = ref.watch(zakatYearsProvider) ?? const <YearView>[];
    final settings = ref.watch(settingsProvider).value;
    final calendar = widget.calendar ?? settings?.zakatYear;
    if (calendar == null) return const SizedBox.shrink();
    final today = ref.watch(todayProvider);
    final from = newCycleFrom([for (final y in years) y.slot], today);
    final changed = widget.calendar != null;
    return SheetBody(
      children: [
        Text(
          changed
              ? l10n.zakatChangeToTitle(calendar.name)
              : l10n.zakatChangeCycleTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (years.isNotEmpty) ..._kept(context, years, from, calendar),
        const SizedBox(height: 12),
        Text(l10n.zakatCycleHelp(calendar.name)),
        const SizedBox(height: 8),
        CycleDateField(
          calendar: calendar,
          month: _month,
          day: _day,
          onChanged: (m, d) => setState(() {
            _month = m;
            _day = d;
          }),
        ),
        if (_fits(calendar)) _firstYear(context, years, from, calendar, today),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              key: const ValueKey('cycle-save'),
              onPressed: _fits(calendar) ? () => _save(calendar) : null,
              child: Text(l10n.save),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _kept(
    BuildContext context,
    List<YearView> years,
    DateTime from,
    ZakatYear calendar,
  ) {
    final l10n = context.l10n;
    final ordered = [...years]
      ..sort((a, b) => a.slot.due.compareTo(b.slot.due));
    return [
      const SizedBox(height: 8),
      Text(l10n.zakatChangeKeep),
      for (final y in ordered)
        Text(
          l10n.zakatChangeKeepRow(
            context.yearLabel(y.slot),
            context.stateName(y),
            context.date(y.slot.due),
            context.percentPlain(y.slot.calendar.r),
          ),
        ),
      Text(
        l10n.zakatChangeStartsAfter(
          calendar.name,
          context.date(from.subtract(const Duration(days: 1))),
        ),
      ),
      Text(l10n.zakatChangeAppliesFrom(context.yearLabel(ordered.last.slot))),
    ];
  }

  Widget _firstYear(
    BuildContext context,
    List<YearView> years,
    DateTime from,
    ZakatYear calendar,
    DateTime today,
  ) {
    final cycles = ref.watch(zakatCyclesProvider).value ?? const [];
    final moved = {
      for (final y in years)
        if (y.record?.movedDue != null) y.slot.key: y.record!.movedDue!,
    };
    final slots = yearSlots(
      [
        ...cycles,
        ZakatCycle(calendar: calendar, month: _month!, day: _day!, from: from),
      ],
      moved,
      today,
    ).where((s) => !s.key.isBefore(from));
    if (slots.isEmpty) return const SizedBox.shrink();
    final first = slots.first;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        key: const ValueKey('cycle-first-year'),
        context.l10n.zakatChangeFirstYear(
          calendar.name,
          context.yearLabel(first),
          context.date(first.due),
          context.percentPlain(calendar.r),
        ),
      ),
    );
  }
}
