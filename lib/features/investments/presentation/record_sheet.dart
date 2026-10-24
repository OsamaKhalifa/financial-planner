/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/decimal_math.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/units.dart';
import '../../../core/dates.dart';
import '../domain/expected_plan.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../../../core/assumptions/assumptions_providers.dart';
import '../domain/portfolio_calculator.dart';
import 'investments_providers.dart';
import 'widgets/fields.dart';
import 'widgets/labels.dart';
import 'widgets/unit_picker_sheet.dart';

enum RecordPreset { interestGivenAway }

Future<void> showRecordSheet(
  BuildContext context, {
  required String investmentId,
  HistoryEntry? editing,
  RecordPreset? preset,
  PlanRow? row,
  DateTime? date,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => RecordSheet(
    investmentId: investmentId,
    editing: editing,
    preset: preset,
    row: row,
    date: date,
  ),
);

enum _Tab { value, moneyIn, moneyOut, interest }

enum _Where { paidOut, keptInside }

/// S5: one sheet for value updates, money in and out, and interest. The same
/// sheet edits an existing entry.
class RecordSheet extends ConsumerStatefulWidget {
  const RecordSheet({
    super.key,
    required this.investmentId,
    this.editing,
    this.preset,
    this.row,
    this.date,
  });

  final String investmentId;
  final HistoryEntry? editing;
  final RecordPreset? preset;

  /// Opened from a pending row: kind, date and amount preset; the date stays
  /// within the row's 7-day window (architect Q-E2).
  final PlanRow? row;

  /// The date of a new entry when it is not today (a zakat due date).
  final DateTime? date;

  @override
  ConsumerState<RecordSheet> createState() => _RecordSheetState();
}

class _RecordSheetState extends ConsumerState<RecordSheet> {
  final _amount = TextEditingController();
  final _valueAfter = TextEditingController();
  final _valueLeft = TextEditingController();
  _Tab _tab = _Tab.value;
  late DateTime _date;
  Unit? _unit;
  var _sale = true;
  var _givenAway = false;
  _Where _where = _Where.paidOut;
  _Where _from = _Where.keptInside;
  var _perUnit = false;
  String? _error;
  var _ready = false;

  @override
  void dispose() {
    _amount.dispose();
    _valueAfter.dispose();
    _valueLeft.dispose();
    super.dispose();
  }

  void _init(InvestmentWithHistory h) {
    if (_ready) return;
    _ready = true;
    _date = widget.date ?? ref.read(todayProvider);
    _unit = h.investment.unit;
    final e = widget.editing;
    if (widget.preset == RecordPreset.interestGivenAway) {
      _tab = _Tab.interest;
      _givenAway = true;
      final left = _toPurify(h);
      _from = left.kept > Decimal.zero || left.paid == Decimal.zero
          ? _Where.keptInside
          : _Where.paidOut;
    }
    final row = widget.row;
    if (row != null) {
      _date = row.date;
      final held = row.kind == PlanKind.value
          ? _calc()?.timeline(h.investment.id).heldInterestAt(row.date)
          : null;
      // A typed value is gross of interest kept inside; the estimate is net.
      _amount.text = row.expected == null
          ? ''
          : (row.expected! + (held ?? Decimal.zero)).toString();
      if (row.kind == PlanKind.value) {
        _tab = _Tab.value;
      } else if (h.investment.conventionalDeposit) {
        _tab = _Tab.interest;
        _where = _Where.paidOut;
      } else {
        _tab = _Tab.moneyOut;
        _sale = false;
      }
    }
    if (e == null) return;
    _date = e.date;
    switch (e) {
      case ValueUpdate(:final value):
        _tab = _Tab.value;
        _amount.text = _isMetal(h.investment)
            ? grossGrams(
                type: h.investment.type,
                pure: value,
                karat: h.investment.purityKarat,
                fineness: h.investment.purityFineness,
              ).toString()
            : value.toString();
      case MoneyIn(:final amount):
        _tab = _Tab.moneyIn;
        _amount.text = amount.amount.toString();
        _unit = amount.unit;
      case MoneyOut(:final amount, :final kind):
        _tab = _Tab.moneyOut;
        _amount.text = amount.amount.toString();
        _unit = amount.unit;
        _sale = kind == MoneyOutKind.sale;
      case InterestRecord(:final amount, :final kind):
        _tab = _Tab.interest;
        _amount.text = amount.amount.toString();
        _unit = amount.unit;
        _givenAway =
            kind == InterestKind.givenAwayFromInside ||
            kind == InterestKind.givenAwayFromPaidOut;
        _where = kind == InterestKind.keptInside
            ? _Where.keptInside
            : _Where.paidOut;
        _from = kind == InterestKind.givenAwayFromInside
            ? _Where.keptInside
            : _Where.paidOut;
      case PlanSkip():
    }
  }

  /// The calculator, only when it already knows this item.
  PortfolioCalculator? _calc({bool watch = false}) {
    final c =
        (watch ? ref.watch(calculatorProvider) : ref.read(calculatorProvider))
            .value;
    return c != null && c.hasItem(widget.investmentId) ? c : null;
  }

  bool _isMetal(Investment i) =>
      i.type == AssetType.gold || i.type == AssetType.silver;

  /// What the user typed as gross grams, as the pure grams a value holds.
  Decimal _asValue(Investment i, Decimal typed) => _isMetal(i)
      ? pureGrams(
          type: i.type,
          gross: typed,
          karat: i.purityKarat,
          fineness: i.purityFineness,
        )
      : typed;

  /// Interest still to give away, per place (item unit).
  ({Decimal kept, Decimal paid}) _toPurify(InvestmentWithHistory h) {
    var kept = Decimal.zero;
    var paid = Decimal.zero;
    if (h.investment.peCase == PeCase.c) {
      for (final e in h.history.whereType<MoneyOut>()) {
        if (e.kind == MoneyOutKind.income) paid += e.amount.amount;
      }
    }
    for (final e in h.history.whereType<InterestRecord>()) {
      if (e.id == widget.editing?.id) continue;
      final a = e.amount.amount;
      switch (e.kind) {
        case InterestKind.keptInside:
          kept += a;
        case InterestKind.paidOut:
          paid += a;
        case InterestKind.givenAwayFromInside:
          kept -= a;
        case InterestKind.givenAwayFromPaidOut:
          paid -= a;
      }
    }
    return (kept: kept, paid: paid);
  }

  Future<void> _save(InvestmentWithHistory h) async {
    final l10n = context.l10n;
    final item = h.investment;
    final calc = _calc();
    final amount = parseAmount(_amount.text);
    String? fail(String? message) {
      setState(() => _error = message);
      return message;
    }

    if (_date.isBefore(item.startDate)) {
      fail(l10n.errBeforeStart(context.date(item.startDate)));
      return;
    }
    final window = _window;
    if (window != null &&
        (_date.isBefore(window.$1) || _date.isAfter(window.$2))) {
      fail(
        l10n.errOutsideWindow(context.date(window.$1), context.date(window.$2)),
      );
      return;
    }
    if (amount == null || (amount <= Decimal.zero && _tab != _Tab.value)) {
      fail(l10n.errZero);
      return;
    }
    final unit = _unit ?? item.unit;
    final entries = <HistoryEntry>[];
    final existing = widget.editing;
    switch (_tab) {
      case _Tab.value:
        final typed = _perUnit && item.quantity != null
            ? amount * item.quantity!
            : amount;
        final value = _asValue(item, typed);
        final sameDay = h.history
            .whereType<ValueUpdate>()
            .where((v) => v.date == _date && v.id != existing?.id)
            .firstOrNull;
        if (sameDay != null) {
          final ok = await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text(l10n.replaceValueTitle(context.date(_date))),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: Text(l10n.replace),
                ),
              ],
            ),
          );
          if (ok != true) return;
          entries.add(
            ValueUpdate(
              id: sameDay.id,
              investmentId: item.id,
              date: _date,
              value: value,
              createdAt: sameDay.createdAt,
            ),
          );
        } else {
          entries.add(
            ValueUpdate(
              id: existing is ValueUpdate ? existing.id : null,
              investmentId: item.id,
              date: _date,
              value: value,
              createdAt: existing?.createdAt,
            ),
          );
        }
      case _Tab.moneyIn:
        entries.add(
          MoneyIn(
            id: existing is MoneyIn ? existing.id : null,
            investmentId: item.id,
            date: _date,
            amount: Money(amount, unit),
            createdAt: existing?.createdAt,
          ),
        );
        final after = parseAmount(_valueAfter.text);
        if (after != null) {
          entries.add(_valueOn(item.id, _asValue(item, after), h));
        }
      case _Tab.moneyOut:
        // Income never changes the value (Q12), even if a value left was
        // typed under Sale before switching.
        final left = _sale ? parseAmount(_valueLeft.text) : null;
        final current =
            calc?.timeline(item.id).recordedValueAt(_date) ?? Decimal.zero;
        final inItemUnit = unit == item.unit ? amount : null;
        if (_sale &&
            left == null &&
            inItemUnit != null &&
            inItemUnit > current) {
          fail(l10n.valueLeftRequired);
          return;
        }
        entries.add(
          MoneyOut(
            id: existing is MoneyOut ? existing.id : null,
            investmentId: item.id,
            date: _date,
            amount: Money(amount, unit),
            kind: _sale ? MoneyOutKind.sale : MoneyOutKind.income,
            createdAt: existing?.createdAt,
          ),
        );
        if (left != null) {
          entries.add(_valueOn(item.id, _asValue(item, left), h));
        }
      case _Tab.interest:
        final kind = _interestKind(h, amount);
        if (kind == null) return;
        entries.add(
          InterestRecord(
            id: existing is InterestRecord ? existing.id : null,
            investmentId: item.id,
            date: _date,
            amount: Money(amount, unit),
            kind: kind,
            createdAt: existing?.createdAt,
          ),
        );
    }
    try {
      await ref.read(investmentsRepositoryProvider).saveEntries(entries);
      if (mounted) Navigator.of(context).pop();
    } on Exception {
      fail(l10n.errSave);
    }
  }

  /// The row's date ± 7 days, never after today.
  (DateTime, DateTime)? get _window {
    final row = widget.row;
    if (row == null) return null;
    return (
      row.date.subtract(const Duration(days: 7)),
      earlier(row.date.add(const Duration(days: 7)), ref.read(todayProvider)),
    );
  }

  /// "This also records …" when a record typed by hand falls in a pending
  /// row's window (UX 2.12.3); interest only on a conventional deposit.
  String? _alsoRecords(Investment item) {
    if (widget.row != null || widget.editing != null) return null;
    final plan = ref.watch(expectedProvider(item.id));
    if (plan == null) return null;
    final kind = switch (_tab) {
      _Tab.value => PlanKind.value,
      _Tab.moneyOut when !_sale && !item.conventionalDeposit => PlanKind.payout,
      _Tab.interest when !_givenAway && item.conventionalDeposit =>
        PlanKind.payout,
      _ => null,
    };
    if (kind == null) return null;
    final row = plan.pendingRowNear(_date, kind);
    if (row == null) return null;
    final l10n = context.l10n;
    return kind == PlanKind.value
        ? l10n.alsoRecordsValue(context.date(row.date))
        : l10n.alsoRecordsPayout(context.date(row.date));
  }

  /// A value update on the same day replaces the one that is there.
  ValueUpdate _valueOn(String id, Decimal value, InvestmentWithHistory h) {
    final same = h.history
        .whereType<ValueUpdate>()
        .where((v) => v.date == _date)
        .firstOrNull;
    return ValueUpdate(
      id: same?.id,
      investmentId: id,
      date: _date,
      value: value,
      createdAt: same?.createdAt,
    );
  }

  InterestKind? _interestKind(InvestmentWithHistory h, Decimal amount) {
    final l10n = context.l10n;
    if (!_givenAway) {
      return _where == _Where.keptInside
          ? InterestKind.keptInside
          : InterestKind.paidOut;
    }
    final left = _toPurify(h);
    final available = _from == _Where.keptInside ? left.kept : left.paid;
    if (amount > available) {
      setState(
        () => _error = l10n.errGivenTooMuch(
          context.money(available, h.investment.unit),
        ),
      );
      return null;
    }
    return _from == _Where.keptInside
        ? InterestKind.givenAwayFromInside
        : InterestKind.givenAwayFromPaidOut;
  }

  Future<void> _delete(InvestmentWithHistory h) async {
    final e = widget.editing!;
    final repo = ref.read(investmentsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    await repo.deleteEntries([e.id]);
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.deleted),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => repo.saveEntries([e]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = ref.watch(investmentsProvider).value;
    final match = items?.where((h) => h.investment.id == widget.investmentId);
    if (match == null || match.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final h = match.first;
    _init(h);
    final item = h.investment;
    final today = ref.watch(todayProvider);
    final calc = _calc(watch: true);
    final amount = parseAmount(_amount.text);
    final last = calc?.timeline(item.id).recordedValueAt(_date);
    return Padding(
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
          children: [
            SegmentedButton<_Tab>(
              segments: [
                ButtonSegment(value: _Tab.value, label: Text(l10n.tabValue)),
                ButtonSegment(value: _Tab.moneyIn, label: Text(l10n.tabIn)),
                ButtonSegment(value: _Tab.moneyOut, label: Text(l10n.tabOut)),
                ButtonSegment(
                  value: _Tab.interest,
                  label: Text(l10n.tabInterest),
                ),
              ],
              selected: {_tab},
              onSelectionChanged: (s) => setState(() {
                _tab = s.first;
                _error = null;
              }),
            ),
            if (widget.row?.expected case final expected?)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.expectedHeader(
                    context.money(expected, item.unit),
                    context.date(widget.row!.date),
                  ),
                  key: const ValueKey('expected-header'),
                ),
              ),
            const SizedBox(height: 12),
            DateField(
              key: const ValueKey('record-date'),
              label: l10n.fieldDate,
              value: _date,
              firstDate: _window?.$1,
              lastDate: _window?.$2 ?? today,
              onChanged: (d) => setState(() => _date = d),
            ),
            if (_alsoRecords(item) case final line?)
              Text(line, key: const ValueKey('also-records')),
            ..._tabFields(context, h, last, amount),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  key: const ValueKey('record-error'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (widget.editing != null)
                  TextButton(
                    onPressed: () => _delete(h),
                    child: Text(l10n.delete),
                  ),
                const Spacer(),
                FilledButton(
                  key: const ValueKey('record-save'),
                  onPressed: () => _save(h),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabFields(
    BuildContext context,
    InvestmentWithHistory h,
    Decimal? last,
    Decimal? amount,
  ) {
    final l10n = context.l10n;
    final item = h.investment;
    final base = ref.read(settingsProvider).value?.baseCurrency ?? item.unit;
    Widget amountRow(String label) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AmountField(
            key: const ValueKey('record-amount'),
            controller: _amount,
            label: label,
            onChanged: (_) => setState(() => _error = null),
          ),
        ),
        const SizedBox(width: 8),
        if (_tab != _Tab.value)
          OutlinedButton(
            onPressed: () async {
              final u = await showUnitPicker(
                context,
                anchor: base,
                selected: _unit,
              );
              if (u != null) setState(() => _unit = u);
            },
            child: Text((_unit ?? item.unit).code),
          ),
      ],
    );
    switch (_tab) {
      case _Tab.value:
        final total = amount == null
            ? null
            : _perUnit && item.quantity != null
            ? amount * item.quantity!
            : amount;
        final ratio = last == null || last == Decimal.zero || total == null
            ? null
            : divide(total, last);
        return [
          if (last != null && last != Decimal.zero)
            Text(
              l10n.lastValue(
                context.money(last, item.unit),
                context.date(_date),
              ),
            ),
          amountRow(_isMetal(item) ? l10n.fieldGrams : l10n.fieldValue),
          if (_isMetal(item) && amount != null)
            Text(l10n.pureGramsPreview(context.grams(_asValue(item, amount)))),
          if (item.quantity != null)
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l10n.total)),
                ButtonSegment(value: true, label: Text(l10n.perUnit)),
              ],
              selected: {_perUnit},
              onSelectionChanged: (s) => setState(() => _perUnit = s.first),
            ),
          if (_perUnit && total != null)
            Text('= ${context.money(total, item.unit)}'),
          if (ratio != null &&
              (ratio > Decimal.parse('1.5') || ratio < Decimal.parse('0.5')))
            Text(
              l10n.typoCheck(ratio.round(scale: 1).toString()),
              key: const ValueKey('typo-check'),
            ),
        ];
      case _Tab.moneyIn:
        return [
          amountRow(l10n.fieldAmount),
          AmountField(controller: _valueAfter, label: l10n.fieldValueAfter),
        ];
      case _Tab.moneyOut:
        final left = parseAmount(_valueLeft.text);
        return [
          amountRow(l10n.fieldAmount),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(l10n.kindSale)),
              ButtonSegment(value: false, label: Text(l10n.kindIncome)),
            ],
            selected: {_sale},
            onSelectionChanged: (s) => setState(() => _sale = s.first),
          ),
          if (_sale) ...[
            AmountField(
              key: const ValueKey('value-left'),
              controller: _valueLeft,
              label: l10n.fieldValueLeft,
              onChanged: (_) => setState(() {}),
            ),
            if (left != null && left == Decimal.zero)
              Text(l10n.closesInvestment),
          ] else
            Text(l10n.incomeNoValueChange),
        ];
      case _Tab.interest:
        final caseC = item.peCase == PeCase.c;
        final left = _toPurify(h);
        final anyLeft = left.kept > Decimal.zero || left.paid > Decimal.zero;
        return [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l10n.interestReceived)),
              ButtonSegment(value: true, label: Text(l10n.interestGivenAway)),
            ],
            selected: {_givenAway},
            onSelectionChanged: (s) => setState(() {
              _givenAway = s.first;
              _from = left.kept > Decimal.zero || left.paid == Decimal.zero
                  ? _Where.keptInside
                  : _Where.paidOut;
            }),
          ),
          if (!_givenAway) ...[
            Text(l10n.interestWhere),
            SegmentedButton<_Where>(
              segments: [
                ButtonSegment(
                  value: _Where.paidOut,
                  label: Text(l10n.interestPaidOut),
                ),
                ButtonSegment(
                  value: _Where.keptInside,
                  label: Text(l10n.interestKeptInside),
                ),
              ],
              selected: {_where},
              onSelectionChanged: (s) => setState(() => _where = s.first),
            ),
            Text(
              l10n.interestNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            amountRow(l10n.fieldAmount),
          ] else if (!anyLeft)
            Text(l10n.nothingToPurify)
          else ...[
            Text(l10n.givenFrom),
            SegmentedButton<_Where>(
              segments: [
                if (left.kept > Decimal.zero)
                  ButtonSegment(
                    value: _Where.keptInside,
                    label: Text(l10n.interestKeptInside),
                  ),
                if (left.paid > Decimal.zero)
                  ButtonSegment(
                    value: _Where.paidOut,
                    label: Text(
                      caseC ? l10n.givenAwayFromPayouts : l10n.interestPaidOut,
                    ),
                  ),
              ],
              selected: {_from},
              onSelectionChanged: (s) => setState(() => _from = s.first),
            ),
            if (caseC && _from == _Where.paidOut)
              Text(
                l10n.givenAwayFromPayoutsHelp,
                key: const ValueKey('payouts-given-help'),
              ),
            Text(
              l10n.givenAwayNote,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              _from == _Where.keptInside ? l10n.effectKept : l10n.effectPaid,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            amountRow(l10n.fieldAmount),
          ],
        ];
    }
  }
}
