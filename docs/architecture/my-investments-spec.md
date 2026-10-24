# Implementation spec — My Investments

**Owner:** architect · **Status:** v1 · 2026-10-16 · 2026-10-17: §12 added (Expected vs actual + Private equity, AC-46…AC-67)
**Inputs:** [story](../product/stories/my-investments.md) (frozen, AC-1…AC-44 + AC-19b; §5.5, §5.6, AC-45…AC-67 added 2026-10-17) · [zakat file](../product/shariah/zakat-on-investments.md) · [UX flow](../product/ux/my-investments.md) (loop 1 accepted) · ADR-[0001](../adr/0001-data-access-behind-repositories.md), [0002](../adr/0002-project-layout-and-stack.md), [0003](../adr/0003-rate-refresh-source.md), [0004](../adr/0004-shipped-inflation-data.md)
**Pending upstream:** PM is adding a worked number to AC-5 (dividends-only set-aside). The formula below already follows the consultant's rule; only the test value is pending.

Rule of this spec: the engine is pure Dart and holds almost all logic and tests. Repositories store and stream; screens display engine output. Nothing is cached until a measurement says so.

---

## 1. Decisions that shape the code

| # | Decision | Why |
|---|---|---|
| D1 | **Engine recomputes from full history in memory** on every change. Repositories stream whole aggregates; no SQL aggregation. | Personal data is small. Budget, enforced by a phase-2 test: 50 items × 10 years × ~2 entries/month (≈12k entries) + 2k rates → the 12-month and all-years lists of S7 compute in < 200 ms on the CI host. Over budget → revisit (memoise per period), not before. |
| D2 | **Decimal stored as TEXT** in SQLite via one Drift `TypeConverter<Decimal, String>`. Dates (calendar days) stored as TEXT `yyyy-MM-dd`; `createdAt`/`updatedAt` as Drift `DateTime` in UTC. | Verified: SQLite REAL gives `1.10*3 = 3.3000000000000003`. Text dates sort correctly and have no time zone. |
| D3 | **Calendar dates are `DateTime.utc(y, m, d)`** everywhere in domain code; `core/dates.dart` is the only place that builds them (`day(y,m,d)`, `today(clock)`, `daysBetween`, `endOfMonth`, `endOfYear`, `daysInYear`). No new date type. | Day counts (`E − t`, T) must not shift with DST; UTC midnight gives that without a class. |
| D4 | **Division** goes through `divide(a, b)` in `core/money/decimal_math.dart` (`(a / b).toDecimal(scaleOnInfinitePrecision: 20)`). Display rounding (2 dp, half-up) happens only in `format.dart`. | `decimal` returns `Rational` on division; one place picks the scale. Tests compare full precision within 0.005 (story §10). |
| D5 | **Fractional powers** (annualised return, period inflation `(1+π)^(d/D)`) use `powRatio(Decimal base, Decimal exponent)`, which computes through `double` and returns a `Decimal` parsed from 15 significant digits. This is the **only** `double` in `lib/` and it never touches an amount of money — inputs and output are growth factors. | `decimal` has integer `pow` only. Error ≈ 1e-15 relative vs a test tolerance of 5e-5. Verified: AC-14 → 0.786 %, AC-34 → 2.386 %. Rejected: our own Decimal `ln`/`exp` series — ~40 lines of numeric code to test for no visible gain. The architecture test allows `double` only in `decimal_math.dart`. |
| D6 | **`Unit` is a Dart extension type** over `String` (`USD`, `EGP`, `XAU-g`, `XAG-g`); **`Money`** is a small final class `(Decimal amount, Unit unit)` with `==`. No other value objects. | Both have real invariants used everywhere (unit equality, metal check, never adding two units). Everything else is plain fields. |
| D7 | **Zakat share is resolved at calculation time** from the item's stored `ZakatRule` + current settings. Only `custom` stores a number. | If the user changes the portfolio long-term method or jewellery ruling, items that follow it change too, and the why sheet can always name the rule (UX §8.1). |
| D8 | **One history table** for money in, money out, interest records and value updates (`history_entries`, `kind` column), one sealed Dart type. | It mirrors S4 (one history list) and S5 (one sheet); one stream, one ordering. |
| D9 | **Rate cross at fetch time** (ADR-0003); **no chaining at lookup** (story Q6). | Privacy-neutral fixed request + gold in non-USD bases. |
| D10 | **Current period ends today:** a period's E = min(period end, today). Future days never count in T. | "2026 so far" (UX S2); otherwise a mid-year set-aside would be charged for days not yet lived. Listed for PM confirmation (Q-5). |
| D11 | **Tests mirror `lib/` under `test/`** (`lib/a/b.dart` → `test/a/b_test.dart`), not literally next to the file. | `flutter_test` is a dev dependency; test files inside `lib/` would be compiled as app code and break `flutter analyze`/release builds. Same intent as CLAUDE.md ("next to the file"): one test file per source file, same path. Owner may object. |

---

## 2. Domain model

### 2.1 Reference data — `lib/core/reference/`

- `units.dart` — `extension type const Unit(String code)` with `isMetal`, consts `xauG = Unit('XAU-g')`, `xagG`; `v1Currencies` (32, sorted by code): AED, AUD, BDT, BHD, CAD, CHF, CNY, DKK, DZD, EGP, EUR, GBP, HKD, IDR, INR, JOD, JPY, KWD, MAD, MYR, NGN, NOK, OMR, PKR, QAR, SAR, SEK, SGD, TND, TRY, USD, ZAR (PM added SEK/NOK/DKK, story §6.3; all quoted by the ADR-0003 source and all have World Bank data, re-checked 2026-10-16). `allUnits` = currencies + XAU-g + XAG-g, one unmodifiable list sorted by code. `Country defaultCountryOf(Unit)` (EUR → `EMU`). `List<Unit> orderedUnits({required Map<Unit,int> usage, required Unit topAnchor})` — story §6.3; `topAnchor` = base, or region currency before setup.
- `markets.dart` — `enum Market(country, currency)`: tadawul(SAU, SAR), egx(EGY, EGP), nasdaq(USA, USD), nyse(USA, USD), lse(GBR, GBP), dfm(ARE, AED), adx(ARE, AED), boursaKuwait(KWT, KWD), qse(QAT, QAR), bursaMalaysia(MYS, MYR), bist(TUR, TRY), psx(PAK, PKR), other (country stored on the investment).
- `countries.dart` — `extension type const Country(String iso3)`; the 32 codes of ADR-0004.

Names (en/ar) of units, countries and markets are ICU `select` messages in the ARB files (§7), not Dart maps.

### 2.2 Assumptions — `lib/core/assumptions/domain/`

```dart
enum RateSource { typed, currencyApi }
final class Rate { String id; Unit from; Unit to; Decimal rate; DateTime asOf; RateSource source; DateTime createdAt, updatedAt; }

final class RateQuote { Decimal rate; DateTime asOf; RateSource source; bool inverted; }
final class RateBook {                       // pure; built from List<Rate>
  RateQuote? quote(Unit from, Unit to, DateTime on);   // identity → 1; latest asOf ≤ on over direct + inverse; same date: typed beats fetched, direct beats inverse
  Money? convert(Money m, Unit to, DateTime on);       // null = missing
}

enum ZakatYear { lunar(r: '0.025', days: '354.367'), solar(r: '0.02577', days: '365') }   // AC-9 by construction
enum LongTermMethod { dividendsOnly, proxy25, fullValue, perItem }
final class Settings {
  Unit? baseCurrency; Country? homeInflation;          // null home → defaultCountryOf(base)
  ZakatYear? zakatYear; LongTermMethod? longTermMethod; bool? jewelleryZakatable;   // null = not answered yet (AC-8)
  bool get setupDone => baseCurrency != null && zakatYear != null;
}

enum InflationProvenance { shipped, user, assumed }
final class YearInflation { Decimal rate; int year; InflationProvenance provenance; int? assumedFrom; }
final class PeriodInflation { Decimal i; List<YearInflation> years; }
final class ShippedInflation { String source; String asOfNote; Map<Country, Map<int, Decimal>> series; static ShippedInflation parse(String json); }
final class InflationOverride { String id; Country country; int year; Decimal rate; DateTime createdAt, updatedAt; }
// All inflation rates in the domain are fractions (0.10 = 10 %). ShippedInflation.parse converts the asset's percent strings once; the UI converts typed percents.
final class InflationBook {                          // pure
  InflationBook(ShippedInflation shipped, List<InflationOverride> overrides);
  YearInflation? forYear(Country c, int year);       // override → shipped → latest earlier year (assumed) → null (AC-32, AC-33)
  PeriodInflation? forPeriod(Country c, DateTime s, DateTime e);   // story §8.2 (AC-34); null if any year is null
}
```

### 2.3 Investments — `lib/features/investments/domain/`

```dart
enum AssetType { stock, fund, sukuk, gold, silver, cashDeposit, crypto, other }
enum Intent { trading, longTerm, personalUse, rental }
enum ZakatRule {          // what the user chose; resolved with Settings (D7)
  cash100, bullion100, jewelleryPerSetting, trading100, longTermPerSetting,
  longTermDividendsOnly, longTermProxy25, longTermFullValue, sukuk100, crypto100,
  companyPaysZakat, custom }

final class Investment {
  String id; String name; AssetType type; Intent? intent;
  Market? market; Country? marketCountry;             // marketCountry only when market == other
  Unit unit; DateTime startDate;
  Decimal? quantity;                                   // non-metal display + price×qty helper only
  int? purityKarat; int? purityFineness;               // metals
  ZakatRule zakatRule; Decimal? customZakatShare;      // 0..1, only for custom
  Country? inflationOverride; String? notes;
  DateTime createdAt, updatedAt;
}

sealed class HistoryEntry { String id; String investmentId; DateTime date; DateTime createdAt, updatedAt; }
final class MoneyIn  extends HistoryEntry { Money amount; }
enum MoneyOutKind { sale, income }
final class MoneyOut extends HistoryEntry { Money amount; MoneyOutKind kind; }
enum InterestKind { keptInside, paidOut, givenAwayFromInside, givenAwayFromPaidOut }
final class InterestRecord extends HistoryEntry { Money amount; InterestKind kind; }
final class ValueUpdate extends HistoryEntry { Decimal value; }   // item unit; metals: pure grams

final class InvestmentWithHistory { Investment investment; List<HistoryEntry> history; }   // the aggregate
```

Gold/silver: unit is XAU-g / XAG-g; every value is pure grams (`grams × karat ÷ 24`, silver `× fineness ÷ 1000`). The form converts gross grams once; `quantity` stays null for metals (one source of truth).

A "value left" or "value after" in S5 is saved as a `ValueUpdate` on the same date as the flow, in the same repository call.

### 2.4 Validation and zakat defaults

- `investment_draft.dart` — `InvestmentDraft` (all fields nullable, plus `firstPaid: Money?`, `currentValue: Decimal?`, `grossGrams: Decimal?`) and `List<DraftError> validate(InvestmentDraft, {required DateTime today, required Settings settings})`; `DraftError` is an enum per field + `zeroAmount`, `futureDate`, `shareRequired`, `answerLongTermMethod`, `answerJewellery`. Covers AC-1, AC-2, AC-7, AC-8.
- `zakat_rules.dart`
  - `ZakatRule? defaultRule(AssetType, Intent?, Settings)` — null means "must ask" (story §5.1).
  - `ResolvedZakat resolve(Investment, Settings)` → `{Decimal share, bool onDividends, ZakatNotice? notice, String sourceSection}`; `notice` ∈ {dividendsCountedWithCash (AC-5), cryptoDisputed (AC-6)}; `sourceSection` = zakat-file anchor for the why sheet (A9), e.g. `B3`.

### 2.5 The calculation engine (pure Dart, no Flutter import)

`lib/core/money/decimal_math.dart` — `divide`, `powRatio` (D4, D5).

`lib/features/investments/domain/formulas.dart` — stateless functions, one per story formula; every AC with a number tests these first.

```dart
final class Flow { DateTime date; Decimal amount; }            // + in, − out, one unit
final class DietzResult { Decimal bv, ev, cf, d; Decimal? r; }  // r null when d ≤ 0 (AC-41)
DietzResult modifiedDietz({required Decimal bv, required Decimal ev, required List<Flow> flows, required DateTime s, required DateTime e});
Decimal setAside({required ZakatYear year, required Decimal share, required Decimal ev, required int days, required Decimal dividends, required bool noZakatYear});
        // r×s×ev×days/Y + r×dividends; 0 if noZakatYear (§9.4, AC-5, AC-18)
Decimal? afterSetAsideReturn(DietzResult dz, Decimal z);         // (EV−BV−CF−Z)/D
Decimal real(Decimal r, Decimal i);                              // (1+r)/(1+i)−1
Decimal? annualised(Decimal r, int days);                        // null if days < 365 or 1+r ≤ 0 (AC-11)
final class PurchasingPower { Decimal neededEnd; Decimal? neededReturn; Decimal gap; bool kept; }
PurchasingPower? purchasingPower(DietzResult dz, Decimal z, Decimal i);   // §9.6; null if d ≤ 0
```

`item_timeline.dart` — `ItemTimeline(InvestmentWithHistory, RateBook)`; all results in item unit:
- `Decimal recordedValueAt(DateTime d)` — replay in date order: `ValueUpdate` sets; `MoneyIn` adds (converted at its date) unless a value update on that day; `MoneyOut` subtracts likewise; `InterestRecord.givenAwayFromInside` subtracts; `keptInside` adds (see Q-1).
- `Decimal heldInterestAt(d)` (H), `Decimal netValueAt(d) = recorded − H` (§5.4).
- `List<Flow> flowsIn(s, e)` (money in +, money out −; interest never), `Decimal incomeIn(s, e)`.
- `Money toPurifyAt(d)` — all interest − all given away (both places) (AC-19, AC-19b).
- `bool activeIn(s, e)` — a value update or flow in (s, e] (§9.3); `bool closedAt(d)`; `DateTime latestValueDate`.
- Missing conversion of a flow into item unit (needs a rate on the flow date) → `MissingRate(pair, date)` collected, never 1:1.

`period.dart` — `enum Granularity { month, year }`; `final class Period { DateTime s, e; }` with `Period.month(y, m, today)`, `Period.year(y, today)` (D10); the since-start period is built inside `PortfolioCalculator.sinceStart(id)` (no `Period.sinceStart`); `List<Period> periodsBetween(DateTime first, DateTime today, Granularity)`.

`portfolio_calculator.dart` — composes the above. Built once per data change:

```dart
enum ViewUnit { base, goldGrams, silverGrams }
final class PortfolioCalculator {
  PortfolioCalculator({required List<InvestmentWithHistory> items, required RateBook rates, required InflationBook inflation,
                       required Settings settings, required Set<int> noZakatYears, required DateTime today});
  ItemFigures item(String id, Period p);             // item unit + base: dietz, Z, Rz, i (own series and home), reals, PP, markers
  PortfolioFigures portfolio(Period p, ViewUnit view);   // base or grams: summed BV/EV/flows → one dietz; Z = ΣZ_item; i home; PP; markers
  SinceStartFigures sinceStart(String id);           // gain, simple ROI, since-start R, annualised, Z/Rz/reals over held period (§9.2)
  Map<Unit,int> unitUsage();                         // for orderedUnits (AC-42…44)
  StaleNow staleNow();                               // calendar month of today (§9.3, UX S2/S6)
}
```

Rules inside, each one test-named after its AC:
- **Base conversion:** BV at S, each flow at its date, EV and Z at E (§6.1). A missing rate removes the item from that period's base totals → `ItemFigures.excluded` = one `Excluded(itemId, from, to, date)`, the first missing pair (AC-21); only conversions dated on or before E count. A closing rate dated ≤ S → `StaleRate` marker (AC-22).
- **Item set-aside** in item unit with `resolve(item).share`; dividend part = r × base income in (S, E] when `onDividends`, no T/Y factor; value part converted at E (§9.4, Z-7).
- **Series per item:** `inflationOverride` → market country (stock; fund/sukuk with market) → home (metals) → `defaultCountryOf(unit)` (AC-31). Home = `settings.homeInflation ?? defaultCountryOf(base)`.
- **Grams view:** convert base BV at S, flows at their dates, EV and Z at E by the XAU-g/XAG-g→base rate; i = 0; no real figures; label flag (AC-39). A missing metal rate → the grams view is unavailable for that period, with the pair named.
- **Since-start with no-zakat years:** set-aside × (days in years without the switch ÷ T) (Q-3).
- **Markers:** `staleValues` (count + ids), `staleRate`, `excluded`, `inflation` provenance (shipped/user/assumedFrom/empty), `notAvailable` (D ≤ 0).

Every figures object keeps its inputs (BV, EV, CF, D, each flow with weight, each rate with date and source, each inflation year with provenance, zakat rule + section) so the why sheet (S9) formats "your numbers" without recomputing.

---

## 3. Drift schema — `lib/core/db/`

`app_database.dart` (the `AppDatabase`, `schemaVersion = 1`, `MigrationStrategy(onCreate: m.createAll)`), `tables.dart`, `converters.dart` (Decimal ↔ TEXT, calendar date ↔ TEXT), generated `app_database.g.dart` (committed). Every table: `id TEXT PK` (UUID v4 from `newId()`), `created_at`, `updated_at` (UTC), per ADR-0001.

| Table | Columns (besides id/created_at/updated_at) | Keys / indexes |
|---|---|---|
| `investments` | name, asset_type, intent?, market?, market_country?, unit, start_date, quantity?, purity_karat?, purity_fineness?, zakat_rule, custom_zakat_share?, inflation_override?, notes? | — |
| `history_entries` | investment_id → investments.id **ON DELETE CASCADE**, kind (`money_in`, `sale`, `income`, `interest_kept_inside`, `interest_paid_out`, `interest_given_away_inside`, `interest_given_away_paid_out`, `value_update`), date, amount, unit? (null for value_update) | index (investment_id, date); unique (investment_id, date) where kind = 'value_update' (partial index via `customStatement` in `onCreate`) |
| `rates` | from_unit, to_unit, rate, as_of, source (`typed` / `currency_api`) | index (from_unit, to_unit, as_of); unique (from_unit, to_unit, as_of, source) — one typed and one fetched per pair-day |
| `inflation_overrides` | country, year, rate (fraction, TEXT) | unique (country, year) |
| `settings` | singleton row (id = `'settings'`): base_currency?, home_inflation?, zakat_year?, long_term_method?, jewellery_zakatable? | — |
| `no_zakat_years` | year | unique (year) |

`PRAGMA foreign_keys = ON` in `beforeOpen`. Opened on device with `driftDatabase(name: 'financial_planner', native: DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory))`; in tests with `AppDatabase(NativeDatabase.memory())`.

---

## 4. Repositories (ADR-0001)

Errors next to each interface: `NotFound`, `Conflict`, `StorageUnavailable`; implementations map `SqliteException`/`DriftWrappedException` to them.

**Ids and timestamps.** Domain constructors default `id` to `newId()` and `createdAt`/`updatedAt` to the 1970 epoch (a placeholder only). Repositories own the timestamps: on insert both = clock (UTC); on update `updatedAt` = clock and `createdAt` is kept from the row; row → domain mapping always passes `id`, `createdAt`, `updatedAt`. A phase-2 test asserts no stored row has a 1970 timestamp.

`lib/features/investments/domain/investments_repository.dart`

```dart
abstract interface class InvestmentsRepository {
  Stream<List<InvestmentWithHistory>> watchAll();
  Future<void> create(Investment item, List<HistoryEntry> initial);   // one transaction: item + first money in + first value update
  Future<void> update(Investment item);
  Future<void> delete(String id);                                     // cascade
  Future<void> restore(InvestmentWithHistory aggregate);              // Undo after delete
  Future<void> saveEntries(List<HistoryEntry> entries);               // insert or replace by id; one transaction (S5 flow + value left; S6 values)
  Future<void> deleteEntry(String id);
}
```
Impl: `lib/features/investments/data/drift_investments_repository.dart` — `watchAll` = one Drift `watch()` on `investments` LEFT JOIN `history_entries`, ordered by (investment_id, date, created_at), grouped into aggregates in Dart. No extra stream library.

`lib/core/assumptions/domain/assumptions_repository.dart`

```dart
abstract interface class AssumptionsRepository {
  Stream<List<Rate>> watchRates();
  Future<void> saveTypedRate(Rate rate);            // upsert on (from, to, asOf, typed)
  Future<int> saveFetchedRates(List<Rate> rates);    // one transaction; skips existing (pair, asOf, currency_api); returns inserted count
  Future<void> deleteRate(String id);
  Stream<List<InflationOverride>> watchInflationOverrides();
  Future<void> setInflationOverride(Country c, int year, Decimal rate);
  Future<void> clearInflationOverride(Country c, int year);
  Stream<Settings> watchSettings();
  Future<void> saveSettings(Settings s);
  Stream<Set<int>> watchNoZakatYears();
  Future<void> setNoZakatYear(int year, {required bool noZakat});
}
```
Impl: `lib/core/assumptions/data/drift_assumptions_repository.dart`.

`lib/core/assumptions/data/rate_refresher.dart` — **not** a repository (ADR-0001's exception is not extended): `RateRefresher(http.Client, AssumptionsRepository, DateTime Function() now)`, `Future<RefreshResult> refresh(Set<(Unit, Unit)> neededPairs)`; `RefreshResult` = `succeeded(asOf, inserted, notCovered)` | `failed(reason)`. Request per ADR-0003; pair filtering happens after download.

`lib/core/assumptions/shipped_inflation_loader.dart` — `Future<ShippedInflation> loadShippedInflation(AssetBundle)`.

---

## 5. Providers (Riverpod 3, no codegen, co-located)

| File | Providers |
|---|---|
| `lib/core/clock_provider.dart` | `clockProvider` (`DateTime Function()`), overridden in tests |
| `lib/core/db/database_provider.dart` | `appDatabaseProvider` (`ref.onDispose(db.close)`; tests override with in-memory) |
| `lib/core/assumptions/assumptions_providers.dart` | `assumptionsRepositoryProvider`, `ratesProvider` (Stream), `rateBookProvider`, `settingsProvider` (Stream), `noZakatYearsProvider` (Stream), `shippedInflationProvider` (Future), `inflationBookProvider`, `httpClientProvider`, `rateRefresherProvider`, `refreshControllerProvider` (`Notifier<RefreshState>`: idle / running / succeeded / failed — S6/S8 card) |
| `lib/features/investments/presentation/investments_providers.dart` | `investmentsRepositoryProvider`, `investmentsProvider` (Stream), `calculatorProvider` (combines the streams above + clock → `AsyncValue<PortfolioCalculator>`), `portfolioFiguresProvider.family((Period, ViewUnit))`, `itemFiguresProvider.family((String, Period))`, `sinceStartProvider.family(String)`, `unitOrderProvider` |

Writes: widgets call repository methods via `ref.read(...)`; streams refresh the screens. No per-screen notifiers except `refreshControllerProvider`. Form state is local `StatefulWidget` state.

---

## 6. Presentation — `lib/features/investments/presentation/` (UX doc, loop 1)

| UX | File | Route kind | Engine/provider it reads |
|---|---|---|---|
| S1 Setup (2 steps: base + home inflation; zakat year + long-term method) | `setup_screen.dart` | root when `!settings.setupDone` | settings, unit order |
| S2 Home (stale banner / up-to-date line, list, sort; actions: Settings) | `home_screen.dart` | root | portfolio(year, view), sinceStart per item, staleNow |
| S3 Investment form (add/edit, fields per type, intent → zakat line, inline rate, price × qty) | `investment_form_screen.dart` | push (fullscreenDialog) | validate, defaultRule, resolve |
| S4 Item detail (since-start card, zakat line, history) | `item_detail_screen.dart` | push | sinceStart, resolve |
| S5 Record sheet (money in / money out / value update / interest) | `record_sheet.dart` | bottom sheet | timeline value for typo check |
| S6 Update all (refresh card, as-of date, stale rates + values, one Save) | `update_all_screen.dart` | push | staleNow, refreshController |
| S7 Period view (scope, month/year, grams toggle, ladder, verdict, markers, items, excluded, other periods, no-zakat switch + nisab hint) | `period_screen.dart` | push | portfolio/item figures, periodsBetween |
| S8 Assumptions (+ pair history, series years) | `assumptions_screen.dart`, `rate_history_screen.dart`, `inflation_series_screen.dart` | push from Settings | rates, inflation book, settings |
| Settings (hub: Assumptions ›, AI) | `features/settings/settings_screen.dart` | push from the gear on every tab | settings, AI settings |
| S9 Why sheet | `why_sheet.dart` | bottom sheet | the figures object passed in |
| Shared | `widgets/unit_picker_sheet.dart`, `widgets/inline_rate_entry.dart`, `widgets/figure_text.dart` (number + marker + tap → S9) | | |

Number formatting: `lib/core/money/format.dart` — `formatAmount(Decimal, Locale, {int digits = 2})`, `formatPercent`, `formatGrams`; rounds the Decimal, groups with the locale's `NumberSymbols` (from `intl`) and its digits, never converts to `double`; wraps output in Unicode isolates (U+2066…U+2069) so "+15.50 %" stays LTR inside Arabic text (UX §6).

Nisab hint (UX 2.10 step 7, consultant answer (b)): `85 g × XAU-g→base` and `595 g × XAG-g→base` via `RateBook`, plus Σ(value × share) from the calculator. No AC yet (Q-6).

---

## 7. Localization

- `l10n.yaml` (`arb-dir: lib/l10n`, `template-arb-file: app_en.arb`, `output-localization-file: app_localizations.dart`), `generate: true` in `pubspec.yaml`, generated output committed with the ARB files.
- `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`. Every user-facing string, including the Shariah-required labels (AC-18, AC-35, AC-39, §9.4 label) as single keys so a test can assert them.
- Unit / country / market names: one ICU `select` message each (`unitName(code)`, `countryName(iso3)`, `marketName(id)`).
- Zakat references ("IIFA Res 28 (3/4) §3", "[U] source not yet verified") are ARB strings, kept verbatim in both languages.
- `MaterialApp(supportedLocales: [en, ar], localizationsDelegates: AppLocalizations.localizationsDelegates)`; RTL comes from the locale. One widget test per screen runs in `ar` and checks no overflow.

---

## 8. Build order — each phase ends with `flutter analyze` clean and `flutter test` green

**Phase 0 — skeleton** (no AC)
- Modify `pubspec.yaml` (ADR-0002 deps, `generate: true`, asset path), `analysis_options.yaml` (add `prefer_final_locals`, `avoid_print`; `depend_on_referenced_packages` stays on), `lib/main.dart` (replace counter: `ProviderScope` + `MaterialApp` with l10n and an empty Home), `test/widget_test.dart` → delete; create `l10n.yaml`, `lib/l10n/app_en.arb`, `app_ar.arb`, `test/architecture_test.dart` (drift/http/double import rules, ADR-0002), `test/main_test.dart` (app boots in en and ar).
- CI check that no `*.sqlite`/`*.db` is tracked (CLAUDE.md) — add to the existing CI workflow if one exists, else a step in this phase's PR.

**Phase 1 — domain + engine + unit tests** (most ACs)
- Create: `lib/core/money/{money.dart, decimal_math.dart}`, `lib/core/dates.dart`, `lib/core/ids.dart`, `lib/core/reference/{units.dart, markets.dart, countries.dart}`, `lib/core/assumptions/domain/{rate.dart, rate_book.dart, settings.dart, inflation.dart}` (Rate/RateBook; Settings/ZakatYear/LongTermMethod; ShippedInflation/InflationOverride/InflationBook), `lib/features/investments/domain/{investment.dart, history_entry.dart, investment_draft.dart, zakat_rules.dart, formulas.dart, item_timeline.dart, period.dart, portfolio_calculator.dart}`; matching `test/**/_test.dart`; `test/features/investments/domain/acceptance_test.dart` — one `test('AC-n …')` per numeric AC driving `PortfolioCalculator` end to end with in-memory domain objects.
- Covers: AC-1, 2, 3, 4, 5 (rule + formula; number when PM lands it), 6, 7, 9, 10–24, 28, 31, 32 (book logic), 33, 34, 36, 37, 38, 39 (figures), 40, 41, 42, 43, 44.

**Phase 2 — Drift + repositories**
- Create: `lib/core/db/{tables.dart, converters.dart, app_database.dart, app_database.g.dart, database_provider.dart}`, `lib/core/clock_provider.dart`, `lib/features/investments/domain/investments_repository.dart`, `lib/features/investments/data/drift_investments_repository.dart`, `lib/core/assumptions/domain/assumptions_repository.dart`, `lib/core/assumptions/data/drift_assumptions_repository.dart`; tests on `NativeDatabase.memory()` incl. round-trip of every Decimal at 20 dp, cascade delete, value-update uniqueness, typed-vs-fetched uniqueness, override survives a changed shipped asset, and the D1 performance budget test.
- Covers: AC-3, AC-4 (persisted), AC-28 (both rows kept), AC-32 (override storage and removal).

**Phase 3 — rate refresh + shipped inflation**
- Create: `lib/core/assumptions/data/rate_refresher.dart`, `lib/core/assumptions/shipped_inflation_loader.dart`, `lib/core/assumptions/assumptions_providers.dart`, `tool/gen_inflation.dart`, `assets/inflation/cpi_annual.json` (generated, committed), `test/fixtures/currency_api_usd.json` (a trimmed real response); tests with `http/testing.dart` `MockClient`.
- Covers: AC-25 (no client use outside `refresh`), AC-26 (captured request identical for two different user datasets), AC-27 (asOf from body, clock set to another day), AC-29 (both URLs fail → zero writes), AC-30, AC-32 (shipped "as of" shown from the asset).

**Phase 4 — screens + widget tests**
- Create the §6 files + `investments_providers.dart`, `lib/core/money/format.dart`; modify `lib/main.dart` (root = Setup or Home), ARB files. One widget test file per screen (en + ar), all on in-memory DB and a `MockClient` that fails the test if called unexpectedly.
- Covers: AC-1 and AC-2 (fields named inline, no future dates), AC-5/AC-6 (notices), AC-8 (setup and first long-term stock), AC-18 (switch help text), AC-21 (excluded line), AC-22 (stale marker), AC-29 (failure message, figures unchanged), AC-35, AC-39 (label), AC-42–44 (picker widget order).

**Phase 5 — golden path integration test**
- Create `integration_test/golden_path_test.dart`: setup (EGP, lunar, long-term = proxy 25 %) → add Fund A (AC-12 data) → record money in 4,000 → Update all with a fake refresh client → April 2026 period view shows 4.21 % / 30.69 set-aside per AC-12/AC-14 → app run asserts zero unexpected HTTP calls (AC-25). Runs on simulator in CI; the same flow also runs headless as `test/golden_path_widget_test.dart` so every PR exercises it.

---

## 9. AC → phase → layer

| AC | Phase | Layer |
|---|---|---|
| 1 | 1, 4 | `investment_draft.validate`; S3 inline errors |
| 2 | 1, 4 | `validate`; S3 date picker |
| 3 | 1, 2 | `ItemTimeline.recordedValueAt`; history storage |
| 4 | 1, 2 | `ItemTimeline.closedAt`, `periodsBetween`; storage |
| 5 | 1, 4 | `zakat_rules.resolve` + `setAside` dividend part; S3/S4 notice |
| 6 | 1, 4 | `defaultRule` (crypto100) + notice; S3 |
| 7 | 1 | `validate` (`shareRequired`) |
| 8 | 4 | S1 + S3 gating (`answerLongTermMethod`) |
| 9 | 1 | `ZakatYear` enum (pair by construction) |
| 10, 11 | 1 | `sinceStart`, `annualised` |
| 12, 13 | 1 | `modifiedDietz`, `portfolio` |
| 14 | 1 | `setAside`, `InflationBook.forPeriod`, `real` |
| 15, 16, 17 | 1 | `setAside`, `purchasingPower` |
| 18 | 1, 4 | `setAside(noZakatYear)`; S7/S8 help text |
| 19, 19b | 1 | `ItemTimeline` (H, toPurify) |
| 20 | 1 | `portfolio` (convert then deflate by home), item own-market real |
| 21 | 1, 4 | `Excluded` marker; S2/S7 line |
| 22 | 1, 4 | `RateBook.quote` + `StaleRate`; marker text |
| 23 | 1 | `RateBook` inverse |
| 24 | 1 | `RateBook.convert` at start date |
| 25 | 3, 5 | `RateRefresher` only on call; golden path asserts no calls |
| 26 | 3 | fixed URL, captured request |
| 27 | 3 | asOf from body |
| 28 | 1, 2 | typed beats fetched in `RateBook`; both rows kept |
| 29 | 3, 4 | zero writes on failure; S6 message |
| 30 | 3 | ounce → pure gram conversion |
| 31 | 1 | series resolution in calculator |
| 32 | 1, 2, 3 | `InflationBook` order; override table; asset provenance |
| 33, 34 | 1 | `InflationBook.forYear` / `forPeriod` |
| 35 | 4 | `figure_text` label on every real figure |
| 36, 37, 38 | 1 | metals as units in `RateBook` + timeline |
| 39 | 1, 4 | `ViewUnit.goldGrams`; S7 label |
| 40, 41 | 1 | `activeIn` staleness; `DietzResult.r == null` |
| 42, 43, 44 | 1, 4 | `orderedUnits`; picker widget |

No AC is untestable. None is ambiguous enough to block phase 1; the questions below change behaviour outside the AC numbers.

---

## 10. Scope concerns

1. **S6 "one Save, all or nothing" spans two repositories** (rates + item values). ADR-0001 names exactly this as its revisit trigger. Cheaper: Save writes typed rates in one transaction, then values in another; if the second fails, the screen keeps the value rows and says "Rates saved, values not saved — try again". Rates are independent facts (fetched ones are already saved this way, UX 2.6). Recommend this; otherwise ADR-0001 needs a cross-repository unit of work.
2. **Why sheet for every number (S9, ~20 number kinds × en/ar).** The largest single piece of phase 4. The engine already carries the inputs, so the cost is templates and strings. Cheaper: ship S9 in phase 4 for the Shariah-required figures (set-aside, zakat share, real returns, gap, to-purify — A6/A9) and the return figure; others show "What it is" only, completed in a follow-up.
3. **"All units" in the picker** (story §6.3, AC-42 "all other units") — a full ISO 4217 list needs ~150 en/ar names and country mappings with no rate or inflation data behind many of them. Decided by PM: 32 currencies + XAU-g/XAG-g.
4. **Undo toasts on four delete kinds** — kept, but implemented as "re-save the captured aggregate", not soft-delete columns.

## 11. Questions for PM

- **Q-1** Interest *kept inside* the item: does it raise the recorded value on its date (symmetric with "given away from inside lowers it", §5.4)? AC-19 holds either way, but without it the month of the interest shows a fake dip (−5 % in June, +5.26 % in December for AC-19's data). Spec assumes **yes**.
- **Q-2** Dividends-only set-aside in a multi-currency case: convert each dividend at its own date (spec) or at E like the value part?
- **Q-3** Since-start set-aside when the held period includes a "no zakat due" year: spec prorates by days outside those years. OK?
- **Q-4** Confirm the v1 unit list = 29 currencies (§2.1) + XAU-g, XAG-g instead of all ISO 4217. And who writes and approves the Arabic strings (labels carrying Shariah wording)?
- **Q-5** Current period ends today (D10): "2026 so far" uses E = today. Confirm.
- **Q-6** The nisab hint (UX 2.10 step 7) has no AC. Add one, or treat as UX-only?
- **Q-7** Consultant (UX verdict item 4) says "Other + personal use → 0 %"; story AC-7 says "other" never defaults. Spec follows AC-7.

---

## 12. Addition — Expected vs actual + Private equity (2026-10-17)

**Inputs:** story §5.5, §5.6, AC-46…AC-67, §13 Q10–Q15 · zakat file B6, B6.1, B6.2, P-1…P-5 · UX §2.12 (written 2026-10-17; screen parts in 12.10) · orchestrator decisions on Q-E1…Q-E5 (2026-10-17, 12.11).
**Scope here:** data model, domain, engine, Drift migration, repository, and how the §2.12 screens use them. Layout is UX's.

### 12.1 Decisions

| # | Decision | Why | Rejected |
|---|---|---|---|
| E1 | **Pending rows are derived, never stored.** `expectedVsActual(timeline, today)` rebuilds every row on each read from the item's plan fields + its history. Only the user's decisions are written: check mark / edit → a normal `MoneyOut(kind: income)` (conventional cash deposit: `InterestRecord(paidOut)`, Q-E1) or `ValueUpdate`; skip → one `PlanSkip` entry. | "No data written in the background" (§5.6, AC-51, AC-63) holds by construction: nothing is written until the user taps. The 7-day rule runs on every read, so a record typed by hand in S5 resolves its row with no write-time hook, and deleting it brings the row back. "A pending amount follows the current plan" (AC-59) and "edits recompute from the start" (§5.6 Edits) need no rewrite job. | **Stored generated rows:** needs a write on app open (a write the user did not ask for), a rebuild on every plan edit, a matching hook in `saveEntries` and an un-match hook in `deleteEntry`; two copies of the same fact can drift. |
| E2 | **A skip is a history entry** (`PlanSkip`, kinds `payout_skipped` / `value_skipped`) in the existing `history_entries` table, dated on the schedule date. | D8 (one history table, one sealed type) already gives one stream, cascade delete, Undo via `restore`, un-skip via `deleteEntries`, one transaction via `saveEntries`. **Only interface change:** `deleteEntry(id)` becomes `deleteEntries(ids)` (12.6), for the one-transaction Undo of "Confirm all". | **Own `plan_skips` table:** a second join in `watchAll` (row product with history), new `skip`/`unskip` methods, `restore` must carry a second list. Cost of E2: `amount` is NOT NULL, so a skip stores `0`; `ItemTimeline` must drop skips (one filter, 12.4). |
| E3 | **Matching = date window only:** a record resolves row k when `|record.date − d_k| ≤ 7` days. Rows in date order; each takes the earliest unused record in its window (by date, then `createdAt`). Payout rows take `MoneyOut(income)` only (never interest, AC-58) — except a cash deposit with `accountKind == conventional`, whose payout rows take interest received (`keptInside` / `paidOut`) only, never income (Q-E1); value rows take `ValueUpdate` only. A matched record beats a skip on the same row. A skip resolves a row only on its exact date. | One rule for hand-entered and confirmed records. Windows never overlap: the shortest step is 28 days (monthly, February) and a window spans 14 days, so greedy matching is exact (test it). | **A `plan_date` link column on history:** a second matching rule, and links go stale when the schedule changes. Cost of E3 removed by Q-E2: S5 opened from a pending row limits the date to d_k ± 7. |
| E4 | **Shariah risk tag is derived**, not stored: `Investment.shariahRisk => peCase == PeCase.b`. The stored facts are the two P-2 answers. | AC-66: the tag must follow every change of Q1/Q2; a stored flag is a second copy that can disagree. It survives a restart because the answers do. UC-2 reads the same getter (D1: engine is in memory). | Stored `shariah_risk` column (story Q14 wording "stored tag" is met: it is computed from stored answers). |
| E5 | **Case C is applied inside `ItemTimeline`**: income of a case C item leaves `flowsIn` and `incomeFlows` and goes into `toPurifyAt`. Giving it away reuses the existing "interest given away — from interest paid out to me" record (`givenAwayFromPaidOut`), no new kind (orchestrator 2026-10-17). | Every figure (Dietz, gain, ROI, set-aside, base totals) reads those three methods (verified in `portfolio_calculator.dart`), so one place changes them all, and P-4 "follows the current answers for all past payouts" is automatic. | A flag on each `MoneyOut`: would need a rewrite of past rows when Q2 changes. |
| E6 | **Case C zakat is fixed in `resolve`**: for a private-equity item with `peCase == c`, `resolve` returns 100 %, section `B6` (B9 reason), notice `capitalBackIsDebt`, whatever rule is stored. | P-1 item 5 says "no method question"; D7 already resolves at calculation time. Changing Q2 later then needs no rule rewrite. | A new `ZakatRule.debt100` written by the form: a stored rule that must be rewritten whenever Q2 changes. |
| E7 | **Private equity reuses existing rules**: trading → `trading100`; long-term "known %" → `custom`; "profit received only" → `longTermDividendsOnly` (same math, §9.4, P-1); "full value" → `longTermFullValue`. `resolve` returns section `B6` for every private-equity item. | Same math, same engine path (`onDividends`); only the "why" anchor differs. | New `pe*` rules: four enum values with identical math. |
| E8 | **Rates are fractions**, like inflation: `expectedProfit = 0.20` for 20 %. Schedule enum `Schedule { monthly(1), quarterly(3), halfYearly(6), yearly(12) }`. | §2.2 rule. The story has "every 6 months"; the zakat file's input table lists monthly/quarterly/yearly only — story wins (the file is the source for rules, not enums). | — |
| E9 | **Expected amounts are rounded to 2 dp in the domain** (`round(scale: 2)`, half away from zero), an explicit exception to D4. | A confirmed amount becomes a stored record ("5,000.00", "83.33", AC-49, AC-52); display rounding would store 20 dp. | — |
| E10 | **Charts are one `CustomPaint` widget** (`widgets/plan_chart.dart`, two callers: value chart and income chart). No chart package, no ADR. | Two line series + filled/hollow points + a date axis is ~150 lines; a package (fl_chart, ~1 MB, own RTL and theming rules) costs more than it saves. Revisit if a third chart kind appears (UC-2 dashboard). | fl_chart; syncfusion (licence). |
| E11 | **Q12: income does not change the recorded value; only sales do** (12.7). | Root cause confirmed in code; case C and closed-item confirms (AC-56) are wrong without it. | Keep the old rule (forces a value re-entry after every payout). |

### 12.2 Domain model changes — `lib/features/investments/domain/`

```dart
enum AssetType { stock, fund, sukuk, gold, silver, cashDeposit, crypto, privateEquity, other }   // stored by name: 'privateEquity'
enum Schedule { monthly(1), quarterly(3), halfYearly(6), yearly(12); const Schedule(this.months); final int months; }
enum ProfitBasis { shareOfProfit, fixedPctOfMoney, notSure }   // P-2 Q1
enum CapitalBack { no, yes, notSure }                           // P-2 Q2
enum AccountKind { islamic, conventional }                      // P-3, cash deposit only
enum PeCase { a, b, c, notSure }

final class Investment {
  … existing fields …
  Schedule? payoutSchedule; Decimal? expectedProfit;        // fraction per year, > 0; needs payoutSchedule
  Schedule? valueCheckSchedule; Decimal? expectedGrowth;    // fraction per year, > −1; needs valueCheckSchedule
  ProfitBasis? profitBasis;      // privateEquity with expectedProfit only (Q1, Q-E4)
  CapitalBack? capitalBack;      // every privateEquity item (Q2, Q-E4); never depends on a schedule
  AccountKind? accountKind;      // cashDeposit with payoutSchedule (Q-E3)
  PeCase? get peCase;      // null unless privateEquity (capitalBack is then always set — validated). Q2 first:
                           //   capitalBack yes → c (with or without a %, with or without a schedule)
                           //   Q1 asked (a % is set):     notSure in Q1 or Q2 → notSure; fixed + no → b; share + no → a
                           //   Q1 not asked (no %):       no → a; notSure → notSure
  bool get shariahRisk;    // peCase == b
}
// withRule(...) copies the seven new fields.

// history_entry.dart
enum PlanKind { payout, value }
final class PlanSkip extends HistoryEntry { PlanKind plan; }   // date = the schedule date; a user decision, never actual
```

`investment_draft.dart` — `InvestmentDraft` gets the seven fields. New `DraftError`s: `planNotForType` (payout fields on gold/silver/crypto, value fields on gold/silver), `profitNeedsSchedule`, `growthNeedsSchedule`, `profitNotPositive` (≤ 0), `growthTooLow` (≤ −1), `answerProfitBasis` (privateEquity + expectedProfit), `answerCapitalBack` (every privateEquity item) — any value incl. not sure passes, AC-64 — and `answerAccountKind` (cashDeposit + payoutSchedule, Q-E3). Private equity: intent must be trading or long-term, else `missingIntent` (AC-46 "intent is named"); long-term rule must be `custom`, `longTermDividendsOnly` or `longTermFullValue`, else `shareRequired` (AC-47); case C skips the share check (E6). The form clears Q1 when the % is cleared, and the account kind when the payout schedule is cleared. Q2 is never cleared on private equity. So `peCase` is a pure function of what is stored. Case C in `ItemTimeline` (E5) and `resolve` (E6) reads only `peCase`, never a schedule or a %.

`zakat_rules.dart` — `defaultRule(privateEquity, trading) = trading100`, `(privateEquity, longTerm) = null` (must pick); `offeredShare` unchanged (other only); `resolve`: section `B6` for every private-equity item, case C override (E6); new `ZakatNotice.capitalBackIsDebt`. P-2 and P-3 notices are **display** notices derived by the screen from `peCase` / `accountKind`, not zakat notices.

`portfolio_calculator.dart` — **no change.** Private equity falls into the "others → default country of the item unit" series branch (story §8.1; verified: the market branch tests stock/fund/sukuk only). The calculator does not import the plan code (architecture test, 12.8).

### 12.3 Where the expected-amount math lives

- `lib/core/dates.dart` — add `DateTime addMonths(DateTime start, int months)`: same day in month `start.month + months`, or that month's last day (AC-50: 01-31 → 02-28, 03-31, 04-30; 2024-02-29 + 48 → 2028-02-29). Always from the start date, never chained.
- `lib/features/investments/domain/formulas.dart` — two stateless formulas, Decimal only:
  - `Decimal expectedPayout({required Decimal capital, required Decimal rate, required int months})` = `round2(capital × rate × months ÷ 12)` (`divide`). AC-49: 100,000 × 0.20 × 3/12 = 5,000.00; 10,000 × 0.10 / 12 = 83.33.
  - `Decimal expectedValue({required List<Flow> flows, required Decimal growth, required DateTime on})` = `round2(max(0, Σ f.amount × powRatio(1 + growth, divide(daysBetween(f.date, on), 365))))` over flows dated ≤ on. `powRatio` stays the only `double` (D5): its inputs are a growth factor and a day ratio. Verified with a script: AC-60 12,635.39 / 9,948.16, AC-61 10,096.72 / 10,184.88, AC-48 9,000.00.
- `lib/features/investments/domain/expected_plan.dart` — **new file.** No existing file owns a schedule or a match; keeping it out of `item_timeline.dart` keeps "actual only" structural (AC-63). Pure Dart.

```dart
enum RowState { pending, resolved, skipped }       // UI words: payout received / value recorded
final class PlanRow { PlanKind kind; int k; DateTime date; Decimal? expected; RowState state;
                      HistoryEntry? actual; Decimal? actualAmount;        // matched record, in item unit
                      bool noPayoutLine; }                                // payout: skipped, or pending and today ≥ date + 8
final class ValueCheck { DateTime date; Decimal actualNet; Decimal expected; Decimal diff; Decimal? diffPct; }   // at every ValueUpdate after start (AC-60)
final class ExpectedVsActual {
  List<PlanRow> payoutRows, valueRows;
  Decimal? expectedSoFar;          // Σ P_k, d_k ≤ today (pending and skipped incl.); null without a %
  Decimal received;                // all income since start, matched or not, case C incl. (§5.5, AC-54)
  Decimal? difference;
  ({Decimal? expected, Decimal received}) payoutsIn(Period p);   // S7 item scope, AC-52
  Decimal? expectedValueAt(DateTime t);                         // chart line; null without a growth %
  List<MissingRate> missing;       // non-empty → every expected amount null, pair named (§5.6)
  bool get hasPending;
  PlanRow? pendingRowNear(DateTime d, PlanKind k);              // S5 by hand: "This also records the expected payout of …" (UX 2.12.3)
}
ExpectedVsActual? expectedVsActual(ItemTimeline tl, DateTime today);   // null when the item has no schedule
```

Rules inside, each test-named after its AC:
- Row dates `d_k = addMonths(start, k × m)`, k ≥ 1, `d_k ≤ today` and `!tl.closedAt(d_k)` (AC-51, AC-56).
- `C(d)` = money in − sales dated ≤ d, in item unit, not below 0; income never lowers it. `P_k = expectedPayout(C(d_(k−1)), p, m)`, `d_0` = start (AC-55).
- `V_exp` flows = money in (+) and **sales** (−) — the same entries that move the recorded value after E11 (needs the PM edit in 12.7). Never value updates, never interest.
- Amounts in other units come from `tl.inItemUnit(entry)` (12.4), so conversion and `MissingRate` stay in one place.
- Conventional cash deposit (Q-E1): payout rows match interest received (E3); `received` = interest received; the check mark records `InterestRecord(paidOut, d_k, P_k)`, so it lands in "to purify" and never in return (Z-6). Islamic or unanswered: income, as for other types (AC-58 unchanged).
- Case C payouts still count as received (§5.5).

Providers (`investments_providers.dart`): `expectedProvider.family(String id)` = `expectedVsActual(calc.timeline(id), calc.today)`; `pendingCountProvider.family(String id)` = number of pending rows for the S2 badge (0 for closed items, AC-56). Both read the existing `calculatorProvider`; nothing new is cached.

Writes (screens, through `saveEntries` / `deleteEntries`): check mark → `MoneyOut(income, d_k, P_k)` (conventional: `InterestRecord(paidOut, …)`) or `ValueUpdate(c_k, V_exp)`; "Confirm all as expected" → one `saveEntries` call with every pending row that has an amount (one transaction, AC-53); skip → `saveEntries([PlanSkip(...)])`; every Undo snackbar (✓, Confirm all, Skip) → one `deleteEntries(ids of what was just written)`. Confirming never changes another row's amount: `P_k` reads only money in / sales and `V_exp` reads no value update.

### 12.4 Engine changes — `item_timeline.dart`

1. **Constructor drops `PlanSkip`** before sorting: `_entries` holds actual records only. Without this, `activeIn` and `latestValueDate` (`x is! InterestRecord`) would count a skip as activity.
2. **E11 (Q12):** in `_replay`, `MoneyOut` lowers `delta` only when `kind == sale`.
3. **Case C (E5):** `final bool _incomeIsPurify = investment.peCase == PeCase.c`. When true: `flowsIn` and `incomeFlows` skip `MoneyOut(income)`; `toPurifyAt` adds those amounts; `givenAwayFromPaidOut` records still subtract them (AC-19b path, no new kind). AC-65: case A gain 10,000.00, case C gain 0.00 and to purify 10,000.00.
4. Add `Decimal? inItemUnit(HistoryEntry e) => _amount[e.id];` for the plan.

Dividends-only and "profit received only" zakat are unchanged (`incomeFlows` + `onDividends`); AC-47 375.00 = 0.025 × 15,000 runs through the AC-5 path.

### 12.5 Drift schema v2 + migration — `lib/core/db/`

| Table | Change |
|---|---|
| `investments` | add nullable TEXT columns `payout_schedule`, `expected_profit` (Decimal), `value_check_schedule`, `expected_growth` (Decimal), `profit_basis`, `capital_back`, `account_kind`. Existing rows read back as "no plan". `asset_type` gains `privateEquity`; existing `other` rows are untouched (AC-46). |
| `history_entries` | no column change. New kinds `payout_skipped`, `value_skipped` (amount `0`, unit null). New partial unique index `history_one_skip_per_plan_date ON history_entries (investment_id, kind, date) WHERE kind IN ('payout_skipped','value_skipped')` — one decision per row, a double tap throws `Conflict`. |

Migration path (drift_dev 2.35.1 is already a dev dependency; `make-migrations` and `testWithDataIntegrity` verified present in the pub cache):
1. **First, on the unchanged v1 code:** add `build.yaml` with `drift_dev` options `databases: {app_database: lib/core/db/app_database.dart}`, `schema_dir: drift_schemas/`, `test_dir: test/core/db/`; run `dart run drift_dev make-migrations` → commits `drift_schemas/app_database/drift_schema_v1.json`. Doing this after the table edit loses the v1 snapshot.
2. **Move both partial indexes into the table declaration** with `@TableIndex.sql(...)` on `HistoryEntries` (exists in drift 2.35.2). The v1 index keeps its exact name and SQL. Why: the schema verifier compares the migrated database with the dumped schema and reports indexes it does not know as "unexpected entries" (read in `find_differences.dart`); an index made by `customStatement` is invisible to the dump. `onCreate` becomes `m.createAll()`.
3. `schemaVersion = 2`; `onUpgrade: stepByStep(from1To2: (m, schema) async { addColumn × 7; await customStatement('CREATE UNIQUE INDEX IF NOT EXISTS history_one_value_update_per_day …'); await m.create(schema.historyOneSkipPerPlanDate); })`. `IF NOT EXISTS` because real v1 databases have that index and the dumped v1 schema does not. Only `addColumn` and new indexes — no table rebuild, so no data copy and no FK juggling.
4. Re-run `make-migrations` → `drift_schema_v2.json`, `lib/core/db/app_database.steps.dart`, `test/core/db/app_database/generated/schema_v1.dart`, `schema_v2.dart`, `test/core/db/app_database/migration_test.dart` (all committed).
5. **Migration test** (`test/core/db/app_database/migration_test.dart`): the generated schema test 1→2, plus `testWithDataIntegrity(oldVersion: 1, newVersion: 2)` that inserts at v1: an `other` item with every optional column, one history row of every v1 kind (incl. a 20-dp Decimal), a typed and a fetched rate, an inflation override, the settings row, a no-zakat year; then opens `AppDatabase` at v2 and checks through `DriftInvestmentsRepository` / `DriftAssumptionsRepository` that every value is equal, the item is still `other` with the same rule, every plan field is null, and a second value update on the same item and day still throws `Conflict`.

### 12.6 Repository (ADR-0001)

**`InvestmentsRepository` interface:** one change — `Future<void> deleteEntry(String id)` → `Future<void> deleteEntries(List<String> ids)`, one transaction, `NotFound` if any id is unknown (nothing deleted). Why: "Confirm all" Undo removes N records at once (UX 2.12.3); N separate calls could half-undo. Extends the existing method (one caller today, `record_sheet.dart`) instead of adding a second one. Domain types only, async (ADR-0001).
`drift_investments_repository.dart`: `_investmentRow` / `_investmentOf` map the seven columns (enums by name, Decimals via the existing converter); `_entryRow` / `_entryOf` map `PlanSkip` ↔ `payout_skipped` / `value_skipped`; `deleteEntries` in one `transaction`. `AssumptionsRepository`: no change.

### 12.7 Q12 verdict — income money out and the recorded value

**Root cause confirmed.** `item_timeline.dart` `_replay`: `case MoneyOut() when amount != null: delta -= amount;` — no check of `kind`. It does what story §5.4 says ("Money out … lowers the value"), so it is a story rule problem, not a coding slip. Effect: item worth 100,000 pays 5,000 income → recorded value 95,000 → gain = 95,000 + 5,000 − 100,000 = 0, return ≈ 0 % until the user types the value again.

**Fix is sound: income money out does not change the recorded value; only sales do.**
- **Capital-keeping items** (private equity, Islamic deposit, rent paid out under "other"): correct without a value re-entry. Required for case C (otherwise case C payouts, left out of flows, would drop the value and give a negative gain) and for AC-56 (a payout confirmed after a full sale would push the value below 0).
- **Stocks/funds (ex-dividend drop):** between the payout and the next value update the recorded value is too high by the dividend, so that month's return is too high by about the dividend ÷ value (≈ 1–2 % for a quarterly dividend). The next value update corrects it, and Dietz over any period ending on a typed value is exact. Cosmetic, temporary. Mirror of today's error, which is permanent until a re-entry.
- **Stale marker side effect:** a month with only an income record counts as "active" (§9.3 counts flows), so it is not marked "value not updated" although the value is carried. Same as today; slightly more visible now. Cosmetic.
- **Dividends-only / profit-received-only zakat:** unaffected. `Z_div` reads `incomeFlows`, never the value, and the value share is 0. AC-5 stays 25.00 / 10.00 / 15.00.
- **Value-based zakat methods (trading, full value, 25 %):** EV is higher by the dividend until the next update → set-aside slightly higher (r × s × dividend × T/Y). Small, on the safe side, corrected at the next update.

**Existing tests that touch income — none asserts the old drop; none should break:**
`item_timeline_test` "income is summed separately from sales" (checks `incomeIn` and flow count only); `portfolio_calculator_test` "since start: days in a no-zakat year…" (value update at the end decides EV), "dividends-only income in a no-zakat year…" and "a dividend in another currency…" (share 0); `acceptance_test` AC-5 (adds a value update on each dividend date — a workaround for the old rule; still passes, can be removed); `item_detail_screen_test` AC-5 why sheet (share 0); `record_sheet_test` "income received is a money out of kind income" (40 below the value 1,000); `drift_investments_repository_test` round trip (kind only).
**New tests:** `item_timeline_test` "income keeps the recorded value; a sale lowers it"; `record_sheet_test` "income above the value does not ask for the value left" (record_sheet.dart line ~256: the `valueLeftRequired` check becomes sale-only).
**Story text the PM must change with the fix:** §5.4 "Money out on date d lowers the value…" → sales only; the "value left" sentence → sales only; §5.6 V_exp "Why all money out, incl. income" → money in and sales; §13 Q12 → decided. No AC number changes (AC-60 has sales only).

### 12.8 Files, in order (Phase 6; each step ends `flutter analyze` clean, `flutter test` green)

1. `build.yaml` (new) + `dart run drift_dev make-migrations` on v1 → `drift_schemas/app_database/drift_schema_v1.json` (12.5 step 1). **Before any table edit.**
2. `lib/core/dates.dart` — `addMonths`. Test: `test/core/dates_test.dart` (AC-50).
3. `lib/features/investments/domain/investment.dart` — `privateEquity`, five enums, seven fields, `withRule`, `peCase`, `shariahRisk`. Test: `investment_test.dart` (case table, AC-66 tag on/off).
4. `lib/features/investments/domain/history_entry.dart` — `PlanKind`, `PlanSkip`.
5. `lib/features/investments/domain/item_timeline.dart` — 12.4 items 1–4. Test: `item_timeline_test.dart` (Q12, skip ignored, case C).
6. `lib/features/investments/domain/formulas.dart` — `expectedPayout`, `expectedValue`. Test: `formulas_test.dart`.
7. `lib/features/investments/domain/expected_plan.dart` (new). Test: `test/features/investments/domain/expected_plan_test.dart` (new; windows never overlap, oldest row first, matched beats skip, closed item, missing rate, no %, conventional cash matched by interest only, `pendingRowNear`).
8. `lib/features/investments/domain/zakat_rules.dart` — 12.2. Test: `zakat_rules_test.dart`.
9. `lib/features/investments/domain/investment_draft.dart` — 12.2. Test: `investment_draft_test.dart`.
10. `test/features/investments/domain/acceptance_test.dart` — `AC-46` … `AC-67` engine-level cases (AC-63: figures with and without a plan are equal).
11. `lib/core/db/tables.dart` — seven columns, both partial indexes as `@TableIndex.sql`.
12. `lib/core/db/app_database.dart` — v2, `createAll`, `stepByStep`; regenerate `app_database.g.dart`; `make-migrations` → `app_database.steps.dart`, v2 json, generated test schemas.
13. `test/core/db/app_database/migration_test.dart` — 12.5 step 5.
14. `lib/features/investments/domain/investments_repository.dart` (`deleteEntries`) + `lib/features/investments/data/drift_investments_repository.dart` — 12.6. Test: `drift_investments_repository_test.dart` (round trip of every new field and both skip kinds; skip uniqueness → `Conflict`; `deleteEntries` all-or-nothing; AC-51: reading the plan writes no row — row count before = after).
15. `test/architecture_test.dart` — `portfolio_calculator.dart` and `formulas.dart` never import `expected_plan.dart` (AC-63); no `Timer`/`Timer.periodic`/`Stream.periodic` under `lib/features/` (AC-63 background).
16. `lib/features/investments/presentation/investments_providers.dart` — `expectedProvider`, `pendingCountProvider`.
17. `lib/l10n/app_en.arb` + `app_ar.arb` — every §2.12 string as a single key; P-1 item 5/6, P-2, P-3 texts verbatim; Arabic for these waits for consultant review (UX 2.12.7).
18. `lib/features/investments/presentation/record_sheet.dart` — 12.10 S5. Test: `record_sheet_test.dart`.
19. `lib/features/investments/presentation/investment_form_screen.dart` — 12.10 S3. Test: `investment_form_screen_test.dart` (AC-46…49, 64, 67).
20. `lib/features/investments/presentation/widgets/plan_chart.dart` (new, E10). Test: `test/features/investments/presentation/widgets/plan_chart_test.dart` (semantics summary, en + ar).
21. `lib/features/investments/presentation/item_detail_screen.dart` (+ `widgets/labels.dart`, `why_builders.dart` for the tag and case notices) — 12.10 S4. Test: `item_detail_screen_test.dart` (AC-51…62, 65, 66).
22. `lib/features/investments/presentation/home_screen.dart` — 12.10 S2. `period_screen.dart` — item-scope payouts line. Tests: `home_screen_test.dart` (AC-51, 56), `period_screen_test.dart` (AC-52 July).

### 12.9 AC → layer

| AC | Layer |
|---|---|
| 46 | `AssetType`, `validate` (intent), migration test (`other` kept) |
| 47 | `defaultRule`, `validate` (PE rules), `resolve` B6; AC-5 path for 375.00 |
| 48 | `validate` (plan errors); `expectedValue` (9,000.00); no plan → `expectedVsActual` null |
| 49, 50 | `expectedPayout`, `addMonths`; S3 amount line |
| 51, 57, 58 | `expectedVsActual` rows, `noPayoutLine` (date + 8), matching skips interest; R test "no row written" |
| 52, 53 | S4 actions → `saveEntries` (`MoneyOut` / `PlanSkip`); `payoutsIn` |
| 54 | matching E3 (10,000 resolves July; 2,000 unmatched, received 17,000) |
| 55 | `C(d)` from the previous date |
| 56 | `closedAt` cut-off; `pendingCountProvider` |
| 59 | rows derived from current fields |
| 60, 61 | `expectedValue`, `ValueCheck`; value rows |
| 62 | `expectedValueAt`, rows → `plan_chart.dart` |
| 63 | architecture test + acceptance "equal with and without plan" |
| 64, 66 | `peCase`, `shariahRisk`, `validate`; S3/S4 notices |
| 65 | `ItemTimeline` case C, `resolve` case C |
| 67 | `accountKind`, ARB texts, word check test |

### 12.10 Screens (UX §2.12) — what each one reads and writes

Layout is UX's; this lists the engine and repository calls only. **CUT by the orchestrator:** the S2 "To confirm (n)" filter chip and the "Use Private equity" link on "other". Not built.

- **S2 Home** (`home_screen.dart`): row pill "n to confirm" when `pendingCountProvider(id) > 0` (closed → 0, AC-56). No banner, no app-bar count. No other change.
- **S3 Form** (`investment_form_screen.dart`, existing local state + `validate`):
  - Type list gains Private equity; intent limited to To sell / Long-term; long-term shows the three P-1 options (no 25 %), case C replaces them with the P-1 item 5 line (E6).
  - **Expected (optional)** `ExpansionTile`: payout and value sub-blocks hidden per type (`planNotForType`); schedule chips map "None" to `null`.
  - Live lines: "= {P_1} every {m} months · first on {d_1}" from `expectedPayout(firstPaid in item unit, p, m)` + `addMonths(start, m)`; "Your estimate for {start + 1 year}: …" from `expectedValue([first money in], g, addMonths(start, 12))`. Missing rate → the existing inline rate entry.
  - **Question placement differs from UX 2.12.2 — UX must move them (decisions Q-E3, Q-E4):** on private equity, Q2 is always shown, in the type/intent part of the form and not inside Expected. Case C can exist with no plan. The cash account question shows as soon as a **payout schedule** is picked. Q1 shows only when the % is filled in.
  - Notices from `peCase` (A none / B / C / notSure) and `accountKind`; case B tag preview from `shariahRisk`. Edit confirms ("recalculates every past month", "rows rebuilt") are text only; nothing extra is written.
- **S4 Item detail** (`item_detail_screen.dart`):
  - **To confirm card** = `payoutRows` + `valueRows` with `state == pending`, oldest first; "Show n more" after 3 is display only.
  - ✓ → one `saveEntries` (12.3 writes) → snackbar Undo → `deleteEntries([id])`.
  - Row with `expected == null` → "Add amount" → S5.
  - ⋮ Skip → `saveEntries([PlanSkip])`, Undo → `deleteEntries`.
  - Confirm all → one `saveEntries`, Undo → one `deleteEntries` with all ids; hidden when no pending row has an amount.
  - `noPayoutLine` drives the P-3 line; the private equity suffix is added when `type == privateEquity`; case C label "· to purify" when `peCase == c`.
  - **History list:** shows a `PlanSkip` as a quiet "Skipped" row only while its row's state is `skipped` (a later matched record wins, E3; the stale skip stays stored, harmless). Tapping it opens S5. Value-update rows below their `ValueCheck.expected` show "Value is below your estimate."
  - **Plan vs actual card:** Payouts part = `expectedSoFar` / `received` / `difference` (no % → `received` only, AC-57); Value part = last `ValueCheck`. The Payouts | Value switch is local widget state.
  - **Charts** (`widgets/plan_chart.dart`, `CustomPaint`, one widget, two callers; E10). Input is a plain series list built in the screen:
    - value chart: expected line = `expectedValueAt(t)` sampled at start, every check date, every value-update date and today (a smooth enough curve at ≤ 1 point per month, no extra math); actual = `ValueUpdate` points (`netValueAt`); hollow = pending value rows.
    - payouts chart: cumulative `expected` steps at row dates; cumulative actual income (case C incl.) steps at record dates; hollow = pending payout rows at the cumulative expected amount.
    - Dashed/solid/hollow, 3 grid lines, mirrored time axis in RTL, tap tooltip (exact amounts via `format.dart`), one `Semantics` summary label.
  - Tag chip from `shariahRisk` → S9. Case C notice and returns line from `peCase`; to-purify card already includes the payouts (12.4).
- **S5 Record sheet** (`record_sheet.dart`):
  - Opened from a row: kind preset (Out · Income; conventional cash: Interest · paid out to me; Value), date = d_k, amount = expected, header "Expected … on …". The date picker is limited to d_k ± 7 (Q-E2).
  - Opened by hand: the "This also records the expected payout of {date}" line when `pendingRowNear(date, kind)` is non-null; for conventional cash it is shown on interest received, never on income.
  - Value-left check for sales only (Q12).
- **S7 Period view** (`period_screen.dart`): item scope only, one line from `payoutsIn(period)`. Never in portfolio scope.

### 12.11 Questions

All decided by the orchestrator, 2026-10-17. Applied above.
- **Q-E1 — decided (consultant's fix):** on a conventional cash deposit, the check mark records interest paid out to me, and an interest record within the window resolves the row (E3, 12.3). My "no payout rows" proposal was rejected. **PM:** the story §5.6 matching line ("Interest records never resolve a payout row") and AC-58 need a conventional-deposit exception, plus an AC for it.
- **Q-E2 — decided:** editing a pending row limits the date to d_k ± 7 (12.10 S5).
- **Q-E3 — decided:** the account kind is required to save when a cash deposit has a payout schedule (`answerAccountKind`).
- **Q-E4 — decided (corrected):** on private equity, Q2 is asked on **every** item and required ("not sure" allowed). Q1 is asked only with a %. With no %: Q2 no → A, yes → C, not sure → notSure. Case C does not depend on a schedule. **UX:** 2.12.2 asks both questions only "when a % is filled in" and must change. **PM/consultant:** P-2 says "when expected_profit_pct is set"; the story §5.5 and P-2 need this change, and AC-64 needs a no-% case.
- **Q-E5 — accepted as cosmetic:** after a schedule or start-date change, old skips are ignored, but they come back if the old dates come back. Not fixed.
- **Case C give-away — decided:** reuse "interest given away — from interest paid out to me". No new kind (E5, 12.4).
- **Q12 — fix approved** (E11, 12.7). PM still edits the story text listed in 12.7.

## 13. Fix — settings placement and the Investments title (2026-10-24)

Scope: Investments app-bar title; one Settings gear on every tab (UX Option A); Settings becomes the hub that opens S8; "Update all" leaves S8 and lives in the Investments banner slot; Settings fully localized. Out: why-sheet "Change" deep links, new routes, new dependencies.

### 13.1 Decisions

- **D-1 — The gear is one public widget, `SettingsAction`, added to `lib/features/settings/settings_screen.dart`.** It is an `IconButton(tooltip: l10n.settings, icon: Icon(Icons.settings))` that does `Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()))` — the only navigator is the root one, as today (`main.dart`: pushed screens cover the tab bar). 4 callers: Overview, Investments, Zakat, Plan, each `AppBar(actions: const [SettingsAction()])`. *Rejected:* a new file `settings_action.dart` (the screen file it opens already fits); `lib/core/` (`architecture_test` forbids core → features); one app bar owned by `AppShell` (rewrites all 4 screens' scaffolds and collides with feat/overview and feat/zakat).
- **D-2 — Settings is the hub; S8 is unchanged except the Update all button goes.** Row 1 is a `ListTile(key: 'settings-assumptions', title: l10n.assumptionsTitle, subtitle, trailing: chevron)` → push `AssumptionsScreen`. Then the existing AI section. *Rejected:* keeping a second Assumptions icon on Investments (two doors to one room, the problem being fixed).
- **D-3 — Hub subtitle = base currency · zakat year, from `settingsProvider` only.** New key `assumptionsSummary(currency, zakatYear)` = "{currency} · {zakatYear}", where zakatYear is the existing `zakatYearLunar` / `zakatYearSolar` label. While settings load, or if a value is null, no subtitle. *Rejected:* "rates as of {date}" — the honest date is the oldest in-use pair, and that logic lives inside `AssumptionsScreen._rates` (base + items + `RateBook`); the newest date would hide a stale pair. Needs new plumbing → dropped per scope.
- **D-4 — The banner slot on S2 always shows when the list has items.** Extend `_staleBanner`: stale → today's card; nothing stale → a plain (no container colour) `ListTile(key: 'up-to-date', title: l10n.allUpToDate(formatMonthYear(today)), trailing: TextButton(l10n.updateAll))` → S6. Same `TextButton` label in both states, so `find.text(l10n.updateAll)` works either way. The empty state shows neither. *Rejected:* new key "All up to date" — `allUpToDate(month)` already exists (S6 uses it), and staleness is per month, so the month is the true statement.
- **D-5 — English text stays word for word what it is today.** Every hard-coded string in `settings_screen.dart` becomes an ARB key with the same English value, so tests that find English text (`settings_screen_test`, `integration_test/ai_live_test`) only need localization delegates, not new strings. *Rejected:* rewording in the same change (mixes a copy change into a refactor).
- **D-6 — Vendor data (`AiVendor.name`, `keyHelp`, `dataNotice` in `lib/core/ai/ai_vendors.dart`) stays as vendor data, not ARB, in this fix.** The screen's own sentences around it are localized ("Your own key. {notice}", "{help} Stored only on this phone."). *Rejected:* `vendor.id → l10n key` mapping in the screen (a second source of vendor text; breaks `fake_ai_vendor` vendors); moving the text into ARB and off `AiVendor` (changes core/ai and its tests — out of this cut). **Open for owner:** in Arabic, the Gemini key help and data notice stay English until this is done.

### 13.2 Assumptions

- **A-1 — verified (read):** `test/architecture_test.dart` has no "features never import each other" check; overview already imports investments and `main.dart`, Investments already imports `settings_screen.dart`. New imports features/{overview,zakat,plan} → settings and settings → `investments/presentation/assumptions_screen.dart` pass the suite. The settings ↔ investments library cycle is legal Dart; it matches the existing `main.dart` ↔ `overview_screen.dart` cycle.
- **A-2 — unverified — risk:** `settings_screen_test` pumps `SettingsScreen` without a database. After D-2 the screen watches `settingsProvider` (Drift). Without an `appDatabaseProvider` override it may error or leave a pending timer. Mitigation in 13.4: override with `Harness(...).db`.
- **A-3 — verified (read):** the golden path reaches S6 today via the Assumptions tooltip (`test/support/golden_path.dart:120–122`) and then pops one extra route ("leave Assumptions too", `:135`). Both lines must change.
- **A-4 — verified (read):** the `main_test` "Financial Planner" check is on the Setup screen (`setup_screen.dart:109` keeps `appTitle`). Not affected.

### 13.3 Files, in order (each step: `flutter analyze` clean)

1. `lib/l10n/app_en.arb`, `app_ar.arb` — add `settings` (Settings / الإعدادات), `assumptionsSummary`, and one key per string in `settings_screen.dart` (`settingsReadError`, `aiHeading`, `aiCloudTitle`, `aiCloudSubtitle`, `aiProviderHeading`, `aiVendorSubtitle{notice}`, `aiKeyLabel{vendor}`, `aiKeyHelper{help}`, `aiKeySaved`, `aiRemoveKey`, `aiSaveKey`, `aiStatusOff`, `aiStatusPickVendor`, `aiStatusAddKey{vendor}`, `aiStatusUsingKey{vendor}`). English = today's text exactly. Arabic: none of the banned words; profit = ربح. Run `flutter gen-l10n`.
2. `lib/features/settings/settings_screen.dart` — add the copyright header; `context.l10n` for all strings; Assumptions row first (D-2, D-3); add `SettingsAction` (D-1).
3. `lib/features/investments/presentation/assumptions_screen.dart` — delete the bottom `FilledButton` (Update all) and the now-unused `update_all_screen.dart` import. Nothing else.
4. `lib/features/investments/presentation/home_screen.dart` — title `l10n.tabInvestments`; actions `const [SettingsAction()]` (drop the 'Settings' and `Icons.tune` buttons, and the `assumptions_screen.dart` import); `_staleBanner` per D-4 and called with no stale condition.
5. `overview_screen.dart`, `zakat_screen.dart`, `plan_screen.dart` — import + `actions: const [SettingsAction()]`. **Only that line**, for merge with feat/overview and feat/zakat.
6. Tests (13.4), then docs (13.5).

### 13.4 Tests

| Test | Change | Scope item |
|---|---|---|
| `test/features/investments/presentation/home_screen_test.dart` | **new:** app bar shows `l10n.tabInvestments`, not `appTitle`; **new:** no `Icons.tune`, one `find.byTooltip(l10n.settings)`; **new:** nothing stale → `up-to-date` line, tap `updateAll` → `UpdateAllScreen`; **new:** empty list → no banner, no up-to-date line. Existing stale-banner test stays. | 1, 2 |
| `test/main_test.dart` | **new:** set-up shell, for each of the 4 tabs: `find.byTooltip(l10n.settings)` is there; tap → `SettingsScreen`, back → shell (en + ar). | 2 |
| `test/features/settings/settings_screen_test.dart` | **must change:** `pumpSettings` adds the 4 localization delegates and `appDatabaseProvider.overrideWithValue(Harness(day(2026, 10, 16)).db)` (seed `setup()` for the subtitle test). **new:** Assumptions row first, subtitle = `assumptionsSummary(base, zakat year label)`, tap → `AssumptionsScreen`; **new:** Arabic run shows `الإعدادات` title and no English AI strings except vendor data (D-6). | 2, 3 |
| `test/features/investments/presentation/assumptions_screen_test.dart` | **must change:** the test at ~`:368` that taps `updateAll` → now asserts `find.text(l10n.updateAll)` finds nothing (keep the no-zakat part). | 2 |
| `test/support/golden_path.dart` (`test/golden_path_widget_test.dart`, `integration_test/golden_path_test.dart`) | **must change:** replace the tooltip tap with `tapText(l10n().updateAll)` on the Investments tab; delete the extra pop at `:135`. | 2 |
| `integration_test/ai_live_test.dart` | **must change:** add the localization delegates to its `MaterialApp` (English finds stay valid by D-5). Device-only; run if a device is available. | 3 |
| `test/l10n/expected_words_test.dart` | no change; must stay green (new keys are not expected-figure keys). | 3 |
| `test/architecture_test.dart` | no change; must stay green (A-1). | 2 |

### 13.5 Docs to make true

- `docs/product/ux/my-investments.md` §1 — S8 row: "Opened from Settings (gear on every tab)"; Navigation line: every tab's top bar = title + **Settings** gear; Settings = Assumptions › (base · zakat year) + AI. §2.2 step 1: banner slot shows the stale banner, or "Everything is up to date for {month} · Update all"; only with items. §2.6 entry points: S2 banner slot (stale or up to date), Overview stale card, "rate missing" links — not S8. §2.7 entry: Settings › Assumptions (why-sheet deep links stay as written: separate follow-up); delete step 5.
- This file, §6 screens table: S2 row (drop totals; "stale banner / up-to-date line, list, sort"; actions: Settings); S8 row: "push from Settings"; add a row "Settings (hub: Assumptions ›, AI) | `features/settings/settings_screen.dart` | push from the gear on every tab | settings, AI settings".
- `docs/product/stories/my-investments.md` — checked, no navigation text; no change.
