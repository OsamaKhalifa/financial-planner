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
}
