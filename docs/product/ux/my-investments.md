# UX flow — My Investments

**Owner:** ux-expert · **Status:** v1 draft · 2026-10-16 · review loop 1 applied (PM + consultant)
**Input:** [story](../stories/my-investments.md) · [market research](../research/my-investments-market.md) · [zakat rules](../shariah/zakat-on-investments.md)
**Platform note:** one adaptive layout with platform-native controls (Cupertino feel on iOS first, Material 3 on Android); the architect decides the widget strategy.
**AC numbers** below refer to story §10 as renumbered on 2026-10-16.

---

## 0. Decisions this design is built on

**Decided** (owner, PM, consultant — 2026-10-16):

| # | Decision | Where it shows |
|---|---|---|
| D1 | **Optional online refresh** of FX and gold/silver rates. Only on tap; no background fetch (AC-25). The request is **identical for every user** — no currency list, amounts or identifiers (AC-26). Each fetched rate is stored with the **source's "as of" date** and source name (AC-27). A typed rate on the same date and pair wins; both kept (AC-28). Latest rates only — no past-date fetch. Item values are always typed. | S6 starts with it; S8 has it; inline Fetch only when the date needed is today. |
| D2 | **Shipped default inflation** per country and year, with source and "as of" year; user overrides any year; removing the override brings back the shipped value (AC-32). | Real figures visible from day one; each says Shipped / Yours / Assumed (2.9). |
| D3 | **Grams view (gold/silver): yes.** Zakat computed in money, then shown in grams; no inflation step; "yardstick, not a price index" (AC-39). | "Show in: EGP \| Gold g" toggle on S2 and S7. |
| D4 | **Zakat year** asked at setup, lunar 2.5 % / 354.367 days pre-selected and shown; solar 2.577 % / 365 the option; always a matched pair (AC-9). **Long-term shares method** asked at setup or when the first long-term stock/fund is added (AC-8). **Jewellery** asked when jewellery is first added. **Nisab metal** is not asked here (UC-3). **Pension** is not a type and not a setup question. | S1, S3. |
| D5 | **Intent** (trading / long-term / personal use / rental) drives the default zakat share (story §5.1). | S3. |
| D6 | **Interest (to purify)** is its own history record, not a money-out kind: *paid out to me* or *kept inside this item*, plus an **Interest given away** record, available for both cases (kept inside: lowers value and to-purify; paid out: lowers to-purify only). Never in return, gain or the zakat base; "to purify" total shown on its own, never netted against zakat (story §5.3–5.4, AC-19). | S4, S5, S2, S7. |
| D7 | Label "**Estimated zakat set-aside (planning). Actual zakat is due once a year on your zakat date.**" — never "zakat due" or "zakat paid". | S4, S7, §3. |
| D8 | **Stale now** = no entry in the current calendar month; no user setting (story §9.3). | S2, S6. |
| D9 | **Price × quantity** input help: when quantity is set, a value can be typed per unit; the stored value is price × quantity, shown before saving (story §5). | S5, S6. |

**Still pending** — places tagged would change:

| Tag | Working assumption | If it flips |
|---|---|---|
| **[F-GOLDBASE]** | Grams view decided yes; tag kept so the toggle stays easy to drop. | Remove the toggle on S2/S7. Nothing else depends on it. |
| **[F-DIV]** | Dividends-only = zakat share 0 % + the notice (story AC-5). The consultant proposes a set-aside on dividends received (see PM-Q1). | S7 ladder gains a "set-aside on dividends" amount; the notice text changes. |

Q5 (real totals), Q6 (no third-unit conversion) and Q7 (Gregorian year) are decided; no flip tags.

---

## 1. Screen list (and what was merged)

| # | Screen | Kind | Merged in it |
|---|---|---|---|
| S1 | **Setup** (first run only) | 2-step full screen | Base currency + home inflation + zakat year + long-term method. |
| S2 | **Home** (investments list + totals) | Main | Totals, this-year verdict, to-purify total, stale summary, list, sort. Home *is* the list. |
| S3 | **Investment form** (add / edit) | Full-screen sheet | Add and edit are one form; fields per asset type. |
| S4 | **Item detail** | Main | Returns + whole history in one scroll. |
| S5 | **Record sheet** | Bottom sheet | Money in, money out, value update, interest — one sheet. Same sheet edits a history entry. |
| S6 | **Update all** | Main | Rate refresh + stale rates + stale item values. One list, one Save. |
| S7 | **Period view** | Main | Month / Year, before/after set-aside, before/after inflation, purchasing-power gap, no-zakat switch with nisab hint. Portfolio or one item (scope picker). |
| S8 | **Assumptions** | Main | Rates, inflation series, base, home inflation, zakat choices, no-zakat years. Replaces separate "Settings" and "Rates" screens. |
| S9 | **Why sheet** | Bottom sheet (one component) | Every explanation. |
| — | Unit picker, inline rate entry | Shared sheets / rows | Used by S1, S3, S5, S6, S7, S8. |

**Why merge this way:** three jobs — *record* (S3 + S5), *keep current* (S6, S8 for corrections), *judge* (S2, S4, S7). Rates, inflation and zakat choices are all "assumptions behind the numbers", so they live together in S8, and every why sheet deep-links to the exact S8 row.

**Navigation:** S2 is the root. No tab bar in v1. Home top bar: title, **Assumptions** icon (S8). Everything else is reached by tapping content.

---

## 2. Flows

### 2.1 First run — Setup (S1)

**Entry point:** first launch (no base currency stored).

1. **Step 1 — "What currency do you count your wealth in?"**
   - Sees: unit picker inline (phone-region currency first, then §6.3 order). Below: "Home inflation: Egypt (from EGP) · Change". Line: "Totals, monthly and yearly figures, and zakat set-aside use this currency. You can change it later."
   - App: stores base and home series. Shipped inflation is used at once (D2).
2. **Step 2 — "How do you calculate zakat?"** (D4). Two rows; each has a one-line why and **Source** (S9 with the views and references).
   | Choice | Options (source named in the option) | One-line why | Ref |
   |---|---|---|---|
   | Zakat year | **Lunar — 2.5 % over 354 days** (pre-selected, shown) · Solar — 2.577 % over 365 days (AAOIFI) | "Some scholars allow a solar year with an adjusted rate; others keep the lunar year." | A1, A2 |
   | Long-held shares and funds | **Dividends only (IIFA)** · **25 % of value (NZF proxy)** · **Full value (precaution)** · I'll decide per item | "When company data is unknown, scholars use different methods." | B3, B4 |
   - Long-term row has **Not now**: then it is asked when the first long-term stock or fund is added (AC-8). Nothing pre-selected on that row.
   - Jewellery and nisab are not asked here: jewellery is asked when first added (2.3), nisab belongs to UC-3 (only a hint in 2.10).
   - Does: confirms / answers, taps **Done** (primary).
3. **Empty Home.** "No investments yet." + primary **Add investment** + chips "Monthly fund", "Gold", "Stock" (open S3 with type preset). Line: "Your data stays on this phone."

**Exit:** Done → S2 empty. Back on step 2 → step 1. App killed mid-setup → restarts at step 1 with base kept if chosen.

### 2.2 Home — investments list (S2)

**Entry point:** launch, back from any screen.

1. **Totals card**
   - "Total value" — big, base currency, "as of {latest date used}". Values are net of interest kept inside items (story §5.4).
   - If items excluded: "Excludes 1 item — USD→EGP rate missing" → S6 at that rate.
   - **Show in: EGP | Gold g** (D3) [F-GOLDBASE].
   - **To purify** line, only if > 0: "Interest to purify: 500.00 EGP ⓘ" → S9 (D6).
2. **This-year verdict row** — "2026 so far: purchasing power **kept +407.75 EGP**" / "**lost −566.50 EGP**" (after set-aside, after home inflation). Tag under it when inflation is shipped or assumed (2.9). Tap → S7, Year.
3. **Stale banner** (only if anything is stale, D8) — "4 values and 2 rates not updated this month · **Update all**" → S6.
4. **List** — "Sort: Value ▾" (Value in base · Return since start · Name · Oldest update first). Default Value, highest first; persists. Sections **Open**, then **Closed (3)** collapsed.
5. **Primary action:** floating **+ Add** (S3).

**List row** (end-aligned numbers, mirrors in RTL):
- Start: name; under it type · market ("Stock · NASDAQ") or grams ("17.5 g pure").
- End: value in base (large); under it return since start in base, signed. If item unit ≠ base: third line "1,050 USD".
- **Stale marker:** dot + text "Not updated this month", or for metal items "Gold rate not updated this month". Never colour only.
- **Missing rate:** base value "—", "USD→EGP rate missing · Add" → inline rate entry (2.8).

### 2.3 Add / edit investment (S3)

**Entry point:** + Add on S2, chip on empty state, Edit on S4.

One scrolling form. Asset type is first; it decides which fields show. Hidden fields are not asked or validated.

| Field | Stock · Fund/ETF | Sukuk | Gold · Silver | Cash deposit | Crypto | Other (real estate, business, pension, …) |
|---|---|---|---|---|---|---|
| Name | yes | yes | yes | yes | yes | yes |
| Market | stock: required; fund: optional | optional | — | — | — | — |
| Item unit | default from market / base | default base | fixed XAU-g / XAG-g (hidden) | default base | default base | default base |
| Start date | yes | yes | yes | yes | yes | yes |
| Paid (first money in) | yes | yes | yes (default base) | yes | yes | yes |
| Current value + date | optional (defaults to paid) | optional | — (grams × rate) | optional | optional | optional |
| Quantity | optional | optional | **Grams**, required | — | optional | optional |
| Purity | — | — | **Karat chips 24/22/21/18**; silver 999/925 | — | — | — |
| **Intent** | Trading · Long-term — required, nothing pre-selected | — | Savings (bullion, default) · Personal use (jewellery) | — | — | Trading · Long-term · Personal use · Rental — required |
| **Zakat share** | from intent (below) | **100 %**, shown | from intent | **100 %**, shown | **100 %** + notice | **typed by the user**, no prefill |
| Inflation series | under "More", default shown | same | same (home) | same | same | same |
| Notes | under "More" | same | same | same | same | same |

1. Picks type → right fields with defaults.
2. **Intent → zakat share.** The A9 status line from the zakat file always sits under the share, with **Source**:
   - **Stock/fund, Trading** → 100 %: "Zakat: on 100 % of market value. You hold this to sell. — IIFA Res 28 (3/4) §3."
   - **Stock/fund, Long-term** → the setup method. If it was "Not now" or "per item", the 3-way method choice (sources named, as in S1) opens here. Results: Full value → 100 %; NZF proxy → 25 %; **Dividends only → 0 %** with the notice "**Zakat on your dividends is counted with your cash.**" (AC-5) [F-DIV].
   - **Sukuk** → 100 % (B4). No method question.
   - **Gold/silver, Savings** → 100 %. **Personal use** → the jewellery ruling; asked here the first time (Zakatable · Not zakatable, one-line why "The schools differ on jewellery that is worn.", Source B2), then remembered in S8.
   - **Crypto** → 100 % with the notice "**Scholars differ on whether holding crypto is permitted. Those who permit it say zakat is on its full market value.**" + Source B8 (AC-6).
   - **Other** → share field empty; save is blocked until filled (AC-7). Help under the field depends on intent:
     - Long-term (business, private stake): "Enter the zakatable part of the business: cash, receivables and stock for sale, less short-term debts. Machines and buildings are not counted." — B6. The listed-shares methods are **not** offered.
     - Rental: "Zakat is not on the property; rent you still hold is counted with your cash. Usually 0 %." — B5.
     - Personal use: "Personal-use items: usually 0 %." — B5.
     - Trading: "Bought to resell: usually 100 % of market value." — B5.
     - Pension (typed as Other): help links to B7's three views; the user types the %.
     - Each hint has a tap-to-fill chip ("Use 0 %") — the user's tap, never a silent default.
   - Stocks also get a "Company pays zakat for me (0 %)" switch (B3); every type except cash/sukuk/crypto gets "Custom %". The why then says "You changed this from {x} %".
   - `[U]` references show "source not yet verified".
3. **Inline rate capture:** if "Paid" unit ≠ item unit and no rate exists on the start date, a row appears under "Paid": "1 USD = ____ EGP on 1 Mar 2026". **Fetch** appears on this row only when the start date is today (D1); it runs the same identical refresh. Result line "= 1,000.00 USD paid" (AC-24). Gold: "1 g 24k gold = ____ EGP" → "= 10.40 g pure gold paid" (AC-37). The rate joins the one rate history.
4. **Save** (primary).

**Exits:**
- Success → S4 of the new item, toast "Saved".
- Cancel with changes → "Discard this investment?" (Discard / Keep editing).
- Validation → stays; each missing field named inline + top summary "3 fields need attention" (AC-1). Paid = 0 → "Must be more than 0"; date pickers offer no future dates (AC-2).
- Write fails → "Could not save. Nothing was changed. Try again."

**Edit:** same form, filled. Changing type, unit, purity, intent or share on an item with history → "This recalculates every past month for this item." (confirm). Delete at the bottom: "Delete investment and its whole history?" + **Undo** toast 10 s.

### 2.4 Item detail (S4)

**Entry point:** row on S2; after save on S3; item row on S7.

1. **Header:** name, type · market · intent, Edit. Value now in item unit (large) + "≈ 57,750 EGP" if different. "Value from 31 Dec 2026" + stale marker if stale.
2. **Returns card — "Since start"** (two columns only when item unit ≠ base). All rows use the held period (story §9.2):
   | Row | In USD (item) | In EGP (base) |
   |---|---|---|
   | Gain | +50.00 USD | +7,750.00 EGP |
   | Return | +5.00 % | +15.50 % |
   | Per year | only if held ≥ 1 year (AC-11) | same |
   | Estimated set-aside | — | −x EGP |
   | Return after set-aside | — | +x.xx % |
   | Real | **Own market** (US inflation): +1.94 % | **In your money** (Egypt inflation): −3.75 % |
   - Under real: "Purchasing power (for planning only — zakat is always on today's actual value)." (AC-35) + inflation tag (2.9).
   - Link **By month and year** → S7 scoped to this item.
3. **To purify** (only if any interest recorded): "Interest to purify: 500.00 EGP · not counted as return ⓘ" + text button **Record given away** (opens S5 on Interest → Given away).
4. **Zakat line** — intent + A9 status line + Source (+ dividends-only or crypto notice where it applies).
5. **History** — newest first: money in, money out (sale / income), interest received (paid out / kept inside), interest given away, value updates (gold: gram changes). Row: date, kind label + icon, signed amount + unit. Tap → S5 edit. Swipe → delete + Undo.
6. **Primary action:** **Record** (S5). Closed item: banner "Closed on 30 Apr 2026", no Record; "Reopen" in overflow.

### 2.5 Record sheet (S5)

**Entry point:** Record on S4; "Record given away" on S4; tap a history row (edit).

1. Switch **Value · In · Out · Interest** (default Value, the most frequent). Interest is shown in the switch for cash deposit, sukuk and other; for other types it is under "More" (rare there). Date (default today). Amount + unit (default item unit; §6.3 order).
2. Per kind:
   - **Value update:** value in item unit; reference "Last: 1,050.00 USD on 31 Dec 2026". If quantity is set: toggle **Total · Per unit**; per unit shows "× 120 units = 14,800.00 USD" before saving (D9). Gold: new grams (only when grams changed outside a buy/sell).
   - **Money in:** amount, unit, optional "value after" (else value rises by the amount). Gold: amount paid + grams bought (pure grams live).
   - **Money out:** amount, unit, kind **Sale · Income received**. Optional "Value left". If amount > current value → "Value left" required: "This is more than the item's value. Enter what is left (0 or more)." Value left = 0 → "This closes the investment. It stays in past months." (AC-4)
   - **Interest:** sub-switch **Received · Given away**.
     - *Received:* amount, unit, and **Where is it? Paid out to me · Kept inside this item**. Line: "Interest is not counted as return and not in the zakat base. It is shown as 'to purify' so you can give it away. · Source" (Z-6).
     - *Given away:* amount (up to this item's to-purify total) and **Given from: Interest kept inside this item · Interest paid out to me**. Default = the case that still has interest to purify; if only one case has any, the other option is hidden. Line: "**Giving it away does not count as zakat.**" (B1, Z-6). Effect line changes with the choice:
       - kept inside → "Lowers the item's value and the to-purify total by the same amount. Return is not affected."
       - paid out → "Lowers the to-purify total. The item's value does not change."
3. Inline rate capture if needed (2.3 step 3; Fetch only when the date is today).
4. **Typo check:** a value or rate > 50 % away from the last → non-blocking line "This is 10× the last value. Check the number."
5. **Save** → S4, recalculated.

**Errors:** date before start → "Can't be before the start date (10 Jan 2026)". Same-date value update → "Replace the value of 31 Dec 2026?" Given away > what is left to purify in that case → "You have 500.00 interest {kept inside this item / paid out to you} still to purify. Enter 500.00 or less."

### 2.6 Update all (S6) — the make-or-break flow

**Entry point:** stale banner on S2; "rate missing" links on S2/S7; "Update all" on S8.

**Goal:** monthly update of 10 items and 3 rates in under 60 seconds, one hand, never leaving the screen.

1. **Step A — Refresh rates (D1).** Top card: **Refresh rates online** (primary until it has run). Under it: "Downloads the same public price list for everyone. Nothing about you is sent." and "Last refresh: rates as of 30 Sep 2026 · {source}".
   - The request is the same for every user (AC-26); the app keeps from the answer every pair the source gives.
   - While fetching: progress on the card; the list below stays usable.
   - After: "Rates as of 15 Oct 2026 · {source} · 3 of your rates updated". The date is the **source's "as of" date**, never the phone's time (AC-27). If the source's date is still before this month, those rates stay stale — honest, not hidden.
   - Fails (offline, source down): "Couldn't refresh. Nothing changed. Your saved rates are still used — type a rate below if you have a newer one." (AC-29) Never blocks.
   - Skippable: the user can ignore the card and type.
2. **"As of" date** for typed rows, one for the whole screen (default today; can be set to e.g. the last day of last month).
3. **Step B — still stale**, one list in this order:
   1. **Rates still old** — pairs the refresh did not cover, or all pairs if refresh was skipped. Row: "1 KWD = ____ EGP", hint "last 160.20 · 30 Sep · typed by you". Refreshed pairs collapse into one line "3 rates refreshed (as of 15 Oct) ›"; expanding lets the user type an override for the same date (AC-28).
   2. **Item values** — every open non-metal item that is stale (D8). Row: name, unit, field, hint "last 1,050.00 · 30 Sep". **Total · Per unit** toggle on rows with quantity (D9). Metal items are not listed: the gold rate line says "moves 3 gold items" (AC-38).
   (No inflation rows: shipped defaults cover them; overrides live in S8.)
4. **Speed details:**
   - After refresh (or skip), focus goes to the first empty field with the number keyboard open; "Next" walks every row. No row needs a tap to open.
   - **Same** button per row: records the last value again on the "as of" date; clears its stale mark.
   - Blank rows are skipped, not errors. Partial saves are normal.
   - Bottom bar counter: "7 of 10 filled". Typo check per row, inline, never blocking.
   - "Show all" switch: off = stale only (default); on = every open item and every rate in use.
5. **Save** (single primary in the bottom bar once refresh has run or been skipped) → all typed rows in one write (all or nothing). Fetched rates are saved when the fetch succeeds, so Discard does not lose them. Back to origin with toast "Updated 7 values. 3 still old."

**Exits:** back with typed rows → "Save 7 updates?" (Save / Discard). Write fail → "Could not save. Nothing was changed." rows kept. Nothing stale → "Everything is up to date for October 2026" + refresh card + "Show all".

### 2.7 Assumptions (S8)

**Entry point:** Home top-bar icon; every why sheet's "Change" link (lands on the row).

1. **Base and home** — base currency (change → "All totals and months recalculate"), home inflation series.
2. **Rates** — header **Refresh rates online** (same action as S6). Pairs in use, then "Other pairs". Row: "1 USD = 48.50 EGP · as of 15 Oct 2026" + origin tag **{source}** or **Typed by you**, stale/missing marker. If a typed and a fetched rate share a date: "Your rate is used (source gave 48.50)". Tap → pair history (dated; add, edit, delete + Undo; fetched rows are overridden by typing, not edited). Add-rate sheet: pair picker (§6.3), **swap direction**, date, rate, inverse shown live ("1 EGP = 0.0206 USD") so a reversed entry is visible (AC-23).
3. **Inflation** — series in use. Row: "Egypt · 2026 assumed from 2025 · 2025 25.0 % shipped (World Bank, as of 2025)". Tap → year list, each year **Shipped** or **Yours**; tap a year → type an override; overridden years show "Reset to shipped" (AC-32). Empty series: "No data for {country}. Add a year to see real figures for items using it."
4. **Zakat** — Zakat year, Long-term method, Jewellery ruling (each with Source; jewellery shows "Not asked yet" until first jewellery). **No zakat due by year**: one row per year with the switch, help text and nisab hint (same block as 2.10 step 7).
5. **Update all** button → S6.

### 2.8 Missing-rate states (everywhere)

A missing rate never becomes 1:1 and never blocks typing.
- **S2 row:** base value "—", "USD→EGP rate missing · Add". Totals card "Excludes 1 item".
- **S4:** base column "Needs USD→EGP rate" + inline field.
- **S7:** **Excluded** group: "US stock — USD→EGP rate missing" (AC-21). Verdict says "Based on 4 of 5 items".
- **Inline rate entry** (shared): "1 USD = ____ EGP on {date needed}" + Save; **Fetch** only if that date is today.
- **Stale rate:** figure shown, marked "rate not updated in this period" (AC-22).

### 2.9 Inflation source states (D2)

Every real figure has a short tappable tag → S9 → S8 row:
- **Shipped** — "Egypt inflation: shipped ({source}, as of 2025)". Quiet style.
- **Yours** — no tag on the figure; named in the why sheet.
- **Assumed** — "inflation assumed from 2025" (AC-33). Stronger marker.
- **Empty series** — real figures replaced by "No inflation data for {country} · Add" + inline "____ %". Before-inflation figures stay.

### 2.10 Period view (S7)

**Entry point:** this-year row on S2 (Year, current year); "By month and year" on S4 (scoped).

1. **Header:** scope "All investments ▾" (or one item) · **Month | Year** · **Show in: EGP | Gold g** [F-GOLDBASE] · stepper "‹ April 2026 ›" (mirrors in RTL).
2. **The ladder** — all steps visible at once, top to bottom:
   | Line | Month example (AC-14) | Year example (AC-15) |
   |---|---|---|
   | Return | +2.37 % | +15.00 % |
   | Estimated zakat set-aside | −30.69 EGP | −592.25 EGP |
   | Return after set-aside | +2.19 % | +12.04 % |
   | Inflation (Egypt) · tag | 0.79 % for this period | 10.00 % |
   | **Real return after set-aside** | **+1.39 %** | **+1.85 %** |
   Smaller line: "Real return before set-aside" (AC-15: +4.55 %).
   - Set-aside row label is the D7 text, shortened on the row to "Estimated zakat set-aside (planning)" with the second sentence under it: "Actual zakat is due once a year on your zakat date."
3. **To purify** (only if any interest in the period): line under the ladder, "Interest to purify: 500.00 EGP — not in return, not netted against the set-aside" (AC-19).
4. **Verdict block:**
   - "**Kept** purchasing power, after set-aside · **+407.75 EGP**" / "**Lost** · **−566.50 EGP**" (AC-15, AC-17). Word + sign + icon.
   - "Needed: end value 22,581.48 EGP (return 12.91 %)" (AC-15).
   - "Purchasing power (for planning only — zakat is always on today's actual value)." (AC-35)
   - Grams view: "Lost 0.45 g gold after set-aside" (AC-39); the inflation line is replaced by "No inflation step: in gold, the gram is the measure. Gold is a yardstick, not a price index."
5. **Markers line** (if any): "2 items not updated this period · rate not updated in this period · inflation assumed from 2025". Each tappable → its fix.
6. **Items in this period** (scope = all): row per item with its figure and marker → S4. Then **Excluded** group (2.8).
7. **No-zakat block** (Year view only; also in S8):
   - Switch "**No zakat due for 2026**". Off by default. **Never set automatically.**
   - Help text: "**Decide using all your zakatable wealth, not only this list.**" (AC-18)
   - **Nisab hint** (consultant Z-4): "Nisab: 85 g gold = 425,000.00 EGP · 595 g silver = 35,700.00 EGP — your rates of 15 Oct 2026". Both lines shown (the metal choice belongs to UC-3). A missing metal rate → "Add a gold rate to see the nisab" + inline rate entry.
   - "Zakatable total in this list: 312,000.00 EGP" (Σ value × share, net of interest).
   - Switch on → set-aside rows show "0 — no zakat due this year"; after-set-aside figures equal before (AC-18).
8. **Other periods** — last 12 months (or all years), one row each: period · chosen measure · kept/lost icon. Chip row picks the column: **Return · After set-aside · Real after set-aside** (default the last). Tap → stepper jumps there.

**Not available:** D ≤ 0 → "Not available" + why (AC-41). Stepper stops at the first month held.

### 2.11 Why sheet (S9) — "Explain or do not show"

**Entry point:** tap any number or its ⓘ (44 pt target covers label + number).

Four blocks:
1. **What it is** — one plain sentence.
2. **Your numbers** — the formula in words with the user's values: "+4.21 % = gain 500.00 ÷ average money invested 11,866.67. Your 4,000 deposit on 16 Apr counts for 14 of 30 days."
3. **Assumptions used** — each rate (source + "as of", or "typed by you"), each inflation year (Shipped / Yours / Assumed), each zakat choice; each with **Change** (deep link to S8 or inline field).
4. **Source** (zakat, interest and purchasing-power numbers) — ruling text from the zakat file, its reference, verification tag; `[U]` → "source not yet verified". Shipped inflation: dataset and "as of" year.
Method limits live here (Modified Dietz drift; "not annualised under 1 year").

---

## 3. Every number: label and where its "why" lives

| Number | Screen | Label (EN) | Why sheet says | Source block |
|---|---|---|---|---|
| Total value | S2 | Total value · as of {date} | Sum of open items at latest rates, net of interest kept inside; lists excluded items | — |
| This-year verdict | S2 | 2026 so far: purchasing power kept / lost | Same as S7 verdict, year to date | A6 + inflation source |
| To purify (total / item / period) | S2, S4, S7 | Interest to purify | All interest recorded − given away; not return, not zakat base, giving it away is not zakat | Z-6, B1 |
| Item value (base) | S2, S4 | ≈ {x} EGP | Converted at "1 USD = 48.50 EGP · as of {date} · {source / typed}" | — |
| Return since start | S2, S4 | Return (since {start}) | Money-weighted (Modified Dietz); deposits are not profit; limit stated | — |
| Gain | S4 | Gain | value + money out − money in; interest excluded | — |
| Annualised | S4 | Per year | Shown only after 1 year held | — |
| Own-market real | S4 | Real · own market ({series}) | Item-unit return vs that country's inflation | A6 + inflation source |
| Real in base | S4 | Real · in your money ({home}) | Base return vs home inflation; includes currency moves | A6 + inflation source |
| Zakat share | S3, S4 | Zakat: on {x} % of value | Intent → default, method, notice, any override | A9 + Part B |
| Period return | S7 | Return | Modified Dietz for the period with the user's flows | — |
| Set-aside | S4, S7 | Estimated zakat set-aside (planning) | rate × share × end value × days ÷ year length, matched pair (2.5 %/354.367 or 2.577 %/365) | A1/A2, Z-2, Z-3 |
| Return after set-aside | S4, S7 | Return after set-aside | Return with the set-aside subtracted | A1 |
| Period inflation | S7 | Inflation ({series}) for this period | Yearly rates pro-rated by days; each year tagged | inflation source |
| Real after / before set-aside | S4, S7 | Real return after / before set-aside | (1+R)/(1+i)−1; never applied to the zakat base | A6 |
| Purchasing-power gap | S2, S7 | Kept / Lost {amount} | (end − set-aside) vs (start + flows + inflation on average capital) | A6 |
| Needed end value / return | S7 | Needed | Value that would exactly keep purchasing power after set-aside | A6 |
| Totals real | S7 | Real return after set-aside | Converted to base, then home inflation; **not** an average of items' own-market reals | A6 |
| Nisab hint | S7, S8 | Nisab: 85 g gold = {x} · 595 g silver = {y} | grams × your gold/silver rate on {date}; full check is in a later feature | A3, Z-4 |
| Zakatable total | S7, S8 | Zakatable total in this list | Σ value × share; the list may not be all your wealth | Z-4 |
| Rate | S6, S8 | 1 USD = {x} EGP · as of {date} | Source + its date, or typed by you; typed wins on the same date | A7 |

**VoiceOver:** each number reads label + value + unit + marker in one phrase, e.g. "Return since start, plus 15.50 percent, in Egyptian pounds, value not updated this month." Signs read as words.

---

## 4. ASCII sketches (English, LTR; Arabic mirrors — numbers stay LTR inside)

Home totals are illustrative; S7 uses AC-15.

**S2 — Home**
```
┌──────────────────────────────────────┐
│ My Investments         [Assumptions] │
│ ┌──────────────────────────────────┐ │
│ │ Total value       Show in EGP | g │ │
│ │ 1,240,500.00 EGP                  │ │
│ │ as of 16 Oct 2026 · Excludes 1  › │ │
│ │ Interest to purify: 500.00 EGP  ⓘ │ │
│ ├──────────────────────────────────┤ │
│ │ 2026 so far: kept purchasing power│ │
│ │ ▲ +407.75 EGP                  ⓘ ›│ │
│ │ Egypt inflation: shipped (2025)   │ │
│ └──────────────────────────────────┘ │
│ ● 4 values, 2 rates not updated this │
│   month                 [Update all] │
│ Sort: Value ▾                        │
│ ──────────────────────────────────── │
│ Gold bar 50 g          262,500.00 EGP│
│ Gold · 50.0 g pure          +25.00 % │
│ ● Gold rate not updated this month   │
│ ──────────────────────────────────── │
│ US stock                57,750.00 EGP│
│ Stock · NASDAQ              +15.50 % │
│                          1,050.00 USD│
│ ──────────────────────────────────── │
│ Closed (3) ▸                         │
│                             [ + Add ]│
└──────────────────────────────────────┘
```

**S4 — Item detail**
```
┌──────────────────────────────────────┐
│ ‹ US stock                     Edit  │
│ Stock · NASDAQ · Long-term           │
│ 1,050.00 USD                         │
│ ≈ 57,750.00 EGP · value from 31 Dec  │
│ ┌ Since start ─────────────────────┐ │
│ │               In USD     In EGP  │ │
│ │ Gain         +50.00   +7,750.00 ⓘ│ │
│ │ Return       +5.00 %   +15.50 % ⓘ│ │
│ │ Real          +1.94 %   −3.75 % ⓘ│ │
│ │              own mkt   your money│ │
│ │ For planning only. Zakat is on   │ │
│ │ today's actual value.            │ │
│ │                By month & year › │ │
│ └──────────────────────────────────┘ │
│ Zakat: 0 % — dividends only (IIFA).  │
│ Zakat on your dividends is counted   │
│ with your cash. · Source ›           │
│ History                              │
│ 31 Dec 2026  Value update  1,050 USD │
│ 15 Jun 2026  ↓ Income        12 USD  │
│ 01 Mar 2025  ↑ Money in    1,000 USD │
│                          [ Record ]  │
└──────────────────────────────────────┘
```

**S6 — Update all**
```
┌──────────────────────────────────────┐
│ ‹ Update all                         │
│ ┌──────────────────────────────────┐ │
│ │ [ Refresh rates online ]          │ │
│ │ Same public price list for        │ │
│ │ everyone. Nothing about you sent. │ │
│ │ ✓ Rates as of 15 Oct 2026 ·       │ │
│ │   {source} · 3 of yours updated › │ │
│ └──────────────────────────────────┘ │
│ As of: 16 Oct 2026 ▾    Show all ( ) │
│ RATES STILL OLD                      │
│ 1 KWD =  [           ] EGP   [Same]  │
│          last 160.20 · 30 Sep · you  │
│ VALUES                               │
│ Fund A    [ 14,800.00 ] EGP  [Same]  │
│          last 14,500 · 30 Sep        │
│ US stock  [ 8.75 ]/unit  Total|Unit  │
│          × 120 = 1,050.00 USD        │
│ Deposit   [           ] EGP  [Same]  │
│          last 50,000 · 30 Sep        │
│ ──────────────────────────────────── │
│ 2 of 4 filled              [ Save ]  │
└──────────────────────────────────────┘
```

**S7 — Period view (Year, AC-15)**
```
┌──────────────────────────────────────┐
│ ‹ All investments ▾                  │
│ [ Month | Year ]      Show in EGP | g│
│          ‹  2026  ›                  │
│ ┌──────────────────────────────────┐ │
│ │ Return                +15.00 %  ⓘ│ │
│ │ Est. zakat set-aside  (planning) │ │
│ │                   −592.25 EGP   ⓘ│ │
│ │ Actual zakat is due once a year  │ │
│ │ on your zakat date.              │ │
│ │ Return after set-aside +12.04 % ⓘ│ │
│ │ Inflation (Egypt)      10.00 %  ⓘ│ │
│ │ Real after set-aside   +1.85 %  ⓘ│ │
│ │ real before set-aside: +4.55 %   │ │
│ ├──────────────────────────────────┤ │
│ │ ▲ KEPT purchasing power          │ │
│ │   +407.75 EGP after set-aside   ⓘ│ │
│ │   Needed: 22,581.48 EGP (12.91 %)│ │
│ │ For planning only. Zakat is on   │ │
│ │ today's actual value.            │ │
│ └──────────────────────────────────┘ │
│ No zakat due for 2026          (  )  │
│ Decide using all your zakatable      │
│ wealth, not only this list.          │
│ Nisab: 85 g gold = 425,000.00 EGP    │
│        595 g silver = 35,700.00 EGP  │
│ Zakatable total in this list:        │
│        23,000.00 EGP                 │
│ Items                                │
│  EGX stock                  +15.00 % │
│ Other years [Return|Set-aside|Real]  │
│  2025          +9.10 %   ▲ kept      │
└──────────────────────────────────────┘
```

---

## 5. Exit states (summary)

| Flow | Success | Cancel | Error |
|---|---|---|---|
| Setup | Empty Home | Back to step 1 | — (local only) |
| Add/edit | S4 + "Saved" | Discard confirm if changed | Inline per field + top summary; write fail = nothing saved |
| Record | Back to S4, recalculated | Dismiss (confirm if changed) | Inline; value left required when out > value; given away ≤ still to purify in that case |
| Update all | Origin + "Updated n. m still old." | "Save n updates?" (fetched rates already kept) | Refresh fail = nothing changed, told so (AC-29); write fail = nothing saved, rows kept |
| Assumptions edit | Row updated; dependents recalc | Dismiss | Inline (rate ≤ 0; inflation outside −50 %…1000 %) |
| Delete (item / entry / rate / override) | Gone + Undo toast 10 s | Undo | — |

---

## 6. Edge cases

- **Empty:** no investments → S2 empty state. No rates → S8 "Rates appear here when an investment needs one." Only first money in → one history row; S7 shows months since start.
- **No network:** only Refresh and the today-only Fetch use it. Offline tap → "You're offline. Nothing changed. Your saved rates are used." No screen ever waits on the network; no request without a tap (AC-25).
- **Fetched vs typed same date:** typed wins; the fetched row shows "your rate is used".
- **Source date older than this month:** fetched rates still marked stale; the card says the source's date.
- **Large numbers:** full precision with grouping, never "1.2M" for money. At large Dynamic Type the label stacks above the number. Percent to 2 decimals.
- **Zero / closed:** closed items leave Open, stay in Closed and in every past period (AC-4).
- **Return not available:** D ≤ 0 → "Not available" + why (AC-41). Under 1 year → no "Per year" row (AC-11).
- **Value not updated:** month figures 0.00 % marked "value not updated", the later month holds the gain (AC-40); why sheet says so.
- **Base currency change:** confirm; recalc; new missing rates listed on Home, refresh offered.
- **Arabic / RTL:** layout mirrors; numbers, ISO codes and % stay LTR as one unit ("+15.50 %"); digit style follows the device locale; stepper arrows and chevrons mirror.
- **Unit picker:** search (code and name, EN and AR) · "Most used" (≤ 5, base always included, AC-42–44) · "All" sorted by **code**, localized name as subtitle. Metal units: "Gold, grams (24k) · XAU-g".
- **Accessibility:** 44 pt targets, Dynamic Type, markers are text + icon, kept/lost carries a word and a sign.

---

## 7. Shariah surface

- **Setup:** zakat year (matched pairs, lunar shown pre-selected) and long-term method with each option's source named (IIFA / NZF / precaution) + Source link.
- **Add/edit:** intent → share + A9 line + Source; dividends-only notice (AC-5); crypto permissibility notice (AC-6); "other" share always typed by the user with B5/B6/B7 help (AC-7); jewellery ruling asked on first jewellery.
- **Record:** interest received / given away with "not return, not zakat base" and "**giving it away does not count as zakat**".
- **Item detail / Home / Period:** to-purify shown apart, never netted against the set-aside.
- **Period view:** "Estimated zakat set-aside (planning). Actual zakat is due once a year on your zakat date." Never "zakat due". No-zakat switch never automatic, with "Decide using all your zakatable wealth, not only this list", nisab hint and zakatable total. Set-aside and inflation are separate lines; every real figure carries the AC-35 wording.
- **Grams view:** zakat computed in money, shown in grams; "yardstick, not a price index"; no gold-for-gold modelled.
- **`[U]` references** show "source not yet verified". Wahed's 30 % appears nowhere.
- **Never shown:** buy/sell/hold advice; any inflation-adjusted zakat base.

---

## 8. Where this departs from the story

1. **Inline rate capture** (type; Fetch only for today) in the add form, record sheet and missing-rate rows — all into the one rate history.
2. **Typo check** (> 50 % change) on typed values and rates — non-blocking.
3. **"Same" button** in Update all records the last value again on the new date.
4. **Unit picker** sorts "All" by code with localized name (story lets UX choose).
5. **Tap-to-fill hint chips** for "other" (e.g. "Use 0 %" for personal use) — the user's tap, not a default, so AC-7 holds.
6. **Nisab hint** next to the no-zakat switch (consultant Z-4 answer); story §11 keeps the full nisab check in UC-3.

---

## Questions for PM

- **PM-Q1 — Dividends-only set-aside: story vs consultant.** Story AC-5: share 0 %, set-aside 0, notice "counted with your cash". Consultant (UX answer (a)): set-aside = r_z × income received in the period, no T/Y, plus a double-count hint on cash money-in. These give different S7 numbers for Khaled. Designed to the story [F-DIV]; which one wins?
- **PM-Q2 — "Other" + personal use.** Consultant says 0 %; story AC-7 says no default. Designed as an empty field with a "Use 0 %" chip. OK?
