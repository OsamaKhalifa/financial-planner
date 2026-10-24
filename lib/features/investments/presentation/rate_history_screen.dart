/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/rate.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/units.dart';
import 'investments_providers.dart';
import 'widgets/fields.dart';
import 'widgets/labels.dart';
import 'widgets/unit_picker_sheet.dart';

/// The dated history of one pair, both directions. Typed rates are added,
/// edited and deleted here; fetched ones are overridden by typing (AC-28).
class RateHistoryScreen extends ConsumerWidget {
  const RateHistoryScreen({super.key, required this.from, required this.to});

  final Unit from;
  final Unit to;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rates = ref.watch(ratesProvider).value;
    if (rates == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final rows =
        rates
            .where(
              (r) =>
                  (r.from == from && r.to == to) ||
                  (r.from == to && r.to == from),
            )
            .toList()
          ..sort((a, b) => b.asOf.compareTo(a.asOf));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rateHistoryTitle(from.code, to.code))),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add-rate'),
        onPressed: () => showRateDialog(context, from: from, to: to),
        icon: const Icon(Icons.add),
        label: Text(l10n.addRate),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.rateFetchedNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          for (final r in rows)
            ListTile(
              key: ValueKey('rate-row-${r.id}'),
              title: Text(
                l10n.rateLine(
                  r.from.code,
                  context.amount(r.rate, digits: 4),
                  r.to.code,
                  context.date(r.asOf),
                ),
              ),
              subtitle: Text(
                r.source == RateSource.typed
                    ? l10n.rateTagTyped
                    : l10n.rateTagFetched(l10n.refreshSource),
              ),
              onTap: r.source == RateSource.typed
                  ? () => showRateDialog(
                      context,
                      from: r.from,
                      to: r.to,
                      editing: r,
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}

Future<void> showRateDialog(
  BuildContext context, {
  required Unit from,
  required Unit to,
  Rate? editing,
  DateTime? on,
}) => showDialog<void>(
  context: context,
  builder: (_) => _RateDialog(from: from, to: to, editing: editing, on: on),
);

class _RateDialog extends ConsumerStatefulWidget {
  const _RateDialog({
    required this.from,
    required this.to,
    this.editing,
    this.on,
  });

  final Unit from;
  final Unit to;
  final Rate? editing;

  /// The date the rate is for when it is new (a zakat due date).
  final DateTime? on;

  @override
  ConsumerState<_RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends ConsumerState<_RateDialog> {
  late Unit _from = widget.from;
  late Unit _to = widget.to;
  late DateTime _date =
      widget.editing?.asOf ?? widget.on ?? ref.read(todayProvider);
  late final _rate = TextEditingController(
    text: widget.editing?.rate.toString() ?? '',
  );
  String? _error;

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final v = parseAmount(_rate.text);
    if (v == null || v <= Decimal.zero) {
      setState(() => _error = l10n.errRate);
      return;
    }
    final repo = ref.read(assumptionsRepositoryProvider);
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.saveTypedRate(
        Rate(
          id: widget.editing?.id,
          from: _from,
          to: _to,
          rate: v,
          asOf: _date,
        ),
      );
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.rateAddedToast)));
    } on Exception {
      setState(() => _error = l10n.errSave);
    }
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final e = widget.editing!;
    final repo = ref.read(assumptionsRepositoryProvider);
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await repo.deleteRate(e.id);
    nav.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.deleted),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => repo.saveTypedRate(e),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final v = parseAmount(_rate.text);
    final base = ref.read(settingsProvider).value?.baseCurrency ?? _to;
    return AlertDialog(
      title: Text(widget.editing == null ? l10n.addRate : l10n.editRate),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                OutlinedButton(
                  onPressed: () async {
                    final u = await showUnitPicker(
                      context,
                      anchor: base,
                      selected: _from,
                    );
                    if (u != null) setState(() => _from = u);
                  },
                  child: Text(_from.code),
                ),
                IconButton(
                  key: const ValueKey('swap'),
                  tooltip: l10n.swapDirection,
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () => setState(() {
                    final t = _from;
                    _from = _to;
                    _to = t;
                  }),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final u = await showUnitPicker(
                      context,
                      anchor: base,
                      selected: _to,
                    );
                    if (u != null) setState(() => _to = u);
                  },
                  child: Text(_to.code),
                ),
              ],
            ),
            DateField(
              label: l10n.fieldDate,
              value: _date,
              lastDate: ref.read(todayProvider),
              onChanged: (d) => setState(() => _date = d),
            ),
            AmountField(
              key: const ValueKey('rate-value'),
              controller: _rate,
              label: l10n.inlineRateField,
              error: _error,
              onChanged: (_) => setState(() => _error = null),
            ),
            if (v != null && v > Decimal.zero)
              Text(
                key: const ValueKey('inverse'),
                l10n.inverseLine(
                  _from.code,
                  context.amount(divide(Decimal.one, v), digits: 4),
                  _to.code,
                ),
              ),
          ],
        ),
      ),
      actions: [
        if (widget.editing != null)
          TextButton(onPressed: _delete, child: Text(l10n.delete)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('rate-save'),
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
