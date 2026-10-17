# Business Requirements — Financial Planner

**Status:** v0 draft · 2026-10-16 · PM hat
**Owner:** @OsamaKhalifa
**Scope of this doc:** vision, personas, use cases, non-goals. Not a spec.

---

## 1. Vision

A pocket financial planner for a Muslim user who wants to **track what they own, know their zakat, keep their investments halal, and plan without riba** — on their phone, with no account to create and no data leaving the device.

One sentence: **"Know what you own, know what you owe, know what is halal."**

## 2. Why this exists

Existing finance apps are either:
- Western-first, no Islamic lens (zakat is an afterthought, haram screening missing).
- Islamic-first but shallow (zakat calculator only, no portfolio).
- Server-tied and bank-linked (data leaves the user).

Gap: **private, mobile, Islamic-aware, works offline.**

## 3. Personas

### 3.1 The Salaried Saver — Yasmin
- 20s–40s, salaried, saves monthly.
- Owns some cash, maybe gold, maybe a few mutual funds.
- Wants: know her zakat, know which funds are halal, keep a goal (hajj, down payment).
- Does not want: brokerage integration, auto-trading, "wealth management."

### 3.2 The DIY Investor — Khaled
- 30s–50s, picks stocks himself.
- Owns a brokerage account outside this app, enters positions by hand.
- Wants: screen each ticker for halal, see portfolio-level ROI and risk, zakat on tradable holdings.
- Does not want: tips, signals, social features.

### 3.3 The Debt-Avoider — Amira
- Any age, actively avoids interest-based loans.
- Tracks what she owes to family, what family owes her (`qard hasan` style).
- Wants: no-interest debt ledger, reminders, zakat treatment of debts owed to her.
- Does not want: credit score tracking, loan offers.

**v1 target:** all three. Amira is served by UC-5 (debts) and UC-7 (budget).

## 4. Core use cases (v1)

### UC-1 — Record my holdings
Add a position by hand: name, type (cash / gold / silver / stock / fund / crypto / other), quantity, cost basis, currency, date acquired. No bank link, no broker API in v1.

### UC-2 — See my net worth
Dashboard with total value in a chosen base currency, breakdown by asset class, ROI since start.

**Open question for architect/PM:** price source for stocks, funds, gold, crypto, FX? Options: user enters manually; app calls a free API (Yahoo, CoinGecko, metals-api); hybrid (manual with optional refresh). Decision needed before UC-2 is a real story.

### UC-3 — Calculate my zakat
Enter hawl start date. App computes zakat on eligible wealth as of today or a chosen date. Shows:
- Nisab (gold **and** silver, user picks convention).
- Eligible wealth breakdown.
- Zakat amount at 2.5%.
- Each rule linked to its source in `docs/product/shariah/zakat.md`.

### UC-4 — Screen a stock or fund for halal
User enters ticker + exchange. App shows a verdict (compliant / questionable / non-compliant) plus:
- Business activity screen (sector exclusions).
- Financial ratios (debt/assets, interest income %, cash+receivables/assets) under a named methodology (AAOIFI SS No. 21 or Dow Jones Islamic — one chosen in a Shariah ADR).
- Links to source.

**Open question:** data source for screening. Candidates to evaluate (pricing and terms **not yet verified**): Zoya, Musaffa, Islamicly, or raw fundamentals (e.g. Finnhub) + our own ratio calc. Decision needed before UC-4 is a real story.

### UC-5 — Track my halal debts
Add a debt (I owe someone / someone owes me). No interest. Due date optional. Mark paid. See total "lent to others" and "borrowed from others". Zakat treatment per Shariah consultant.

### UC-6 — Track a saving goal
One goal, name + target amount + target date. See monthly amount needed. No investment advice.

### UC-7 — Halal monthly budget
Set monthly income and spending categories. Record spending by hand. See spent vs planned per category. Flag categories the user marks as "to avoid" (e.g. interest payments) so they see riba leakage at a glance. No bank sync.

## 5. Non-goals (v1)

- No server, no cloud sync. Device-only.
- No bank integration, no broker integration.
- No tax reporting (country-specific, out of scope).
- No social features, no sharing, no leaderboards.
- No notifications in v1 (opt-in local reminders in v1.1 maybe).
- No ads, no in-app purchases, no premium tier.
- No "robo-advisor." We do not pick investments.
- No crypto beyond manual entry. Shariah consultant decides which coins are in scope at all.
- No forward/futures/options. Full stop.

## 6. Platforms

- iOS 15+ · iPhone first. iPad later. (Flutter's current minimum.)
- Android 7+ (SDK 24) · phones first.
- Flutter stable channel.
- English + Arabic (RTL). More languages later.

## 7. Data

- All user data stored locally on device.
- Encrypted at rest (platform secure storage for keys, local DB encrypted).
- Export: user can export their data as JSON for their own backup.
- Import: from an exported JSON only. No CSV broker import in v1.
- No telemetry in v1. No crash reports sent off-device unless the user opts in on first launch (decision deferred to UX).

## 8. Shariah touchpoints (every one must be a story)

- Zakat rules (nisab, hawl, eligible assets, rates for gold/silver/cash/stocks/debts). Owner: Islamic consultant.
- Haram business activity list and ratio thresholds. Owner: Islamic consultant.
- Gold vs silver nisab convention (user choice, both shown with sources).
- Qard hasan modeling (no interest, zakat on debts owed to the user).
- Crypto position: which coins, under what reasoning, with named scholar.
- Mixed-income purification (if a fund has <5% interest income, do we subtract that %?).

Each gets one file in `docs/product/shariah/`.

## 9. Open decisions (block v1 stories)

1. Price data source for UC-2.
2. Screening data source for UC-4.
3. ~~Local DB choice~~ — decided: SQLite behind repository interfaces, swappable for a server store later (ADR-0001).
4. Which crypto, if any, in v1.
5. Base currency: single pick on onboarding, or multi-currency portfolio? (UX + architect call.)

## 10. Success criteria (v1)

- A new user can onboard, add 5 holdings, see their net worth, compute zakat, screen 1 stock, add 1 debt, set a budget, and track 1 goal — **in under 10 minutes, with no account**.
- Every money rule in the app has a visible "why" with a reference.
- Zero user data leaves the device without an explicit user action. (The optional rate refresh sends only a request for public FX and gold/silver rates — the same request for every user.)

---

**Next up:** Islamic consultant writes `docs/product/shariah/zakat.md` and `docs/product/shariah/screening.md`. Architect writes ADR-0001 (local DB) and ADR-0002 (project layout). Then PM breaks UC-1 and UC-3 into stories with acceptance criteria.
