// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InvestmentsTable extends Investments
    with TableInfo<$InvestmentsTable, InvestmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeMeta = const VerificationMeta(
    'assetType',
  );
  @override
  late final GeneratedColumn<String> assetType = GeneratedColumn<String>(
    'asset_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentMeta = const VerificationMeta('intent');
  @override
  late final GeneratedColumn<String> intent = GeneratedColumn<String>(
    'intent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _marketMeta = const VerificationMeta('market');
  @override
  late final GeneratedColumn<String> market = GeneratedColumn<String>(
    'market',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _marketCountryMeta = const VerificationMeta(
    'marketCountry',
  );
  @override
  late final GeneratedColumn<String> marketCountry = GeneratedColumn<String>(
    'market_country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($InvestmentsTable.$converterstartDate);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> quantity =
      GeneratedColumn<String>(
        'quantity',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($InvestmentsTable.$converterquantityn);
  static const VerificationMeta _purityKaratMeta = const VerificationMeta(
    'purityKarat',
  );
  @override
  late final GeneratedColumn<int> purityKarat = GeneratedColumn<int>(
    'purity_karat',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purityFinenessMeta = const VerificationMeta(
    'purityFineness',
  );
  @override
  late final GeneratedColumn<int> purityFineness = GeneratedColumn<int>(
    'purity_fineness',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zakatRuleMeta = const VerificationMeta(
    'zakatRule',
  );
  @override
  late final GeneratedColumn<String> zakatRule = GeneratedColumn<String>(
    'zakat_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String>
  customZakatShare = GeneratedColumn<String>(
    'custom_zakat_share',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Decimal?>($InvestmentsTable.$convertercustomZakatSharen);
  static const VerificationMeta _inflationOverrideMeta = const VerificationMeta(
    'inflationOverride',
  );
  @override
  late final GeneratedColumn<String> inflationOverride =
      GeneratedColumn<String>(
        'inflation_override',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payoutScheduleMeta = const VerificationMeta(
    'payoutSchedule',
  );
  @override
  late final GeneratedColumn<String> payoutSchedule = GeneratedColumn<String>(
    'payout_schedule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> expectedProfit =
      GeneratedColumn<String>(
        'expected_profit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($InvestmentsTable.$converterexpectedProfitn);
  static const VerificationMeta _valueCheckScheduleMeta =
      const VerificationMeta('valueCheckSchedule');
  @override
  late final GeneratedColumn<String> valueCheckSchedule =
      GeneratedColumn<String>(
        'value_check_schedule',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> expectedGrowth =
      GeneratedColumn<String>(
        'expected_growth',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($InvestmentsTable.$converterexpectedGrowthn);
  static const VerificationMeta _profitBasisMeta = const VerificationMeta(
    'profitBasis',
  );
  @override
  late final GeneratedColumn<String> profitBasis = GeneratedColumn<String>(
    'profit_basis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capitalBackMeta = const VerificationMeta(
    'capitalBack',
  );
  @override
  late final GeneratedColumn<String> capitalBack = GeneratedColumn<String>(
    'capital_back',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountKindMeta = const VerificationMeta(
    'accountKind',
  );
  @override
  late final GeneratedColumn<String> accountKind = GeneratedColumn<String>(
    'account_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    assetType,
    intent,
    market,
    marketCountry,
    unit,
    startDate,
    quantity,
    purityKarat,
    purityFineness,
    zakatRule,
    customZakatShare,
    inflationOverride,
    notes,
    payoutSchedule,
    expectedProfit,
    valueCheckSchedule,
    expectedGrowth,
    profitBasis,
    capitalBack,
    accountKind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investments';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvestmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('asset_type')) {
      context.handle(
        _assetTypeMeta,
        assetType.isAcceptableOrUnknown(data['asset_type']!, _assetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_assetTypeMeta);
    }
    if (data.containsKey('intent')) {
      context.handle(
        _intentMeta,
        intent.isAcceptableOrUnknown(data['intent']!, _intentMeta),
      );
    }
    if (data.containsKey('market')) {
      context.handle(
        _marketMeta,
        market.isAcceptableOrUnknown(data['market']!, _marketMeta),
      );
    }
    if (data.containsKey('market_country')) {
      context.handle(
        _marketCountryMeta,
        marketCountry.isAcceptableOrUnknown(
          data['market_country']!,
          _marketCountryMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('purity_karat')) {
      context.handle(
        _purityKaratMeta,
        purityKarat.isAcceptableOrUnknown(
          data['purity_karat']!,
          _purityKaratMeta,
        ),
      );
    }
    if (data.containsKey('purity_fineness')) {
      context.handle(
        _purityFinenessMeta,
        purityFineness.isAcceptableOrUnknown(
          data['purity_fineness']!,
          _purityFinenessMeta,
        ),
      );
    }
    if (data.containsKey('zakat_rule')) {
      context.handle(
        _zakatRuleMeta,
        zakatRule.isAcceptableOrUnknown(data['zakat_rule']!, _zakatRuleMeta),
      );
    } else if (isInserting) {
      context.missing(_zakatRuleMeta);
    }
    if (data.containsKey('inflation_override')) {
      context.handle(
        _inflationOverrideMeta,
        inflationOverride.isAcceptableOrUnknown(
          data['inflation_override']!,
          _inflationOverrideMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('payout_schedule')) {
      context.handle(
        _payoutScheduleMeta,
        payoutSchedule.isAcceptableOrUnknown(
          data['payout_schedule']!,
          _payoutScheduleMeta,
        ),
      );
    }
    if (data.containsKey('value_check_schedule')) {
      context.handle(
        _valueCheckScheduleMeta,
        valueCheckSchedule.isAcceptableOrUnknown(
          data['value_check_schedule']!,
          _valueCheckScheduleMeta,
        ),
      );
    }
    if (data.containsKey('profit_basis')) {
      context.handle(
        _profitBasisMeta,
        profitBasis.isAcceptableOrUnknown(
          data['profit_basis']!,
          _profitBasisMeta,
        ),
      );
    }
    if (data.containsKey('capital_back')) {
      context.handle(
        _capitalBackMeta,
        capitalBack.isAcceptableOrUnknown(
          data['capital_back']!,
          _capitalBackMeta,
        ),
      );
    }
    if (data.containsKey('account_kind')) {
      context.handle(
        _accountKindMeta,
        accountKind.isAcceptableOrUnknown(
          data['account_kind']!,
          _accountKindMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      assetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type'],
      )!,
      intent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intent'],
      ),
      market: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market'],
      ),
      marketCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market_country'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      startDate: $InvestmentsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      quantity: $InvestmentsTable.$converterquantityn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}quantity'],
        ),
      ),
      purityKarat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purity_karat'],
      ),
      purityFineness: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purity_fineness'],
      ),
      zakatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zakat_rule'],
      )!,
      customZakatShare: $InvestmentsTable.$convertercustomZakatSharen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}custom_zakat_share'],
        ),
      ),
      inflationOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inflation_override'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      payoutSchedule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payout_schedule'],
      ),
      expectedProfit: $InvestmentsTable.$converterexpectedProfitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}expected_profit'],
        ),
      ),
      valueCheckSchedule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_check_schedule'],
      ),
      expectedGrowth: $InvestmentsTable.$converterexpectedGrowthn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}expected_growth'],
        ),
      ),
      profitBasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profit_basis'],
      ),
      capitalBack: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capital_back'],
      ),
      accountKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_kind'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvestmentsTable createAlias(String alias) {
    return $InvestmentsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterstartDate =
      const CalendarDateConverter();
  static TypeConverter<Decimal, String> $converterquantity =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterquantityn =
      NullAwareTypeConverter.wrap($converterquantity);
  static TypeConverter<Decimal, String> $convertercustomZakatShare =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $convertercustomZakatSharen =
      NullAwareTypeConverter.wrap($convertercustomZakatShare);
  static TypeConverter<Decimal, String> $converterexpectedProfit =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterexpectedProfitn =
      NullAwareTypeConverter.wrap($converterexpectedProfit);
  static TypeConverter<Decimal, String> $converterexpectedGrowth =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterexpectedGrowthn =
      NullAwareTypeConverter.wrap($converterexpectedGrowth);
}

class InvestmentRow extends DataClass implements Insertable<InvestmentRow> {
  final String id;
  final String name;
  final String assetType;
  final String? intent;
  final String? market;
  final String? marketCountry;
  final String unit;
  final DateTime startDate;
  final Decimal? quantity;
  final int? purityKarat;
  final int? purityFineness;
  final String zakatRule;
  final Decimal? customZakatShare;
  final String? inflationOverride;
  final String? notes;

  /// v2 (story §5.5, §5.6): the plan and the P-2/P-3 answers, all optional.
  final String? payoutSchedule;
  final Decimal? expectedProfit;
  final String? valueCheckSchedule;
  final Decimal? expectedGrowth;
  final String? profitBasis;
  final String? capitalBack;
  final String? accountKind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InvestmentRow({
    required this.id,
    required this.name,
    required this.assetType,
    this.intent,
    this.market,
    this.marketCountry,
    required this.unit,
    required this.startDate,
    this.quantity,
    this.purityKarat,
    this.purityFineness,
    required this.zakatRule,
    this.customZakatShare,
    this.inflationOverride,
    this.notes,
    this.payoutSchedule,
    this.expectedProfit,
    this.valueCheckSchedule,
    this.expectedGrowth,
    this.profitBasis,
    this.capitalBack,
    this.accountKind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['asset_type'] = Variable<String>(assetType);
    if (!nullToAbsent || intent != null) {
      map['intent'] = Variable<String>(intent);
    }
    if (!nullToAbsent || market != null) {
      map['market'] = Variable<String>(market);
    }
    if (!nullToAbsent || marketCountry != null) {
      map['market_country'] = Variable<String>(marketCountry);
    }
    map['unit'] = Variable<String>(unit);
    {
      map['start_date'] = Variable<String>(
        $InvestmentsTable.$converterstartDate.toSql(startDate),
      );
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<String>(
        $InvestmentsTable.$converterquantityn.toSql(quantity),
      );
    }
    if (!nullToAbsent || purityKarat != null) {
      map['purity_karat'] = Variable<int>(purityKarat);
    }
    if (!nullToAbsent || purityFineness != null) {
      map['purity_fineness'] = Variable<int>(purityFineness);
    }
    map['zakat_rule'] = Variable<String>(zakatRule);
    if (!nullToAbsent || customZakatShare != null) {
      map['custom_zakat_share'] = Variable<String>(
        $InvestmentsTable.$convertercustomZakatSharen.toSql(customZakatShare),
      );
    }
    if (!nullToAbsent || inflationOverride != null) {
      map['inflation_override'] = Variable<String>(inflationOverride);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || payoutSchedule != null) {
      map['payout_schedule'] = Variable<String>(payoutSchedule);
    }
    if (!nullToAbsent || expectedProfit != null) {
      map['expected_profit'] = Variable<String>(
        $InvestmentsTable.$converterexpectedProfitn.toSql(expectedProfit),
      );
    }
    if (!nullToAbsent || valueCheckSchedule != null) {
      map['value_check_schedule'] = Variable<String>(valueCheckSchedule);
    }
    if (!nullToAbsent || expectedGrowth != null) {
      map['expected_growth'] = Variable<String>(
        $InvestmentsTable.$converterexpectedGrowthn.toSql(expectedGrowth),
      );
    }
    if (!nullToAbsent || profitBasis != null) {
      map['profit_basis'] = Variable<String>(profitBasis);
    }
    if (!nullToAbsent || capitalBack != null) {
      map['capital_back'] = Variable<String>(capitalBack);
    }
    if (!nullToAbsent || accountKind != null) {
      map['account_kind'] = Variable<String>(accountKind);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvestmentsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentsCompanion(
      id: Value(id),
      name: Value(name),
      assetType: Value(assetType),
      intent: intent == null && nullToAbsent
          ? const Value.absent()
          : Value(intent),
      market: market == null && nullToAbsent
          ? const Value.absent()
          : Value(market),
      marketCountry: marketCountry == null && nullToAbsent
          ? const Value.absent()
          : Value(marketCountry),
      unit: Value(unit),
      startDate: Value(startDate),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      purityKarat: purityKarat == null && nullToAbsent
          ? const Value.absent()
          : Value(purityKarat),
      purityFineness: purityFineness == null && nullToAbsent
          ? const Value.absent()
          : Value(purityFineness),
      zakatRule: Value(zakatRule),
      customZakatShare: customZakatShare == null && nullToAbsent
          ? const Value.absent()
          : Value(customZakatShare),
      inflationOverride: inflationOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(inflationOverride),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      payoutSchedule: payoutSchedule == null && nullToAbsent
          ? const Value.absent()
          : Value(payoutSchedule),
      expectedProfit: expectedProfit == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedProfit),
      valueCheckSchedule: valueCheckSchedule == null && nullToAbsent
          ? const Value.absent()
          : Value(valueCheckSchedule),
      expectedGrowth: expectedGrowth == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedGrowth),
      profitBasis: profitBasis == null && nullToAbsent
          ? const Value.absent()
          : Value(profitBasis),
      capitalBack: capitalBack == null && nullToAbsent
          ? const Value.absent()
          : Value(capitalBack),
      accountKind: accountKind == null && nullToAbsent
          ? const Value.absent()
          : Value(accountKind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InvestmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      assetType: serializer.fromJson<String>(json['assetType']),
      intent: serializer.fromJson<String?>(json['intent']),
      market: serializer.fromJson<String?>(json['market']),
      marketCountry: serializer.fromJson<String?>(json['marketCountry']),
      unit: serializer.fromJson<String>(json['unit']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      quantity: serializer.fromJson<Decimal?>(json['quantity']),
      purityKarat: serializer.fromJson<int?>(json['purityKarat']),
      purityFineness: serializer.fromJson<int?>(json['purityFineness']),
      zakatRule: serializer.fromJson<String>(json['zakatRule']),
      customZakatShare: serializer.fromJson<Decimal?>(json['customZakatShare']),
      inflationOverride: serializer.fromJson<String?>(
        json['inflationOverride'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      payoutSchedule: serializer.fromJson<String?>(json['payoutSchedule']),
      expectedProfit: serializer.fromJson<Decimal?>(json['expectedProfit']),
      valueCheckSchedule: serializer.fromJson<String?>(
        json['valueCheckSchedule'],
      ),
      expectedGrowth: serializer.fromJson<Decimal?>(json['expectedGrowth']),
      profitBasis: serializer.fromJson<String?>(json['profitBasis']),
      capitalBack: serializer.fromJson<String?>(json['capitalBack']),
      accountKind: serializer.fromJson<String?>(json['accountKind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'assetType': serializer.toJson<String>(assetType),
      'intent': serializer.toJson<String?>(intent),
      'market': serializer.toJson<String?>(market),
      'marketCountry': serializer.toJson<String?>(marketCountry),
      'unit': serializer.toJson<String>(unit),
      'startDate': serializer.toJson<DateTime>(startDate),
      'quantity': serializer.toJson<Decimal?>(quantity),
      'purityKarat': serializer.toJson<int?>(purityKarat),
      'purityFineness': serializer.toJson<int?>(purityFineness),
      'zakatRule': serializer.toJson<String>(zakatRule),
      'customZakatShare': serializer.toJson<Decimal?>(customZakatShare),
      'inflationOverride': serializer.toJson<String?>(inflationOverride),
      'notes': serializer.toJson<String?>(notes),
      'payoutSchedule': serializer.toJson<String?>(payoutSchedule),
      'expectedProfit': serializer.toJson<Decimal?>(expectedProfit),
      'valueCheckSchedule': serializer.toJson<String?>(valueCheckSchedule),
      'expectedGrowth': serializer.toJson<Decimal?>(expectedGrowth),
      'profitBasis': serializer.toJson<String?>(profitBasis),
      'capitalBack': serializer.toJson<String?>(capitalBack),
      'accountKind': serializer.toJson<String?>(accountKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InvestmentRow copyWith({
    String? id,
    String? name,
    String? assetType,
    Value<String?> intent = const Value.absent(),
    Value<String?> market = const Value.absent(),
    Value<String?> marketCountry = const Value.absent(),
    String? unit,
    DateTime? startDate,
    Value<Decimal?> quantity = const Value.absent(),
    Value<int?> purityKarat = const Value.absent(),
    Value<int?> purityFineness = const Value.absent(),
    String? zakatRule,
    Value<Decimal?> customZakatShare = const Value.absent(),
    Value<String?> inflationOverride = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> payoutSchedule = const Value.absent(),
    Value<Decimal?> expectedProfit = const Value.absent(),
    Value<String?> valueCheckSchedule = const Value.absent(),
    Value<Decimal?> expectedGrowth = const Value.absent(),
    Value<String?> profitBasis = const Value.absent(),
    Value<String?> capitalBack = const Value.absent(),
    Value<String?> accountKind = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InvestmentRow(
    id: id ?? this.id,
    name: name ?? this.name,
    assetType: assetType ?? this.assetType,
    intent: intent.present ? intent.value : this.intent,
    market: market.present ? market.value : this.market,
    marketCountry: marketCountry.present
        ? marketCountry.value
        : this.marketCountry,
    unit: unit ?? this.unit,
    startDate: startDate ?? this.startDate,
    quantity: quantity.present ? quantity.value : this.quantity,
    purityKarat: purityKarat.present ? purityKarat.value : this.purityKarat,
    purityFineness: purityFineness.present
        ? purityFineness.value
        : this.purityFineness,
    zakatRule: zakatRule ?? this.zakatRule,
    customZakatShare: customZakatShare.present
        ? customZakatShare.value
        : this.customZakatShare,
    inflationOverride: inflationOverride.present
        ? inflationOverride.value
        : this.inflationOverride,
    notes: notes.present ? notes.value : this.notes,
    payoutSchedule: payoutSchedule.present
        ? payoutSchedule.value
        : this.payoutSchedule,
    expectedProfit: expectedProfit.present
        ? expectedProfit.value
        : this.expectedProfit,
    valueCheckSchedule: valueCheckSchedule.present
        ? valueCheckSchedule.value
        : this.valueCheckSchedule,
    expectedGrowth: expectedGrowth.present
        ? expectedGrowth.value
        : this.expectedGrowth,
    profitBasis: profitBasis.present ? profitBasis.value : this.profitBasis,
    capitalBack: capitalBack.present ? capitalBack.value : this.capitalBack,
    accountKind: accountKind.present ? accountKind.value : this.accountKind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InvestmentRow copyWithCompanion(InvestmentsCompanion data) {
    return InvestmentRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      assetType: data.assetType.present ? data.assetType.value : this.assetType,
      intent: data.intent.present ? data.intent.value : this.intent,
      market: data.market.present ? data.market.value : this.market,
      marketCountry: data.marketCountry.present
          ? data.marketCountry.value
          : this.marketCountry,
      unit: data.unit.present ? data.unit.value : this.unit,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      purityKarat: data.purityKarat.present
          ? data.purityKarat.value
          : this.purityKarat,
      purityFineness: data.purityFineness.present
          ? data.purityFineness.value
          : this.purityFineness,
      zakatRule: data.zakatRule.present ? data.zakatRule.value : this.zakatRule,
      customZakatShare: data.customZakatShare.present
          ? data.customZakatShare.value
          : this.customZakatShare,
      inflationOverride: data.inflationOverride.present
          ? data.inflationOverride.value
          : this.inflationOverride,
      notes: data.notes.present ? data.notes.value : this.notes,
      payoutSchedule: data.payoutSchedule.present
          ? data.payoutSchedule.value
          : this.payoutSchedule,
      expectedProfit: data.expectedProfit.present
          ? data.expectedProfit.value
          : this.expectedProfit,
      valueCheckSchedule: data.valueCheckSchedule.present
          ? data.valueCheckSchedule.value
          : this.valueCheckSchedule,
      expectedGrowth: data.expectedGrowth.present
          ? data.expectedGrowth.value
          : this.expectedGrowth,
      profitBasis: data.profitBasis.present
          ? data.profitBasis.value
          : this.profitBasis,
      capitalBack: data.capitalBack.present
          ? data.capitalBack.value
          : this.capitalBack,
      accountKind: data.accountKind.present
          ? data.accountKind.value
          : this.accountKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assetType: $assetType, ')
          ..write('intent: $intent, ')
          ..write('market: $market, ')
          ..write('marketCountry: $marketCountry, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('quantity: $quantity, ')
          ..write('purityKarat: $purityKarat, ')
          ..write('purityFineness: $purityFineness, ')
          ..write('zakatRule: $zakatRule, ')
          ..write('customZakatShare: $customZakatShare, ')
          ..write('inflationOverride: $inflationOverride, ')
          ..write('notes: $notes, ')
          ..write('payoutSchedule: $payoutSchedule, ')
          ..write('expectedProfit: $expectedProfit, ')
          ..write('valueCheckSchedule: $valueCheckSchedule, ')
          ..write('expectedGrowth: $expectedGrowth, ')
          ..write('profitBasis: $profitBasis, ')
          ..write('capitalBack: $capitalBack, ')
          ..write('accountKind: $accountKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    assetType,
    intent,
    market,
    marketCountry,
    unit,
    startDate,
    quantity,
    purityKarat,
    purityFineness,
    zakatRule,
    customZakatShare,
    inflationOverride,
    notes,
    payoutSchedule,
    expectedProfit,
    valueCheckSchedule,
    expectedGrowth,
    profitBasis,
    capitalBack,
    accountKind,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.assetType == this.assetType &&
          other.intent == this.intent &&
          other.market == this.market &&
          other.marketCountry == this.marketCountry &&
          other.unit == this.unit &&
          other.startDate == this.startDate &&
          other.quantity == this.quantity &&
          other.purityKarat == this.purityKarat &&
          other.purityFineness == this.purityFineness &&
          other.zakatRule == this.zakatRule &&
          other.customZakatShare == this.customZakatShare &&
          other.inflationOverride == this.inflationOverride &&
          other.notes == this.notes &&
          other.payoutSchedule == this.payoutSchedule &&
          other.expectedProfit == this.expectedProfit &&
          other.valueCheckSchedule == this.valueCheckSchedule &&
          other.expectedGrowth == this.expectedGrowth &&
          other.profitBasis == this.profitBasis &&
          other.capitalBack == this.capitalBack &&
          other.accountKind == this.accountKind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvestmentsCompanion extends UpdateCompanion<InvestmentRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> assetType;
  final Value<String?> intent;
  final Value<String?> market;
  final Value<String?> marketCountry;
  final Value<String> unit;
  final Value<DateTime> startDate;
  final Value<Decimal?> quantity;
  final Value<int?> purityKarat;
  final Value<int?> purityFineness;
  final Value<String> zakatRule;
  final Value<Decimal?> customZakatShare;
  final Value<String?> inflationOverride;
  final Value<String?> notes;
  final Value<String?> payoutSchedule;
  final Value<Decimal?> expectedProfit;
  final Value<String?> valueCheckSchedule;
  final Value<Decimal?> expectedGrowth;
  final Value<String?> profitBasis;
  final Value<String?> capitalBack;
  final Value<String?> accountKind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InvestmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.assetType = const Value.absent(),
    this.intent = const Value.absent(),
    this.market = const Value.absent(),
    this.marketCountry = const Value.absent(),
    this.unit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.quantity = const Value.absent(),
    this.purityKarat = const Value.absent(),
    this.purityFineness = const Value.absent(),
    this.zakatRule = const Value.absent(),
    this.customZakatShare = const Value.absent(),
    this.inflationOverride = const Value.absent(),
    this.notes = const Value.absent(),
    this.payoutSchedule = const Value.absent(),
    this.expectedProfit = const Value.absent(),
    this.valueCheckSchedule = const Value.absent(),
    this.expectedGrowth = const Value.absent(),
    this.profitBasis = const Value.absent(),
    this.capitalBack = const Value.absent(),
    this.accountKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentsCompanion.insert({
    required String id,
    required String name,
    required String assetType,
    this.intent = const Value.absent(),
    this.market = const Value.absent(),
    this.marketCountry = const Value.absent(),
    required String unit,
    required DateTime startDate,
    this.quantity = const Value.absent(),
    this.purityKarat = const Value.absent(),
    this.purityFineness = const Value.absent(),
    required String zakatRule,
    this.customZakatShare = const Value.absent(),
    this.inflationOverride = const Value.absent(),
    this.notes = const Value.absent(),
    this.payoutSchedule = const Value.absent(),
    this.expectedProfit = const Value.absent(),
    this.valueCheckSchedule = const Value.absent(),
    this.expectedGrowth = const Value.absent(),
    this.profitBasis = const Value.absent(),
    this.capitalBack = const Value.absent(),
    this.accountKind = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       assetType = Value(assetType),
       unit = Value(unit),
       startDate = Value(startDate),
       zakatRule = Value(zakatRule),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InvestmentRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? assetType,
    Expression<String>? intent,
    Expression<String>? market,
    Expression<String>? marketCountry,
    Expression<String>? unit,
    Expression<String>? startDate,
    Expression<String>? quantity,
    Expression<int>? purityKarat,
    Expression<int>? purityFineness,
    Expression<String>? zakatRule,
    Expression<String>? customZakatShare,
    Expression<String>? inflationOverride,
    Expression<String>? notes,
    Expression<String>? payoutSchedule,
    Expression<String>? expectedProfit,
    Expression<String>? valueCheckSchedule,
    Expression<String>? expectedGrowth,
    Expression<String>? profitBasis,
    Expression<String>? capitalBack,
    Expression<String>? accountKind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (assetType != null) 'asset_type': assetType,
      if (intent != null) 'intent': intent,
      if (market != null) 'market': market,
      if (marketCountry != null) 'market_country': marketCountry,
      if (unit != null) 'unit': unit,
      if (startDate != null) 'start_date': startDate,
      if (quantity != null) 'quantity': quantity,
      if (purityKarat != null) 'purity_karat': purityKarat,
      if (purityFineness != null) 'purity_fineness': purityFineness,
      if (zakatRule != null) 'zakat_rule': zakatRule,
      if (customZakatShare != null) 'custom_zakat_share': customZakatShare,
      if (inflationOverride != null) 'inflation_override': inflationOverride,
      if (notes != null) 'notes': notes,
      if (payoutSchedule != null) 'payout_schedule': payoutSchedule,
      if (expectedProfit != null) 'expected_profit': expectedProfit,
      if (valueCheckSchedule != null)
        'value_check_schedule': valueCheckSchedule,
      if (expectedGrowth != null) 'expected_growth': expectedGrowth,
      if (profitBasis != null) 'profit_basis': profitBasis,
      if (capitalBack != null) 'capital_back': capitalBack,
      if (accountKind != null) 'account_kind': accountKind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? assetType,
    Value<String?>? intent,
    Value<String?>? market,
    Value<String?>? marketCountry,
    Value<String>? unit,
    Value<DateTime>? startDate,
    Value<Decimal?>? quantity,
    Value<int?>? purityKarat,
    Value<int?>? purityFineness,
    Value<String>? zakatRule,
    Value<Decimal?>? customZakatShare,
    Value<String?>? inflationOverride,
    Value<String?>? notes,
    Value<String?>? payoutSchedule,
    Value<Decimal?>? expectedProfit,
    Value<String?>? valueCheckSchedule,
    Value<Decimal?>? expectedGrowth,
    Value<String?>? profitBasis,
    Value<String?>? capitalBack,
    Value<String?>? accountKind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvestmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      assetType: assetType ?? this.assetType,
      intent: intent ?? this.intent,
      market: market ?? this.market,
      marketCountry: marketCountry ?? this.marketCountry,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      quantity: quantity ?? this.quantity,
      purityKarat: purityKarat ?? this.purityKarat,
      purityFineness: purityFineness ?? this.purityFineness,
      zakatRule: zakatRule ?? this.zakatRule,
      customZakatShare: customZakatShare ?? this.customZakatShare,
      inflationOverride: inflationOverride ?? this.inflationOverride,
      notes: notes ?? this.notes,
      payoutSchedule: payoutSchedule ?? this.payoutSchedule,
      expectedProfit: expectedProfit ?? this.expectedProfit,
      valueCheckSchedule: valueCheckSchedule ?? this.valueCheckSchedule,
      expectedGrowth: expectedGrowth ?? this.expectedGrowth,
      profitBasis: profitBasis ?? this.profitBasis,
      capitalBack: capitalBack ?? this.capitalBack,
      accountKind: accountKind ?? this.accountKind,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (assetType.present) {
      map['asset_type'] = Variable<String>(assetType.value);
    }
    if (intent.present) {
      map['intent'] = Variable<String>(intent.value);
    }
    if (market.present) {
      map['market'] = Variable<String>(market.value);
    }
    if (marketCountry.present) {
      map['market_country'] = Variable<String>(marketCountry.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $InvestmentsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(
        $InvestmentsTable.$converterquantityn.toSql(quantity.value),
      );
    }
    if (purityKarat.present) {
      map['purity_karat'] = Variable<int>(purityKarat.value);
    }
    if (purityFineness.present) {
      map['purity_fineness'] = Variable<int>(purityFineness.value);
    }
    if (zakatRule.present) {
      map['zakat_rule'] = Variable<String>(zakatRule.value);
    }
    if (customZakatShare.present) {
      map['custom_zakat_share'] = Variable<String>(
        $InvestmentsTable.$convertercustomZakatSharen.toSql(
          customZakatShare.value,
        ),
      );
    }
    if (inflationOverride.present) {
      map['inflation_override'] = Variable<String>(inflationOverride.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (payoutSchedule.present) {
      map['payout_schedule'] = Variable<String>(payoutSchedule.value);
    }
    if (expectedProfit.present) {
      map['expected_profit'] = Variable<String>(
        $InvestmentsTable.$converterexpectedProfitn.toSql(expectedProfit.value),
      );
    }
    if (valueCheckSchedule.present) {
      map['value_check_schedule'] = Variable<String>(valueCheckSchedule.value);
    }
    if (expectedGrowth.present) {
      map['expected_growth'] = Variable<String>(
        $InvestmentsTable.$converterexpectedGrowthn.toSql(expectedGrowth.value),
      );
    }
    if (profitBasis.present) {
      map['profit_basis'] = Variable<String>(profitBasis.value);
    }
    if (capitalBack.present) {
      map['capital_back'] = Variable<String>(capitalBack.value);
    }
    if (accountKind.present) {
      map['account_kind'] = Variable<String>(accountKind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('assetType: $assetType, ')
          ..write('intent: $intent, ')
          ..write('market: $market, ')
          ..write('marketCountry: $marketCountry, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('quantity: $quantity, ')
          ..write('purityKarat: $purityKarat, ')
          ..write('purityFineness: $purityFineness, ')
          ..write('zakatRule: $zakatRule, ')
          ..write('customZakatShare: $customZakatShare, ')
          ..write('inflationOverride: $inflationOverride, ')
          ..write('notes: $notes, ')
          ..write('payoutSchedule: $payoutSchedule, ')
          ..write('expectedProfit: $expectedProfit, ')
          ..write('valueCheckSchedule: $valueCheckSchedule, ')
          ..write('expectedGrowth: $expectedGrowth, ')
          ..write('profitBasis: $profitBasis, ')
          ..write('capitalBack: $capitalBack, ')
          ..write('accountKind: $accountKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryEntriesTable extends HistoryEntries
    with TableInfo<$HistoryEntriesTable, HistoryEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _investmentIdMeta = const VerificationMeta(
    'investmentId',
  );
  @override
  late final GeneratedColumn<String> investmentId = GeneratedColumn<String>(
    'investment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES investments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($HistoryEntriesTable.$converterdate);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> amount =
      GeneratedColumn<String>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($HistoryEntriesTable.$converteramount);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    investmentId,
    kind,
    date,
    amount,
    unit,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('investment_id')) {
      context.handle(
        _investmentIdMeta,
        investmentId.isAcceptableOrUnknown(
          data['investment_id']!,
          _investmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_investmentIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      investmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}investment_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      date: $HistoryEntriesTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      amount: $HistoryEntriesTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amount'],
        )!,
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HistoryEntriesTable createAlias(String alias) {
    return $HistoryEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate =
      const CalendarDateConverter();
  static TypeConverter<Decimal, String> $converteramount =
      const DecimalConverter();
}

class HistoryEntryRow extends DataClass implements Insertable<HistoryEntryRow> {
  final String id;
  final String investmentId;

  /// money_in, sale, income, interest_*, value_update, *_skipped
  final String kind;
  final DateTime date;

  /// For value_update: the value in the item unit.
  final Decimal amount;

  /// Null for value_update.
  final String? unit;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HistoryEntryRow({
    required this.id,
    required this.investmentId,
    required this.kind,
    required this.date,
    required this.amount,
    this.unit,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['investment_id'] = Variable<String>(investmentId);
    map['kind'] = Variable<String>(kind);
    {
      map['date'] = Variable<String>(
        $HistoryEntriesTable.$converterdate.toSql(date),
      );
    }
    {
      map['amount'] = Variable<String>(
        $HistoryEntriesTable.$converteramount.toSql(amount),
      );
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return HistoryEntriesCompanion(
      id: Value(id),
      investmentId: Value(investmentId),
      kind: Value(kind),
      date: Value(date),
      amount: Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HistoryEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryEntryRow(
      id: serializer.fromJson<String>(json['id']),
      investmentId: serializer.fromJson<String>(json['investmentId']),
      kind: serializer.fromJson<String>(json['kind']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<Decimal>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'investmentId': serializer.toJson<String>(investmentId),
      'kind': serializer.toJson<String>(kind),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<Decimal>(amount),
      'unit': serializer.toJson<String?>(unit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HistoryEntryRow copyWith({
    String? id,
    String? investmentId,
    String? kind,
    DateTime? date,
    Decimal? amount,
    Value<String?> unit = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HistoryEntryRow(
    id: id ?? this.id,
    investmentId: investmentId ?? this.investmentId,
    kind: kind ?? this.kind,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    unit: unit.present ? unit.value : this.unit,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HistoryEntryRow copyWithCompanion(HistoryEntriesCompanion data) {
    return HistoryEntryRow(
      id: data.id.present ? data.id.value : this.id,
      investmentId: data.investmentId.present
          ? data.investmentId.value
          : this.investmentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEntryRow(')
          ..write('id: $id, ')
          ..write('investmentId: $investmentId, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    investmentId,
    kind,
    date,
    amount,
    unit,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryEntryRow &&
          other.id == this.id &&
          other.investmentId == this.investmentId &&
          other.kind == this.kind &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HistoryEntriesCompanion extends UpdateCompanion<HistoryEntryRow> {
  final Value<String> id;
  final Value<String> investmentId;
  final Value<String> kind;
  final Value<DateTime> date;
  final Value<Decimal> amount;
  final Value<String?> unit;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.investmentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryEntriesCompanion.insert({
    required String id,
    required String investmentId,
    required String kind,
    required DateTime date,
    required Decimal amount,
    this.unit = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       investmentId = Value(investmentId),
       kind = Value(kind),
       date = Value(date),
       amount = Value(amount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HistoryEntryRow> custom({
    Expression<String>? id,
    Expression<String>? investmentId,
    Expression<String>? kind,
    Expression<String>? date,
    Expression<String>? amount,
    Expression<String>? unit,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (investmentId != null) 'investment_id': investmentId,
      if (kind != null) 'kind': kind,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? investmentId,
    Value<String>? kind,
    Value<DateTime>? date,
    Value<Decimal>? amount,
    Value<String?>? unit,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HistoryEntriesCompanion(
      id: id ?? this.id,
      investmentId: investmentId ?? this.investmentId,
      kind: kind ?? this.kind,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (investmentId.present) {
      map['investment_id'] = Variable<String>(investmentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $HistoryEntriesTable.$converterdate.toSql(date.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<String>(
        $HistoryEntriesTable.$converteramount.toSql(amount.value),
      );
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('investmentId: $investmentId, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RatesTable extends Rates with TableInfo<$RatesTable, RateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromUnitMeta = const VerificationMeta(
    'fromUnit',
  );
  @override
  late final GeneratedColumn<String> fromUnit = GeneratedColumn<String>(
    'from_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toUnitMeta = const VerificationMeta('toUnit');
  @override
  late final GeneratedColumn<String> toUnit = GeneratedColumn<String>(
    'to_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> rate =
      GeneratedColumn<String>(
        'rate',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($RatesTable.$converterrate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> asOf =
      GeneratedColumn<String>(
        'as_of',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RatesTable.$converterasOf);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromUnit,
    toUnit,
    rate,
    asOf,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<RateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_unit')) {
      context.handle(
        _fromUnitMeta,
        fromUnit.isAcceptableOrUnknown(data['from_unit']!, _fromUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_fromUnitMeta);
    }
    if (data.containsKey('to_unit')) {
      context.handle(
        _toUnitMeta,
        toUnit.isAcceptableOrUnknown(data['to_unit']!, _toUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_toUnitMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {fromUnit, toUnit, asOf, source},
  ];
  @override
  RateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_unit'],
      )!,
      toUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_unit'],
      )!,
      rate: $RatesTable.$converterrate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rate'],
        )!,
      ),
      asOf: $RatesTable.$converterasOf.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}as_of'],
        )!,
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RatesTable createAlias(String alias) {
    return $RatesTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $converterrate =
      const DecimalConverter();
  static TypeConverter<DateTime, String> $converterasOf =
      const CalendarDateConverter();
}

class RateRow extends DataClass implements Insertable<RateRow> {
  final String id;
  final String fromUnit;
  final String toUnit;
  final Decimal rate;
  final DateTime asOf;

  /// typed or currencyApi
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RateRow({
    required this.id,
    required this.fromUnit,
    required this.toUnit,
    required this.rate,
    required this.asOf,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_unit'] = Variable<String>(fromUnit);
    map['to_unit'] = Variable<String>(toUnit);
    {
      map['rate'] = Variable<String>($RatesTable.$converterrate.toSql(rate));
    }
    {
      map['as_of'] = Variable<String>($RatesTable.$converterasOf.toSql(asOf));
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RatesCompanion toCompanion(bool nullToAbsent) {
    return RatesCompanion(
      id: Value(id),
      fromUnit: Value(fromUnit),
      toUnit: Value(toUnit),
      rate: Value(rate),
      asOf: Value(asOf),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateRow(
      id: serializer.fromJson<String>(json['id']),
      fromUnit: serializer.fromJson<String>(json['fromUnit']),
      toUnit: serializer.fromJson<String>(json['toUnit']),
      rate: serializer.fromJson<Decimal>(json['rate']),
      asOf: serializer.fromJson<DateTime>(json['asOf']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromUnit': serializer.toJson<String>(fromUnit),
      'toUnit': serializer.toJson<String>(toUnit),
      'rate': serializer.toJson<Decimal>(rate),
      'asOf': serializer.toJson<DateTime>(asOf),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RateRow copyWith({
    String? id,
    String? fromUnit,
    String? toUnit,
    Decimal? rate,
    DateTime? asOf,
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RateRow(
    id: id ?? this.id,
    fromUnit: fromUnit ?? this.fromUnit,
    toUnit: toUnit ?? this.toUnit,
    rate: rate ?? this.rate,
    asOf: asOf ?? this.asOf,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RateRow copyWithCompanion(RatesCompanion data) {
    return RateRow(
      id: data.id.present ? data.id.value : this.id,
      fromUnit: data.fromUnit.present ? data.fromUnit.value : this.fromUnit,
      toUnit: data.toUnit.present ? data.toUnit.value : this.toUnit,
      rate: data.rate.present ? data.rate.value : this.rate,
      asOf: data.asOf.present ? data.asOf.value : this.asOf,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateRow(')
          ..write('id: $id, ')
          ..write('fromUnit: $fromUnit, ')
          ..write('toUnit: $toUnit, ')
          ..write('rate: $rate, ')
          ..write('asOf: $asOf, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromUnit,
    toUnit,
    rate,
    asOf,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateRow &&
          other.id == this.id &&
          other.fromUnit == this.fromUnit &&
          other.toUnit == this.toUnit &&
          other.rate == this.rate &&
          other.asOf == this.asOf &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RatesCompanion extends UpdateCompanion<RateRow> {
  final Value<String> id;
  final Value<String> fromUnit;
  final Value<String> toUnit;
  final Value<Decimal> rate;
  final Value<DateTime> asOf;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RatesCompanion({
    this.id = const Value.absent(),
    this.fromUnit = const Value.absent(),
    this.toUnit = const Value.absent(),
    this.rate = const Value.absent(),
    this.asOf = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RatesCompanion.insert({
    required String id,
    required String fromUnit,
    required String toUnit,
    required Decimal rate,
    required DateTime asOf,
    required String source,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromUnit = Value(fromUnit),
       toUnit = Value(toUnit),
       rate = Value(rate),
       asOf = Value(asOf),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RateRow> custom({
    Expression<String>? id,
    Expression<String>? fromUnit,
    Expression<String>? toUnit,
    Expression<String>? rate,
    Expression<String>? asOf,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromUnit != null) 'from_unit': fromUnit,
      if (toUnit != null) 'to_unit': toUnit,
      if (rate != null) 'rate': rate,
      if (asOf != null) 'as_of': asOf,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RatesCompanion copyWith({
    Value<String>? id,
    Value<String>? fromUnit,
    Value<String>? toUnit,
    Value<Decimal>? rate,
    Value<DateTime>? asOf,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RatesCompanion(
      id: id ?? this.id,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      rate: rate ?? this.rate,
      asOf: asOf ?? this.asOf,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromUnit.present) {
      map['from_unit'] = Variable<String>(fromUnit.value);
    }
    if (toUnit.present) {
      map['to_unit'] = Variable<String>(toUnit.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(
        $RatesTable.$converterrate.toSql(rate.value),
      );
    }
    if (asOf.present) {
      map['as_of'] = Variable<String>(
        $RatesTable.$converterasOf.toSql(asOf.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatesCompanion(')
          ..write('id: $id, ')
          ..write('fromUnit: $fromUnit, ')
          ..write('toUnit: $toUnit, ')
          ..write('rate: $rate, ')
          ..write('asOf: $asOf, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InflationOverridesTable extends InflationOverrides
    with TableInfo<$InflationOverridesTable, InflationOverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InflationOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> rate =
      GeneratedColumn<String>(
        'rate',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($InflationOverridesTable.$converterrate);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    country,
    year,
    rate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inflation_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<InflationOverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {country, year},
  ];
  @override
  InflationOverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InflationOverrideRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      rate: $InflationOverridesTable.$converterrate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rate'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InflationOverridesTable createAlias(String alias) {
    return $InflationOverridesTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $converterrate =
      const DecimalConverter();
}

class InflationOverrideRow extends DataClass
    implements Insertable<InflationOverrideRow> {
  final String id;
  final String country;
  final int year;
  final Decimal rate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InflationOverrideRow({
    required this.id,
    required this.country,
    required this.year,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['country'] = Variable<String>(country);
    map['year'] = Variable<int>(year);
    {
      map['rate'] = Variable<String>(
        $InflationOverridesTable.$converterrate.toSql(rate),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InflationOverridesCompanion toCompanion(bool nullToAbsent) {
    return InflationOverridesCompanion(
      id: Value(id),
      country: Value(country),
      year: Value(year),
      rate: Value(rate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InflationOverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InflationOverrideRow(
      id: serializer.fromJson<String>(json['id']),
      country: serializer.fromJson<String>(json['country']),
      year: serializer.fromJson<int>(json['year']),
      rate: serializer.fromJson<Decimal>(json['rate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'country': serializer.toJson<String>(country),
      'year': serializer.toJson<int>(year),
      'rate': serializer.toJson<Decimal>(rate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InflationOverrideRow copyWith({
    String? id,
    String? country,
    int? year,
    Decimal? rate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InflationOverrideRow(
    id: id ?? this.id,
    country: country ?? this.country,
    year: year ?? this.year,
    rate: rate ?? this.rate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InflationOverrideRow copyWithCompanion(InflationOverridesCompanion data) {
    return InflationOverrideRow(
      id: data.id.present ? data.id.value : this.id,
      country: data.country.present ? data.country.value : this.country,
      year: data.year.present ? data.year.value : this.year,
      rate: data.rate.present ? data.rate.value : this.rate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InflationOverrideRow(')
          ..write('id: $id, ')
          ..write('country: $country, ')
          ..write('year: $year, ')
          ..write('rate: $rate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, country, year, rate, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InflationOverrideRow &&
          other.id == this.id &&
          other.country == this.country &&
          other.year == this.year &&
          other.rate == this.rate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InflationOverridesCompanion
    extends UpdateCompanion<InflationOverrideRow> {
  final Value<String> id;
  final Value<String> country;
  final Value<int> year;
  final Value<Decimal> rate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InflationOverridesCompanion({
    this.id = const Value.absent(),
    this.country = const Value.absent(),
    this.year = const Value.absent(),
    this.rate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InflationOverridesCompanion.insert({
    required String id,
    required String country,
    required int year,
    required Decimal rate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       country = Value(country),
       year = Value(year),
       rate = Value(rate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InflationOverrideRow> custom({
    Expression<String>? id,
    Expression<String>? country,
    Expression<int>? year,
    Expression<String>? rate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (country != null) 'country': country,
      if (year != null) 'year': year,
      if (rate != null) 'rate': rate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InflationOverridesCompanion copyWith({
    Value<String>? id,
    Value<String>? country,
    Value<int>? year,
    Value<Decimal>? rate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InflationOverridesCompanion(
      id: id ?? this.id,
      country: country ?? this.country,
      year: year ?? this.year,
      rate: rate ?? this.rate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(
        $InflationOverridesTable.$converterrate.toSql(rate.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InflationOverridesCompanion(')
          ..write('id: $id, ')
          ..write('country: $country, ')
          ..write('year: $year, ')
          ..write('rate: $rate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _homeInflationMeta = const VerificationMeta(
    'homeInflation',
  );
  @override
  late final GeneratedColumn<String> homeInflation = GeneratedColumn<String>(
    'home_inflation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zakatYearMeta = const VerificationMeta(
    'zakatYear',
  );
  @override
  late final GeneratedColumn<String> zakatYear = GeneratedColumn<String>(
    'zakat_year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longTermMethodMeta = const VerificationMeta(
    'longTermMethod',
  );
  @override
  late final GeneratedColumn<String> longTermMethod = GeneratedColumn<String>(
    'long_term_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jewelleryZakatableMeta =
      const VerificationMeta('jewelleryZakatable');
  @override
  late final GeneratedColumn<bool> jewelleryZakatable = GeneratedColumn<bool>(
    'jewellery_zakatable',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("jewellery_zakatable" IN (0, 1))',
    ),
  );
  static const VerificationMeta _nisabMetalMeta = const VerificationMeta(
    'nisabMetal',
  );
  @override
  late final GeneratedColumn<String> nisabMetal = GeneratedColumn<String>(
    'nisab_metal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderOnMeta = const VerificationMeta(
    'reminderOn',
  );
  @override
  late final GeneratedColumn<bool> reminderOn = GeneratedColumn<bool>(
    'reminder_on',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_on" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderDaysMeta = const VerificationMeta(
    'reminderDays',
  );
  @override
  late final GeneratedColumn<int> reminderDays = GeneratedColumn<int>(
    'reminder_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(540),
  );
  static const VerificationMeta _reminderAskedMeta = const VerificationMeta(
    'reminderAsked',
  );
  @override
  late final GeneratedColumn<bool> reminderAsked = GeneratedColumn<bool>(
    'reminder_asked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_asked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _givingRateViewMeta = const VerificationMeta(
    'givingRateView',
  );
  @override
  late final GeneratedColumn<String> givingRateView = GeneratedColumn<String>(
    'giving_rate_view',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseCurrency,
    homeInflation,
    zakatYear,
    longTermMethod,
    jewelleryZakatable,
    nisabMetal,
    reminderOn,
    reminderDays,
    reminderMinute,
    reminderAsked,
    givingRateView,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('home_inflation')) {
      context.handle(
        _homeInflationMeta,
        homeInflation.isAcceptableOrUnknown(
          data['home_inflation']!,
          _homeInflationMeta,
        ),
      );
    }
    if (data.containsKey('zakat_year')) {
      context.handle(
        _zakatYearMeta,
        zakatYear.isAcceptableOrUnknown(data['zakat_year']!, _zakatYearMeta),
      );
    }
    if (data.containsKey('long_term_method')) {
      context.handle(
        _longTermMethodMeta,
        longTermMethod.isAcceptableOrUnknown(
          data['long_term_method']!,
          _longTermMethodMeta,
        ),
      );
    }
    if (data.containsKey('jewellery_zakatable')) {
      context.handle(
        _jewelleryZakatableMeta,
        jewelleryZakatable.isAcceptableOrUnknown(
          data['jewellery_zakatable']!,
          _jewelleryZakatableMeta,
        ),
      );
    }
    if (data.containsKey('nisab_metal')) {
      context.handle(
        _nisabMetalMeta,
        nisabMetal.isAcceptableOrUnknown(data['nisab_metal']!, _nisabMetalMeta),
      );
    }
    if (data.containsKey('reminder_on')) {
      context.handle(
        _reminderOnMeta,
        reminderOn.isAcceptableOrUnknown(data['reminder_on']!, _reminderOnMeta),
      );
    }
    if (data.containsKey('reminder_days')) {
      context.handle(
        _reminderDaysMeta,
        reminderDays.isAcceptableOrUnknown(
          data['reminder_days']!,
          _reminderDaysMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('reminder_asked')) {
      context.handle(
        _reminderAskedMeta,
        reminderAsked.isAcceptableOrUnknown(
          data['reminder_asked']!,
          _reminderAskedMeta,
        ),
      );
    }
    if (data.containsKey('giving_rate_view')) {
      context.handle(
        _givingRateViewMeta,
        givingRateView.isAcceptableOrUnknown(
          data['giving_rate_view']!,
          _givingRateViewMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      ),
      homeInflation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_inflation'],
      ),
      zakatYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zakat_year'],
      ),
      longTermMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}long_term_method'],
      ),
      jewelleryZakatable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}jewellery_zakatable'],
      ),
      nisabMetal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nisab_metal'],
      ),
      reminderOn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_on'],
      )!,
      reminderDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_days'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      )!,
      reminderAsked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_asked'],
      )!,
      givingRateView: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}giving_rate_view'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final String id;
  final String? baseCurrency;
  final String? homeInflation;
  final String? zakatYear;
  final String? longTermMethod;
  final bool? jewelleryZakatable;

  /// v3 (zakat spec §2.1): the zakat preferences.
  final String? nisabMetal;
  final bool reminderOn;
  final int reminderDays;
  final int reminderMinute;
  final bool reminderAsked;
  final String? givingRateView;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SettingsRow({
    required this.id,
    this.baseCurrency,
    this.homeInflation,
    this.zakatYear,
    this.longTermMethod,
    this.jewelleryZakatable,
    this.nisabMetal,
    required this.reminderOn,
    required this.reminderDays,
    required this.reminderMinute,
    required this.reminderAsked,
    this.givingRateView,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || baseCurrency != null) {
      map['base_currency'] = Variable<String>(baseCurrency);
    }
    if (!nullToAbsent || homeInflation != null) {
      map['home_inflation'] = Variable<String>(homeInflation);
    }
    if (!nullToAbsent || zakatYear != null) {
      map['zakat_year'] = Variable<String>(zakatYear);
    }
    if (!nullToAbsent || longTermMethod != null) {
      map['long_term_method'] = Variable<String>(longTermMethod);
    }
    if (!nullToAbsent || jewelleryZakatable != null) {
      map['jewellery_zakatable'] = Variable<bool>(jewelleryZakatable);
    }
    if (!nullToAbsent || nisabMetal != null) {
      map['nisab_metal'] = Variable<String>(nisabMetal);
    }
    map['reminder_on'] = Variable<bool>(reminderOn);
    map['reminder_days'] = Variable<int>(reminderDays);
    map['reminder_minute'] = Variable<int>(reminderMinute);
    map['reminder_asked'] = Variable<bool>(reminderAsked);
    if (!nullToAbsent || givingRateView != null) {
      map['giving_rate_view'] = Variable<String>(givingRateView);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      baseCurrency: baseCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(baseCurrency),
      homeInflation: homeInflation == null && nullToAbsent
          ? const Value.absent()
          : Value(homeInflation),
      zakatYear: zakatYear == null && nullToAbsent
          ? const Value.absent()
          : Value(zakatYear),
      longTermMethod: longTermMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(longTermMethod),
      jewelleryZakatable: jewelleryZakatable == null && nullToAbsent
          ? const Value.absent()
          : Value(jewelleryZakatable),
      nisabMetal: nisabMetal == null && nullToAbsent
          ? const Value.absent()
          : Value(nisabMetal),
      reminderOn: Value(reminderOn),
      reminderDays: Value(reminderDays),
      reminderMinute: Value(reminderMinute),
      reminderAsked: Value(reminderAsked),
      givingRateView: givingRateView == null && nullToAbsent
          ? const Value.absent()
          : Value(givingRateView),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<String>(json['id']),
      baseCurrency: serializer.fromJson<String?>(json['baseCurrency']),
      homeInflation: serializer.fromJson<String?>(json['homeInflation']),
      zakatYear: serializer.fromJson<String?>(json['zakatYear']),
      longTermMethod: serializer.fromJson<String?>(json['longTermMethod']),
      jewelleryZakatable: serializer.fromJson<bool?>(
        json['jewelleryZakatable'],
      ),
      nisabMetal: serializer.fromJson<String?>(json['nisabMetal']),
      reminderOn: serializer.fromJson<bool>(json['reminderOn']),
      reminderDays: serializer.fromJson<int>(json['reminderDays']),
      reminderMinute: serializer.fromJson<int>(json['reminderMinute']),
      reminderAsked: serializer.fromJson<bool>(json['reminderAsked']),
      givingRateView: serializer.fromJson<String?>(json['givingRateView']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseCurrency': serializer.toJson<String?>(baseCurrency),
      'homeInflation': serializer.toJson<String?>(homeInflation),
      'zakatYear': serializer.toJson<String?>(zakatYear),
      'longTermMethod': serializer.toJson<String?>(longTermMethod),
      'jewelleryZakatable': serializer.toJson<bool?>(jewelleryZakatable),
      'nisabMetal': serializer.toJson<String?>(nisabMetal),
      'reminderOn': serializer.toJson<bool>(reminderOn),
      'reminderDays': serializer.toJson<int>(reminderDays),
      'reminderMinute': serializer.toJson<int>(reminderMinute),
      'reminderAsked': serializer.toJson<bool>(reminderAsked),
      'givingRateView': serializer.toJson<String?>(givingRateView),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SettingsRow copyWith({
    String? id,
    Value<String?> baseCurrency = const Value.absent(),
    Value<String?> homeInflation = const Value.absent(),
    Value<String?> zakatYear = const Value.absent(),
    Value<String?> longTermMethod = const Value.absent(),
    Value<bool?> jewelleryZakatable = const Value.absent(),
    Value<String?> nisabMetal = const Value.absent(),
    bool? reminderOn,
    int? reminderDays,
    int? reminderMinute,
    bool? reminderAsked,
    Value<String?> givingRateView = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SettingsRow(
    id: id ?? this.id,
    baseCurrency: baseCurrency.present ? baseCurrency.value : this.baseCurrency,
    homeInflation: homeInflation.present
        ? homeInflation.value
        : this.homeInflation,
    zakatYear: zakatYear.present ? zakatYear.value : this.zakatYear,
    longTermMethod: longTermMethod.present
        ? longTermMethod.value
        : this.longTermMethod,
    jewelleryZakatable: jewelleryZakatable.present
        ? jewelleryZakatable.value
        : this.jewelleryZakatable,
    nisabMetal: nisabMetal.present ? nisabMetal.value : this.nisabMetal,
    reminderOn: reminderOn ?? this.reminderOn,
    reminderDays: reminderDays ?? this.reminderDays,
    reminderMinute: reminderMinute ?? this.reminderMinute,
    reminderAsked: reminderAsked ?? this.reminderAsked,
    givingRateView: givingRateView.present
        ? givingRateView.value
        : this.givingRateView,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      homeInflation: data.homeInflation.present
          ? data.homeInflation.value
          : this.homeInflation,
      zakatYear: data.zakatYear.present ? data.zakatYear.value : this.zakatYear,
      longTermMethod: data.longTermMethod.present
          ? data.longTermMethod.value
          : this.longTermMethod,
      jewelleryZakatable: data.jewelleryZakatable.present
          ? data.jewelleryZakatable.value
          : this.jewelleryZakatable,
      nisabMetal: data.nisabMetal.present
          ? data.nisabMetal.value
          : this.nisabMetal,
      reminderOn: data.reminderOn.present
          ? data.reminderOn.value
          : this.reminderOn,
      reminderDays: data.reminderDays.present
          ? data.reminderDays.value
          : this.reminderDays,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
      reminderAsked: data.reminderAsked.present
          ? data.reminderAsked.value
          : this.reminderAsked,
      givingRateView: data.givingRateView.present
          ? data.givingRateView.value
          : this.givingRateView,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('homeInflation: $homeInflation, ')
          ..write('zakatYear: $zakatYear, ')
          ..write('longTermMethod: $longTermMethod, ')
          ..write('jewelleryZakatable: $jewelleryZakatable, ')
          ..write('nisabMetal: $nisabMetal, ')
          ..write('reminderOn: $reminderOn, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('reminderAsked: $reminderAsked, ')
          ..write('givingRateView: $givingRateView, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseCurrency,
    homeInflation,
    zakatYear,
    longTermMethod,
    jewelleryZakatable,
    nisabMetal,
    reminderOn,
    reminderDays,
    reminderMinute,
    reminderAsked,
    givingRateView,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.baseCurrency == this.baseCurrency &&
          other.homeInflation == this.homeInflation &&
          other.zakatYear == this.zakatYear &&
          other.longTermMethod == this.longTermMethod &&
          other.jewelleryZakatable == this.jewelleryZakatable &&
          other.nisabMetal == this.nisabMetal &&
          other.reminderOn == this.reminderOn &&
          other.reminderDays == this.reminderDays &&
          other.reminderMinute == this.reminderMinute &&
          other.reminderAsked == this.reminderAsked &&
          other.givingRateView == this.givingRateView &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<String> id;
  final Value<String?> baseCurrency;
  final Value<String?> homeInflation;
  final Value<String?> zakatYear;
  final Value<String?> longTermMethod;
  final Value<bool?> jewelleryZakatable;
  final Value<String?> nisabMetal;
  final Value<bool> reminderOn;
  final Value<int> reminderDays;
  final Value<int> reminderMinute;
  final Value<bool> reminderAsked;
  final Value<String?> givingRateView;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.homeInflation = const Value.absent(),
    this.zakatYear = const Value.absent(),
    this.longTermMethod = const Value.absent(),
    this.jewelleryZakatable = const Value.absent(),
    this.nisabMetal = const Value.absent(),
    this.reminderOn = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.reminderAsked = const Value.absent(),
    this.givingRateView = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String id,
    this.baseCurrency = const Value.absent(),
    this.homeInflation = const Value.absent(),
    this.zakatYear = const Value.absent(),
    this.longTermMethod = const Value.absent(),
    this.jewelleryZakatable = const Value.absent(),
    this.nisabMetal = const Value.absent(),
    this.reminderOn = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.reminderAsked = const Value.absent(),
    this.givingRateView = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SettingsRow> custom({
    Expression<String>? id,
    Expression<String>? baseCurrency,
    Expression<String>? homeInflation,
    Expression<String>? zakatYear,
    Expression<String>? longTermMethod,
    Expression<bool>? jewelleryZakatable,
    Expression<String>? nisabMetal,
    Expression<bool>? reminderOn,
    Expression<int>? reminderDays,
    Expression<int>? reminderMinute,
    Expression<bool>? reminderAsked,
    Expression<String>? givingRateView,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (homeInflation != null) 'home_inflation': homeInflation,
      if (zakatYear != null) 'zakat_year': zakatYear,
      if (longTermMethod != null) 'long_term_method': longTermMethod,
      if (jewelleryZakatable != null) 'jewellery_zakatable': jewelleryZakatable,
      if (nisabMetal != null) 'nisab_metal': nisabMetal,
      if (reminderOn != null) 'reminder_on': reminderOn,
      if (reminderDays != null) 'reminder_days': reminderDays,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
      if (reminderAsked != null) 'reminder_asked': reminderAsked,
      if (givingRateView != null) 'giving_rate_view': givingRateView,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? id,
    Value<String?>? baseCurrency,
    Value<String?>? homeInflation,
    Value<String?>? zakatYear,
    Value<String?>? longTermMethod,
    Value<bool?>? jewelleryZakatable,
    Value<String?>? nisabMetal,
    Value<bool>? reminderOn,
    Value<int>? reminderDays,
    Value<int>? reminderMinute,
    Value<bool>? reminderAsked,
    Value<String?>? givingRateView,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      homeInflation: homeInflation ?? this.homeInflation,
      zakatYear: zakatYear ?? this.zakatYear,
      longTermMethod: longTermMethod ?? this.longTermMethod,
      jewelleryZakatable: jewelleryZakatable ?? this.jewelleryZakatable,
      nisabMetal: nisabMetal ?? this.nisabMetal,
      reminderOn: reminderOn ?? this.reminderOn,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      reminderAsked: reminderAsked ?? this.reminderAsked,
      givingRateView: givingRateView ?? this.givingRateView,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (homeInflation.present) {
      map['home_inflation'] = Variable<String>(homeInflation.value);
    }
    if (zakatYear.present) {
      map['zakat_year'] = Variable<String>(zakatYear.value);
    }
    if (longTermMethod.present) {
      map['long_term_method'] = Variable<String>(longTermMethod.value);
    }
    if (jewelleryZakatable.present) {
      map['jewellery_zakatable'] = Variable<bool>(jewelleryZakatable.value);
    }
    if (nisabMetal.present) {
      map['nisab_metal'] = Variable<String>(nisabMetal.value);
    }
    if (reminderOn.present) {
      map['reminder_on'] = Variable<bool>(reminderOn.value);
    }
    if (reminderDays.present) {
      map['reminder_days'] = Variable<int>(reminderDays.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    if (reminderAsked.present) {
      map['reminder_asked'] = Variable<bool>(reminderAsked.value);
    }
    if (givingRateView.present) {
      map['giving_rate_view'] = Variable<String>(givingRateView.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('homeInflation: $homeInflation, ')
          ..write('zakatYear: $zakatYear, ')
          ..write('longTermMethod: $longTermMethod, ')
          ..write('jewelleryZakatable: $jewelleryZakatable, ')
          ..write('nisabMetal: $nisabMetal, ')
          ..write('reminderOn: $reminderOn, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('reminderAsked: $reminderAsked, ')
          ..write('givingRateView: $givingRateView, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoZakatYearsTable extends NoZakatYears
    with TableInfo<$NoZakatYearsTable, NoZakatYearRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoZakatYearsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, year, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'no_zakat_years';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoZakatYearRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {year},
  ];
  @override
  NoZakatYearRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoZakatYearRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NoZakatYearsTable createAlias(String alias) {
    return $NoZakatYearsTable(attachedDatabase, alias);
  }
}

class NoZakatYearRow extends DataClass implements Insertable<NoZakatYearRow> {
  final String id;
  final int year;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoZakatYearRow({
    required this.id,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NoZakatYearsCompanion toCompanion(bool nullToAbsent) {
    return NoZakatYearsCompanion(
      id: Value(id),
      year: Value(year),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoZakatYearRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoZakatYearRow(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoZakatYearRow copyWith({
    String? id,
    int? year,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoZakatYearRow(
    id: id ?? this.id,
    year: year ?? this.year,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NoZakatYearRow copyWithCompanion(NoZakatYearsCompanion data) {
    return NoZakatYearRow(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoZakatYearRow(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, year, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoZakatYearRow &&
          other.id == this.id &&
          other.year == this.year &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NoZakatYearsCompanion extends UpdateCompanion<NoZakatYearRow> {
  final Value<String> id;
  final Value<int> year;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NoZakatYearsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoZakatYearsCompanion.insert({
    required String id,
    required int year,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NoZakatYearRow> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoZakatYearsCompanion copyWith({
    Value<String>? id,
    Value<int>? year,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NoZakatYearsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoZakatYearsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZakatCyclesTable extends ZakatCycles
    with TableInfo<$ZakatCyclesTable, ZakatCycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakatCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarMeta = const VerificationMeta(
    'calendar',
  );
  @override
  late final GeneratedColumn<String> calendar = GeneratedColumn<String>(
    'calendar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> fromDate =
      GeneratedColumn<String>(
        'from_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ZakatCyclesTable.$converterfromDate);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calendar,
    month,
    day,
    fromDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakat_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZakatCycleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('calendar')) {
      context.handle(
        _calendarMeta,
        calendar.isAcceptableOrUnknown(data['calendar']!, _calendarMeta),
      );
    } else if (isInserting) {
      context.missing(_calendarMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {fromDate},
  ];
  @override
  ZakatCycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakatCycleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      calendar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      )!,
      fromDate: $ZakatCyclesTable.$converterfromDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}from_date'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ZakatCyclesTable createAlias(String alias) {
    return $ZakatCyclesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterfromDate =
      const CalendarDateConverter();
}

class ZakatCycleRow extends DataClass implements Insertable<ZakatCycleRow> {
  final String id;
  final String calendar;
  final int month;
  final int day;
  final DateTime fromDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ZakatCycleRow({
    required this.id,
    required this.calendar,
    required this.month,
    required this.day,
    required this.fromDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['calendar'] = Variable<String>(calendar);
    map['month'] = Variable<int>(month);
    map['day'] = Variable<int>(day);
    {
      map['from_date'] = Variable<String>(
        $ZakatCyclesTable.$converterfromDate.toSql(fromDate),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ZakatCyclesCompanion toCompanion(bool nullToAbsent) {
    return ZakatCyclesCompanion(
      id: Value(id),
      calendar: Value(calendar),
      month: Value(month),
      day: Value(day),
      fromDate: Value(fromDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ZakatCycleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakatCycleRow(
      id: serializer.fromJson<String>(json['id']),
      calendar: serializer.fromJson<String>(json['calendar']),
      month: serializer.fromJson<int>(json['month']),
      day: serializer.fromJson<int>(json['day']),
      fromDate: serializer.fromJson<DateTime>(json['fromDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'calendar': serializer.toJson<String>(calendar),
      'month': serializer.toJson<int>(month),
      'day': serializer.toJson<int>(day),
      'fromDate': serializer.toJson<DateTime>(fromDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ZakatCycleRow copyWith({
    String? id,
    String? calendar,
    int? month,
    int? day,
    DateTime? fromDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ZakatCycleRow(
    id: id ?? this.id,
    calendar: calendar ?? this.calendar,
    month: month ?? this.month,
    day: day ?? this.day,
    fromDate: fromDate ?? this.fromDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ZakatCycleRow copyWithCompanion(ZakatCyclesCompanion data) {
    return ZakatCycleRow(
      id: data.id.present ? data.id.value : this.id,
      calendar: data.calendar.present ? data.calendar.value : this.calendar,
      month: data.month.present ? data.month.value : this.month,
      day: data.day.present ? data.day.value : this.day,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakatCycleRow(')
          ..write('id: $id, ')
          ..write('calendar: $calendar, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('fromDate: $fromDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, calendar, month, day, fromDate, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakatCycleRow &&
          other.id == this.id &&
          other.calendar == this.calendar &&
          other.month == this.month &&
          other.day == this.day &&
          other.fromDate == this.fromDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ZakatCyclesCompanion extends UpdateCompanion<ZakatCycleRow> {
  final Value<String> id;
  final Value<String> calendar;
  final Value<int> month;
  final Value<int> day;
  final Value<DateTime> fromDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ZakatCyclesCompanion({
    this.id = const Value.absent(),
    this.calendar = const Value.absent(),
    this.month = const Value.absent(),
    this.day = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZakatCyclesCompanion.insert({
    required String id,
    required String calendar,
    required int month,
    required int day,
    required DateTime fromDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       calendar = Value(calendar),
       month = Value(month),
       day = Value(day),
       fromDate = Value(fromDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ZakatCycleRow> custom({
    Expression<String>? id,
    Expression<String>? calendar,
    Expression<int>? month,
    Expression<int>? day,
    Expression<String>? fromDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calendar != null) 'calendar': calendar,
      if (month != null) 'month': month,
      if (day != null) 'day': day,
      if (fromDate != null) 'from_date': fromDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZakatCyclesCompanion copyWith({
    Value<String>? id,
    Value<String>? calendar,
    Value<int>? month,
    Value<int>? day,
    Value<DateTime>? fromDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ZakatCyclesCompanion(
      id: id ?? this.id,
      calendar: calendar ?? this.calendar,
      month: month ?? this.month,
      day: day ?? this.day,
      fromDate: fromDate ?? this.fromDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (calendar.present) {
      map['calendar'] = Variable<String>(calendar.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (fromDate.present) {
      map['from_date'] = Variable<String>(
        $ZakatCyclesTable.$converterfromDate.toSql(fromDate.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakatCyclesCompanion(')
          ..write('id: $id, ')
          ..write('calendar: $calendar, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('fromDate: $fromDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZakatYearsTable extends ZakatYears
    with TableInfo<$ZakatYearsTable, ZakatYearRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakatYearsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> dueKey =
      GeneratedColumn<String>(
        'due_key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ZakatYearsTable.$converterdueKey);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> movedDue =
      GeneratedColumn<String>(
        'moved_due',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ZakatYearsTable.$convertermovedDuen);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> debts =
      GeneratedColumn<String>(
        'debts',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('0'),
      ).withConverter<Decimal>($ZakatYearsTable.$converterdebts);
  static const VerificationMeta _deductDebtsMeta = const VerificationMeta(
    'deductDebts',
  );
  @override
  late final GeneratedColumn<bool> deductDebts = GeneratedColumn<bool>(
    'deduct_debts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deduct_debts" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> startedOn =
      GeneratedColumn<String>(
        'started_on',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ZakatYearsTable.$converterstartedOnn);
  static const VerificationMeta _frozenBaseMeta = const VerificationMeta(
    'frozenBase',
  );
  @override
  late final GeneratedColumn<String> frozenBase = GeneratedColumn<String>(
    'frozen_base',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frozenNisabMetalMeta = const VerificationMeta(
    'frozenNisabMetal',
  );
  @override
  late final GeneratedColumn<String> frozenNisabMetal = GeneratedColumn<String>(
    'frozen_nisab_metal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String>
  frozenMetalRate = GeneratedColumn<String>(
    'frozen_metal_rate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Decimal?>($ZakatYearsTable.$converterfrozenMetalRaten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String>
  frozenMetalRateDate = GeneratedColumn<String>(
    'frozen_metal_rate_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($ZakatYearsTable.$converterfrozenMetalRateDaten);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dueKey,
    movedDue,
    debts,
    deductDebts,
    startedOn,
    frozenBase,
    frozenNisabMetal,
    frozenMetalRate,
    frozenMetalRateDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakat_years';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZakatYearRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deduct_debts')) {
      context.handle(
        _deductDebtsMeta,
        deductDebts.isAcceptableOrUnknown(
          data['deduct_debts']!,
          _deductDebtsMeta,
        ),
      );
    }
    if (data.containsKey('frozen_base')) {
      context.handle(
        _frozenBaseMeta,
        frozenBase.isAcceptableOrUnknown(data['frozen_base']!, _frozenBaseMeta),
      );
    }
    if (data.containsKey('frozen_nisab_metal')) {
      context.handle(
        _frozenNisabMetalMeta,
        frozenNisabMetal.isAcceptableOrUnknown(
          data['frozen_nisab_metal']!,
          _frozenNisabMetalMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {dueKey},
  ];
  @override
  ZakatYearRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakatYearRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dueKey: $ZakatYearsTable.$converterdueKey.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}due_key'],
        )!,
      ),
      movedDue: $ZakatYearsTable.$convertermovedDuen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}moved_due'],
        ),
      ),
      debts: $ZakatYearsTable.$converterdebts.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}debts'],
        )!,
      ),
      deductDebts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deduct_debts'],
      )!,
      startedOn: $ZakatYearsTable.$converterstartedOnn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}started_on'],
        ),
      ),
      frozenBase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frozen_base'],
      ),
      frozenNisabMetal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frozen_nisab_metal'],
      ),
      frozenMetalRate: $ZakatYearsTable.$converterfrozenMetalRaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frozen_metal_rate'],
        ),
      ),
      frozenMetalRateDate: $ZakatYearsTable.$converterfrozenMetalRateDaten
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}frozen_metal_rate_date'],
            ),
          ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ZakatYearsTable createAlias(String alias) {
    return $ZakatYearsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdueKey =
      const CalendarDateConverter();
  static TypeConverter<DateTime, String> $convertermovedDue =
      const CalendarDateConverter();
  static TypeConverter<DateTime?, String?> $convertermovedDuen =
      NullAwareTypeConverter.wrap($convertermovedDue);
  static TypeConverter<Decimal, String> $converterdebts =
      const DecimalConverter();
  static TypeConverter<DateTime, String> $converterstartedOn =
      const CalendarDateConverter();
  static TypeConverter<DateTime?, String?> $converterstartedOnn =
      NullAwareTypeConverter.wrap($converterstartedOn);
  static TypeConverter<Decimal, String> $converterfrozenMetalRate =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterfrozenMetalRaten =
      NullAwareTypeConverter.wrap($converterfrozenMetalRate);
  static TypeConverter<DateTime, String> $converterfrozenMetalRateDate =
      const CalendarDateConverter();
  static TypeConverter<DateTime?, String?> $converterfrozenMetalRateDaten =
      NullAwareTypeConverter.wrap($converterfrozenMetalRateDate);
}

class ZakatYearRow extends DataClass implements Insertable<ZakatYearRow> {
  final String id;

  /// The computed due date (Z4); a moved due date never changes it.
  final DateTime dueKey;
  final DateTime? movedDue;
  final Decimal debts;
  final bool deductDebts;
  final DateTime? startedOn;
  final String? frozenBase;
  final String? frozenNisabMetal;
  final Decimal? frozenMetalRate;
  final DateTime? frozenMetalRateDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ZakatYearRow({
    required this.id,
    required this.dueKey,
    this.movedDue,
    required this.debts,
    required this.deductDebts,
    this.startedOn,
    this.frozenBase,
    this.frozenNisabMetal,
    this.frozenMetalRate,
    this.frozenMetalRateDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['due_key'] = Variable<String>(
        $ZakatYearsTable.$converterdueKey.toSql(dueKey),
      );
    }
    if (!nullToAbsent || movedDue != null) {
      map['moved_due'] = Variable<String>(
        $ZakatYearsTable.$convertermovedDuen.toSql(movedDue),
      );
    }
    {
      map['debts'] = Variable<String>(
        $ZakatYearsTable.$converterdebts.toSql(debts),
      );
    }
    map['deduct_debts'] = Variable<bool>(deductDebts);
    if (!nullToAbsent || startedOn != null) {
      map['started_on'] = Variable<String>(
        $ZakatYearsTable.$converterstartedOnn.toSql(startedOn),
      );
    }
    if (!nullToAbsent || frozenBase != null) {
      map['frozen_base'] = Variable<String>(frozenBase);
    }
    if (!nullToAbsent || frozenNisabMetal != null) {
      map['frozen_nisab_metal'] = Variable<String>(frozenNisabMetal);
    }
    if (!nullToAbsent || frozenMetalRate != null) {
      map['frozen_metal_rate'] = Variable<String>(
        $ZakatYearsTable.$converterfrozenMetalRaten.toSql(frozenMetalRate),
      );
    }
    if (!nullToAbsent || frozenMetalRateDate != null) {
      map['frozen_metal_rate_date'] = Variable<String>(
        $ZakatYearsTable.$converterfrozenMetalRateDaten.toSql(
          frozenMetalRateDate,
        ),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ZakatYearsCompanion toCompanion(bool nullToAbsent) {
    return ZakatYearsCompanion(
      id: Value(id),
      dueKey: Value(dueKey),
      movedDue: movedDue == null && nullToAbsent
          ? const Value.absent()
          : Value(movedDue),
      debts: Value(debts),
      deductDebts: Value(deductDebts),
      startedOn: startedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(startedOn),
      frozenBase: frozenBase == null && nullToAbsent
          ? const Value.absent()
          : Value(frozenBase),
      frozenNisabMetal: frozenNisabMetal == null && nullToAbsent
          ? const Value.absent()
          : Value(frozenNisabMetal),
      frozenMetalRate: frozenMetalRate == null && nullToAbsent
          ? const Value.absent()
          : Value(frozenMetalRate),
      frozenMetalRateDate: frozenMetalRateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(frozenMetalRateDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ZakatYearRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakatYearRow(
      id: serializer.fromJson<String>(json['id']),
      dueKey: serializer.fromJson<DateTime>(json['dueKey']),
      movedDue: serializer.fromJson<DateTime?>(json['movedDue']),
      debts: serializer.fromJson<Decimal>(json['debts']),
      deductDebts: serializer.fromJson<bool>(json['deductDebts']),
      startedOn: serializer.fromJson<DateTime?>(json['startedOn']),
      frozenBase: serializer.fromJson<String?>(json['frozenBase']),
      frozenNisabMetal: serializer.fromJson<String?>(json['frozenNisabMetal']),
      frozenMetalRate: serializer.fromJson<Decimal?>(json['frozenMetalRate']),
      frozenMetalRateDate: serializer.fromJson<DateTime?>(
        json['frozenMetalRateDate'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dueKey': serializer.toJson<DateTime>(dueKey),
      'movedDue': serializer.toJson<DateTime?>(movedDue),
      'debts': serializer.toJson<Decimal>(debts),
      'deductDebts': serializer.toJson<bool>(deductDebts),
      'startedOn': serializer.toJson<DateTime?>(startedOn),
      'frozenBase': serializer.toJson<String?>(frozenBase),
      'frozenNisabMetal': serializer.toJson<String?>(frozenNisabMetal),
      'frozenMetalRate': serializer.toJson<Decimal?>(frozenMetalRate),
      'frozenMetalRateDate': serializer.toJson<DateTime?>(frozenMetalRateDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ZakatYearRow copyWith({
    String? id,
    DateTime? dueKey,
    Value<DateTime?> movedDue = const Value.absent(),
    Decimal? debts,
    bool? deductDebts,
    Value<DateTime?> startedOn = const Value.absent(),
    Value<String?> frozenBase = const Value.absent(),
    Value<String?> frozenNisabMetal = const Value.absent(),
    Value<Decimal?> frozenMetalRate = const Value.absent(),
    Value<DateTime?> frozenMetalRateDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ZakatYearRow(
    id: id ?? this.id,
    dueKey: dueKey ?? this.dueKey,
    movedDue: movedDue.present ? movedDue.value : this.movedDue,
    debts: debts ?? this.debts,
    deductDebts: deductDebts ?? this.deductDebts,
    startedOn: startedOn.present ? startedOn.value : this.startedOn,
    frozenBase: frozenBase.present ? frozenBase.value : this.frozenBase,
    frozenNisabMetal: frozenNisabMetal.present
        ? frozenNisabMetal.value
        : this.frozenNisabMetal,
    frozenMetalRate: frozenMetalRate.present
        ? frozenMetalRate.value
        : this.frozenMetalRate,
    frozenMetalRateDate: frozenMetalRateDate.present
        ? frozenMetalRateDate.value
        : this.frozenMetalRateDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ZakatYearRow copyWithCompanion(ZakatYearsCompanion data) {
    return ZakatYearRow(
      id: data.id.present ? data.id.value : this.id,
      dueKey: data.dueKey.present ? data.dueKey.value : this.dueKey,
      movedDue: data.movedDue.present ? data.movedDue.value : this.movedDue,
      debts: data.debts.present ? data.debts.value : this.debts,
      deductDebts: data.deductDebts.present
          ? data.deductDebts.value
          : this.deductDebts,
      startedOn: data.startedOn.present ? data.startedOn.value : this.startedOn,
      frozenBase: data.frozenBase.present
          ? data.frozenBase.value
          : this.frozenBase,
      frozenNisabMetal: data.frozenNisabMetal.present
          ? data.frozenNisabMetal.value
          : this.frozenNisabMetal,
      frozenMetalRate: data.frozenMetalRate.present
          ? data.frozenMetalRate.value
          : this.frozenMetalRate,
      frozenMetalRateDate: data.frozenMetalRateDate.present
          ? data.frozenMetalRateDate.value
          : this.frozenMetalRateDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakatYearRow(')
          ..write('id: $id, ')
          ..write('dueKey: $dueKey, ')
          ..write('movedDue: $movedDue, ')
          ..write('debts: $debts, ')
          ..write('deductDebts: $deductDebts, ')
          ..write('startedOn: $startedOn, ')
          ..write('frozenBase: $frozenBase, ')
          ..write('frozenNisabMetal: $frozenNisabMetal, ')
          ..write('frozenMetalRate: $frozenMetalRate, ')
          ..write('frozenMetalRateDate: $frozenMetalRateDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dueKey,
    movedDue,
    debts,
    deductDebts,
    startedOn,
    frozenBase,
    frozenNisabMetal,
    frozenMetalRate,
    frozenMetalRateDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakatYearRow &&
          other.id == this.id &&
          other.dueKey == this.dueKey &&
          other.movedDue == this.movedDue &&
          other.debts == this.debts &&
          other.deductDebts == this.deductDebts &&
          other.startedOn == this.startedOn &&
          other.frozenBase == this.frozenBase &&
          other.frozenNisabMetal == this.frozenNisabMetal &&
          other.frozenMetalRate == this.frozenMetalRate &&
          other.frozenMetalRateDate == this.frozenMetalRateDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ZakatYearsCompanion extends UpdateCompanion<ZakatYearRow> {
  final Value<String> id;
  final Value<DateTime> dueKey;
  final Value<DateTime?> movedDue;
  final Value<Decimal> debts;
  final Value<bool> deductDebts;
  final Value<DateTime?> startedOn;
  final Value<String?> frozenBase;
  final Value<String?> frozenNisabMetal;
  final Value<Decimal?> frozenMetalRate;
  final Value<DateTime?> frozenMetalRateDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ZakatYearsCompanion({
    this.id = const Value.absent(),
    this.dueKey = const Value.absent(),
    this.movedDue = const Value.absent(),
    this.debts = const Value.absent(),
    this.deductDebts = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.frozenBase = const Value.absent(),
    this.frozenNisabMetal = const Value.absent(),
    this.frozenMetalRate = const Value.absent(),
    this.frozenMetalRateDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZakatYearsCompanion.insert({
    required String id,
    required DateTime dueKey,
    this.movedDue = const Value.absent(),
    this.debts = const Value.absent(),
    this.deductDebts = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.frozenBase = const Value.absent(),
    this.frozenNisabMetal = const Value.absent(),
    this.frozenMetalRate = const Value.absent(),
    this.frozenMetalRateDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dueKey = Value(dueKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ZakatYearRow> custom({
    Expression<String>? id,
    Expression<String>? dueKey,
    Expression<String>? movedDue,
    Expression<String>? debts,
    Expression<bool>? deductDebts,
    Expression<String>? startedOn,
    Expression<String>? frozenBase,
    Expression<String>? frozenNisabMetal,
    Expression<String>? frozenMetalRate,
    Expression<String>? frozenMetalRateDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dueKey != null) 'due_key': dueKey,
      if (movedDue != null) 'moved_due': movedDue,
      if (debts != null) 'debts': debts,
      if (deductDebts != null) 'deduct_debts': deductDebts,
      if (startedOn != null) 'started_on': startedOn,
      if (frozenBase != null) 'frozen_base': frozenBase,
      if (frozenNisabMetal != null) 'frozen_nisab_metal': frozenNisabMetal,
      if (frozenMetalRate != null) 'frozen_metal_rate': frozenMetalRate,
      if (frozenMetalRateDate != null)
        'frozen_metal_rate_date': frozenMetalRateDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZakatYearsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? dueKey,
    Value<DateTime?>? movedDue,
    Value<Decimal>? debts,
    Value<bool>? deductDebts,
    Value<DateTime?>? startedOn,
    Value<String?>? frozenBase,
    Value<String?>? frozenNisabMetal,
    Value<Decimal?>? frozenMetalRate,
    Value<DateTime?>? frozenMetalRateDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ZakatYearsCompanion(
      id: id ?? this.id,
      dueKey: dueKey ?? this.dueKey,
      movedDue: movedDue ?? this.movedDue,
      debts: debts ?? this.debts,
      deductDebts: deductDebts ?? this.deductDebts,
      startedOn: startedOn ?? this.startedOn,
      frozenBase: frozenBase ?? this.frozenBase,
      frozenNisabMetal: frozenNisabMetal ?? this.frozenNisabMetal,
      frozenMetalRate: frozenMetalRate ?? this.frozenMetalRate,
      frozenMetalRateDate: frozenMetalRateDate ?? this.frozenMetalRateDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dueKey.present) {
      map['due_key'] = Variable<String>(
        $ZakatYearsTable.$converterdueKey.toSql(dueKey.value),
      );
    }
    if (movedDue.present) {
      map['moved_due'] = Variable<String>(
        $ZakatYearsTable.$convertermovedDuen.toSql(movedDue.value),
      );
    }
    if (debts.present) {
      map['debts'] = Variable<String>(
        $ZakatYearsTable.$converterdebts.toSql(debts.value),
      );
    }
    if (deductDebts.present) {
      map['deduct_debts'] = Variable<bool>(deductDebts.value);
    }
    if (startedOn.present) {
      map['started_on'] = Variable<String>(
        $ZakatYearsTable.$converterstartedOnn.toSql(startedOn.value),
      );
    }
    if (frozenBase.present) {
      map['frozen_base'] = Variable<String>(frozenBase.value);
    }
    if (frozenNisabMetal.present) {
      map['frozen_nisab_metal'] = Variable<String>(frozenNisabMetal.value);
    }
    if (frozenMetalRate.present) {
      map['frozen_metal_rate'] = Variable<String>(
        $ZakatYearsTable.$converterfrozenMetalRaten.toSql(
          frozenMetalRate.value,
        ),
      );
    }
    if (frozenMetalRateDate.present) {
      map['frozen_metal_rate_date'] = Variable<String>(
        $ZakatYearsTable.$converterfrozenMetalRateDaten.toSql(
          frozenMetalRateDate.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakatYearsCompanion(')
          ..write('id: $id, ')
          ..write('dueKey: $dueKey, ')
          ..write('movedDue: $movedDue, ')
          ..write('debts: $debts, ')
          ..write('deductDebts: $deductDebts, ')
          ..write('startedOn: $startedOn, ')
          ..write('frozenBase: $frozenBase, ')
          ..write('frozenNisabMetal: $frozenNisabMetal, ')
          ..write('frozenMetalRate: $frozenMetalRate, ')
          ..write('frozenMetalRateDate: $frozenMetalRateDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZakatExtraLinesTable extends ZakatExtraLines
    with TableInfo<$ZakatExtraLinesTable, ZakatExtraLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakatExtraLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<String> yearId = GeneratedColumn<String>(
    'year_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zakat_years (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> amount =
      GeneratedColumn<String>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($ZakatExtraLinesTable.$converteramount);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goodDebtConfirmedMeta = const VerificationMeta(
    'goodDebtConfirmed',
  );
  @override
  late final GeneratedColumn<bool> goodDebtConfirmed = GeneratedColumn<bool>(
    'good_debt_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("good_debt_confirmed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    yearId,
    label,
    kind,
    amount,
    unit,
    goodDebtConfirmed,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakat_extra_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZakatExtraLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    } else if (isInserting) {
      context.missing(_yearIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('good_debt_confirmed')) {
      context.handle(
        _goodDebtConfirmedMeta,
        goodDebtConfirmed.isAcceptableOrUnknown(
          data['good_debt_confirmed']!,
          _goodDebtConfirmedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_goodDebtConfirmedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZakatExtraLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakatExtraLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amount: $ZakatExtraLinesTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amount'],
        )!,
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      goodDebtConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}good_debt_confirmed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ZakatExtraLinesTable createAlias(String alias) {
    return $ZakatExtraLinesTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $converteramount =
      const DecimalConverter();
}

class ZakatExtraLineRow extends DataClass
    implements Insertable<ZakatExtraLineRow> {
  final String id;
  final String yearId;
  final String label;

  /// cash or owedToMe
  final String kind;
  final Decimal amount;
  final String unit;
  final bool goodDebtConfirmed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ZakatExtraLineRow({
    required this.id,
    required this.yearId,
    required this.label,
    required this.kind,
    required this.amount,
    required this.unit,
    required this.goodDebtConfirmed,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year_id'] = Variable<String>(yearId);
    map['label'] = Variable<String>(label);
    map['kind'] = Variable<String>(kind);
    {
      map['amount'] = Variable<String>(
        $ZakatExtraLinesTable.$converteramount.toSql(amount),
      );
    }
    map['unit'] = Variable<String>(unit);
    map['good_debt_confirmed'] = Variable<bool>(goodDebtConfirmed);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ZakatExtraLinesCompanion toCompanion(bool nullToAbsent) {
    return ZakatExtraLinesCompanion(
      id: Value(id),
      yearId: Value(yearId),
      label: Value(label),
      kind: Value(kind),
      amount: Value(amount),
      unit: Value(unit),
      goodDebtConfirmed: Value(goodDebtConfirmed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ZakatExtraLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakatExtraLineRow(
      id: serializer.fromJson<String>(json['id']),
      yearId: serializer.fromJson<String>(json['yearId']),
      label: serializer.fromJson<String>(json['label']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<Decimal>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      goodDebtConfirmed: serializer.fromJson<bool>(json['goodDebtConfirmed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'yearId': serializer.toJson<String>(yearId),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<Decimal>(amount),
      'unit': serializer.toJson<String>(unit),
      'goodDebtConfirmed': serializer.toJson<bool>(goodDebtConfirmed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ZakatExtraLineRow copyWith({
    String? id,
    String? yearId,
    String? label,
    String? kind,
    Decimal? amount,
    String? unit,
    bool? goodDebtConfirmed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ZakatExtraLineRow(
    id: id ?? this.id,
    yearId: yearId ?? this.yearId,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    goodDebtConfirmed: goodDebtConfirmed ?? this.goodDebtConfirmed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ZakatExtraLineRow copyWithCompanion(ZakatExtraLinesCompanion data) {
    return ZakatExtraLineRow(
      id: data.id.present ? data.id.value : this.id,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      goodDebtConfirmed: data.goodDebtConfirmed.present
          ? data.goodDebtConfirmed.value
          : this.goodDebtConfirmed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakatExtraLineRow(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('goodDebtConfirmed: $goodDebtConfirmed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    yearId,
    label,
    kind,
    amount,
    unit,
    goodDebtConfirmed,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakatExtraLineRow &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.goodDebtConfirmed == this.goodDebtConfirmed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ZakatExtraLinesCompanion extends UpdateCompanion<ZakatExtraLineRow> {
  final Value<String> id;
  final Value<String> yearId;
  final Value<String> label;
  final Value<String> kind;
  final Value<Decimal> amount;
  final Value<String> unit;
  final Value<bool> goodDebtConfirmed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ZakatExtraLinesCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.goodDebtConfirmed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZakatExtraLinesCompanion.insert({
    required String id,
    required String yearId,
    required String label,
    required String kind,
    required Decimal amount,
    required String unit,
    required bool goodDebtConfirmed,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       yearId = Value(yearId),
       label = Value(label),
       kind = Value(kind),
       amount = Value(amount),
       unit = Value(unit),
       goodDebtConfirmed = Value(goodDebtConfirmed),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ZakatExtraLineRow> custom({
    Expression<String>? id,
    Expression<String>? yearId,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<String>? amount,
    Expression<String>? unit,
    Expression<bool>? goodDebtConfirmed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (goodDebtConfirmed != null) 'good_debt_confirmed': goodDebtConfirmed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZakatExtraLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? yearId,
    Value<String>? label,
    Value<String>? kind,
    Value<Decimal>? amount,
    Value<String>? unit,
    Value<bool>? goodDebtConfirmed,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ZakatExtraLinesCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      goodDebtConfirmed: goodDebtConfirmed ?? this.goodDebtConfirmed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<String>(yearId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(
        $ZakatExtraLinesTable.$converteramount.toSql(amount.value),
      );
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (goodDebtConfirmed.present) {
      map['good_debt_confirmed'] = Variable<bool>(goodDebtConfirmed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakatExtraLinesCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('goodDebtConfirmed: $goodDebtConfirmed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZakatFrozenLinesTable extends ZakatFrozenLines
    with TableInfo<$ZakatFrozenLinesTable, ZakatFrozenLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakatFrozenLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<String> yearId = GeneratedColumn<String>(
    'year_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zakat_years (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> value =
      GeneratedColumn<String>(
        'value',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($ZakatFrozenLinesTable.$convertervalue);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> heldInterest =
      GeneratedColumn<String>(
        'held_interest',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($ZakatFrozenLinesTable.$converterheldInterest);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> valueDate =
      GeneratedColumn<String>(
        'value_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ZakatFrozenLinesTable.$convertervalueDaten);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> rate =
      GeneratedColumn<String>(
        'rate',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($ZakatFrozenLinesTable.$converterraten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> rateDate =
      GeneratedColumn<String>(
        'rate_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ZakatFrozenLinesTable.$converterrateDaten);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> share =
      GeneratedColumn<String>(
        'share',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($ZakatFrozenLinesTable.$convertershare);
  static const VerificationMeta _sectionMeta = const VerificationMeta(
    'section',
  );
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noticeMeta = const VerificationMeta('notice');
  @override
  late final GeneratedColumn<String> notice = GeneratedColumn<String>(
    'notice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extraKindMeta = const VerificationMeta(
    'extraKind',
  );
  @override
  late final GeneratedColumn<String> extraKind = GeneratedColumn<String>(
    'extra_kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    yearId,
    position,
    source,
    refId,
    name,
    unit,
    value,
    heldInterest,
    valueDate,
    rate,
    rateDate,
    share,
    section,
    notice,
    extraKind,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakat_frozen_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZakatFrozenLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    } else if (isInserting) {
      context.missing(_yearIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('section')) {
      context.handle(
        _sectionMeta,
        section.isAcceptableOrUnknown(data['section']!, _sectionMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('notice')) {
      context.handle(
        _noticeMeta,
        notice.isAcceptableOrUnknown(data['notice']!, _noticeMeta),
      );
    }
    if (data.containsKey('extra_kind')) {
      context.handle(
        _extraKindMeta,
        extraKind.isAcceptableOrUnknown(data['extra_kind']!, _extraKindMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZakatFrozenLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakatFrozenLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      value: $ZakatFrozenLinesTable.$convertervalue.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}value'],
        )!,
      ),
      heldInterest: $ZakatFrozenLinesTable.$converterheldInterest.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}held_interest'],
        )!,
      ),
      valueDate: $ZakatFrozenLinesTable.$convertervalueDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}value_date'],
        ),
      ),
      rate: $ZakatFrozenLinesTable.$converterraten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rate'],
        ),
      ),
      rateDate: $ZakatFrozenLinesTable.$converterrateDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rate_date'],
        ),
      ),
      share: $ZakatFrozenLinesTable.$convertershare.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}share'],
        )!,
      ),
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      )!,
      notice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notice'],
      ),
      extraKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_kind'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ZakatFrozenLinesTable createAlias(String alias) {
    return $ZakatFrozenLinesTable(attachedDatabase, alias);
  }

  static TypeConverter<Decimal, String> $convertervalue =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterheldInterest =
      const DecimalConverter();
  static TypeConverter<DateTime, String> $convertervalueDate =
      const CalendarDateConverter();
  static TypeConverter<DateTime?, String?> $convertervalueDaten =
      NullAwareTypeConverter.wrap($convertervalueDate);
  static TypeConverter<Decimal, String> $converterrate =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterraten =
      NullAwareTypeConverter.wrap($converterrate);
  static TypeConverter<DateTime, String> $converterrateDate =
      const CalendarDateConverter();
  static TypeConverter<DateTime?, String?> $converterrateDaten =
      NullAwareTypeConverter.wrap($converterrateDate);
  static TypeConverter<Decimal, String> $convertershare =
      const DecimalConverter();
}

class ZakatFrozenLineRow extends DataClass
    implements Insertable<ZakatFrozenLineRow> {
  final String id;
  final String yearId;
  final int position;

  /// item or extra
  final String source;

  /// The investment or extra-line id.
  final String? refId;
  final String name;
  final String unit;
  final Decimal value;
  final Decimal heldInterest;
  final DateTime? valueDate;
  final Decimal? rate;
  final DateTime? rateDate;
  final Decimal share;
  final String section;
  final String? notice;
  final String? extraKind;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ZakatFrozenLineRow({
    required this.id,
    required this.yearId,
    required this.position,
    required this.source,
    this.refId,
    required this.name,
    required this.unit,
    required this.value,
    required this.heldInterest,
    this.valueDate,
    this.rate,
    this.rateDate,
    required this.share,
    required this.section,
    this.notice,
    this.extraKind,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year_id'] = Variable<String>(yearId);
    map['position'] = Variable<int>(position);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    {
      map['value'] = Variable<String>(
        $ZakatFrozenLinesTable.$convertervalue.toSql(value),
      );
    }
    {
      map['held_interest'] = Variable<String>(
        $ZakatFrozenLinesTable.$converterheldInterest.toSql(heldInterest),
      );
    }
    if (!nullToAbsent || valueDate != null) {
      map['value_date'] = Variable<String>(
        $ZakatFrozenLinesTable.$convertervalueDaten.toSql(valueDate),
      );
    }
    if (!nullToAbsent || rate != null) {
      map['rate'] = Variable<String>(
        $ZakatFrozenLinesTable.$converterraten.toSql(rate),
      );
    }
    if (!nullToAbsent || rateDate != null) {
      map['rate_date'] = Variable<String>(
        $ZakatFrozenLinesTable.$converterrateDaten.toSql(rateDate),
      );
    }
    {
      map['share'] = Variable<String>(
        $ZakatFrozenLinesTable.$convertershare.toSql(share),
      );
    }
    map['section'] = Variable<String>(section);
    if (!nullToAbsent || notice != null) {
      map['notice'] = Variable<String>(notice);
    }
    if (!nullToAbsent || extraKind != null) {
      map['extra_kind'] = Variable<String>(extraKind);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ZakatFrozenLinesCompanion toCompanion(bool nullToAbsent) {
    return ZakatFrozenLinesCompanion(
      id: Value(id),
      yearId: Value(yearId),
      position: Value(position),
      source: Value(source),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
      name: Value(name),
      unit: Value(unit),
      value: Value(value),
      heldInterest: Value(heldInterest),
      valueDate: valueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(valueDate),
      rate: rate == null && nullToAbsent ? const Value.absent() : Value(rate),
      rateDate: rateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(rateDate),
      share: Value(share),
      section: Value(section),
      notice: notice == null && nullToAbsent
          ? const Value.absent()
          : Value(notice),
      extraKind: extraKind == null && nullToAbsent
          ? const Value.absent()
          : Value(extraKind),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ZakatFrozenLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakatFrozenLineRow(
      id: serializer.fromJson<String>(json['id']),
      yearId: serializer.fromJson<String>(json['yearId']),
      position: serializer.fromJson<int>(json['position']),
      source: serializer.fromJson<String>(json['source']),
      refId: serializer.fromJson<String?>(json['refId']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      value: serializer.fromJson<Decimal>(json['value']),
      heldInterest: serializer.fromJson<Decimal>(json['heldInterest']),
      valueDate: serializer.fromJson<DateTime?>(json['valueDate']),
      rate: serializer.fromJson<Decimal?>(json['rate']),
      rateDate: serializer.fromJson<DateTime?>(json['rateDate']),
      share: serializer.fromJson<Decimal>(json['share']),
      section: serializer.fromJson<String>(json['section']),
      notice: serializer.fromJson<String?>(json['notice']),
      extraKind: serializer.fromJson<String?>(json['extraKind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'yearId': serializer.toJson<String>(yearId),
      'position': serializer.toJson<int>(position),
      'source': serializer.toJson<String>(source),
      'refId': serializer.toJson<String?>(refId),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'value': serializer.toJson<Decimal>(value),
      'heldInterest': serializer.toJson<Decimal>(heldInterest),
      'valueDate': serializer.toJson<DateTime?>(valueDate),
      'rate': serializer.toJson<Decimal?>(rate),
      'rateDate': serializer.toJson<DateTime?>(rateDate),
      'share': serializer.toJson<Decimal>(share),
      'section': serializer.toJson<String>(section),
      'notice': serializer.toJson<String?>(notice),
      'extraKind': serializer.toJson<String?>(extraKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ZakatFrozenLineRow copyWith({
    String? id,
    String? yearId,
    int? position,
    String? source,
    Value<String?> refId = const Value.absent(),
    String? name,
    String? unit,
    Decimal? value,
    Decimal? heldInterest,
    Value<DateTime?> valueDate = const Value.absent(),
    Value<Decimal?> rate = const Value.absent(),
    Value<DateTime?> rateDate = const Value.absent(),
    Decimal? share,
    String? section,
    Value<String?> notice = const Value.absent(),
    Value<String?> extraKind = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ZakatFrozenLineRow(
    id: id ?? this.id,
    yearId: yearId ?? this.yearId,
    position: position ?? this.position,
    source: source ?? this.source,
    refId: refId.present ? refId.value : this.refId,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    value: value ?? this.value,
    heldInterest: heldInterest ?? this.heldInterest,
    valueDate: valueDate.present ? valueDate.value : this.valueDate,
    rate: rate.present ? rate.value : this.rate,
    rateDate: rateDate.present ? rateDate.value : this.rateDate,
    share: share ?? this.share,
    section: section ?? this.section,
    notice: notice.present ? notice.value : this.notice,
    extraKind: extraKind.present ? extraKind.value : this.extraKind,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ZakatFrozenLineRow copyWithCompanion(ZakatFrozenLinesCompanion data) {
    return ZakatFrozenLineRow(
      id: data.id.present ? data.id.value : this.id,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      position: data.position.present ? data.position.value : this.position,
      source: data.source.present ? data.source.value : this.source,
      refId: data.refId.present ? data.refId.value : this.refId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      value: data.value.present ? data.value.value : this.value,
      heldInterest: data.heldInterest.present
          ? data.heldInterest.value
          : this.heldInterest,
      valueDate: data.valueDate.present ? data.valueDate.value : this.valueDate,
      rate: data.rate.present ? data.rate.value : this.rate,
      rateDate: data.rateDate.present ? data.rateDate.value : this.rateDate,
      share: data.share.present ? data.share.value : this.share,
      section: data.section.present ? data.section.value : this.section,
      notice: data.notice.present ? data.notice.value : this.notice,
      extraKind: data.extraKind.present ? data.extraKind.value : this.extraKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakatFrozenLineRow(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('position: $position, ')
          ..write('source: $source, ')
          ..write('refId: $refId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('value: $value, ')
          ..write('heldInterest: $heldInterest, ')
          ..write('valueDate: $valueDate, ')
          ..write('rate: $rate, ')
          ..write('rateDate: $rateDate, ')
          ..write('share: $share, ')
          ..write('section: $section, ')
          ..write('notice: $notice, ')
          ..write('extraKind: $extraKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    yearId,
    position,
    source,
    refId,
    name,
    unit,
    value,
    heldInterest,
    valueDate,
    rate,
    rateDate,
    share,
    section,
    notice,
    extraKind,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakatFrozenLineRow &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.position == this.position &&
          other.source == this.source &&
          other.refId == this.refId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.value == this.value &&
          other.heldInterest == this.heldInterest &&
          other.valueDate == this.valueDate &&
          other.rate == this.rate &&
          other.rateDate == this.rateDate &&
          other.share == this.share &&
          other.section == this.section &&
          other.notice == this.notice &&
          other.extraKind == this.extraKind &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ZakatFrozenLinesCompanion extends UpdateCompanion<ZakatFrozenLineRow> {
  final Value<String> id;
  final Value<String> yearId;
  final Value<int> position;
  final Value<String> source;
  final Value<String?> refId;
  final Value<String> name;
  final Value<String> unit;
  final Value<Decimal> value;
  final Value<Decimal> heldInterest;
  final Value<DateTime?> valueDate;
  final Value<Decimal?> rate;
  final Value<DateTime?> rateDate;
  final Value<Decimal> share;
  final Value<String> section;
  final Value<String?> notice;
  final Value<String?> extraKind;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ZakatFrozenLinesCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.position = const Value.absent(),
    this.source = const Value.absent(),
    this.refId = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.value = const Value.absent(),
    this.heldInterest = const Value.absent(),
    this.valueDate = const Value.absent(),
    this.rate = const Value.absent(),
    this.rateDate = const Value.absent(),
    this.share = const Value.absent(),
    this.section = const Value.absent(),
    this.notice = const Value.absent(),
    this.extraKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZakatFrozenLinesCompanion.insert({
    required String id,
    required String yearId,
    required int position,
    required String source,
    this.refId = const Value.absent(),
    required String name,
    required String unit,
    required Decimal value,
    required Decimal heldInterest,
    this.valueDate = const Value.absent(),
    this.rate = const Value.absent(),
    this.rateDate = const Value.absent(),
    required Decimal share,
    required String section,
    this.notice = const Value.absent(),
    this.extraKind = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       yearId = Value(yearId),
       position = Value(position),
       source = Value(source),
       name = Value(name),
       unit = Value(unit),
       value = Value(value),
       heldInterest = Value(heldInterest),
       share = Value(share),
       section = Value(section),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ZakatFrozenLineRow> custom({
    Expression<String>? id,
    Expression<String>? yearId,
    Expression<int>? position,
    Expression<String>? source,
    Expression<String>? refId,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<String>? value,
    Expression<String>? heldInterest,
    Expression<String>? valueDate,
    Expression<String>? rate,
    Expression<String>? rateDate,
    Expression<String>? share,
    Expression<String>? section,
    Expression<String>? notice,
    Expression<String>? extraKind,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (position != null) 'position': position,
      if (source != null) 'source': source,
      if (refId != null) 'ref_id': refId,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (value != null) 'value': value,
      if (heldInterest != null) 'held_interest': heldInterest,
      if (valueDate != null) 'value_date': valueDate,
      if (rate != null) 'rate': rate,
      if (rateDate != null) 'rate_date': rateDate,
      if (share != null) 'share': share,
      if (section != null) 'section': section,
      if (notice != null) 'notice': notice,
      if (extraKind != null) 'extra_kind': extraKind,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZakatFrozenLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? yearId,
    Value<int>? position,
    Value<String>? source,
    Value<String?>? refId,
    Value<String>? name,
    Value<String>? unit,
    Value<Decimal>? value,
    Value<Decimal>? heldInterest,
    Value<DateTime?>? valueDate,
    Value<Decimal?>? rate,
    Value<DateTime?>? rateDate,
    Value<Decimal>? share,
    Value<String>? section,
    Value<String?>? notice,
    Value<String?>? extraKind,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ZakatFrozenLinesCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      position: position ?? this.position,
      source: source ?? this.source,
      refId: refId ?? this.refId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      value: value ?? this.value,
      heldInterest: heldInterest ?? this.heldInterest,
      valueDate: valueDate ?? this.valueDate,
      rate: rate ?? this.rate,
      rateDate: rateDate ?? this.rateDate,
      share: share ?? this.share,
      section: section ?? this.section,
      notice: notice ?? this.notice,
      extraKind: extraKind ?? this.extraKind,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<String>(yearId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(
        $ZakatFrozenLinesTable.$convertervalue.toSql(value.value),
      );
    }
    if (heldInterest.present) {
      map['held_interest'] = Variable<String>(
        $ZakatFrozenLinesTable.$converterheldInterest.toSql(heldInterest.value),
      );
    }
    if (valueDate.present) {
      map['value_date'] = Variable<String>(
        $ZakatFrozenLinesTable.$convertervalueDaten.toSql(valueDate.value),
      );
    }
    if (rate.present) {
      map['rate'] = Variable<String>(
        $ZakatFrozenLinesTable.$converterraten.toSql(rate.value),
      );
    }
    if (rateDate.present) {
      map['rate_date'] = Variable<String>(
        $ZakatFrozenLinesTable.$converterrateDaten.toSql(rateDate.value),
      );
    }
    if (share.present) {
      map['share'] = Variable<String>(
        $ZakatFrozenLinesTable.$convertershare.toSql(share.value),
      );
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (notice.present) {
      map['notice'] = Variable<String>(notice.value);
    }
    if (extraKind.present) {
      map['extra_kind'] = Variable<String>(extraKind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakatFrozenLinesCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('position: $position, ')
          ..write('source: $source, ')
          ..write('refId: $refId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('value: $value, ')
          ..write('heldInterest: $heldInterest, ')
          ..write('valueDate: $valueDate, ')
          ..write('rate: $rate, ')
          ..write('rateDate: $rateDate, ')
          ..write('share: $share, ')
          ..write('section: $section, ')
          ..write('notice: $notice, ')
          ..write('extraKind: $extraKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZakatGiftsTable extends ZakatGifts
    with TableInfo<$ZakatGiftsTable, ZakatGiftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZakatGiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<String> yearId = GeneratedColumn<String>(
    'year_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES zakat_years (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ZakatGiftsTable.$converterdate);
  @override
  late final GeneratedColumnWithTypeConverter<Decimal, String> amount =
      GeneratedColumn<String>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Decimal>($ZakatGiftsTable.$converteramount);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Decimal?, String> rate =
      GeneratedColumn<String>(
        'rate',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Decimal?>($ZakatGiftsTable.$converterraten);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> rateDate =
      GeneratedColumn<String>(
        'rate_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ZakatGiftsTable.$converterrateDaten);
  static const VerificationMeta _rateViewMeta = const VerificationMeta(
    'rateView',
  );
  @override
  late final GeneratedColumn<String> rateView = GeneratedColumn<String>(
    'rate_view',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    yearId,
    date,
    amount,
    unit,
    rate,
    rateDate,
    rateView,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zakat_gifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ZakatGiftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    } else if (isInserting) {
      context.missing(_yearIdMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('rate_view')) {
      context.handle(
        _rateViewMeta,
        rateView.isAcceptableOrUnknown(data['rate_view']!, _rateViewMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZakatGiftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZakatGiftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year_id'],
      )!,
      date: $ZakatGiftsTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      amount: $ZakatGiftsTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amount'],
        )!,
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      rate: $ZakatGiftsTable.$converterraten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rate'],
        ),
      ),
      rateDate: $ZakatGiftsTable.$converterrateDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rate_date'],
        ),
      ),
      rateView: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate_view'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ZakatGiftsTable createAlias(String alias) {
    return $ZakatGiftsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate =
      const CalendarDateConverter();
  static TypeConverter<Decimal, String> $converteramount =
      const DecimalConverter();
  static TypeConverter<Decimal, String> $converterrate =
      const DecimalConverter();
  static TypeConverter<Decimal?, String?> $converterraten =
      NullAwareTypeConverter.wrap($converterrate);
  static TypeConverter<DateTime, String> $converterrateDate =
      const CalendarDateConverter();
  static TypeConverter<DateTime?, String?> $converterrateDaten =
      NullAwareTypeConverter.wrap($converterrateDate);
}

class ZakatGiftRow extends DataClass implements Insertable<ZakatGiftRow> {
  final String id;
  final String yearId;
  final DateTime date;
  final Decimal amount;
  final String unit;

  /// Rate, rate date and rate view are all null when the unit is the year base.
  final Decimal? rate;
  final DateTime? rateDate;
  final String? rateView;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ZakatGiftRow({
    required this.id,
    required this.yearId,
    required this.date,
    required this.amount,
    required this.unit,
    this.rate,
    this.rateDate,
    this.rateView,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year_id'] = Variable<String>(yearId);
    {
      map['date'] = Variable<String>(
        $ZakatGiftsTable.$converterdate.toSql(date),
      );
    }
    {
      map['amount'] = Variable<String>(
        $ZakatGiftsTable.$converteramount.toSql(amount),
      );
    }
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || rate != null) {
      map['rate'] = Variable<String>(
        $ZakatGiftsTable.$converterraten.toSql(rate),
      );
    }
    if (!nullToAbsent || rateDate != null) {
      map['rate_date'] = Variable<String>(
        $ZakatGiftsTable.$converterrateDaten.toSql(rateDate),
      );
    }
    if (!nullToAbsent || rateView != null) {
      map['rate_view'] = Variable<String>(rateView);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ZakatGiftsCompanion toCompanion(bool nullToAbsent) {
    return ZakatGiftsCompanion(
      id: Value(id),
      yearId: Value(yearId),
      date: Value(date),
      amount: Value(amount),
      unit: Value(unit),
      rate: rate == null && nullToAbsent ? const Value.absent() : Value(rate),
      rateDate: rateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(rateDate),
      rateView: rateView == null && nullToAbsent
          ? const Value.absent()
          : Value(rateView),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ZakatGiftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZakatGiftRow(
      id: serializer.fromJson<String>(json['id']),
      yearId: serializer.fromJson<String>(json['yearId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<Decimal>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      rate: serializer.fromJson<Decimal?>(json['rate']),
      rateDate: serializer.fromJson<DateTime?>(json['rateDate']),
      rateView: serializer.fromJson<String?>(json['rateView']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'yearId': serializer.toJson<String>(yearId),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<Decimal>(amount),
      'unit': serializer.toJson<String>(unit),
      'rate': serializer.toJson<Decimal?>(rate),
      'rateDate': serializer.toJson<DateTime?>(rateDate),
      'rateView': serializer.toJson<String?>(rateView),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ZakatGiftRow copyWith({
    String? id,
    String? yearId,
    DateTime? date,
    Decimal? amount,
    String? unit,
    Value<Decimal?> rate = const Value.absent(),
    Value<DateTime?> rateDate = const Value.absent(),
    Value<String?> rateView = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ZakatGiftRow(
    id: id ?? this.id,
    yearId: yearId ?? this.yearId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    rate: rate.present ? rate.value : this.rate,
    rateDate: rateDate.present ? rateDate.value : this.rateDate,
    rateView: rateView.present ? rateView.value : this.rateView,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ZakatGiftRow copyWithCompanion(ZakatGiftsCompanion data) {
    return ZakatGiftRow(
      id: data.id.present ? data.id.value : this.id,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      rate: data.rate.present ? data.rate.value : this.rate,
      rateDate: data.rateDate.present ? data.rateDate.value : this.rateDate,
      rateView: data.rateView.present ? data.rateView.value : this.rateView,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZakatGiftRow(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('rate: $rate, ')
          ..write('rateDate: $rateDate, ')
          ..write('rateView: $rateView, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    yearId,
    date,
    amount,
    unit,
    rate,
    rateDate,
    rateView,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZakatGiftRow &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.rate == this.rate &&
          other.rateDate == this.rateDate &&
          other.rateView == this.rateView &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ZakatGiftsCompanion extends UpdateCompanion<ZakatGiftRow> {
  final Value<String> id;
  final Value<String> yearId;
  final Value<DateTime> date;
  final Value<Decimal> amount;
  final Value<String> unit;
  final Value<Decimal?> rate;
  final Value<DateTime?> rateDate;
  final Value<String?> rateView;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ZakatGiftsCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.rate = const Value.absent(),
    this.rateDate = const Value.absent(),
    this.rateView = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZakatGiftsCompanion.insert({
    required String id,
    required String yearId,
    required DateTime date,
    required Decimal amount,
    required String unit,
    this.rate = const Value.absent(),
    this.rateDate = const Value.absent(),
    this.rateView = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       yearId = Value(yearId),
       date = Value(date),
       amount = Value(amount),
       unit = Value(unit),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ZakatGiftRow> custom({
    Expression<String>? id,
    Expression<String>? yearId,
    Expression<String>? date,
    Expression<String>? amount,
    Expression<String>? unit,
    Expression<String>? rate,
    Expression<String>? rateDate,
    Expression<String>? rateView,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (rate != null) 'rate': rate,
      if (rateDate != null) 'rate_date': rateDate,
      if (rateView != null) 'rate_view': rateView,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZakatGiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? yearId,
    Value<DateTime>? date,
    Value<Decimal>? amount,
    Value<String>? unit,
    Value<Decimal?>? rate,
    Value<DateTime?>? rateDate,
    Value<String?>? rateView,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ZakatGiftsCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      rate: rate ?? this.rate,
      rateDate: rateDate ?? this.rateDate,
      rateView: rateView ?? this.rateView,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<String>(yearId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $ZakatGiftsTable.$converterdate.toSql(date.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<String>(
        $ZakatGiftsTable.$converteramount.toSql(amount.value),
      );
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(
        $ZakatGiftsTable.$converterraten.toSql(rate.value),
      );
    }
    if (rateDate.present) {
      map['rate_date'] = Variable<String>(
        $ZakatGiftsTable.$converterrateDaten.toSql(rateDate.value),
      );
    }
    if (rateView.present) {
      map['rate_view'] = Variable<String>(rateView.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZakatGiftsCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('rate: $rate, ')
          ..write('rateDate: $rateDate, ')
          ..write('rateView: $rateView, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InvestmentsTable investments = $InvestmentsTable(this);
  late final $HistoryEntriesTable historyEntries = $HistoryEntriesTable(this);
  late final $RatesTable rates = $RatesTable(this);
  late final $InflationOverridesTable inflationOverrides =
      $InflationOverridesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $NoZakatYearsTable noZakatYears = $NoZakatYearsTable(this);
  late final $ZakatCyclesTable zakatCycles = $ZakatCyclesTable(this);
  late final $ZakatYearsTable zakatYears = $ZakatYearsTable(this);
  late final $ZakatExtraLinesTable zakatExtraLines = $ZakatExtraLinesTable(
    this,
  );
  late final $ZakatFrozenLinesTable zakatFrozenLines = $ZakatFrozenLinesTable(
    this,
  );
  late final $ZakatGiftsTable zakatGifts = $ZakatGiftsTable(this);
  late final Index historyByInvestmentDate = Index(
    'history_by_investment_date',
    'CREATE INDEX history_by_investment_date ON history_entries (investment_id, date)',
  );
  late final Index historyOneValueUpdatePerDay = Index(
    'history_one_value_update_per_day',
    'CREATE UNIQUE INDEX history_one_value_update_per_day ON history_entries (investment_id, date) WHERE kind = \'value_update\'',
  );
  late final Index historyOneSkipPerPlanDate = Index(
    'history_one_skip_per_plan_date',
    'CREATE UNIQUE INDEX history_one_skip_per_plan_date ON history_entries (investment_id, kind, date) WHERE kind IN (\'payout_skipped\', \'value_skipped\')',
  );
  late final Index ratesByPair = Index(
    'rates_by_pair',
    'CREATE INDEX rates_by_pair ON rates (from_unit, to_unit, as_of)',
  );
  late final Index zakatExtraLinesByYear = Index(
    'zakat_extra_lines_by_year',
    'CREATE INDEX zakat_extra_lines_by_year ON zakat_extra_lines (year_id)',
  );
  late final Index zakatFrozenLinesByYear = Index(
    'zakat_frozen_lines_by_year',
    'CREATE INDEX zakat_frozen_lines_by_year ON zakat_frozen_lines (year_id, position)',
  );
  late final Index zakatGiftsByYearDate = Index(
    'zakat_gifts_by_year_date',
    'CREATE INDEX zakat_gifts_by_year_date ON zakat_gifts (year_id, date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    investments,
    historyEntries,
    rates,
    inflationOverrides,
    appSettings,
    noZakatYears,
    zakatCycles,
    zakatYears,
    zakatExtraLines,
    zakatFrozenLines,
    zakatGifts,
    historyByInvestmentDate,
    historyOneValueUpdatePerDay,
    historyOneSkipPerPlanDate,
    ratesByPair,
    zakatExtraLinesByYear,
    zakatFrozenLinesByYear,
    zakatGiftsByYearDate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'investments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('history_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'zakat_years',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('zakat_extra_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'zakat_years',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('zakat_frozen_lines', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'zakat_years',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('zakat_gifts', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$InvestmentsTableCreateCompanionBuilder =
    InvestmentsCompanion Function({
      required String id,
      required String name,
      required String assetType,
      Value<String?> intent,
      Value<String?> market,
      Value<String?> marketCountry,
      required String unit,
      required DateTime startDate,
      Value<Decimal?> quantity,
      Value<int?> purityKarat,
      Value<int?> purityFineness,
      required String zakatRule,
      Value<Decimal?> customZakatShare,
      Value<String?> inflationOverride,
      Value<String?> notes,
      Value<String?> payoutSchedule,
      Value<Decimal?> expectedProfit,
      Value<String?> valueCheckSchedule,
      Value<Decimal?> expectedGrowth,
      Value<String?> profitBasis,
      Value<String?> capitalBack,
      Value<String?> accountKind,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InvestmentsTableUpdateCompanionBuilder =
    InvestmentsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> assetType,
      Value<String?> intent,
      Value<String?> market,
      Value<String?> marketCountry,
      Value<String> unit,
      Value<DateTime> startDate,
      Value<Decimal?> quantity,
      Value<int?> purityKarat,
      Value<int?> purityFineness,
      Value<String> zakatRule,
      Value<Decimal?> customZakatShare,
      Value<String?> inflationOverride,
      Value<String?> notes,
      Value<String?> payoutSchedule,
      Value<Decimal?> expectedProfit,
      Value<String?> valueCheckSchedule,
      Value<Decimal?> expectedGrowth,
      Value<String?> profitBasis,
      Value<String?> capitalBack,
      Value<String?> accountKind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$InvestmentsTableReferences
    extends BaseReferences<_$AppDatabase, $InvestmentsTable, InvestmentRow> {
  $$InvestmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HistoryEntriesTable, List<HistoryEntryRow>>
  _historyEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.historyEntries,
    aliasName: 'investments__id__history_entries__investment_id',
  );

  $$HistoryEntriesTableProcessedTableManager get historyEntriesRefs {
    final manager = $$HistoryEntriesTableTableManager(
      $_db,
      $_db.historyEntries,
    ).filter((f) => f.investmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_historyEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvestmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetType => $composableBuilder(
    column: $table.assetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intent => $composableBuilder(
    column: $table.intent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get market => $composableBuilder(
    column: $table.market,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marketCountry => $composableBuilder(
    column: $table.marketCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get quantity =>
      $composableBuilder(
        column: $table.quantity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get purityKarat => $composableBuilder(
    column: $table.purityKarat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purityFineness => $composableBuilder(
    column: $table.purityFineness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zakatRule => $composableBuilder(
    column: $table.zakatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String>
  get customZakatShare => $composableBuilder(
    column: $table.customZakatShare,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get inflationOverride => $composableBuilder(
    column: $table.inflationOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payoutSchedule => $composableBuilder(
    column: $table.payoutSchedule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String>
  get expectedProfit => $composableBuilder(
    column: $table.expectedProfit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get valueCheckSchedule => $composableBuilder(
    column: $table.valueCheckSchedule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String>
  get expectedGrowth => $composableBuilder(
    column: $table.expectedGrowth,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get profitBasis => $composableBuilder(
    column: $table.profitBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capitalBack => $composableBuilder(
    column: $table.capitalBack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountKind => $composableBuilder(
    column: $table.accountKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> historyEntriesRefs(
    Expression<bool> Function($$HistoryEntriesTableFilterComposer f) f,
  ) {
    final $$HistoryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historyEntries,
      getReferencedColumn: (t) => t.investmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.historyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvestmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetType => $composableBuilder(
    column: $table.assetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intent => $composableBuilder(
    column: $table.intent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get market => $composableBuilder(
    column: $table.market,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketCountry => $composableBuilder(
    column: $table.marketCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purityKarat => $composableBuilder(
    column: $table.purityKarat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purityFineness => $composableBuilder(
    column: $table.purityFineness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zakatRule => $composableBuilder(
    column: $table.zakatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customZakatShare => $composableBuilder(
    column: $table.customZakatShare,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inflationOverride => $composableBuilder(
    column: $table.inflationOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payoutSchedule => $composableBuilder(
    column: $table.payoutSchedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedProfit => $composableBuilder(
    column: $table.expectedProfit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueCheckSchedule => $composableBuilder(
    column: $table.valueCheckSchedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedGrowth => $composableBuilder(
    column: $table.expectedGrowth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profitBasis => $composableBuilder(
    column: $table.profitBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capitalBack => $composableBuilder(
    column: $table.capitalBack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountKind => $composableBuilder(
    column: $table.accountKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvestmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get assetType =>
      $composableBuilder(column: $table.assetType, builder: (column) => column);

  GeneratedColumn<String> get intent =>
      $composableBuilder(column: $table.intent, builder: (column) => column);

  GeneratedColumn<String> get market =>
      $composableBuilder(column: $table.market, builder: (column) => column);

  GeneratedColumn<String> get marketCountry => $composableBuilder(
    column: $table.marketCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get purityKarat => $composableBuilder(
    column: $table.purityKarat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purityFineness => $composableBuilder(
    column: $table.purityFineness,
    builder: (column) => column,
  );

  GeneratedColumn<String> get zakatRule =>
      $composableBuilder(column: $table.zakatRule, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get customZakatShare =>
      $composableBuilder(
        column: $table.customZakatShare,
        builder: (column) => column,
      );

  GeneratedColumn<String> get inflationOverride => $composableBuilder(
    column: $table.inflationOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get payoutSchedule => $composableBuilder(
    column: $table.payoutSchedule,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal?, String> get expectedProfit =>
      $composableBuilder(
        column: $table.expectedProfit,
        builder: (column) => column,
      );

  GeneratedColumn<String> get valueCheckSchedule => $composableBuilder(
    column: $table.valueCheckSchedule,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal?, String> get expectedGrowth =>
      $composableBuilder(
        column: $table.expectedGrowth,
        builder: (column) => column,
      );

  GeneratedColumn<String> get profitBasis => $composableBuilder(
    column: $table.profitBasis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get capitalBack => $composableBuilder(
    column: $table.capitalBack,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountKind => $composableBuilder(
    column: $table.accountKind,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> historyEntriesRefs<T extends Object>(
    Expression<T> Function($$HistoryEntriesTableAnnotationComposer a) f,
  ) {
    final $$HistoryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historyEntries,
      getReferencedColumn: (t) => t.investmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.historyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvestmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvestmentsTable,
          InvestmentRow,
          $$InvestmentsTableFilterComposer,
          $$InvestmentsTableOrderingComposer,
          $$InvestmentsTableAnnotationComposer,
          $$InvestmentsTableCreateCompanionBuilder,
          $$InvestmentsTableUpdateCompanionBuilder,
          (InvestmentRow, $$InvestmentsTableReferences),
          InvestmentRow,
          PrefetchHooks Function({bool historyEntriesRefs})
        > {
  $$InvestmentsTableTableManager(_$AppDatabase db, $InvestmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> assetType = const Value.absent(),
                Value<String?> intent = const Value.absent(),
                Value<String?> market = const Value.absent(),
                Value<String?> marketCountry = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<Decimal?> quantity = const Value.absent(),
                Value<int?> purityKarat = const Value.absent(),
                Value<int?> purityFineness = const Value.absent(),
                Value<String> zakatRule = const Value.absent(),
                Value<Decimal?> customZakatShare = const Value.absent(),
                Value<String?> inflationOverride = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> payoutSchedule = const Value.absent(),
                Value<Decimal?> expectedProfit = const Value.absent(),
                Value<String?> valueCheckSchedule = const Value.absent(),
                Value<Decimal?> expectedGrowth = const Value.absent(),
                Value<String?> profitBasis = const Value.absent(),
                Value<String?> capitalBack = const Value.absent(),
                Value<String?> accountKind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvestmentsCompanion(
                id: id,
                name: name,
                assetType: assetType,
                intent: intent,
                market: market,
                marketCountry: marketCountry,
                unit: unit,
                startDate: startDate,
                quantity: quantity,
                purityKarat: purityKarat,
                purityFineness: purityFineness,
                zakatRule: zakatRule,
                customZakatShare: customZakatShare,
                inflationOverride: inflationOverride,
                notes: notes,
                payoutSchedule: payoutSchedule,
                expectedProfit: expectedProfit,
                valueCheckSchedule: valueCheckSchedule,
                expectedGrowth: expectedGrowth,
                profitBasis: profitBasis,
                capitalBack: capitalBack,
                accountKind: accountKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String assetType,
                Value<String?> intent = const Value.absent(),
                Value<String?> market = const Value.absent(),
                Value<String?> marketCountry = const Value.absent(),
                required String unit,
                required DateTime startDate,
                Value<Decimal?> quantity = const Value.absent(),
                Value<int?> purityKarat = const Value.absent(),
                Value<int?> purityFineness = const Value.absent(),
                required String zakatRule,
                Value<Decimal?> customZakatShare = const Value.absent(),
                Value<String?> inflationOverride = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> payoutSchedule = const Value.absent(),
                Value<Decimal?> expectedProfit = const Value.absent(),
                Value<String?> valueCheckSchedule = const Value.absent(),
                Value<Decimal?> expectedGrowth = const Value.absent(),
                Value<String?> profitBasis = const Value.absent(),
                Value<String?> capitalBack = const Value.absent(),
                Value<String?> accountKind = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvestmentsCompanion.insert(
                id: id,
                name: name,
                assetType: assetType,
                intent: intent,
                market: market,
                marketCountry: marketCountry,
                unit: unit,
                startDate: startDate,
                quantity: quantity,
                purityKarat: purityKarat,
                purityFineness: purityFineness,
                zakatRule: zakatRule,
                customZakatShare: customZakatShare,
                inflationOverride: inflationOverride,
                notes: notes,
                payoutSchedule: payoutSchedule,
                expectedProfit: expectedProfit,
                valueCheckSchedule: valueCheckSchedule,
                expectedGrowth: expectedGrowth,
                profitBasis: profitBasis,
                capitalBack: capitalBack,
                accountKind: accountKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvestmentsTable, InvestmentRow>(table),
                  $$InvestmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({historyEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (historyEntriesRefs) db.historyEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (historyEntriesRefs)
                    await $_getPrefetchedData<
                      InvestmentRow,
                      $InvestmentsTable,
                      HistoryEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$InvestmentsTableReferences
                          ._historyEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$InvestmentsTableReferences(
                            db,
                            table,
                            p0,
                          ).historyEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.investmentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$InvestmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvestmentsTable,
      InvestmentRow,
      $$InvestmentsTableFilterComposer,
      $$InvestmentsTableOrderingComposer,
      $$InvestmentsTableAnnotationComposer,
      $$InvestmentsTableCreateCompanionBuilder,
      $$InvestmentsTableUpdateCompanionBuilder,
      (InvestmentRow, $$InvestmentsTableReferences),
      InvestmentRow,
      PrefetchHooks Function({bool historyEntriesRefs})
    >;
typedef $$HistoryEntriesTableCreateCompanionBuilder =
    HistoryEntriesCompanion Function({
      required String id,
      required String investmentId,
      required String kind,
      required DateTime date,
      required Decimal amount,
      Value<String?> unit,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HistoryEntriesTableUpdateCompanionBuilder =
    HistoryEntriesCompanion Function({
      Value<String> id,
      Value<String> investmentId,
      Value<String> kind,
      Value<DateTime> date,
      Value<Decimal> amount,
      Value<String?> unit,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$HistoryEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $HistoryEntriesTable, HistoryEntryRow> {
  $$HistoryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InvestmentsTable _investmentIdTable(_$AppDatabase db) => db
      .investments
      .createAlias('history_entries__investment_id__investments__id');

  $$InvestmentsTableProcessedTableManager get investmentId {
    final $_column = $_itemColumn<String>('investment_id')!;

    final manager = $$InvestmentsTableTableManager(
      $_db,
      $_db.investments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_investmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryEntriesTable> {
  $$HistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvestmentsTableFilterComposer get investmentId {
    final $$InvestmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.investmentId,
      referencedTable: $db.investments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvestmentsTableFilterComposer(
            $db: $db,
            $table: $db.investments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryEntriesTable> {
  $$HistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvestmentsTableOrderingComposer get investmentId {
    final $$InvestmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.investmentId,
      referencedTable: $db.investments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvestmentsTableOrderingComposer(
            $db: $db,
            $table: $db.investments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryEntriesTable> {
  $$HistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$InvestmentsTableAnnotationComposer get investmentId {
    final $$InvestmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.investmentId,
      referencedTable: $db.investments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvestmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.investments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoryEntriesTable,
          HistoryEntryRow,
          $$HistoryEntriesTableFilterComposer,
          $$HistoryEntriesTableOrderingComposer,
          $$HistoryEntriesTableAnnotationComposer,
          $$HistoryEntriesTableCreateCompanionBuilder,
          $$HistoryEntriesTableUpdateCompanionBuilder,
          (HistoryEntryRow, $$HistoryEntriesTableReferences),
          HistoryEntryRow,
          PrefetchHooks Function({bool investmentId})
        > {
  $$HistoryEntriesTableTableManager(
    _$AppDatabase db,
    $HistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> investmentId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<Decimal> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoryEntriesCompanion(
                id: id,
                investmentId: investmentId,
                kind: kind,
                date: date,
                amount: amount,
                unit: unit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String investmentId,
                required String kind,
                required DateTime date,
                required Decimal amount,
                Value<String?> unit = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HistoryEntriesCompanion.insert(
                id: id,
                investmentId: investmentId,
                kind: kind,
                date: date,
                amount: amount,
                unit: unit,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HistoryEntriesTable, HistoryEntryRow>(table),
                  $$HistoryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({investmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (investmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.investmentId,
                        referencedTable: $$HistoryEntriesTableReferences
                            ._investmentIdTable(db),
                        referencedColumn: $$HistoryEntriesTableReferences
                            ._investmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryEntriesTable,
      HistoryEntryRow,
      $$HistoryEntriesTableFilterComposer,
      $$HistoryEntriesTableOrderingComposer,
      $$HistoryEntriesTableAnnotationComposer,
      $$HistoryEntriesTableCreateCompanionBuilder,
      $$HistoryEntriesTableUpdateCompanionBuilder,
      (HistoryEntryRow, $$HistoryEntriesTableReferences),
      HistoryEntryRow,
      PrefetchHooks Function({bool investmentId})
    >;
typedef $$RatesTableCreateCompanionBuilder = RatesCompanion Function({
  required String id,
  required String fromUnit,
  required String toUnit,
  required Decimal rate,
  required DateTime asOf,
  required String source,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RatesTableUpdateCompanionBuilder = RatesCompanion Function({
  Value<String> id,
  Value<String> fromUnit,
  Value<String> toUnit,
  Value<Decimal> rate,
  Value<DateTime> asOf,
  Value<String> source,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RatesTableFilterComposer extends Composer<_$AppDatabase, $RatesTable> {
  $$RatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromUnit => $composableBuilder(
    column: $table.fromUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toUnit => $composableBuilder(
    column: $table.toUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get rate =>
      $composableBuilder(
        column: $table.rate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get asOf =>
      $composableBuilder(
        column: $table.asOf,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RatesTableOrderingComposer
    extends Composer<_$AppDatabase, $RatesTable> {
  $$RatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromUnit => $composableBuilder(
    column: $table.fromUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toUnit => $composableBuilder(
    column: $table.toUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatesTable> {
  $$RatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromUnit =>
      $composableBuilder(column: $table.fromUnit, builder: (column) => column);

  GeneratedColumn<String> get toUnit =>
      $composableBuilder(column: $table.toUnit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatesTable,
          RateRow,
          $$RatesTableFilterComposer,
          $$RatesTableOrderingComposer,
          $$RatesTableAnnotationComposer,
          $$RatesTableCreateCompanionBuilder,
          $$RatesTableUpdateCompanionBuilder,
          (RateRow, BaseReferences<_$AppDatabase, $RatesTable, RateRow>),
          RateRow,
          PrefetchHooks Function()
        > {
  $$RatesTableTableManager(_$AppDatabase db, $RatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromUnit = const Value.absent(),
                Value<String> toUnit = const Value.absent(),
                Value<Decimal> rate = const Value.absent(),
                Value<DateTime> asOf = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RatesCompanion(
                id: id,
                fromUnit: fromUnit,
                toUnit: toUnit,
                rate: rate,
                asOf: asOf,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromUnit,
                required String toUnit,
                required Decimal rate,
                required DateTime asOf,
                required String source,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RatesCompanion.insert(
                id: id,
                fromUnit: fromUnit,
                toUnit: toUnit,
                rate: rate,
                asOf: asOf,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RatesTable, RateRow>(table),
                  BaseReferences<_$AppDatabase, $RatesTable, RateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatesTable,
      RateRow,
      $$RatesTableFilterComposer,
      $$RatesTableOrderingComposer,
      $$RatesTableAnnotationComposer,
      $$RatesTableCreateCompanionBuilder,
      $$RatesTableUpdateCompanionBuilder,
      (RateRow, BaseReferences<_$AppDatabase, $RatesTable, RateRow>),
      RateRow,
      PrefetchHooks Function()
    >;
typedef $$InflationOverridesTableCreateCompanionBuilder =
    InflationOverridesCompanion Function({
      required String id,
      required String country,
      required int year,
      required Decimal rate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InflationOverridesTableUpdateCompanionBuilder =
    InflationOverridesCompanion Function({
      Value<String> id,
      Value<String> country,
      Value<int> year,
      Value<Decimal> rate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$InflationOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $InflationOverridesTable> {
  $$InflationOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get rate =>
      $composableBuilder(
        column: $table.rate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InflationOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $InflationOverridesTable> {
  $$InflationOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InflationOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InflationOverridesTable> {
  $$InflationOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InflationOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InflationOverridesTable,
          InflationOverrideRow,
          $$InflationOverridesTableFilterComposer,
          $$InflationOverridesTableOrderingComposer,
          $$InflationOverridesTableAnnotationComposer,
          $$InflationOverridesTableCreateCompanionBuilder,
          $$InflationOverridesTableUpdateCompanionBuilder,
          (
            InflationOverrideRow,
            BaseReferences<
              _$AppDatabase,
              $InflationOverridesTable,
              InflationOverrideRow
            >,
          ),
          InflationOverrideRow,
          PrefetchHooks Function()
        > {
  $$InflationOverridesTableTableManager(
    _$AppDatabase db,
    $InflationOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InflationOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InflationOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InflationOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<Decimal> rate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InflationOverridesCompanion(
                id: id,
                country: country,
                year: year,
                rate: rate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String country,
                required int year,
                required Decimal rate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InflationOverridesCompanion.insert(
                id: id,
                country: country,
                year: year,
                rate: rate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InflationOverridesTable, InflationOverrideRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InflationOverridesTable,
                    InflationOverrideRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InflationOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InflationOverridesTable,
      InflationOverrideRow,
      $$InflationOverridesTableFilterComposer,
      $$InflationOverridesTableOrderingComposer,
      $$InflationOverridesTableAnnotationComposer,
      $$InflationOverridesTableCreateCompanionBuilder,
      $$InflationOverridesTableUpdateCompanionBuilder,
      (
        InflationOverrideRow,
        BaseReferences<
          _$AppDatabase,
          $InflationOverridesTable,
          InflationOverrideRow
        >,
      ),
      InflationOverrideRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String id,
      Value<String?> baseCurrency,
      Value<String?> homeInflation,
      Value<String?> zakatYear,
      Value<String?> longTermMethod,
      Value<bool?> jewelleryZakatable,
      Value<String?> nisabMetal,
      Value<bool> reminderOn,
      Value<int> reminderDays,
      Value<int> reminderMinute,
      Value<bool> reminderAsked,
      Value<String?> givingRateView,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> id,
      Value<String?> baseCurrency,
      Value<String?> homeInflation,
      Value<String?> zakatYear,
      Value<String?> longTermMethod,
      Value<bool?> jewelleryZakatable,
      Value<String?> nisabMetal,
      Value<bool> reminderOn,
      Value<int> reminderDays,
      Value<int> reminderMinute,
      Value<bool> reminderAsked,
      Value<String?> givingRateView,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeInflation => $composableBuilder(
    column: $table.homeInflation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zakatYear => $composableBuilder(
    column: $table.zakatYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get longTermMethod => $composableBuilder(
    column: $table.longTermMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get jewelleryZakatable => $composableBuilder(
    column: $table.jewelleryZakatable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nisabMetal => $composableBuilder(
    column: $table.nisabMetal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderOn => $composableBuilder(
    column: $table.reminderOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderAsked => $composableBuilder(
    column: $table.reminderAsked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get givingRateView => $composableBuilder(
    column: $table.givingRateView,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeInflation => $composableBuilder(
    column: $table.homeInflation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zakatYear => $composableBuilder(
    column: $table.zakatYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get longTermMethod => $composableBuilder(
    column: $table.longTermMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get jewelleryZakatable => $composableBuilder(
    column: $table.jewelleryZakatable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nisabMetal => $composableBuilder(
    column: $table.nisabMetal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderOn => $composableBuilder(
    column: $table.reminderOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderAsked => $composableBuilder(
    column: $table.reminderAsked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get givingRateView => $composableBuilder(
    column: $table.givingRateView,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get homeInflation => $composableBuilder(
    column: $table.homeInflation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get zakatYear =>
      $composableBuilder(column: $table.zakatYear, builder: (column) => column);

  GeneratedColumn<String> get longTermMethod => $composableBuilder(
    column: $table.longTermMethod,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get jewelleryZakatable => $composableBuilder(
    column: $table.jewelleryZakatable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nisabMetal => $composableBuilder(
    column: $table.nisabMetal,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderOn => $composableBuilder(
    column: $table.reminderOn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderAsked => $composableBuilder(
    column: $table.reminderAsked,
    builder: (column) => column,
  );

  GeneratedColumn<String> get givingRateView => $composableBuilder(
    column: $table.givingRateView,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingsRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> baseCurrency = const Value.absent(),
                Value<String?> homeInflation = const Value.absent(),
                Value<String?> zakatYear = const Value.absent(),
                Value<String?> longTermMethod = const Value.absent(),
                Value<bool?> jewelleryZakatable = const Value.absent(),
                Value<String?> nisabMetal = const Value.absent(),
                Value<bool> reminderOn = const Value.absent(),
                Value<int> reminderDays = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
                Value<bool> reminderAsked = const Value.absent(),
                Value<String?> givingRateView = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                baseCurrency: baseCurrency,
                homeInflation: homeInflation,
                zakatYear: zakatYear,
                longTermMethod: longTermMethod,
                jewelleryZakatable: jewelleryZakatable,
                nisabMetal: nisabMetal,
                reminderOn: reminderOn,
                reminderDays: reminderDays,
                reminderMinute: reminderMinute,
                reminderAsked: reminderAsked,
                givingRateView: givingRateView,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> baseCurrency = const Value.absent(),
                Value<String?> homeInflation = const Value.absent(),
                Value<String?> zakatYear = const Value.absent(),
                Value<String?> longTermMethod = const Value.absent(),
                Value<bool?> jewelleryZakatable = const Value.absent(),
                Value<String?> nisabMetal = const Value.absent(),
                Value<bool> reminderOn = const Value.absent(),
                Value<int> reminderDays = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
                Value<bool> reminderAsked = const Value.absent(),
                Value<String?> givingRateView = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                baseCurrency: baseCurrency,
                homeInflation: homeInflation,
                zakatYear: zakatYear,
                longTermMethod: longTermMethod,
                jewelleryZakatable: jewelleryZakatable,
                nisabMetal: nisabMetal,
                reminderOn: reminderOn,
                reminderDays: reminderDays,
                reminderMinute: reminderMinute,
                reminderAsked: reminderAsked,
                givingRateView: givingRateView,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingsRow>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingsRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$NoZakatYearsTableCreateCompanionBuilder =
    NoZakatYearsCompanion Function({
      required String id,
      required int year,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$NoZakatYearsTableUpdateCompanionBuilder =
    NoZakatYearsCompanion Function({
      Value<String> id,
      Value<int> year,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NoZakatYearsTableFilterComposer
    extends Composer<_$AppDatabase, $NoZakatYearsTable> {
  $$NoZakatYearsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoZakatYearsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoZakatYearsTable> {
  $$NoZakatYearsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoZakatYearsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoZakatYearsTable> {
  $$NoZakatYearsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NoZakatYearsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoZakatYearsTable,
          NoZakatYearRow,
          $$NoZakatYearsTableFilterComposer,
          $$NoZakatYearsTableOrderingComposer,
          $$NoZakatYearsTableAnnotationComposer,
          $$NoZakatYearsTableCreateCompanionBuilder,
          $$NoZakatYearsTableUpdateCompanionBuilder,
          (
            NoZakatYearRow,
            BaseReferences<_$AppDatabase, $NoZakatYearsTable, NoZakatYearRow>,
          ),
          NoZakatYearRow,
          PrefetchHooks Function()
        > {
  $$NoZakatYearsTableTableManager(_$AppDatabase db, $NoZakatYearsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoZakatYearsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoZakatYearsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoZakatYearsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoZakatYearsCompanion(
                id: id,
                year: year,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int year,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NoZakatYearsCompanion.insert(
                id: id,
                year: year,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NoZakatYearsTable, NoZakatYearRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NoZakatYearsTable,
                    NoZakatYearRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoZakatYearsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoZakatYearsTable,
      NoZakatYearRow,
      $$NoZakatYearsTableFilterComposer,
      $$NoZakatYearsTableOrderingComposer,
      $$NoZakatYearsTableAnnotationComposer,
      $$NoZakatYearsTableCreateCompanionBuilder,
      $$NoZakatYearsTableUpdateCompanionBuilder,
      (
        NoZakatYearRow,
        BaseReferences<_$AppDatabase, $NoZakatYearsTable, NoZakatYearRow>,
      ),
      NoZakatYearRow,
      PrefetchHooks Function()
    >;
typedef $$ZakatCyclesTableCreateCompanionBuilder =
    ZakatCyclesCompanion Function({
      required String id,
      required String calendar,
      required int month,
      required int day,
      required DateTime fromDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ZakatCyclesTableUpdateCompanionBuilder =
    ZakatCyclesCompanion Function({
      Value<String> id,
      Value<String> calendar,
      Value<int> month,
      Value<int> day,
      Value<DateTime> fromDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ZakatCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $ZakatCyclesTable> {
  $$ZakatCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendar => $composableBuilder(
    column: $table.calendar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get fromDate =>
      $composableBuilder(
        column: $table.fromDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ZakatCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakatCyclesTable> {
  $$ZakatCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendar => $composableBuilder(
    column: $table.calendar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZakatCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakatCyclesTable> {
  $$ZakatCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get calendar =>
      $composableBuilder(column: $table.calendar, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ZakatCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZakatCyclesTable,
          ZakatCycleRow,
          $$ZakatCyclesTableFilterComposer,
          $$ZakatCyclesTableOrderingComposer,
          $$ZakatCyclesTableAnnotationComposer,
          $$ZakatCyclesTableCreateCompanionBuilder,
          $$ZakatCyclesTableUpdateCompanionBuilder,
          (
            ZakatCycleRow,
            BaseReferences<_$AppDatabase, $ZakatCyclesTable, ZakatCycleRow>,
          ),
          ZakatCycleRow,
          PrefetchHooks Function()
        > {
  $$ZakatCyclesTableTableManager(_$AppDatabase db, $ZakatCyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakatCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakatCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakatCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> calendar = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> day = const Value.absent(),
                Value<DateTime> fromDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZakatCyclesCompanion(
                id: id,
                calendar: calendar,
                month: month,
                day: day,
                fromDate: fromDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String calendar,
                required int month,
                required int day,
                required DateTime fromDate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ZakatCyclesCompanion.insert(
                id: id,
                calendar: calendar,
                month: month,
                day: day,
                fromDate: fromDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZakatCyclesTable, ZakatCycleRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ZakatCyclesTable,
                    ZakatCycleRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ZakatCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZakatCyclesTable,
      ZakatCycleRow,
      $$ZakatCyclesTableFilterComposer,
      $$ZakatCyclesTableOrderingComposer,
      $$ZakatCyclesTableAnnotationComposer,
      $$ZakatCyclesTableCreateCompanionBuilder,
      $$ZakatCyclesTableUpdateCompanionBuilder,
      (
        ZakatCycleRow,
        BaseReferences<_$AppDatabase, $ZakatCyclesTable, ZakatCycleRow>,
      ),
      ZakatCycleRow,
      PrefetchHooks Function()
    >;
typedef $$ZakatYearsTableCreateCompanionBuilder = ZakatYearsCompanion Function({
  required String id,
  required DateTime dueKey,
  Value<DateTime?> movedDue,
  Value<Decimal> debts,
  Value<bool> deductDebts,
  Value<DateTime?> startedOn,
  Value<String?> frozenBase,
  Value<String?> frozenNisabMetal,
  Value<Decimal?> frozenMetalRate,
  Value<DateTime?> frozenMetalRateDate,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ZakatYearsTableUpdateCompanionBuilder = ZakatYearsCompanion Function({
  Value<String> id,
  Value<DateTime> dueKey,
  Value<DateTime?> movedDue,
  Value<Decimal> debts,
  Value<bool> deductDebts,
  Value<DateTime?> startedOn,
  Value<String?> frozenBase,
  Value<String?> frozenNisabMetal,
  Value<Decimal?> frozenMetalRate,
  Value<DateTime?> frozenMetalRateDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ZakatYearsTableReferences
    extends BaseReferences<_$AppDatabase, $ZakatYearsTable, ZakatYearRow> {
  $$ZakatYearsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ZakatExtraLinesTable, List<ZakatExtraLineRow>>
  _zakatExtraLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.zakatExtraLines,
    aliasName: 'zakat_years__id__zakat_extra_lines__year_id',
  );

  $$ZakatExtraLinesTableProcessedTableManager get zakatExtraLinesRefs {
    final manager = $$ZakatExtraLinesTableTableManager(
      $_db,
      $_db.zakatExtraLines,
    ).filter((f) => f.yearId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _zakatExtraLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ZakatFrozenLinesTable, List<ZakatFrozenLineRow>>
  _zakatFrozenLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.zakatFrozenLines,
    aliasName: 'zakat_years__id__zakat_frozen_lines__year_id',
  );

  $$ZakatFrozenLinesTableProcessedTableManager get zakatFrozenLinesRefs {
    final manager = $$ZakatFrozenLinesTableTableManager(
      $_db,
      $_db.zakatFrozenLines,
    ).filter((f) => f.yearId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _zakatFrozenLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ZakatGiftsTable, List<ZakatGiftRow>>
  _zakatGiftsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.zakatGifts,
    aliasName: 'zakat_years__id__zakat_gifts__year_id',
  );

  $$ZakatGiftsTableProcessedTableManager get zakatGiftsRefs {
    final manager = $$ZakatGiftsTableTableManager(
      $_db,
      $_db.zakatGifts,
    ).filter((f) => f.yearId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_zakatGiftsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ZakatYearsTableFilterComposer
    extends Composer<_$AppDatabase, $ZakatYearsTable> {
  $$ZakatYearsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get dueKey =>
      $composableBuilder(
        column: $table.dueKey,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get movedDue =>
      $composableBuilder(
        column: $table.movedDue,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get debts =>
      $composableBuilder(
        column: $table.debts,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get deductDebts => $composableBuilder(
    column: $table.deductDebts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get startedOn =>
      $composableBuilder(
        column: $table.startedOn,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get frozenBase => $composableBuilder(
    column: $table.frozenBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frozenNisabMetal => $composableBuilder(
    column: $table.frozenNisabMetal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String>
  get frozenMetalRate => $composableBuilder(
    column: $table.frozenMetalRate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String>
  get frozenMetalRateDate => $composableBuilder(
    column: $table.frozenMetalRateDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> zakatExtraLinesRefs(
    Expression<bool> Function($$ZakatExtraLinesTableFilterComposer f) f,
  ) {
    final $$ZakatExtraLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zakatExtraLines,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatExtraLinesTableFilterComposer(
            $db: $db,
            $table: $db.zakatExtraLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> zakatFrozenLinesRefs(
    Expression<bool> Function($$ZakatFrozenLinesTableFilterComposer f) f,
  ) {
    final $$ZakatFrozenLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zakatFrozenLines,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatFrozenLinesTableFilterComposer(
            $db: $db,
            $table: $db.zakatFrozenLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> zakatGiftsRefs(
    Expression<bool> Function($$ZakatGiftsTableFilterComposer f) f,
  ) {
    final $$ZakatGiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zakatGifts,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatGiftsTableFilterComposer(
            $db: $db,
            $table: $db.zakatGifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZakatYearsTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakatYearsTable> {
  $$ZakatYearsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueKey => $composableBuilder(
    column: $table.dueKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get movedDue => $composableBuilder(
    column: $table.movedDue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get debts => $composableBuilder(
    column: $table.debts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deductDebts => $composableBuilder(
    column: $table.deductDebts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frozenBase => $composableBuilder(
    column: $table.frozenBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frozenNisabMetal => $composableBuilder(
    column: $table.frozenNisabMetal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frozenMetalRate => $composableBuilder(
    column: $table.frozenMetalRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frozenMetalRateDate => $composableBuilder(
    column: $table.frozenMetalRateDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ZakatYearsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakatYearsTable> {
  $$ZakatYearsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get dueKey =>
      $composableBuilder(column: $table.dueKey, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get movedDue =>
      $composableBuilder(column: $table.movedDue, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get debts =>
      $composableBuilder(column: $table.debts, builder: (column) => column);

  GeneratedColumn<bool> get deductDebts => $composableBuilder(
    column: $table.deductDebts,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime?, String> get startedOn =>
      $composableBuilder(column: $table.startedOn, builder: (column) => column);

  GeneratedColumn<String> get frozenBase => $composableBuilder(
    column: $table.frozenBase,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frozenNisabMetal => $composableBuilder(
    column: $table.frozenNisabMetal,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Decimal?, String> get frozenMetalRate =>
      $composableBuilder(
        column: $table.frozenMetalRate,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, String> get frozenMetalRateDate =>
      $composableBuilder(
        column: $table.frozenMetalRateDate,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> zakatExtraLinesRefs<T extends Object>(
    Expression<T> Function($$ZakatExtraLinesTableAnnotationComposer a) f,
  ) {
    final $$ZakatExtraLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zakatExtraLines,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatExtraLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.zakatExtraLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> zakatFrozenLinesRefs<T extends Object>(
    Expression<T> Function($$ZakatFrozenLinesTableAnnotationComposer a) f,
  ) {
    final $$ZakatFrozenLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zakatFrozenLines,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatFrozenLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.zakatFrozenLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> zakatGiftsRefs<T extends Object>(
    Expression<T> Function($$ZakatGiftsTableAnnotationComposer a) f,
  ) {
    final $$ZakatGiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.zakatGifts,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatGiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.zakatGifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ZakatYearsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZakatYearsTable,
          ZakatYearRow,
          $$ZakatYearsTableFilterComposer,
          $$ZakatYearsTableOrderingComposer,
          $$ZakatYearsTableAnnotationComposer,
          $$ZakatYearsTableCreateCompanionBuilder,
          $$ZakatYearsTableUpdateCompanionBuilder,
          (ZakatYearRow, $$ZakatYearsTableReferences),
          ZakatYearRow,
          PrefetchHooks Function({
            bool zakatExtraLinesRefs,
            bool zakatFrozenLinesRefs,
            bool zakatGiftsRefs,
          })
        > {
  $$ZakatYearsTableTableManager(_$AppDatabase db, $ZakatYearsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakatYearsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakatYearsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakatYearsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> dueKey = const Value.absent(),
                Value<DateTime?> movedDue = const Value.absent(),
                Value<Decimal> debts = const Value.absent(),
                Value<bool> deductDebts = const Value.absent(),
                Value<DateTime?> startedOn = const Value.absent(),
                Value<String?> frozenBase = const Value.absent(),
                Value<String?> frozenNisabMetal = const Value.absent(),
                Value<Decimal?> frozenMetalRate = const Value.absent(),
                Value<DateTime?> frozenMetalRateDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZakatYearsCompanion(
                id: id,
                dueKey: dueKey,
                movedDue: movedDue,
                debts: debts,
                deductDebts: deductDebts,
                startedOn: startedOn,
                frozenBase: frozenBase,
                frozenNisabMetal: frozenNisabMetal,
                frozenMetalRate: frozenMetalRate,
                frozenMetalRateDate: frozenMetalRateDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime dueKey,
                Value<DateTime?> movedDue = const Value.absent(),
                Value<Decimal> debts = const Value.absent(),
                Value<bool> deductDebts = const Value.absent(),
                Value<DateTime?> startedOn = const Value.absent(),
                Value<String?> frozenBase = const Value.absent(),
                Value<String?> frozenNisabMetal = const Value.absent(),
                Value<Decimal?> frozenMetalRate = const Value.absent(),
                Value<DateTime?> frozenMetalRateDate = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ZakatYearsCompanion.insert(
                id: id,
                dueKey: dueKey,
                movedDue: movedDue,
                debts: debts,
                deductDebts: deductDebts,
                startedOn: startedOn,
                frozenBase: frozenBase,
                frozenNisabMetal: frozenNisabMetal,
                frozenMetalRate: frozenMetalRate,
                frozenMetalRateDate: frozenMetalRateDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZakatYearsTable, ZakatYearRow>(table),
                  $$ZakatYearsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                zakatExtraLinesRefs = false,
                zakatFrozenLinesRefs = false,
                zakatGiftsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (zakatExtraLinesRefs) db.zakatExtraLines,
                    if (zakatFrozenLinesRefs) db.zakatFrozenLines,
                    if (zakatGiftsRefs) db.zakatGifts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (zakatExtraLinesRefs)
                        await $_getPrefetchedData<
                          ZakatYearRow,
                          $ZakatYearsTable,
                          ZakatExtraLineRow
                        >(
                          currentTable: table,
                          referencedTable: $$ZakatYearsTableReferences
                              ._zakatExtraLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ZakatYearsTableReferences(
                                db,
                                table,
                                p0,
                              ).zakatExtraLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.yearId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (zakatFrozenLinesRefs)
                        await $_getPrefetchedData<
                          ZakatYearRow,
                          $ZakatYearsTable,
                          ZakatFrozenLineRow
                        >(
                          currentTable: table,
                          referencedTable: $$ZakatYearsTableReferences
                              ._zakatFrozenLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ZakatYearsTableReferences(
                                db,
                                table,
                                p0,
                              ).zakatFrozenLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.yearId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (zakatGiftsRefs)
                        await $_getPrefetchedData<
                          ZakatYearRow,
                          $ZakatYearsTable,
                          ZakatGiftRow
                        >(
                          currentTable: table,
                          referencedTable: $$ZakatYearsTableReferences
                              ._zakatGiftsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ZakatYearsTableReferences(
                                db,
                                table,
                                p0,
                              ).zakatGiftsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.yearId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ZakatYearsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZakatYearsTable,
      ZakatYearRow,
      $$ZakatYearsTableFilterComposer,
      $$ZakatYearsTableOrderingComposer,
      $$ZakatYearsTableAnnotationComposer,
      $$ZakatYearsTableCreateCompanionBuilder,
      $$ZakatYearsTableUpdateCompanionBuilder,
      (ZakatYearRow, $$ZakatYearsTableReferences),
      ZakatYearRow,
      PrefetchHooks Function({
        bool zakatExtraLinesRefs,
        bool zakatFrozenLinesRefs,
        bool zakatGiftsRefs,
      })
    >;
typedef $$ZakatExtraLinesTableCreateCompanionBuilder =
    ZakatExtraLinesCompanion Function({
      required String id,
      required String yearId,
      required String label,
      required String kind,
      required Decimal amount,
      required String unit,
      required bool goodDebtConfirmed,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ZakatExtraLinesTableUpdateCompanionBuilder =
    ZakatExtraLinesCompanion Function({
      Value<String> id,
      Value<String> yearId,
      Value<String> label,
      Value<String> kind,
      Value<Decimal> amount,
      Value<String> unit,
      Value<bool> goodDebtConfirmed,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ZakatExtraLinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ZakatExtraLinesTable,
          ZakatExtraLineRow
        > {
  $$ZakatExtraLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ZakatYearsTable _yearIdTable(_$AppDatabase db) =>
      db.zakatYears.createAlias('zakat_extra_lines__year_id__zakat_years__id');

  $$ZakatYearsTableProcessedTableManager get yearId {
    final $_column = $_itemColumn<String>('year_id')!;

    final manager = $$ZakatYearsTableTableManager(
      $_db,
      $_db.zakatYears,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_yearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ZakatExtraLinesTableFilterComposer
    extends Composer<_$AppDatabase, $ZakatExtraLinesTable> {
  $$ZakatExtraLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get goodDebtConfirmed => $composableBuilder(
    column: $table.goodDebtConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ZakatYearsTableFilterComposer get yearId {
    final $$ZakatYearsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableFilterComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatExtraLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakatExtraLinesTable> {
  $$ZakatExtraLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get goodDebtConfirmed => $composableBuilder(
    column: $table.goodDebtConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ZakatYearsTableOrderingComposer get yearId {
    final $$ZakatYearsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableOrderingComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatExtraLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakatExtraLinesTable> {
  $$ZakatExtraLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get goodDebtConfirmed => $composableBuilder(
    column: $table.goodDebtConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ZakatYearsTableAnnotationComposer get yearId {
    final $$ZakatYearsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableAnnotationComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatExtraLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZakatExtraLinesTable,
          ZakatExtraLineRow,
          $$ZakatExtraLinesTableFilterComposer,
          $$ZakatExtraLinesTableOrderingComposer,
          $$ZakatExtraLinesTableAnnotationComposer,
          $$ZakatExtraLinesTableCreateCompanionBuilder,
          $$ZakatExtraLinesTableUpdateCompanionBuilder,
          (ZakatExtraLineRow, $$ZakatExtraLinesTableReferences),
          ZakatExtraLineRow,
          PrefetchHooks Function({bool yearId})
        > {
  $$ZakatExtraLinesTableTableManager(
    _$AppDatabase db,
    $ZakatExtraLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakatExtraLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakatExtraLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakatExtraLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> yearId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<Decimal> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> goodDebtConfirmed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZakatExtraLinesCompanion(
                id: id,
                yearId: yearId,
                label: label,
                kind: kind,
                amount: amount,
                unit: unit,
                goodDebtConfirmed: goodDebtConfirmed,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String yearId,
                required String label,
                required String kind,
                required Decimal amount,
                required String unit,
                required bool goodDebtConfirmed,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ZakatExtraLinesCompanion.insert(
                id: id,
                yearId: yearId,
                label: label,
                kind: kind,
                amount: amount,
                unit: unit,
                goodDebtConfirmed: goodDebtConfirmed,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZakatExtraLinesTable, ZakatExtraLineRow>(table),
                  $$ZakatExtraLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({yearId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (yearId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.yearId,
                        referencedTable: $$ZakatExtraLinesTableReferences
                            ._yearIdTable(db),
                        referencedColumn: $$ZakatExtraLinesTableReferences
                            ._yearIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ZakatExtraLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZakatExtraLinesTable,
      ZakatExtraLineRow,
      $$ZakatExtraLinesTableFilterComposer,
      $$ZakatExtraLinesTableOrderingComposer,
      $$ZakatExtraLinesTableAnnotationComposer,
      $$ZakatExtraLinesTableCreateCompanionBuilder,
      $$ZakatExtraLinesTableUpdateCompanionBuilder,
      (ZakatExtraLineRow, $$ZakatExtraLinesTableReferences),
      ZakatExtraLineRow,
      PrefetchHooks Function({bool yearId})
    >;
typedef $$ZakatFrozenLinesTableCreateCompanionBuilder =
    ZakatFrozenLinesCompanion Function({
      required String id,
      required String yearId,
      required int position,
      required String source,
      Value<String?> refId,
      required String name,
      required String unit,
      required Decimal value,
      required Decimal heldInterest,
      Value<DateTime?> valueDate,
      Value<Decimal?> rate,
      Value<DateTime?> rateDate,
      required Decimal share,
      required String section,
      Value<String?> notice,
      Value<String?> extraKind,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ZakatFrozenLinesTableUpdateCompanionBuilder =
    ZakatFrozenLinesCompanion Function({
      Value<String> id,
      Value<String> yearId,
      Value<int> position,
      Value<String> source,
      Value<String?> refId,
      Value<String> name,
      Value<String> unit,
      Value<Decimal> value,
      Value<Decimal> heldInterest,
      Value<DateTime?> valueDate,
      Value<Decimal?> rate,
      Value<DateTime?> rateDate,
      Value<Decimal> share,
      Value<String> section,
      Value<String?> notice,
      Value<String?> extraKind,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ZakatFrozenLinesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ZakatFrozenLinesTable,
          ZakatFrozenLineRow
        > {
  $$ZakatFrozenLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ZakatYearsTable _yearIdTable(_$AppDatabase db) =>
      db.zakatYears.createAlias('zakat_frozen_lines__year_id__zakat_years__id');

  $$ZakatYearsTableProcessedTableManager get yearId {
    final $_column = $_itemColumn<String>('year_id')!;

    final manager = $$ZakatYearsTableTableManager(
      $_db,
      $_db.zakatYears,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_yearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ZakatFrozenLinesTableFilterComposer
    extends Composer<_$AppDatabase, $ZakatFrozenLinesTable> {
  $$ZakatFrozenLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get value =>
      $composableBuilder(
        column: $table.value,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get heldInterest =>
      $composableBuilder(
        column: $table.heldInterest,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get valueDate =>
      $composableBuilder(
        column: $table.valueDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get rate =>
      $composableBuilder(
        column: $table.rate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get rateDate =>
      $composableBuilder(
        column: $table.rateDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get share =>
      $composableBuilder(
        column: $table.share,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notice => $composableBuilder(
    column: $table.notice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraKind => $composableBuilder(
    column: $table.extraKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ZakatYearsTableFilterComposer get yearId {
    final $$ZakatYearsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableFilterComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatFrozenLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakatFrozenLinesTable> {
  $$ZakatFrozenLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heldInterest => $composableBuilder(
    column: $table.heldInterest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueDate => $composableBuilder(
    column: $table.valueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateDate => $composableBuilder(
    column: $table.rateDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get share => $composableBuilder(
    column: $table.share,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notice => $composableBuilder(
    column: $table.notice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraKind => $composableBuilder(
    column: $table.extraKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ZakatYearsTableOrderingComposer get yearId {
    final $$ZakatYearsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableOrderingComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatFrozenLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakatFrozenLinesTable> {
  $$ZakatFrozenLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get heldInterest =>
      $composableBuilder(
        column: $table.heldInterest,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, String> get valueDate =>
      $composableBuilder(column: $table.valueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get rateDate =>
      $composableBuilder(column: $table.rateDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get share =>
      $composableBuilder(column: $table.share, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<String> get notice =>
      $composableBuilder(column: $table.notice, builder: (column) => column);

  GeneratedColumn<String> get extraKind =>
      $composableBuilder(column: $table.extraKind, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ZakatYearsTableAnnotationComposer get yearId {
    final $$ZakatYearsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableAnnotationComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatFrozenLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZakatFrozenLinesTable,
          ZakatFrozenLineRow,
          $$ZakatFrozenLinesTableFilterComposer,
          $$ZakatFrozenLinesTableOrderingComposer,
          $$ZakatFrozenLinesTableAnnotationComposer,
          $$ZakatFrozenLinesTableCreateCompanionBuilder,
          $$ZakatFrozenLinesTableUpdateCompanionBuilder,
          (ZakatFrozenLineRow, $$ZakatFrozenLinesTableReferences),
          ZakatFrozenLineRow,
          PrefetchHooks Function({bool yearId})
        > {
  $$ZakatFrozenLinesTableTableManager(
    _$AppDatabase db,
    $ZakatFrozenLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakatFrozenLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakatFrozenLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakatFrozenLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> yearId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> refId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<Decimal> value = const Value.absent(),
                Value<Decimal> heldInterest = const Value.absent(),
                Value<DateTime?> valueDate = const Value.absent(),
                Value<Decimal?> rate = const Value.absent(),
                Value<DateTime?> rateDate = const Value.absent(),
                Value<Decimal> share = const Value.absent(),
                Value<String> section = const Value.absent(),
                Value<String?> notice = const Value.absent(),
                Value<String?> extraKind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZakatFrozenLinesCompanion(
                id: id,
                yearId: yearId,
                position: position,
                source: source,
                refId: refId,
                name: name,
                unit: unit,
                value: value,
                heldInterest: heldInterest,
                valueDate: valueDate,
                rate: rate,
                rateDate: rateDate,
                share: share,
                section: section,
                notice: notice,
                extraKind: extraKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String yearId,
                required int position,
                required String source,
                Value<String?> refId = const Value.absent(),
                required String name,
                required String unit,
                required Decimal value,
                required Decimal heldInterest,
                Value<DateTime?> valueDate = const Value.absent(),
                Value<Decimal?> rate = const Value.absent(),
                Value<DateTime?> rateDate = const Value.absent(),
                required Decimal share,
                required String section,
                Value<String?> notice = const Value.absent(),
                Value<String?> extraKind = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ZakatFrozenLinesCompanion.insert(
                id: id,
                yearId: yearId,
                position: position,
                source: source,
                refId: refId,
                name: name,
                unit: unit,
                value: value,
                heldInterest: heldInterest,
                valueDate: valueDate,
                rate: rate,
                rateDate: rateDate,
                share: share,
                section: section,
                notice: notice,
                extraKind: extraKind,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZakatFrozenLinesTable, ZakatFrozenLineRow>(
                    table,
                  ),
                  $$ZakatFrozenLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({yearId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (yearId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.yearId,
                        referencedTable: $$ZakatFrozenLinesTableReferences
                            ._yearIdTable(db),
                        referencedColumn: $$ZakatFrozenLinesTableReferences
                            ._yearIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ZakatFrozenLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZakatFrozenLinesTable,
      ZakatFrozenLineRow,
      $$ZakatFrozenLinesTableFilterComposer,
      $$ZakatFrozenLinesTableOrderingComposer,
      $$ZakatFrozenLinesTableAnnotationComposer,
      $$ZakatFrozenLinesTableCreateCompanionBuilder,
      $$ZakatFrozenLinesTableUpdateCompanionBuilder,
      (ZakatFrozenLineRow, $$ZakatFrozenLinesTableReferences),
      ZakatFrozenLineRow,
      PrefetchHooks Function({bool yearId})
    >;
typedef $$ZakatGiftsTableCreateCompanionBuilder = ZakatGiftsCompanion Function({
  required String id,
  required String yearId,
  required DateTime date,
  required Decimal amount,
  required String unit,
  Value<Decimal?> rate,
  Value<DateTime?> rateDate,
  Value<String?> rateView,
  Value<String?> note,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ZakatGiftsTableUpdateCompanionBuilder = ZakatGiftsCompanion Function({
  Value<String> id,
  Value<String> yearId,
  Value<DateTime> date,
  Value<Decimal> amount,
  Value<String> unit,
  Value<Decimal?> rate,
  Value<DateTime?> rateDate,
  Value<String?> rateView,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ZakatGiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ZakatGiftsTable, ZakatGiftRow> {
  $$ZakatGiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ZakatYearsTable _yearIdTable(_$AppDatabase db) =>
      db.zakatYears.createAlias('zakat_gifts__year_id__zakat_years__id');

  $$ZakatYearsTableProcessedTableManager get yearId {
    final $_column = $_itemColumn<String>('year_id')!;

    final manager = $$ZakatYearsTableTableManager(
      $_db,
      $_db.zakatYears,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_yearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ZakatGiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ZakatGiftsTable> {
  $$ZakatGiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Decimal, Decimal, String> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Decimal?, Decimal, String> get rate =>
      $composableBuilder(
        column: $table.rate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get rateDate =>
      $composableBuilder(
        column: $table.rateDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get rateView => $composableBuilder(
    column: $table.rateView,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ZakatYearsTableFilterComposer get yearId {
    final $$ZakatYearsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableFilterComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatGiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ZakatGiftsTable> {
  $$ZakatGiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateDate => $composableBuilder(
    column: $table.rateDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateView => $composableBuilder(
    column: $table.rateView,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ZakatYearsTableOrderingComposer get yearId {
    final $$ZakatYearsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableOrderingComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatGiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ZakatGiftsTable> {
  $$ZakatGiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal, String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Decimal?, String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, String> get rateDate =>
      $composableBuilder(column: $table.rateDate, builder: (column) => column);

  GeneratedColumn<String> get rateView =>
      $composableBuilder(column: $table.rateView, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ZakatYearsTableAnnotationComposer get yearId {
    final $$ZakatYearsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.zakatYears,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ZakatYearsTableAnnotationComposer(
            $db: $db,
            $table: $db.zakatYears,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ZakatGiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZakatGiftsTable,
          ZakatGiftRow,
          $$ZakatGiftsTableFilterComposer,
          $$ZakatGiftsTableOrderingComposer,
          $$ZakatGiftsTableAnnotationComposer,
          $$ZakatGiftsTableCreateCompanionBuilder,
          $$ZakatGiftsTableUpdateCompanionBuilder,
          (ZakatGiftRow, $$ZakatGiftsTableReferences),
          ZakatGiftRow,
          PrefetchHooks Function({bool yearId})
        > {
  $$ZakatGiftsTableTableManager(_$AppDatabase db, $ZakatGiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ZakatGiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ZakatGiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ZakatGiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> yearId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<Decimal> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<Decimal?> rate = const Value.absent(),
                Value<DateTime?> rateDate = const Value.absent(),
                Value<String?> rateView = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ZakatGiftsCompanion(
                id: id,
                yearId: yearId,
                date: date,
                amount: amount,
                unit: unit,
                rate: rate,
                rateDate: rateDate,
                rateView: rateView,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String yearId,
                required DateTime date,
                required Decimal amount,
                required String unit,
                Value<Decimal?> rate = const Value.absent(),
                Value<DateTime?> rateDate = const Value.absent(),
                Value<String?> rateView = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ZakatGiftsCompanion.insert(
                id: id,
                yearId: yearId,
                date: date,
                amount: amount,
                unit: unit,
                rate: rate,
                rateDate: rateDate,
                rateView: rateView,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZakatGiftsTable, ZakatGiftRow>(table),
                  $$ZakatGiftsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({yearId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (yearId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.yearId,
                        referencedTable: $$ZakatGiftsTableReferences
                            ._yearIdTable(db),
                        referencedColumn: $$ZakatGiftsTableReferences
                            ._yearIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ZakatGiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZakatGiftsTable,
      ZakatGiftRow,
      $$ZakatGiftsTableFilterComposer,
      $$ZakatGiftsTableOrderingComposer,
      $$ZakatGiftsTableAnnotationComposer,
      $$ZakatGiftsTableCreateCompanionBuilder,
      $$ZakatGiftsTableUpdateCompanionBuilder,
      (ZakatGiftRow, $$ZakatGiftsTableReferences),
      ZakatGiftRow,
      PrefetchHooks Function({bool yearId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InvestmentsTableTableManager get investments =>
      $$InvestmentsTableTableManager(_db, _db.investments);
  $$HistoryEntriesTableTableManager get historyEntries =>
      $$HistoryEntriesTableTableManager(_db, _db.historyEntries);
  $$RatesTableTableManager get rates =>
      $$RatesTableTableManager(_db, _db.rates);
  $$InflationOverridesTableTableManager get inflationOverrides =>
      $$InflationOverridesTableTableManager(_db, _db.inflationOverrides);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$NoZakatYearsTableTableManager get noZakatYears =>
      $$NoZakatYearsTableTableManager(_db, _db.noZakatYears);
  $$ZakatCyclesTableTableManager get zakatCycles =>
      $$ZakatCyclesTableTableManager(_db, _db.zakatCycles);
  $$ZakatYearsTableTableManager get zakatYears =>
      $$ZakatYearsTableTableManager(_db, _db.zakatYears);
  $$ZakatExtraLinesTableTableManager get zakatExtraLines =>
      $$ZakatExtraLinesTableTableManager(_db, _db.zakatExtraLines);
  $$ZakatFrozenLinesTableTableManager get zakatFrozenLines =>
      $$ZakatFrozenLinesTableTableManager(_db, _db.zakatFrozenLines);
  $$ZakatGiftsTableTableManager get zakatGifts =>
      $$ZakatGiftsTableTableManager(_db, _db.zakatGifts);
}
