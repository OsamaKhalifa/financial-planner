# ADR-0002 — Project layout and stack

**Status:** proposed · 2026-10-16 · architect · needs owner ack (refines ADR-0001 wording, see Why §4)

## Decision

Feature-first folders with a small `lib/core/`, Riverpod 3 without code generation, Drift (with `drift_dev` code generation) via `drift_flutter`, plain `Navigator`, Material 3 with Flutter's `.adaptive` constructors, and exactly the dependencies listed below.

### Layout

```
lib/
  main.dart                     ProviderScope + MaterialApp (theme, l10n, home = Setup or Home)
  l10n/app_en.arb, app_ar.arb   gen-l10n input (flutter generate: true)
  core/
    db/                         AppDatabase + all Drift tables (only place, with */data/, that imports drift)
    money/                      Money, decimal_math.dart (divide, fractional pow), format.dart
    dates.dart                  calendar-date helpers (UTC midnight, daysBetween, month/year bounds)
    ids.dart                    newId() — UUID v4 from Random.secure
    reference/                  units.dart (Unit, currencies + metals, picker order), markets.dart, countries.dart
    assumptions/                rates, inflation, settings: domain + repository interface + data/ + providers
  features/
    investments/
      domain/                   Investment, history records, engine (pure Dart), validation, zakat defaults
      data/                     DriftInvestmentsRepository
      presentation/             screens S1–S9 + shared widgets, providers co-located
tool/
  gen_inflation.dart            regenerates assets/inflation/cpi_annual.json (ADR-0004)
assets/inflation/cpi_annual.json
test/                           mirrors lib/ paths: lib/a/b.dart → test/a/b_test.dart
integration_test/golden_path_test.dart
```

Import direction: `presentation → domain ← data`, `features → core`, never `core → features`. Feature-to-feature imports follow the amendment at the end of this file. Only `lib/core/db/` and `*/data/` import `package:drift`; only `lib/core/assumptions/data/rate_refresher.dart` imports `package:http`. A unit test (`test/architecture_test.dart`) greps `lib/` and fails on a violation.

### Dependencies (resolved with `flutter pub add --dry-run` on Flutter 3.47.7 / Dart 3.13.5, 2026-10-16)

| Package | Version | Why (one line) |
|---|---|---|
| `flutter_riverpod` | ^3.4.3 | Owner decision: state management. |
| `drift` | ^2.35.2 | Owner decision (ADR-0001): SQLite access with typed queries and `watch()` streams. |
| `drift_flutter` | ^0.3.1 | Opens the DB on device and bundles sqlite via `sqlite3` 3.x build hooks. Not a direct dependency on `sqlite3_flutter_libs` (end-of-life, `0.6.0+eol`); `drift_flutter` 0.3.1 still pulls it (and `sqlcipher_flutter_libs`) in transitively — verified in Phase 0. Revisit when `drift_flutter` drops it. |
| `path_provider` | ^2.1.6 | `getApplicationSupportDirectory` for the DB file (ADR-0001). `drift_flutter` defaults to the *documents* dir, which is user-visible on iOS — we pass `DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory)`. Already transitive; direct because we call it. |
| `decimal` | ^3.2.6 | Money is `Decimal` (project rule). Pulls `rational`. |
| `http` | ^1.6.0 | The one network call (ADR-0003). Chosen over `dart:io HttpClient` for `MockClient`, which makes AC-25/26/29 plain unit tests. |
| `intl` | ^0.20.3 | Pinned by `flutter_localizations`; locale symbols and `DateFormat`. |
| `flutter_localizations` | sdk | English + Arabic RTL. |
| dev: `drift_dev` | ^2.35.1 | Generates Drift table/row classes. |
| dev: `build_runner` | ^2.16.2 | Runs `drift_dev`. (2.17.1 exists but is held back by the current constraint set; take what resolves.) |
| dev: `integration_test` | sdk | Golden-path test on a simulator. |

Not added: `uuid` (10-line `newId()` in `core/ids.dart`), `riverpod_generator`/`riverpod_annotation`, `go_router`, `freezed`, `json_serializable`, `equatable`, `sqlite3_flutter_libs`, `shared_preferences` (settings live in Drift — one store).

### Code generation

- **Drift: yes.** Hand-writing `TableInfo` classes is hundreds of lines per table and error-prone; `drift_dev` is how Drift is meant to be used. Generated `*.g.dart` is committed so `flutter test` on CI needs no build step; CI runs `dart run build_runner build --delete-conflicting-outputs` and fails on a diff.
- **Riverpod: no.** About 15 providers. Plain `Provider` / `StreamProvider` / `FutureProvider` / `Notifier` + `.family` are a few lines each; the generator adds an annotation package and a second generated file per provider for no behaviour.
- **l10n:** Flutter's built-in `gen-l10n` (`generate: true`), not build_runner.

### Navigation

Plain `Navigator.push(MaterialPageRoute(...))` and `showModalBottomSheet`. One root (Home, S2), no tabs, no deep links, no web URLs (UX §1). `go_router` solves none of those problems for us.

### Widgets

Material 3 everywhere, with Flutter's `.adaptive` constructors (`Switch.adaptive`, `Slider.adaptive`, `CircularProgressIndicator.adaptive`, `showAdaptiveDialog`) where the UX asks for an iOS feel — no parallel Cupertino widget trees.

## Why

1. A fresh `flutter create` app needs one agreed shape before the first story, or each phase invents its own.
2. Every dependency above maps to an owner decision or a test that would otherwise need a real network/device. Weight: all are pure Dart except `sqlite3` (native library, ~1–2 MB per ABI); binary impact is measured once in phase 4 with `flutter build apk --analyze-size`, not guessed.
3. Verified, not assumed: in a scratch Dart project, `drift 2.35.2` `NativeDatabase.memory()` opened SQLite 3.54.0 on the host through build hooks (so tests need no system sqlite), and the `decimal 3.2.6` API reproduced AC-12, AC-14, AC-15, AC-30, AC-34 and AC-37 to the stated figures. The same probe showed `SELECT 1.10 * 3` = `3.3000000000000003` — so Decimals are stored as TEXT, never REAL.
4. **Refines ADR-0001:** ADR-0001 says "one repository interface per feature". Rates, inflation overrides and settings are needed by this feature now and by UC-3 (zakat) next, and features may not import each other, so they live in `lib/core/assumptions/` behind one `AssumptionsRepository` (mirrors the UX "Assumptions" screen). So: one interface per *aggregate with real queries* — two in v1 (`InvestmentsRepository`, `AssumptionsRepository`). No other change to ADR-0001.

## Rejected alternatives

- **`riverpod_generator`** — extra generated files and an annotation dependency for ~15 trivial providers.
- **`go_router`** — declarative URLs and deep links we do not have.
- **`sqlite3_flutter_libs` + manual `NativeDatabase` setup** — end-of-life package; `drift_flutter` is the maintained path.
- **`uuid` package** — a dependency for ten lines of `Random.secure` code.
- **Layer-first folders (`lib/models`, `lib/screens`)** — owner chose feature-first.
- **Separate Cupertino screens on iOS** — two widget trees to keep in sync for a look-and-feel nuance.
- **Rates/settings inside `features/investments/`** — UC-3 would have to import a feature.

## Trigger to revisit

- A second feature with its own data (UC-3, UC-5): decide then whether it gets its own repository or extends `AssumptionsRepository`.
- Deep links, a tab bar, or web support → reconsider `go_router`.
- Provider count passes ~40 or boilerplate becomes a review complaint → reconsider `riverpod_generator`.
- `flutter build apk --analyze-size` shows the sqlite native lib dominating app size.

## Amendment 2026-10-24 — feature imports and the settings seam (zakat spec Z1, Z2)

**Rule, as it really is:** a feature may import `features/investments`. `features/investments` never imports another feature, with one exception: `features/settings`. No other feature-to-feature import. `test/architecture_test.dart` enforces it: `lib/features/investments/` imports no `features/(zakat|overview|plan)/`, and `lib/features/zakat/` imports no `features/(overview|plan|settings)/`.

**Why:** Overview already imports `features/investments` (11 imports, plus `main.dart` for `AppShell.select`) on `main`, so "never feature → feature" was already broken and untested. The Zakat tab needs `PortfolioCalculator`, `resolve()`, the why sheet, `DateField`, the unit picker, the rate dialog and `ItemDetailScreen`. Writing down what is true and testing it beats a third pattern.

**Rejected:** zakat inside `features/investments/` (the folder becomes the whole app); callbacks injected from `main.dart` (10+ widgets and providers would pass them through constructors); moving the calculator and shared widgets to `lib/core/` (~40 files churn for no behaviour change).

**One injection seam (Z2):** `zakatSettingsSectionProvider` (`Provider<WidgetBuilder?>`, default `null`) in `investments_providers.dart`, overridden in `main.dart` with the zakat feature's `ZakatSettingsSection`. When set, S8 shows it in place of its own zakat-year radio. It is the only place the arrow points backwards (investments to zakat), and it points through a provider, not an import.

**Dependencies added by this feature:** `hijri` ([ADR-0007](0007-hijri-calendar.md)), `flutter_local_notifications` and `timezone` ([ADR-0008](0008-local-notifications.md)).
