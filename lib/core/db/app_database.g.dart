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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
    createdAt,
    updatedAt,
  );
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

  /// money_in, sale, income, interest_*, value_update
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
  final DateTime createdAt;
  final DateTime updatedAt;
  const SettingsRow({
    required this.id,
    this.baseCurrency,
    this.homeInflation,
    this.zakatYear,
    this.longTermMethod,
    this.jewelleryZakatable,
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
  late final Index historyByInvestmentDate = Index(
    'history_by_investment_date',
    'CREATE INDEX history_by_investment_date ON history_entries (investment_id, date)',
  );
  late final Index ratesByPair = Index(
    'rates_by_pair',
    'CREATE INDEX rates_by_pair ON rates (from_unit, to_unit, as_of)',
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
    historyByInvestmentDate,
    ratesByPair,
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
}
