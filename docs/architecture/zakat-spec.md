# Implementation spec — Zakat (UC-3: yearly zakat, its sources, its distribution)

**Owner:** architect · **Status:** v1 · 2026-10-24
**Inputs:** [story](../product/stories/zakat.md) (review loop 1, AC-1…AC-44) · [UX](../product/ux/zakat.md) (Z1–Z8, S4/S8/S9 changes) · [zakat file](../product/shariah/zakat-on-investments.md) Part A, B and **Part C (C1–C11)** · coordinator delta 2026-10-23 (value/rate dates on lines, moved previous due date, per-entry rate data, reminder on/off, Start + Undo, empty and below-nisab states) · ADR-[0001](../adr/0001-data-access-behind-repositories.md), [0002](../adr/0002-project-layout-and-stack.md), [0007](../adr/0007-hijri-calendar.md) (new), [0008](../adr/0008-local-notifications.md) (new) · base: `origin/main` 288d151 (Overview).
**Built to change:** the consultant's loop-1 review runs in parallel. Every text is an ARB key (§8); every Part A/C rule is in **one** file, `lib/features/zakat/domain/yearly_zakat.dart` (§3.3). A changed text = ARB edit. A changed rule = one function in that file + its test.

Rule of this spec (same as my-investments): the domain is pure Dart and holds the logic and the tests. Repositories store and stream. Screens display domain output.

---

## 1. Decisions

| # | Decision | Why | Rejected |
|---|---|---|---|
| Z1 | **Zakat is its own feature, `lib/features/zakat/`, and may import `lib/features/investments/`. One direction only.** ADR-0002 gets an amendment: "a feature may import `features/investments`; `features/investments` never imports another feature except `settings`; no other feature-to-feature import". Enforced by a new line in `test/architecture_test.dart`. | The Zakat tab needs `PortfolioCalculator`, `resolve()`, the why sheet, `DateField`, the unit picker, the rate dialog and `ItemDetailScreen` (jump to source, AC-21). **Overview already does this** on main (11 imports from `features/investments`, plus `main.dart` for `AppShell.select`): the rule is already broken and not tested. Writing down what is true and testing it beats a third pattern. | **Zakat inside `features/investments/`** — the folder becomes the whole app, and the tab shell already treats Zakat as a feature. **Callbacks injected from `main.dart`** — 10+ widgets and providers would have to pass through constructor parameters. **Move the calculator and shared widgets to `lib/core/`** — ~40 files churn for no behaviour change. |
| Z2 | **One injection seam for S8 only:** `zakatSettingsSectionProvider` (`Provider<WidgetBuilder?>`, default `null`) in `investments_providers.dart`, overridden in `main.dart` with the zakat feature's `ZakatSettingsSection`. When set, S8 shows it **in place of** its own zakat-year radio. | UX U4 puts the zakat rows in S8 (an investments screen), and the zakat-year radio must open the cycle sheet once a cycle exists (story §5.1). Z1 forbids investments → zakat. This is the only place the arrow points backwards. | **Investments imports zakat** — a cycle. **Move the zakat-year radio to a Zakat settings page** — cheaper, but a UX change (U4); not taken without the owner. |
| Z3 | **Years are derived, never stored as a list.** The year list is rebuilt on every read from the stored **cycles** (§2.1), the stored per-year **decisions** (moved date, debts, start/freeze, extra lines, gifts) and today. A year row (`zakat_years`) is written only on the user's first decision about that year. | Same rule as my-investments E1: "nothing written in the background". open → due happens by date, with no write (story §8 "the only automatic state changes"). AC-20 "never creates/deletes a year by itself" holds by construction. | **Stored years created at app start** — a write the user did not ask for, and a job that must run on every start. |
| Z4 | **Year key = its computed due date** (`yyyy-MM-dd`). Not the label. | Two years can carry the same label after a cycle change inside one Hijri/Gregorian year (§10 Q-P1). Due dates are strictly ordered across cycles, so the key is unique. A moved due date never changes the key. | `(calendar, number)` — collides (Q-P1). |
| Z5 | **Cycles are append-only** in table `zakat_cycles`: `{calendar, month, day, from}`. Years of a cycle = due dates ≥ `from` and before the next cycle's `from`. First save: `from` = today (Q-O1). Each later change: `from` = the open year's **effective** due date + 1 (C2, AC-6). A stored cycle whose `from` ≥ the new `from` owns no existing year and is deleted in the same transaction. | Every existing year keeps its calendar, due date and r (§5.1, C2) without copying anything. AC-6's three cases fall out: 1448 AH kept, next "2027"; due/distributing kept; cycle change → "2028". | **Rebuild years on change** (C2 BLOCKER). **Materialise existing years at change time** — copies of derivable facts. |
| Z6 | **Cycle + `Settings.zakatYear` are written in one transaction** by `AssumptionsRepository.saveZakatCycle(Settings, ZakatCycle)`. | Story §5.1: the calendar change "is not saved until [the cycle date] is given". `zakatYear` lives in the settings table (owned by `AssumptionsRepository`); the cycle row next to it keeps the write in one repository (ADR-0001 revisit trigger avoided). | Cycles in `ZakatRepository` — a cross-repository transaction. |
| Z7 | **Zakat preferences are one value `ZakatPrefs` inside `Settings`** (`Settings.zakat`, never null, default `const ZakatPrefs()`): nisab metal, reminder on/days/minute, reminder asked, giving-rate view. Stored as six `settings` columns. | `Settings` has no `copyWith`; `_with` in `investments_providers.dart` rebuilds it field by field and drops anything it does not name. One nested field = one line in `_with` instead of six chances to drop a setting. Same table and same S8 section as the existing zakat settings (swim the channel). | Six flat `Settings` fields (six `_with` lines). A new `zakat_settings` table (a second settings store). |
| Z8 | **`ZakatRepository`** (new interface, ADR-0001) in `features/zakat/domain/`, Drift impl in `features/zakat/data/`. It owns year decisions, extra lines, frozen lines and gifts. | A new aggregate with real queries (ADR-0002 §4 revisit trigger: "UC-3 … decide then"). Rates, settings and cycles stay in `AssumptionsRepository`. | Everything in `AssumptionsRepository` — it would hold two unrelated aggregates. |
| Z9 | **Live lines come from the calculator: `PortfolioCalculator.zakatPosition(DateTime on)`** (new). `nisabHint()` becomes a 10-line wrapper over `zakatPosition(today)`. | Story §6.1 asks for exactly what `nisabHint` already computes (net value incl. H, rate on or before the date, `resolve()` share, metal quotes), but at a chosen date and per item. One method, two callers. | A second "zakat calculator" — a parallel path that would drift from My Investments (story §6.1 says "the same rule the item uses today"). |
| Z10 | **A frozen year stores inputs only** (each line's name, unit, value, value date, held interest, rate, rate date, share, section, notice; the year's base, nisab metal, metal rate + date; debts + on/off). B, Z, every line amount and the nisab are recomputed by the **same** pure function as a live year. | One formula path for live and frozen (AC-24, AC-33); nothing derived is stored twice. A rate edit or item deletion cannot touch a frozen year, because its rates are copied (AC-24). | Store B and Z too — a second copy that a formula fix would not update consistently. JSON blob — unversioned, not covered by the migration test. |
| Z11 | **A gift stores amount, currency, rate, rate date and rate view.** Counted amount = `round2(amount × rate)`, derived. | Delta (3); story §9 "a change applies to new entries only" (PM-Q5) and AC-42 "year keeps EGP after a base change": a later rate edit or view change must not recount an old entry. | Derive the rate from `RateBook` on each read — a rate edit would recount old entries. |
| Z12 | **"Previous due date"** = the previous year's **effective (moved)** due date. First year: the cycle date one year before the first due date, in the same calendar (delta (2), C6). | Earliest gift date (C6, AC-28) and the year's start. | Computed (unmoved) date — wrong by up to 2 days after a move. |
| Z13 | **Hijri conversion lives in `lib/core/dates.dart`** (ADR-0007), the only file importing `package:hijri`. | D3 of the my-investments spec: `dates.dart` is the only place that builds calendar dates. The package returns local `DateTime`s; the conversion to UTC sits in one place. | A zakat-only `hijri.dart` wrapper — a new file where an existing one fits. |
| Z14 | **Notifications behind `YearEndReminder`** (ADR-0008): one fixed id, inexact on Android, absolute UTC instant, no `flutter_timezone`. The plan (which year, which moment) is a pure function in `yearly_zakat.dart`; the screen builds the localised text and calls the port. | Tests use a fake; no platform channel in `flutter test`. Inexact avoids the exact-alarm permission (story allows it — see Q-N1). | See ADR-0008. |
| Z15 | **Undo for Start / Close = `SnackBar(duration: 10 s)` with an Undo action.** The action calls `ZakatRepository.unfreeze`, which throws `Conflict` if the year has a gift. | AC-43 needs 10 s; `test/architecture_test.dart` forbids `Timer` in `lib/features/` (AC-63). The SnackBar's own duration is the timer; same pattern as S4 ✓ (`item_detail_screen.dart` ~610). "Only while the log is empty" is enforced in the repository, not by UI timing. | A `Timer` (banned); a stored "undo until" timestamp (a write for a UI affordance). |
| Z16 | **Line value date** (delta (1)): `ItemTimeline.valueDateAt(d)` (new, next to `latestValueDate`) = the latest non-interest entry on or before d; for metals, the later of that and the metal rate's date. The line shows it, and the rate date, when older than the due date. | Same rule as the stale-value logic (§9.3) already in that file. | Compute in the screen — logic in a widget. |
| Z17 | **S4 frozen-year banner** = one optional constructor parameter `ItemDetailScreen(investmentId, frozenNote: String?)`. | UX 2.4.6: "one optional S4 argument; nothing else in S4 changes". | — |
| Z18 | **The rate fix rows reuse `showRateDialog`** (`rate_history_screen.dart`), with one new optional parameter `DateTime? on` (preset date). | It already writes a typed rate via `saveTypedRate` (AC-42 "stored as a manual dated rate, like any other"). | A zakat rate dialog. |

---

## 2. Data model — Drift schema v3 (`lib/core/db/`)

### 2.1 Tables

All new tables: `id TEXT PK` (UUID, `newId()`), `created_at`, `updated_at` (UTC), Decimals as TEXT via `DecimalConverter`, calendar days via `CalendarDateConverter` (ADR-0001, D2).

| Table | Columns (besides id / created_at / updated_at) | Keys |
|---|---|---|
| `settings` (changed) | **+** `nisab_metal` TEXT null (`gold`/`silver`), `reminder_on` BOOL NOT NULL DEFAULT 1, `reminder_days` INT NOT NULL DEFAULT 0, `reminder_minute` INT NOT NULL DEFAULT 540 (09:00), `reminder_asked` BOOL NOT NULL DEFAULT 0, `giving_rate_view` TEXT null (`dayGiven`/`dueDate`) | — |
| `zakat_cycles` (new) | `calendar` (`lunar`/`solar`, the `ZakatYear` name), `month` INT, `day` INT, `from_date` date | unique (`from_date`) |
| `zakat_years` (new) | `due_key` date (computed due date, Z4), `moved_due` date null, `debts` Decimal NOT NULL DEFAULT '0', `deduct_debts` BOOL NOT NULL DEFAULT 1, `started_on` date null, **frozen inputs** (null unless started): `frozen_base` TEXT, `frozen_nisab_metal` TEXT, `frozen_metal_rate` Decimal null, `frozen_metal_rate_date` date null | unique (`due_key`) |
| `zakat_extra_lines` (new) | `year_id` → zakat_years.id ON DELETE CASCADE, `label`, `kind` (`cash`/`owedToMe`), `amount` Decimal, `unit`, `good_debt_confirmed` BOOL | index (`year_id`) |
| `zakat_frozen_lines` (new) | `year_id` → cascade, `position` INT, `source` (`item`/`extra`), `ref_id` TEXT null (investment or extra-line id), `name`, `unit`, `value` Decimal, `held_interest` Decimal, `value_date` date null, `rate` Decimal null, `rate_date` date null, `share` Decimal, `section` TEXT, `notice` TEXT null, `extra_kind` TEXT null | index (`year_id`, `position`) |
| `zakat_gifts` (new) | `year_id` → cascade, `date`, `amount` Decimal, `unit`, `rate` Decimal null, `rate_date` date null, `rate_view` TEXT null (all three null when unit = year base), `note` TEXT null | index (`year_id`, `date`) |

`zakat_years` rows are never deleted (AC-20); `unfreeze` clears `started_on` and the frozen columns and deletes that year's `zakat_frozen_lines`.

### 2.2 Migration v2 → v3

- `app_database.dart`: add the four tables to `@DriftDatabase(tables: …)`, `schemaVersion => 3`, add `from2To3` to `stepByStep`, inside `transaction(...)` like `from1To2`: `m.addColumn(schema.settings, …)` × 6, `m.create(schema.zakatCycles)`, `…zakatYears`, `…zakatExtraLines`, `…zakatFrozenLines`, `…zakatGifts`, and their indexes (`m.create(schema.<index>)`). Only adds — no table rebuild, no data copy. The NOT NULL columns carry constant defaults (SQLite `ALTER TABLE ADD COLUMN` accepts them).
- Commands (in the worktree, in this order): edit `tables.dart` + `app_database.dart` → `dart run build_runner build --delete-conflicting-outputs` → `dart run drift_dev make-migrations` → commits `drift_schemas/app_database/drift_schema_v3.json`, regenerated `lib/core/db/app_database.steps.dart`, `test/core/db/app_database/generated/schema_v3.dart`, updated `generated/schema.dart`. The v2 snapshot already exists, so no "snapshot first" step this time. CI's `git diff --exit-code -- lib` must stay clean.
- `test/core/db/app_database/migration_test.dart` already loops over all versions (1→2, 1→3, 2→3 by the generated schema test). **Add** one `testWithDataIntegrity(oldVersion: 2, newVersion: 3)`: insert at v2 one item of every v2 field, a history row, a typed and a fetched rate, an inflation override, the settings row with all five v1 columns, a no-zakat year; open at v3; read through `DriftAssumptionsRepository` / `DriftInvestmentsRepository`: everything equal, `Settings.zakat == const ZakatPrefs()` (on, 0 days, 09:00, not asked, no metal, no view), no cycles, `ZakatRepository.watchYears()` emits `[]`.

---

## 3. Domain

### 3.1 Core additions — `lib/core/assumptions/domain/settings.dart` (changed)

```dart
enum NisabMetal { gold, silver }                  // grams live in yearly_zakat.dart (A3)
enum GivingRateView { dayGiven, dueDate }          // C8
final class ZakatPrefs {
  const ZakatPrefs({this.nisab, this.reminderOn = true, this.reminderDays = 0,
                    this.reminderMinute = 540, this.reminderAsked = false, this.givingRateView});
  final NisabMetal? nisab;            // null = not asked yet (AC-7)
  final bool reminderOn; final int reminderDays; final int reminderMinute;   // product defaults (§5.4)
  final bool reminderAsked;           // AC-34: ask the OS once
  final GivingRateView? givingRateView;   // null = not asked yet (AC-30)
  ZakatPrefs copyWith({...});         // explicit nulls via a sentinel are not needed: no field is ever cleared
}
final class ZakatCycle { const ZakatCycle({String? id, required this.calendar, required this.month, required this.day, required this.from}); ZakatYear calendar; int month; int day; DateTime from; }
// Settings gets `final ZakatPrefs zakat;` (constructor default const ZakatPrefs()).
```
`ZakatCycle` sits in core because `AssumptionsRepository` speaks it, and core may not import features. `ZakatPrefs.copyWith` has callers in four sheets; `Settings` itself still has none (`_with` stays the one rebuild path).

`lib/core/dates.dart` (changed, ADR-0007):
```dart
DateTime? hijriToDate(int y, int m, int d);   // UTC; null outside 1356–1500 AH
int? hijriMonthLength(int y, int m);
({int y, int m, int d}) hijriOf(DateTime date);
```

`lib/core/assumptions/domain/assumptions_repository.dart` (changed): `Stream<List<ZakatCycle>> watchZakatCycles();` (ordered by `from`) and `Future<void> saveZakatCycle(Settings settings, ZakatCycle cycle);` — one transaction: settings row (same upsert as `saveSettings`) + delete cycles with `from >= cycle.from` + insert `cycle`.

### 3.2 Investments additions (changed files, Z9/Z16)

`portfolio_calculator.dart`:
```dart
enum ZakatQuestion { jewellery, longTermMethod }
final class HoldingOnDate {
  Investment investment; Decimal value /* net of H, item unit */; Decimal heldInterest;
  DateTime valueDate; RateQuote? toBase /* null + unit != base → missing */;
  ResolvedZakat? zakat; ZakatQuestion? question;   // exactly one of the two is set
}
final class ZakatPosition { DateTime on; Unit base; List<HoldingOnDate> holdings; RateQuote? gold; RateQuote? silver; }
ZakatPosition zakatPosition(DateTime on);
  // holdings: items with startDate ≤ on and !closedAt(on) (story §6.1, AC-13); value = netValueAt(on) (AC-11, AC-14)
  // toBase = rates.quote(unit, base, on) — never a rate dated after `on` (AC-11); gold/silver = quote(xauG/xagG, base, on)
NisabHint nisabHint();   // = zakatPosition(today): Σ value × toBase.rate × zakat.share over holdings with both; metals × 85 / 595
```
`zakat_rules.dart`: `ZakatQuestion? pendingQuestion(Investment, Settings)` — the two cases where `resolve()` throws today; `zakatPosition` calls it before `resolve`. (`ZakatQuestion` lives here, not in the calculator.)
`item_timeline.dart`: `DateTime valueDateAt(DateTime d)` (Z16).

### 3.3 Zakat domain — `lib/features/zakat/domain/`

**`zakat_year.dart`** (new) — stored records, no logic:
```dart
enum ExtraKind { cash, owedToMe }
final class ExtraLine { String id; String label; ExtraKind kind; Money amount; bool goodDebtConfirmed; }
final class FrozenLine { String? refId; bool isExtra; ExtraKind? extraKind; String name; Unit unit; Decimal value, heldInterest; DateTime? valueDate;
                         Decimal? rate; DateTime? rateDate; Decimal share; String section; ZakatNotice? notice; }
final class FrozenYear { DateTime startedOn; Unit base; NisabMetal nisab; Decimal metalRate; DateTime metalRateDate; List<FrozenLine> lines; }
final class Gift { String id; DateTime date; Money amount; Decimal? rate; DateTime? rateDate; GivingRateView? view; String? note; }
final class ZakatYearRecord { DateTime dueKey; DateTime? movedDue; Decimal debts; bool deductDebts;
                              List<ExtraLine> extras; FrozenYear? frozen; List<Gift> gifts; }
// A missing record reads as: no move, debts 0, deduction on, no extras, not frozen, no gifts (AC-18).
```

**`yearly_zakat.dart`** (new) — **every Part A/C rule of the story, and nothing else.** Pure functions; each test-named after its AC.
```dart
// Calendar (§5.1–5.3, C1–C3)
DateTime? dueDate(ZakatYear cal, int month, int day, int year);   // lunar: Umm al-Qura, day 30 → month length (C3); solar: 29 Feb → 28 Feb
({DateTime from, DateTime to}) moveBounds(ZakatYear cal, DateTime computed);   // lunar −2…+2; solar −2…0 (C3)
final class YearSlot { DateTime key /* computed */; DateTime due /* effective */; ZakatYear calendar; int number; DateTime previousDue; }
List<YearSlot> yearSlots(List<ZakatCycle> cycles, Map<DateTime, DateTime> moved, DateTime today);
   // past years + the open one (first effective due ≥ today); previousDue per Z12; stops at the hijri range end
DateTime newCycleFrom(List<YearSlot> slots, DateTime today);       // open year's effective due + 1, or today when no cycle (Z5)
// State (§8)
enum YearState { open, due, distributing, settled }
YearState stateOf(YearSlot s, ZakatYearRecord? r, YearResult? frozenResult, Decimal distributed, DateTime today);
// Lines and totals (§6, §7; A1–A8, B1/B9, C4, C5)
final class ZakatLine { … the FrozenLine fields + Decimal? inBase, zakatable, lineZakat; ZakatQuestion? question; bool missingRate; }
final class YearInputs { Unit base; ZakatYear calendar; DateTime on; NisabMetal? nisab; RateQuote? metalRate;
                         List<ZakatLine> lines; Decimal debts; bool deductDebts; }
YearInputs liveInputs(YearSlot s, ZakatYearRecord? r, ZakatPosition p, RateBook rates, ZakatPrefs prefs);   // extras converted on p.on (A7)
YearInputs frozenInputs(YearSlot s, ZakatYearRecord r);
enum Missing { rate, question, nisabStandard, metalRate }
final class YearResult { Decimal linesTotal, debtsLine, b; Decimal? nisab; bool? reachesNisab; Decimal? z;
                         bool empty; List<(Missing, List<ZakatLine>)> missing; bool get complete; bool get canStart; }
YearResult compute(YearInputs i);
   // per line: inBase = value × rate (full precision); zakatable L_i = inBase × share; lineZakat = round2(r × L_i) (display only)
   // B = max(0, ΣL − debts if deduct); nisab = grams × metal rate; Z = round2(r × B) if B ≥ nisab else 0 (C4)
   // r = calendar.r; ZakatYear.days is never read (AC-9); empty = no item line and no extra line (PM-Q1)
FrozenYear freeze(YearInputs i, DateTime today);    // start and recompute (C9)
// Extra lines (C5, B9) and debts (A5)
List<ExtraLineError> validateExtra(ExtraLine e);    // amount > 0, unit set, owedToMe needs goodDebtConfirmed
// Gifts (§9; C6, C7, C8)
DateTime earliestGiftDate(YearSlot s) => s.previousDue + 1 day;
List<GiftError> validateGift(Gift g, YearSlot s, DateTime today);   // > 0; date in (previousDue, today]; not XAU-g/XAG-g
DateTime giftRateDate(GivingRateView v, Gift g, YearSlot s) => v == dayGiven ? g.date : s.due;
Decimal counted(Gift g, Unit base);                 // amount if unit == base, else round2(amount × rate)
bool givenEarly(Gift g, YearSlot s) => g.date.isBefore(s.due);
({Decimal distributed, Decimal remaining, Decimal over}) progress(Decimal z, List<Gift> gifts, Unit base);
// Reminder (§5.4)
final class ReminderPlan { DateTime yearKey; DateTime fireAt /* local wall time */; int daysBefore; String label; DateTime due; }
ReminderPlan? reminderPlan(List<YearView> years, ZakatPrefs prefs, {required bool permitted, required DateTime now});
   // the year with the first effective due ≥ today; none if off, not permitted, fireAt ≤ now, or that year is started
// Focus year (UX U2): oldest due, else oldest distributing, else open
YearView focusYear(List<YearView> years);
```
`YearView` = `{YearSlot slot; ZakatYearRecord? record; YearInputs inputs; YearResult result; YearState state; progress}` — what every screen reads.

Rounding: `round2` = `Decimal.round(scale: 2)` (half away from zero), the my-investments E9 exception: Z and counted gifts are amounts the user gives.

**`zakat_repository.dart`** (new, ADR-0001; async, domain types only):
```dart
abstract interface class ZakatRepository {
  Stream<List<ZakatYearRecord>> watchYears();
  Future<void> saveYear(DateTime key, {DateTime? movedDue, required Decimal debts, required bool deductDebts});  // upsert; Conflict if frozen
  Future<void> saveExtraLine(DateTime key, ExtraLine line);     // upsert by id (also Undo of delete); Conflict if frozen
  Future<void> deleteExtraLine(String id);
  Future<void> freeze(DateTime key, FrozenYear f);              // start or recompute: one transaction, gifts untouched
  Future<void> unfreeze(DateTime key);                          // Undo: Conflict if any gift exists (Z15)
  Future<void> saveGift(DateTime key, Gift g);                  // upsert by id; Conflict if not frozen (AC-26)
  Future<void> deleteGift(String id);
}
```

**`year_end_reminder.dart`** (new) — the port of ADR-0008 (`Reminder`, `YearEndReminder`).

### 3.4 Where each rule lives

| Rule | File |
|---|---|
| r per calendar, no T/Y (A1, A2, C1) | `Settings.ZakatYear.r` (existing) read by `compute` |
| Cycle → due date, day 30, 29 Feb (C1, C3) | `yearly_zakat.dart` `dueDate` (+ `dates.dart` conversion) |
| Moving a due date (C3) | `moveBounds` |
| Calendar/cycle change never pushes zakat later (C2) | `newCycleFrom` + `saveZakatCycle` |
| Item share and section (Part B) | `zakat_rules.dart resolve()` (unchanged) via `zakatPosition` |
| Values net of H, market value, on the date (Z-6, A7, edge cases) | `PortfolioCalculator.zakatPosition` |
| Extra-line kinds, good debt (B1, B9, C5) | `validateExtra` |
| Debts, nisab after deduction, below nisab (A3, A5, C4) | `compute` |
| Giving early, earliest date (C6) | `earliestGiftDate`, `validateGift`, `givenEarly` |
| More than due (C7), recompute (C9) | `progress`, `freeze` |
| Other currency, rate view (C8) | `giftRateDate`, `counted` |
| Notification moment (§5.4) | `reminderPlan`; text C10 in ARB |
| What "settled" claims (C11) | ARB only |

---

## 4. Data implementations

- `lib/core/db/tables.dart` — §2.1.
- `lib/core/assumptions/data/drift_assumptions_repository.dart` — `saveSettings` row and `_settingsOf` map the six new columns (`s.zakat.*`); `watchZakatCycles`, `saveZakatCycle` (one `transaction`).
- `lib/features/zakat/data/drift_zakat_repository.dart` (new) — `watchYears` = `_db.tableUpdates(TableUpdateQuery.onAllTables([zakatYears, zakatExtraLines, zakatFrozenLines, zakatGifts]))` started with one initial event, `asyncMap` to one read of the four tables (one transaction), grouped by `year_id` in Dart. (One LEFT JOIN over three child tables would multiply rows.) No stream library. Errors through `guardStorage`. Cascade by FK (`PRAGMA foreign_keys = ON` is already set).
- `lib/features/zakat/data/local_year_end_reminder.dart` (new) — ADR-0008. Plugin `initialize` happens lazily on first call (not in `main()`), so app start and every existing test stay plugin-free.

---

## 5. Providers — `lib/features/zakat/presentation/zakat_providers.dart` (new)

| Provider | What |
|---|---|
| `zakatRepositoryProvider` | `DriftZakatRepository(appDatabase, clock)` |
| `zakatRecordsProvider` | `StreamProvider` of `watchYears()` |
| `zakatCyclesProvider` | in `lib/core/assumptions/assumptions_providers.dart` (changed), `StreamProvider` of `watchZakatCycles()` |
| `zakatYearsProvider` | `Provider<List<YearView>?>`: cycles + records + `calculatorProvider` + `rateBookProvider` + `settingsProvider` + `todayProvider` → `yearSlots`, then per slot: open → `liveInputs(zakatPosition(today))` (story §7 "open year"), due → `liveInputs(zakatPosition(slot.due))`, frozen → `frozenInputs`; `compute`; `stateOf`. Null until loaded. Newest first is the screen's job. |
| `yearViewProvider.family(DateTime key)` | one `YearView` or null (deleted cycle) |
| `focusYearProvider` | `focusYear(...)` |
| `yearEndReminderProvider` | `Provider<YearEndReminder>` → `LocalYearEndReminder()`; **overridden by `FakeYearEndReminder` in `test/support/app_harness.dart`** for every test |
| `reminderPlanProvider` | `FutureProvider<ReminderPlan?>`: years + prefs + `isPermitted()` + clock |
| `zakatActionsProvider` | `ZakatActions` (like `SettingsActions`): `saveCycle(...)` (first save asks permission once, AC-34), `changeCycle(...)`, `setNisab`, `setReminder(on, days, minute)`, `setGivingRateView`, `moveDue`, `saveDebts`, `start(YearView)` / `recompute(YearView)` (both `freeze(liveInputs(due date))`), `undoStart`, extra-line and gift writes. Every prefs write is `saveSettings(_with(old, zakat: old.zakat.copyWith(...)))` — `_with` gets `ZakatPrefs? zakat` (one line). |

Reminder sync (story §5.4 "at every app start and after every change"): `ZakatScreen` (built at start: `AppShell` uses an `IndexedStack`) does `ref.listen(reminderPlanProvider, …, fireImmediately: true)`; on a changed `(plan, locale)` it calls `cancel()` or `schedule(Reminder(text from l10n))`. Locale is part of the comparison so the text follows a language change at the next start.

---

## 6. Screens and widgets (UX doc is the layout source)

| UX | File | New / changed | Reads → writes |
|---|---|---|---|
| Tab root: due texts (C10) + Z1 or Z2 of the focus year; notification tap / launch routing (AC-36) | `lib/features/zakat/presentation/zakat_screen.dart` | changed (placeholder replaced) | `zakatYearsProvider`, `focusYearProvider`, port `launchYearKey`/`taps` → `AppShell.select(context, AppShell.zakatTab)` + push Z2 |
| Z1 setup (steps z/a/b/c) | `zakat_setup.dart` | new | prefs, cycles → `saveCycle` (+ permission once), `setNisab` |
| Z2 year screen (header, result card per state, how it adds up, lines, extras, debts, given card, fixed notes, frozen banner, Start/Close + Undo, Recompute dialog) | `year_screen.dart` | new | `yearViewProvider(key)` → actions; line tap → `ItemDetailScreen(id, frozenNote:)` (AC-21, AC-24) |
| Z4 move, Z5 extra line, Z6 debts, cycle/calendar change sheet (UX 2.8) | `zakat_sheets.dart` | new | `moveBounds`, `validateExtra`, `newCycleFrom` preview |
| Z7 amount given (rate view asked once, inline rate via `showRateDialog(on:)`, C6 line, Delete + Undo) | `gift_sheet.dart` | new | `validateGift`, `giftRateDate`, `counted` |
| Z8 history | `history_screen.dart` | new | `zakatYearsProvider` |
| S8 Zakat section (zakat-year radio via cycle sheet, nisab, cycle date, reminder on/off + days + time, giving-rate view) | `zakat_settings_section.dart` | new | injected into S8 (Z2) |
| Z3 cycle-date control (Month + Day dropdowns, both calendars) | `lib/features/investments/presentation/widgets/fields.dart` `CycleDateField` | changed | — |
| S4 frozen banner | `item_detail_screen.dart` | changed (Z17) | — |
| S8 seam | `assumptions_screen.dart` | changed (Z2) | — |
| S9 sources | `why_builders.dart` `zakatSource` | changed: `A3, A4, A5, A7, A8, B7, B9, C1…C11, Z4` → `src_*` keys | — |
| rate dialog preset date | `rate_history_screen.dart` `showRateDialog(on:)` | changed (Z18) | — |
| tab index constant, seam override | `lib/main.dart` | changed: `static const zakatTab = 2;` `ProviderScope(overrides: [zakatSettingsSectionProvider.overrideWithValue(...)])` | — |

State rules the screens just read (delta (6)): `result.empty` → "Nothing to count yet.", no verdict, no Start (PM-Q1); `!result.complete` → reasons + fix rows, no Start; `z == 0` → action label "Close this year", frozen → settled at once, label "below nisab: no zakat due" (C11); Start/Close only in state `due`. The fixed info line on due/distributing years (delta (4)) is one ARB string, shown under the result card.

---

## 7. Tests (QA owns names; layout here)

- **Unit:** `test/core/dates_test.dart` (hijri helpers), `test/features/investments/domain/portfolio_calculator_test.dart` (`zakatPosition`; `nisabHint` unchanged on existing cases), `item_timeline_test.dart` (`valueDateAt`), `zakat_rules_test.dart` (`pendingQuestion`), **`test/features/zakat/domain/yearly_zakat_test.dart`** (every function in §3.3), **`test/features/zakat/domain/acceptance_test.dart`** (one `test('AC-n …')` per numeric/calendar AC, driving `PortfolioCalculator` + `yearly_zakat.dart` with Yasmin's table from story §11).
- **Data:** `test/core/assumptions/data/drift_assumptions_repository_test.dart` (prefs round trip; `saveZakatCycle` one transaction + replace rule), **`test/features/zakat/data/drift_zakat_repository_test.dart`** (round trip of every field at 20 dp; cascade; `unfreeze` Conflict with a gift; `saveGift` Conflict on an unfrozen year; `freeze` keeps gifts), migration test (§2.2).
- **Widget** (en + ar, in-memory DB, `FakeYearEndReminder`, no network): `test/features/zakat/presentation/{zakat_screen,zakat_setup,year_screen,zakat_sheets,gift_sheet,history_screen,zakat_settings_section}_test.dart`; `test/main_test.dart` — the Zakat tab no longer shows `comingSoon` (only Plan does); with no cycle it shows Z1.
- **Fake:** `test/support/fake_year_end_reminder.dart` — records `schedule`/`cancel`, configurable `permitted`, `launchYearKey`, a `StreamController` for `taps`. `test/support/app_harness.dart` overrides `yearEndReminderProvider` and `zakatSettingsSectionProvider` (as `main.dart` does).
- **Integration:** extend `test/support/golden_path.dart` (shared by `integration_test/golden_path_test.dart` and `test/golden_path_widget_test.dart`) with the story's I path.
- **Architecture** (`test/architecture_test.dart`): `package:hijri` only in `lib/core/dates.dart`; `package:flutter_local_notifications` and `package:timezone` only in `lib/features/zakat/data/local_year_end_reminder.dart`; `lib/features/investments/` imports no `features/(zakat|overview|plan)/`; `lib/features/zakat/` imports no `features/(overview|plan)/` and, from `features/settings/`, only `settings_screen.dart` (the gear every tab shows). Existing rules (no `Timer`, no `double`, domain without Flutter) cover the new files.
- **Words:** `test/l10n/expected_words_test.dart` — AC-41 banned words and the "late/missed/overdue/default" tone ban over every `zakat*`, `reminder*`, `src_C*` key, en and ar.

---

## 8. Localization — key groups (`lib/l10n/app_en.arb`, `app_ar.arb`; generated `app_localizations*.dart` committed)

Every user-facing text is one key, so the consultant's wording changes are ARB-only. Arabic of Shariah texts waits for the consultant (story §13 last line); until then `app_ar.arb` carries the UX doc's Arabic where given and the English text otherwise, marked in the PR.

| Group (prefix) | Content |
|---|---|
| `hijriMonth` | ICU `select` 1–12 (en + ar names from UX 2.2) |
| `zakatSetup*` | Z1 steps z/a/b/c, C1 help (lunar and solar variant), "Not today's date…", calendar line, live next-due card, day-30 and 29-Feb helpers, permission line, denied toast, save error |
| `zakatYearLabel*` | "{n} AH" / "{n}", state chips (`zakatState` select: open/due/distributing/settled/belowNisab) |
| `zakatDue*` | the three C10 due texts; the fixed due/distributing info line (delta (4)); C3 Umm al-Qura line; "Moved from {date}" |
| `reminder*` | C10 notification title/body ("ends today" / "ends on {date}"), days-before field and error "Enter 0 to 60.", time, on/off, preview, past-moment line, "Notifications are off… Open settings" |
| `zakatResult*` | result-card lines per state, "Estimate. Zakat is due on {date}.", "Nothing to count yet.", "Below nisab: no zakat due for this year.", "Zakat can't be worked out yet. {n} things are missing:", fix-row reasons, Start/Close labels + explanation, snackbars + Undo |
| `zakatAdds*` | "How it adds up" rows, "Reaches nisab?" yes/no, rounding why, deduction-off why (C4) |
| `zakatLine*` | "{share} of {amount}", "zakat {amount}", "converted at {rate} on {date}", value date / rate date older than due date (delta (1)), rate missing, question names, "net of {x} interest kept inside", dividends notice + Add cash line (Z-1, Z-Q5), "Deleted from your investments", frozen S4 banner |
| `zakatExtra*` | Z5 kinds, help, good-debt checkbox, doubtful-debt line (B9), "Counted in {year} only." |
| `zakatDebts*` | Z6 title, help, "not deducted", Deduct |
| `zakatGift*` | Z7 fields, date-window error, rate view question + help (C8), "counted at {rate} on {date}", "given before the due date" + C6 line, "Given {x} more than due." + C7 line, C11 line, empty log, progress VoiceOver |
| `zakatRecompute*` | dialog, preview, C9 help |
| `zakatNotes*` | A4, A8, Z-4/C5 fixed notes |
| `zakatHistory*`, `zakatSettings*` | Z8 and S8 rows |
| `src_A3`…`src_C11`, `src_Z4` | new Source strings for `zakatSource` (A4, A5, A7, A8, B9, C1–C11, Z-4) |

---

## 9. Edit batches (accept-edits mode: few, big). Each batch ends `flutter analyze` clean + `flutter test` green.

**Batch 0 — docs (architect/owner, before code).**
- *changed* `docs/adr/0002-project-layout-and-stack.md` — amendment Z1 + Z2 (import rule as it really is, enforced by test). Owner ack.
- *changed* `docs/product/brd.md` §5 non-goals — the one-notification exception (story §15). Owner or orchestrator.

**Batch 1 — dependencies, native setup, core, database** (no UI change)
1. *changed* `pubspec.yaml` — `hijri: 3.0.1`, `flutter_local_notifications: 22.3.1`, `timezone: 0.11.1` (exact pins, ADR-0007/0008); `pubspec.lock`.
2. *changed* `android/app/build.gradle.kts`, `android/app/src/main/AndroidManifest.xml`, `ios/Runner/AppDelegate.swift`; *new* `android/app/src/main/res/raw/keep.xml` — exactly ADR-0008.
3. *changed* `lib/core/dates.dart` — hijri helpers (§3.1).
4. *changed* `lib/core/assumptions/domain/settings.dart` — `NisabMetal`, `GivingRateView`, `ZakatPrefs`, `ZakatCycle`, `Settings.zakat`.
5. *changed* `lib/core/db/tables.dart` (6 settings columns, 5 tables), `lib/core/db/app_database.dart` (v3, `from2To3`). Run `build_runner` then `make-migrations` → *changed* `app_database.g.dart`, `app_database.steps.dart`, `test/core/db/app_database/generated/schema.dart`; *new* `drift_schemas/app_database/drift_schema_v3.json`, `test/core/db/app_database/generated/schema_v3.dart`.
6. *changed* `lib/core/assumptions/domain/assumptions_repository.dart`, `lib/core/assumptions/data/drift_assumptions_repository.dart`, `lib/core/assumptions/assumptions_providers.dart` (`zakatCyclesProvider`), `lib/features/investments/presentation/investments_providers.dart` (`_with` + `zakat`; `zakatSettingsSectionProvider`).
7. Tests: *changed* `test/core/dates_test.dart`, `test/core/assumptions/data/drift_assumptions_repository_test.dart`, `test/core/db/app_database/migration_test.dart`, `test/architecture_test.dart` (all §7 rules).

**Batch 2 — strings + the investments extensions**
1. *changed* `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb` — every §8 key at once; `flutter gen-l10n` → *changed* `app_localizations*.dart`.
2. *changed* `lib/features/investments/domain/{portfolio_calculator.dart, item_timeline.dart, zakat_rules.dart}` — §3.2.
3. *changed* `lib/features/investments/presentation/{why_builders.dart, rate_history_screen.dart, item_detail_screen.dart, assumptions_screen.dart, widgets/fields.dart}` — §6 rows.
4. Tests: *changed* `portfolio_calculator_test.dart`, `item_timeline_test.dart`, `zakat_rules_test.dart`, `why_sheet_test.dart` (new sections), `item_detail_screen_test.dart` (banner), `assumptions_screen_test.dart` (seam off = today's radio; seam on = injected widget), `test/l10n/expected_words_test.dart` (AC-41).

**Batch 3 — zakat domain + data** (no UI)
1. *new* `lib/features/zakat/domain/{zakat_year.dart, yearly_zakat.dart, zakat_repository.dart, year_end_reminder.dart}`.
2. *new* `lib/features/zakat/data/{drift_zakat_repository.dart, local_year_end_reminder.dart}`.
3. *new* tests `test/features/zakat/domain/{yearly_zakat_test.dart, acceptance_test.dart}`, `test/features/zakat/data/drift_zakat_repository_test.dart`, `test/support/fake_year_end_reminder.dart`.

**Batch 4 — zakat screens + wiring**
1. *new* `lib/features/zakat/presentation/{zakat_providers.dart, zakat_setup.dart, year_screen.dart, zakat_sheets.dart, gift_sheet.dart, history_screen.dart, zakat_settings_section.dart}`; *changed* `zakat_screen.dart`.
2. *changed* `lib/main.dart` (zakatTab, seam override).
3. *changed* `test/main_test.dart`, `test/support/app_harness.dart`, `test/support/golden_path.dart`; *new* the seven widget test files of §7.

(`app_localizations*.dart` is regenerated in Batch 2 only; if Batch 4 needs a missing key, add it and regenerate in the same batch.)

---

## 10. AC → file / test

U = `test/features/zakat/domain/acceptance_test.dart` (+ `yearly_zakat_test.dart`); W = widget test in `test/features/zakat/presentation/`; I = golden path.

| AC | Where it is decided | Test |
|---|---|---|
| 1 | `zakat_setup.dart` + `CycleDateField` (31 Apr disabled) | W `zakat_setup_test` |
| 2 | `dueDate` (day 30), `dates.dart` hijri | U; W `year_screen_test` (label, C3 line) |
| 3 | `dueDate` solar, 29 Feb | U |
| 4 | `yearSlots` (first year, open → due by date, next year from D + 1) | U |
| 5 | `moveBounds`; `saveYear` Conflict when frozen | U; W `zakat_sheets_test` |
| 6 | `newCycleFrom`, `saveZakatCycle` replace rule | U; repo test; W (applies-from text) |
| 7 | `compute` nisab; Z1 step a | U; W `zakat_setup_test` |
| 8 | `compute` `Missing.metalRate` | U; W |
| 9 | `zakatPosition` + `compute` (Σ 520,000.00, B 500,000.00, Z 12,500.00; `days` never read) | U; W; I |
| 10 | `ZakatYear.solar.r` in `compute` | U |
| 11 | `zakatPosition(on)` (value and rate ≤ D; market value) | U; W (rate text) |
| 12 | `compute` `Missing.rate` (two lines named) | U; W |
| 13 | `zakatPosition` start/closed filter; 0 % line kept | U |
| 14 | `netValueAt` in `zakatPosition` | U |
| 15 | `resolve` share 0 + notice; no income added | U; W |
| 16 | `pendingQuestion` → `Missing.question` | U; W |
| 17 | `validateExtra`; extras per year record | U |
| 18 | `compute` debts on/off, B ≥ 0 | U; W |
| 19 | `compute` below/at nisab | U; W (A4, A8, C5 notes) |
| 20 | Z3 (derived years), no default for nisab/cycle/view, `unfreeze` only by user | U (no write on read: row counts before = after); arch test |
| 21 | `year_screen` line tap → `ItemDetailScreen`; live provider | W; I |
| 22 | `zakatSource` sections, `[U]` text | W `year_screen_test` |
| 23 | `stateOf`, `YearResult.canStart`, `empty` | U; W |
| 24 | `frozenInputs` (Z10) | U; W; I |
| 25 | `freeze` (recompute) keeps gifts | U |
| 26 | `progress`, `stateOf`, `validateGift`, `saveGift` Conflict when not frozen | U; repo test; W; I |
| 27 | `progress` after recompute; C7 text | U |
| 28 | `earliestGiftDate` (Z12), `givenEarly` | U; W |
| 29 | `progress.over` | U; W |
| 30 | `giftRateDate`, `counted`, rate view asked once | U; W `gift_sheet_test`; I |
| 31 | `canStart` with Z = 0, "Close this year", settled at once | U; W |
| 32 | `zakatYearsProvider` order (newest due first), labels | U; W `history_screen_test`; I |
| 33 | `YearView` fields (moved + computed due, entries) | W; I |
| 34 | `ZakatActions.saveCycle` asks once (`reminderAsked`) | W (fake records calls); I |
| 35 | `reminderPlan` + C10 ARB texts; no network (harness) | U; W |
| 36 | `zakat_screen.dart` launch/taps routing | W (fake `launchYearKey`, `taps`); I |
| 37 | `reminderPlan` on move/days/time; not on cycle change; one id | U; W |
| 38 | `reminderPlan(permitted: false)` | U; W |
| 39 | due texts from `YearView.state == due` + result | U; W |
| 40 | `reminderPlan` days 3 at 20:30; bounds 0–60; past moment | U; W |
| 41 | ARB scan | `test/l10n/expected_words_test.dart` |
| 42 | `showRateDialog(on:)` + `saveTypedRate`; `counted`; frozen base | W `gift_sheet_test`; U |
| 43 | Z15 SnackBar 10 s; `unfreeze` Conflict with a gift | W (`pump(11 s)` → no Undo); repo test |
| 44 | `reminderOn` in `reminderPlan` | U; W |

### Untestable or contradictory

- **AC-35 / AC-36 / AC-37 on a real phone** — CI proves the *request* (time, text, payload) against the fake. That the OS shows it at 09:00 and that a real tap opens the year is outside `flutter test`; on Android with inexact scheduling the delivery time is the OS's (Q-N1). The done gate's one manual simulator run should include it once.
- **Same label twice (story §4 "Label", §10, AC-32)** — a cycle change that moves the date later in the same Hijri/Gregorian year (e.g. open 1448 AH on 1 Ramadan → new cycle 1 Shawwal) creates a second "1448 AH". The story's label rule cannot tell them apart. The code keys by due date (Z4), so nothing breaks; only the text is ambiguous (Q-P1).
- **AC-20 "never creates a year"** is read as "never stores one". Years appear by date (AC-4 requires it); nothing is written.
- **Story §5.4 "if the year is already distributing at the fire moment, none is shown"** — met by cancelling when the year is started (the app knows only "now", not the future). A year started from another device does not exist in v1.
- **AC-34 on Android ≤ 12** there is no prompt at all; "asked once" is vacuous there (test runs against the fake).

---

## 11. Questions for the owner (product only)

- **Q-N1 — Android reminder time.** With no extra permission, Android may show the reminder later than the chosen time (iOS is exact). Exact timing needs a second permission that the user grants on a system settings page. Accept "around the chosen time" on Android? (Recommended: yes.)
- **Q-P1 — Two years with the same label.** After a cycle change later in the same year, two years can both read "1448 AH" (or "2027"). Show the due date next to the label in History and on the year screen (it is already on both), or add a suffix? (Recommended: no suffix; the due date already shows.)
