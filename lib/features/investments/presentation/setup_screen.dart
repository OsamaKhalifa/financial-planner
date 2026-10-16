/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/domain/settings.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/units.dart';
import 'investments_providers.dart';
import 'why_sheet.dart';
import 'widgets/labels.dart';
import 'widgets/unit_picker_sheet.dart';

enum _Method { dividendsOnly, proxy25, fullValue, perItem, notNow }

const _regionCurrency = {
  'AE': 'AED', 'AU': 'AUD', 'BD': 'BDT', 'BH': 'BHD', 'CA': 'CAD',
  'CH': 'CHF', 'CN': 'CNY', 'DK': 'DKK', 'DZ': 'DZD', 'EG': 'EGP',
  'GB': 'GBP', 'HK': 'HKD', 'ID': 'IDR', 'IN': 'INR', 'JO': 'JOD',
  'JP': 'JPY', 'KW': 'KWD', 'MA': 'MAD', 'MY': 'MYR', 'NG': 'NGN',
  'NO': 'NOK', 'OM': 'OMR', 'PK': 'PKR', 'QA': 'QAR', 'SA': 'SAR',
  'SE': 'SEK', 'SG': 'SGD', 'TN': 'TND', 'TR': 'TRY', 'US': 'USD',
  'ZA': 'ZAR',
};

/// S1: two steps; nothing is applied that the user has not seen (AC-8).
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  var _step = 0;
  Unit? _base;
  Country? _home;
  ZakatYear _year = ZakatYear.lunar;
  _Method? _method;

  Unit get _anchor {
    final region = ui.PlatformDispatcher.instance.locale.countryCode;
    return Unit(_regionCurrency[region] ?? 'USD');
  }

  Future<void> _finish() async {
    final method = switch (_method) {
      _Method.dividendsOnly => LongTermMethod.dividendsOnly,
      _Method.proxy25 => LongTermMethod.proxy25,
      _Method.fullValue => LongTermMethod.fullValue,
      _Method.perItem => LongTermMethod.perItem,
      _Method.notNow || null => null,
    };
    await ref.read(settingsActionsProvider).saveSettings(
      Settings(
        baseCurrency: _base,
        homeInflation: _home,
        zakatYear: _year,
        longTermMethod: method,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step = 0);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: SafeArea(child: _step == 0 ? _baseStep(context) : _zakatStep(context)),
      ),
    );
  }

  Widget _baseStep(BuildContext context) {
    final l10n = context.l10n;
    final base = _base;
    final home = _home ?? (base == null ? null : defaultCountryOf(base));
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.setupBaseTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(l10n.setupBaseHelp),
              if (base != null && home != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeInflationLine(context.countryName(home), base.code),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final c = await _pickCountry(context);
                        if (c != null) setState(() => _home = c);
                      },
                      child: Text(l10n.change),
                    ),
                  ],
                ),
              ],
              UnitList(
                anchor: _anchor,
                selected: base,
                shrinkWrap: true,
                onPick: (u) => setState(() {
                  _base = u;
                  _home = null;
                }),
              ),
            ],
          ),
        ),
        _bottomBar(
          label: l10n.next,
          onPressed: base == null ? null : () => setState(() => _step = 1),
        ),
      ],
    );
  }

  Widget _zakatStep(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.setupZakatTitle, style: textTheme.titleLarge),
              const SizedBox(height: 16),
              _rowTitle(
                l10n.zakatYearTitle,
                () => showWhy(
                  context,
                  Why(
                    title: l10n.zakatYearTitle,
                    what: l10n.zakatYearWhy,
                    source: l10n.src_A1A2,
                  ),
                ),
              ),
              Text(l10n.zakatYearWhy, style: textTheme.bodySmall),
              RadioGroup<ZakatYear>(
                groupValue: _year,
                onChanged: (v) => setState(() => _year = v!),
                child: Column(
                  children: [
                    RadioListTile<ZakatYear>(
                      value: ZakatYear.lunar,
                      title: Text(l10n.zakatYearLunar),
                    ),
                    RadioListTile<ZakatYear>(
                      value: ZakatYear.solar,
                      title: Text(l10n.zakatYearSolar),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _rowTitle(
                l10n.longTermTitle,
                () => showWhy(
                  context,
                  Why(
                    title: l10n.longTermTitle,
                    what: l10n.longTermWhy,
                    source: l10n.src_B3,
                  ),
                ),
              ),
              Text(l10n.longTermWhy, style: textTheme.bodySmall),
              RadioGroup<_Method>(
                groupValue: _method,
                onChanged: (v) => setState(() => _method = v),
                child: Column(
                  children: [
                    RadioListTile<_Method>(
                      value: _Method.dividendsOnly,
                      title: Text(l10n.longTermDividendsOnly),
                    ),
                    RadioListTile<_Method>(
                      value: _Method.proxy25,
                      title: Text(l10n.longTermProxy25),
                    ),
                    RadioListTile<_Method>(
                      value: _Method.fullValue,
                      title: Text(l10n.longTermFullValue),
                    ),
                    RadioListTile<_Method>(
                      value: _Method.perItem,
                      title: Text(l10n.longTermPerItem),
                    ),
                    RadioListTile<_Method>(
                      value: _Method.notNow,
                      title: Text(l10n.longTermNotNow),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _bottomBar(label: l10n.done, onPressed: _finish),
      ],
    );
  }

  Widget _rowTitle(String title, VoidCallback onSource) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      TextButton(onPressed: onSource, child: Text(context.l10n.source)),
    ],
  );

  Widget _bottomBar({required String label, required VoidCallback? onPressed}) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onPressed, child: Text(label)),
        ),
      );
}

Future<Country?> _pickCountry(BuildContext context) => showModalBottomSheet<Country>(
  context: context,
  builder: (_) => ListView(
    children: [
      for (final c in v1Countries)
        ListTile(
          key: ValueKey('country-${c.iso3}'),
          title: Text(context.countryName(c)),
          onTap: () => Navigator.of(context).pop(c),
        ),
    ],
  ),
);
