// API assumptions (spec leaves open; developer: match these or tell QA):
// 1 Every spec'd field is a named ctor arg (Money is positional: Money(amount, unit)); nullable ones optional.
// 2 RateBook(List<Rate>), InflationBook(shipped, overrides), Period.month(y,m,today), Period.year(y,today).
// 3 Figures (item + portfolio): dietz, setAside, returnAfterSetAside, inflation (PeriodInflation?), realBeforeZakat,
//   realAfterSetAside, purchasingPower, excluded (List<Excluded{itemId,from,to,date}>), staleRate, staleValues
//   (List<String> ids). ItemFigures also: unitDietz, ownInflation, ownMarketReal. Grams view adds showYardstickLabel.
// 4 SinceStartFigures: days, gain, simpleRoi, simpleRoiBase, sinceStartReturn, annualised.
// 5 DraftError values: missingName/Type/Intent/Market/Unit/StartDate/FirstPaid/Grams/Purity + spec'd extras.
// 6 ZakatYear.r / .days are Decimal. calculator.nisabHint() -> NisabHint{goldNisab,silverNisab: Money?; zakatableTotal: Money}
//   (AC-45 is not in spec §9). Gross grams -> pure grams is form logic, not tested here. UI-only parts are skipped.
import 'package:decimal/decimal.dart';
import 'package:financial_planner/core/assumptions/domain/inflation.dart';
import 'package:financial_planner/core/assumptions/domain/rate.dart';
import 'package:financial_planner/core/assumptions/domain/rate_book.dart';
import 'package:financial_planner/core/assumptions/domain/settings.dart';
import 'package:financial_planner/core/dates.dart';
import 'package:financial_planner/core/money/money.dart';
import 'package:financial_planner/core/reference/countries.dart';
import 'package:financial_planner/core/reference/markets.dart';
import 'package:financial_planner/core/reference/units.dart';
import 'package:financial_planner/features/investments/domain/expected_plan.dart';
import 'package:financial_planner/features/investments/domain/formulas.dart';
import 'package:financial_planner/features/investments/domain/history_entry.dart';
import 'package:financial_planner/features/investments/domain/investment.dart';
import 'package:financial_planner/features/investments/domain/investment_draft.dart';
import 'package:financial_planner/features/investments/domain/item_timeline.dart';
import 'package:financial_planner/features/investments/domain/period.dart';
import 'package:financial_planner/features/investments/domain/portfolio_calculator.dart';
import 'package:financial_planner/features/investments/domain/zakat_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/figures_view.dart';

// ---------------------------------------------------------------- helpers

const egp = Unit('EGP');
const usd = Unit('USD');
const sar = Unit('SAR');
const eur = Unit('EUR');
const gbp = Unit('GBP');
const aed = Unit('AED');
const chf = Unit('CHF');
const egy = Country('EGY');
const usa = Country('USA');
const sau = Country('SAU');

Decimal d(String s) => Decimal.parse(s);
final _epoch = DateTime.utc(2026);
var _seq = 0;
String _id() => 'id${_seq++}';

void expectDec(Decimal? actual, String expected, {String? what}) {
  expect(actual, isNotNull, reason: what);
  final diff = (actual! - d(expected)).abs();
  expect(
    diff <= d('0.005'),
    isTrue,
    reason: '${what ?? ''} got $actual, want $expected',
  );
}

// Percent figures are compared in percent, at the story's 2 decimals.
void expectPct(Decimal? actual, String expected, {String? what}) =>
    expectDec(actual == null ? null : actual * d('100'), expected, what: what);

Investment inv(
  String id, {
  required AssetType type,
  required Unit unit,
  required DateTime start,
  Intent? intent,
  Market? market,
  Country? marketCountry,
  ZakatRule rule = ZakatRule.custom,
  String? share = '0',
  int? karat,
  Country? inflationOverride,
}) => Investment(
  id: id,
  name: id,
  type: type,
  intent: intent,
  market: market,
  marketCountry: marketCountry,
  unit: unit,
  startDate: start,
  purityKarat: karat,
  zakatRule: rule,
  customZakatShare: rule == ZakatRule.custom ? d(share!) : null,
  inflationOverride: inflationOverride,
  createdAt: _epoch,
  updatedAt: _epoch,
);

MoneyIn mIn(String inv, DateTime on, String amount, Unit unit) => MoneyIn(
  id: _id(),
  investmentId: inv,
  date: on,
  amount: Money(d(amount), unit),
  createdAt: _epoch,
  updatedAt: _epoch,
);

MoneyOut mOut(
  String inv,
  DateTime on,
  String amount,
  Unit unit,
  MoneyOutKind kind,
) => MoneyOut(
  id: _id(),
  investmentId: inv,
  date: on,
  amount: Money(d(amount), unit),
  kind: kind,
  createdAt: _epoch,
  updatedAt: _epoch,
);

ValueUpdate val(String inv, DateTime on, String value) => ValueUpdate(
  id: _id(),
  investmentId: inv,
  date: on,
  value: d(value),
  createdAt: _epoch,
  updatedAt: _epoch,
);

InterestRecord interest(
  String inv,
  DateTime on,
  String amount,
  Unit unit,
  InterestKind kind,
) => InterestRecord(
  id: _id(),
  investmentId: inv,
  date: on,
  amount: Money(d(amount), unit),
  kind: kind,
  createdAt: _epoch,
  updatedAt: _epoch,
);

InvestmentWithHistory item(Investment i, List<HistoryEntry> h) =>
    InvestmentWithHistory(investment: i, history: h);

Rate rate(
  Unit from,
  Unit to,
  String r,
  DateTime on, {
  RateSource source = RateSource.typed,
}) => Rate(
  id: _id(),
  from: from,
  to: to,
  rate: d(r),
  asOf: on,
  source: source,
  createdAt: _epoch,
  updatedAt: _epoch,
);

Settings settings({
  Unit base = egp,
  ZakatYear? year = ZakatYear.lunar,
  LongTermMethod? method,
}) => Settings(baseCurrency: base, zakatYear: year, longTermMethod: method);

InflationBook cpiBook(
  Map<Country, Map<int, String>> series, [
  List<InflationOverride> overrides = const [],
]) => InflationBook(
  ShippedInflation(
    source: 'test',
    asOfNote: 'test',
    series: {
      for (final e in series.entries)
        e.key: {for (final y in e.value.entries) y.key: d(y.value)},
    },
  ),
  overrides,
);

PortfolioCalculator calc(
  List<InvestmentWithHistory> items, {
  required DateTime today,
  List<Rate> rates = const [],
  Map<Country, Map<int, String>> cpi = const {},
  List<InflationOverride> overrides = const [],
  Settings? setup,
  Set<int> noZakatYears = const {},
}) => PortfolioCalculator(
  items: items,
  rates: RateBook(rates),
  inflation: cpiBook(cpi, overrides),
  settings: setup ?? settings(),
  noZakatYears: noZakatYears,
  today: today,
);

/// The AC-15 stock: EGX, EGP, zakat share 100 %, 20,000 -> [endValue] over 2026.
InvestmentWithHistory ac15Stock(String endValue) {
  final i = inv(
    'stock',
    type: AssetType.stock,
    intent: Intent.trading,
    market: Market.egx,
    unit: egp,
    start: day(2025, 12, 31),
    rule: ZakatRule.trading100,
  );
  return item(i, [
    mIn('stock', day(2025, 12, 31), '20000', egp),
    val('stock', day(2026, 12, 31), endValue),
  ]);
}

const ac15Cpi = {
  egy: {2026: '0.10'},
};

void main() {
  final today = day(2026, 10, 16);
  final afterYear = day(2027, 1, 15);

  group('fields and history', () {
    test('AC-1 saving a draft with missing required fields is rejected and each missing field is named', () {
      final errors = validate(
        InvestmentDraft(),
        today: today,
        settings: settings(),
      );
      expect(
        errors,
        containsAll([
          DraftError.missingName,
          DraftError.missingType,
          DraftError.missingUnit,
          DraftError.missingStartDate,
          DraftError.missingFirstPaid,
          DraftError.shareRequired,
        ]),
      );

      final stock = validate(
        InvestmentDraft(
          name: 'S',
          type: AssetType.stock,
          unit: egp,
          startDate: day(2026, 1, 1),
          firstPaid: Money(d('100'), egp),
        ),
        today: today,
        settings: settings(),
      );
      expect(
        stock,
        containsAll([DraftError.missingMarket, DraftError.missingIntent]),
      );

      final fund = validate(
        InvestmentDraft(
          name: 'F',
          type: AssetType.fund,
          unit: egp,
          startDate: day(2026, 1, 1),
          firstPaid: Money(d('100'), egp),
        ),
        today: today,
        settings: settings(),
      );
      expect(fund, contains(DraftError.missingIntent));

      final other = validate(
        InvestmentDraft(
          name: 'O',
          type: AssetType.other,
          unit: egp,
          startDate: day(2026, 1, 1),
          firstPaid: Money(d('100'), egp),
        ),
        today: today,
        settings: settings(),
      );
      expect(other, contains(DraftError.missingIntent));

      final gold = validate(
        InvestmentDraft(
          name: 'G',
          type: AssetType.gold,
          intent: Intent.longTerm,
          unit: xauG,
          startDate: day(2026, 1, 1),
          firstPaid: Money(d('100'), egp),
        ),
        today: today,
        settings: settings(),
      );
      expect(
        gold,
        containsAll([DraftError.missingGrams, DraftError.missingPurity]),
      );
    });

    test(
      'AC-2 first money in of 0 or a start date after today is rejected',
      () {
        final zero = validate(
          InvestmentDraft(
            name: 'A',
            type: AssetType.cashDeposit,
            unit: egp,
            startDate: day(2026, 1, 1),
            firstPaid: Money(d('0'), egp),
            zakatRule: ZakatRule.cash100,
          ),
          today: today,
          settings: settings(),
        );
        expect(zero, contains(DraftError.zeroAmount));

        final future = validate(
          InvestmentDraft(
            name: 'A',
            type: AssetType.cashDeposit,
            unit: egp,
            startDate: day(2026, 10, 17),
            firstPaid: Money(d('100'), egp),
            zakatRule: ZakatRule.cash100,
          ),
          today: today,
          settings: settings(),
        );
        expect(future, contains(DraftError.futureDate));
      },
    );

    test('AC-3 adding a value update keeps all updates and February still uses 1,100', () {
      final i = inv(
        'a',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 1, 31),
      );
      final history = <HistoryEntry>[
        mIn('a', day(2026, 1, 31), '1000', egp),
        val('a', day(2026, 1, 31), '1000'),
        val('a', day(2026, 2, 28), '1100'),
      ];
      history.add(val('a', day(2026, 3, 31), '1050'));
      final agg = item(i, history);
      expect(agg.history.whereType<ValueUpdate>().length, 3);

      final tl = ItemTimeline(agg, RateBook(const []));
      expectDec(tl.recordedValueAt(day(2026, 2, 28)), '1100');
      expectDec(tl.recordedValueAt(day(2026, 3, 31)), '1050');

      final feb = calc([
        agg,
      ], today: today).item('a', Period.month(2026, 2, today));
      expectDec(feb.dietz.bv, '1000');
      expectDec(feb.dietz.ev, '1100');
    });

    test('AC-4 a full sale with value left 0 closes the item and it still appears in past months', () {
      final i = inv(
        'a',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 1, 10),
      );
      final agg = item(i, [
        mIn('a', day(2026, 1, 10), '1000', egp),
        mOut('a', day(2026, 3, 15), '1000', egp, MoneyOutKind.sale),
        val('a', day(2026, 3, 15), '0'),
      ]);
      final tl = ItemTimeline(agg, RateBook(const []));
      expect(tl.closedAt(day(2026, 3, 15)), isTrue);
      expect(tl.closedAt(day(2026, 2, 28)), isFalse);

      final c = calc([agg], today: today);
      expectDec(c.item('a', Period.month(2026, 2, today)).dietz.ev, '1000');
      expectDec(
        c.portfolio(Period.month(2026, 2, today), ViewUnit.base).dietz.ev,
        '1000',
      );
      expect(
        periodsBetween(day(2026, 1, 10), today, Granularity.month).length,
        10,
      );
    });
  });

  group('zakat share defaults and settings', () {
    test('AC-5 a dividends-only stock has share 0 and its set-aside is 2.5 % of each dividend (25 / 10 / 15)', () {
      final i = inv(
        'div',
        type: AssetType.stock,
        intent: Intent.longTerm,
        market: Market.egx,
        unit: egp,
        start: day(2025, 1, 1),
        rule: ZakatRule.longTermDividendsOnly,
      );
      final resolved = resolve(
        i,
        settings(method: LongTermMethod.dividendsOnly),
      );
      expectDec(resolved.share, '0');
      expect(resolved.onDividends, isTrue);
      expect(resolved.notice, ZakatNotice.dividendsCountedWithCash);

      final agg = item(i, [
        mIn('div', day(2025, 1, 1), '50000', egp),
        val('div', day(2025, 12, 31), '50000'),
        mOut('div', day(2026, 3, 15), '400', egp, MoneyOutKind.income),
        val('div', day(2026, 3, 15), '50000'),
        mOut('div', day(2026, 9, 15), '600', egp, MoneyOutKind.income),
        val('div', day(2026, 9, 15), '50000'),
        val('div', day(2026, 12, 31), '50000'),
      ]);
      final c = calc([agg], today: afterYear);
      expectDec(
        c.item('div', Period.year(2026, afterYear)).setAside,
        '25.00',
        what: 'year',
      );
      expectDec(
        c.item('div', Period.month(2026, 3, afterYear)).setAside,
        '10.00',
        what: 'March',
      );
      expectDec(
        c.item('div', Period.month(2026, 9, afterYear)).setAside,
        '15.00',
        what: 'September',
      );
      expectDec(
        c.item('div', Period.month(2026, 4, afterYear)).setAside,
        '0',
        what: 'April',
      );
    });

    test('AC-6 a new crypto item defaults to 100 % and carries the disputed-permissibility notice', () {
      expect(
        defaultRule(AssetType.crypto, null, settings()),
        ZakatRule.crypto100,
      );
      final i = inv(
        'c',
        type: AssetType.crypto,
        unit: usd,
        start: day(2026, 1, 1),
        rule: ZakatRule.crypto100,
      );
      final r = resolve(i, settings());
      expectDec(r.share, '1');
      expect(r.notice, ZakatNotice.cryptoDisputed);
    });

    test('AC-7 an "other" item without a confirmed zakat share is rejected and never gets a default', () {
      for (final intent in [
        Intent.personalUse,
        Intent.rental,
        Intent.trading,
        Intent.longTerm,
      ]) {
        expect(
          defaultRule(AssetType.other, intent, settings()),
          isNull,
          reason: '$intent',
        );
      }
      InvestmentDraft draft({ZakatRule? rule, Decimal? share}) =>
          InvestmentDraft(
            name: 'Flat',
            type: AssetType.other,
            intent: Intent.personalUse,
            unit: egp,
            startDate: day(2026, 1, 1),
            firstPaid: Money(d('100'), egp),
            zakatRule: rule,
            customZakatShare: share,
          );

      expect(
        validate(draft(), today: today, settings: settings()),
        contains(DraftError.shareRequired),
      );
      expect(
        validate(
          draft(rule: ZakatRule.custom, share: d('0')),
          today: today,
          settings: settings(),
        ),
        isNot(contains(DraftError.shareRequired)),
      );
    });

    test('AC-9 zakat year lunar and solar are matched pairs: 2.5 % / 354.367 and 2.577 % / 365', () {
      expect(ZakatYear.lunar.r, d('0.025'));
      expect(ZakatYear.lunar.days, d('354.367'));
      expect(ZakatYear.solar.r, d('0.02577'));
      expect(ZakatYear.solar.days, d('365'));
      expect(ZakatYear.values.length, 2);
    });
  });

  group('simple ROI and annualised', () {
    test('AC-10 Fund A over exactly 365 days has gain 1,500 and 15.00 % simple, since-start and annualised', () {
      final i = inv(
        'a',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2025, 1, 1),
      );
      final s = calc([
        item(i, [
          mIn('a', day(2025, 1, 1), '10000', egp),
          val('a', day(2026, 1, 1), '11500'),
        ]),
      ], today: today).sinceStart('a');
      expect(s.days, 365);
      expectDec(s.gain, '1500');
      expectPct(s.simpleRoi, '15.00');
      expectPct(s.sinceStartReturn, '15.00');
      expectPct(s.annualised, '15.00');
      expectPct(annualised(d('0.15'), 365), '15.00');
    });

    test('AC-11 after 184 days simple ROI is 5.00 % and no annualised figure is shown', () {
      final i = inv(
        'a',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 3, 1),
      );
      final s = calc([
        item(i, [
          mIn('a', day(2026, 3, 1), '1000', egp),
          val('a', day(2026, 9, 1), '1050'),
        ]),
      ], today: today).sinceStart('a');
      expect(s.days, 184);
      expectPct(s.simpleRoi, '5.00');
      expect(s.annualised, isNull);
      expect(annualised(d('0.05'), 184), isNull);
    });
  });

  group('Modified Dietz', () {
    InvestmentWithHistory fundA({ZakatRule rule = ZakatRule.custom}) => item(
      inv(
        'A',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 3, 31),
        rule: rule,
      ),
      [
        mIn('A', day(2026, 3, 31), '10000', egp),
        mIn('A', day(2026, 4, 16), '4000', egp),
        val('A', day(2026, 4, 30), '14500'),
      ],
    );
    InvestmentWithHistory fundB() => item(
      inv(
        'B',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 3, 31),
      ),
      [
        mIn('B', day(2026, 3, 31), '5000', egp),
        val('B', day(2026, 4, 30), '4900'),
      ],
    );

    test('AC-12 a mid-month deposit is weighted 14/30 so April return is 4.21 %, not 45 %', () {
      final f = calc([
        fundA(),
      ], today: today).item('A', Period.month(2026, 4, today));
      expectDec(f.dietz.d, '11866.67');
      expectPct(f.dietz.r, '4.21');

      final dz = modifiedDietz(
        bv: d('10000'),
        ev: d('14500'),
        flows: [Flow(date: day(2026, 4, 16), amount: d('4000'))],
        s: day(2026, 3, 31),
        e: day(2026, 4, 30),
      );
      expectDec(dz.d, '11866.67');
      expectPct(dz.r, '4.21');
    });

    test('AC-13 April totals of Fund A + Fund B are BV 15,000, CF 4,000, EV 19,400, D 16,866.67, return 2.37 %', () {
      final p = calc([
        fundA(),
        fundB(),
      ], today: today).portfolio(Period.month(2026, 4, today), ViewUnit.base);
      expectDec(p.dietz.bv, '15000');
      expectDec(p.dietz.cf, '4000');
      expectDec(p.dietz.ev, '19400');
      expectDec(p.dietz.d, '16866.67');
      expectPct(p.dietz.r, '2.37');
    });

    test('AC-14 with Fund A at 100 % and Egypt inflation 10 %, April set-aside is 30.69, after set-aside 2.19 %, '
        'inflation 0.79 %, real 1.39 %', () {
      final p = calc(
        [fundA(rule: ZakatRule.trading100), fundB()],
        today: today,
        cpi: const {
          egy: {2026: '0.10'},
        },
      ).portfolio(Period.month(2026, 4, today), ViewUnit.base);
      expectDec(p.setAside, '30.69');
      expectPct(p.returnAfterSetAside, '2.19');
      expectPct(p.inflation!.i, '0.79');
      expectPct(p.realAfterSetAside, '1.39');
    });
  });

  group('after zakat, after inflation, purchasing power', () {
    test('AC-15 a 100 % stock over 2026 gives 15.00 % / set-aside 592.25 / 12.04 % / real 4.55 % and 1.85 % / '
        'needed 22,581.48 and 12.91 % / gap +407.75 kept', () {
      final f = calc(
        [ac15Stock('23000')],
        today: afterYear,
        cpi: ac15Cpi,
      ).item('stock', Period.year(2026, afterYear));
      expectPct(f.dietz.r, '15.00');
      expectDec(f.setAside, '592.25');
      expectPct(f.returnAfterSetAside, '12.04');
      expectPct(f.realBeforeZakat, '4.55');
      expectPct(f.realAfterSetAside, '1.85');
      expectDec(f.purchasingPower!.neededEnd, '22581.48');
      expectPct(f.purchasingPower!.neededReturn, '12.91');
      expectDec(f.purchasingPower!.gap, '407.75');
      expect(f.purchasingPower!.kept, isTrue);
    });

    test(
      'AC-16 with the solar zakat year the same stock has set-aside 592.71',
      () {
        final f = calc(
          [ac15Stock('23000')],
          today: afterYear,
          cpi: ac15Cpi,
          setup: settings(year: ZakatYear.solar),
        ).item('stock', Period.year(2026, afterYear));
        expectDec(f.setAside, '592.71');
      },
    );

    test('AC-17 with end value 22,000 the set-aside is 566.50, the gap -566.50 lost and real after set-aside -2.58 %', () {
      final f = calc(
        [ac15Stock('22000')],
        today: afterYear,
        cpi: ac15Cpi,
      ).item('stock', Period.year(2026, afterYear));
      expectDec(f.setAside, '566.50');
      expectDec(f.purchasingPower!.gap, '-566.50');
      expect(f.purchasingPower!.kept, isFalse);
      expectPct(f.realAfterSetAside, '-2.58');
    });

    test('AC-18 with "no zakat due this year" on for 2026 the after-set-aside figures equal the before-zakat figures', () {
      final f = calc(
        [ac15Stock('23000')],
        today: afterYear,
        cpi: ac15Cpi,
        noZakatYears: {2026},
      ).item('stock', Period.year(2026, afterYear));
      expectDec(f.setAside, '0');
      expect(f.returnAfterSetAside, f.dietz.r);
      expect(f.realAfterSetAside, f.realBeforeZakat);
      expectDec(
        setAside(
          year: ZakatYear.lunar,
          share: d('1'),
          ev: d('23000'),
          days: 0,
          dividends: d('0'),
        ),
        '0',
      );
    });
  });

  group('interest (to purify)', () {
    Investment deposit() => inv(
      'dep',
      type: AssetType.cashDeposit,
      unit: egp,
      start: day(2025, 12, 31),
      rule: ZakatRule.cash100,
    );

    test('AC-19 interest kept inside is no return, not in the zakat base, shown as 500 to purify, cleared by giving it away', () {
      final history = <HistoryEntry>[
        mIn('dep', day(2025, 12, 31), '10000', egp),
        interest('dep', day(2026, 6, 30), '500', egp, InterestKind.keptInside),
        val('dep', day(2026, 12, 31), '10500'),
      ];
      final c = calc([item(deposit(), history)], today: afterYear);
      final y = c.item('dep', Period.year(2026, afterYear));
      expectPct(y.dietz.r, '0.00');
      expectDec(y.dietz.ev - y.dietz.bv - y.dietz.cf, '0');
      expectDec(y.setAside, '257.50');

      final tl = ItemTimeline(item(deposit(), history), RateBook(const []));
      expectDec(tl.toPurifyAt(day(2026, 12, 31)).amount, '500.00');
      expectDec(tl.heldInterestAt(day(2026, 12, 31)), '500');
      expectDec(tl.netValueAt(day(2026, 12, 31)), '10000');
      expectDec(tl.recordedValueAt(day(2026, 6, 30)), '10500');

      final later = [
        ...history,
        interest(
          'dep',
          day(2027, 1, 5),
          '500',
          egp,
          InterestKind.givenAwayFromInside,
        ),
      ];
      final tl2 = ItemTimeline(item(deposit(), later), RateBook(const []));
      expectDec(tl2.toPurifyAt(day(2027, 1, 5)).amount, '0');
      final end = day(2027, 3, 1);
      final y2027 = calc([
        item(deposit(), later),
      ], today: end).item('dep', Period.year(2027, end));
      expectPct(y2027.dietz.r, '0.00');
    });

    test('AC-19b interest paid out then given away from that interest leaves value, H and return unchanged', () {
      final history = <HistoryEntry>[
        mIn('dep', day(2025, 12, 31), '10000', egp),
        interest('dep', day(2026, 6, 30), '300', egp, InterestKind.paidOut),
        interest(
          'dep',
          day(2026, 7, 10),
          '300',
          egp,
          InterestKind.givenAwayFromPaidOut,
        ),
        val('dep', day(2026, 12, 31), '10000'),
      ];
      final agg = item(deposit(), history);
      final tl = ItemTimeline(agg, RateBook(const []));
      expectDec(tl.toPurifyAt(day(2026, 6, 30)).amount, '300.00');
      expectDec(tl.toPurifyAt(day(2026, 7, 10)).amount, '0.00');
      for (final on in [
        day(2026, 6, 30),
        day(2026, 7, 10),
        day(2026, 12, 31),
      ]) {
        expectDec(tl.recordedValueAt(on), '10000');
        expectDec(tl.heldInterestAt(on), '0');
      }
      final y = calc([
        agg,
      ], today: afterYear).item('dep', Period.year(2026, afterYear));
      expectPct(y.dietz.r, '0.00');
      expectDec(y.setAside, '257.50');
    });
  });

  group('multi-currency', () {
    final rates = [
      rate(usd, egp, '50.00', day(2025, 12, 31)),
      rate(usd, egp, '55.00', day(2026, 12, 31)),
    ];

    List<InvestmentWithHistory> ac20Items() => [
      item(
        inv(
          'us',
          type: AssetType.stock,
          intent: Intent.trading,
          market: Market.nasdaq,
          unit: usd,
          start: day(2025, 12, 31),
        ),
        [
          mIn('us', day(2025, 12, 31), '1000', usd),
          val('us', day(2026, 12, 31), '1050'),
        ],
      ),
      item(
        inv(
          'egx',
          type: AssetType.stock,
          intent: Intent.trading,
          market: Market.egx,
          unit: egp,
          start: day(2025, 12, 31),
        ),
        [
          mIn('egx', day(2025, 12, 31), '50000', egp),
          val('egx', day(2026, 12, 31), '60000'),
        ],
      ),
    ];

    test('AC-20 US stock +5 % in USD is +15.50 % in EGP; totals 17.75 %, real -1.88 %, gap -2,250 lost, not the average of own-market reals', () {
      final c = calc(
        ac20Items(),
        today: afterYear,
        rates: rates,
        cpi: const {
          egy: {2026: '0.20'},
          usa: {2026: '0.03'},
        },
      );
      final us = c.item('us', Period.year(2026, afterYear));
      expectPct(us.unitDietz.r, '5.00');
      expectPct(us.ownMarketReal, '1.94');
      expectPct(us.dietz.r, '15.50');
      expectPct(us.realBeforeZakat, '-3.75');

      final t = c.portfolio(Period.year(2026, afterYear), ViewUnit.base);
      expectDec(t.dietz.bv, '100000');
      expectDec(t.dietz.ev, '117750');
      expectPct(t.dietz.r, '17.75');
      expectPct(t.realBeforeZakat, '-1.88');
      expectDec(t.purchasingPower!.gap, '-2250.00');
      expect(t.purchasingPower!.kept, isFalse);
      expect(
        (t.realBeforeZakat! * d('100') - d('0.97')).abs() > d('0.005'),
        isTrue,
        reason: 'must not be the average of own-market reals',
      );
    });

    test('AC-21 a USD item with no USD->EGP rate is left out of April totals and named as missing', () {
      final us = item(
        inv(
          'us',
          type: AssetType.stock,
          intent: Intent.trading,
          market: Market.nasdaq,
          unit: usd,
          start: day(2026, 1, 1),
        ),
        [mIn('us', day(2026, 1, 1), '1000', usd)],
      );
      final eg = item(
        inv(
          'eg',
          type: AssetType.fund,
          intent: Intent.trading,
          unit: egp,
          start: day(2026, 1, 1),
        ),
        [mIn('eg', day(2026, 1, 1), '2000', egp)],
      );
      final p = calc([
        us,
        eg,
      ], today: today).portfolio(Period.month(2026, 4, today), ViewUnit.base);
      expectDec(p.dietz.ev, '2000');
      final missing = p.excluded.single;
      expect(missing.itemId, 'us');
      expect(missing.from, usd);
      expect(missing.to, egp);
    });

    test('AC-22 with only a January rate, May uses 50.00 and is marked "rate not updated in this period"', () {
      final us = item(
        inv(
          'us',
          type: AssetType.stock,
          intent: Intent.trading,
          market: Market.nasdaq,
          unit: usd,
          start: day(2026, 1, 15),
        ),
        [mIn('us', day(2026, 1, 15), '1000', usd)],
      );
      final p = calc(
        [us],
        today: today,
        rates: [rate(usd, egp, '50.00', day(2026, 1, 15))],
      ).portfolio(Period.month(2026, 5, today), ViewUnit.base);
      expectDec(p.dietz.ev, '50000');
      expect(p.staleRate, isTrue);
    });

    test('AC-23 an EGP->USD rate of 0.02 also converts 1,000 USD to 50,000 EGP that day', () {
      final book = RateBook([rate(egp, usd, '0.02', day(2026, 4, 30))]);
      expectDec(
        book.convert(Money(d('1000'), usd), egp, day(2026, 4, 30))!.amount,
        '50000',
      );
      expect(
        book.convert(Money(d('1000'), usd), egp, day(2026, 4, 29)),
        isNull,
      );
    });

    test('AC-24 a USD stock bought with 50,000 EGP when USD->EGP is 50 has first money in 1,000 USD', () {
      final i = inv(
        'us',
        type: AssetType.stock,
        intent: Intent.trading,
        market: Market.nasdaq,
        unit: usd,
        start: day(2026, 3, 1),
      );
      final tl = ItemTimeline(
        item(i, [mIn('us', day(2026, 3, 1), '50000', egp)]),
        RateBook([rate(usd, egp, '50.00', day(2026, 3, 1))]),
      );
      expectDec(
        tl.flowsIn(day(2026, 2, 28), day(2026, 3, 1)).single.amount,
        '1000',
      );
    });
  });

  group('rates', () {
    test('AC-28 a typed rate and a fetched rate on the same date are both stored and the typed one is used', () {
      final book = RateBook([
        rate(
          usd,
          egp,
          '48.50',
          day(2026, 10, 15),
          source: RateSource.currencyApi,
        ),
        rate(usd, egp, '49.00', day(2026, 10, 15)),
      ]);
      final q = book.quote(usd, egp, day(2026, 10, 15))!;
      expectDec(q.rate, '49.00');
      expect(q.source, RateSource.typed);
      final reversed = RateBook([
        rate(usd, egp, '49.00', day(2026, 10, 15)),
        rate(
          usd,
          egp,
          '48.50',
          day(2026, 10, 15),
          source: RateSource.currencyApi,
        ),
      ]);
      expectDec(reversed.quote(usd, egp, day(2026, 10, 15))!.rate, '49.00');
    });
  });

  group('inflation choice and shipped defaults', () {
    test('AC-31 inflation series: Tadawul stock -> Saudi Arabia, USD deposit -> United States, override -> Egypt', () {
      final tad = item(
        inv(
          'tad',
          type: AssetType.stock,
          intent: Intent.trading,
          market: Market.tadawul,
          unit: sar,
          start: day(2025, 12, 31),
        ),
        [mIn('tad', day(2025, 12, 31), '1000', sar)],
      );
      final dep = item(
        inv(
          'dep',
          type: AssetType.cashDeposit,
          unit: usd,
          start: day(2025, 12, 31),
          rule: ZakatRule.cash100,
        ),
        [mIn('dep', day(2025, 12, 31), '1000', usd)],
      );
      final ovr = item(
        inv(
          'ovr',
          type: AssetType.cashDeposit,
          unit: usd,
          start: day(2025, 12, 31),
          rule: ZakatRule.cash100,
          inflationOverride: egy,
        ),
        [mIn('ovr', day(2025, 12, 31), '1000', usd)],
      );
      final c = calc(
        [tad, dep, ovr],
        today: afterYear,
        rates: [rate(sar, usd, '0.27', day(2025, 12, 31))],
        cpi: const {
          sau: {2026: '0.02'},
          usa: {2026: '0.03'},
          egy: {2026: '0.20'},
        },
        setup: settings(base: usd),
      );
      final y = Period.year(2026, afterYear);
      expectPct(c.item('tad', y).ownInflation!.i, '2.00');
      expectPct(c.item('dep', y).ownInflation!.i, '3.00');
      expectPct(c.item('ovr', y).ownInflation!.i, '20.00');
    });

    test('AC-32 a user override wins over shipped values, also after an update ships a new value, and removing it restores shipped', () {
      final shipped = ShippedInflation(
        source: 'World Bank',
        asOfNote: 'as of 2025',
        series: {
          egy: {2025: d('0.25')},
        },
      );
      expect(shipped.source, 'World Bank');
      expect(shipped.asOfNote, contains('2025'));

      final book = InflationBook(shipped, const []);
      expect(book.forYear(egy, 2025)!.provenance, InflationProvenance.shipped);
      expectPct(book.forYear(egy, 2025)!.rate, '25.00');

      final override = InflationOverride(
        id: 'o1',
        country: egy,
        year: 2025,
        rate: d('0.30'),
        createdAt: _epoch,
        updatedAt: _epoch,
      );
      final withOverride = InflationBook(shipped, [override]);
      expectPct(withOverride.forYear(egy, 2025)!.rate, '30.00');
      expect(
        withOverride.forYear(egy, 2025)!.provenance,
        InflationProvenance.user,
      );

      final updated = ShippedInflation(
        source: 'World Bank',
        asOfNote: 'as of 2025',
        series: {
          egy: {2025: d('0.28')},
        },
      );
      expectPct(
        InflationBook(updated, [override]).forYear(egy, 2025)!.rate,
        '30.00',
      );
      expectPct(
        InflationBook(updated, const []).forYear(egy, 2025)!.rate,
        '28.00',
      );
    });

    test('AC-33 with Egypt known only to 2025 = 25 %, 2026 uses 25 % marked "inflation assumed from 2025"', () {
      final book = cpiBook(const {
        egy: {2025: '0.25'},
      });
      final y = book.forYear(egy, 2026)!;
      expectPct(y.rate, '25.00');
      expect(y.provenance, InflationProvenance.assumed);
      expect(y.assumedFrom, 2025);
      final p = book.forPeriod(egy, day(2026, 3, 31), day(2026, 4, 30))!;
      expect(p.years.single.provenance, InflationProvenance.assumed);
      expect(cpiBook(const {}).forYear(egy, 2026), isNull);
    });

    test('AC-34 a period over a year end with 31 days in each year has inflation 2.39 %', () {
      final book = cpiBook(const {
        egy: {2025: '0.10', 2026: '0.20'},
      });
      expectPct(
        book.forPeriod(egy, day(2025, 11, 30), day(2026, 1, 31))!.i,
        '2.39',
      );
    });
  });

  group('gold and silver', () {
    Investment gold(String id, {DateTime? start}) => inv(
      id,
      type: AssetType.gold,
      intent: Intent.longTerm,
      unit: xauG,
      start: start ?? day(2025, 12, 31),
      rule: ZakatRule.bullion100,
      karat: 21,
    );
    final goldRates = [
      rate(xauG, egp, '4000', day(2025, 12, 31)),
      rate(xauG, egp, '5000', day(2026, 12, 31)),
    ];
    InvestmentWithHistory ac36Gold() => item(gold('gold'), [
      mIn('gold', day(2025, 12, 31), '70000', egp),
      val('gold', day(2025, 12, 31), '17.5'),
    ]);

    test('AC-36 17.5 pure grams over 2026: 0 % in gold, 25 % in EGP, set-aside 2,253.14, 21.78 % after, real 1.48 %, gap +1,246.86 kept', () {
      final f = calc(
        [ac36Gold()],
        today: afterYear,
        rates: goldRates,
        cpi: const {
          egy: {2026: '0.20'},
        },
      ).item('gold', Period.year(2026, afterYear));
      expectPct(f.unitDietz.r, '0.00');
      expectPct(f.dietz.r, '25.00');
      expectDec(f.setAside, '2253.14');
      expectPct(f.returnAfterSetAside, '21.78');
      expectPct(f.realAfterSetAside, '1.48');
      expectDec(f.purchasingPower!.gap, '1246.86');
      expect(f.purchasingPower!.kept, isTrue);
    });

    test('AC-37 buying 10 g of gold for 52,000 EGP at 5,000 is 10.40 XAU-g and a -3.85 % return in gold and in EGP', () {
      final agg = item(gold('g', start: day(2026, 3, 1)), [
        mIn('g', day(2026, 3, 1), '52000', egp),
        val('g', day(2026, 3, 1), '10'),
      ]);
      final rates = [rate(xauG, egp, '5000', day(2026, 3, 1))];
      final tl = ItemTimeline(agg, RateBook(rates));
      expectDec(
        tl.flowsIn(day(2026, 2, 28), day(2026, 3, 1)).single.amount,
        '10.40',
      );
      final s = calc([agg], today: today, rates: rates).sinceStart('g');
      expectPct(s.simpleRoi, '-3.85');
      expectPct(s.simpleRoiBase, '-3.85');
      expectPct(s.sinceStartReturn, '-3.85');
    });

    test('AC-38 one gold-rate update revalues every gold item with no per-item value update', () {
      final a = item(gold('a'), [
        mIn('a', day(2025, 12, 31), '70000', egp),
        val('a', day(2025, 12, 31), '17.5'),
      ]);
      final b = item(gold('b'), [
        mIn('b', day(2025, 12, 31), '40000', egp),
        val('b', day(2025, 12, 31), '10'),
      ]);
      final c = calc([a, b], today: afterYear, rates: goldRates);
      final y = Period.year(2026, afterYear);
      expectDec(c.item('a', y).dietz.ev, '87500');
      expectDec(c.item('b', y).dietz.ev, '50000');
      expectDec(c.portfolio(y, ViewUnit.base).dietz.ev, '137500');
    });

    test('AC-39 grams view of AC-36: 17.50 g both ends, set-aside 0.45 g, -2.58 % after set-aside, no inflation, lost 0.45 g, yardstick label', () {
      final p = calc(
        [ac36Gold()],
        today: afterYear,
        rates: goldRates,
        cpi: const {
          egy: {2026: '0.20'},
        },
      ).portfolio(Period.year(2026, afterYear), ViewUnit.goldGrams);
      expectDec(p.dietz.bv, '17.50');
      expectDec(p.dietz.ev, '17.50');
      expectDec(p.setAside, '0.45');
      expectPct(p.returnAfterSetAside, '-2.58');
      expect(p.realBeforeZakat, isNull);
      expect(p.realAfterSetAside, isNull);
      expectDec(p.purchasingPower!.gap, '-0.45');
      expect(p.purchasingPower!.kept, isFalse);
      expect(p.showYardstickLabel, isTrue);
    });
  });

  group('staleness and edge cases', () {
    test('AC-40 an item first valued on 20 June has 0.00 % for Feb to May marked stale and June holds the whole gain', () {
      final i = inv(
        'a',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 1, 10),
      );
      final c = calc([
        item(i, [
          mIn('a', day(2026, 1, 10), '1000', egp),
          val('a', day(2026, 6, 20), '1200'),
        ]),
      ], today: today);
      for (var m = 2; m <= 5; m++) {
        final p = Period.month(2026, m, today);
        expectPct(c.item('a', p).dietz.r, '0.00', what: 'month $m');
        expect(
          c.portfolio(p, ViewUnit.base).staleValues,
          contains('a'),
          reason: 'month $m',
        );
      }
      final june = Period.month(2026, 6, today);
      expectPct(c.item('a', june).dietz.r, '20.00');
      expect(
        c.portfolio(june, ViewUnit.base).staleValues,
        isNot(contains('a')),
      );
    });

    test('AC-41 when average capital is 0 or less the return is "not available", never an error or infinity', () {
      final dz = modifiedDietz(
        bv: d('0'),
        ev: d('0'),
        flows: const [],
        s: day(2026, 3, 31),
        e: day(2026, 4, 30),
      );
      expect(dz.r, isNull);
      expect(afterSetAsideReturn(dz, d('0')), isNull);
      expect(purchasingPower(dz, d('0'), d('0.1')), isNull);

      final i = inv(
        'a',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        start: day(2026, 1, 10),
      );
      final closed = item(i, [
        mIn('a', day(2026, 1, 10), '1000', egp),
        mOut('a', day(2026, 2, 15), '1000', egp, MoneyOutKind.sale),
        val('a', day(2026, 2, 15), '0'),
      ]);
      final f = calc([
        closed,
      ], today: today).item('a', Period.month(2026, 3, today));
      expect(f.dietz.r, isNull);
      expect(f.returnAfterSetAside, isNull);
      expect(f.realBeforeZakat, isNull);
      expect(f.purchasingPower, isNull);
    });
  });

  group('unit picker order', () {
    PortfolioCalculator withUnits(Map<Unit, int> counts, {Unit base = egp}) {
      final items = <InvestmentWithHistory>[];
      counts.forEach((u, n) {
        for (var k = 0; k < n; k++) {
          final id = '${u.code}$k';
          items.add(
            item(
              inv(
                id,
                type: AssetType.cashDeposit,
                unit: u,
                start: day(2026, 1, 1),
                rule: ZakatRule.cash100,
              ),
              [mIn(id, day(2026, 1, 1), '100', u)],
            ),
          );
        }
      });
      return calc(
        items,
        today: today,
        setup: settings(base: base),
      );
    }

    List<Unit> restSorted(Set<Unit> top) =>
        (allUnits.where((u) => !top.contains(u)).toList()
          ..sort((a, b) => a.code.compareTo(b.code)));

    test('AC-42 with USD x3, EGP x2, SAR x1, XAU-g x1 and base EGP the list starts USD, EGP, SAR, XAU-g then the rest by code', () {
      final c = withUnits({usd: 3, egp: 2, sar: 1, xauG: 1});
      final usage = c.unitUsage();
      expect(usage[usd], 3);
      expect(usage[egp], 2);
      final list = orderedUnits(usage: usage, topAnchor: egp);
      final top = [usd, egp, sar, xauG];
      expect(list.take(4).toList(), top);
      expect(list.skip(4).toList(), restSorted(top.toSet()));
      expect(list.length, allUnits.length);
      expect(list.toSet().length, list.length);
      expect(allUnits.length, 34);
    });

    test('AC-43 with 6 units none in the base currency the top group is the base plus the 4 most used, ties by code', () {
      final c = withUnits({usd: 3, sar: 2, eur: 2, gbp: 1, aed: 1, chf: 1});
      final list = orderedUnits(usage: c.unitUsage(), topAnchor: egp);
      final top = {egp, usd, eur, sar, aed};
      expect(list.take(5).toSet(), top);
      expect(list.skip(5).toList(), restSorted(top));
    });

    test('AC-44 a new user with base SAR and no investments sees SAR first, then all units alphabetically', () {
      final list = orderedUnits(usage: const {}, topAnchor: sar);
      expect(list.first, sar);
      expect(list.skip(1).toList(), restSorted({sar}));
    });
  });

  group('nisab hint', () {
    List<InvestmentWithHistory> nisabItems() => [
      item(
        inv(
          'cash',
          type: AssetType.cashDeposit,
          unit: egp,
          start: day(2026, 1, 1),
          rule: ZakatRule.cash100,
        ),
        [mIn('cash', day(2026, 1, 1), '100000', egp)],
      ),
      item(
        inv(
          'lt',
          type: AssetType.stock,
          intent: Intent.longTerm,
          market: Market.egx,
          unit: egp,
          start: day(2026, 1, 1),
          rule: ZakatRule.longTermProxy25,
        ),
        [mIn('lt', day(2026, 1, 1), '50000', egp)],
      ),
    ];

    test('AC-45 the nisab hint shows 85 g gold = 425,000, 595 g silver = 35,700 and zakatable total 112,500 EGP', () {
      final hint = calc(
        nisabItems(),
        today: today,
        rates: [rate(xauG, egp, '5000', today), rate(xagG, egp, '60', today)],
      ).nisabHint();
      expectDec(hint.goldNisab!.amount, '425000.00');
      expect(hint.goldNisab!.unit, egp);
      expectDec(hint.silverNisab!.amount, '35700.00');
      expectDec(hint.zakatableTotal.amount, '112500.00');

      final noGold = calc(
        nisabItems(),
        today: today,
        rates: [rate(xagG, egp, '60', today)],
      ).nisabHint();
      expect(noGold.goldNisab, isNull);
      expectDec(noGold.silverNisab!.amount, '35700.00');
    });
  });
  group('expected vs actual and private equity', () {
    /// "Friend's project" (story §10): private equity, long-term, EGP, start
    /// 2026-01-15, 100,000 in, 20 % a year, paid every 3 months.
    Investment friend({
      ZakatRule rule = ZakatRule.longTermFullValue,
      String? profit = '0.20',
      Schedule? payout = Schedule.quarterly,
      ProfitBasis? q1 = ProfitBasis.shareOfProfit,
      CapitalBack q2 = CapitalBack.no,
    }) => Investment(
      id: 'fp',
      name: "Friend's project",
      type: AssetType.privateEquity,
      intent: Intent.longTerm,
      unit: egp,
      startDate: day(2026, 1, 15),
      zakatRule: rule,
      payoutSchedule: payout,
      expectedProfit: profit == null ? null : d(profit),
      profitBasis: profit == null ? null : q1,
      capitalBack: q2,
      createdAt: _epoch,
      updatedAt: _epoch,
    );

    MoneyIn fpIn() => mIn('fp', day(2026, 1, 15), '100000', egp);

    MoneyOut fpIncome(DateTime on, String a) =>
        mOut('fp', on, a, egp, MoneyOutKind.income);

    PlanSkip skip(String id, DateTime on, PlanKind k) => PlanSkip(
      id: _id(),
      investmentId: id,
      date: on,
      plan: k,
      createdAt: _epoch,
      updatedAt: _epoch,
    );

    ExpectedVsActual planOf(Investment i, List<HistoryEntry> h, DateTime on) =>
        expectedVsActual(ItemTimeline(item(i, h), RateBook(const [])), on)!;

    /// The fund of AC-60/61: start 2026-01-01, 10,000 in, growth 12 %.
    Investment fund({
      Schedule check = Schedule.monthly,
      String growth = '0.12',
    }) => Investment(
      id: 'fund',
      name: 'fund',
      type: AssetType.fund,
      intent: Intent.trading,
      unit: egp,
      startDate: day(2026, 1, 1),
      zakatRule: ZakatRule.trading100,
      valueCheckSchedule: check,
      expectedGrowth: d(growth),
      createdAt: _epoch,
      updatedAt: _epoch,
    );

    MoneyIn fundIn() => mIn('fund', day(2026, 1, 1), '10000', egp);

    /// Cash deposit of AC-58: start 2026-01-01, 10,000, 10 %, monthly.
    Investment deposit(AccountKind kind) => Investment(
      id: 'dep',
      name: 'dep',
      type: AssetType.cashDeposit,
      unit: egp,
      startDate: day(2026, 1, 1),
      zakatRule: ZakatRule.cash100,
      payoutSchedule: Schedule.monthly,
      expectedProfit: d('0.10'),
      accountKind: kind,
      createdAt: _epoch,
      updatedAt: _epoch,
    );

    List<DateTime> dates(List<PlanRow> rows) => [for (final r in rows) r.date];

    void expectRows(List<PlanRow> rows, List<String?> expected) {
      expect(rows.length, expected.length);
      for (var i = 0; i < rows.length; i++) {
        if (expected[i] == null) {
          expect(rows[i].expected, isNull, reason: 'row $i');
        } else {
          expectDec(rows[i].expected, expected[i]!, what: 'row $i');
        }
      }
    }

    test('AC-68 income keeps the value at 100,000 (gain 5,000, ROI 5 %); income 150,000 asks nothing; a sale of 30,000 leaves 70,000', () {
      final history = <HistoryEntry>[
        mIn('fp', day(2026, 1, 15), '100000', egp),
        mOut('fp', day(2026, 4, 15), '5000', egp, MoneyOutKind.income),
      ];
      final tl = ItemTimeline(item(friend(), history), RateBook(const []));
      expectDec(tl.recordedValueAt(day(2026, 4, 15)), '100000.00');
      expectDec(tl.netValueAt(day(2026, 4, 15)), '100000.00');
      final s = calc([
        item(friend(), history),
      ], today: day(2026, 4, 20)).sinceStart('fp');
      expectDec(s.gain, '5000.00');
      expectPct(s.simpleRoi, '5.00');

      final more = [
        ...history,
        mOut('fp', day(2026, 5, 1), '150000', egp, MoneyOutKind.income),
      ];
      final tl2 = ItemTimeline(item(friend(), more), RateBook(const []));
      expectDec(tl2.recordedValueAt(day(2026, 5, 1)), '100000.00');
      expect(tl2.closedAt(day(2026, 5, 1)), isFalse);

      final sold = [
        ...more,
        mOut('fp', day(2026, 6, 1), '30000', egp, MoneyOutKind.sale),
      ];
      final tl3 = ItemTimeline(item(friend(), sold), RateBook(const []));
      expectDec(tl3.recordedValueAt(day(2026, 6, 1)), '70000.00');

      final f = fund(check: Schedule.yearly);
      final ac60 = [
        fundIn(),
        mIn('fund', day(2026, 4, 1), '2000', egp),
        val('fund', day(2026, 7, 1), '12400'),
      ];
      final withIncome = [
        ...ac60,
        mOut('fund', day(2026, 5, 1), '500', egp, MoneyOutKind.income),
      ];
      expectDec(
        planOf(f, ac60, day(2026, 7, 1)).expectedValueAt(day(2026, 7, 1)),
        '12635.39',
      );
      expectDec(
        planOf(f, withIncome, day(2026, 7, 1)).expectedValueAt(day(2026, 7, 1)),
        '12635.39',
      );
    });
    test('AC-46 private equity asks no market, intent only trading or long-term, quantity optional; no intent is named', () {
      InvestmentDraft draft({Intent? intent, ZakatRule? rule}) =>
          InvestmentDraft(
            name: "Friend's project",
            type: AssetType.privateEquity,
            intent: intent,
            unit: egp,
            startDate: day(2026, 1, 15),
            firstPaid: Money(d('100000'), egp),
            zakatRule: rule,
            capitalBack: CapitalBack.no,
          );
      expect(validate(draft(), today: today, settings: settings()), [
        DraftError.missingIntent,
      ]);
      for (final bad in [Intent.personalUse, Intent.rental]) {
        expect(
          validate(
            draft(intent: bad),
            today: today,
            settings: settings(),
          ),
          [DraftError.missingIntent],
        );
      }
      expect(
        validate(
          draft(intent: Intent.trading),
          today: today,
          settings: settings(),
        ),
        isEmpty,
        reason: 'no market, no quantity needed',
      );
      final other = inv(
        'o',
        type: AssetType.other,
        intent: Intent.longTerm,
        unit: egp,
        start: day(2026, 1, 1),
        share: '0.4',
      );
      expect(other.peCase, isNull);
      expectDec(resolve(other, settings()).share, '0.40');
      expect(resolve(other, settings()).sourceSection, 'A9');
    });

    test('AC-47 trading is 100 % with no method; long-term must pick (no 25 %); profit received only = 0.025 × 15,000 = 375.00', () {
      expect(
        defaultRule(AssetType.privateEquity, Intent.trading, settings()),
        ZakatRule.trading100,
      );
      expectDec(
        resolve(friend(rule: ZakatRule.trading100), settings()).share,
        '1.00',
      );
      expect(
        defaultRule(AssetType.privateEquity, Intent.longTerm, settings()),
        isNull,
      );
      final i = friend(rule: ZakatRule.longTermDividendsOnly);
      final r = resolve(i, settings());
      expectDec(r.share, '0');
      expect(r.notice, ZakatNotice.profitPayoutsOnly);
      final agg = item(i, [
        fpIn(),
        fpIncome(day(2026, 4, 20), '5000'),
        fpIncome(day(2026, 7, 14), '5000'),
        fpIncome(day(2026, 10, 15), '5000'),
      ]);
      final on = day(2026, 10, 17);
      final y = calc([agg], today: on).item('fp', Period.year(2026, on));
      expectDec(y.setAside, '375.00');
      expectDec(y.base!.dividends, '15000.00');
      expectDec(
        y.setAside - ZakatYear.lunar.r * y.base!.dividends,
        '0',
        what: 'set-aside on the value',
      );
    });

    test('AC-48 no plan on metals/crypto, rule checks, V_exp at −10 % = 9,000.00, no plan → no expected figure', () {
      InvestmentDraft d0(
        AssetType t, {
        Schedule? payout,
        String? profit,
        Schedule? check,
        String? growth,
      }) => InvestmentDraft(
        name: 'x',
        type: t,
        intent: Intent.trading,
        market: Market.egx,
        unit: egp,
        startDate: day(2026, 1, 1),
        firstPaid: Money(d('10000'), egp),
        zakatRule: ZakatRule.trading100,
        payoutSchedule: payout,
        expectedProfit: profit == null ? null : d(profit),
        valueCheckSchedule: check,
        expectedGrowth: growth == null ? null : d(growth),
      );
      List<DraftError> v(InvestmentDraft x) =>
          validate(x, today: today, settings: settings());
      for (final t in [AssetType.gold, AssetType.silver, AssetType.crypto]) {
        expect(
          v(d0(t, payout: Schedule.monthly)),
          contains(DraftError.planNotForType),
        );
      }
      for (final t in [AssetType.gold, AssetType.silver]) {
        expect(
          v(d0(t, check: Schedule.monthly)),
          contains(DraftError.planNotForType),
        );
      }
      expect(v(d0(AssetType.fund, profit: '0.1')), [
        DraftError.profitNeedsSchedule,
      ]);
      expect(v(d0(AssetType.fund, growth: '0.1')), [
        DraftError.growthNeedsSchedule,
      ]);
      expect(v(d0(AssetType.fund, payout: Schedule.monthly, profit: '0')), [
        DraftError.profitNotPositive,
      ]);
      expect(v(d0(AssetType.fund, check: Schedule.yearly, growth: '-1')), [
        DraftError.growthTooLow,
      ]);
      expect(
        v(d0(AssetType.fund, check: Schedule.yearly, growth: '-0.10')),
        isEmpty,
      );
      final p = planOf(fund(check: Schedule.yearly, growth: '-0.10'), [
        fundIn(),
      ], day(2027, 1, 1));
      expectDec(p.expectedValueAt(day(2027, 1, 1)), '9000.00');
      expectDec(p.valueRows.single.expected, '9000.00');
      final stock = inv(
        's',
        type: AssetType.stock,
        intent: Intent.trading,
        market: Market.egx,
        unit: egp,
        start: day(2026, 1, 1),
        rule: ZakatRule.trading100,
      );
      expect(v(d0(AssetType.stock)), isEmpty);
      expect(
        expectedVsActual(
          ItemTimeline(
            item(stock, [mIn('s', day(2026, 1, 1), '100', egp)]),
            RateBook(const []),
          ),
          today,
        ),
        isNull,
      );
    });

    test('AC-49 5,000.00 every 3 months on 2026-04-15, 07-15, 10-15, 2027-01-15; a 10 % monthly fund pays 83.33', () {
      final p = planOf(friend(), [fpIn()], day(2027, 1, 20));
      expect(dates(p.payoutRows), [
        day(2026, 4, 15),
        day(2026, 7, 15),
        day(2026, 10, 15),
        day(2027, 1, 15),
      ]);
      expectRows(p.payoutRows, ['5000.00', '5000.00', '5000.00', '5000.00']);
      final monthly = Investment(
        id: 'f',
        name: 'f',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        startDate: day(2026, 1, 1),
        zakatRule: ZakatRule.trading100,
        payoutSchedule: Schedule.monthly,
        expectedProfit: d('0.10'),
      );
      final m = planOf(monthly, [
        mIn('f', day(2026, 1, 1), '10000', egp),
      ], day(2026, 3, 2));
      expectRows(m.payoutRows, ['83.33', '83.33']);
    });

    test(
      'AC-50 rows fall on the last day of short months, counted from the start',
      () {
        Investment monthly(DateTime start, Schedule s) => Investment(
          id: 'm',
          name: 'm',
          type: AssetType.fund,
          intent: Intent.trading,
          unit: egp,
          startDate: start,
          zakatRule: ZakatRule.trading100,
          payoutSchedule: s,
        );
        final a = planOf(monthly(day(2026, 1, 31), Schedule.monthly), [
          mIn('m', day(2026, 1, 31), '100', egp),
        ], day(2026, 5, 15));
        expect(dates(a.payoutRows), [
          day(2026, 2, 28),
          day(2026, 3, 31),
          day(2026, 4, 30),
        ]);
        final b = planOf(monthly(day(2024, 2, 29), Schedule.yearly), [
          mIn('m', day(2024, 2, 29), '100', egp),
        ], day(2028, 3, 1));
        expect(dates(b.payoutRows), [
          day(2025, 2, 28),
          day(2026, 2, 28),
          day(2027, 2, 28),
          day(2028, 2, 29),
        ]);
      },
    );

    test('AC-51 on 2026-10-17: three pending rows of 5,000.00; April/July show the line, October from 10-23; 15,000 / 0 / −15,000; 3 to confirm', () {
      final h = [fpIn()];
      final p = planOf(friend(), h, day(2026, 10, 17));
      expect(dates(p.payoutRows), [
        day(2026, 4, 15),
        day(2026, 7, 15),
        day(2026, 10, 15),
      ]);
      expectRows(p.payoutRows, ['5000.00', '5000.00', '5000.00']);
      expect(p.payoutRows.every((r) => r.pending), isTrue);
      expect(
        [for (final r in p.payoutRows) r.noPayoutLine],
        [true, true, false],
      );
      expect(p.payoutRows[1].from, day(2026, 4, 16));
      expectDec(p.expectedSoFar, '15000.00');
      expectDec(p.received, '0.00');
      expectDec(p.difference, '-15000.00');
      expect(p.toConfirm, 3);
      expect(
        planOf(friend(), h, day(2026, 10, 22)).payoutRows[2].noPayoutLine,
        isFalse,
      );
      expect(
        planOf(friend(), h, day(2026, 10, 23)).payoutRows[2].noPayoutLine,
        isTrue,
      );
    });

    test('AC-52 confirm April, edit July to 4,000, skip October: 15,000 / 9,000 / −6,000; year 15,000 / 9,000; July 5,000 / 4,000; October 5,000 / 0', () {
      final on = day(2026, 10, 17);
      final h = <HistoryEntry>[
        fpIn(),
        fpIncome(day(2026, 4, 15), '5000.00'),
        fpIncome(day(2026, 7, 15), '4000'),
        skip('fp', day(2026, 10, 15), PlanKind.payout),
      ];
      final p = planOf(friend(), h, on);
      expect(
        [for (final r in p.payoutRows) r.state],
        [RowState.resolved, RowState.resolved, RowState.skipped],
      );
      expectDec(p.payoutRows[1].actualAmount, '4000.00');
      final oct = p.payoutRows[2];
      expect(oct.noPayoutLine, isTrue);
      expect((oct.from, oct.date), (day(2026, 7, 16), day(2026, 10, 15)));
      expectDec(p.expectedSoFar, '15000.00');
      expectDec(p.received, '9000.00');
      expectDec(p.difference, '-6000.00');
      final year = p.payoutsIn(Period.year(2026, on));
      expectDec(year.expected, '15000.00');
      expectDec(year.received, '9000.00');
      final july = p.payoutsIn(Period.month(2026, 7, on));
      expectDec(july.expected, '5000.00');
      expectDec(july.received, '4000.00');
      final october = p.payoutsIn(Period.month(2026, 10, on));
      expectDec(october.expected, '5000.00');
      expectDec(october.received, '0.00');
      expect(p.hasPending, isFalse);
      expect(p.toConfirm, 0);
    });

    test('AC-53 confirm all: three income records of 5,000 on the row dates; received 15,000, difference 0, nothing pending', () {
      final on = day(2026, 10, 17);
      final before = planOf(friend(), [fpIn()], on);
      final written = [
        for (final r in before.pendingRows)
          if (r.expected != null) fpIncome(r.date, r.expected.toString()),
      ];
      expect(
        [for (final w in written) w.date],
        [day(2026, 4, 15), day(2026, 7, 15), day(2026, 10, 15)],
      );
      expect(written.every((w) => w.amount.amount == d('5000')), isTrue);
      final p = planOf(friend(), [fpIn(), ...written], on);
      expectDec(p.received, '15000.00');
      expectDec(p.difference, '0.00');
      expect(p.hasPending, isFalse);
    });

    test('AC-54 hand-entered income within 7 days resolves its row; 2,000 on 05-30 is taken by none (17,000, +2,000)', () {
      final on = day(2026, 10, 17);
      final h = [
        fpIn(),
        fpIncome(day(2026, 4, 20), '5000'),
        fpIncome(day(2026, 7, 14), '10000'),
      ];
      final p = planOf(friend(), h, on);
      expectDec(p.payoutRows[0].actualAmount, '5000.00');
      expectDec(p.payoutRows[1].actualAmount, '10000.00');
      expect([for (final r in p.payoutRows) r.pending], [false, false, true]);
      expectDec(p.expectedSoFar, '15000.00');
      expectDec(p.received, '15000.00');
      expectDec(p.difference, '0.00');
      final q = planOf(friend(), [
        ...h,
        fpIncome(day(2026, 5, 30), '2000'),
      ], on);
      expect(
        q.payoutRows.where((r) => r.actual?.date == day(2026, 5, 30)),
        isEmpty,
      );
      expectDec(q.received, '17000.00');
      expectDec(q.difference, '2000.00');
    });

    test('AC-55 money in and sales count from the next period: 5,000 / 6,000 / 3,500', () {
      final p = planOf(friend(), [
        fpIn(),
        mIn('fp', day(2026, 8, 1), '20000', egp),
        mOut('fp', day(2026, 11, 1), '50000', egp, MoneyOutKind.sale),
      ], day(2027, 4, 20));
      expect(dates(p.payoutRows).sublist(2), [
        day(2026, 10, 15),
        day(2027, 1, 15),
        day(2027, 4, 15),
      ]);
      expectRows(p.payoutRows.sublist(2), ['5000.00', '6000.00', '3500.00']);
    });

    test('AC-56 after a full sale: no row after the closing date, old rows still open, not counted on Home', () {
      final p = planOf(friend(), [
        fpIn(),
        mOut('fp', day(2026, 12, 1), '100000', egp, MoneyOutKind.sale),
        val('fp', day(2026, 12, 1), '0'),
      ], day(2027, 2, 1));
      expect(dates(p.payoutRows), [
        day(2026, 4, 15),
        day(2026, 7, 15),
        day(2026, 10, 15),
      ]);
      expect(p.payoutRows.every((r) => r.pending), isTrue);
      expect(p.toConfirm, 0);
      final confirmed = planOf(friend(), [
        fpIn(),
        mOut('fp', day(2026, 12, 1), '100000', egp, MoneyOutKind.sale),
        val('fp', day(2026, 12, 1), '0'),
        fpIncome(day(2026, 4, 15), '5000'),
      ], day(2027, 2, 1));
      expect(confirmed.payoutRows.first.state, RowState.resolved);
      expectDec(confirmed.timeline.netValueAt(day(2027, 2, 1)), '0');
    });

    Investment noPct() => Investment(
      id: 'np',
      name: 'np',
      type: AssetType.fund,
      intent: Intent.trading,
      unit: egp,
      startDate: day(2026, 1, 31),
      zakatRule: ZakatRule.trading100,
      payoutSchedule: Schedule.monthly,
      createdAt: _epoch,
      updatedAt: _epoch,
    );
    List<HistoryEntry> noPctHistory() => [
      mIn('np', day(2026, 1, 31), '50000', egp),
      mOut('np', day(2026, 3, 5), '1200', egp, MoneyOutKind.income),
      mOut('np', day(2026, 4, 2), '900', egp, MoneyOutKind.income),
    ];

    test('AC-57 no %: two rows received 1,200 / 900, the April row pending with no amount; the line from 05-10; received 2,100, no expected', () {
      final p = planOf(noPct(), noPctHistory(), day(2026, 5, 7));
      expectDec(p.payoutRows[0].actualAmount, '1200.00');
      expectDec(p.payoutRows[1].actualAmount, '900.00');
      final april = p.payoutRows[2];
      expect(april.date, day(2026, 4, 30));
      expect(april.pending, isTrue);
      expect(april.expected, isNull);
      expect(april.noPayoutLine, isFalse);
      expect(
        planOf(
          noPct(),
          noPctHistory(),
          day(2026, 5, 10),
        ).payoutRows[2].noPayoutLine,
        isTrue,
      );
      expectDec(p.received, '2100.00');
      expect(p.expectedSoFar, isNull);
      expect(p.difference, isNull);
    });

    test('AC-73 adding 950 to the April row: received 3,050.00, the row is received', () {
      final p = planOf(noPct(), [
        ...noPctHistory(),
        mOut('np', day(2026, 4, 30), '950', egp, MoneyOutKind.income),
      ], day(2026, 5, 10));
      expect(p.payoutRows[2].state, RowState.resolved);
      expectDec(p.payoutRows[2].actualAmount, '950.00');
      expectDec(p.received, '3050.00');
    });

    test('AC-58 Islamic deposit: interest does not resolve the 83.33 row; it shows the line; received 0.00', () {
      final p = planOf(deposit(AccountKind.islamic), [
        mIn('dep', day(2026, 1, 1), '10000', egp),
        interest('dep', day(2026, 2, 1), '83.33', egp, InterestKind.paidOut),
      ], day(2026, 2, 9));
      final row = p.payoutRows.single;
      expect(row.date, day(2026, 2, 1));
      expectDec(row.expected, '83.33');
      expect(row.pending, isTrue);
      expect(row.noPayoutLine, isTrue);
      expectDec(p.received, '0.00');
    });

    test('AC-58b conventional deposit: the check mark is interest paid out (to purify 83.33), value 10,000.00, February 0.00 %; a hand interest record resolves it, income does not', () {
      final dep = deposit(AccountKind.conventional);
      final start = mIn('dep', day(2026, 1, 1), '10000', egp);
      final p = planOf(dep, [start], day(2026, 2, 9));
      expectDec(p.payoutRows.single.expected, '83.33');
      final confirmed = interest(
        'dep',
        day(2026, 2, 1),
        p.payoutRows.single.expected.toString(),
        egp,
        InterestKind.paidOut,
      );
      final h = [start, confirmed];
      final after = planOf(dep, h, day(2026, 2, 9));
      expect(after.payoutRows.single.state, RowState.resolved);
      final tl = ItemTimeline(item(dep, h), RateBook(const []));
      expectDec(tl.toPurifyAt(day(2026, 2, 9)).amount, '83.33');
      expectDec(tl.recordedValueAt(day(2026, 2, 9)), '10000.00');
      expect(tl.incomeFlows(day(2025, 12, 31), day(2026, 12, 31)), isEmpty);
      final feb = day(2026, 2, 28);
      expectPct(
        calc([
          item(dep, h),
        ], today: feb).item('dep', Period.month(2026, 2, feb)).dietz.r,
        '0.00',
      );
      final byHand = planOf(dep, [
        start,
        interest('dep', day(2026, 2, 3), '83.33', egp, InterestKind.paidOut),
      ], day(2026, 2, 9));
      expect(byHand.payoutRows.single.state, RowState.resolved);
      final income = planOf(dep, [
        start,
        mOut('dep', day(2026, 2, 3), '83.33', egp, MoneyOutKind.income),
      ], day(2026, 2, 9));
      expect(income.payoutRows.single.pending, isTrue);
    });

    test('AC-59 a new % moves pending rows to 6,000.00; April stays 5,000.00; 18,000 expected, 5,000 received', () {
      final p = planOf(friend(profit: '0.24'), [
        fpIn(),
        fpIncome(day(2026, 4, 15), '5000'),
      ], day(2026, 10, 17));
      expectRows(p.payoutRows, ['6000.00', '6000.00', '6000.00']);
      expectDec(p.payoutRows[0].actualAmount, '5000.00');
      expect([for (final r in p.payoutRows) r.pending], [false, true, true]);
      expectDec(p.expectedSoFar, '18000.00');
      expectDec(p.received, '5000.00');
    });

    test('AC-60 V_exp 11,200.00; at the 07-01 update 12,635.39, −235.39 (−1.86 %), below; at 09-28 9,948.16, +151.84 (+1.53 %)', () {
      final f = fund(check: Schedule.yearly);
      expectDec(
        planOf(f, [fundIn()], day(2027, 1, 1)).expectedValueAt(day(2027, 1, 1)),
        '11200.00',
      );
      final h = [
        fundIn(),
        mIn('fund', day(2026, 4, 1), '2000', egp),
        val('fund', day(2026, 7, 1), '12400'),
        mOut('fund', day(2026, 8, 15), '3000', egp, MoneyOutKind.sale),
        val('fund', day(2026, 9, 28), '10100'),
      ];
      final p = planOf(f, h, day(2026, 10, 1));
      final first = p.valueChecks[0];
      expect(first.date, day(2026, 7, 1));
      expectDec(first.actualNet, '12400.00');
      expectDec(first.expected, '12635.39');
      expectDec(first.diff, '-235.39');
      expectPct(first.diffPct, '-1.86');
      expect(first.below, isTrue);
      final second = p.valueChecks[1];
      expectDec(second.actualNet, '10100.00');
      expectDec(second.expected, '9948.16');
      expectDec(second.diff, '151.84');
      expectPct(second.diffPct, '1.53');
      expect(second.below, isFalse);
    });

    test('AC-61 value rows 10,096.72 and 10,184.88; confirming February keeps March; March edited to 9,800: −384.88 (−3.78 %); a hand update on 02-05 resolves February', () {
      final on = day(2026, 3, 5);
      final p = planOf(fund(), [fundIn()], on);
      expect(dates(p.valueRows), [day(2026, 2, 1), day(2026, 3, 1)]);
      expectRows(p.valueRows, ['10096.72', '10184.88']);
      final feb = val(
        'fund',
        day(2026, 2, 1),
        p.valueRows[0].expected.toString(),
      );
      final q = planOf(fund(), [fundIn(), feb], on);
      expect(q.valueRows[0].state, RowState.resolved);
      expectDec(q.valueRows[0].actualAmount, '10096.72');
      expect(q.valueRows[1].pending, isTrue);
      expectDec(q.valueRows[1].expected, '10184.88');
      final r = planOf(fund(), [
        fundIn(),
        feb,
        val('fund', day(2026, 3, 1), '9800'),
      ], on);
      expect(r.hasPending, isFalse);
      final march = r.valueChecks.last;
      expectDec(march.actualNet, '9800.00');
      expectDec(march.diff, '-384.88');
      expectPct(march.diffPct, '-3.78');
      final byHand = planOf(fund(), [
        fundIn(),
        val('fund', day(2026, 2, 5), '10050'),
      ], on);
      expect(byHand.valueRows[0].state, RowState.resolved);
      expect(byHand.valueRows[0].actual!.date, day(2026, 2, 5));
      expect(byHand.valueRows[1].pending, isTrue);
    });

    test('AC-62 the chart data: V_exp through the rows, hollow points at 10,096.72 and 10,184.88; income steps 5,000 / 10,000 / 15,000 vs 5,000 / 9,000', () {
      final p = planOf(fund(), [fundIn()], day(2026, 3, 5));
      expectDec(p.expectedValueAt(day(2026, 1, 1)), '10000.00');
      expectDec(p.expectedValueAt(day(2026, 2, 1)), '10096.72');
      expectDec(p.expectedValueAt(day(2026, 3, 1)), '10184.88');
      expect(p.valueRows.every((r) => r.pending), isTrue);
      final ac52 = planOf(friend(), [
        fpIn(),
        fpIncome(day(2026, 4, 15), '5000'),
        fpIncome(day(2026, 7, 15), '4000'),
        skip('fp', day(2026, 10, 15), PlanKind.payout),
      ], day(2026, 10, 17));
      var cumulative = Decimal.zero;
      final expectedSteps = [
        for (final r in ac52.payoutRows) cumulative += r.expected!,
      ];
      expect(expectedSteps, [d('5000'), d('10000'), d('15000')]);
      cumulative = Decimal.zero;
      final actualSteps = [
        for (final x in ac52.receivedRecords)
          (x.date, cumulative += ac52.timeline.inItemUnit(x)!),
      ];
      expect(actualSteps, [
        (day(2026, 4, 15), d('5000')),
        (day(2026, 7, 15), d('9000')),
      ]);
    });

    test('AC-63 a plan changes no actual figure: every return, gain, set-aside, real, purchasing power, totals, stale marker', () {
      final on = day(2026, 10, 17);
      final cpi = {
        egy: {2025: '0.30', 2026: '0.10'},
      };
      List<Object?> returns(Returns? r) => [
        r?.dietz.bv,
        r?.dietz.ev,
        r?.dietz.cf,
        r?.dietz.d,
        r?.dietz.r,
        r?.z,
        r?.dividends,
        r?.rz,
        r?.i,
        r?.real,
        r?.realAfterZakat,
        r?.pp?.gap,
        r?.pp?.neededEnd,
        r?.pp?.neededReturn,
        r?.pp?.kept,
      ];
      List<Object?> all(Investment i) {
        final c = calc(
          [
            item(i, [
              fpIn(),
              fpIncome(day(2026, 4, 20), '5000'),
              val('fp', day(2026, 6, 30), '101000'),
            ]),
          ],
          today: on,
          cpi: cpi,
        );
        final s = c.sinceStart('fp');
        return [
          s.days,
          s.gain,
          s.gainBase,
          s.simpleRoi,
          s.simpleRoiBase,
          s.sinceStartReturn,
          s.annualised,
          s.annualisedBase,
          c.staleNow().itemIds,
          ...returns(s.figures.base),
          ...returns(s.figures.itemUnit),
          for (final p in [
            Period.year(2026, on),
            Period.month(2026, 4, on),
            Period.month(2026, 10, on),
          ]) ...[
            ...returns(c.item('fp', p).base),
            ...returns(c.item('fp', p).itemUnit),
            c.item('fp', p).staleValue,
            c.item('fp', p).toPurify.amount,
            c.item('fp', p).closed,
            ...returns(c.portfolio(p, ViewUnit.base).totals),
            c.portfolio(p, ViewUnit.base).staleValues,
            c.portfolio(p, ViewUnit.base).toPurify.amount,
          ],
        ];
      }

      final withPlan = all(friend());
      final noPlan = all(friend(profit: null, payout: null));
      expect(withPlan.length, noPlan.length);
      for (var i = 0; i < withPlan.length; i++) {
        expect(withPlan[i], noPlan[i], reason: 'figure $i');
      }
      expect(withPlan.whereType<Decimal>().length, greaterThan(40));
    });

    test('AC-64 cases follow Q2 first, Q1 only with a %', () {
      expect(friend(profit: null, q2: CapitalBack.no).peCase, PeCase.a);
      expect(friend(profit: null, q2: CapitalBack.yes).peCase, PeCase.c);
      expect(
        friend(profit: null, q2: CapitalBack.notSure).peCase,
        PeCase.notSure,
      );
      expect(friend(q1: ProfitBasis.shareOfProfit).peCase, PeCase.a);
      expect(friend(q1: ProfitBasis.fixedPctOfMoney).peCase, PeCase.b);
      expect(
        friend(q1: ProfitBasis.notSure, q2: CapitalBack.yes).peCase,
        PeCase.c,
      );
      expect(friend(q1: ProfitBasis.notSure).peCase, PeCase.notSure);
      expect(
        friend(q1: ProfitBasis.fixedPctOfMoney, q2: CapitalBack.notSure).peCase,
        PeCase.notSure,
      );
      InvestmentDraft draft({
        String? profit,
        ProfitBasis? q1,
        CapitalBack? q2,
      }) => InvestmentDraft(
        name: 'x',
        type: AssetType.privateEquity,
        intent: Intent.trading,
        unit: egp,
        startDate: day(2026, 1, 15),
        firstPaid: Money(d('100000'), egp),
        payoutSchedule: profit == null ? null : Schedule.quarterly,
        expectedProfit: profit == null ? null : d(profit),
        profitBasis: q1,
        capitalBack: q2,
      );
      List<DraftError> v(InvestmentDraft x) =>
          validate(x, today: today, settings: settings());
      expect(v(draft()), [DraftError.answerCapitalBack]);
      expect(v(draft(q2: CapitalBack.notSure)), isEmpty);
      expect(v(draft(profit: '0.2', q2: CapitalBack.no)), [
        DraftError.answerProfitBasis,
      ]);
      expect(
        v(draft(profit: '0.2', q1: ProfitBasis.notSure, q2: CapitalBack.no)),
        isEmpty,
      );
    });

    List<HistoryEntry> twoPayouts() => [
      fpIn(),
      fpIncome(day(2026, 4, 15), '5000'),
      fpIncome(day(2026, 7, 15), '5000'),
    ];

    test('AC-65 case A: gain 10,000.00, ROI 10.00 %, to purify 0.00; case C: gain 0.00, ROI 0.00 %, to purify 10,000.00, rows still received, zakat 100 %', () {
      final on = day(2026, 10, 17);
      final a = calc([
        item(friend(), twoPayouts()),
      ], today: on).sinceStart('fp');
      expectDec(a.gain, '10000.00');
      expectPct(a.simpleRoi, '10.00');
      expectDec(a.figures.toPurify.amount, '0.00');
      final caseC = friend(q2: CapitalBack.yes);
      final c = calc([item(caseC, twoPayouts())], today: on).sinceStart('fp');
      expectDec(c.gain, '0.00');
      expectPct(c.simpleRoi, '0.00');
      expectDec(c.figures.toPurify.amount, '10000.00');
      final p = planOf(caseC, twoPayouts(), on);
      expect(
        [for (final r in p.payoutRows.take(2)) r.state],
        [RowState.resolved, RowState.resolved],
      );
      expectDec(p.received, '10000.00');
      final z = resolve(caseC, settings());
      expectDec(z.share, '1.00');
      expect(z.notice, ZakatNotice.capitalBackIsDebt);
    });

    test('AC-66 case B: gain 10,000.00 and the Shariah risk tag; share of profit removes it; not sure or case C has none', () {
      final b = friend(q1: ProfitBasis.fixedPctOfMoney);
      final s = calc([
        item(b, twoPayouts()),
      ], today: day(2026, 10, 17)).sinceStart('fp');
      expectDec(s.gain, '10000.00');
      expect(b.peCase, PeCase.b);
      expect(b.shariahRisk, isTrue);
      expect(friend(q1: ProfitBasis.shareOfProfit).shariahRisk, isFalse);
      expect(friend(q1: ProfitBasis.notSure).shariahRisk, isFalse);
      expect(
        friend(
          q1: ProfitBasis.fixedPctOfMoney,
          q2: CapitalBack.yes,
        ).shariahRisk,
        isFalse,
      );
    });

    test('AC-69 a record dated d ± 7 resolves the row; d ± 8 does not', () {
      for (final ok in [day(2026, 4, 22), day(2026, 4, 8)]) {
        final p = planOf(friend(), [
          fpIn(),
          fpIncome(ok, '5000'),
        ], day(2026, 10, 17));
        expect(p.payoutRows.first.state, RowState.resolved, reason: '$ok');
      }
      for (final no in [day(2026, 4, 23), day(2026, 4, 7)]) {
        final p = planOf(friend(), [
          fpIn(),
          fpIncome(no, '5000'),
        ], day(2026, 10, 17));
        expect(p.payoutRows.first.pending, isTrue, reason: '$no');
      }
    });

    test('AC-70 a cash deposit with a payout schedule must name the account kind; without a schedule it is not asked', () {
      InvestmentDraft dep({Schedule? payout, AccountKind? kind}) =>
          InvestmentDraft(
            name: 'dep',
            type: AssetType.cashDeposit,
            unit: egp,
            startDate: day(2026, 1, 1),
            firstPaid: Money(d('10000'), egp),
            payoutSchedule: payout,
            accountKind: kind,
          );
      List<DraftError> v(InvestmentDraft x) =>
          validate(x, today: today, settings: settings());
      expect(v(dep(payout: Schedule.monthly)), [DraftError.answerAccountKind]);
      expect(
        v(dep(payout: Schedule.monthly, kind: AccountKind.conventional)),
        isEmpty,
      );
      expect(v(dep()), isEmpty);
    });

    test('AC-71 case C give-away of 4,000 from payouts: to purify 6,000.00, gain stays 0.00, set-aside unchanged', () {
      final caseC = friend(q2: CapitalBack.yes);
      final on = day(2026, 10, 17);
      final given = [
        ...twoPayouts(),
        interest(
          'fp',
          day(2026, 8, 1),
          '4000',
          egp,
          InterestKind.givenAwayFromPaidOut,
        ),
      ];
      final before = calc([item(caseC, twoPayouts())], today: on);
      final after = calc([item(caseC, given)], today: on);
      final s = after.sinceStart('fp');
      expectDec(after.timeline('fp').toPurifyAt(on).amount, '6000.00');
      expectDec(s.gain, '0.00');
      final year = Period.year(2026, on);
      expectDec(
        after.item('fp', year).setAside,
        before.item('fp', year).setAside.toString(),
      );
    });

    test('AC-72 undo removes what was written: the rows are pending again', () {
      final on = day(2026, 10, 17);
      final p = planOf(friend(), [fpIn()], on);
      expectDec(p.received, '0.00');
      expect(p.toConfirm, 3);
      final skipped = planOf(friend(), [
        fpIn(),
        skip('fp', day(2026, 10, 15), PlanKind.payout),
      ], on);
      expect(skipped.payoutRows.last.state, RowState.skipped);
      expect(skipped.toConfirm, 2);
    });

    test('AC-75 Home counts 5 to confirm (3 + 2); after confirm all on the project, 2', () {
      // AC-61's fund seen on the same day as AC-51: its two monthly rows are
      // placed so both fall on or before 2026-10-17.
      final on = day(2026, 10, 17);
      final f = Investment(
        id: 'fund',
        name: 'fund',
        type: AssetType.fund,
        intent: Intent.trading,
        unit: egp,
        startDate: day(2026, 8, 17),
        zakatRule: ZakatRule.trading100,
        valueCheckSchedule: Schedule.monthly,
        expectedGrowth: d('0.12'),
      );
      final fundOn = planOf(f, [
        mIn('fund', day(2026, 8, 17), '10000', egp),
      ], on);
      final fp = planOf(friend(), [fpIn()], on);
      expect(fundOn.toConfirm, 2);
      expect(fp.toConfirm + fundOn.toConfirm, 5);
      final confirmed = planOf(friend(), [
        fpIn(),
        for (final r in fp.pendingRows) fpIncome(r.date, r.expected.toString()),
      ], on);
      expect(confirmed.toConfirm + fundOn.toConfirm, 2);
    });
  });
}
