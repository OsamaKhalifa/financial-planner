/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart' hide Flow, Intent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assumptions/assumptions_providers.dart';
import '../../../core/assumptions/data/rate_refresher.dart';
import '../../../core/assumptions/domain/rate.dart';
import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/dates.dart';
import '../../../core/ids.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/markets.dart';
import '../../../core/reference/units.dart';
import '../domain/formulas.dart';
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
  final _profit = TextEditingController();
  final _growth = TextEditingController();

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
  Schedule? _payoutSchedule;
  Schedule? _valueCheckSchedule;
  ProfitBasis? _profitBasis;
  CapitalBack? _capitalBack;
  AccountKind? _accountKind;

  /// Private equity, long-term: the user's pick of the three P-1 methods.
  ZakatRule? _peMethod;

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
      _profit,
      _growth,
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
    _payoutSchedule = null;
    _valueCheckSchedule = null;
    _profit.clear();
    _growth.clear();
    _profitBasis = null;
    _capitalBack = null;
    _accountKind = null;
    _peMethod = null;
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
    _payoutSchedule = i.payoutSchedule;
    _valueCheckSchedule = i.valueCheckSchedule;
    _profit.text = _pctText(i.expectedProfit);
    _growth.text = _pctText(i.expectedGrowth);
    _profitBasis = i.profitBasis;
    _capitalBack = i.capitalBack;
    _accountKind = i.accountKind;
    if (i.type == AssetType.privateEquity) {
      _customShare = false;
      // A case C item stores a placeholder rule (resolve ignores it), so it
      // is not shown as the user's pick.
      _peMethod = i.peCase == PeCase.c || i.intent != Intent.longTerm
          ? null
          : i.zakatRule;
    }
  }

  String _pctText(Decimal? fraction) =>
      fraction == null ? '' : (fraction * Decimal.fromInt(100)).toString();

  Decimal? _pct(TextEditingController c) {
    final p = parseAmount(c.text);
    return p == null ? null : divide(p, Decimal.fromInt(100));
  }

  bool get _payoutAllowed => _type != null && payoutPlanAllowed(_type!);

  bool get _valueAllowed => _type != null && valuePlanAllowed(_type!);

  Decimal? get _expectedProfit => _payoutAllowed ? _pct(_profit) : null;

  Decimal? get _expectedGrowth => _valueAllowed ? _pct(_growth) : null;

  Schedule? get _payout => _payoutAllowed ? _payoutSchedule : null;

  Schedule? get _valueCheck => _valueAllowed ? _valueCheckSchedule : null;

  bool get _isPe => _type == AssetType.privateEquity;

  /// Q1 is cleared with the %; the account kind with the payout schedule.
  ProfitBasis? get _q1 =>
      _isPe && _expectedProfit != null ? _profitBasis : null;

  CapitalBack? get _q2 => _isPe ? _capitalBack : null;

  AccountKind? get _account =>
      _type == AssetType.cashDeposit && _payout != null ? _accountKind : null;

  /// What would be stored, for the case, the notices and the zakat line.
  Investment _probe(AssetType type, ZakatRule rule) => Investment(
    name: '',
    type: type,
    intent: _intent,
    unit: const Unit('USD'),
    startDate: DateTime.utc(2000),
    zakatRule: rule,
    customZakatShare: rule == ZakatRule.custom ? _shareFraction : null,
    payoutSchedule: _payout,
    expectedProfit: _expectedProfit,
    profitBasis: _q1,
    capitalBack: _q2,
    accountKind: _account,
  );

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
    if (type == AssetType.privateEquity) return _peRule;
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

  /// Case C stores full value as a placeholder: resolve fixes it at 100 %
  /// whatever is stored (spec E6), and the edit form asks again if Q2 changes.
  ZakatRule? get _peRule {
    if (_capitalBack == CapitalBack.yes) {
      return _intent == Intent.trading
          ? ZakatRule.trading100
          : ZakatRule.longTermFullValue;
    }
    if (_intent == Intent.trading) return ZakatRule.trading100;
    if (_intent != Intent.longTerm) return null;
    if (_peMethod == ZakatRule.custom && _share.text.trim().isEmpty) {
      return null;
    }
    return _peMethod;
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
      payoutSchedule: _payout,
      expectedProfit: _expectedProfit,
      valueCheckSchedule: _valueCheck,
      expectedGrowth: _expectedGrowth,
      profitBasis: _q1,
      capitalBack: _q2,
      accountKind: _account,
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
      payoutSchedule: _payout,
      expectedProfit: _expectedProfit,
      valueCheckSchedule: _valueCheck,
      expectedGrowth: _expectedGrowth,
      profitBasis: _q1,
      capitalBack: _q2,
      accountKind: _account,
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
            if (type == AssetType.privateEquity)
              Text(
                l10n.typePrivateEquityHint,
                style: Theme.of(context).textTheme.bodySmall,
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
                label: _isPe ? l10n.fieldSharesInProject : l10n.fieldQuantity,
                onChanged: (_) => _dirty = true,
              ),
            if (type != null) ..._intentFields(context, type),
            if (_isPe) ..._capitalBackFields(context),
            if (type != null) ..._zakatFields(context, type),
            if (type != null && (_payoutAllowed || _valueAllowed))
              _expectedSection(context, type),
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
      AssetType.privateEquity => [Intent.trading, Intent.longTerm],
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
              label: Text(
                !_isPe
                    ? context.intentName(i)
                    : i == Intent.trading
                    ? l10n.peIntentTrading
                    : l10n.peIntentLongTerm,
              ),
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
    } else if (type == AssetType.privateEquity) {
      widgets.addAll(_peMethodFields(context));
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
        Text(
          type == AssetType.privateEquity ? l10n.peMethodPick : l10n.errShare,
          style: TextStyle(color: theme.colorScheme.error),
        ),
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
    if (rule == ZakatRule.custom && type != AssetType.privateEquity) {
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
    final r = resolve(_probe(type, rule), _effectiveSettings);
    final notice = switch (r.notice) {
      ZakatNotice.dividendsCountedWithCash => l10n.noticeDividends,
      ZakatNotice.cryptoDisputed => l10n.noticeCrypto,
      ZakatNotice.profitPayoutsOnly => l10n.noticeProfitPayoutsOnly(
        context.percent(_effectiveSettings.zakatYear!.r).replaceAll('+', ''),
      ),
      ZakatNotice.capitalBackIsDebt => l10n.noticeCapitalBackIsDebt,
      null => null,
    };
    final reason = switch (rule) {
      _ when r.notice == ZakatNotice.capitalBackIsDebt => null,
      ZakatRule.trading100 when type == AssetType.privateEquity =>
        l10n.zakatPeTrading,
      ZakatRule.longTermFullValue when type == AssetType.privateEquity =>
        l10n.peMethodFullNote,
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
      AssetType.privateEquity => 'B6',
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

  Widget _errorText(BuildContext context, String text) =>
      Text(text, style: TextStyle(color: Theme.of(context).colorScheme.error));

  Widget _radios<T>(
    String keyPrefix,
    T? group,
    ValueChanged<T?> onChanged,
    List<(T, String)> options,
  ) => RadioGroup<T>(
    groupValue: group,
    onChanged: (v) => _touch(() => onChanged(v)),
    child: Column(
      children: [
        for (final o in options)
          RadioListTile<T>(
            key: ValueKey('$keyPrefix-${o.$1}'),
            contentPadding: EdgeInsets.zero,
            value: o.$1,
            title: Text(o.$2),
          ),
      ],
    ),
  );

  /// Q2 on every private-equity item, right after the intent: it can change
  /// the zakat share (case C, P-2 loop 1).
  List<Widget> _capitalBackFields(BuildContext context) {
    final l10n = context.l10n;
    return [
      const SizedBox(height: 12),
      Text(l10n.q2CapitalBack, style: Theme.of(context).textTheme.titleSmall),
      _radios<CapitalBack>('q2', _capitalBack, (v) => _capitalBack = v, [
        (CapitalBack.no, l10n.answerNo),
        (CapitalBack.yes, l10n.answerYes),
        (CapitalBack.notSure, l10n.answerNotSure),
      ]),
      if (_errors.contains(DraftError.answerCapitalBack))
        _errorText(context, l10n.errPickOne),
      if (_editing != null && _editing!.capitalBack != _q2)
        Text(l10n.editRecalculates, key: const ValueKey('q2-recalculates')),
      if (_expectedProfit == null) ?_peNotice(context),
    ];
  }

  /// One notice from the case, with a Source link (P-2 table, AC-64).
  Widget? _peNotice(BuildContext context) {
    final l10n = context.l10n;
    final c = _probe(AssetType.privateEquity, ZakatRule.trading100).peCase;
    final why = whyCase(context, c);
    if (why == null) return null;
    return Card(
      key: const ValueKey('pe-notice'),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(why.what)),
              ],
            ),
            if (c == PeCase.b)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(l10n.caseBTagPreview),
              ),
            TextButton(
              onPressed: () => showWhy(context, why),
              child: Text(l10n.source),
            ),
          ],
        ),
      ),
    );
  }

  /// P-1: long-term asks one of three methods, nothing pre-selected, no 25 %.
  List<Widget> _peMethodFields(BuildContext context) {
    final l10n = context.l10n;
    if (_intent != Intent.longTerm || _capitalBack == CapitalBack.yes) {
      return const [];
    }
    return [
      _radios<ZakatRule>('pe-method', _peMethod, (v) => _peMethod = v, [
        (ZakatRule.custom, l10n.peMethodKnown),
        (ZakatRule.longTermDividendsOnly, l10n.peMethodProfit),
        (ZakatRule.longTermFullValue, l10n.peMethodFull),
      ]),
      if (_peMethod == ZakatRule.custom) ...[
        AmountField(
          key: const ValueKey('share'),
          controller: _share,
          label: l10n.fieldShare,
          onChanged: (_) => _touch(() {}),
        ),
        Text(
          l10n.peMethodKnownSource,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
      Text(l10n.peMethodsHelp, style: Theme.of(context).textTheme.bodySmall),
    ];
  }

  Widget _scheduleChips(
    String keyPrefix,
    Schedule? selected,
    ValueChanged<Schedule?> onSelected,
  ) {
    final l10n = context.l10n;
    final options = <(Schedule?, String)>[
      (null, l10n.scheduleNone),
      (Schedule.monthly, l10n.scheduleMonthly),
      (Schedule.quarterly, l10n.scheduleQuarterly),
      (Schedule.halfYearly, l10n.scheduleHalfYearly),
      (Schedule.yearly, l10n.scheduleYearly),
    ];
    return Wrap(
      spacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            key: ValueKey('$keyPrefix-${o.$1?.name ?? 'none'}'),
            label: Text(o.$2),
            selected: selected == o.$1,
            onSelected: (_) => _touch(() => onSelected(o.$1)),
          ),
      ],
    );
  }

  /// The money in on the start date, in the item unit; null while a rate is
  /// missing (the inline rate entry asks for it).
  Decimal? _startCapital() {
    if (_isEdit) {
      final calc = ref.read(calculatorProvider).value;
      if (calc == null || !calc.hasItem(widget.editId!)) return null;
      final tl = calc.timeline(widget.editId!);
      return sumOf([
        for (final f in tl.flowsIn(
          _start!.subtract(const Duration(days: 1)),
          _start!,
        ))
          f.amount,
      ]);
    }
    final paid = parseAmount(_paid.text);
    if (paid == null || _paidUnit == null || _unit == null) return null;
    if (_paidUnit == _unit) return paid;
    final rate = parseAmount(_rate.text);
    if (_showRateRow) return rate == null ? null : paid * rate;
    return ref
        .read(rateBookProvider)
        .value
        ?.convert(Money(paid, _paidUnit!), _unit!, _start!)
        ?.amount;
  }

  Widget _expectedSection(BuildContext context, AssetType type) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final edited = _editing;
    final hasPlan =
        edited != null &&
        (edited.payoutSchedule != null || edited.valueCheckSchedule != null);
    final capital = _startCapital();
    final unit = _unit;
    final help = Text(l10n.estimateHelp, style: theme.textTheme.bodySmall);
    final profit = _expectedProfit;
    final growth = _expectedGrowth;
    String? preview;
    if (profit != null && _payout != null && unit != null) {
      final m = _payout!.months;
      preview = capital == null
          ? null
          : l10n.payoutPreview(
              context.money(
                expectedPayout(capital: capital, rate: profit, months: m),
                unit,
              ),
              m,
              context.date(addMonths(_start!, m)),
            );
    }
    String? growthLine;
    if (growth != null && unit != null && capital != null) {
      final on = addMonths(_start!, 12);
      growthLine = l10n.growthPreview(
        context.date(on),
        context.money(
          expectedValue(
            flows: [Flow(date: _start!, amount: capital)],
            growth: growth,
            on: on,
          ),
          unit,
        ),
      );
    }
    final missingRate =
        capital == null &&
        !_isEdit &&
        _paidUnit != null &&
        unit != null &&
        (profit != null || growth != null);
    final planChanged =
        edited != null &&
        (edited.payoutSchedule != _payout ||
            edited.expectedProfit != profit ||
            edited.valueCheckSchedule != _valueCheck ||
            edited.expectedGrowth != growth);
    final answersChanged =
        edited != null &&
        (edited.profitBasis != _q1 || edited.capitalBack != _q2);
    return ExpansionTile(
      key: const ValueKey('expected'),
      title: Text(l10n.expectedTitle),
      subtitle: Text(l10n.expectedSubtitle),
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: type == AssetType.privateEquity || hasPlan,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_payoutAllowed) ...[
          Text(l10n.blockPayouts, style: theme.textTheme.titleSmall),
          Text(l10n.fieldPayoutSchedule, style: theme.textTheme.labelLarge),
          _scheduleChips('payout', _payoutSchedule, (v) {
            _payoutSchedule = v;
          }),
          AmountField(
            key: const ValueKey('expected-profit'),
            controller: _profit,
            label: l10n.fieldExpectedProfit,
            suffix: '%',
            error: _errors.contains(DraftError.profitNeedsSchedule)
                ? l10n.errPickPayoutSchedule
                : _errors.contains(DraftError.profitNotPositive)
                ? l10n.errProfitPositive
                : null,
            onChanged: (_) => _touch(() {}),
          ),
          help,
          if (preview != null)
            Text(preview, key: const ValueKey('payout-preview')),
          if (type == AssetType.cashDeposit && _payout != null)
            ..._accountKindFields(context),
          if (_isPe && profit != null) ...[
            Text(l10n.q1ProfitBasis, style: theme.textTheme.titleSmall),
            _radios<ProfitBasis>('q1', _profitBasis, (v) => _profitBasis = v, [
              (ProfitBasis.shareOfProfit, l10n.q1Share),
              (ProfitBasis.fixedPctOfMoney, l10n.q1Fixed),
              (ProfitBasis.notSure, l10n.answerNotSure),
            ]),
            if (_errors.contains(DraftError.answerProfitBasis))
              _errorText(context, l10n.errPickOne),
            ?_peNotice(context),
          ],
        ],
        if (_valueAllowed) ...[
          const SizedBox(height: 12),
          Text(l10n.blockValueChecks, style: theme.textTheme.titleSmall),
          Text(l10n.fieldValueCheckSchedule, style: theme.textTheme.labelLarge),
          _scheduleChips('value', _valueCheckSchedule, (v) {
            _valueCheckSchedule = v;
          }),
          AmountField(
            key: const ValueKey('expected-growth'),
            controller: _growth,
            label: l10n.fieldExpectedGrowth,
            suffix: '%',
            error: _errors.contains(DraftError.growthNeedsSchedule)
                ? l10n.errPickValueSchedule
                : _errors.contains(DraftError.growthTooLow)
                ? l10n.errGrowthTooLow
                : null,
            onChanged: (_) => _touch(() {}),
          ),
          help,
          if (growthLine != null)
            Text(growthLine, key: const ValueKey('growth-preview')),
        ],
        if (missingRate)
          Text(
            l10n.needsRateForEstimates(
              context.pair(_paidUnit!, unit),
              context.date(_start!),
            ),
          ),
        if (answersChanged) Text(l10n.editRecalculates),
        if (planChanged) Text(l10n.editRowsRebuilt),
      ],
    );
  }

  List<Widget> _accountKindFields(BuildContext context) {
    final l10n = context.l10n;
    return [
      Text(
        l10n.accountKindQuestion,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      Wrap(
        spacing: 8,
        children: [
          for (final k in [
            (AccountKind.islamic, l10n.accountIslamic),
            (AccountKind.conventional, l10n.accountConventional),
          ])
            ChoiceChip(
              key: ValueKey('account-${k.$1.name}'),
              label: Text(k.$2),
              selected: _accountKind == k.$1,
              onSelected: (_) => _touch(() => _accountKind = k.$1),
            ),
        ],
      ),
      if (_errors.contains(DraftError.answerAccountKind))
        _errorText(context, l10n.errPickAccountKind),
      if (_accountKind == AccountKind.conventional) ...[
        Text(
          l10n.noticeConventional,
          key: const ValueKey('conventional-notice'),
        ),
        TextButton(
          onPressed: () => showWhy(
            context,
            Why(
              title: l10n.accountConventional,
              what: l10n.noticeConventional,
              source: l10n.src_Z6,
            ),
          ),
          child: Text(l10n.source),
        ),
      ],
    ];
  }
}
