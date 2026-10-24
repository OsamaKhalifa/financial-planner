/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

// Yasmin's year from the story (§11): base EGP, lunar (r 2.5 %), nisab gold
// 85 g, due date D = 2026-10-20, today 2026-10-23. Every expected number below
// is worked out by hand from the story's table, not read from the code.

import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/portfolio_calculator.dart';
import 'package:financial_planner/features/investments/domain/zakat_rules.dart';
import 'package:financial_planner/features/zakat/domain/yearly_zakat.dart';
import 'package:financial_planner/features/zakat/domain/zakat_year.dart';
import 'package:flutter_test/flutter_test.dart';

const egp = Unit('EGP');
const usd = Unit('USD');
const sar = Unit('SAR');
Decimal d(String s) => Decimal.parse(s);

final due = day(2026, 10, 20);
final today = day(2026, 10, 23);

// ---------------------------------------------------------------- fixture

Rate rate(Unit from, Unit to, String r, DateTime on) =>
    Rate(from: from, to: to, rate: d(r), asOf: on);

List<Rate> yasminRates() => [
  rate(xauG, egp, '5000', due),
  rate(xagG, egp, '60', due),
  rate(usd, egp, '48', due),
  rate(usd, egp, '50', day(2026, 10, 21)),
];

InvestmentWithHistory item(
  String id,
  AssetType type,
  Unit unit,
  ZakatRule rule,
  List<HistoryEntry> Function(String id) history, {
  Decimal? customShare,
  DateTime? start,
  Intent? intent,
}) => InvestmentWithHistory(
  investment: Investment(
    id: id,
    name: id,
    type: type,
    intent: intent,
    unit: unit,
    startDate: start ?? day(2026, 1, 1),
    zakatRule: rule,
    customZakatShare: customShare,
  ),
  history: history(id),
);

MoneyIn paid(String id, String amount, Unit unit, [DateTime? on]) => MoneyIn(
  investmentId: id,
  date: on ?? day(2026, 1, 1),
  amount: Money(d(amount), unit),
);

ValueUpdate valued(String id, DateTime on, String v) =>
    ValueUpdate(investmentId: id, date: on, value: d(v));

InvestmentWithHistory savings({
  String value = '120000',
  DateTime? valueOn,
  List<HistoryEntry> more = const [],
}) => item(
  'Savings',
  AssetType.cashDeposit,
  egp,
  ZakatRule.cash100,
  (id) => [
    paid(id, value, egp),
    valued(id, valueOn ?? day(2026, 10, 1), value),
    ...more,
  ],
);

InvestmentWithHistory goldBar() => item(
  'Gold bar',
  AssetType.gold,
  xauG,
  ZakatRule.bullion100,
  (id) => [paid(id, '50', xauG), valued(id, due, '50')],
);

InvestmentWithHistory usShares({String cost = '3000'}) => item(
  'US shares',
  AssetType.stock,
  usd,
  ZakatRule.trading100,
  (id) => [paid(id, cost, usd), valued(id, due, '2000')],
);

InvestmentWithHistory egxShares({
  ZakatRule rule = ZakatRule.longTermProxy25,
  List<HistoryEntry> more = const [],
}) => item(
  'EGX shares',
  AssetType.stock,
  egp,
  rule,
  (id) => [paid(id, '80000', egp), valued(id, due, '80000'), ...more],
);

InvestmentWithHistory home() => item(
  'Home',
  AssetType.other,
  egp,
  ZakatRule.custom,
  (id) => [paid(id, '3000000', egp), valued(id, due, '3000000')],
  customShare: Decimal.zero,
);

List<InvestmentWithHistory> yasminItems() => [
  savings(),
  goldBar(),
  usShares(),
  egxShares(),
  home(),
];

ExtraLine cashAtHome() => ExtraLine(
  id: 'cash',
  label: 'Cash at home',
  kind: ExtraKind.cash,
  amount: Money(d('10000'), egp),
  goodDebtConfirmed: false,
);

ExtraLine loan() => ExtraLine(
  id: 'loan',
  label: 'Loan to my brother',
  kind: ExtraKind.owedToMe,
  amount: Money(d('500'), usd),
  goodDebtConfirmed: true,
);

YearSlot dueSlot({ZakatYear calendar = ZakatYear.lunar}) => YearSlot(
  key: due,
  due: due,
  calendar: calendar,
  number: 1447,
  previousDue: day(2025, 10, 9),
);

/// Yasmin's year, with whatever the test changes.
({YearInputs inputs, YearResult result}) yasmin({
  ZakatYear calendar = ZakatYear.lunar,
  List<InvestmentWithHistory>? items,
  List<Rate>? rates,
  Settings? settings,
  ZakatPrefs prefs = const ZakatPrefs(nisab: NisabMetal.gold),
  List<ExtraLine>? extras,
  String debts = '20000',
  bool deduct = true,
  DateTime? on,
}) {
  final book = RateBook(rates ?? yasminRates());
  final calc = PortfolioCalculator(
    items: items ?? yasminItems(),
    rates: book,
    inflation: InflationBook(const ShippedInflation(series: {}), const []),
    settings: settings ?? Settings(baseCurrency: egp, zakatYear: calendar),
    noZakatYears: const {},
    today: today,
  );
  final record = ZakatYearRecord(
    dueKey: due,
    debts: d(debts),
    deductDebts: deduct,
    extras: extras ?? [cashAtHome(), loan()],
  );
  final inputs = liveInputs(
    dueSlot(calendar: calendar),
    record,
    calc.zakatPosition(on ?? due),
    book,
    prefs,
  );
  return (inputs: inputs, result: compute(inputs));
}

ZakatLine lineOf(YearInputs i, String name) =>
    i.lines.firstWhere((l) => l.name == name);

String money2(Decimal v) => v.toStringAsFixed(2);

// ------------------------------------------------------------------- tests

void main() {
  group('calendar and due dates (§5.1-5.3)', () {
    test(
      'AC-2 lunar 1 Ramadan: 1447 AH is 2026-02-18, 1448 AH is 2027-02-08',
      () {
        expect(dueDate(ZakatYear.lunar, 9, 1, 1447), day(2026, 2, 18));
        expect(dueDate(ZakatYear.lunar, 9, 1, 1448), day(2027, 2, 8));
      },
    );

    test('AC-2 cycle day 30 in a month with 29 days is the 29th, and in a 30-day month the 30th', () {
      final short = [
        for (var m = 1; m <= 12; m++)
          if (hijriMonthLength(1447, m) == 29) m,
      ];
      final long = [
        for (var m = 1; m <= 12; m++)
          if (hijriMonthLength(1447, m) == 30) m,
      ];
      expect(short, isNotEmpty);
      expect(long, isNotEmpty);
      for (final m in short) {
        expect(dueDate(ZakatYear.lunar, m, 30, 1447), hijriToDate(1447, m, 29));
        expect(
          hijriToDate(1447, m, 30),
          isNot(dueDate(ZakatYear.lunar, m, 30, 1447)),
        );
      }
      for (final m in long) {
        expect(dueDate(ZakatYear.lunar, m, 30, 1447), hijriToDate(1447, m, 30));
      }
    });

    test('AC-3 solar 20 October; 29 February is 28 February in 2027 and 29 in 2028', () {
      expect(dueDate(ZakatYear.solar, 10, 20, 2026), day(2026, 10, 20));
      expect(dueDate(ZakatYear.solar, 10, 20, 2027), day(2027, 10, 20));
      expect(dueDate(ZakatYear.solar, 2, 29, 2027), day(2027, 2, 28));
      expect(dueDate(ZakatYear.solar, 2, 29, 2028), day(2028, 2, 29));
    });

    ZakatCycle solar20Oct(DateTime from) =>
        ZakatCycle(calendar: ZakatYear.solar, month: 10, day: 20, from: from);

    test(
      'AC-4 saved on 2026-01-05 the first year is 2026 and none earlier exists',
      () {
        final slots = yearSlots(
          [solar20Oct(day(2026, 1, 5))],
          const {},
          day(2026, 1, 5),
        );
        expect(slots.map((s) => (s.number, s.due)), [(2026, due)]);
      },
    );

    test(
      'AC-4 saved on 2026-10-21 the first year is 2027 and no 2026 exists',
      () {
        final slots = yearSlots(
          [solar20Oct(day(2026, 10, 21))],
          const {},
          day(2026, 10, 21),
        );
        expect(slots.map((s) => s.number), [2027]);
      },
    );

    test('AC-4 2026 is open on 10-19, due on 10-20; on 10-21 2027 is open and 2026 stays due', () {
      final cycle = [solar20Oct(day(2026, 1, 5))];
      YearState stateAt(DateTime now, int year) {
        final s = yearSlots(
          cycle,
          const {},
          now,
        ).firstWhere((s) => s.number == year);
        return stateOf(s, null, null, Decimal.zero, now);
      }

      expect(stateAt(day(2026, 10, 19), 2026), YearState.open);
      expect(stateAt(day(2026, 10, 20), 2026), YearState.due);
      expect(
        yearSlots(cycle, const {}, day(2026, 10, 20)).map((s) => s.number),
        [2026],
      );
      expect(stateAt(day(2026, 10, 21), 2026), YearState.due);
      expect(stateAt(day(2026, 10, 21), 2027), YearState.open);
    });

    test('AC-5 lunar may move 2 days either way, solar 2 days earlier and never later', () {
      final b = moveBounds(ZakatYear.lunar, day(2026, 2, 18));
      expect((b.from, b.to), (day(2026, 2, 16), day(2026, 2, 20)));
      final s = moveBounds(ZakatYear.solar, day(2027, 10, 20));
      expect((s.from, s.to), (day(2027, 10, 18), day(2027, 10, 20)));
    });

    test(
      'AC-5 a moved 1447 AH keeps its label and key, 1448 AH does not change',
      () {
        final lunar = ZakatCycle(
          calendar: ZakatYear.lunar,
          month: 9,
          day: 1,
          from: day(2026, 1, 5),
        );
        final slots = yearSlots(
          [lunar],
          {day(2026, 2, 18): day(2026, 2, 16)},
          today,
        );
        expect(slots[0].number, 1447);
        expect(
          (slots[0].key, slots[0].due),
          (day(2026, 2, 18), day(2026, 2, 16)),
        );
        expect(slots[1].due, day(2027, 2, 8));
      },
    );

    test('AC-6 the C2 example: 1448 AH keeps 2027-02-08 and 2.5 %, the next year is 2027 at 2.577 %', () {
      final lunar = ZakatCycle(
        calendar: ZakatYear.lunar,
        month: 9,
        day: 1,
        from: day(2026, 1, 5),
      );
      final before = yearSlots([lunar], const {}, today);
      expect(before.map((s) => s.number), [1447, 1448]);
      final from = newCycleFrom(before, today);
      expect(from, day(2027, 2, 9));
      final after = yearSlots([lunar, solar20Oct(from)], const {}, today);
      expect(after.map((s) => (s.number, s.due)), [
        (1447, day(2026, 2, 18)),
        (1448, day(2027, 2, 8)),
        (2027, day(2027, 10, 20)),
      ]);
      expect(after.map((s) => s.calendar.r), [
        d('0.025'),
        d('0.025'),
        d('0.02577'),
      ]);
    });

    test('AC-6 a year in state due keeps its date; the new cycle starts after the open year', () {
      final lunar = ZakatCycle(
        calendar: ZakatYear.lunar,
        month: 9,
        day: 1,
        from: day(2026, 1, 5),
      );
      final now = day(2026, 2, 20);
      final slots = yearSlots([lunar], const {}, now);
      expect(stateOf(slots[0], null, null, Decimal.zero, now), YearState.due);
      expect(slots[1].due, day(2027, 2, 8));
      expect(newCycleFrom(slots, now), day(2027, 2, 9));
    });

    test('AC-6 solar 20 Oct changed to 1 March: 2027 keeps 2027-10-20, the next is 2028 on 2028-03-01', () {
      final first = solar20Oct(day(2026, 1, 5));
      final slots = yearSlots([first], const {}, today);
      final from = newCycleFrom(slots, today);
      expect(from, day(2027, 10, 21));
      final march = ZakatCycle(
        calendar: ZakatYear.solar,
        month: 3,
        day: 1,
        from: from,
      );
      final after = yearSlots([first, march], const {}, today);
      expect(after.map((s) => (s.number, s.due)), [
        (2026, due),
        (2027, day(2027, 10, 20)),
        (2028, day(2028, 3, 1)),
      ]);
    });
  });

  group('Yasmin\'s year (§11)', () {
    test('AC-9 the eight lines, each part, and the totals', () {
      final y = yasmin();
      final rows = {
        'Savings': ('120000', '1', '120000', '3000', 'B1'),
        'Gold bar': ('250000', '1', '250000', '6250', 'B2'),
        'US shares': ('96000', '1', '96000', '2400', 'B3'),
        'EGX shares': ('80000', '0.25', '20000', '500', 'B3'),
        'Home': ('3000000', '0', '0', '0', 'B5'),
        'Cash at home': ('10000', '1', '10000', '250', 'B1'),
        'Loan to my brother': ('24000', '1', '24000', '600', 'B9'),
      };
      expect(y.inputs.lines.map((l) => l.name), rows.keys);
      for (final e in rows.entries) {
        final l = lineOf(y.inputs, e.key);
        final (inBase, share, zakatable, onLine, section) = e.value;
        expect(l.inBase, d(inBase), reason: e.key);
        expect(l.share, d(share), reason: e.key);
        expect(l.zakatable, d(zakatable), reason: e.key);
        expect(l.lineZakat(d('0.025')), d(onLine), reason: e.key);
        expect(l.section, section, reason: e.key);
      }
      expect(y.result.linesTotal, d('520000'));
      expect(y.result.debtsLine, d('20000'));
      expect(y.result.b, d('500000'));
      expect(y.result.nisab, d('425000'));
      expect(y.result.reachesNisab, isTrue);
      expect(money2(y.result.z!), '12500.00');
      expect(y.result.complete && y.result.canStart, isTrue);
    });

    test('AC-9 US shares read "converted at 48 on D" and the metal and base lines use no foreign rate', () {
      final y = yasmin();
      final us = lineOf(y.inputs, 'US shares');
      expect(
        (us.unit, us.value, us.rate, us.rateDate),
        (usd, d('2000'), d('48'), due),
      );
      expect(lineOf(y.inputs, 'Savings').rate, Decimal.one);
    });

    test('AC-10 solar: Z = 0.02577 x 500,000 = 12,885.00', () {
      expect(money2(yasmin(calendar: ZakatYear.solar).result.z!), '12885.00');
    });

    test('AC-7 nisab 425,000.00 on D with gold, 35,700.00 with silver', () {
      expect(money2(yasmin().result.nisab!), '425000.00');
      final silver = yasmin(prefs: const ZakatPrefs(nisab: NisabMetal.silver));
      expect(money2(silver.result.nisab!), '35700.00');
      expect(silver.inputs.metalRate, d('60'));
    });

    test(
      'AC-7 no nisab standard chosen: the question is asked and no Z shows',
      () {
        final y = yasmin(prefs: const ZakatPrefs());
        expect(y.result.missing.map((m) => m.$1), [Missing.nisabStandard]);
        expect(y.result.z, isNull);
      },
    );

    test('AC-8 no gold rate on or before D: no nisab, no Z, incomplete', () {
      final y = yasmin(
        rates: [
          rate(usd, egp, '48', due),
          rate(xauG, egp, '5000', day(2026, 10, 21)),
        ],
      );
      expect(y.result.nisab, isNull);
      final reasons = {for (final m in y.result.missing) m.$1: m.$2};
      expect(reasons.keys, [Missing.rate, Missing.metalRate]);
      expect(reasons[Missing.rate]!.map((l) => l.name), ['Gold bar']);
      expect(y.result.z, isNull);
      expect(y.result.canStart, isFalse);
    });

    test(
      'AC-11 a Savings update dated after D is not used, one dated D is',
      () {
        final later = yasmin(
          items: [
            savings(more: [valued('Savings', day(2026, 10, 22), '130000')]),
            goldBar(),
            usShares(),
            egxShares(),
            home(),
          ],
        );
        expect(lineOf(later.inputs, 'Savings').inBase, d('120000'));
        final onD = yasmin(
          items: [
            savings(more: [valued('Savings', due, '125000')]),
            goldBar(),
            usShares(),
            egxShares(),
            home(),
          ],
        );
        expect(lineOf(onD.inputs, 'Savings').inBase, d('125000'));
        expect(money2(onD.result.linesTotal), '525000.00');
      },
    );

    test('AC-11 the 50.00 rate dated 2026-10-21 is used for no line', () {
      final y = yasmin();
      expect(lineOf(y.inputs, 'US shares').rate, d('48'));
      expect(lineOf(y.inputs, 'Loan to my brother').rate, d('48'));
    });

    test('AC-11 only USD 47.00 dated 2026-10-10: 94,000 + 23,500, sum 517,500, B 497,500, Z 12,437.50', () {
      final y = yasmin(
        rates: [
          rate(xauG, egp, '5000', due),
          rate(usd, egp, '47', day(2026, 10, 10)),
        ],
      );
      expect(lineOf(y.inputs, 'US shares').inBase, d('94000'));
      expect(lineOf(y.inputs, 'Loan to my brother').inBase, d('23500'));
      for (final n in ['US shares', 'Loan to my brother']) {
        final l = lineOf(y.inputs, n);
        expect((l.rate, l.rateDate), (d('47'), day(2026, 10, 10)), reason: n);
      }
      expect(y.result.linesTotal, d('517500'));
      expect(y.result.b, d('497500'));
      expect(money2(y.result.z!), '12437.50');
    });

    test('AC-11 market value, not cost: 3,000 USD paid, 2,000 USD now, the line uses 2,000', () {
      final us = lineOf(yasmin().inputs, 'US shares');
      expect(us.value, d('2000'));
    });

    test('AC-12 no USD rate on or before D: both USD lines are named, no 1:1, no Z', () {
      final y = yasmin(rates: [rate(xauG, egp, '5000', due)]);
      expect(y.result.complete, isFalse);
      final (reason, lines) = y.result.missing.single;
      expect(reason, Missing.rate);
      expect(lines.map((l) => l.name), ['US shares', 'Loan to my brother']);
      expect(
        lines.every((l) => l.inBase == null && l.zakatable == null),
        isTrue,
      );
      expect(y.result.z, isNull);
      expect(y.result.canStart, isFalse);
    });

    test('AC-13 an item started 2026-10-21 or sold on 2026-09-01 has no line; Home keeps a 0.00 line with B5', () {
      final y = yasmin(
        items: [
          ...yasminItems(),
          item(
            'Later',
            AssetType.fund,
            egp,
            ZakatRule.trading100,
            (id) => [paid(id, '999', egp, day(2026, 10, 21))],
            start: day(2026, 10, 21),
          ),
          item(
            'Sold',
            AssetType.fund,
            egp,
            ZakatRule.trading100,
            (id) => [paid(id, '700', egp), valued(id, day(2026, 9, 1), '0')],
          ),
        ],
      );
      expect(y.inputs.lines.map((l) => l.name), isNot(contains('Later')));
      expect(y.inputs.lines.map((l) => l.name), isNot(contains('Sold')));
      final h = lineOf(y.inputs, 'Home');
      expect((h.zakatable, h.section), (Decimal.zero, 'B5'));
      expect(y.result.b, d('500000'));
    });

    test('AC-14 Savings 120,500 with 500 interest kept inside: the line is 120,000.00 and Z stays 12,500.00', () {
      final y = yasmin(
        items: [
          savings(
            value: '120000',
            more: [
              InterestRecord(
                investmentId: 'Savings',
                date: day(2026, 10, 2),
                amount: Money(d('500'), egp),
                kind: InterestKind.keptInside,
              ),
            ],
          ),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
      );
      final s = lineOf(y.inputs, 'Savings');
      expect((s.inBase, s.heldInterest), (d('120000'), d('500')));
      expect(money2(y.result.z!), '12500.00');
    });

    test('AC-15 EGX shares on dividends-only: a 0.00 line with the dividends notice, B 480,000, Z 12,000.00', () {
      final y = yasmin(
        items: [
          savings(),
          goldBar(),
          usShares(),
          egxShares(
            rule: ZakatRule.longTermDividendsOnly,
            more: [
              MoneyOut(
                investmentId: 'EGX shares',
                date: day(2026, 5, 1),
                amount: Money(d('1000'), egp),
                kind: MoneyOutKind.income,
              ),
            ],
          ),
          home(),
        ],
      );
      final e = lineOf(y.inputs, 'EGX shares');
      expect((e.share, e.zakatable), (Decimal.zero, Decimal.zero));
      expect(e.notice, ZakatNotice.dividendsCountedWithCash);
      expect(y.result.b, d('480000'));
      expect(money2(y.result.z!), '12000.00');
    });

    test('AC-15 private equity on "profit received only": 0.00 with the profit-payouts notice', () {
      final y = yasmin(
        items: [
          ...yasminItems(),
          item(
            'Friend project',
            AssetType.privateEquity,
            egp,
            ZakatRule.longTermDividendsOnly,
            (id) => [paid(id, '50000', egp), valued(id, due, '50000')],
          ),
        ],
      );
      final p = lineOf(y.inputs, 'Friend project');
      expect(
        (p.zakatable, p.notice, p.section),
        (Decimal.zero, ZakatNotice.profitPayoutsOnly, 'B6'),
      );
      expect(y.result.b, d('500000'));
    });

    test('AC-16 a worn-gold item with no ruling, or a long-term stock with no method, names its question and blocks Z', () {
      final ring = item(
        'Wedding ring',
        AssetType.gold,
        xauG,
        ZakatRule.jewelleryPerSetting,
        (id) => [paid(id, '10', xauG), valued(id, due, '10')],
        intent: Intent.personalUse,
      );
      final longHeld = item(
        'EGX shares',
        AssetType.stock,
        egp,
        ZakatRule.longTermPerSetting,
        (id) => [paid(id, '80000', egp), valued(id, due, '80000')],
        intent: Intent.longTerm,
      );
      final y = yasmin(
        items: [savings(), goldBar(), usShares(), ring, longHeld, home()],
      );
      final asked = y.result.missing.singleWhere(
        (m) => m.$1 == Missing.question,
      );
      expect(asked.$2.map((l) => (l.name, l.question)), [
        ('Wedding ring', ZakatQuestion.jewellery),
        ('EGX shares', ZakatQuestion.longTermMethod),
      ]);
      expect(asked.$2.every((l) => l.zakatable == null), isTrue);
      expect(y.result.z, isNull);
      expect(y.result.canStart, isFalse);
    });

    test('AC-17 extra lines count at 100 % with B1 / B9, and there are only two kinds', () {
      final y = yasmin();
      expect(
        [
          lineOf(y.inputs, 'Cash at home'),
          lineOf(y.inputs, 'Loan to my brother'),
        ].map((l) => (l.share, l.section, l.isExtra)),
        [(Decimal.one, 'B1', true), (Decimal.one, 'B9', true)],
      );
      expect(ExtraKind.values, hasLength(2));
    });

    test('AC-17 amount 0, no currency, and a debt without the debtor statement are refused', () {
      ExtraLine extra(
        String amount, {
        Unit unit = egp,
        ExtraKind kind = ExtraKind.cash,
        bool good = false,
      }) => ExtraLine(
        label: 'x',
        kind: kind,
        amount: Money(d(amount), unit),
        goodDebtConfirmed: good,
      );
      expect(validateExtra(extra('0')), [ExtraLineError.amount]);
      expect(validateExtra(extra('5', unit: const Unit(''))), [
        ExtraLineError.unit,
      ]);
      expect(validateExtra(extra('5', kind: ExtraKind.owedToMe)), [
        ExtraLineError.goodDebt,
      ]);
      expect(
        validateExtra(extra('5', kind: ExtraKind.owedToMe, good: true)),
        isEmpty,
      );
    });

    test('AC-17 the next year opens with no extra lines', () {
      final next = yasmin(extras: const []);
      expect(next.inputs.lines.where((l) => l.isExtra), isEmpty);
    });

    test('AC-18 a new year has debts 0 with deduction on', () {
      final i = liveInputs(
        dueSlot(),
        null,
        PortfolioCalculator(
          items: yasminItems(),
          rates: RateBook(yasminRates()),
          inflation: InflationBook(
            const ShippedInflation(series: {}),
            const [],
          ),
          settings: const Settings(
            baseCurrency: egp,
            zakatYear: ZakatYear.lunar,
          ),
          noZakatYears: const {},
          today: today,
        ).zakatPosition(due),
        RateBook(yasminRates()),
        const ZakatPrefs(nisab: NisabMetal.gold),
      );
      expect((i.debts, i.deductDebts), (Decimal.zero, true));
    });

    test('AC-18 deduction off: B 520,000.00 and Z 13,000.00; debts 600,000: B 0.00 and Z 0.00', () {
      final off = yasmin(deduct: false);
      expect(off.result.debtsLine, Decimal.zero);
      expect(money2(off.result.b), '520000.00');
      expect(money2(off.result.z!), '13000.00');
      final over = yasmin(debts: '600000');
      expect(money2(over.result.b), '0.00');
      expect(money2(over.result.z!), '0.00');
      expect(over.result.reachesNisab, isFalse);
    });

    test('AC-19 debts 100,000: B 420,000.00 below 425,000.00, Z 0.00; silver: Z 10,500.00', () {
      final below = yasmin(debts: '100000');
      expect(money2(below.result.b), '420000.00');
      expect(below.result.reachesNisab, isFalse);
      expect(money2(below.result.z!), '0.00');
      final silver = yasmin(
        debts: '100000',
        prefs: const ZakatPrefs(nisab: NisabMetal.silver),
      );
      expect(money2(silver.result.z!), '10500.00');
    });

    test(
      'AC-19 debts 95,000: B equals the nisab, 425,000.00, and Z is 10,625.00',
      () {
        final at = yasmin(debts: '95000');
        expect(at.result.b, at.result.nisab);
        expect(money2(at.result.z!), '10625.00');
      },
    );

    test('AC-21 a Savings value of 140,000 dated 2026-10-15 shows at once: B 520,000.00, Z 13,000.00', () {
      final y = yasmin(
        items: [
          savings(more: [valued('Savings', day(2026, 10, 15), '140000')]),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
      );
      expect(lineOf(y.inputs, 'Savings').inBase, d('140000'));
      expect(money2(y.result.b), '520000.00');
      expect(money2(y.result.z!), '13000.00');
    });

    test('AC-45 Savings stands on Oct 1, the others on D; the USD 47.00 lines and the metal rate carry their own dates', () {
      final y = yasmin();
      expect(lineOf(y.inputs, 'Savings').valueDate, day(2026, 10, 1));
      for (final n in ['Gold bar', 'US shares', 'EGX shares', 'Home']) {
        expect(lineOf(y.inputs, n).valueDate, due, reason: n);
      }
      expect(lineOf(y.inputs, 'Cash at home').valueDate, isNull);
      expect(lineOf(y.inputs, 'Loan to my brother').valueDate, isNull);
      expect(y.inputs.metalRateDate, due);

      final old = yasmin(
        rates: [
          rate(xauG, egp, '5000', day(2026, 10, 15)),
          rate(usd, egp, '47', day(2026, 10, 10)),
        ],
      );
      expect(old.inputs.metalRateDate, day(2026, 10, 15));
      expect(lineOf(old.inputs, 'Gold bar').valueDate, due);
      expect(lineOf(old.inputs, 'Gold bar').rateDate, day(2026, 10, 15));
      expect(lineOf(old.inputs, 'US shares').rateDate, day(2026, 10, 10));
      expect(old.result.complete, isTrue);
      expect(old.result.canStart, isTrue);
    });

    test('AC-45 a Savings update dated D removes its older value date', () {
      final y = yasmin(
        items: [
          savings(more: [valued('Savings', due, '120000')]),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
      );
      expect(lineOf(y.inputs, 'Savings').valueDate, due);
    });
  });

  group('open, due, incomplete and empty years (§7, §8)', () {
    test(
      'AC-23 an open year uses the figures on today and is not a due year',
      () {
        final open = yearSlots(
          [
            ZakatCycle(
              calendar: ZakatYear.solar,
              month: 10,
              day: 20,
              from: day(2026, 1, 5),
            ),
          ],
          const {},
          today,
        ).last;
        expect(open.due, day(2027, 10, 20));
        expect(stateOf(open, null, null, Decimal.zero, today), YearState.open);
      },
    );

    test('AC-23 Yasmin\'s due year can start, with no separate confirm', () {
      final y = yasmin();
      expect(
        stateOf(dueSlot(), null, null, Decimal.zero, today),
        YearState.due,
      );
      expect(y.result.canStart, isTrue);
    });

    test('AC-23 incomplete years (no rate, no question, no nisab) cannot start and say why', () {
      expect(
        yasmin(rates: [rate(xauG, egp, '5000', due)]).result.canStart,
        isFalse,
      );
      expect(yasmin(prefs: const ZakatPrefs()).result.canStart, isFalse);
    });

    test('AC-23 a due year with no investment line and no extra line is empty: no Z, no verdict, no start', () {
      for (final debts in ['0', '20000']) {
        final y = yasmin(items: const [], extras: const [], debts: debts);
        expect(y.result.empty, isTrue, reason: debts);
        expect(y.result.z, isNull, reason: debts);
        expect(y.result.canStart, isFalse, reason: debts);
      }
    });

    test('AC-39 three due years show Z > 0, Z = 0 (below nisab) and incomplete; starting the first leaves the other two', () {
      YearView asView(YearInputs i, {ZakatYearRecord? record}) =>
          yearViewOf(dueSlot(), record, i, today);
      final owed = asView(yasmin().inputs);
      final below = asView(yasmin(debts: '100000').inputs);
      final incomplete = asView(
        yasmin(rates: [rate(xauG, egp, '5000', due)]).inputs,
      );
      for (final v in [owed, below, incomplete]) {
        expect(v.state, YearState.due);
      }
      expect(owed.result.z! > Decimal.zero, isTrue);
      expect(below.result.z, Decimal.zero);
      expect(incomplete.result.complete, isFalse);

      final record = ZakatYearRecord(
        dueKey: due,
        debts: d('20000'),
        deductDebts: true,
        frozen: freeze(yasmin().inputs, today),
      );
      final startedYear = asView(
        frozenInputs(dueSlot(), record),
        record: record,
      );
      expect(startedYear.state, YearState.distributing);
      expect(focusYear([startedYear, below, incomplete]).state, YearState.due);
    });
  });

  group('frozen years, start and recompute (§8)', () {
    ZakatYearRecord started(
      YearInputs i, {
      List<Gift> gifts = const [],
      String debts = '20000',
    }) => ZakatYearRecord(
      dueKey: due,
      debts: d(debts),
      deductDebts: true,
      frozen: freeze(i, today),
      gifts: gifts,
    );

    test('AC-24 later value, rate, nisab standard and item changes leave a started year as it was', () {
      final y = yasmin();
      final record = started(y.inputs);
      final frozen = compute(frozenInputs(dueSlot(), record));
      expect(money2(frozen.nisab!), '425000.00');
      expect(money2(frozen.z!), '12500.00');
      expect(frozen.linesTotal, d('520000'));

      final changed = yasmin(
        items: [
          savings(more: [valued('Savings', day(2026, 10, 18), '200000')]),
          goldBar(),
          usShares(),
          egxShares(),
        ],
        rates: [
          rate(xauG, egp, '6000', due),
          rate(xagG, egp, '60', due),
          rate(usd, egp, '48', due),
        ],
        prefs: const ZakatPrefs(nisab: NisabMetal.silver),
      );
      expect(money2(changed.result.z!), '15750.00');
      final again = compute(frozenInputs(dueSlot(), record));
      expect(money2(again.z!), '12500.00');
      expect(money2(again.nisab!), '425000.00');
    });

    test('AC-24 Home\'s line stays in a started year after the item is deleted, and opens nothing', () {
      final record = started(yasmin().inputs);
      final home = frozenInputs(
        dueSlot(),
        record,
      ).lines.firstWhere((l) => l.name == 'Home');
      expect((home.refId, home.zakatable), ('Home', Decimal.zero));
    });

    test('AC-25 recompute: Savings 200,000, Gold bar 300,000, sum 650,000, B 630,000, nisab 510,000, Z 15,750.00; the log stays', () {
      final y = yasmin();
      final gifts = [
        Gift(date: day(2026, 10, 21), amount: Money(d('5000'), egp)),
      ];
      final v1 = started(y.inputs, gifts: gifts);
      expect(money2(compute(frozenInputs(dueSlot(), v1)).z!), '12500.00');

      final now = yasmin(
        items: [
          savings(more: [valued('Savings', day(2026, 10, 18), '200000')]),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
        rates: [rate(xauG, egp, '6000', due), rate(usd, egp, '48', due)],
      );
      expect(lineOf(now.inputs, 'Savings').inBase, d('200000'));
      expect(lineOf(now.inputs, 'Gold bar').inBase, d('300000'));
      expect(now.result.linesTotal, d('650000'));
      expect(now.result.b, d('630000'));
      expect(money2(now.result.nisab!), '510000.00');
      expect(money2(now.result.z!), '15750.00');

      final v2 = started(now.inputs, gifts: gifts);
      final r = compute(frozenInputs(dueSlot(), v2));
      expect(money2(r.z!), '15750.00');
      final p = progress(r.z!, v2.gifts, v2.frozen!.base);
      expect((p.distributed, p.remaining), (d('5000'), d('10750')));
      expect(
        stateOf(dueSlot(), v2, r, p.distributed, today),
        YearState.distributing,
      );
    });

    test('AC-43 a year without a frozen record is due again with live figures after an undo', () {
      final y = yasmin();
      final record = started(y.inputs);
      expect(
        stateOf(
          dueSlot(),
          record,
          compute(frozenInputs(dueSlot(), record)),
          Decimal.zero,
          today,
        ),
        YearState.distributing,
      );
      final undone = ZakatYearRecord(
        dueKey: due,
        debts: d('20000'),
        deductDebts: true,
      );
      expect(
        stateOf(dueSlot(), undone, null, Decimal.zero, today),
        YearState.due,
      );
      final savingsUpdated = yasmin(
        items: [
          savings(more: [valued('Savings', day(2026, 10, 15), '140000')]),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
      );
      expect(money2(savingsUpdated.result.z!), '13000.00');
    });

    test('AC-31 a due year below nisab is closed at once: state settled, Z 0.00, remaining 0.00', () {
      final y = yasmin(debts: '100000');
      expect(y.result.canStart, isTrue);
      final record = started(y.inputs, debts: '100000');
      final r = compute(frozenInputs(dueSlot(), record));
      final p = progress(r.z!, record.gifts, egp);
      expect(money2(r.z!), '0.00');
      expect(money2(p.remaining), '0.00');
      expect(
        stateOf(dueSlot(), record, r, p.distributed, today),
        YearState.settled,
      );
    });
  });

  group('distribution log (§9)', () {
    Gift egpGift(String amount, DateTime on, {String? note}) =>
        Gift(date: on, amount: Money(d(amount), egp), note: note);

    YearState stateWith(List<Gift> gifts, {YearInputs? inputs}) {
      final record = ZakatYearRecord(
        dueKey: due,
        debts: d('20000'),
        deductDebts: true,
        frozen: freeze(inputs ?? yasmin().inputs, today),
        gifts: gifts,
      );
      final r = compute(frozenInputs(dueSlot(), record));
      return stateOf(
        dueSlot(),
        record,
        r,
        progress(r.z!, gifts, egp).distributed,
        today,
      );
    }

    test('AC-26 5,000 then 7,500: remaining 7,500.00 distributing, then 0.00 and settled; deleting the 7,500 undoes it', () {
      final first = egpGift('5000', day(2026, 10, 21), note: 'Masjid');
      final second = egpGift('7500', day(2026, 10, 23));
      final z = d('12500');
      final one = progress(z, [first], egp);
      expect((one.distributed, one.remaining), (d('5000'), d('7500')));
      expect(stateWith([first]), YearState.distributing);
      final both = progress(z, [first, second], egp);
      expect((both.distributed, both.remaining), (d('12500'), d('0')));
      expect(stateWith([first, second]), YearState.settled);
      expect(stateWith([first]), YearState.distributing);
    });

    test('AC-26 an entry of 0, or dated 2026-10-24, is refused', () {
      expect(validateGift(egpGift('0', day(2026, 10, 21)), dueSlot(), today), [
        GiftError.amount,
      ]);
      expect(validateGift(egpGift('1', day(2026, 10, 24)), dueSlot(), today), [
        GiftError.dateInFuture,
      ]);
    });

    test('AC-27 a settled year recomputed to 15,750.00 is distributing again with 3,250.00 to give', () {
      final gifts = [egpGift('12500', day(2026, 10, 23))];
      final grown = yasmin(
        items: [
          savings(more: [valued('Savings', day(2026, 10, 18), '200000')]),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
        rates: [rate(xauG, egp, '6000', due), rate(usd, egp, '48', due)],
      );
      expect(money2(grown.result.z!), '15750.00');
      final p = progress(grown.result.z!, gifts, egp);
      expect((p.distributed, p.remaining), (d('12500'), d('3250')));
      expect(stateWith(gifts, inputs: grown.inputs), YearState.distributing);
    });

    test('AC-27 recomputed after Savings is 100,000: Z 12,000.00, remaining 0.00, settled, 500.00 more than due', () {
      final lower = yasmin(
        items: [
          savings(value: '100000'),
          goldBar(),
          usShares(),
          egxShares(),
          home(),
        ],
      );
      expect(lower.result.linesTotal, d('500000'));
      expect(lower.result.b, d('480000'));
      expect(money2(lower.result.z!), '12000.00');
      final gifts = [egpGift('12500', day(2026, 10, 23))];
      final p = progress(lower.result.z!, gifts, egp);
      expect((p.remaining, p.over), (d('0'), d('500')));
      expect(stateWith(gifts, inputs: lower.inputs), YearState.settled);
    });

    test('AC-28 solar 2026: an early entry counts and is marked; 2025-10-21 is accepted, 2025-10-20 refused', () {
      final cycle = ZakatCycle(
        calendar: ZakatYear.solar,
        month: 10,
        day: 20,
        from: day(2025, 1, 5),
      );
      final s2026 = yearSlots(
        [cycle],
        const {},
        today,
      ).firstWhere((s) => s.number == 2026);
      final early = egpGift('2000', day(2026, 10, 1));
      expect(validateGift(early, s2026, today), isEmpty);
      expect(givenEarly(early, s2026), isTrue);
      expect(progress(d('12885'), [early], egp).distributed, d('2000'));
      expect(
        validateGift(egpGift('1', day(2025, 10, 21)), s2026, today),
        isEmpty,
      );
      expect(validateGift(egpGift('1', day(2025, 10, 20)), s2026, today), [
        GiftError.dateTooEarly,
      ]);
    });

    test('AC-28 when 2025 was moved to 2025-10-18, 2025-10-19 is accepted and 2025-10-18 is refused', () {
      final cycle = ZakatCycle(
        calendar: ZakatYear.solar,
        month: 10,
        day: 20,
        from: day(2025, 1, 5),
      );
      final s2026 = yearSlots(
        [cycle],
        {day(2025, 10, 20): day(2025, 10, 18)},
        today,
      ).firstWhere((s) => s.number == 2026);
      expect(
        validateGift(egpGift('1', day(2025, 10, 19)), s2026, today),
        isEmpty,
      );
      expect(validateGift(egpGift('1', day(2025, 10, 18)), s2026, today), [
        GiftError.dateTooEarly,
      ]);
    });

    test('AC-46 first year: with no 2025 in the app, 2025-10-21 is accepted and 2025-10-20 refused', () {
      final cycle = ZakatCycle(
        calendar: ZakatYear.solar,
        month: 10,
        day: 20,
        from: day(2026, 1, 5),
      );
      final slots = yearSlots([cycle], const {}, day(2026, 1, 5));
      expect(slots.map((s) => s.number), [2026]);
      expect(
        validateGift(egpGift('1', day(2025, 10, 21)), slots.single, today),
        isEmpty,
      );
      expect(
        validateGift(egpGift('1', day(2025, 10, 20)), slots.single, today),
        [GiftError.dateTooEarly],
      );
    });

    test('AC-29 13,000.00 against Z 12,500.00: remaining 0.00, settled, 500.00 more than due, no other year touched', () {
      final gifts = [egpGift('13000', day(2026, 10, 23))];
      final p = progress(d('12500'), gifts, egp);
      expect((p.remaining, p.over), (d('0'), d('500')));
      expect(stateWith(gifts), YearState.settled);
      expect(progress(d('11000'), const [], egp).distributed, d('0'));
    });

    Gift usdGift(GivingRateView view, RateBook book, YearSlot s) {
      final draft = Gift(
        date: day(2026, 10, 22),
        amount: Money(d('100'), usd),
        view: view,
      );
      final q = book.quote(usd, egp, giftRateDate(view, draft, s))!;
      return Gift(
        id: draft.id,
        date: draft.date,
        amount: draft.amount,
        rate: q.rate,
        rateDate: q.asOf,
        view: view,
      );
    }

    test('AC-30 100 USD on 2026-10-22: day-given counts 5,000.00 at the rate of Oct 21; due-date counts 4,800.00 at the rate of Oct 20', () {
      final book = RateBook(yasminRates());
      final day1 = usdGift(GivingRateView.dayGiven, book, dueSlot());
      expect((day1.rate, day1.rateDate), (d('50'), day(2026, 10, 21)));
      expect(counted(day1, egp), d('5000'));
      expect(day1.rateDate != day(2026, 10, 22), isTrue);
      expect(progress(d('12500'), [day1], egp).remaining, d('7500'));
      final day2 = usdGift(GivingRateView.dueDate, book, dueSlot());
      expect((day2.rate, day2.rateDate), (d('48'), due));
      expect(counted(day2, egp), d('4800'));
      expect(progress(d('12500'), [day2], egp).remaining, d('7700'));
    });

    test(
      'AC-30 a later change of view does not recount an entry that is stored',
      () {
        final book = RateBook(yasminRates());
        final old = usdGift(GivingRateView.dayGiven, book, dueSlot());
        final book2 = RateBook([
          ...yasminRates(),
          rate(usd, egp, '60', day(2026, 10, 22)),
        ]);
        expect(counted(old, egp), d('5000'));
        final edited = usdGift(GivingRateView.dueDate, book2, dueSlot());
        expect(counted(edited, egp), d('4800'));
      },
    );

    test('AC-42 200 SAR with a typed 13.00 dated 2026-10-22 counts 2,600.00; with due-date view the rate asked for is dated D', () {
      final g = Gift(
        date: day(2026, 10, 22),
        amount: Money(d('200'), sar),
        rate: d('13'),
        rateDate: day(2026, 10, 22),
        view: GivingRateView.dayGiven,
      );
      expect(counted(g, egp), d('2600'));
      expect(
        giftRateDate(GivingRateView.dayGiven, g, dueSlot()),
        day(2026, 10, 22),
      );
      expect(giftRateDate(GivingRateView.dueDate, g, dueSlot()), due);
      expect(
        RateBook(yasminRates()).quote(sar, egp, day(2026, 10, 22)),
        isNull,
      );
    });

    test('AC-42 a year started in EGP keeps counting in EGP after the base changes to USD', () {
      final record = ZakatYearRecord(
        dueKey: due,
        debts: d('20000'),
        deductDebts: true,
        frozen: freeze(yasmin().inputs, today),
      );
      final inputs = frozenInputs(dueSlot(), record);
      expect(inputs.base, egp);
      final g = Gift(
        date: day(2026, 10, 22),
        amount: Money(d('200'), sar),
        rate: d('13'),
        rateDate: day(2026, 10, 22),
        view: GivingRateView.dayGiven,
      );
      expect(counted(g, inputs.base), d('2600'));
    });
  });

  group('year-end notification (§5.4)', () {
    YearView viewOf(YearSlot s, {bool frozen = false}) {
      final i = yasmin().inputs;
      return yearViewOf(
        s,
        frozen
            ? ZakatYearRecord(
                dueKey: s.key,
                debts: Decimal.zero,
                deductDebts: true,
                frozen: freeze(i, today),
              )
            : null,
        frozen
            ? frozenInputs(
                s,
                ZakatYearRecord(
                  dueKey: s.key,
                  debts: Decimal.zero,
                  deductDebts: true,
                  frozen: freeze(i, today),
                ),
              )
            : i,
        today,
      );
    }

    List<YearView> yearsOf(
      ZakatCycle cycle,
      DateTime now, {
      Map<DateTime, DateTime> moved = const {},
    }) => [
      for (final s in yearSlots([cycle], moved, now)) viewOf(s),
    ];

    final solar = ZakatCycle(
      calendar: ZakatYear.solar,
      month: 10,
      day: 20,
      from: day(2026, 1, 5),
    );

    test('AC-35 solar 20 October saved on 2026-01-05: one notification on 2026-10-20 at 09:00 for "2026"', () {
      final now = DateTime(2026, 1, 5, 12);
      final plan = reminderPlan(
        yearsOf(solar, day(2026, 1, 5)),
        const ZakatPrefs(),
        permitted: true,
        now: now,
      )!;
      expect(plan.fireAt, DateTime(2026, 10, 20, 9));
      expect((plan.label, plan.daysBefore), ('2026', 0));
    });

    test('AC-35 lunar 1 Ramadan saved on 2026-10-23 is 1448 AH, notified on 2027-02-08 at 09:00', () {
      final lunar = ZakatCycle(
        calendar: ZakatYear.lunar,
        month: 9,
        day: 1,
        from: day(2026, 10, 23),
      );
      expect(hijriOf(day(2026, 10, 23)), (y: 1448, m: 5, d: 12));
      final years = yearsOf(lunar, day(2026, 10, 23));
      expect(years.map((y) => y.slot.number), [1448]);
      final plan = reminderPlan(
        years,
        const ZakatPrefs(),
        permitted: true,
        now: DateTime(2026, 10, 23, 12),
      )!;
      expect(plan.fireAt, DateTime(2027, 2, 8, 9));
      expect(plan.label, '1448 AH');
    });

    test('AC-37 moving 2027 to 2027-10-18 moves the notification; days before and time move it too', () {
      final now = DateTime(2026, 10, 23, 12);
      DateTime? fire(Map<DateTime, DateTime> moved, ZakatPrefs prefs) =>
          reminderPlan(
            yearsOf(solar, day(2026, 10, 23), moved: moved),
            prefs,
            permitted: true,
            now: now,
          )?.fireAt;
      expect(fire(const {}, const ZakatPrefs()), DateTime(2027, 10, 20, 9));
      expect(
        fire({day(2027, 10, 20): day(2027, 10, 18)}, const ZakatPrefs()),
        DateTime(2027, 10, 18, 9),
      );
      expect(
        fire(const {}, const ZakatPrefs(reminderDays: 2, reminderMinute: 600)),
        DateTime(2027, 10, 18, 10),
      );
    });

    test('AC-37 a change of cycle or calendar does not move the notification of the coming year', () {
      final now = DateTime(2026, 10, 23, 12);
      final before = reminderPlan(
        yearsOf(solar, day(2026, 10, 23)),
        const ZakatPrefs(),
        permitted: true,
        now: now,
      )!;
      final march = ZakatCycle(
        calendar: ZakatYear.solar,
        month: 3,
        day: 1,
        from: newCycleFrom(
          yearSlots([solar], const {}, day(2026, 10, 23)),
          day(2026, 10, 23),
        ),
      );
      final years = [
        for (final s in yearSlots([solar, march], const {}, day(2026, 10, 23)))
          viewOf(s),
      ];
      final after = reminderPlan(
        years,
        const ZakatPrefs(),
        permitted: true,
        now: now,
      )!;
      expect((after.yearKey, after.fireAt), (before.yearKey, before.fireAt));
    });

    test('AC-38 permission denied: no notification', () {
      expect(
        reminderPlan(
          yearsOf(solar, day(2026, 10, 23)),
          const ZakatPrefs(),
          permitted: false,
          now: DateTime(2026, 10, 23, 12),
        ),
        isNull,
      );
    });

    test('AC-40 3 days before at 20:30 is 2027-10-17 20:30; back to 0 is 2027-10-20 20:30', () {
      final now = DateTime(2026, 10, 23, 12);
      ReminderPlan? plan(int days) => reminderPlan(
        yearsOf(solar, day(2026, 10, 23)),
        ZakatPrefs(reminderDays: days, reminderMinute: 20 * 60 + 30),
        permitted: true,
        now: now,
      );
      expect(plan(3)!.fireAt, DateTime(2027, 10, 17, 20, 30));
      expect(plan(3)!.due, day(2027, 10, 20));
      expect(plan(0)!.fireAt, DateTime(2027, 10, 20, 20, 30));
    });

    test('AC-40 cycle date 25 October, 5 days before: the moment 2026-10-20 has passed, so 2026 gets none', () {
      final oct25 = ZakatCycle(
        calendar: ZakatYear.solar,
        month: 10,
        day: 25,
        from: day(2026, 1, 5),
      );
      final years = yearsOf(oct25, day(2026, 10, 23));
      expect(years.last.slot.due, day(2026, 10, 25));
      expect(
        reminderPlan(
          years,
          const ZakatPrefs(reminderDays: 5),
          permitted: true,
          now: DateTime(2026, 10, 23, 12),
        ),
        isNull,
      );
    });

    test(
      'AC-44 switched off: none; on again: the coming year is scheduled',
      () {
        final years = yearsOf(solar, day(2026, 10, 23));
        final now = DateTime(2026, 10, 23, 12);
        expect(
          reminderPlan(
            years,
            const ZakatPrefs(reminderOn: false),
            permitted: true,
            now: now,
          ),
          isNull,
        );
        expect(
          reminderPlan(
            years,
            const ZakatPrefs(),
            permitted: true,
            now: now,
          )!.fireAt,
          DateTime(2027, 10, 20, 9),
        );
      },
    );

    test('a started coming year is not notified', () {
      final slot = yearSlots([solar], const {}, day(2026, 10, 19)).last;
      expect(slot.due, due);
      expect(
        reminderPlan(
          [viewOf(slot, frozen: true)],
          const ZakatPrefs(),
          permitted: true,
          now: DateTime(2026, 10, 19, 12),
        ),
        isNull,
      );
    });
  });
}
