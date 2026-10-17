/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/data/rate_refresher.dart';
import '../../../core/assumptions/domain/rate.dart';
import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/ids.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import '../domain/history_entry.dart';
import '../domain/investment.dart';
import '../domain/investment_draft.dart';
import '../domain/zakat_rules.dart';
import 'investments_providers.dart';
import 'item_detail_screen.dart';
import 'why_builders.dart';
import 'why_sheet.dart';
import 'widgets/fields.dart';
import 'widgets/labels.dart';
import 'widgets/unit_picker_sheet.dart';

/// S3: add or edit. Asset type decides the fields; nothing is defaulted
/// silently where the Shariah file says "ask" (AC-1, AC-2, AC-5..AC-8).
class InvestmentFormScreen extends ConsumerStatefulWidget {
  const InvestmentFormScreen({super.key, this.presetType, this.editId});

  final AssetType? presetType;
  final String? editId;

  @override
  ConsumerState<InvestmentFormScreen> createState() => _FormState();
}

class _FormState extends ConsumerState<InvestmentFormScreen> {
  final _name = TextEditingController();
  final _paid = TextEditingController();
  final _value = TextEditingController();
  final _quantity = TextEditingController();
  final _grams = TextEditingController();
  final _share = TextEditingController();
  final _notes = TextEditingController();
  final _rate = TextEditingController();

  AssetType? _type;
  Intent? _intent;
  Market? _market;
  Country? _marketCountry;
  Unit? _unit;
  Unit? _paidUnit;
  DateTime? _start;
  DateTime? _valueDate;
  int? _karat;
  int? _fineness;
  bool _companyPays = false;
  LongTermMethod? _chosenMethod;
  bool? _chosenJewellery;
  Set<DraftError> _errors = {};
  bool _rateMissing = false;
  bool _showRateRow = false;
  String _rateKey = '';
  bool _fetchAsked = false;
  bool _customShare = false;
  Country? _inflation;
  String? _rateError;
  Investment? _editing;
  var _dirty = false;

  bool get _isEdit => widget.editId != null;

  @override
  void initState() {
    super.initState();
    _type = widget.presetType;
    if (widget.presetType != null) _applyTypeDefaults();
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _paid,
      _value,
      _quantity,
      _grams,
      _share,
      _notes,
      _rate,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Unit? get _base => ref.read(settingsProvider).value?.baseCurrency;

  void _touch(VoidCallback f) => setState(() {
    _dirty = true;
    f();
  });

  void _applyTypeDefaults() {
    final base = _base;
    _unit = switch (_type) {
      AssetType.gold => xauG,
      AssetType.silver => xagG,
      _ => base,
    };
    _paidUnit = _unit?.isMetal == true ? base : _unit;
    _intent = switch (_type) {
      AssetType.gold || AssetType.silver => Intent.longTerm,
      _ => null,
    };
    _market = null;
    _karat = null;
    _fineness = null;
    _companyPays = false;
    _chosenMethod = null;
    _share.clear();
  }

  void _loadEdit(Investment i) {
    _editing = i;
    _name.text = i.name;
    _type = i.type;
    _intent = i.intent;
    _market = i.market;
    _marketCountry = i.marketCountry;
    _unit = i.unit;
    _start = i.startDate;
    _quantity.text = i.quantity?.toString() ?? '';
    _karat = i.purityKarat;
    _fineness = i.purityFineness;
    _notes.text = i.notes ?? '';
    _inflation = i.inflationOverride;
    _customShare = i.zakatRule == ZakatRule.custom && i.type != AssetType.other;
    _companyPays = i.zakatRule == ZakatRule.companyPaysZakat;
    if (i.zakatRule == ZakatRule.custom && i.customZakatShare != null) {
      _share.text = (i.customZakatShare! * Decimal.fromInt(100)).toString();
    }
    _chosenMethod = switch (i.zakatRule) {
      ZakatRule.longTermDividendsOnly => LongTermMethod.dividendsOnly,
      ZakatRule.longTermProxy25 => LongTermMethod.proxy25,
      ZakatRule.longTermFullValue => LongTermMethod.fullValue,
      _ => null,
    };
  }

  Settings get _settings =>
      ref.read(settingsProvider).value ?? const Settings();

  /// The settings as the form would leave them: answers given here count.
  Settings get _effectiveSettings => Settings(
    baseCurrency: _settings.baseCurrency,
    homeInflation: _settings.homeInflation,
    zakatYear: _settings.zakatYear,
    longTermMethod: _settings.longTermMethod ?? _chosenMethod,
    jewelleryZakatable: _settings.jewelleryZakatable ?? _chosenJewellery,
  );

  ZakatRule? get _rule {
    final type = _type;
    if (type == null) return null;
    if (_companyPays && type == AssetType.stock) {
      return ZakatRule.companyPaysZakat;
    }
    if (type == AssetType.other ||
        (_customShare && type != AssetType.cashDeposit)) {
      return _share.text.trim().isEmpty ? null : ZakatRule.custom;
    }
    final stockLike = type == AssetType.stock || type == AssetType.fund;
    if (stockLike &&
        _intent == Intent.longTerm &&
        _settings.longTermMethod == LongTermMethod.perItem &&
        _chosenMethod != null) {
      return explicitLongTermRule(_chosenMethod!);
    }
    return defaultRule(type, _intent, _effectiveSettings);
  }

  Decimal? get _shareFraction {
    final p = parseAmount(_share.text);
    return p == null ? null : divide(p, Decimal.fromInt(100));
  }

  InvestmentDraft _draft() {
    final type = _type;
    final grossGrams = parseAmount(_grams.text);
    final purity = type == AssetType.gold ? _karat : _fineness;
    final pure =
        (type == AssetType.gold || type == AssetType.silver) &&
            grossGrams != null &&
            purity != null
        ? pureGrams(
            type: type!,
            gross: grossGrams,
            karat: _karat,
            fineness: _fineness,
          )
        : null;
    final paid = parseAmount(_paid.text);
    return InvestmentDraft(
      name: _name.text,
      type: type,
      intent: _intent,
      market: _market,
      marketCountry: _marketCountry,
      unit: _unit,
      startDate: _start,
      firstPaid: paid == null || _paidUnit == null
          ? null
          : Money(paid, _paidUnit!),
      currentValue: pure ?? parseAmount(_value.text),
      grossGrams: grossGrams,
      purityKarat: _karat,
      purityFineness: _fineness,
      quantity: parseAmount(_quantity.text),
      zakatRule: _rule,
      customZakatShare: _shareFraction,
    );
  }

  Future<void> _save() async {
    final today = ref.read(todayProvider);
    final errors = validate(
      _draft(),
      today: today,
      settings: _effectiveSettings,
    ).toSet();
    if (_isEdit) {
      errors.removeAll({
        DraftError.missingFirstPaid,
        DraftError.zeroAmount,
        DraftError.missingStartDate,
        DraftError.futureDate,
        DraftError.missingGrams,
      });
    }
    if (_customShare && _type != null && _type != AssetType.cashDeposit) {
      final share = _shareFraction;
      if (share == null || share < Decimal.zero || share > Decimal.one) {
        errors.add(DraftError.shareRequired);
      }
    }
    if (_type == null) {
      // Those fields are not shown yet; the type comes first.
      errors.removeAll({
        DraftError.missingUnit,
        DraftError.missingFirstPaid,
        DraftError.shareRequired,
      });
    }
    final rate = parseAmount(_rate.text);
    final needsRate = !_isEdit && _rateMissing;
    if (needsRate && (rate == null || rate <= Decimal.zero)) {
      setState(() {
        _errors = errors;
        _rateError = context.l10n.errRate;
      });
      return;
    }
    if (errors.isNotEmpty) {
      setState(() {
        _errors = errors;
        _rateError = null;
      });
      return;
    }
    setState(() {
      _errors = {};
      _rateError = null;
    });
    try {
      final typed = _showRateRow && rate != null && rate > Decimal.zero
          ? rate
          : null;
      final id = await _persist(rate: typed);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.savedToast)));
      if (_isEdit) {
        Navigator.of(context).pop();
      } else {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ItemDetailScreen(investmentId: id),
          ),
        );
      }
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errSave)));
    }
  }

  Future<String> _persist({Decimal? rate}) async {
    final type = _type!;
    final rule = _rule!;
    final settings = ref.read(settingsActionsProvider);
    final answeredHere =
        (_settings.longTermMethod == null && _chosenMethod != null) ||
        (_settings.jewelleryZakatable == null && _chosenJewellery != null);
    if (answeredHere) await settings.saveSettings(_effectiveSettings);
    final draft = _draft();
    final id = _editing?.id ?? newId();
    final item = Investment(
      id: id,
      name: _name.text.trim(),
      type: type,
      intent: _intent,
      market: _market,
      marketCountry: _market == Market.other ? _marketCountry : null,
      unit: _unit!,
      startDate: _editing?.startDate ?? _start!,
      quantity: type == AssetType.gold || type == AssetType.silver
          ? null
          : draft.quantity,
      purityKarat: type == AssetType.gold ? _karat : null,
      purityFineness: type == AssetType.silver ? _fineness : null,
      zakatRule: rule,
      customZakatShare: rule == ZakatRule.custom ? _shareFraction : null,
      inflationOverride: _inflation,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      createdAt: _editing?.createdAt,
    );
    final repo = ref.read(investmentsRepositoryProvider);
    if (_isEdit) {
      await repo.update(item);
      return id;
    }
    if (rate != null) {
      final paidUnit = _paidUnit!;
      await ref
          .read(assumptionsRepositoryProvider)
          .saveTypedRate(
            Rate(
              from: _unit!.isMetal ? _unit! : paidUnit,
              to: _unit!.isMetal ? paidUnit : _unit!,
              rate: rate,
              asOf: _start!,
            ),
          );
    }
    final entries = <HistoryEntry>[
      MoneyIn(investmentId: id, date: _start!, amount: draft.firstPaid!),
      if (_unit!.isMetal)
        ValueUpdate(investmentId: id, date: _start!, value: draft.currentValue!)
      else if (draft.currentValue != null)
        ValueUpdate(
          investmentId: id,
          date: _valueDate ?? _start!,
          value: draft.currentValue!,
        ),
    ];
    await repo.create(item, entries);
    return id;
  }

  /// No rate yet for the pair this payment needs on the start date.
  bool _needsRate(RateBook? book) {
    final start = _start;
    final paid = _paidUnit;
    final unit = _unit;
    if (_isEdit ||
        book == null ||
        start == null ||
        paid == null ||
        unit == null ||
        paid == unit) {
      return false;
    }
    final from = unit.isMetal ? unit : paid;
    final to = unit.isMetal ? paid : unit;
    return book.quote(from, to, start) == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final today = ref.watch(todayProvider);
    if (_isEdit && _editing == null) {
      final items = ref.watch(investmentsProvider).value;
      if (items == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      _loadEdit(
        items.firstWhere((h) => h.investment.id == widget.editId).investment,
      );
    }
    _start ??= today;
    _paidUnit ??= _unit?.isMetal == true ? settings.baseCurrency : _unit;
    if (_unit == null && _type != null) _applyTypeDefaults();
    final type = _type;
    final rateKey = '${_paidUnit?.code}>${_unit?.code}@$_start';
    if (rateKey != _rateKey) {
      _rateKey = rateKey;
      _showRateRow = false;
      _fetchAsked = false;
    }
    _rateMissing = _needsRate(ref.watch(rateBookProvider).value);
    // The row stays once shown, so a successful fetch does not make it vanish.
    if (_rateMissing) _showRateRow = true;
    String? err(Set<DraftError> any, String text) =>
        _errors.any(any.contains) ? text : null;
    final isMetal = type == AssetType.gold || type == AssetType.silver;
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l10n.discardTitle),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(l10n.keepEditing),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(l10n.discard),
              ),
            ],
          ),
        );
        if (discard == true && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? l10n.formTitleEdit : l10n.formTitleAdd),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_errors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.errSummary('${_errors.length}'),
                  key: const ValueKey('error-summary'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Wrap(
              spacing: 8,
              children: [
                for (final t in AssetType.values)
                  ChoiceChip(
                    label: Text(context.assetTypeName(t)),
                    selected: _type == t,
                    onSelected: _isEdit
                        ? null
                        : (_) => _touch(() {
                            _type = t;
                            _applyTypeDefaults();
                          }),
                  ),
              ],
            ),
            if (_errors.contains(DraftError.missingType))
              Text(
                l10n.errType,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: l10n.fieldName,
                errorText: err({DraftError.missingName}, l10n.errName),
              ),
              onChanged: (_) => _dirty = true,
            ),
            if (type == AssetType.stock ||
                type == AssetType.fund ||
                type == AssetType.sukuk)
              ..._marketFields(context, type!),
            if (type != null && !isMetal) _unitField(context),
            if (!_isEdit)
              DateField(
                label: l10n.fieldStartDate,
                value: _start!,
                lastDate: today,
                error: err({
                  DraftError.missingStartDate,
                  DraftError.futureDate,
                }, l10n.errFuture),
                onChanged: (d) => _touch(() => _start = d),
              ),
            if (!_isEdit && type != null)
              ..._moneyFields(context, type, isMetal),
            if (type != null && !isMetal)
              AmountField(
                controller: _quantity,
                label: l10n.fieldQuantity,
                onChanged: (_) => _dirty = true,
              ),
            if (type != null) ..._intentFields(context, type),
            if (type != null) ..._zakatFields(context, type),
            _moreSection(context),
            const SizedBox(height: 16),
            FilledButton(
              key: const ValueKey('save'),
              onPressed: _save,
              child: Text(l10n.save),
            ),
            if (_isEdit)
              TextButton(
                onPressed: _delete,
                child: Text(l10n.deleteInvestment),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final items = await ref.read(investmentsProvider.future);
    final aggregate = items.firstWhere((h) => h.investment.id == widget.editId);
    final repo = ref.read(investmentsRepositoryProvider);
    await repo.delete(widget.editId!);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((r) => r.isFirst);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.deleted),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => repo.restore(aggregate),
        ),
      ),
    );
  }

  List<Widget> _marketFields(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    return [
      DropdownButtonFormField<Market>(
        key: const ValueKey('market'),
        initialValue: _market,
        decoration: InputDecoration(
          labelText: l10n.fieldMarket,
          errorText: _errors.contains(DraftError.missingMarket)
              ? l10n.errMarket
              : null,
        ),
        items: [
          for (final m in Market.values)
            DropdownMenuItem(value: m, child: Text(context.marketName(m))),
        ],
        onChanged: (m) => _touch(() {
          _market = m;
          if (m != null && m != Market.other && !_isEdit) {
            _unit = m.currency;
            _paidUnit = m.currency;
          }
        }),
      ),
      if (_market == Market.other)
        DropdownButtonFormField<Country>(
          initialValue: _marketCountry,
          decoration: InputDecoration(
            labelText: l10n.fieldMarketCountry,
            errorText: _errors.contains(DraftError.missingMarketCountry)
                ? l10n.errMarketCountry
                : null,
          ),
          items: [
            for (final c in v1Countries)
              DropdownMenuItem(value: c, child: Text(context.countryName(c))),
          ],
          onChanged: (c) => _touch(() => _marketCountry = c),
        ),
    ];
  }

  Widget _unitField(BuildContext context) {
    final l10n = context.l10n;
    final base = _base ?? const Unit('USD');
    return InkWell(
      onTap: _isEdit
          ? null
          : () async {
              final u = await showUnitPicker(
                context,
                anchor: base,
                selected: _unit,
              );
              if (u != null) {
                _touch(() {
                  _unit = u;
                  _paidUnit = u;
                });
              }
            },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldUnit,
          errorText: _errors.contains(DraftError.missingUnit)
              ? l10n.errUnit
              : null,
        ),
        child: Text(
          _unit == null ? '' : '${_unit!.code} · ${context.unitName(_unit!)}',
        ),
      ),
    );
  }

  List<Widget> _moneyFields(
    BuildContext context,
    AssetType type,
    bool isMetal,
  ) {
    final l10n = context.l10n;
    final base = _base ?? const Unit('USD');
    final paid = parseAmount(_paid.text);
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AmountField(
              key: const ValueKey('paid'),
              controller: _paid,
              label: l10n.fieldPaid,
              error: _errors.contains(DraftError.zeroAmount)
                  ? l10n.errZero
                  : _errors.contains(DraftError.missingFirstPaid)
                  ? l10n.errFirstPaid
                  : null,
              onChanged: (_) => _touch(() {}),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () async {
              final u = await showUnitPicker(
                context,
                anchor: base,
                selected: _paidUnit,
              );
              if (u != null) _touch(() => _paidUnit = u);
            },
            child: Text(_paidUnit?.code ?? ''),
          ),
        ],
      ),
      if (_showRateRow && paid != null) _inlineRate(context, isMetal),
      if (isMetal) ...[
        AmountField(
          key: const ValueKey('grams'),
          controller: _grams,
          label: l10n.fieldGrams,
          error: _errors.contains(DraftError.missingGrams)
              ? l10n.errGrams
              : null,
          onChanged: (_) => _touch(() {}),
        ),
        Wrap(
          spacing: 8,
          children: [
            if (type == AssetType.gold)
              for (final k in [24, 22, 21, 18])
                ChoiceChip(
                  label: Text(l10n.karat('$k')),
                  selected: _karat == k,
                  onSelected: (_) => _touch(() => _karat = k),
                )
            else
              for (final k in [999, 925])
                ChoiceChip(
                  label: Text(l10n.fineness('$k')),
                  selected: _fineness == k,
                  onSelected: (_) => _touch(() => _fineness = k),
                ),
          ],
        ),
        if (_errors.contains(DraftError.missingPurity))
          Text(
            l10n.errPurity,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        _pureGramsPreview(context, type),
      ] else ...[
        AmountField(
          key: const ValueKey('current-value'),
          controller: _value,
          label: l10n.fieldCurrentValue,
          onChanged: (_) => _dirty = true,
        ),
        if (_value.text.trim().isNotEmpty)
          DateField(
            label: l10n.fieldValueDate,
            value: _valueDate ?? _start!,
            lastDate: ref.read(todayProvider),
            onChanged: (d) => _touch(() => _valueDate = d),
          ),
      ],
    ];
  }

  Widget _pureGramsPreview(BuildContext context, AssetType type) {
    final gross = parseAmount(_grams.text);
    final purity = type == AssetType.gold ? _karat : _fineness;
    if (gross == null || purity == null) return const SizedBox.shrink();
    final pure = pureGrams(
      type: type,
      gross: gross,
      karat: _karat,
      fineness: _fineness,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(context.l10n.pureGramsPreview(context.grams(pure))),
    );
  }

  Widget _inlineRate(BuildContext context, bool isMetal) {
    final l10n = context.l10n;
    final from = isMetal ? _unit! : _paidUnit!;
    final to = isMetal ? _paidUnit! : _unit!;
    final today = ref.read(todayProvider);
    final paid = parseAmount(_paid.text);
    final rate = parseAmount(_rate.text);
    final refresh = ref.watch(refreshControllerProvider);
    final quote = ref.watch(rateBookProvider).value?.quote(from, to, _start!);
    final result = paid == null || rate == null || rate <= Decimal.zero
        ? null
        : isMetal
        ? context.grams(divide(paid, rate))
        : context.money(paid * rate, to);
    final status = !_fetchAsked
        ? null
        : switch (refresh) {
            RefreshDone(result: RefreshFailed()) => l10n.fetchFailed,
            RefreshDone(result: RefreshSucceeded(:final notCovered))
                when notCovered.contains((from, to)) =>
              l10n.fetchNotCovered(from.code, to.code),
            _ => null,
          };
    final fetched = quote != null && quote.source == RateSource.currencyApi
        ? l10n.fetchedRateLine(
            from.code,
            context.amount(quote.rate, digits: 4),
            to.code,
            context.date(quote.asOf),
            l10n.refreshSource,
          )
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.inlineRateLabel(from.code, to.code, context.date(_start!))),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AmountField(
                key: const ValueKey('inline-rate'),
                controller: _rate,
                label: l10n.inlineRateField,
                error: _rateError,
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_start == today)
              refresh is RefreshRunning
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          key: ValueKey('fetch-progress'),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : TextButton(
                      key: const ValueKey('fetch-rate'),
                      onPressed: () {
                        setState(() => _fetchAsked = true);
                        ref.read(refreshControllerProvider.notifier).refresh({
                          (from, to),
                        });
                      },
                      child: Text(l10n.fetchRate),
                    ),
          ],
        ),
        if (status != null) Text(status, key: const ValueKey('fetch-status')),
        if (fetched != null) Text(fetched, key: const ValueKey('fetched-rate')),
        if (result != null)
          Text(isMetal ? l10n.pureGramsPreview(result) : '= $result'),
      ],
    );
  }

  /// Notes and the inflation series of this item (story §5, AC-31).
  Widget _moreSection(BuildContext context) {
    final l10n = context.l10n;
    return ExpansionTile(
      key: const ValueKey('more'),
      title: Text(l10n.moreSection),
      tilePadding: EdgeInsets.zero,
      children: [
        DropdownButtonFormField<Country?>(
          key: const ValueKey('inflation-series'),
          initialValue: _inflation,
          decoration: InputDecoration(labelText: l10n.inflationSeriesField),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(l10n.inflationSeriesDefault),
            ),
            for (final c in v1Countries)
              DropdownMenuItem(value: c, child: Text(context.countryName(c))),
          ],
          onChanged: (c) => _touch(() => _inflation = c),
        ),
        TextField(
          controller: _notes,
          decoration: InputDecoration(labelText: l10n.fieldNotes),
          onChanged: (_) => _dirty = true,
        ),
      ],
    );
  }

  List<Widget> _intentFields(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    final options = switch (type) {
      AssetType.stock || AssetType.fund => [Intent.trading, Intent.longTerm],
      AssetType.gold ||
      AssetType.silver => [Intent.longTerm, Intent.personalUse],
      AssetType.other => Intent.values,
      _ => const <Intent>[],
    };
    if (options.isEmpty) return const [];
    return [
      const SizedBox(height: 12),
      Text(l10n.fieldIntent, style: Theme.of(context).textTheme.labelLarge),
      Wrap(
        spacing: 8,
        children: [
          for (final i in options)
            ChoiceChip(
              label: Text(context.intentName(i)),
              selected: _intent == i,
              onSelected: (_) => _touch(() {
                _intent = i;
              }),
            ),
        ],
      ),
      if (_errors.contains(DraftError.missingIntent))
        Text(
          l10n.errIntent,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
    ];
  }

  List<Widget> _zakatFields(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final widgets = <Widget>[const Divider()];
    final stockLike = type == AssetType.stock || type == AssetType.fund;
    final method = _settings.longTermMethod;
    final needsMethod =
        stockLike &&
        _intent == Intent.longTerm &&
        !_companyPays &&
        (method == null || method == LongTermMethod.perItem);
    if (type == AssetType.stock) {
      widgets.add(
        SwitchListTile(
          title: Text(l10n.companyPays),
          value: _companyPays,
          onChanged: (v) => _touch(() => _companyPays = v),
        ),
      );
    }
    if (needsMethod) {
      widgets.add(_methodChoice(context));
    }
    final needsJewellery =
        (type == AssetType.gold || type == AssetType.silver) &&
        _intent == Intent.personalUse &&
        _effectiveSettings.jewelleryZakatable == null;
    if (needsJewellery) widgets.add(_jewelleryChoice(context));
    if (type == AssetType.other) {
      widgets.addAll(_otherShare(context));
    } else if (type != AssetType.cashDeposit) {
      widgets.addAll(_customShareFields(context, type));
    }

    final resolved = _resolvedForDisplay(type);
    widgets.add(
      Text(
        key: const ValueKey('zakat-line'),
        resolved.$1,
        style: theme.textTheme.titleSmall,
      ),
    );
    for (final line in resolved.$2) {
      widgets.add(Text(line, style: theme.textTheme.bodySmall));
    }
    if (_errors.contains(DraftError.answerLongTermMethod)) {
      widgets.add(
        Text(
          l10n.errLongTerm,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      );
    }
    if (_errors.contains(DraftError.answerJewellery)) {
      widgets.add(
        Text(
          l10n.errJewellery,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      );
    }
    if (_errors.contains(DraftError.shareRequired) &&
        type != AssetType.other &&
        !needsMethod) {
      widgets.add(
        Text(l10n.errShare, style: TextStyle(color: theme.colorScheme.error)),
      );
    }
    widgets.add(
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          onPressed: () => showWhy(context, _whyFor(context, type)),
          child: Text(l10n.source),
        ),
      ),
    );
    return widgets;
  }

  (String, List<String>) _resolvedForDisplay(AssetType type) {
    final l10n = context.l10n;
    final rule = _rule;
    if (rule == null) return (l10n.zakatNeedsChoice, const []);
    if (rule == ZakatRule.custom) {
      final share = _shareFraction;
      return (
        share == null
            ? l10n.zakatNeedsChoice
            : l10n.zakatLinePercent(context.percent(share).replaceAll('+', '')),
        [l10n.zakatReasonCustom],
      );
    }
    if (rule == ZakatRule.longTermPerSetting &&
        _effectiveSettings.longTermMethod == null) {
      return (l10n.zakatNeedsChoice, const []);
    }
    if (rule == ZakatRule.jewelleryPerSetting &&
        _effectiveSettings.jewelleryZakatable == null) {
      return (l10n.zakatNeedsChoice, const []);
    }
    final probe = Investment(
      name: '',
      type: type,
      unit: const Unit('USD'),
      startDate: DateTime.utc(2000),
      zakatRule: rule,
    );
    final r = resolve(probe, _effectiveSettings);
    final notice = switch (r.notice) {
      ZakatNotice.dividendsCountedWithCash => l10n.noticeDividends,
      ZakatNotice.cryptoDisputed => l10n.noticeCrypto,
      null => null,
    };
    final reason = switch (rule) {
      ZakatRule.trading100 => l10n.zakatReasonTrading,
      ZakatRule.cash100 => l10n.zakatReasonCash,
      ZakatRule.bullion100 => l10n.zakatReasonSavings,
      ZakatRule.jewelleryPerSetting => l10n.zakatReasonJewellery,
      ZakatRule.sukuk100 => l10n.zakatReasonSukuk,
      _ => null,
    };
    final head = r.onDividends
        ? l10n.zakatLineDividends
        : rule == ZakatRule.companyPaysZakat
        ? l10n.zakatLineCompany
        : l10n.zakatLinePercent(context.percent(r.share).replaceAll('+', ''));
    return (head, [?reason, ?notice]);
  }

  Why _whyFor(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    final section = switch (type) {
      AssetType.cashDeposit => 'B1',
      AssetType.gold || AssetType.silver => 'B2',
      AssetType.stock || AssetType.fund => 'B3',
      AssetType.sukuk => 'B4',
      AssetType.crypto => 'B8',
      AssetType.other => 'B5',
    };
    return Why(
      title: l10n.fieldShare,
      what: _resolvedForDisplay(type).$1,
      source: zakatSource(l10n, section, type: type),
    );
  }

  /// The first answer also becomes the portfolio setting (AC-8); with
  /// "decide per item" it only applies to this item.
  Widget _methodChoice(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (LongTermMethod.dividendsOnly, l10n.longTermDividendsOnly),
      (LongTermMethod.proxy25, l10n.longTermProxy25),
      (LongTermMethod.fullValue, l10n.longTermFullValue),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.longTermTitle, style: Theme.of(context).textTheme.titleSmall),
        Text(l10n.longTermWhy, style: Theme.of(context).textTheme.bodySmall),
        RadioGroup<LongTermMethod>(
          groupValue: _chosenMethod,
          onChanged: (v) => _touch(() => _chosenMethod = v),
          child: Column(
            children: [
              for (final o in options)
                RadioListTile<LongTermMethod>(
                  key: ValueKey('method-${o.$1.name}'),
                  value: o.$1,
                  title: Text(o.$2),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _jewelleryChoice(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.jewelleryAsk, style: Theme.of(context).textTheme.titleSmall),
        Text(l10n.jewelleryWhy, style: Theme.of(context).textTheme.bodySmall),
        RadioGroup<bool>(
          groupValue: _chosenJewellery,
          onChanged: (v) => _touch(() => _chosenJewellery = v),
          child: Column(
            children: [
              RadioListTile<bool>(
                key: const ValueKey('jewellery-yes'),
                value: true,
                title: Text(l10n.jewelleryYes),
              ),
              RadioListTile<bool>(
                key: const ValueKey('jewellery-no'),
                value: false,
                title: Text(l10n.jewelleryNo),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Every type except a cash deposit may override its share (story §5).
  List<Widget> _customShareFields(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    final defaultRule0 = defaultRule(type, _intent, _effectiveSettings);
    String? was;
    final unanswered =
        (defaultRule0 == ZakatRule.longTermPerSetting &&
            _effectiveSettings.longTermMethod == null) ||
        (defaultRule0 == ZakatRule.jewelleryPerSetting &&
            _effectiveSettings.jewelleryZakatable == null);
    if (defaultRule0 != null && !unanswered) {
      final probe = Investment(
        name: '',
        type: type,
        unit: const Unit('USD'),
        startDate: DateTime.utc(2000),
        zakatRule: defaultRule0,
      );
      was = context
          .percent(resolve(probe, _effectiveSettings).share)
          .replaceAll('+', '');
    }
    return [
      SwitchListTile(
        key: const ValueKey('custom-share'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.customShareSwitch),
        value: _customShare,
        onChanged: (v) => _touch(() => _customShare = v),
      ),
      if (_customShare) ...[
        AmountField(
          key: const ValueKey('share'),
          controller: _share,
          label: l10n.fieldShare,
          error: _errors.contains(DraftError.shareRequired)
              ? l10n.errShare
              : null,
          onChanged: (_) => _touch(() {}),
        ),
        if (was != null)
          Text(
            l10n.zakatChangedFrom(was),
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    ];
  }

  List<Widget> _otherShare(BuildContext context) {
    final l10n = context.l10n;
    final hint = switch (_intent) {
      Intent.longTerm => l10n.hintLongTerm,
      Intent.rental => l10n.hintRental,
      Intent.personalUse => l10n.hintPersonalUse,
      Intent.trading => l10n.hintTrading,
      null => null,
    };
    final offer = offeredShare(AssetType.other, _intent);
    return [
      AmountField(
        key: const ValueKey('share'),
        controller: _share,
        label: l10n.fieldShare,
        error: _errors.contains(DraftError.shareRequired)
            ? l10n.errShare
            : null,
        onChanged: (_) => _touch(() {}),
      ),
      ?hint == null
          ? null
          : Text(hint, style: Theme.of(context).textTheme.bodySmall),
      if (offer != null)
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: ActionChip(
            key: const ValueKey('use-offered-share'),
            label: Text(
              l10n.useShare(
                (offer.share * Decimal.fromInt(100)).round().toString(),
              ),
            ),
            // The user's tap applies the offer; it is never filled silently (AC-7).
            onPressed: () => _touch(
              () => _share.text = (offer.share * Decimal.fromInt(100))
                  .round()
                  .toString(),
            ),
          ),
        ),
    ];
  }
}
