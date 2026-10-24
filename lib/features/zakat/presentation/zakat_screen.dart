/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../main.dart';
import '../../investments/presentation/widgets/labels.dart';
import '../domain/year_end_reminder.dart';
import '../domain/yearly_zakat.dart';
import '../../settings/settings_screen.dart';
import 'history_screen.dart';
import 'year_screen.dart';
import 'zakat_labels.dart';
import 'zakat_providers.dart';
import 'zakat_setup.dart';

typedef _Synced = ({
  String yearKey,
  DateTime fireAt,
  String title,
  String body,
});

/// Zakat tab (UC-3): the due texts and the year that needs the user, or the
/// setup while an answer is missing. It also keeps the one year-end
/// notification in step with the data and routes a tapped notification to its
/// year (AC-36, AC-37).
class ZakatScreen extends ConsumerStatefulWidget {
  const ZakatScreen({super.key});

  @override
  ConsumerState<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends ConsumerState<ZakatScreen> {
  StreamSubscription<String>? _taps;
  String? _pendingKey;
  var _scheduleKnown = false;
  _Synced? _synced;

  @override
  void initState() {
    super.initState();
    final reminder = ref.read(yearEndReminderProvider);
    _taps = reminder.taps.listen(_open);
    unawaited(
      reminder.launchYearKey().then((key) {
        if (key != null) _open(key);
      }),
    );
  }

  @override
  void dispose() {
    unawaited(_taps?.cancel());
    super.dispose();
  }

  void _open(String key) {
    _pendingKey = key;
    final years = ref.read(zakatYearsProvider);
    if (years != null) _route(years);
  }

  /// The year of the notification, or the focus year when it is gone.
  void _route(List<YearView> years) {
    final key = parseYearKey(_pendingKey!);
    _pendingKey = null;
    AppShell.select(context, AppShell.zakatTab);
    final nav = Navigator.of(context)..popUntil((r) => r.isFirst);
    if (years.any((y) => y.slot.key == key)) {
      nav.push(
        MaterialPageRoute<void>(builder: (_) => YearScreen(yearKey: key)),
      );
    }
  }

  void _onPlan(AsyncValue<ReminderPlan?> plan) {
    final years = ref.read(zakatYearsProvider);
    if (plan is! AsyncData<ReminderPlan?> || years == null) return;
    final want = plan.value == null ? null : _reminderOf(plan.value!, years);
    final next = want == null
        ? null
        : (
            yearKey: want.yearKey,
            fireAt: want.fireAt,
            title: want.title,
            body: want.body,
          );
    if (_scheduleKnown && next == _synced) return;
    _scheduleKnown = true;
    _synced = next;
    final reminder = ref.read(yearEndReminderProvider);
    unawaited(want == null ? reminder.cancel() : reminder.schedule(want));
  }

  Reminder _reminderOf(ReminderPlan plan, List<YearView> years) {
    final l10n = context.l10n;
    final slot = years.firstWhere((y) => y.slot.key == plan.yearKey).slot;
    return Reminder(
      yearKey: yearKeyText(plan.yearKey),
      fireAt: plan.fireAt,
      title: l10n.reminderTitle,
      body: context.reminderText(
        label: context.yearLabel(slot),
        daysBefore: plan.daysBefore,
        due: plan.due,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(reminderPlanProvider, (_, next) => _onPlan(next));
    ref.listen(zakatYearsProvider, (_, years) {
      if (years != null && _pendingKey != null) _route(years);
    });
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final years = ref.watch(zakatYearsProvider);
    Widget scaffold(Widget body, {YearView? focus}) => Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabZakat),
        actions: [
          IconButton(
            key: const ValueKey('zakat-history'),
            tooltip: l10n.zakatHistoryTitle,
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
            ),
          ),
          const SettingsAction(),
        ],
      ),
      floatingActionButton: focus == null ? null : yearFab(context, focus),
      body: body,
    );
    if (settings == null || years == null) {
      return scaffold(const Center(child: CircularProgressIndicator()));
    }
    final needsNisab = settings.zakat.nisab == null;
    if (needsNisab || years.isEmpty) {
      return scaffold(
        ZakatSetup(
          key: const ValueKey('zakat-setup'),
          needsNisab: needsNisab,
          needsCycle: years.isEmpty,
        ),
      );
    }
    final focus = focusYear(years);
    return scaffold(
      YearContent(view: focus, top: _dueTexts(context, years)),
      focus: focus,
    );
  }

  List<Widget> _dueTexts(BuildContext context, List<YearView> years) {
    final due =
        years.where((y) => y.state == YearState.due && !y.frozen).toList()
          ..sort((a, b) => a.slot.due.compareTo(b.slot.due));
    return [for (final y in due) _DueText(y)];
  }
}

/// One tonal card per year in state due (C10, AC-39): information, never an
/// alarm.
class _DueText extends StatelessWidget {
  const _DueText(this.view);

  final YearView view;

  String _text(BuildContext context) {
    final l10n = context.l10n;
    final label = context.yearLabel(view.slot);
    final z = view.result.z;
    if (z == null) {
      return l10n.zakatDueIncomplete(label, context.date(view.slot.due));
    }
    return z > Decimal.zero
        ? l10n.zakatDueIs(label)
        : l10n.zakatDueBelow(label, context.date(view.slot.due));
  }

  @override
  Widget build(BuildContext context) => Card(
    key: ValueKey('due-text-${yearKeyText(view.slot.key)}'),
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(_text(context)),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => YearScreen(yearKey: view.slot.key),
        ),
      ),
    ),
  );
}
