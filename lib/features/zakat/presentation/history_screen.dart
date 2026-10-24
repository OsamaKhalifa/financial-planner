/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../investments/presentation/widgets/labels.dart';
import '../domain/yearly_zakat.dart';
import 'year_screen.dart';
import 'zakat_labels.dart';
import 'zakat_providers.dart';

/// Z8: every year, newest due date first, whatever its calendar (AC-32).
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final years = ref.watch(zakatYearsProvider);
    final newestFirst = years == null
        ? null
        : ([...years]..sort((a, b) => b.slot.due.compareTo(a.slot.due)));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.zakatHistoryTitle)),
      body: newestFirst == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(children: [for (final y in newestFirst) _HistoryRow(y)]),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow(this.view);

  final YearView view;

  String _due(BuildContext context) {
    final z = view.result.z;
    if (z == null) return '—';
    final amount = context.money(z, view.inputs.base);
    return view.frozen ? amount : '$amount · ${context.l10n.zakatEstimateTag}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final given = context.money(view.progress.distributed, view.inputs.base);
    return ListTile(
      key: ValueKey('history-${yearKeyText(view.slot.key)}'),
      title: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(context.yearLabel(view.slot)),
          Chip(label: Text(context.stateName(view))),
        ],
      ),
      subtitle: Text(context.date(view.slot.due)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(_due(context), style: Theme.of(context).textTheme.titleSmall),
          Text(l10n.zakatHistoryGiven(given)),
        ],
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => YearScreen(yearKey: view.slot.key),
        ),
      ),
    );
  }
}
