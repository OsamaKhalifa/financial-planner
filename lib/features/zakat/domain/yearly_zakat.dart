/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:decimal/decimal.dart';

import '../../../core/assumptions/domain/rate_book.dart';
import '../../../core/assumptions/domain/settings.dart';
import '../../../core/dates.dart';
import '../../../core/money/decimal_math.dart';
import '../../../core/reference/units.dart';
import '../../investments/domain/investment.dart';
import '../../investments/domain/portfolio_calculator.dart';
import '../../investments/domain/zakat_rules.dart';
import 'zakat_year.dart';

// Every rule of the zakat story (Part A and Part C of the Shariah file) lives
// in this file, one function per rule. A changed ruling is one function here
// and its test.

// ---------------------------------------------------------------- calendar

/// The Gregorian day a year ends on. Lunar: Umm al-Qura, and day 30 in a
/// 29-day month is the 29th, never later than the real end of the year (C3).
/// Solar: 29 February is 28 February in a common year. Null outside the
/// Hijri range the converter covers.
DateTime? dueDate(ZakatYear cal, int month, int dayOfMonth, int year) {
  switch (cal) {
    case ZakatYear.lunar:
      final length = hijriMonthLength(year, month);
      if (length == null) return null;
      return hijriToDate(
        year,
        month,
        dayOfMonth > length ? length : dayOfMonth,
      );
    case ZakatYear.solar:
      final last = endOfMonth(day(year, month, 1)).day;
      return day(year, month, dayOfMonth > last ? last : dayOfMonth);
  }
}

/// How far the user may move a computed due date (C3): lunar two days either
/// way for moon sighting; solar earlier only, since later delays zakat (C2).
({DateTime from, DateTime to}) moveBounds(ZakatYear cal, DateTime computed) => (
  from: computed.subtract(const Duration(days: 2)),
  to: cal == ZakatYear.lunar ? computed.add(const Duration(days: 2)) : computed,
);

final class YearSlot {
  const YearSlot({
    required this.key,
    required this.due,
    required this.calendar,
    required this.number,
    required this.previousDue,
  });

  /// The computed due date; the year's identity (Z4).
  final DateTime key;

  /// The due date after the user's move.
  final DateTime due;
  final ZakatYear calendar;

  /// The Hijri or Gregorian year of [key].
  final int number;

  /// The previous year's real due date; for the first year, the cycle date one
  /// year earlier in the same calendar (C6, Z12).
  final DateTime previousDue;
}

/// Past years plus the open one (the first whose due date is not before
/// [today]). A cycle owns the due dates from its [ZakatCycle.from] up to the
/// next cycle's start, so a change of cycle never rebuilds an existing year
/// (C2).
List<YearSlot> yearSlots(
  List<ZakatCycle> cycles,
  Map<DateTime, DateTime> moved,
  DateTime today,
) {
  final ordered = [...cycles]..sort((a, b) => a.from.compareTo(b.from));
  final slots = <YearSlot>[];
  for (var i = 0; i < ordered.length; i++) {
    final next = i + 1 < ordered.length ? ordered[i + 1].from : null;
    slots.addAll(
      _slotsOf(
        ordered[i],
        next,
        moved,
        today,
        slots.isEmpty ? null : slots.last.due,
      ),
    );
  }
  return slots;
}

Iterable<YearSlot> _slotsOf(
  ZakatCycle c,
  DateTime? next,
  Map<DateTime, DateTime> moved,
  DateTime today,
  DateTime? previous,
) sync* {
  final first = c.calendar == ZakatYear.lunar ? hijriOf(c.from).y : c.from.year;
  var before = previous;
  for (var n = first; ; n++) {
    final key = dueDate(c.calendar, c.month, c.day, n);
    if (key == null) return;
    if (key.isBefore(c.from)) continue;
    final due = moved[key] ?? key;
    if (next != null && !due.isBefore(next)) return;
    yield YearSlot(
      key: key,
      due: due,
      calendar: c.calendar,
      number: n,
      previousDue:
          before ?? dueDate(c.calendar, c.month, c.day, n - 1) ?? c.from,
    );
    before = due;
    if (next == null && !due.isBefore(today)) return;
  }
}

/// Where a new calendar or cycle starts: the day after the open year's real
/// due date, so zakat already due is never pushed later (C2, AC-6). With no
/// year yet, today (Q-O1).
DateTime newCycleFrom(List<YearSlot> slots, DateTime today) {
  final open = slots.where((s) => !s.due.isBefore(today));
  return open.isEmpty ? today : open.first.due.add(const Duration(days: 1));
}

// ------------------------------------------------------------------- state

enum YearState { open, due, distributing, settled }

/// open → due happens by date alone; a started year is distributing until the
/// logged amounts reach Z, then settled (story §4, §8). A frozen Z of 0 is
/// settled at once.
YearState stateOf(
  YearSlot s,
  ZakatYearRecord? r,
  YearResult? frozenResult,
  Decimal distributed,
  DateTime today,
) {
  if (r?.frozen != null) {
    return distributed >= frozenResult!.z!
        ? YearState.settled
        : YearState.distributing;
  }
  return s.due.isAfter(today) ? YearState.open : YearState.due;
}

// ------------------------------------------------------------ lines, totals

Decimal round2(Decimal v) => v.round(scale: 2);

final Decimal _gold = Decimal.fromInt(85);
final Decimal _silver = Decimal.fromInt(595);

/// A3: the nisab in grams of the metal the user chose.
Decimal nisabGrams(NisabMetal metal) =>
    metal == NisabMetal.gold ? _gold : _silver;

/// One source of wealth in a year (story §4). [rate] is the multiplier to the
/// year's base (1 for the base itself); null means no rate on or before the
/// date: never 1:1 (A7). [share] is null while [question] is open.
final class ZakatLine {
  const ZakatLine({
    this.refId,
    this.isExtra = false,
    this.extraKind,
    required this.name,
    required this.unit,
    required this.value,
    required this.heldInterest,
    this.valueDate,
    this.rate,
    this.rateDate,
    this.share,
    required this.section,
    this.notice,
    this.question,
  });

  factory ZakatLine.frozen(FrozenLine f) => ZakatLine(
    refId: f.refId,
    isExtra: f.isExtra,
    extraKind: f.extraKind,
    name: f.name,
    unit: f.unit,
    value: f.value,
    heldInterest: f.heldInterest,
    valueDate: f.valueDate,
    rate: f.rate,
    rateDate: f.rateDate,
    share: f.share,
    section: f.section,
    notice: f.notice,
  );

  final String? refId;
  final bool isExtra;
  final ExtraKind? extraKind;
  final String name;
  final Unit unit;

  /// In [unit], net of [heldInterest] (Z-6).
  final Decimal value;
  final Decimal heldInterest;
  final DateTime? valueDate;
  final Decimal? rate;
  final DateTime? rateDate;
  final Decimal? share;
  final String section;
  final ZakatNotice? notice;
  final ZakatQuestion? question;

  bool get missingRate => rate == null;

  /// Full precision; only displays round.
  Decimal? get inBase => rate == null ? null : value * rate!;

  /// L_i: the amount that enters the zakatable base.
  Decimal? get zakatable =>
      inBase == null || share == null ? null : inBase! * share!;

  /// Display only: Z is worked out from B, not from these (story §7).
  Decimal? lineZakat(Decimal r) =>
      zakatable == null ? null : round2(r * zakatable!);

  FrozenLine toFrozen() => FrozenLine(
    refId: refId,
    isExtra: isExtra,
    extraKind: extraKind,
    name: name,
    unit: unit,
    value: value,
    heldInterest: heldInterest,
    valueDate: valueDate,
    rate: rate,
    rateDate: rateDate,
    share: share!,
    section: section,
    notice: notice,
  );
}

/// Everything [compute] needs; a live year and a frozen year differ only in
/// where these come from (Z10).
final class YearInputs {
  const YearInputs({
    required this.base,
    required this.calendar,
    required this.on,
    required this.nisab,
    required this.metalRate,
    required this.metalRateDate,
    required this.lines,
    required this.debts,
    required this.deductDebts,
  });

  final Unit base;
  final ZakatYear calendar;
  final DateTime on;

  /// Null until the user has chosen (AC-7).
  final NisabMetal? nisab;

  /// The chosen metal's rate to the base on or before [on]; null if none.
  final Decimal? metalRate;
  final DateTime? metalRateDate;
  final List<ZakatLine> lines;
  final Decimal debts;
  final bool deductDebts;
}

/// The values and rates on [p]'s date, plus the year's extra lines converted
/// the same way (A7). An open year passes today's position, a due year its
/// due date's.
YearInputs liveInputs(
  YearSlot s,
  ZakatYearRecord? r,
  ZakatPosition p,
  RateBook rates,
  ZakatPrefs prefs,
) {
  final metal = switch (prefs.nisab) {
    NisabMetal.gold => p.gold,
    NisabMetal.silver => p.silver,
    null => null,
  };
  return YearInputs(
    base: p.base,
    calendar: s.calendar,
    on: p.on,
    nisab: prefs.nisab,
    metalRate: metal?.rate,
    metalRateDate: metal?.asOf,
    lines: [
      for (final h in p.holdings) _itemLine(h),
      for (final e in r?.extras ?? const <ExtraLine>[])
        _extraLine(e, rates.quote(e.amount.unit, p.base, p.on)),
    ],
    debts: r?.debts ?? Decimal.zero,
    deductDebts: r?.deductDebts ?? true,
  );
}

// resolve() calls a user-typed share "A9"; the story's table cites the asset
// section for an "other" item, whose share is always typed (AC-9: Home is B5).
String _itemSection(HoldingOnDate h) => h.investment.type == AssetType.other
    ? 'B5'
    : h.zakat?.sourceSection ?? _questionSection(h.question!);

ZakatLine _itemLine(HoldingOnDate h) => ZakatLine(
  refId: h.investment.id,
  name: h.investment.name,
  unit: h.investment.unit,
  value: h.value,
  heldInterest: h.heldInterest,
  valueDate: h.valueDate,
  rate: h.toBase?.rate,
  rateDate: h.toBase?.asOf,
  share: h.zakat?.share,
  section: _itemSection(h),
  notice: h.zakat?.notice,
  question: h.question,
);

String _questionSection(ZakatQuestion q) =>
    q == ZakatQuestion.jewellery ? 'B2' : 'B3';

ZakatLine _extraLine(ExtraLine e, RateQuote? toBase) => ZakatLine(
  refId: e.id,
  isExtra: true,
  extraKind: e.kind,
  name: e.label,
  unit: e.amount.unit,
  value: e.amount.amount,
  heldInterest: Decimal.zero,
  rate: toBase?.rate,
  rateDate: toBase?.asOf,
  share: Decimal.one,
  section: e.kind == ExtraKind.cash ? 'B1' : 'B9',
);

/// A frozen year: the stored inputs, nothing from today's data (AC-24).
YearInputs frozenInputs(YearSlot s, ZakatYearRecord r) {
  final f = r.frozen!;
  return YearInputs(
    base: f.base,
    calendar: s.calendar,
    on: s.due,
    nisab: f.nisab,
    metalRate: f.metalRate,
    metalRateDate: f.metalRateDate,
    lines: [for (final l in f.lines) ZakatLine.frozen(l)],
    debts: r.debts,
    deductDebts: r.deductDebts,
  );
}

enum Missing { rate, question, nisabStandard, metalRate }

final class YearResult {
  const YearResult({
    required this.linesTotal,
    required this.debtsLine,
    required this.b,
    required this.nisab,
    required this.reachesNisab,
    required this.z,
    required this.empty,
    required this.missing,
  });

  /// Σ L_i.
  final Decimal linesTotal;

  /// What is taken off: the debts when deduction is on, else 0.
  final Decimal debtsLine;

  /// The zakatable base, never below 0.
  final Decimal b;
  final Decimal? nisab;
  final bool? reachesNisab;

  /// Null until the year is complete and not empty.
  final Decimal? z;

  /// No item line and no extra line; debts alone do not count (PM-Q1).
  final bool empty;
  final List<(Missing, List<ZakatLine>)> missing;

  bool get complete => missing.isEmpty;

  /// Start and Close need a complete year with something in it (AC-23).
  bool get canStart => complete && !empty;
}

/// B = max(0, Σ L_i − debts); Z = round2(r × B) if B ≥ nisab, else 0 (A3,
/// A5, C4). r is the calendar's own rate; `ZakatYear.days` is never read (A1).
YearResult compute(YearInputs i) {
  final linesTotal = sumOf(i.lines.map((l) => l.zakatable ?? Decimal.zero));
  final debtsLine = i.deductDebts ? i.debts : Decimal.zero;
  final raw = linesTotal - debtsLine;
  final b = raw < Decimal.zero ? Decimal.zero : raw;
  final nisab = i.nisab == null || i.metalRate == null
      ? null
      : nisabGrams(i.nisab!) * i.metalRate!;
  final reaches = nisab == null ? null : b >= nisab;
  final missing = _missing(i);
  final empty = i.lines.isEmpty;
  return YearResult(
    linesTotal: linesTotal,
    debtsLine: debtsLine,
    b: b,
    nisab: nisab,
    reachesNisab: reaches,
    z: missing.isNotEmpty || empty
        ? null
        : (reaches! ? round2(i.calendar.r * b) : Decimal.zero),
    empty: empty,
    missing: missing,
  );
}

List<(Missing, List<ZakatLine>)> _missing(YearInputs i) {
  final noRate = [
    for (final l in i.lines)
      if (l.missingRate) l,
  ];
  final noAnswer = [
    for (final l in i.lines)
      if (l.question != null) l,
  ];
  return [
    if (noRate.isNotEmpty) (Missing.rate, noRate),
    if (noAnswer.isNotEmpty) (Missing.question, noAnswer),
    if (i.nisab == null) (Missing.nisabStandard, const <ZakatLine>[]),
    if (i.nisab != null && i.metalRate == null)
      (Missing.metalRate, const <ZakatLine>[]),
  ];
}

/// Start, and recompute (C9): the inputs are frozen as they are and every
/// figure is worked out again from them by [compute].
FrozenYear freeze(YearInputs i, DateTime today) {
  if (!compute(i).canStart) {
    throw StateError('A year that is incomplete or empty cannot be frozen.');
  }
  return FrozenYear(
    startedOn: today,
    base: i.base,
    nisab: i.nisab!,
    metalRate: i.metalRate!,
    metalRateDate: i.metalRateDate!,
    lines: [for (final l in i.lines) l.toFrozen()],
  );
}

// ------------------------------------------------------- extra lines (C5)

enum ExtraLineError { label, amount, unit, goodDebt }

/// Cash and good debts only, at 100 % (B1, B9, C5). Gold, goods for sale and
/// a business are My Investments items, so a metal unit is refused.
List<ExtraLineError> validateExtra(ExtraLine e) => [
  if (e.label.trim().isEmpty) ExtraLineError.label,
  if (e.amount.amount <= Decimal.zero) ExtraLineError.amount,
  if (e.amount.unit.code.isEmpty || e.amount.unit.isMetal) ExtraLineError.unit,
  if (e.kind == ExtraKind.owedToMe && !e.goodDebtConfirmed)
    ExtraLineError.goodDebt,
];

// ------------------------------------------------------------- gifts (§9)

enum GiftError { amount, unit, dateTooEarly, dateInFuture }

/// The first day an entry may carry: the day after the previous year's real
/// due date, which keeps it inside this year's own hawl (C6).
DateTime earliestGiftDate(YearSlot s) =>
    s.previousDue.add(const Duration(days: 1));

List<GiftError> validateGift(Gift g, YearSlot s, DateTime today) => [
  if (g.amount.amount <= Decimal.zero) GiftError.amount,
  if (g.amount.unit.code.isEmpty || g.amount.unit.isMetal) GiftError.unit,
  if (g.date.isBefore(earliestGiftDate(s))) GiftError.dateTooEarly,
  if (g.date.isAfter(today)) GiftError.dateInFuture,
];

/// The day whose rate counts a gift in another currency (C8).
DateTime giftRateDate(GivingRateView v, Gift g, YearSlot s) =>
    v == GivingRateView.dayGiven ? g.date : s.due;

/// In the year's base: as is, or `round2(amount × rate)` (Z11).
Decimal counted(Gift g, Unit base) =>
    g.amount.unit == base ? g.amount.amount : round2(g.amount.amount * g.rate!);

bool givenEarly(Gift g, YearSlot s) => g.date.isBefore(s.due);

/// [over] is what C7 names "more than due".
({Decimal distributed, Decimal remaining, Decimal over}) progress(
  Decimal z,
  List<Gift> gifts,
  Unit base,
) {
  final distributed = sumOf(gifts.map((g) => counted(g, base)));
  final gap = z - distributed;
  return (
    distributed: distributed,
    remaining: gap > Decimal.zero ? gap : Decimal.zero,
    over: gap < Decimal.zero ? -gap : Decimal.zero,
  );
}

// ----------------------------------------------------------- year view, focus

/// What every screen reads about one year.
final class YearView {
  const YearView({
    required this.slot,
    required this.record,
    required this.inputs,
    required this.result,
    required this.state,
    required this.progress,
  });

  final YearSlot slot;
  final ZakatYearRecord? record;
  final YearInputs inputs;
  final YearResult result;
  final YearState state;
  final ({Decimal distributed, Decimal remaining, Decimal over}) progress;

  bool get frozen => record?.frozen != null;
}

/// [inputs] are the live ones for an open or due year and the frozen ones for
/// a started year.
YearView yearViewOf(
  YearSlot slot,
  ZakatYearRecord? record,
  YearInputs inputs,
  DateTime today,
) {
  final result = compute(inputs);
  final p = progress(
    result.z ?? Decimal.zero,
    record?.gifts ?? const [],
    inputs.base,
  );
  return YearView(
    slot: slot,
    record: record,
    inputs: inputs,
    result: result,
    state: stateOf(
      slot,
      record,
      record?.frozen == null ? null : result,
      p.distributed,
      today,
    ),
    progress: p,
  );
}

/// The oldest due year, else the oldest distributing one, else the open one
/// (UX U2). With none of those (the last year was closed on its due date) the
/// newest year.
YearView focusYear(List<YearView> years) {
  YearView? oldest(YearState state) {
    final of = years.where((y) => y.state == state).toList()
      ..sort((a, b) => a.slot.due.compareTo(b.slot.due));
    return of.isEmpty ? null : of.first;
  }

  return oldest(YearState.due) ??
      oldest(YearState.distributing) ??
      oldest(YearState.open) ??
      years.reduce((a, b) => a.slot.due.isAfter(b.slot.due) ? a : b);
}

// ---------------------------------------------------------------- reminder

final class ReminderPlan {
  const ReminderPlan({
    required this.yearKey,
    required this.fireAt,
    required this.daysBefore,
    required this.label,
    required this.due,
  });

  final DateTime yearKey;

  /// Device wall time.
  final DateTime fireAt;
  final int daysBefore;

  /// "1448 AH" or "2027"; the screen builds the localised text.
  final String label;
  final DateTime due;
}

/// Device wall time of the reminder: [daysBefore] days before [due], at
/// [minute] minutes after midnight.
DateTime reminderFireAt(DateTime due, int daysBefore, int minute) => DateTime(
  due.year,
  due.month,
  due.day - daysBefore,
  minute ~/ 60,
  minute % 60,
);

/// One reminder, for the coming year (the first whose due date is not before
/// today), at (due − N days) at the chosen minute. None when it is off, not
/// permitted, already past, or the year is started (story §5.4). A change of
/// calendar or cycle does not touch it: the coming year keeps its due date.
ReminderPlan? reminderPlan(
  List<YearView> years,
  ZakatPrefs prefs, {
  required bool permitted,
  required DateTime now,
}) {
  if (!prefs.reminderOn || !permitted) return null;
  final todayDate = day(now.year, now.month, now.day);
  final coming = years.where((y) => !y.slot.due.isBefore(todayDate)).toList()
    ..sort((a, b) => a.slot.due.compareTo(b.slot.due));
  if (coming.isEmpty || coming.first.frozen) return null;
  final slot = coming.first.slot;
  final fireAt = reminderFireAt(
    slot.due,
    prefs.reminderDays,
    prefs.reminderMinute,
  );
  if (!fireAt.isAfter(now)) return null;
  return ReminderPlan(
    yearKey: slot.key,
    fireAt: fireAt,
    daysBefore: prefs.reminderDays,
    label: slot.calendar == ZakatYear.lunar
        ? '${slot.number} AH'
        : '${slot.number}',
    due: slot.due,
  );
}
