/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/db/app_database.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/core/storage_exceptions.dart';
import 'package:financial_planner/features/investments/domain/zakat_rules.dart';
import 'package:financial_planner/features/zakat/data/drift_zakat_repository.dart';
import 'package:financial_planner/features/zakat/domain/zakat_year.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
Decimal d(String s) => Decimal.parse(s);

// 20 decimal places: the precision the converter must keep (ADR-0001, D2).
final long = d('123456789.12345678901234567890');
final due = day(2026, 10, 20);

late AppDatabase db;
late DriftZakatRepository repo;
final clock = DateTime.utc(2026, 10, 23, 9);

FrozenLine frozenLine(
  String name, {
  bool extra = false,
  ZakatNotice? notice,
  String? refId,
}) => FrozenLine(
  refId: refId ?? 'ref-$name',
  isExtra: extra,
  extraKind: extra ? ExtraKind.owedToMe : null,
  name: name,
  unit: usd,
  value: long,
  heldInterest: d('0.00000000000000000001'),
  valueDate: day(2026, 10, 1),
  rate: d('48.12345678901234567890'),
  rateDate: day(2026, 10, 20),
  share: d('0.25000000000000000000'),
  section: 'B3',
  notice: notice,
);

FrozenYear frozenYear({List<FrozenLine>? lines, DateTime? startedOn}) =>
    FrozenYear(
      startedOn: startedOn ?? day(2026, 10, 23),
      base: egp,
      nisab: NisabMetal.silver,
      metalRate: d('60.12345678901234567890'),
      metalRateDate: day(2026, 10, 19),
      lines: lines ?? [frozenLine('a'), frozenLine('b')],
    );

Gift gift({String? id, String amount = '100', DateTime? on}) => Gift(
  id: id,
  date: on ?? day(2026, 10, 22),
  amount: Money(d(amount), usd),
  rate: d('50.12345678901234567890'),
  rateDate: day(2026, 10, 21),
  view: GivingRateView.dayGiven,
  note: 'Masjid',
);

ExtraLine extraLine({String id = 'x1', String label = 'Loan'}) => ExtraLine(
  id: id,
  label: label,
  kind: ExtraKind.owedToMe,
  amount: Money(long, usd),
  goodDebtConfirmed: true,
);

Future<ZakatYearRecord> only() async => (await repo.watchYears().first).single;

Future<int> rows(dynamic table) async => (await db.select(table).get()).length;

void main() {
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftZakatRepository(db, () => clock);
  });
  tearDown(() => db.close());

  test('AC-20 reading years writes nothing: no rows exist until the user decides something', () async {
    expect(await repo.watchYears().first, isEmpty);
    expect(await rows(db.zakatYears), 0);
    expect(await rows(db.zakatExtraLines), 0);
    expect(await rows(db.zakatFrozenLines), 0);
    expect(await rows(db.zakatGifts), 0);
  });

  test('saveYear stores the move, the debts at 20 places and the switch, and edits the same row', () async {
    await repo.saveYear(
      due,
      movedDue: day(2026, 10, 18),
      debts: long,
      deductDebts: false,
    );
    var y = await only();
    expect(y.dueKey, due);
    expect(y.movedDue, day(2026, 10, 18));
    expect(y.debts, long);
    expect(y.deductDebts, isFalse);
    expect(y.extras, isEmpty);
    expect(y.frozen, isNull);
    expect(y.gifts, isEmpty);

    await repo.saveYear(due, debts: d('5'), deductDebts: true);
    y = await only();
    expect((y.movedDue, y.debts, y.deductDebts), (null, d('5'), true));
    expect(await rows(db.zakatYears), 1);
  });

  test('years come back oldest due date first', () async {
    await repo.saveYear(day(2027, 10, 20), debts: d('1'), deductDebts: true);
    await repo.saveYear(due, debts: d('2'), deductDebts: true);
    expect((await repo.watchYears().first).map((y) => y.dueKey), [
      due,
      day(2027, 10, 20),
    ]);
  });

  test(
    'an extra line round-trips every field; saving the same id edits it',
    () async {
      await repo.saveExtraLine(due, extraLine());
      var e = (await only()).extras.single;
      expect((e.id, e.label, e.kind), ('x1', 'Loan', ExtraKind.owedToMe));
      expect((e.amount.amount, e.amount.unit), (long, usd));
      expect(e.goodDebtConfirmed, isTrue);

      await repo.saveExtraLine(due, extraLine(label: 'Loan to my brother'));
      e = (await only()).extras.single;
      expect(e.label, 'Loan to my brother');
      expect(await rows(db.zakatExtraLines), 1);
    },
  );

  test(
    'deleting an extra line and saving it again (Undo) brings it back',
    () async {
      await repo.saveExtraLine(due, extraLine());
      await repo.deleteExtraLine('x1');
      expect((await only()).extras, isEmpty);
      await repo.saveExtraLine(due, extraLine());
      expect((await only()).extras.single.id, 'x1');
      await expectLater(repo.deleteExtraLine('nope'), throwsA(isA<NotFound>()));
    },
  );

  test(
    'freeze stores every input at 20 places and reads them back in order',
    () async {
      final f = frozenYear(
        lines: [
          frozenLine('a', notice: ZakatNotice.dividendsCountedWithCash),
          frozenLine('b', extra: true, refId: 'x1'),
          FrozenLine(
            name: 'c',
            unit: egp,
            value: d('1'),
            heldInterest: Decimal.zero,
            share: Decimal.one,
            section: 'B1',
          ),
        ],
      );
      await repo.freeze(due, f);
      final stored = (await only()).frozen!;
      expect(stored.startedOn, day(2026, 10, 23));
      expect((stored.base, stored.nisab), (egp, NisabMetal.silver));
      expect(stored.metalRate, d('60.12345678901234567890'));
      expect(stored.metalRateDate, day(2026, 10, 19));
      expect(stored.lines.map((l) => l.name), ['a', 'b', 'c']);

      final a = stored.lines[0];
      expect((a.refId, a.isExtra, a.extraKind), ('ref-a', false, null));
      expect(
        (a.unit, a.value, a.heldInterest),
        (usd, long, d('0.00000000000000000001')),
      );
      expect(
        (a.valueDate, a.rate, a.rateDate),
        (day(2026, 10, 1), d('48.12345678901234567890'), day(2026, 10, 20)),
      );
      expect(
        (a.share, a.section, a.notice),
        (d('0.25'), 'B3', ZakatNotice.dividendsCountedWithCash),
      );
      final b = stored.lines[1];
      expect(
        (b.refId, b.isExtra, b.extraKind),
        ('x1', true, ExtraKind.owedToMe),
      );
      final c = stored.lines[2];
      expect(
        (c.refId, c.valueDate, c.rate, c.rateDate, c.notice),
        (null, null, null, null, null),
      );
    },
  );

  test(
    'freezing again (recompute) replaces the lines and keeps the gifts',
    () async {
      await repo.freeze(due, frozenYear());
      await repo.saveGift(due, gift(id: 'g1'));
      await repo.freeze(
        due,
        frozenYear(lines: [frozenLine('only')], startedOn: day(2026, 11, 1)),
      );
      final y = await only();
      expect(y.frozen!.lines.map((l) => l.name), ['only']);
      expect(y.frozen!.startedOn, day(2026, 11, 1));
      expect(y.gifts.single.id, 'g1');
      expect(await rows(db.zakatFrozenLines), 1);
    },
  );

  test(
    'a started year is read-only: its decisions and extra lines throw Conflict',
    () async {
      await repo.saveExtraLine(due, extraLine());
      await repo.freeze(due, frozenYear());
      await expectLater(
        repo.saveYear(due, debts: d('1'), deductDebts: true),
        throwsA(isA<Conflict>()),
      );
      await expectLater(
        repo.saveExtraLine(due, extraLine(id: 'x2')),
        throwsA(isA<Conflict>()),
      );
      await expectLater(repo.deleteExtraLine('x1'), throwsA(isA<Conflict>()));
      expect((await only()).extras.single.id, 'x1');
    },
  );

  test(
    'AC-26 a gift on a year that is not started, or unknown, throws Conflict',
    () async {
      await expectLater(repo.saveGift(due, gift()), throwsA(isA<Conflict>()));
      await repo.saveYear(due, debts: d('0'), deductDebts: true);
      await expectLater(repo.saveGift(due, gift()), throwsA(isA<Conflict>()));
      expect(await rows(db.zakatGifts), 0);
    },
  );

  test(
    'a gift round-trips every field at 20 places, edits by id and deletes',
    () async {
      await repo.freeze(due, frozenYear());
      await repo.saveGift(due, gift(id: 'g1'));
      var g = (await only()).gifts.single;
      expect(
        (g.id, g.date, g.amount),
        ('g1', day(2026, 10, 22), Money(d('100'), usd)),
      );
      expect(
        (g.rate, g.rateDate, g.view, g.note),
        (
          d('50.12345678901234567890'),
          day(2026, 10, 21),
          GivingRateView.dayGiven,
          'Masjid',
        ),
      );

      await repo.saveGift(due, gift(id: 'g1', amount: long.toString()));
      g = (await only()).gifts.single;
      expect(g.amount.amount, long);
      expect(await rows(db.zakatGifts), 1);

      await repo.saveGift(
        due,
        Gift(id: 'g2', date: day(2026, 10, 21), amount: Money(d('5'), egp)),
      );
      final gifts = (await only()).gifts;
      expect(gifts.map((x) => x.id), ['g2', 'g1']);
      expect(
        (gifts.first.rate, gifts.first.rateDate, gifts.first.view),
        (null, null, null),
      );

      await repo.deleteGift('g1');
      expect((await only()).gifts.map((x) => x.id), ['g2']);
      await expectLater(repo.deleteGift('nope'), throwsA(isA<NotFound>()));
    },
  );

  test('AC-43 unfreeze returns the year to due while the log is empty; a gift makes it a Conflict', () async {
    await repo.saveYear(due, debts: d('7'), deductDebts: true);
    await repo.freeze(due, frozenYear());
    await repo.unfreeze(due);
    var y = await only();
    expect(y.frozen, isNull);
    expect(y.debts, d('7'));
    expect(await rows(db.zakatFrozenLines), 0);

    await repo.freeze(due, frozenYear());
    await repo.saveGift(due, gift());
    await expectLater(repo.unfreeze(due), throwsA(isA<Conflict>()));
    y = await only();
    expect(y.frozen, isNotNull);
    expect(y.gifts, hasLength(1));
  });

  test('unfreezing a year that was never started is NotFound', () async {
    await expectLater(repo.unfreeze(due), throwsA(isA<NotFound>()));
    await repo.saveYear(due, debts: d('0'), deductDebts: true);
    await expectLater(repo.unfreeze(due), throwsA(isA<NotFound>()));
  });

  test('deleting a year row removes its extra lines, frozen lines and gifts (cascade)', () async {
    await repo.saveExtraLine(due, extraLine());
    await repo.freeze(due, frozenYear());
    await repo.saveGift(due, gift());
    await db.delete(db.zakatYears).go();
    expect(await rows(db.zakatExtraLines), 0);
    expect(await rows(db.zakatFrozenLines), 0);
    expect(await rows(db.zakatGifts), 0);
  });

  test(
    'the stream emits again after each write to any of the four tables',
    () async {
      final seen = <int>[];
      final sub = repo.watchYears().listen((ys) => seen.add(ys.length));
      await pumpEventQueue();
      await repo.saveYear(due, debts: d('0'), deductDebts: true);
      await pumpEventQueue();
      await repo.freeze(due, frozenYear());
      await pumpEventQueue();
      await repo.saveGift(due, gift());
      await pumpEventQueue();
      await sub.cancel();
      expect(seen.first, 0);
      expect(seen.length, greaterThanOrEqualTo(4));
      expect(seen.last, 1);
    },
  );

  test('timestamps are written in UTC from the clock', () async {
    await repo.saveYear(due, debts: d('0'), deductDebts: true);
    final row = await db.select(db.zakatYears).getSingle();
    expect(row.createdAt.toUtc(), clock);
    expect(row.updatedAt.toUtc(), clock);
  });

  test('a unique due key is enforced by the schema', () async {
    await repo.saveYear(due, debts: d('0'), deductDebts: true);
    await expectLater(
      db
          .into(db.zakatYears)
          .insert(
            ZakatYearsCompanion.insert(
              id: 'other',
              dueKey: due,
              createdAt: clock,
              updatedAt: clock,
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('AC-29 a gift in one year changes no other year: log, start and state stay as they were', () async {
    final next = day(2027, 10, 20);
    await repo.freeze(due, frozenYear());
    await repo.freeze(next, frozenYear());
    await repo.saveYear(day(2028, 10, 20), debts: d('3'), deductDebts: true);
    await repo.saveGift(due, gift(id: 'g1', amount: '13000'));
    final years = {for (final y in await repo.watchYears().first) y.dueKey: y};
    expect(years[due]!.gifts.map((g) => g.id), ['g1']);
    expect(years[next]!.gifts, isEmpty);
    expect(years[next]!.frozen, isNotNull);
    expect(years[day(2028, 10, 20)]!.gifts, isEmpty);
    expect(years[day(2028, 10, 20)]!.frozen, isNull);
    await repo.deleteGift('g1');
    expect(
      (await repo.watchYears().first).every((y) => y.gifts.isEmpty),
      isTrue,
    );
  });
}
