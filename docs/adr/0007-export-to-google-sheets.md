# ADR-0007 — Export to Google Sheets from the phone, no server

**Status:** accepted · 2026-10-23 · decided by @OsamaKhalifa

## Decision

Settings has a **Google Sheets** section. The user links a Google account, then taps one of two
exports. Each tap makes a **new spreadsheet** in the user's own Drive:

- **Everything (with history)** — every stored record: investments, history, rates, inflation
  overrides, settings, no-zakat years.
- **Snapshot (now)** — every investment with its last value and the since-start figures from
  `PortfolioCalculator.sinceStart` (value in base, gain, ROI, annualised), the latest rate per pair
  and source, and the other assumptions as they are now.

Sheet text is always English (`AppLocalizationsEn`), whatever the app language: stable headers for
formulas.

- Sign-in: `google_sign_in` (v7). The only scope is `drive.file` — the app can open only the files it
  created, never the user's other Drive files. It is a non-sensitive scope: no Google app review.
- Upload: two calls with raw `http`, like the AI clients — `spreadsheets.create` (tab names, bold
  frozen header) then `values:batchUpdate` with `USER_ENTERED`. Numbers go as their exact `Decimal`
  text and Sheets reads them as numbers, so no `double` is needed (ADR-0002 untouched).
- Text cells (names, notes, labels) get a leading `'`, so they stay text: a name `=HYPERLINK(...)` does not run, a note `1/2` does not turn into a date.
- Code: `lib/features/export/` — `export_tables.dart` (rows, pure), `data/google_sheets_client.dart`
  (HTTP), `export_providers.dart` (account + export action). Data is read through the existing
  providers; no repository change (ADR-0001 kept).

## Why

- Owner requirement: see and work with the data in a spreadsheet.
- "No server side in v1" holds: the phone talks to Google directly with the user's own token.
- "Data stays on the device" holds by default: nothing leaves until the user links an account and
  taps Export, and the section says so (same opt-in idea as cloud AI, ADR-0006).

## New dependencies

| Package | Why | Weight |
|---|---|---|
| `google_sign_in` | Native Google sign-in and an access token for `drive.file`. The only supported way on iOS and Android. | Google's own plugin (flutter.dev) |
| `url_launcher` | "Open in Sheets" after an export. | flutter.dev plugin |

Rejected: `googleapis` (large generated client for two calls), our own OAuth web flow (more code,
worse UX than the native sheet), CSV file + share sheet (not what the owner asked for).

## Setup (once, by the owner)

Google Cloud Console: enable the Google Sheets API; OAuth consent screen (External, Testing, owner as
test user, scope `drive.file`); OAuth clients for iOS (bundle `com.osamakhalifa.financialPlanner`),
Android (package `com.osamakhalifa.financial_planner` + SHA-1) and Web.

- `googleIosClientId` and `googleServerClientId` (the Web client) in
  `lib/features/export/export_providers.dart`.
- The reversed iOS client id in `ios/Flutter/GoogleSignIn.xcconfig` (the sign-in return URL).

Client ids are not secrets: they ship inside every app. Until they are set, Link shows
"Google sign-in is not set up in this build." and never calls Google: the iOS SDK throws a native
exception on an empty client id, which kills the app.

## Trigger to revisit

The app gets a server or real accounts; or the owner wants export on a schedule or into one fixed
sheet.
