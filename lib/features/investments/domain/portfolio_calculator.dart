/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/inflation.dart';
import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/dates.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/money/money.dart';
import '../../../core/reference/countries.dart';
import '../../../core/reference/units.dart';
import 'formulas.dart';
import 'investment.dart';
import 'item_timeline.dart';
import 'period.dart';
import 'zakat_rules.dart';

enum ViewUnit { base, goldGrams, silverGrams }

/// The item is left out of base totals: [from]→[to] has no rate on [date]
/// (AC-21).
final class Excluded {
  const Excluded(this.itemId, this.from, this.to, this.date);

  final String itemId;
  final Unit from;
  final Unit to;
  final DateTime date;
}

/// The closing rate is dated before the period (AC-22).
final class StaleRate {
  const StaleRate(this.from, this.to, this.asOf);

  final Unit from;
  final Unit to;
  final DateTime asOf;
}

/// Every figure of one unit and one period, with its inputs kept for the
/// "why" sheet.
final class Returns {
  const Returns({
    required this.dietz,
    required this.z,
    required this.rz,
    required this.i,
    required this.real,
    required this.realAfterZakat,
    required this.pp,
    required this.inflation,
  });

  final DietzResult dietz;

  /// Estimated zakat set-aside (planning), in the same unit as [dietz].
  final Decimal z;
  final Decimal? rz;

  /// Null when the inflation series is empty, and in the grams view's real
  /// figures.
  final Decimal? i;
  final Decimal? real;
  final Decimal? realAfterZakat;
  final PurchasingPower? pp;
  final PeriodInflation? inflation;

  bool get notAvailable => dietz.r == null;
}

final class ItemFigures {
  const ItemFigures({
    required this.id,
    required this.period,
    required this.held,
    required this.closed,
    required this.zakat,
    required this.inflationCountry,
    required this.homeCountry,
    required this.toPurify,
    required this.staleValue,
    this.itemUnit,
    this.base,
    this.excluded,
    this.staleRate,
  });

  final String id;
  final Period period;

  /// False when the item was not yet started or was already closed.
  final bool held;
  final bool closed;
  final ResolvedZakat zakat;

  /// Series of the item's own-market real return (AC-31).
  final Country inflationCountry;
  final Country homeCountry;
  final Money toPurify;
  final bool staleValue;

  /// In the item unit, with the item's own inflation series.
  final Returns? itemUnit;

  /// In the base currency, with home inflation. Null when [excluded].
  final Returns? base;
  final Excluded? excluded;
  final StaleRate? staleRate;
}

final class PortfolioFigures {
  const PortfolioFigures({
    required this.period,
    required this.view,
    required this.unit,
    required this.items,
    required this.excluded,
    required this.staleValues,
    required this.staleRates,
    required this.toPurify,
    required this.homeCountry,
    this.totals,
    this.unavailable,
  });

  final Period period;
  final ViewUnit view;
  final Unit unit;
  final List<ItemFigures> items;
  final List<Excluded> excluded;
  final List<String> staleValues;
  final List<StaleRate> staleRates;

  /// Total to purify, always in the base currency.
  final Money toPurify;
  final Country homeCountry;

  /// Null in the grams view when a metal rate is missing ([unavailable]).
  final Returns? totals;
  final MissingRate? unavailable;

  /// The grams view is labelled "gold is a yardstick, not a price index".
  bool get showYardstickLabel => view != ViewUnit.base;
}

final class SinceStartFigures {
  const SinceStartFigures({
    required this.figures,
    required this.days,
    required this.gain,
    required this.gainBase,
    required this.simpleRoi,
    required this.simpleRoiBase,
    required this.sinceStartReturn,
    required this.annualised,
    required this.annualisedBase,
  });

  /// Story §9.2: the period formulas with S = start date, E = latest value date.
  final ItemFigures figures;
  final int days;
  final Decimal gain;
  final Decimal? gainBase;
  final Decimal? simpleRoi;
  final Decimal? simpleRoiBase;
  final Decimal? sinceStartReturn;

  /// Null when the item was held for less than 365 days.
  final Decimal? annualised;
  final Decimal? annualisedBase;
}

final class NisabHint {
  const NisabHint({
    required this.goldNisab,
    required this.silverNisab,
    required this.zakatableTotal,
  });

  /// Null when there is no rate for the metal: "Add a gold rate to see the
  /// nisab".
  final Money? goldNisab;
  final Money? silverNisab;
  final Money zakatableTotal;
}

final class StaleNow {
  const StaleNow({required this.itemIds, required this.ratePairs});

  final List<String> itemIds;
  final List<UnitPair> ratePairs;
}

final class PortfolioCalculator {
  PortfolioCalculator({
    required List<InvestmentWithHistory> items,
    required this.rates,
    required this.inflation,
    required this.settings,
    required this.noZakatYears,
    required this.today,
  }) : _items = items,
       _base = settings.baseCurrency!,
       _year =
           settings.zakatYear ??
           (throw StateError('The zakat year must be answered first.')),
       _home = settings.homeCountry!,
       _timelines = {
         for (final h in items) h.investment.id: ItemTimeline(h, rates),
       };

  final RateBook rates;
  final InflationBook inflation;
  final Settings settings;
  final Set<int> noZakatYears;
  final DateTime today;

  final List<InvestmentWithHistory> _items;
  final Unit _base;
  final ZakatYear _year;
  final Country _home;
  final Map<String, ItemTimeline> _timelines;

  ItemTimeline timeline(String id) => _timelines[id]!;

  /// Item's own series: override → market country → home (metals) → country
  /// of its unit (AC-31).
  Country seriesOf(String id) {
    final inv = timeline(id).investment;
    if (inv.inflationOverride != null) return inv.inflationOverride!;
    final market = inv.marketCountryResolved;
    final marketTyped =
        inv.type == AssetType.stock ||
        inv.type == AssetType.fund ||
        inv.type == AssetType.sukuk;
    if (marketTyped && market != null) return market;
    return inv.unit.isMetal ? _home : defaultCountryOf(inv.unit);
  }

  Map<Unit, int> unitUsage() {
    final usage = <Unit, int>{};
    for (final h in _items) {
      usage.update(h.investment.unit, (n) => n + 1, ifAbsent: () => 1);
    }
    return usage;
  }

  ItemFigures item(String id, Period p) => _item(id, p);

  /// [startValue] replaces the value at [Period.s]; since-start figures use
  /// the money paid in (story §9.2), not the first value update.
  ItemFigures _item(String id, Period p, {Decimal? startValue}) {
    final tl = timeline(id);
    final inv = tl.investment;
    final resolved = resolve(inv, settings);
    final held =
        inv.startDate.isBefore(p.e.add(const Duration(days: 1))) &&
        (!tl.closedAt(p.s) || tl.activeIn(p.s, p.e));
    final staleValue = held && !_hasActivity(tl, p);

    ItemFigures make({
      Returns? itemUnit,
      Returns? base,
      Excluded? excluded,
      StaleRate? staleRate,
    }) => ItemFigures(
      id: id,
      period: p,
      held: held,
      closed: tl.closedAt(p.e),
      zakat: resolved,
      inflationCountry: seriesOf(id),
      homeCountry: _home,
      toPurify: tl.toPurifyAt(p.e),
      staleValue: staleValue,
      itemUnit: itemUnit,
      base: base,
      excluded: excluded,
      staleRate: staleRate,
    );

    // Entries dated after the period do not affect its figures.
    final missing = tl.missing.where((m) => !m.date.isAfter(p.e));
    if (missing.isNotEmpty) {
      final m = missing.first;
      return make(excluded: Excluded(id, m.from, m.to, m.date));
    }

    final bv = startValue ?? tl.netValueAt(p.s);
    final ev = tl.netValueAt(p.e);
    final flows = tl.flowsIn(p.s, p.e);
    final dividends = resolved.onDividends
        ? tl.incomeFlows(p.s, p.e).where(_charged).toList()
        : <Flow>[];
    final days = _zakatDays(p);

    Returns returnsOf(
      Decimal bv,
      Decimal ev,
      List<Flow> flows,
      List<Flow> dividends,
      Country series,
    ) {
      final dz = modifiedDietz(bv: bv, ev: ev, flows: flows, s: p.s, e: p.e);
      final z = setAside(
        year: _year,
        share: resolved.share,
        ev: ev,
        days: days,
        dividends: sumOf(dividends.map((f) => f.amount)),
      );
      return _returns(dz, z, inflation.forPeriod(series, p.s, p.e));
    }

    final unitReturns = returnsOf(bv, ev, flows, dividends, seriesOf(id));
    if (inv.unit == _base) {
      return make(
        itemUnit: unitReturns,
        base: returnsOf(bv, ev, flows, dividends, _home),
      );
    }

    MissingRate? miss;
    Decimal toBase(Decimal amount, DateTime on) {
      if (amount == Decimal.zero) return amount;
      final c = rates.convert(Money(amount, inv.unit), _base, on);
      if (c == null) {
        miss ??= MissingRate(inv.unit, _base, on);
        return Decimal.zero;
      }
      return c.amount;
    }

    final evB = toBase(ev, p.e);
    final bvB = toBase(bv, p.s);
    final flowsB = [
      for (final f in flows)
        Flow(date: f.date, amount: toBase(f.amount, f.date)),
    ];
    final dividendsB = [
      for (final f in dividends)
        Flow(date: f.date, amount: toBase(f.amount, f.date)),
    ];
    if (miss != null) {
      final m = miss!;
      return make(
        itemUnit: unitReturns,
        excluded: Excluded(id, m.from, m.to, m.date),
      );
    }
    final closing = rates.quote(inv.unit, _base, p.e);
    return make(
      itemUnit: unitReturns,
      base: returnsOf(bvB, evB, flowsB, dividendsB, _home),
      staleRate: closing != null && !closing.asOf.isAfter(p.s)
          ? StaleRate(inv.unit, _base, closing.asOf)
          : null,
    );
  }

  PortfolioFigures portfolio(Period p, ViewUnit view) {
    final all = [for (final h in _items) item(h.investment.id, p)]
        .where((f) => f.held)
        .toList();
    final included = all.where((f) => f.base != null).toList();
    final toPurify = _totalToPurify(included, p.e);
    final metal = switch (view) {
      ViewUnit.base => null,
      ViewUnit.goldGrams => xauG,
      ViewUnit.silverGrams => xagG,
    };
    final staleRates = {
      for (final f in included)
        if (f.staleRate != null)
          (f.staleRate!.from, f.staleRate!.to): f.staleRate!,
    }.values.toList();

    PortfolioFigures make({Returns? totals, MissingRate? unavailable}) =>
        PortfolioFigures(
          period: p,
          view: view,
          unit: metal ?? _base,
          items: all,
          excluded: [for (final f in all) ?f.excluded],
          staleValues: [
            for (final f in included)
              if (f.staleValue) f.id,
          ],
          staleRates: staleRates,
          toPurify: toPurify,
          homeCountry: _home,
          totals: totals,
          unavailable: unavailable,
        );

    final bases = [for (final f in included) f.base!];
    var bv = sumOf(bases.map((r) => r.dietz.bv));
    var ev = sumOf(bases.map((r) => r.dietz.ev));
    var z = sumOf(bases.map((r) => r.z));
    var flows = [for (final r in bases) ...r.dietz.flows.map((w) => w.flow)];

    if (metal != null) {
      MissingRate? miss;
      Decimal toMetal(Decimal amount, DateTime on) {
        if (amount == Decimal.zero) return amount;
        final c = rates.convert(Money(amount, _base), metal, on);
        if (c == null) {
          miss ??= MissingRate(_base, metal, on);
          return Decimal.zero;
        }
        return c.amount;
      }

      ev = toMetal(ev, p.e);
      z = toMetal(z, p.e);
      bv = toMetal(bv, p.s);
      flows = [
        for (final f in flows)
          Flow(date: f.date, amount: toMetal(f.amount, f.date)),
      ];
      if (miss != null) return make(unavailable: miss);
    }

    final dz = modifiedDietz(bv: bv, ev: ev, flows: flows, s: p.s, e: p.e);
    final infl = metal == null ? inflation.forPeriod(_home, p.s, p.e) : null;
    return make(totals: _returns(dz, z, infl, grams: metal != null));
  }

  SinceStartFigures sinceStart(String id) {
    final tl = timeline(id);
    final inv = tl.investment;
    final end = _sinceStartEnd(tl);
    final dayBefore = inv.startDate.subtract(const Duration(days: 1));
    final paidIn = tl.flowsIn(dayBefore, inv.startDate);
    final f = _item(
      id,
      Period(s: inv.startDate, e: end),
      startValue: paidIn.isEmpty ? null : sumOf(paidIn.map((x) => x.amount)),
    );
    final flows = tl.flowsIn(dayBefore, end);
    final gain = tl.netValueAt(end) - sumOf(flows.map((x) => x.amount));
    final totalIn = _totalIn(flows);
    final inBase = f.base == null ? null : _inBase(inv.unit, flows);
    final gainBase = inBase == null ? null : f.base!.dietz.ev - inBase.net;
    final days = f.period.days;
    return SinceStartFigures(
      figures: f,
      days: days,
      gain: gain,
      gainBase: gainBase,
      simpleRoi: totalIn == Decimal.zero ? null : divide(gain, totalIn),
      simpleRoiBase: gainBase == null || inBase!.totalIn == Decimal.zero
          ? null
          : divide(gainBase, inBase.totalIn),
      sinceStartReturn: f.itemUnit?.dietz.r,
      annualised: _annualisedOf(f.itemUnit, days),
      annualisedBase: _annualisedOf(f.base, days),
    );
  }

  /// Latest value date; for metals also the latest rate, because the item's
  /// value in money moves with the rate alone (§9.3).
  DateTime _sinceStartEnd(ItemTimeline tl) {
    final end = tl.latestValueDate;
    if (!tl.unit.isMetal) return end;
    final q = rates.quote(tl.unit, _base, today);
    return q != null && q.asOf.isAfter(end) ? q.asOf : end;
  }

  /// Nisab at today's metal rates, and Σ (value × zakat share) in the base
  /// currency (UX 2.10; the switch itself is never set from this).
  NisabHint nisabHint() {
    Money? nisab(Unit metal, String grams) {
      final q = rates.quote(metal, _base, today);
      return q == null ? null : Money(Decimal.parse(grams) * q.rate, _base);
    }

    var total = Decimal.zero;
    for (final h in _items) {
      final inv = h.investment;
      if (inv.startDate.isAfter(today)) continue;
      final value = timeline(inv.id).netValueAt(today);
      final c = rates.convert(Money(value, inv.unit), _base, today);
      if (c != null) total += c.amount * resolve(inv, settings).share;
    }
    return NisabHint(
      goldNisab: nisab(xauG, '85'),
      silverNisab: nisab(xagG, '595'),
      zakatableTotal: Money(total, _base),
    );
  }

  /// Items without a value update or flow in the calendar month of [today], and
  /// rate pairs without an entry in that month (§9.3).
  StaleNow staleNow() {
    final monthStart = day(today.year, today.month, 1);
    final before = monthStart.subtract(const Duration(days: 1));
    final open = [
      for (final h in _items)
        if (!h.investment.startDate.isAfter(today) &&
            !timeline(h.investment.id).closedAt(today))
          h.investment,
    ];
    final staleItems = [
      for (final inv in open)
        if (!_active(timeline(inv.id), before, today)) inv.id,
    ];
    final pairs = <UnitPair>{
      for (final inv in open)
        if (inv.unit != _base) (inv.unit, _base),
    };
    return StaleNow(
      itemIds: staleItems,
      ratePairs: [
        for (final pair in pairs)
          if (!_hasRateEntry(pair.$1, pair.$2, before, today)) pair,
      ],
    );
  }

  bool _hasActivity(ItemTimeline tl, Period p) => _active(tl, p.s, p.e);

  // Metals have no value updates of their own: a rate entry also counts.
  bool _active(ItemTimeline tl, DateTime s, DateTime e) =>
      tl.activeIn(s, e) ||
      (tl.unit.isMetal && _hasRateEntry(tl.unit, _base, s, e));

  bool _hasRateEntry(Unit from, Unit to, DateTime s, DateTime e) {
    final q = rates.quote(from, to, e);
    return q != null && q.asOf.isAfter(s);
  }

  bool _charged(Flow f) => !noZakatYears.contains(f.date.year);

  /// Days of (s, e] that fall outside the "no zakat due" years.
  int _zakatDays(Period p) {
    if (noZakatYears.isEmpty) return p.days;
    var days = 0;
    for (var y = p.s.year; y <= p.e.year; y++) {
      if (noZakatYears.contains(y)) continue;
      final d = daysBetween(
        later(p.s, day(y - 1, 12, 31)),
        earlier(p.e, day(y, 12, 31)),
      );
      if (d > 0) days += d;
    }
    return days;
  }

  Returns _returns(
    DietzResult dz,
    Decimal z,
    PeriodInflation? infl, {
    bool grams = false,
  }) {
    final i = grams ? Decimal.zero : infl?.i;
    final r = dz.r;
    final rz = afterSetAsideReturn(dz, z);
    final showReal = !grams && i != null;
    return Returns(
      dietz: dz,
      z: z,
      rz: rz,
      i: i,
      real: showReal && r != null ? real(r, i) : null,
      realAfterZakat: showReal && rz != null ? real(rz, i) : null,
      pp: i == null ? null : purchasingPower(dz, z, i),
      inflation: infl,
    );
  }

  Money _totalToPurify(List<ItemFigures> items, DateTime on) {
    var total = Decimal.zero;
    for (final f in items) {
      final c = rates.convert(f.toPurify, _base, on);
      if (c != null) total += c.amount;
    }
    return Money(total, _base);
  }

  Decimal _totalIn(List<Flow> flows) =>
      sumOf(flows.where((x) => x.amount > Decimal.zero).map((x) => x.amount));

  /// Flows converted at their own dates; null when a rate is missing.
  ({Decimal net, Decimal totalIn})? _inBase(Unit unit, List<Flow> flows) {
    var net = Decimal.zero;
    var totalIn = Decimal.zero;
    for (final f in flows) {
      final c = rates.convert(Money(f.amount, unit), _base, f.date);
      if (c == null) return null;
      net += c.amount;
      if (c.amount > Decimal.zero) totalIn += c.amount;
    }
    return (net: net, totalIn: totalIn);
  }

  Decimal? _annualisedOf(Returns? r, int days) {
    final value = r?.dietz.r;
    return value == null ? null : annualised(value, days);
  }
}
