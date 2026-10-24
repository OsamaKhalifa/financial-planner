/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../investments/presentation/assumptions_screen.dart';
import '../../investments/presentation/investments_providers.dart';
import '../../investments/presentation/why_builders.dart';
import '../../investments/presentation/why_sheet.dart';
import '../../investments/presentation/widgets/fields.dart';
import '../../investments/presentation/widgets/labels.dart';
import '../domain/yearly_zakat.dart';
import 'zakat_labels.dart';
import 'zakat_providers.dart';
import 'zakat_sheets.dart';

enum _Step { nisab, cycle, remind }

/// Z1: asks only what is missing, one step per page. A step already answered
/// is never asked again (U3, AC-7); nothing is pre-filled (AC-1).
class ZakatSetup extends ConsumerStatefulWidget {
  const ZakatSetup({
    super.key,
    required this.needsNisab,
    required this.needsCycle,
  });

  final bool needsNisab;
  final bool needsCycle;

  @override
  ConsumerState<ZakatSetup> createState() => _ZakatSetupState();
}

class _ZakatSetupState extends ConsumerState<ZakatSetup> {
  late final _steps = [
    if (widget.needsNisab) _Step.nisab,
    if (widget.needsCycle) ...[_Step.cycle, _Step.remind],
  ];
  late final ZakatPrefs _prefs = ref.read(settingsProvider).value!.zakat;
  late int? _days = _prefs.reminderDays;
  late int _minute = _prefs.reminderMinute;
  var _i = 0;
  NisabMetal? _nisab;
  int? _month;
  int? _day;

  _Step get _step => _steps[_i];

  bool _fits(ZakatYear calendar) =>
      _month != null && _day != null && cycleDateFits(calendar, _month!, _day!);

  bool _canGo(ZakatYear calendar) => switch (_step) {
    _Step.nisab => _nisab != null,
    _Step.cycle => _fits(calendar),
    _Step.remind => _days != null,
  };

  Future<void> _next(ZakatYear calendar) async {
    final actions = ref.read(zakatActionsProvider);
    switch (_step) {
      case _Step.nisab:
        final saved = await writeOrTell(
          context,
          () => actions.setNisab(_nisab!),
        );
        if (saved && mounted && _i + 1 < _steps.length) {
          setState(() => _i++);
        }
      case _Step.cycle:
        setState(() => _i++);
      case _Step.remind:
        await saveCycleTelling(
          context,
          ref,
          calendar: calendar,
          month: _month!,
          day: _day!,
          reminderDays: _days,
          reminderMinute: _minute,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final calendar = ref.watch(settingsProvider).value!.zakatYear!;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: switch (_step) {
              _Step.nisab => _nisabStep(context),
              _Step.cycle => _cycleStep(context, calendar),
              _Step.remind => _remindStep(context, calendar),
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_i > 0)
                OutlinedButton(
                  key: const ValueKey('setup-back'),
                  onPressed: () => setState(() => _i--),
                  child: Text(l10n.back),
                ),
              const Spacer(),
              FilledButton(
                key: const ValueKey('setup-next'),
                onPressed: _canGo(calendar) ? () => _next(calendar) : null,
                child: Text(_step == _Step.remind ? l10n.save : l10n.next),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _title(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.titleLarge);

  List<Widget> _nisabStep(BuildContext context) {
    final l10n = context.l10n;
    return [
      _title(context, l10n.zakatSetupNisabTitle),
      NisabRadios(
        selected: _nisab,
        onChanged: (m) => setState(() => _nisab = m),
      ),
      const SizedBox(height: 8),
      Text(l10n.zakatNisabWhy),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          onPressed: () => showWhy(context, nisabWhy(context)),
          child: Text(l10n.source),
        ),
      ),
    ];
  }

  List<Widget> _cycleStep(BuildContext context, ZakatYear calendar) {
    final l10n = context.l10n;
    return [
      _title(context, l10n.zakatSetupCycleTitle),
      const SizedBox(height: 8),
      Text(l10n.zakatCycleHelp(calendar.name)),
      Text(l10n.zakatCycleNotToday),
      Row(
        children: [
          Expanded(child: Text(l10n.zakatCalendarLine(calendar.name))),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AssumptionsScreen(),
              ),
            ),
            child: Text(l10n.change),
          ),
        ],
      ),
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
      if (_fits(calendar)) _nextDueCard(context, calendar),
    ];
  }

  YearSlot _firstYear(ZakatYear calendar) => yearSlots(
    [
      ZakatCycle(
        calendar: calendar,
        month: _month!,
        day: _day!,
        from: ref.read(todayProvider),
      ),
    ],
    const {},
    ref.read(todayProvider),
  ).first;

  Widget _nextDueCard(BuildContext context, ZakatYear calendar) {
    final l10n = context.l10n;
    final first = _firstYear(calendar);
    final lunar = calendar == ZakatYear.lunar;
    final label = context.yearLabel(first);
    return Card(
      key: const ValueKey('next-due'),
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.zakatNextDue(
                lunar ? context.hijriDate(first.due) : context.date(first.due),
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              lunar ? context.date(first.due) : context.hijriDate(first.due),
            ),
            Text(l10n.zakatThisYearCalled(label)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => showWhy(
                context,
                Why(
                  title: l10n.zakatSetupCycleTitle,
                  what: l10n.zakatPastYears(label),
                  source: zakatSource(l10n, 'C2'),
                ),
              ),
              child: Text(
                l10n.zakatPastYears(label),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _remindStep(BuildContext context, ZakatYear calendar) {
    final l10n = context.l10n;
    return [
      _title(context, l10n.zakatSetupRemindTitle),
      const SizedBox(height: 8),
      ReminderFields(
        days: _prefs.reminderDays,
        minute: _prefs.reminderMinute,
        coming: _firstYear(calendar),
        onChanged: (days, minute) => setState(() {
          _days = days;
          _minute = minute;
        }),
      ),
      const SizedBox(height: 12),
      Text(l10n.reminderPermissionLine),
    ];
  }
}
