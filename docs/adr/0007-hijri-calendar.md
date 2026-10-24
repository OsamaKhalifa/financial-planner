# ADR-0007 — Hijri dates from the `hijri` package (Umm al-Qura)

**Status:** proposed · 2026-10-24 · architect · facts verified 2026-10-23 in a scratch Dart project

## Decision

Lunar zakat due dates are converted with pub.dev **`hijri` 3.0.1** (Umm al-Qura table), called from exactly one file, `lib/core/dates.dart`, which returns UTC calendar dates like every other helper there (spec D3).

### What the app uses from it

| Call | Use |
|---|---|
| `HijriCalendar().hijriToGregorian(y, m, d)` | due date of Hijri year *y* (story §5.2). Returns a **local** `DateTime` → `dates.dart` rebuilds it as `DateTime.utc(g.year, g.month, g.day)`. |
| `HijriCalendar().getDaysInMonth(y, m)` | day 30 → 29 rule (C3). Ramadan 1447 = 30 days, 1448 = 29. |
| `HijriCalendar.fromDate(DateTime(y, m, d))` | Hijri date of a Gregorian day: the first year on or after the save date, and the "{h} AH" line under solar dates (UX 2.4.1). 2026-10-23 → 1448-05-12. |

Checked values: 1 Ramadan 1446 = 2025-03-01, 1447 = 2026-02-18, 1448 = 2027-02-08; 1 Muharram 1448 = 2026-06-16 (AC-2, AC-35).

### Rules for the one caller

- **Never use the package's month names or `HijriCalendar.language`** (a global static). Month names are the ARB `hijriMonth` select message (en + ar).
- **Range:** the table covers 1356–1500 AH (≈ 1937–2077). Outside it the package throws `ArgumentError`. `dates.dart` turns that into `null`; a year that cannot be converted is not created and the year list stops there. No user today is near either end.
- `package:hijri` is imported only by `lib/core/dates.dart` — a line in `test/architecture_test.dart` enforces it.

## Why

Story §4 and C3 name Umm al-Qura as the converter. Dart's `intl` has no Hijri calendar. The package is pure Dart (no Flutter, no platform channel), so the domain stays testable with plain unit tests and no fakes.

**Weight:** no dependencies; three source files, 32 KB of Dart, of which 20 KB is the month-length table. BSD-2-Clause licence (keep the notice; Flutter's licence page shows it automatically).

**Age and activity:** 3.0.1 published 2026-05-22 (more than two weeks old); previous release 3.0.0 in 2021. Slow-moving is fine here: the Umm al-Qura table for past years does not change. `4.0.0-beta.1` exists — not taken (beta).

## Rejected alternatives

- **Platform calendars** (iOS `Calendar(identifier: .islamicUmmAlQura)`, Android `android.icu.util.IslamicCalendar` UMALQURA) — exact and maintained by the OS, but needs a method channel, native code on two platforms, and a fake in every domain test.
- **Our own Umm al-Qura table in `lib/core/`** — the same 20 KB of numbers copied by hand, with no upstream to compare against; an error would move zakat dates.
- **Arithmetic (tabular) Hijri calendar** — off by 1–2 days from Umm al-Qura in many months; the story asks for Umm al-Qura.

## Trigger to revisit

- A user's due date is reported wrong against the official Umm al-Qura calendar → compare with the platform calendar and switch if the package is wrong.
- A due date after 1500 AH is needed, or the package is discontinued with a known table bug.
- The consultant asks for a calendar other than Umm al-Qura (today the user moves the date ±2 days instead, C3).
