# Implementation spec — My Investments

**Owner:** architect · **Status:** v1 · 2026-10-16
**Inputs:** [story](../product/stories/my-investments.md) (frozen, AC-1…AC-44 + AC-19b) · [zakat file](../product/shariah/zakat-on-investments.md) · [UX flow](../product/ux/my-investments.md) (loop 1 accepted) · ADR-[0001](../adr/0001-data-access-behind-repositories.md), [0002](../adr/0002-project-layout-and-stack.md), [0003](../adr/0003-rate-refresh-source.md), [0004](../adr/0004-shipped-inflation-data.md)
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

- `units.dart` — `extension type const Unit(String code)` with `isMetal`, consts `xauG = Unit('XAU-g')`, `xagG`; `const v1Currencies` (29, alphabetical): AED, AUD, BDT, BHD, CAD, CHF, CNY, DZD, EGP, EUR, GBP, HKD, IDR, INR, JOD, JPY, KWD, MAD, MYR, NGN, OMR, PKR, QAR, SAR, SGD, TND, TRY, USD, ZAR (all quoted by the ADR-0003 source; all have World Bank data). `const allUnits = [...v1Currencies, xauG, xagG]`. `Country defaultCountryOf(Unit)` (EUR → `EMU`). `List<Unit> orderedUnits({required Map<Unit,int> usage, required Unit topAnchor})` — story §6.3; `topAnchor` = base, or region currency before setup.
- `markets.dart` — `enum Market(country, currency)`: tadawul(SAU, SAR), egx(EGY, EGP), nasdaq(USA, USD), nyse(USA, USD), lse(GBR, GBP), dfm(ARE, AED), adx(ARE, AED), boursaKuwait(KWT, KWD), qse(QAT, QAR), bursaMalaysia(MYS, MYR), bist(TUR, TRY), psx(PAK, PKR), other (country stored on the investment).
- `countries.dart` — `extension type const Country(String iso3)`; the 29 codes of ADR-0004.

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

`period.dart` — `enum Granularity { month, year }`; `final class Period { DateTime s, e; }` with `Period.month(y, m, today)`, `Period.year(y, today)` (D10), `Period.sinceStart(item)`; `List<Period> periodsBetween(DateTime first, DateTime today, Granularity)`.

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
- **Base conversion:** BV at S, each flow at its date, EV and Z at E (§6.1). A missing rate removes the item from that period's base totals → `Excluded(itemId, from, to, date)` (AC-21). A closing rate dated ≤ S → `StaleRate` marker (AC-22).
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
| `inflation_overrides` | country, year, rate | unique (country, year) |
| `settings` | singleton row (id = `'settings'`): base_currency?, home_inflation?, zakat_year?, long_term_method?, jewellery_zakatable? | — |
| `no_zakat_years` | year | unique (year) |

`PRAGMA foreign_keys = ON` in `beforeOpen`. Opened on device with `driftDatabase(name: 'financial_planner', native: DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory))`; in tests with `AppDatabase(NativeDatabase.memory())`.

---

## 4. Repositories (ADR-0001)

Errors next to each interface: `NotFound`, `Conflict`, `StorageUnavailable`; implementations map `SqliteException`/`DriftWrappedException` to them.

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
| S2 Home (totals, this-year verdict, to-purify total, stale banner, list, sort) | `home_screen.dart` | root | portfolio(year, view), sinceStart per item, staleNow |
| S3 Investment form (add/edit, fields per type, intent → zakat line, inline rate, price × qty) | `investment_form_screen.dart` | push (fullscreenDialog) | validate, defaultRule, resolve |
| S4 Item detail (since-start card, zakat line, history) | `item_detail_screen.dart` | push | sinceStart, resolve |
| S5 Record sheet (money in / money out / value update / interest) | `record_sheet.dart` | bottom sheet | timeline value for typo check |
| S6 Update all (refresh card, as-of date, stale rates + values, one Save) | `update_all_screen.dart` | push | staleNow, refreshController |
| S7 Period view (scope, month/year, grams toggle, ladder, verdict, markers, items, excluded, other periods, no-zakat switch + nisab hint) | `period_screen.dart` | push | portfolio/item figures, periodsBetween |
| S8 Assumptions (+ pair history, series years) | `assumptions_screen.dart`, `rate_history_screen.dart`, `inflation_series_screen.dart` | push | rates, inflation book, settings |
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
3. **"All units" in the picker** (story §6.3, AC-42 "all other units") — a full ISO 4217 list needs ~150 en/ar names and country mappings with no rate or inflation data behind many of them. Spec uses the curated 29 + XAU-g/XAG-g (Q-4).
4. **Undo toasts on four delete kinds** — kept, but implemented as "re-save the captured aggregate", not soft-delete columns.

## 11. Questions for PM

- **Q-1** Interest *kept inside* the item: does it raise the recorded value on its date (symmetric with "given away from inside lowers it", §5.4)? AC-19 holds either way, but without it the month of the interest shows a fake dip (−5 % in June, +5.26 % in December for AC-19's data). Spec assumes **yes**.
- **Q-2** Dividends-only set-aside in a multi-currency case: convert each dividend at its own date (spec) or at E like the value part?
- **Q-3** Since-start set-aside when the held period includes a "no zakat due" year: spec prorates by days outside those years. OK?
- **Q-4** Confirm the v1 unit list = 29 currencies (§2.1) + XAU-g, XAG-g instead of all ISO 4217. And who writes and approves the Arabic strings (labels carrying Shariah wording)?
- **Q-5** Current period ends today (D10): "2026 so far" uses E = today. Confirm.
- **Q-6** The nisab hint (UX 2.10 step 7) has no AC. Add one, or treat as UX-only?
- **Q-7** Consultant (UX verdict item 4) says "Other + personal use → 0 %"; story AC-7 says "other" never defaults. Spec follows AC-7.
