/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../investments/presentation/investments_providers.dart';
import '../../investments/presentation/why_builders.dart';
import '../../investments/presentation/why_sheet.dart';
import '../../investments/presentation/widgets/fields.dart';
import '../../investments/presentation/widgets/labels.dart';
import 'zakat_labels.dart';
import 'zakat_providers.dart';
import 'zakat_sheets.dart';

/// What `main.dart` puts into [zakatSettingsSectionProvider] (Z2); tests use
/// the same function.
Widget zakatSettingsSectionBuilder(BuildContext context) =>
    const ZakatSettingsSection();

/// The zakat rows of S8: zakat year, nisab, cycle date, reminder and the
/// giving-rate view (UX 2.8).
class ZakatSettingsSection extends ConsumerWidget {
  const ZakatSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final cycles = ref.watch(zakatCyclesProvider).value;
    if (settings == null || cycles == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _yearRows(context, ref, settings, cycles),
        _nisabRows(context, ref, settings.zakat),
        _cycleRow(context, cycles),
        _reminderRows(context, ref, settings.zakat),
        _rateViewRows(context, ref, settings.zakat),
      ],
    );
  }

  Widget _titleRow(BuildContext context, String title, Why why) => Row(
    children: [
      Expanded(child: Text(title)),
      TextButton(
        onPressed: () => showWhy(context, why),
        child: Text(context.l10n.source),
      ),
    ],
  );

  Widget _yearRows(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
    List<ZakatCycle> cycles,
  ) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleRow(
          context,
          l10n.zakatYearTitle,
          Why(
            title: l10n.zakatYearTitle,
            what: l10n.zakatYearWhy,
            source: l10n.src_A1A2,
          ),
        ),
        RadioGroup<ZakatYear>(
          groupValue: settings.zakatYear,
          onChanged: (v) => cycles.isEmpty
              ? ref.read(settingsActionsProvider).setZakatYear(v!)
              : showCycleChangeSheet(context, calendar: v),
          child: Column(
            children: [
              RadioListTile<ZakatYear>(
                key: const ValueKey('year-lunar'),
                value: ZakatYear.lunar,
                title: Text(l10n.zakatYearLunar),
              ),
              RadioListTile<ZakatYear>(
                key: const ValueKey('year-solar'),
                value: ZakatYear.solar,
                title: Text(l10n.zakatYearSolar),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nisabRows(BuildContext context, WidgetRef ref, ZakatPrefs prefs) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleRow(context, l10n.zakatSettingsNisab, nisabWhy(context)),
        NisabRadios(
          selected: prefs.nisab,
          onChanged: (m) => writeOrTell(
            context,
            () => ref.read(zakatActionsProvider).setNisab(m),
          ),
        ),
        Text(
          l10n.zakatSettingsNisabHelp,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _cycleRow(BuildContext context, List<ZakatCycle> cycles) {
    final l10n = context.l10n;
    final cycle = cycles.lastOrNull;
    return ListTile(
      key: const ValueKey('cycle-row'),
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.zakatSettingsCycle),
      subtitle: Text(
        cycle == null
            ? l10n.zakatNotSetYet
            : l10n.zakatCycleValue(
                cycle.calendar.name,
                '${cycle.day}',
                cycleMonthName(context, cycle.calendar, cycle.month),
              ),
      ),
      trailing: TextButton(
        key: const ValueKey('cycle-change'),
        onPressed: () => showCycleChangeSheet(context),
        child: Text(l10n.change),
      ),
    );
  }

  Widget _reminderRows(BuildContext context, WidgetRef ref, ZakatPrefs prefs) {
    final l10n = context.l10n;
    final blocked =
        prefs.reminderAsked &&
        ref.watch(reminderPermittedProvider).value == false;
    final on = prefs.reminderOn && !blocked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile.adaptive(
          key: const ValueKey('reminder-switch'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.reminderSwitch),
          subtitle: Text(
            blocked
                ? l10n.reminderBlocked
                : on
                ? l10n.reminderOnSubtitle(
                    prefs.reminderDays,
                    context.clockText(prefs.reminderMinute),
                  )
                : l10n.reminderOffSubtitle,
          ),
          value: on,
          onChanged: blocked
              ? null
              : (v) => writeOrTell(
                  context,
                  () => ref.read(zakatActionsProvider).setReminder(on: v),
                ),
        ),
        if (on)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              key: const ValueKey('reminder-change'),
              onPressed: () =>
                  showZakatSheet<void>(context, (_) => const _ReminderSheet()),
              child: Text(l10n.change),
            ),
          ),
      ],
    );
  }

  Widget _rateViewRows(BuildContext context, WidgetRef ref, ZakatPrefs prefs) {
    final l10n = context.l10n;
    final view = prefs.givingRateView;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleRow(
          context,
          l10n.zakatSettingsRateView,
          Why(
            title: l10n.zakatGiftViewTitle,
            what: l10n.zakatGiftViewHelp,
            source: zakatSource(l10n, 'C8'),
          ),
        ),
        if (view == null)
          Text(l10n.zakatSettingsRateViewNone)
        else ...[
          RadioGroup<GivingRateView>(
            groupValue: view,
            onChanged: (v) => _setView(context, ref, v!),
            child: Column(
              children: [
                RadioListTile<GivingRateView>(
                  key: const ValueKey('rate-view-dayGiven'),
                  value: GivingRateView.dayGiven,
                  title: Text(l10n.zakatGiftViewDay),
                ),
                RadioListTile<GivingRateView>(
                  key: const ValueKey('rate-view-dueDate'),
                  value: GivingRateView.dueDate,
                  title: Text(l10n.zakatGiftViewDue),
                ),
              ],
            ),
          ),
          Text(
            l10n.zakatRateViewChanged,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Future<void> _setView(
    BuildContext context,
    WidgetRef ref,
    GivingRateView v,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final text = context.l10n.zakatRateViewChanged;
    if (await writeOrTell(
      context,
      () => ref.read(zakatActionsProvider).setGivingRateView(v),
    )) {
      messenger.showSnackBar(SnackBar(content: Text(text)));
    }
  }
}

class _ReminderSheet extends ConsumerStatefulWidget {
  const _ReminderSheet();

  @override
  ConsumerState<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends ConsumerState<_ReminderSheet> {
  late final ZakatPrefs _prefs = ref.read(settingsProvider).value!.zakat;
  late int? _days = _prefs.reminderDays;
  late int _minute = _prefs.reminderMinute;

  Future<void> _save() async {
    final nav = Navigator.of(context);
    final actions = ref.read(zakatActionsProvider);
    if (await writeOrTell(
      context,
      () => actions.setReminder(days: _days, minute: _minute),
    )) {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final today = ref.watch(todayProvider);
    final coming = ref
        .watch(zakatYearsProvider)
        ?.where((y) => !y.slot.due.isBefore(today))
        .firstOrNull;
    return SheetBody(
      children: [
        Text(
          l10n.reminderSwitch,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ReminderFields(
          days: _prefs.reminderDays,
          minute: _prefs.reminderMinute,
          coming: coming?.slot,
          onChanged: (days, minute) => setState(() {
            _days = days;
            _minute = minute;
          }),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            key: const ValueKey('reminder-save'),
            onPressed: _days == null ? null : _save,
            child: Text(l10n.save),
          ),
        ),
      ],
    );
  }
}
