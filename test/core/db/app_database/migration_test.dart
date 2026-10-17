// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:financial_planner/core/assumptions/data/drift_assumptions_repository.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/core/storage_exceptions.dart';
import 'package:financial_planner/features/investments/data/drift_investments_repository.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/zakat_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

const _created = 1767225600; // 2026-01-01T00:00:00Z
const _twentyDp = '1234.12345678901234567890';

final _oldItem = v1.InvestmentsData(
  id: 'o',
  name: 'Rent flat',
  assetType: 'other',
  intent: 'rental',
  market: 'other',
  marketCountry: 'EGY',
  unit: 'EGP',
  startDate: '2025-03-01',
  quantity: '2.5',
  purityKarat: 21,
  purityFineness: 925,
  zakatRule: 'custom',
  customZakatShare: '0.4',
  inflationOverride: 'USA',
  notes: 'note',
  createdAt: _created,
  updatedAt: _created,
);

const _kinds = {
  'money_in': '1000',
  'sale': '100',
  'income': '40',
  'interest_kept_inside': '5',
  'interest_paid_out': '6',
  'interest_given_away_inside': '1',
  'interest_given_away_paid_out': '2',
};

List<v1.HistoryEntriesData> _oldHistory() => [
  for (final (n, e) in _kinds.entries.indexed)
    v1.HistoryEntriesData(
      id: 'h${e.key}',
      investmentId: 'o',
      kind: e.key,
      date: '2025-0${4 + n % 5}-01',
      amount: e.value,
      unit: 'EGP',
      createdAt: _created,
      updatedAt: _created,
    ),
  const v1.HistoryEntriesData(
    id: 'hvalue',
    investmentId: 'o',
    kind: 'value_update',
    date: '2025-12-31',
    amount: _twentyDp,
    createdAt: _created,
    updatedAt: _created,
  ),
];

void _insertV1(Batch batch, v1.DatabaseAtV1 oldDb) {
  batch.insertAll(oldDb.investments, [_oldItem]);
  batch.insertAll(oldDb.historyEntries, _oldHistory());
  batch.insertAll(oldDb.rates, const [
    v1.RatesData(
      id: 'rt',
      fromUnit: 'USD',
      toUnit: 'EGP',
      rate: '48.5',
      asOf: '2025-06-01',
      source: 'typed',
      createdAt: _created,
      updatedAt: _created,
    ),
    v1.RatesData(
      id: 'rf',
      fromUnit: 'USD',
      toUnit: 'EGP',
      rate: '48.75',
      asOf: '2025-06-01',
      source: 'currencyApi',
      createdAt: _created,
      updatedAt: _created,
    ),
  ]);
  batch.insertAll(oldDb.inflationOverrides, const [
    v1.InflationOverridesData(
      id: 'io',
      country: 'EGY',
      year: 2025,
      rate: '0.25',
      createdAt: _created,
      updatedAt: _created,
    ),
  ]);
  batch.insertAll(oldDb.settings, const [
    v1.SettingsData(
      id: 'settings',
      baseCurrency: 'EGP',
      homeInflation: 'EGY',
      zakatYear: 'lunar',
      longTermMethod: 'proxy25',
      jewelleryZakatable: 1,
      createdAt: _created,
      updatedAt: _created,
    ),
  ]);
  batch.insertAll(oldDb.noZakatYears, const [
    v1.NoZakatYearsData(
      id: 'nz',
      year: 2024,
      createdAt: _created,
      updatedAt: _created,
    ),
  ]);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test(
    'migration from v1 to v2 keeps every row; the plan columns are null',
    () async {
      final o = _oldItem;
      await verifier.testWithDataIntegrity(
        oldVersion: 1,
        newVersion: 2,
        createOld: v1.DatabaseAtV1.new,
        createNew: v2.DatabaseAtV2.new,
        openTestedDatabase: AppDatabase.new,
        createItems: _insertV1,
        validateItems: (newDb) async {
          expect(await newDb.select(newDb.investments).get(), [
            v2.InvestmentsData(
              id: o.id,
              name: o.name,
              assetType: o.assetType,
              intent: o.intent,
              market: o.market,
              marketCountry: o.marketCountry,
              unit: o.unit,
              startDate: o.startDate,
              quantity: o.quantity,
              purityKarat: o.purityKarat,
              purityFineness: o.purityFineness,
              zakatRule: o.zakatRule,
              customZakatShare: o.customZakatShare,
              inflationOverride: o.inflationOverride,
              notes: o.notes,
              createdAt: o.createdAt,
              updatedAt: o.updatedAt,
            ),
          ]);
          final history = await newDb.select(newDb.historyEntries).get();
          expect(
            [for (final h in history) (h.id, h.kind, h.date, h.amount, h.unit)],
            [
              for (final h in _oldHistory())
                (h.id, h.kind, h.date, h.amount, h.unit),
            ],
          );
          expect((await newDb.select(newDb.rates).get()).length, 2);
          expect(
            (await newDb.select(newDb.inflationOverrides).get()).length,
            1,
          );
          expect((await newDb.select(newDb.settings).get()).length, 1);
          expect((await newDb.select(newDb.noZakatYears).get()).length, 1);
        },
      );
    },
  );

  test('AC-46 after the update, v1 data reads back the same through the repositories; "other" stays "other"', () async {
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    await old.batch((b) => _insertV1(b, old));
    await old.close();

    final db = AppDatabase(schema.newConnection());
    final now = DateTime.utc(2026, 10, 17);
    final investments = DriftInvestmentsRepository(db, () => now);
    final assumptions = DriftAssumptionsRepository(db, () => now);

    final agg = (await investments.watchAll().first).single;
    final i = agg.investment;
    expect(i.type, AssetType.other);
    expect(i.intent, Intent.rental);
    expect(i.zakatRule, ZakatRule.custom);
    expect(i.customZakatShare, Decimal.parse('0.4'));
    expect(resolve(i, const Settings()).share, Decimal.parse('0.4'));
    expect(i.quantity, Decimal.parse('2.5'));
    expect((i.purityKarat, i.purityFineness), (21, 925));
    expect(i.inflationOverride, const Country('USA'));
    expect(i.notes, 'note');
    expect(i.startDate, day(2025, 3, 1));
    for (final v in [
      i.payoutSchedule,
      i.expectedProfit,
      i.valueCheckSchedule,
      i.expectedGrowth,
      i.profitBasis,
      i.capitalBack,
      i.accountKind,
    ]) {
      expect(v, isNull);
    }

    final h = agg.history;
    expect(h.length, 8);
    expect(
      h.whereType<MoneyIn>().single.amount,
      Money(Decimal.parse('1000'), const Unit('EGP')),
    );
    expect(
      h.whereType<MoneyOut>().map((x) => (x.kind, x.amount.amount)).toSet(),
      {
        (MoneyOutKind.sale, Decimal.parse('100')),
        (MoneyOutKind.income, Decimal.parse('40')),
      },
    );
    expect(
      h.whereType<InterestRecord>().map((x) => x.kind).toSet(),
      InterestKind.values.toSet(),
    );
    expect(h.whereType<ValueUpdate>().single.value, Decimal.parse(_twentyDp));

    final rates = await assumptions.watchRates().first;
    expect(rates.map((r) => (r.source, r.rate)).toSet(), {
      (RateSource.typed, Decimal.parse('48.5')),
      (RateSource.currencyApi, Decimal.parse('48.75')),
    });
    final overrides = await assumptions.watchInflationOverrides().first;
    expect(overrides.single.rate, Decimal.parse('0.25'));
    final s = await assumptions.watchSettings().first;
    expect(s.baseCurrency, const Unit('EGP'));
    expect(s.zakatYear, ZakatYear.lunar);
    expect(s.longTermMethod, LongTermMethod.proxy25);
    expect(s.jewelleryZakatable, isTrue);
    expect(await assumptions.watchNoZakatYears().first, {2024});

    await expectLater(
      investments.saveEntries([
        ValueUpdate(
          investmentId: 'o',
          date: day(2025, 12, 31),
          value: Decimal.one,
        ),
      ]),
      throwsA(isA<Conflict>()),
    );
    await db.close();
  });
}
