/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/reference/units.dart';
import '../investments_providers.dart';
import 'labels.dart';

/// The unit list of story §6.3: the most used units first, then all by code.
class UnitList extends ConsumerWidget {
  const UnitList({
    super.key,
    required this.anchor,
    required this.onPick,
    this.selected,
    this.query = '',
    this.shrinkWrap = false,
  });

  final Unit anchor;
  final Unit? selected;
  final String query;
  final bool shrinkWrap;
  final ValueChanged<Unit> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(unitOrderProvider(anchor));
    final q = query.trim().toLowerCase();
    bool matches(Unit u) =>
        q.isEmpty ||
        u.code.toLowerCase().contains(q) ||
        context.unitName(u).toLowerCase().contains(q);
    final top = order.units.take(order.topCount).where(matches).toList();
    final rest = order.units.skip(order.topCount).where(matches).toList();
    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );
    Widget tile(Unit u) => ListTile(
      key: ValueKey('unit-${u.code}'),
      title: Text(u.code),
      subtitle: Text(context.unitName(u)),
      selected: u == selected,
      trailing: u == selected ? const Icon(Icons.check) : null,
      onTap: () => onPick(u),
    );
    return ListView(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      children: [
        if (top.isNotEmpty) header(context.l10n.mostUsed),
        ...top.map(tile),
        if (rest.isNotEmpty) header(context.l10n.allUnits),
        ...rest.map(tile),
      ],
    );
  }
}

Future<Unit?> showUnitPicker(
  BuildContext context, {
  required Unit anchor,
  Unit? selected,
}) => showModalBottomSheet<Unit>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _UnitPickerSheet(anchor: anchor, selected: selected),
);

class _UnitPickerSheet extends StatefulWidget {
  const _UnitPickerSheet({required this.anchor, this.selected});

  final Unit anchor;
  final Unit? selected;

  @override
  State<_UnitPickerSheet> createState() => _UnitPickerSheetState();
}

class _UnitPickerSheetState extends State<_UnitPickerSheet> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
              labelText: context.l10n.searchUnits,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: UnitList(
            anchor: widget.anchor,
            selected: widget.selected,
            query: _query,
            onPick: (u) => Navigator.of(context).pop(u),
          ),
        ),
      ],
    );
  }
}
