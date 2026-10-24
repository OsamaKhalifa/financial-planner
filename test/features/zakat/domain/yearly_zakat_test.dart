/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/zakat_rules.dart';
import 'package:financial_planner/features/zakat/domain/yearly_zakat.dart';
import 'package:financial_planner/features/zakat/domain/zakat_year.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
const sar = Unit('SAR');
Decimal d(String s) => Decimal.parse(s);

ZakatLine line(
  String name,
  String value, {
  String? rate = '1',
  String? share = '1',
  Unit unit = egp,
  ZakatQuestion? question,
}) => ZakatLine(
  name: name,
  unit: unit,
  value: d(value),
  heldInterest: Decimal.zero,
  rate: rate == null ? null : d(rate),
  share: share == null ? null : d(share),
  section: 'B1',
  question: question,
);

YearInputs inputs(
  List<ZakatLine> lines, {
  String debts = '0',
  bool deduct = true,
  NisabMetal? nisab = NisabMetal.gold,
  String? metal = '5000',
  ZakatYear calendar = ZakatYear.lunar,
}) => YearInputs(
  base: egp,
  calendar: calendar,
  on: day(2026, 10, 20),
  nisab: nisab,
  metalRate: metal == null ? null : d(metal),
  metalRateDate: metal == null ? null : day(2026, 10, 20),
  lines: lines,
  debts: d(debts),
  deductDebts: deduct,
);

YearSlot slot(
  DateTime due, {
  DateTime? key,
  ZakatYear calendar = ZakatYear.solar,
  int number = 2026,
  DateTime? previousDue,
}) => YearSlot(
  key: key ?? due,
  due: due,
  calendar: calendar,
  number: number,
  previousDue: previousDue ?? day(due.year - 1, due.month, due.day),
);

YearView viewOf(YearSlot s, {ZakatYearRecord? record, DateTime? today}) =>
    yearViewOf(
      s,
      record,
      record?.frozen == null
          ? inputs([line('a', '1000000')])
          : frozenInputs(s, record!),
      today ?? day(2026, 10, 23),
    );

ZakatYearRecord frozenRecord(
  YearSlot s, {
  List<Gift> gifts = const [],
  List<ZakatLine>? lines,
}) => ZakatYearRecord(
  dueKey: s.key,
  debts: Decimal.zero,
  deductDebts: true,
  frozen: freeze(inputs(lines ?? [line('a', '1000000')]), day(2026, 10, 23)),
  gifts: gifts,
);

void main() {
  reminderFireAtTests();
  moneyProperties();
  group('compute', () {
    test('B is the lines minus the deducted debts, never below 0', () {
      final r = compute(
        inputs([line('a', '100'), line('b', '50')], debts: '300'),
      );
      expect((r.linesTotal, r.debtsLine, r.b), (d('150'), d('300'), d('0')));
      expect(r.z, d('0'));
      expect(r.reachesNisab, isFalse);
    });

    test('A5 with deduction off the debts line is 0 and the gross total is compared', () {
      final r = compute(
        inputs([line('a', '500000')], debts: '100000', deduct: false),
      );
      expect((r.debtsLine, r.b), (d('0'), d('500000')));
    });

    test('A1/A2 r is the calendar rate: 2.5 % lunar, 2.577 % solar', () {
      final lines = [line('a', '1000000')];
      expect(compute(inputs(lines)).z, d('25000'));
      expect(compute(inputs(lines, calendar: ZakatYear.solar)).z, d('25770'));
    });

    test('Z is worked out from B, so the lines may differ from it by up to 0.01 each', () {
      final i = inputs([
        line('a', '100.2'),
        line('b', '100.2'),
        line('c', '100.2'),
      ], metal: '0.01');
      final r = compute(i);
      expect(r.z, d('7.52'));
      final perLine = [for (final l in i.lines) l.lineZakat(d('0.025'))!];
      expect(perLine, everyElement(d('2.51')));
      expect(d('7.53') - r.z!, d('0.01'));
    });

    test('round2 rounds half away from zero', () {
      expect(round2(d('7.515')), d('7.52'));
      expect(round2(d('7.514')), d('7.51'));
      expect(round2(d('-7.515')), d('-7.52'));
    });

    test('a line is value x rate x share at full precision', () {
      final l = line('a', '3', rate: '0.123456789', share: '0.25');
      expect(l.inBase, d('0.370370367'));
      expect(l.zakatable, d('0.09259259175'));
    });

    test('B at nisab pays, one cent under does not (A3, C4)', () {
      expect(compute(inputs([line('a', '425000')])).z, d('10625'));
      expect(compute(inputs([line('a', '424999.99')])).z, d('0'));
    });

    test('nisab is grams x the metal rate: gold 85, silver 595', () {
      expect(compute(inputs([line('a', '1')])).nisab, d('425000'));
      expect(
        compute(inputs([line('a', '1')], nisab: NisabMetal.silver, metal: '60'))
            .nisab,
        d('35700'),
      );
    });

    test('a 0 % line is still a line: the year is not empty', () {
      final r = compute(inputs([line('home', '3000000', share: '0')]));
      expect((r.empty, r.linesTotal, r.canStart), (false, d('0'), true));
      expect(r.z, d('0'));
    });

    test('an empty year has no Z and no verdict, even with debts (PM-Q1)', () {
      final r = compute(inputs(const [], debts: '20000'));
      expect((r.empty, r.z, r.canStart), (true, null, false));
    });

    test('a missing rate names the line and leaves no Z', () {
      final r = compute(
        inputs([line('us', '2000', unit: usd, rate: null), line('a', '10')]),
      );
      expect(r.complete, isFalse);
      expect(r.z, isNull);
      expect(r.missing.map((m) => m.$1), [Missing.rate]);
      expect(r.missing.single.$2.map((l) => l.name), ['us']);
      expect(r.linesTotal, d('10'));
    });

    test('an open question names the line and leaves no Z', () {
      final r = compute(
        inputs([
          line('ring', '50', share: null, question: ZakatQuestion.jewellery),
        ]),
      );
      expect(r.missing.map((m) => m.$1), [Missing.question]);
      expect(r.z, isNull);
      expect(r.canStart, isFalse);
    });

    test('no nisab standard and no metal rate are two different reasons', () {
      final none = compute(inputs([line('a', '10')], nisab: null, metal: null));
      expect(none.missing.map((m) => m.$1), [Missing.nisabStandard]);
      expect(none.nisab, isNull);
      final noRate = compute(inputs([line('a', '10')], metal: null));
      expect(noRate.missing.map((m) => m.$1), [Missing.metalRate]);
      expect(noRate.reachesNisab, isNull);
    });

    test('every reason is listed at once', () {
      final r = compute(
        inputs(
          [
            line('us', '1', rate: null),
            line('ring', '1', share: null, question: ZakatQuestion.jewellery),
          ],
          nisab: NisabMetal.gold,
          metal: null,
        ),
      );
      expect(r.missing.map((m) => m.$1), [
        Missing.rate,
        Missing.question,
        Missing.metalRate,
      ]);
    });
  });

  group('freeze (C9, Z10)', () {
    test('keeps the inputs and recomputes the same figures from them', () {
      final i = inputs([
        line('a', '300000'),
        line('b', '2000', unit: usd, rate: '48'),
      ], debts: '1000');
      final live = compute(i);
      final f = freeze(i, day(2026, 10, 23));
      final r = ZakatYearRecord(
        dueKey: day(2026, 10, 20),
        debts: d('1000'),
        deductDebts: true,
        frozen: f,
      );
      final back = frozenInputs(slot(day(2026, 10, 20)), r);
      final again = compute(back);
      expect(
        (again.linesTotal, again.b, again.nisab, again.z),
        (live.linesTotal, live.b, live.nisab, live.z),
      );
      expect(f.startedOn, day(2026, 10, 23));
      expect((f.base, f.nisab, f.metalRate), (egp, NisabMetal.gold, d('5000')));
      expect(f.lines.map((l) => l.name), ['a', 'b']);
      expect(back.on, day(2026, 10, 20));
    });

    test('a year that is incomplete or empty cannot be frozen', () {
      expect(
        () => freeze(inputs(const []), day(2026, 10, 23)),
        throwsStateError,
      );
      expect(
        () => freeze(inputs([line('a', '1', rate: null)]), day(2026, 10, 23)),
        throwsStateError,
      );
      expect(
        () => freeze(inputs([line('a', '1')], nisab: null), day(2026, 10, 23)),
        throwsStateError,
      );
    });
  });

  group('stateOf (story §4, §8)', () {
    final s = slot(day(2026, 10, 20));

    test('open before the due date, due on it and after, by date alone', () {
      expect(
        stateOf(s, null, null, Decimal.zero, day(2026, 10, 19)),
        YearState.open,
      );
      expect(
        stateOf(s, null, null, Decimal.zero, day(2026, 10, 20)),
        YearState.due,
      );
      expect(
        stateOf(s, null, null, Decimal.zero, day(2027, 3, 1)),
        YearState.due,
      );
    });

    test('a started year is distributing until the logged amounts reach Z', () {
      final r = frozenRecord(s);
      final z = compute(frozenInputs(s, r));
      expect(z.z, d('25770'));
      expect(
        stateOf(s, r, z, d('25769.99'), day(2026, 10, 23)),
        YearState.distributing,
      );
      expect(
        stateOf(s, r, z, d('25770'), day(2026, 10, 23)),
        YearState.settled,
      );
      expect(
        stateOf(s, r, z, d('30000'), day(2026, 10, 23)),
        YearState.settled,
      );
    });

    test('AC-31 a started year with Z = 0 is settled at once', () {
      final r = frozenRecord(s, lines: [line('a', '1000')]);
      final z = compute(frozenInputs(s, r));
      expect(z.z, d('0'));
      expect(
        stateOf(s, r, z, Decimal.zero, day(2026, 10, 23)),
        YearState.settled,
      );
    });
  });

  group('yearSlots', () {
    final solar = ZakatCycle(
      calendar: ZakatYear.solar,
      month: 10,
      day: 20,
      from: day(2025, 1, 5),
    );

    test(
      'past years and the open one, oldest first, with real previous dues',
      () {
        final slots = yearSlots([solar], const {}, day(2026, 10, 23));
        expect(slots.map((s) => s.number), [2025, 2026, 2027]);
        expect(slots.map((s) => s.due), [
          day(2025, 10, 20),
          day(2026, 10, 20),
          day(2027, 10, 20),
        ]);
        expect(slots[1].previousDue, day(2025, 10, 20));
        expect(slots[0].previousDue, day(2024, 10, 20));
      },
    );

    test('a moved date is the due date and the next year starts after it, but the key stays', () {
      final slots = yearSlots(
        [solar],
        {day(2025, 10, 20): day(2025, 10, 18)},
        day(2026, 10, 23),
      );
      expect(slots[0].key, day(2025, 10, 20));
      expect(slots[0].due, day(2025, 10, 18));
      expect(slots[1].previousDue, day(2025, 10, 18));
      expect(slots[1].due, day(2026, 10, 20));
    });

    test('the year of today is open on its due date and the next one only the day after', () {
      expect(yearSlots([solar], const {}, day(2026, 10, 20)).last.number, 2026);
      expect(yearSlots([solar], const {}, day(2026, 10, 21)).last.number, 2027);
    });

    test('no cycle, no year', () {
      expect(yearSlots(const [], const {}, day(2026, 10, 23)), isEmpty);
    });

    test('a year moved earlier than the new cycle start still belongs to the old cycle', () {
      final lunar = ZakatCycle(
        calendar: ZakatYear.lunar,
        month: 9,
        day: 1,
        from: day(2026, 1, 5),
      );
      final moved = {day(2027, 2, 8): day(2027, 2, 6)};
      final first = yearSlots([lunar], moved, day(2026, 10, 23));
      final from = newCycleFrom(first, day(2026, 10, 23));
      expect(from, day(2027, 2, 9));
      final both = yearSlots(
        [
          lunar,
          ZakatCycle(calendar: ZakatYear.solar, month: 10, day: 20, from: from),
        ],
        moved,
        day(2026, 10, 23),
      );
      expect(both.map((s) => s.key), [
        day(2026, 2, 18),
        day(2027, 2, 8),
        day(2027, 10, 20),
      ]);
      expect(both[2].previousDue, day(2027, 2, 6));
    });
  });

  group('gifts', () {
    final s = slot(day(2026, 10, 20), previousDue: day(2025, 10, 20));
    Gift gift(String amount, DateTime on, {Unit unit = egp, String? rate}) =>
        Gift(
          date: on,
          amount: Money(d(amount), unit),
          rate: rate == null ? null : d(rate),
        );

    test('earliest date is the day after the previous due date (C6)', () {
      expect(earliestGiftDate(s), day(2025, 10, 21));
    });

    test('validateGift refuses 0, a metal, a date inside the last year and a future date', () {
      final today = day(2026, 10, 23);
      expect(
        validateGift(gift('5000', day(2026, 10, 21)), s, today, egp),
        isEmpty,
      );
      expect(
        validateGift(gift('5000', day(2025, 10, 21)), s, today, egp),
        isEmpty,
      );
      expect(validateGift(gift('5000', day(2025, 10, 20)), s, today, egp), [
        GiftError.dateTooEarly,
      ]);
      expect(validateGift(gift('5000', day(2026, 10, 24)), s, today, egp), [
        GiftError.dateInFuture,
      ]);
      expect(validateGift(gift('0', day(2026, 10, 21)), s, today, egp), [
        GiftError.amount,
      ]);
      expect(
        validateGift(gift('1', day(2026, 10, 21), unit: xauG), s, today, egp),
        [GiftError.unit, GiftError.rate],
      );
    });

    test('validateGift refuses a foreign gift with no rate, so counted never sees one', () {
      final today = day(2026, 10, 23);
      final on = day(2026, 10, 21);
      expect(validateGift(gift('10', on, unit: usd), s, today, egp), [
        GiftError.rate,
      ]);
      expect(
        validateGift(gift('10', on, unit: usd, rate: '48'), s, today, egp),
        isEmpty,
      );
    });

    test('given early means before the real due date', () {
      expect(givenEarly(gift('1', day(2026, 10, 19)), s), isTrue);
      expect(givenEarly(gift('1', day(2026, 10, 20)), s), isFalse);
    });

    test('C8 the rate date is the day given or the due date', () {
      final g = gift('100', day(2026, 10, 22), unit: usd);
      expect(giftRateDate(GivingRateView.dayGiven, g, s), day(2026, 10, 22));
      expect(giftRateDate(GivingRateView.dueDate, g, s), day(2026, 10, 20));
    });

    test('counted: the base as is, another currency round2(amount x rate)', () {
      expect(counted(gift('5000', day(2026, 10, 21)), egp), d('5000'));
      expect(
        counted(gift('200', day(2026, 10, 22), unit: sar, rate: '13'), egp),
        d('2600'),
      );
      expect(
        counted(gift('1.005', day(2026, 10, 22), unit: usd, rate: '1'), egp),
        d('1.01'),
      );
    });

    test('progress: remaining never below 0, over is what C7 names', () {
      final gifts = [gift('30', day(2026, 10, 21))];
      expect(progress(d('100'), gifts, egp), (
        distributed: d('30'),
        remaining: d('70'),
        over: d('0'),
      ));
      expect(progress(d('20'), gifts, egp), (
        distributed: d('30'),
        remaining: d('0'),
        over: d('10'),
      ));
      expect(progress(d('30'), gifts, egp), (
        distributed: d('30'),
        remaining: d('0'),
        over: d('0'),
      ));
      expect(progress(d('30'), const [], egp).distributed, d('0'));
    });
  });

  group('validateExtra (C5, B9)', () {
    ExtraLine extra({
      String label = 'Cash at home',
      ExtraKind kind = ExtraKind.cash,
      String amount = '10000',
      Unit unit = egp,
      bool good = false,
    }) => ExtraLine(
      label: label,
      kind: kind,
      amount: Money(d(amount), unit),
      goodDebtConfirmed: good,
    );

    test('a plain cash line is fine, and needs no debtor statement', () {
      expect(validateExtra(extra()), isEmpty);
    });

    test(
      'refuses a blank label, 0 or negative amounts, no currency and a metal',
      () {
        expect(validateExtra(extra(label: ' ')), [ExtraLineError.label]);
        expect(validateExtra(extra(amount: '0')), [ExtraLineError.amount]);
        expect(validateExtra(extra(amount: '-1')), [ExtraLineError.amount]);
        expect(validateExtra(extra(unit: const Unit(''))), [
          ExtraLineError.unit,
        ]);
        expect(validateExtra(extra(unit: xauG)), [ExtraLineError.unit]);
      },
    );

    test('money owed to me needs the good-debt statement', () {
      expect(validateExtra(extra(kind: ExtraKind.owedToMe)), [
        ExtraLineError.goodDebt,
      ]);
      expect(
        validateExtra(extra(kind: ExtraKind.owedToMe, good: true)),
        isEmpty,
      );
    });
  });

  group('focusYear (UX U2)', () {
    YearView at(DateTime due, YearState state) {
      final s = slot(due);
      return YearView(
        slot: s,
        record: null,
        inputs: inputs(const []),
        result: compute(inputs(const [])),
        state: state,
        progress: progress(Decimal.zero, const [], egp),
      );
    }

    test('the oldest due year first, then the oldest distributing, then the open one', () {
      final open = at(day(2027, 10, 20), YearState.open);
      final due1 = at(day(2025, 10, 20), YearState.due);
      final due2 = at(day(2026, 10, 20), YearState.due);
      final dist = at(day(2024, 10, 20), YearState.distributing);
      final settled = at(day(2023, 10, 20), YearState.settled);
      expect(focusYear([open, due2, due1, dist, settled]), due1);
      expect(focusYear([open, dist, settled]), dist);
      expect(focusYear([settled, open]), open);
    });

    test('when every year is settled the newest shows', () {
      final a = at(day(2025, 10, 20), YearState.settled);
      final b = at(day(2026, 10, 20), YearState.settled);
      expect(focusYear([a, b]), b);
    });
  });

  group('reminderPlan (story §5.4)', () {
    final s2027 = slot(day(2027, 10, 20), number: 2027);
    final s2026 = slot(day(2026, 10, 20));
    final now = DateTime(2026, 10, 23, 10);
    const prefs = ZakatPrefs();

    ReminderPlan? plan(
      List<YearView> years, {
      ZakatPrefs p = prefs,
      bool permitted = true,
      DateTime? at,
    }) => reminderPlan(years, p, permitted: permitted, now: at ?? now);

    test('the coming year, on its due date at 09:00 by default', () {
      final p = plan([viewOf(s2026), viewOf(s2027)])!;
      expect(p.yearKey, day(2027, 10, 20));
      expect(p.fireAt, DateTime(2027, 10, 20, 9));
      expect((p.daysBefore, p.label, p.due), (0, '2027', day(2027, 10, 20)));
    });

    test('days before and the time of day move the moment', () {
      final p = plan([
        viewOf(s2027),
      ], p: const ZakatPrefs(reminderDays: 3, reminderMinute: 20 * 60 + 30))!;
      expect(p.fireAt, DateTime(2027, 10, 17, 20, 30));
      expect(p.daysBefore, 3);
    });

    test('a lunar year is labelled in AH', () {
      final lunar = slot(
        day(2027, 2, 8),
        calendar: ZakatYear.lunar,
        number: 1448,
      );
      expect(plan([viewOf(lunar)])!.label, '1448 AH');
    });

    test('none when it is off, not permitted, or the moment has passed', () {
      expect(
        plan([viewOf(s2027)], p: const ZakatPrefs(reminderOn: false)),
        isNull,
      );
      expect(plan([viewOf(s2027)], permitted: false), isNull);
      expect(
        plan(
          [viewOf(s2027)],
          p: const ZakatPrefs(reminderDays: 5),
          at: DateTime(2027, 10, 16),
        ),
        isNull,
      );
      expect(plan([viewOf(s2027)], at: DateTime(2027, 10, 20, 9)), isNull);
    });

    test(
      'a started year gets none, and no later year is picked in its place',
      () {
        final started = viewOf(
          s2027,
          record: frozenRecord(s2027),
          today: day(2027, 10, 20),
        );
        expect(plan([started], at: DateTime(2027, 10, 20, 8)), isNull);
      },
    );

    test('no year, no reminder', () {
      expect(plan(const []), isNull);
    });
  });

  group('dueDate and moveBounds', () {
    test('C3 lunar moves two days either way, solar two days earlier only', () {
      final c = day(2026, 2, 18);
      expect(moveBounds(ZakatYear.lunar, c), (
        from: day(2026, 2, 16),
        to: day(2026, 2, 20),
      ));
      expect(moveBounds(ZakatYear.solar, c), (
        from: day(2026, 2, 16),
        to: day(2026, 2, 18),
      ));
    });

    test('a move never passes the neighbouring years', () {
      final c = day(2027, 2, 8);
      expect(
        moveBounds(
          ZakatYear.lunar,
          c,
          previousDue: day(2027, 2, 7),
          nextDue: day(2027, 2, 9),
        ),
        (from: day(2027, 2, 8), to: day(2027, 2, 8)),
      );
    });

    test('outside the Hijri range there is no date', () {
      expect(dueDate(ZakatYear.lunar, 9, 1, 1600), isNull);
    });
  });
}

void reminderFireAtTests() {
  test('reminderFireAt: days before the due date, at the chosen minute', () {
    expect(
      reminderFireAt(day(2027, 10, 20), 3, 20 * 60 + 30),
      DateTime(2027, 10, 17, 20, 30),
    );
    expect(reminderFireAt(day(2027, 3, 1), 5, 540), DateTime(2027, 2, 24, 9));
  });
}

/// Property tests for the money rules (QA rule: rounding and the zakat sum).
/// A fixed seed keeps a failure reproducible; the expected values are worked
/// out here from the story's formulas, not read from `compute`.
void moneyProperties() {
  group('money properties (fixed seed)', () {
    final rnd = Random(20261023);
    Decimal cents(int max) => (Decimal.fromInt(rnd.nextInt(max)) / d('100'))
        .toDecimal(scaleOnInfinitePrecision: 2);

    test('B, the nisab edge and Z follow the story for 600 random years', () {
      for (var n = 0; n < 600; n++) {
        final share = [d('0'), d('0.25'), d('1')];
        final lines = [
          for (var k = 0; k <= rnd.nextInt(6); k++)
            line(
              'l$k',
              cents(300000000).toString(),
              share: share[rnd.nextInt(3)].toString(),
            ),
        ];
        final debts = cents(200000000);
        final deduct = rnd.nextBool();
        final solar = rnd.nextBool();
        final metal = rnd.nextBool() ? NisabMetal.gold : NisabMetal.silver;
        final rate = d('${1 + rnd.nextInt(6000)}');
        final r = compute(
          inputs(
            lines,
            debts: debts.toString(),
            deduct: deduct,
            nisab: metal,
            metal: rate.toString(),
            calendar: solar ? ZakatYear.solar : ZakatYear.lunar,
          ),
        );
        var sum = Decimal.zero;
        for (final l in lines) {
          sum += l.value * l.share!;
        }
        final raw = sum - (deduct ? debts : Decimal.zero);
        final b = raw < Decimal.zero ? Decimal.zero : raw;
        final grams = metal == NisabMetal.gold ? 85 : 595;
        final nisab = Decimal.fromInt(grams) * rate;
        final rz = solar ? d('0.02577') : d('0.025');
        final why = 'lines $sum debts $debts deduct $deduct $metal @ $rate';
        expect(r.linesTotal, sum, reason: why);
        expect(r.b, b, reason: why);
        expect(r.b >= Decimal.zero, isTrue, reason: why);
        expect(r.nisab, nisab, reason: why);
        expect(
          r.z,
          b >= nisab ? (rz * b).round(scale: 2) : d('0'),
          reason: why,
        );
        if (r.z! > Decimal.zero) {
          expect((r.z! - rz * b).abs() <= d('0.005'), isTrue, reason: why);
        }
        if (r.z! > Decimal.zero) {
          var lineSum = Decimal.zero;
          for (final l in lines) {
            lineSum += l.lineZakat(rz)!;
          }
          final debtZakat = deduct ? (rz * debts).round(scale: 2) : d('0');
          final gap = (lineSum - debtZakat - r.z!).abs();
          expect(
            gap <= d('0.01') * Decimal.fromInt(lines.length + 1),
            isTrue,
            reason: '$why: lines and Z differ by $gap',
          );
        }
      }
    });

    test('one more cent of wealth never lowers Z, and B = nisab pays', () {
      for (var n = 0; n < 300; n++) {
        final base = cents(500000000);
        final debts = cents(100000000);
        final rate = d('${1 + rnd.nextInt(6000)}');
        Decimal? z(Decimal value) => compute(
          inputs(
            [line('a', value.toString())],
            debts: debts.toString(),
            metal: rate.toString(),
          ),
        ).z;
        final more = base + d('0.01');
        expect(
          z(more)! >= z(base)!,
          isTrue,
          reason: '$base +0.01 debts $debts',
        );
        final exact = Decimal.fromInt(85) * rate + debts;
        expect(z(exact)! > Decimal.zero, isTrue, reason: 'B = nisab at $rate');
        expect(z(exact - d('0.01')), d('0'), reason: 'one cent under at $rate');
      }
    });

    test(
      'distributed, remaining and over always add up to Z, for 500 random logs',
      () {
        for (var n = 0; n < 500; n++) {
          final z = cents(300000000);
          final gifts = [
            for (var k = 0; k < rnd.nextInt(5); k++)
              if (rnd.nextBool())
                Gift(
                  date: day(2026, 10, 21),
                  amount: Money(cents(100000000) + d('0.01'), egp),
                )
              else
                Gift(
                  date: day(2026, 10, 21),
                  amount: Money(cents(100000) + d('0.01'), usd),
                  rate: cents(10000) + d('0.01'),
                ),
          ];
          final p = progress(z, gifts, egp);
          var sum = Decimal.zero;
          for (final g in gifts) {
            sum += g.amount.unit == egp
                ? g.amount.amount
                : (g.amount.amount * g.rate!).round(scale: 2);
          }
          final why = 'Z $z gifts ${gifts.length}';
          expect(p.distributed, sum, reason: why);
          expect(p.remaining - p.over, z - sum, reason: why);
          expect(p.remaining * p.over, d('0'), reason: why);
          expect(p.remaining >= Decimal.zero && p.over >= Decimal.zero, isTrue);
        }
      },
    );

    test('AC-20 a year nobody started is open or due by date alone, never distributing or settled', () {
      final s = slot(day(2026, 10, 20));
      final unstarted = ZakatYearRecord(
        dueKey: s.key,
        debts: d('1'),
        deductDebts: true,
      );
      for (var offset = -400; offset <= 800; offset += 7) {
        final today = day(2026, 10, 20).add(Duration(days: offset));
        final expected = offset < 0 ? YearState.open : YearState.due;
        for (final r in [null, unstarted]) {
          expect(
            stateOf(s, r, null, Decimal.zero, today),
            expected,
            reason: 'offset $offset',
          );
        }
      }
    });
  });
}
