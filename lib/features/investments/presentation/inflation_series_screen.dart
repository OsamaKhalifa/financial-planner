/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/inflation.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/countries.dart';
import 'investments_providers.dart';
import 'widgets/fields.dart';
import 'widgets/labels.dart';

/// One country's yearly inflation: shipped, yours, or assumed (AC-32, AC-33).
class InflationSeriesScreen extends ConsumerWidget {
  const InflationSeriesScreen({super.key, required this.country});

  final Country country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final book = ref.watch(inflationBookProvider).value;
    final shipped = ref.watch(shippedInflationProvider).value;
    final overrides = ref.watch(inflationOverridesProvider).value;
    final today = ref.watch(todayProvider);
    if (book == null || shipped == null || overrides == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final name = context.countryName(country);
    final years = {
      ...?shipped.series[country]?.keys,
      for (final o in overrides)
        if (o.country == country) o.year,
      today.year,
    }.toList()..sort((a, b) => b.compareTo(a));
    final empty =
        (shipped.series[country]?.isEmpty ?? true) &&
        !overrides.any((o) => o.country == country);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inflationRow(name))),
      body: ListView(
        children: [
          if (empty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.emptySeries(name)),
            ),
          for (final y in years) _yearTile(context, ref, book, y),
        ],
      ),
    );
  }

  Widget _yearTile(
    BuildContext context,
    WidgetRef ref,
    InflationBook book,
    int year,
  ) {
    final l10n = context.l10n;
    final yi = book.forYear(country, year);
    final tag = switch (yi?.provenance) {
      InflationProvenance.shipped => l10n.tagShipped,
      InflationProvenance.user => l10n.tagYours,
      InflationProvenance.assumed => l10n.tagAssumed('${yi!.assumedFrom}'),
      null => l10n.rateMissingMarker,
    };
    return ListTile(
      key: ValueKey('year-$year'),
      title: Text(
        l10n.inflationYearLine(
          '$year',
          yi == null ? '—' : context.percent(yi.rate),
          tag,
        ),
      ),
      trailing: yi?.provenance == InflationProvenance.user
          ? TextButton(
              onPressed: () => ref
                  .read(assumptionsRepositoryProvider)
                  .clearInflationOverride(country, year),
              child: Text(l10n.resetToShipped),
            )
          : null,
      onTap: () => _edit(context, ref, year, yi),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    int year,
    YearInflation? yi,
  ) => showDialog<void>(
    context: context,
    builder: (_) => _OverrideDialog(country: country, year: year, current: yi),
  );
}

class _OverrideDialog extends ConsumerStatefulWidget {
  const _OverrideDialog({
    required this.country,
    required this.year,
    required this.current,
  });

  final Country country;
  final int year;
  final YearInflation? current;

  @override
  ConsumerState<_OverrideDialog> createState() => _OverrideDialogState();
}

class _OverrideDialogState extends ConsumerState<_OverrideDialog> {
  late final _controller = TextEditingController(
    text: widget.current == null
        ? ''
        : (widget.current!.rate * Decimal.fromInt(100)).toString(),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final p = parseAmount(_controller.text);
    if (p == null || p < Decimal.fromInt(-50) || p > Decimal.fromInt(1000)) {
      setState(() => _error = l10n.errInflation);
      return;
    }
    final nav = Navigator.of(context);
    await ref
        .read(assumptionsRepositoryProvider)
        .setInflationOverride(
          widget.country,
          widget.year,
          divide(p, Decimal.fromInt(100)),
        );
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(
        l10n.overrideTitle(
          context.countryName(widget.country),
          '${widget.year}',
        ),
      ),
      content: AmountField(
        key: const ValueKey('override-field'),
        controller: _controller,
        label: l10n.inflationPercentField,
        error: _error,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('override-save'),
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
