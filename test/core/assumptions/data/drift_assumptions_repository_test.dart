/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/data/drift_assumptions_repository.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/core/storage_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

const usd = Unit('USD');
const egp = Unit('EGP');
const egy = Country('EGY');
Decimal d(String s) => Decimal.parse(s);

late AppDatabase db;
late DriftAssumptionsRepository repo;
var clock = DateTime.utc(2026, 10, 16, 9);

Rate rate(
  String id,
  String r,
  DateTime on, {
  RateSource source = RateSource.typed,
}) => Rate(id: id, from: usd, to: egp, rate: d(r), asOf: on, source: source);

void main() {
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftAssumptionsRepository(db, () => clock);
  });
  tearDown(() => db.close());

  test('AC-28: a typed and a fetched rate on the same day are both kept and the typed one is used', () async {
    final on = day(2026, 10, 15);
    await repo.saveFetchedRates([
      rate('f', '48.50', on, source: RateSource.currencyApi),
    ]);
    await repo.saveTypedRate(rate('t', '49.00', on));
    final stored = await repo.watchRates().first;
    expect(stored.length, 2);
    expect(RateBook(stored).quote(usd, egp, on)!.rate, d('49.00'));
  });

  test('a typed rate for the same pair and day is updated, not duplicated, and keeps its id', () async {
    final on = day(2026, 10, 15);
    await repo.saveTypedRate(rate('t1', '49.00', on));
    await repo.saveTypedRate(rate('t2', '50.00', on));
    final stored = await repo.watchRates().first;
    expect(stored.single.id, 't1');
    expect(stored.single.rate, d('50.00'));
  });

  test(
    'editing a typed rate keeps its id: a new date and value replace the row',
    () async {
      await repo.saveTypedRate(rate('t1', '49.00', day(2026, 10, 15)));
      await repo.saveTypedRate(rate('t1', '51.00', day(2026, 10, 20)));
      final stored = await repo.watchRates().first;
      expect(stored.single.id, 't1');
      expect(stored.single.rate, d('51.00'));
      expect(stored.single.asOf, day(2026, 10, 20));
    },
  );

  test('moving a typed rate onto a day that already has a typed rate is a Conflict', () async {
    await repo.saveTypedRate(rate('t1', '49', day(2026, 10, 15)));
    await repo.saveTypedRate(rate('t2', '50', day(2026, 10, 16)));
    await expectLater(
      repo.saveTypedRate(rate('t2', '50', day(2026, 10, 15))),
      throwsA(isA<Conflict>()),
    );
  });

  test('fetched rates: existing pair and day is skipped, the count is what was inserted', () async {
    final on = day(2026, 10, 15);
    expect(
      await repo.saveFetchedRates([
        rate('a', '48.5', on, source: RateSource.currencyApi),
        rate('b', '48.6', day(2026, 10, 14), source: RateSource.currencyApi),
      ]),
      2,
    );
    expect(
      await repo.saveFetchedRates([
        rate('c', '99', on, source: RateSource.currencyApi),
        rate('d', '48.7', day(2026, 10, 13), source: RateSource.currencyApi),
      ]),
      1,
    );
    final stored = await repo.watchRates().first;
    expect(stored.length, 3);
    expect(stored.where((r) => r.asOf == on).single.rate, d('48.5'));
  });

  test('rates keep 20 decimals, source and date; deleteRate removes one and unknown is NotFound', () async {
    await repo.saveTypedRate(
      rate('t', '0.12345678901234567890', day(2026, 1, 1)),
    );
    final r = (await repo.watchRates().first).single;
    expect(r.rate, d('0.12345678901234567890'));
    expect(r.source, RateSource.typed);
    expect(r.asOf, day(2026, 1, 1));
    await repo.deleteRate('t');
    expect(await repo.watchRates().first, isEmpty);
    await expectLater(repo.deleteRate('t'), throwsA(isA<NotFound>()));
  });

  test('AC-32: an override is stored once per country and year, wins over a changed shipped value, and clearing restores shipped', () async {
    await repo.setInflationOverride(egy, 2025, d('0.30'));
    await repo.setInflationOverride(egy, 2025, d('0.31'));
    final overrides = await repo.watchInflationOverrides().first;
    expect(overrides.single.rate, d('0.31'));

    final updatedShipped = ShippedInflation(
      series: {
        egy: {2025: d('0.28')},
      },
    );
    expect(
      InflationBook(updatedShipped, overrides).forYear(egy, 2025)!.rate,
      d('0.31'),
    );

    await repo.clearInflationOverride(egy, 2025);
    final after = await repo.watchInflationOverrides().first;
    expect(after, isEmpty);
    expect(
      InflationBook(updatedShipped, after).forYear(egy, 2025)!.rate,
      d('0.28'),
    );
  });

  test(
    'settings: empty store means nothing answered; save replaces the one row',
    () async {
      expect((await repo.watchSettings().first).setupDone, isFalse);
      await repo.saveSettings(
        const Settings(
          baseCurrency: egp,
          homeInflation: Country('USA'),
          zakatYear: ZakatYear.solar,
          longTermMethod: LongTermMethod.proxy25,
          jewelleryZakatable: false,
        ),
      );
      var s = await repo.watchSettings().first;
      expect(
        (
          s.baseCurrency,
          s.homeInflation,
          s.zakatYear,
          s.longTermMethod,
          s.jewelleryZakatable,
        ),
        (
          egp,
          const Country('USA'),
          ZakatYear.solar,
          LongTermMethod.proxy25,
          false,
        ),
      );

      await repo.saveSettings(const Settings(baseCurrency: usd));
      s = await repo.watchSettings().first;
      expect(s.baseCurrency, usd);
      expect(s.zakatYear, isNull);
      expect(s.jewelleryZakatable, isNull);
      expect((await db.select(db.appSettings).get()).length, 1);
    },
  );

  test(
    'every write stamps createdAt and updatedAt (UTC) from the clock',
    () async {
      final first = clock;
      await repo.saveTypedRate(rate('t', '49', day(2026, 10, 15)));
      await repo.saveFetchedRates([
        rate('f', '48', day(2026, 10, 14), source: RateSource.currencyApi),
      ]);
      await repo.setInflationOverride(egy, 2025, d('0.3'));
      clock = clock.add(const Duration(hours: 1));
      await repo.saveTypedRate(rate('t2', '50', day(2026, 10, 15)));
      await repo.setInflationOverride(egy, 2025, d('0.4'));
      final rates = {for (final r in await repo.watchRates().first) r.id: r};
      expect((rates['t']!.createdAt, rates['t']!.updatedAt), (first, clock));
      expect((rates['f']!.createdAt, rates['f']!.updatedAt), (first, first));
      final o = (await repo.watchInflationOverrides().first).single;
      expect((o.createdAt, o.updatedAt), (first, clock));
      expect(o.createdAt.isUtc, isTrue);
    },
  );

  test('no-zakat years can be set twice and cleared', () async {
    await repo.setNoZakatYear(2026, noZakat: true);
    await repo.setNoZakatYear(2026, noZakat: true);
    await repo.setNoZakatYear(2025, noZakat: true);
    expect(await repo.watchNoZakatYears().first, {2025, 2026});
    await repo.setNoZakatYear(2026, noZakat: false);
    expect(await repo.watchNoZakatYears().first, {2025});
  });

  test('zakat prefs: a fresh store reads the product defaults; every field round-trips', () async {
    expect((await repo.watchSettings().first).zakat.reminderMinute, 540);
    await repo.saveSettings(const Settings(baseCurrency: usd));
    final fresh = (await repo.watchSettings().first).zakat;
    expect(fresh.nisab, isNull);
    expect(
      (fresh.reminderOn, fresh.reminderDays, fresh.reminderMinute),
      (true, 0, 540),
    );
    expect((fresh.reminderAsked, fresh.givingRateView), (false, null));

    await repo.saveSettings(
      const Settings(
        baseCurrency: usd,
        zakat: ZakatPrefs(
          nisab: NisabMetal.silver,
          reminderOn: false,
          reminderDays: 3,
          reminderMinute: 1230,
          reminderAsked: true,
          givingRateView: GivingRateView.dueDate,
        ),
      ),
    );
    final z = (await repo.watchSettings().first).zakat;
    expect(z.nisab, NisabMetal.silver);
    expect(
      (z.reminderOn, z.reminderDays, z.reminderMinute, z.reminderAsked),
      (false, 3, 1230, true),
    );
    expect(z.givingRateView, GivingRateView.dueDate);
  });

  test('ZakatPrefs.copyWith changes only the named fields', () {
    const base = ZakatPrefs(nisab: NisabMetal.gold, reminderDays: 2);
    final c = base.copyWith(reminderOn: false);
    expect(
      (c.nisab, c.reminderOn, c.reminderDays, c.reminderMinute),
      (NisabMetal.gold, false, 2, 540),
    );
  });

  ZakatCycle cycle(
    String id,
    DateTime from, {
    int month = 10,
    int dayOf = 20,
  }) => ZakatCycle(
    id: id,
    calendar: ZakatYear.solar,
    month: month,
    day: dayOf,
    from: from,
  );

  test('saveZakatCycle writes settings and the cycle together; cycles come back ordered by from', () async {
    const s1 = Settings(baseCurrency: egp, zakatYear: ZakatYear.solar);
    await repo.saveZakatCycle(s1, cycle('a', day(2026, 10, 23), month: 3));
    await repo.saveZakatCycle(s1, cycle('b', day(2027, 10, 21)));
    final cycles = await repo.watchZakatCycles().first;
    expect([for (final c in cycles) c.id], ['a', 'b']);
    expect(cycles.first.calendar, ZakatYear.solar);
    expect((cycles.first.month, cycles.first.day), (3, 20));
    expect(cycles.first.from, day(2026, 10, 23));
    expect((await repo.watchSettings().first).zakatYear, ZakatYear.solar);
  });

  test('AC-6 saveZakatCycle deletes cycles with from at or after the new one and keeps earlier ones', () async {
    const s = Settings(baseCurrency: egp, zakatYear: ZakatYear.solar);
    await repo.saveZakatCycle(s, cycle('a', day(2026, 10, 23)));
    await repo.saveZakatCycle(s, cycle('b', day(2027, 10, 21)));
    await repo.saveZakatCycle(s, cycle('c', day(2027, 10, 21), month: 11));
    await repo.saveZakatCycle(s, cycle('d', day(2026, 12, 1)));
    final cycles = await repo.watchZakatCycles().first;
    expect([for (final c in cycles) c.id], ['a', 'd']);
  });

  test('saveZakatCycle is one transaction: a failing insert leaves the settings as they were', () async {
    const before = Settings(baseCurrency: egp, zakatYear: ZakatYear.lunar);
    await repo.saveZakatCycle(before, cycle('a', day(2026, 10, 23)));
    await expectLater(
      repo.saveZakatCycle(
        const Settings(baseCurrency: egp, zakatYear: ZakatYear.solar),
        cycle('a', day(2027, 1, 1)),
      ),
      throwsA(anything),
    );
    expect((await repo.watchSettings().first).zakatYear, ZakatYear.lunar);
    expect(
      (await repo.watchZakatCycles().first).single.from,
      day(2026, 10, 23),
    );
  });
}
