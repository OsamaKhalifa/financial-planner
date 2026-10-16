# UX flow — My Investments

**Owner:** ux-expert · **Status:** v0 draft · 2026-10-16 · includes owner decisions of 2026-10-16
**Input:** [story](../stories/my-investments.md) · [market research](../research/my-investments-market.md) · [zakat rules](../shariah/zakat-on-investments.md)
**Platform note:** one adaptive layout with platform-native controls (Cupertino feel on iOS first, Material 3 on Android); the architect decides the widget strategy.

---

## 0. Decisions this design is built on

**Decided by the owner (2026-10-16)** — designed in, no flip expected:

| # | Decision | Where it shows |
|---|---|---|
| D1 | **Optional online refresh** of FX and gold/silver rates. User taps a button; no background fetch; sends no user data. Manual entry still works offline; a manual rate on the same date wins. Fetched rates show source and time. Item values are always manual. | S6 leads with it; S8 has it; rate rows show "Fetched · {source} · {time}" or "Typed by you". |
| D2 | **Shipped default inflation** per country and year, with source and "as of" year. User may override any year. | Real figures visible from day one; every real figure says whether it uses a shipped, your own, or an assumed rate (2.9). |
| D3 | **Gold/silver base view: yes.** | "Show in: EGP \| Gold g" toggle on S2 and S7. Kept isolated (one toggle, one rule: no inflation step). |
| D4 | **Disputed zakat views asked at first setup:** nisab metal, jewellery, long-term share method, pensions. Rate default lunar 2.5 %, solar 2.577 % as option. | S1 step 2. |
| D5 | **Consultant:** *intent* (trading / long-term / personal use / rental) drives the default zakat share; money-out kind **"Interest (to purify)"** shown separately and excluded from return; the monthly figure is labelled **"Estimated set-aside"**, never "zakat due". | S3, S5, S4, S7, §3. |

**Still pending** — places tagged would change:

| Tag | Working assumption | If it flips |
|---|---|---|
| **[F-REAL]** | Totals' real return = convert to base, deflate by home inflation (story Q5). | Only the "why" text of the total real figure changes. |
| **[F-3RD]** | No conversion through a third unit (story Q6). | Most "rate missing" states disappear when a chain exists; the why sheet shows the chain used. |
| **[F-HAWL]** | Year = Gregorian year (story Q7). | Period switch gets a third option "Zakat year". |
| **[F-GOLDBASE]** | (Decided yes; tag kept so the toggle stays easy to drop.) | Remove the toggle on S2/S7 and the "XAU-g → each currency" rate rows in S6. Nothing else depends on it. |

---

## 1. Screen list (and what was merged)

| # | Screen | Kind | Merged in it |
|---|---|---|---|
| S1 | **Setup** (first run only) | 2-step full screen | Base currency + home inflation + zakat choices. |
| S2 | **Home** (investments list + totals) | Main | Totals, this-year verdict, stale summary, list, sort. Home *is* the list; no separate dashboard. |
| S3 | **Investment form** (add / edit) | Full-screen sheet | Add and edit are one form. Fields appear per asset type. |
| S4 | **Item detail** | Main | Returns + history of money in / out / value updates in one scroll. No separate history screen. |
| S5 | **Record sheet** | Bottom sheet | Money in, money out, value update — one sheet, 3-way switch. Same sheet edits a history entry. |
| S6 | **Update all** | Main | Rate refresh + every stale rate + every stale item value. One list, one Save. |
| S7 | **Period view** | Main | Month / Year, before/after zakat, before/after inflation, purchasing-power gap. Same screen for the portfolio and for one item (scope picker). |
| S8 | **Assumptions** | Main | Rates, inflation series, base currency, home inflation, zakat choices, years with no zakat due. Every input the numbers depend on. Replaces separate "Settings" and "Rates" screens. |
| S9 | **Why sheet** | Bottom sheet (one component) | Every explanation in the app. |
| — | Unit picker | Bottom sheet (shared) | Used by S1, S3, S5, S8. |

**Why merge this way:** the user has three jobs — *record*, *keep current*, *judge*. Record = S3 + S5. Keep current = S6 (+ S8 for corrections). Judge = S2 + S4 + S7. Rates, inflation and zakat choices are all "assumptions behind the numbers", so they live together in S8, and every why sheet deep-links to the exact S8 row.

**Navigation:** S2 is the root. No tab bar in v1. Home top bar: title, **Assumptions** icon (S8). Everything else is reached by tapping content.

---

## 2. Flows

### 2.1 First run — Setup (S1)

**Entry point:** first launch (no base unit stored).

1. **Step 1 — "What currency do you count your wealth in?"**
   - Sees: unit picker inline (device-region currency first, then §6.3 order). Below: "Home inflation: Egypt (from EGP) · Change". Line: "Totals, monthly and yearly figures, and zakat amounts use this currency. You can change it later."
   - Does: picks base; optionally changes home inflation country (e.g. reports in USD, lives in Egypt).
   - App: stores base and home series. Shipped inflation for that country is used at once (D2); no number typed here.
2. **Step 2 — "How do you calculate zakat?"** (D4)
   - Sees: 5 rows. Each: question, options, one-line why, **Source** link (S9 with views and references). **Nothing pre-selected** where the zakat file says "ask"; the rate row is pre-set to Lunar.
     | Choice | Options | One-line why | Ref (zakat file) |
     |---|---|---|---|
     | Zakat year | **Lunar 2.5 %** (default) · Solar 2.577 % | "Some scholars adjust the rate for the longer solar year; others do not." | A1, A2 |
     | Nisab standard | Gold 85 g · Silver 595 g | "Decides the minimum wealth that makes zakat due." | A3 |
     | Long-held shares and funds | Dividends only · 25 % of value · Full value · I'll decide per item | "When company data is unknown, scholars use different methods." | B3, B4 |
     | Personal gold/silver jewellery | Zakatable · Not zakatable | "The schools differ on jewellery that is worn." | B2 |
     | Pensions you can't withdraw yet | No zakat until withdrawn · On the amount you could withdraw · Full balance | "Scholars differ on money you can't reach yet." | B7 |
   - Each row has **Not now**. An unanswered choice is asked in context the first time it is needed (e.g. adding a long-term stock), never silently defaulted.
   - Does: answers or skips, taps **Done** (primary).
3. **Empty Home.** "No investments yet." + primary **Add investment** + chips "Monthly fund", "Gold", "Stock" (open S3 with type preset). Line: "Your data stays on this phone."

**Exit:** Done → S2 empty. Back on step 2 → step 1. App killed mid-setup → restarts at step 1 with base kept if chosen.

### 2.2 Home — investments list (S2)

**Entry point:** launch, back from any screen.

1. **Totals card**
   - "Total value" — big, base unit, "as of {latest date used}".
   - If items excluded: "Excludes 1 item — USD→EGP rate missing" → S6 scrolled to that rate.
   - **Show in: EGP | Gold g** toggle (D3) [F-GOLDBASE].
2. **This-year verdict row** — "2026 so far: purchasing power **kept +425 EGP**" / "**lost −550 EGP**" (after estimated set-aside, after home inflation). A small source tag under it when the inflation is shipped: "Egypt inflation: shipped estimate". Tap → S7, Year.
3. **Stale banner** (only if anything is stale) — "4 values and 2 rates not updated this month · **Update all**" → S6.
4. **List** — "Sort: Value ▾" (Value in base · Return since start · Name · Oldest update first). Default Value, highest first. Persists. Sections **Open**, then **Closed (3)** collapsed.
5. **Primary action:** floating **+ Add** (S3).

**List row** (end-aligned numbers, mirrors in RTL):
- Start: name; under it type · market ("Stock · NASDAQ") or grams ("17.5 g pure").
- End: value in base (large); under it return since start in base, signed.
- If item unit ≠ base: third line "1,050 USD".
- **Stale marker:** dot + text: "Not updated this month" (value) or "Gold rate not updated this month" (metal items move with the rate, not a value update). Text, never colour only.
- **Missing rate:** base value "—", "USD→EGP rate missing · Add" → inline rate entry (2.8).

**"Stale now" rule (UX decision, PM-Q3):** an item value is stale if it has no value update and no money in/out in the current calendar month; a rate is stale if neither fetched nor typed this calendar month. Mirrors the story's month marker, so Home and Month view never disagree.

### 2.3 Add / edit investment (S3)

**Entry point:** + Add on S2, chip on empty state, Edit on S4.

One scrolling form. Asset type is first; it decides which fields show. Hidden fields are not asked or validated.

| Field | Stock | Fund/ETF · Sukuk | Gold · Silver | Cash deposit | Pension | Crypto · Other |
|---|---|---|---|---|---|---|
| Name | yes | yes | yes | yes | yes | yes |
| Market | required | optional | — | — | — | — |
| Item unit | default from market | default base | fixed XAU-g / XAG-g (hidden) | default base | default base | default base |
| Start date | yes | yes | yes | yes | yes | yes |
| Paid (first money in) — amount + unit | yes | yes | yes (default base) | yes | yes | yes |
| Current value + date | optional (defaults to paid) | optional | — (grams × rate) | optional | optional | optional |
| Quantity | optional | optional | **Grams**, required | — | — | optional |
| Purity | — | — | **Karat chips 24/22/21/18**; silver 999/925 | — | — | — |
| **Intent** (D5) | Trading · Long-term | Trading · Long-term | Long-term (savings) · Personal use (jewellery) | — | — | Trading · Long-term · Personal use · Rental |
| Zakat share | from intent (below) | from intent | from intent | fixed 100 % (shown) | from setup choice | from intent |
| Inflation series | under "More", default shown | same | same (home) | same | same | same |
| Notes | under "More" | same | same | same | same | same |

Pension appears only if PM-Q6 confirms it as a type.

1. Picks type → right fields with defaults.
2. **Intent → zakat share.** Intent is a required segmented choice (where the type has more than one). It fills the zakat share and shows the zakat file's A9 status line under it:
   - Trading → "Zakat: on 100 % of market value. You hold this to sell. — IIFA Res 28 (3/4) §3 · Source".
   - Long-term → uses the setup method (or asks it here if "Not now" / "per item").
   - Personal use (jewellery) → setup jewellery choice. Rental → "Zakat: not on the property; on rent you still hold, as cash. · Source".
   - Override row: "Company pays zakat for me (0 %)" switch for stocks; "Custom %" link for all except cash. The why sheet then says "You changed this from the default {x} %".
   - `[U]` references show "source not yet verified".
3. **Inline rate capture:** if "Paid" unit ≠ item unit and no rate exists on the start date, a row appears under "Paid": "1 USD = ____ EGP on 1 Mar 2026" with a small **Fetch** button (D1; fetches that date's rate if the source has history — PM-Q4). Result line: "= 1,000.00 USD paid". Gold: "1 g 24k gold = ____ EGP" → "= 10.40 g pure gold paid" (AC-21). The rate goes into the one rate history. The user never leaves the form.
4. Taps **Save** (primary).

**Exits:**
- Success → S4 of the new item, toast "Saved".
- Cancel with changes → "Discard this investment?" (Discard / Keep editing).
- Validation → stays; each missing field named inline + top summary "3 fields need attention" (AC-1). Paid = 0 → "Must be more than 0". Date pickers offer no future dates (AC-2).
- Storage write fails → "Could not save. Nothing was changed. Try again."

**Edit:** same form, filled. Changing type, unit, purity or intent on an item with history → "This recalculates every past month for this item." (confirm). Delete at the bottom: "Delete investment and its whole history?" + **Undo** toast 10 s.

### 2.4 Item detail (S4)

**Entry point:** row on S2; after save on S3; item row on S7.

1. **Header:** name, type · market, Edit. Value now in item unit (large) + "≈ 57,750 EGP" if different. "Value from 31 Dec 2026" + stale marker if stale.
2. **Returns card — "Since start"** (two columns only when item unit ≠ base, story §6.2):
   | Row | In USD (item) | In EGP (base) |
   |---|---|---|
   | Gain | +50.00 USD | +7,750.00 EGP |
   | Return | +5.00 % | +15.50 % |
   | Per year | only if held ≥ 1 year | same |
   | After est. set-aside | — | +x.xx % (PM-Q5) |
   | Real | **Own market** (US inflation): +1.94 % | **In your money** (Egypt inflation): −3.75 % |
   - Under real: "Purchasing power (for planning only — zakat is always on today's actual value)." (A6). Inflation source tag if shipped / assumed (2.9).
   - **Interest to purify** (D5), only if any: separate row under the card — "Interest received: 120.00 EGP · to purify · not counted as return ⓘ".
   - Link **By month and year** → S7 scoped to this item.
3. **Zakat line** — intent + A9 status line + Source.
4. **History** — newest first: money in, money out (sale / income / interest to purify), value updates (gold: gram changes). Row: date, kind label + icon, signed amount + unit. Tap → S5 edit. Swipe → delete + Undo.
5. **Primary action:** **Record** (S5). Closed item: banner "Closed on 30 Apr 2026", no Record; "Reopen" in overflow.

### 2.5 Record money in / money out / value update (S5)

**Entry point:** Record on S4; tap a history row (edit).

1. Switch **Money in · Money out · Value update** (default Value update). Date (default today). Amount + unit (default item unit; §6.3 order).
2. Per kind:
   - **Money in:** amount, unit, optional "value after" (else value rises by the amount, story §5.1). Gold: amount paid + grams bought (pure grams live).
   - **Money out:** amount, unit, kind **Sale · Income received · Interest (to purify)**. Interest line under the choice: "Not counted as return. Shown separately so you can give it away. · Source". Optional "Value left". If amount > current value → "Value left" required: "This is more than the item's value. Enter what is left (0 or more)." Value left = 0 → "This closes the investment. It stays in past months."
   - **Value update:** value in item unit, reference "Last: 1,050.00 USD on 31 Dec 2026". Gold: new grams (only when grams changed outside a buy/sell).
3. Inline rate capture if needed (2.3 step 3).
4. **Typo check:** new value > 50 % away from the last → non-blocking line "This is 10× the last value. Check the number."
5. **Save** → S4, recalculated.

**Errors:** date before start → "Can't be before the start date (10 Jan 2026)". Same-date value update → "Replace the value of 31 Dec 2026?"

### 2.6 Update all (S6) — the make-or-break flow

**Entry point:** stale banner on S2; "rate missing" links on S2/S7; "Update all" on S8.

**Goal:** monthly update of 10 items and 3 rates in under 60 seconds, one hand, never leaving the screen.

1. **Step A — Refresh rates (D1).** The top of the screen is one card: **Refresh rates online** (the primary action until it has run). Under it: "Downloads public exchange and gold/silver prices. Nothing about you is sent." and "Last refreshed: 30 Sep 2026, 21:10".
   - Tapping it fetches only the pairs the open items need (item unit → base; XAU-g / XAG-g → base; XAU-g → each held currency if the gold view is on [F-GOLDBASE]).
   - While fetching: the card shows progress; the rest of the list stays usable (values can be typed meanwhile).
   - After: card shows "Updated 3 rates · {source} · 16 Oct 2026, 09:42". A pair the source does not cover stays in the list as a manual row.
   - Fails (offline, source down): "Couldn't refresh. Your saved rates are still used. Try again or type them below." Never blocks.
   - Skippable: the user can ignore the card and type rates.
2. **"As of" date** — one for the whole screen (default today; can be set to e.g. last day of last month). Every typed value gets this date. Fetched rates keep the fetch time.
3. **Step B — what is still stale**, one list, this order:
   1. **Rates still stale** — only pairs not refreshed (not covered, or user skipped refresh). Row: "1 USD = ____ EGP", hint "last 52.10 · 30 Sep · typed by you". Fetched rows collapse into one line "3 rates refreshed ›" (expand to see or override; a typed rate on the same date replaces the fetched one, D1).
   2. **Item values** — every open non-metal item that is stale. Row: name, unit, field, hint "last 1,050.00 · 30 Sep". Metal items are not listed; the gold rate line says "moves 3 gold items".
   (No inflation rows: shipped defaults cover them, D2. Overrides live in S8.)
4. **Speed details:**
   - After refresh, focus jumps to the first empty value field with the number keyboard open. Keyboard "Next" walks every row. No row needs a tap to open.
   - **Same** button per row: records the last value again on the "as of" date (deposit that did not move). Clears the stale mark.
   - Blank rows are skipped, not errors. Partial saves are normal.
   - Bottom bar counter: "7 of 10 filled".
   - Typo check per row (> 50 % change) inline, never blocking.
   - "Show all" switch: off = stale only (default); on = every open item and every rate in use.
5. **Save** (single primary in the bottom bar after refresh has run or been skipped) → all typed rows in one write (all or nothing). Fetched rates are already saved when the fetch succeeds, so a later Discard does not lose them. Back to origin with toast "Updated 7 values. 3 still old."

**Exits:** back with typed rows → "Save 7 updates?" (Save / Discard). Write fail → "Could not save. Nothing was changed." rows kept. Nothing stale → "Everything is up to date for October 2026" + refresh card + "Show all".

### 2.7 Assumptions (S8)

**Entry point:** Home top-bar icon; every why sheet's "Change" link (lands on the row).

1. **Base and home** — base unit (change → "All totals and months recalculate"), home inflation series.
2. **Rates** — header button **Refresh rates online** (same action as S6). Pairs in use, then "Other pairs". Row: "1 USD = 55.00 EGP · 16 Oct 2026" + origin tag **Fetched · {source}** or **Typed by you**, stale/missing marker. Tap → pair history (dated list; add, edit, delete + Undo; fetched rows can be overridden by typing a rate on the same date, not edited in place). Add-rate sheet: pair picker (§6.3 order), **swap direction** button, date, rate, inverse shown live ("1 EGP = 0.0182 USD") so a reversed entry is visible (AC-15).
3. **Inflation** — series in use (home + each item's series). Row: "Egypt · 2026 25.0 % · shipped ({source}, as of 2026)". Tap → year list; each year shows **Shipped** or **Yours**; tap a year → type an override; overridden years show "Reset to shipped". Header: "Shipped rates come from {source}. Replace any year with the official CPI figure if you have a newer one."
4. **Zakat** — the 5 setup choices, each with Source. **Years with no zakat due** (AC-26), with "below nisab this year".
5. **Update all** button → S6.

### 2.8 Missing-rate states (everywhere)

A missing rate never becomes 1:1 and never blocks typing (story §6.1).
- **S2 row:** base value "—", "USD→EGP rate missing · Add". Totals card "Excludes 1 item".
- **S4:** base column "Needs USD→EGP rate" + inline field.
- **S7:** **Excluded** group: "US stock — USD→EGP rate missing for April 2026 · Add" (AC-13). Verdict says "Based on 4 of 5 items".
- **Inline rate entry** (shared): "1 USD = ____ EGP on {date needed}" + **Fetch** + Save. The date shown is the date the figure needs (e.g. 30 Apr 2026).
- **Stale rate:** figure shown, marked "Rate from 15 Jan — not updated in this period" (AC-14).

### 2.9 Inflation source states (D2)

Every real figure carries one of three tags, short, tappable → S9 → S8 row:
- **Shipped** — "Egypt inflation: shipped estimate ({source}, as of 2026)". Quiet style; normal case.
- **Yours** — "Egypt inflation: your rate". No tag on the figure itself; shown only in the why sheet (it is the user's own fact).
- **Assumed** — no shipped and no user rate for the year → latest earlier year used: "Inflation assumed from 2025" (AC-18). Stronger marker.
- **None at all** (a country with no shipped data and nothing typed) → real figures replaced by one row "Add {country} inflation for 2026 to see purchasing power" + inline "____ %". Before-inflation figures stay.

### 2.10 Period view (S7)

**Entry point:** this-year row on S2 (Year, current year); "By month and year" on S4 (scoped to item).

1. **Header:** scope "All investments ▾" (or one item) · **Month | Year** · **Show in: EGP | Gold g** (D3) [F-GOLDBASE] · stepper "‹ April 2026 ›" (mirrors in RTL).
2. **The ladder** — all steps visible at once, read top to bottom (no hidden before/after toggles):
   | Line | Example (AC-9) |
   |---|---|
   | Return | +2.37 % · +400.00 EGP |
   | Estimated set-aside (zakat) | −29.79 EGP |
   | Return after set-aside | +2.19 % |
   | Inflation (Egypt) · source tag | 0.79 % for this period |
   | **Real return after set-aside** | **+1.40 %** |
   Smaller line under it: "Real return before set-aside: +x.xx %".
   - Month view label is always "Estimated set-aside" (D5) with the line "Zakat is due once a year on your zakat date; this is a share to put aside." Year view uses the same label (story has no zakat-date computation).
   - **Interest to purify** (only if any in this period): separate line under the ladder, "Interest received 120.00 EGP — to purify, not in return".
3. **Verdict block** — the outcome:
   - "**Kept** purchasing power, after set-aside · **+425.00 EGP**" / "**Lost** · **−550.00 EGP**". Word + sign + icon.
   - "Needed: end value 22,564.10 EGP (return 12.82 %)".
   - "Purchasing power (for planning only — zakat is always on today's actual value)."
   - Gold view: verdict "Lost 0.44 g gold after set-aside"; inflation line replaced by "No inflation step: in gold, the gram is the measure. Gold is a yardstick, not a price index." (story §7).
4. **Markers line** (if any): "2 items not updated this period · rate from 15 Jan · inflation assumed from 2025". Each tappable → its fix.
5. **Items in this period** (scope = all): row per item with its period figure and marker → S4. Then **Excluded** group (2.8).
6. **Other periods** — last 12 months (or all years), one row each: period · chosen measure · kept/lost icon. Chip row picks the column: **Return · After set-aside · Real after set-aside** (default the last). Tap → stepper jumps there.
7. **No-zakat year:** Year view overflow "No zakat due for 2026"; when on, set-aside line shows "0 — no zakat due this year (below nisab)" (AC-26).

**Not available:** D ≤ 0 → "Not available" + why (AC-25). Stepper stops at the first month held.

### 2.11 Why sheet (S9) — "Explain or do not show"

**Entry point:** tap any number or its ⓘ (44 pt target covers label + number).

Four blocks:
1. **What it is** — one plain sentence.
2. **Your numbers** — the formula in words with the user's values: "+4.21 % = gain 500.00 ÷ average money invested 11,866.67. Your 4,000 deposit on 16 Apr counts for 14 of 30 days."
3. **Assumptions used** — each rate (with Fetched/Typed tag and date), each inflation year (Shipped/Yours/Assumed), each zakat choice; each with **Change** (deep link to S8 or inline field).
4. **Source** (zakat and purchasing-power numbers) — ruling text from the zakat file, reference, verification tag; `[U]` → "source not yet verified". Inflation source and "as of" year for shipped rates.
Method limits live here (Modified Dietz drift, story §9.1; "not annualised under 1 year").

---

## 3. Every number: label and where its "why" lives

| Number | Screen | Label (EN) | Why sheet says | Source block |
|---|---|---|---|---|
| Total value | S2 | Total value · as of {date} | Sum of open items at latest rates; lists excluded items | — |
| This-year verdict | S2 | 2026 so far: purchasing power kept/lost | Same as S7 verdict, year to date | A6 + inflation source |
| Item value (base) | S2, S4 | ≈ {x} EGP | Converted at "1 USD = 55.00 EGP · {date} · fetched/typed" | — |
| Return since start | S2, S4 | Return (since {start}) | Money-weighted (Modified Dietz); deposits are not profit; limit stated | — |
| Gain | S4 | Gain | value + money out − money in (interest to purify excluded) | — |
| Annualised | S4 | Per year | Shown only after 1 year held | — |
| Own-market real | S4 | Real · own market ({series}) | Item-unit return vs that country's inflation | A6 + inflation source |
| Real in base | S4 | Real · in your money ({home}) | Base return vs home inflation; includes currency moves | A6 + inflation source |
| Interest to purify | S4, S7 | Interest received · to purify | Not counted as return; why it is separated | Z-6 / consultant |
| Zakat share | S3, S4 | Zakat: on {x} % of value | Intent → default, method, any override | A9 + B-section |
| Period return | S7 | Return | Modified Dietz for the period with the user's flows | — |
| Set-aside | S7 | Estimated set-aside | rate × share × end value × days/year; "a share to put aside, not zakat due" | A1/A2, Z-3 |
| Return after set-aside | S7 | Return after set-aside | Return minus the set-aside | A1 |
| Period inflation | S7 | Inflation ({series}) for this period | Yearly rates pro-rated by days; each year tagged Shipped/Yours/Assumed | inflation source |
| Real after/before set-aside | S7 | Real return after / before set-aside | (1+R)/(1+i)−1; never applied to the zakat base | A6 |
| Purchasing-power gap | S7 | Kept / Lost {amount} | (end − set-aside) vs (start + flows + inflation on average capital) | A6 |
| Needed end value / return | S7 | Needed | Value that would exactly keep purchasing power after set-aside | A6 |
| Totals real | S7 | Real return after set-aside | Converted to base, deflated by home inflation; **not** an average of items' own-market reals [F-REAL] | A6 |
| Rate | S6, S8 | 1 USD = {x} EGP · Fetched/Typed | Source + time, or "typed by you"; manual on same date wins | A7 |
| Rate inverse | S8 | 1 EGP = {x} USD | Same rate read the other way | — |

**VoiceOver:** each number reads as label + value + unit + marker in one phrase, e.g. "Return since start, plus 15.50 percent, in Egyptian pounds, value not updated this month." Signs read as words.

---

## 4. ASCII sketches (English, LTR; Arabic mirrors — numbers stay LTR inside)

**S2 — Home**
```
┌──────────────────────────────────────┐
│ My Investments         [Assumptions] │
│ ┌──────────────────────────────────┐ │
│ │ Total value       Show in EGP | g │ │
│ │ 1,240,500.00 EGP                  │ │
│ │ as of 16 Oct 2026 · Excludes 1  › │ │
│ ├──────────────────────────────────┤ │
│ │ 2026 so far: kept purchasing power│ │
│ │ ▲ +12,425.00 EGP               ⓘ ›│ │
│ │ Egypt inflation: shipped estimate │ │
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
│ Fund A                  14,500.00 EGP│
│ Fund/ETF                     +4.21 % │
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
│ │ actual value.                    │ │
│ │                By month & year › │ │
│ └──────────────────────────────────┘ │
│ Zakat: on 25 % of value (long-term,  │
│ NZF proxy) · Source ›                │
│ History                              │
│ 31 Dec 2026  Value update  1,050 USD │
│ 15 Jun 2026  ↓ Income        12 USD  │
│ 31 Dec 2025  Value update  1,000 USD │
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
│ │ Public prices only. Nothing about │ │
│ │ you is sent.                      │ │
│ │ ✓ Updated 3 rates · {source}      │ │
│ │   16 Oct 2026, 09:42          ›   │ │
│ └──────────────────────────────────┘ │
│ As of: 16 Oct 2026 ▾    Show all ( ) │
│ RATES STILL OLD                      │
│ 1 KWD =  [           ] EGP   [Same]  │
│          last 160.20 · 30 Sep · you  │
│ VALUES                               │
│ Fund A    [ 14,800.00 ] EGP  [Same]  │
│          last 14,500 · 30 Sep        │
│ US stock  [ 10,500    ] USD  [Same]  │
│          ! 10× the last value — check│
│ Deposit   [           ] EGP  [Same]  │
│          last 50,000 · 30 Sep        │
│ ──────────────────────────────────── │
│ 2 of 4 filled              [ Save ]  │
└──────────────────────────────────────┘
```

**S7 — Period view**
```
┌──────────────────────────────────────┐
│ ‹ All investments ▾                  │
│ [ Month | Year ]      Show in EGP | g│
│        ‹  April 2026  ›              │
│ ┌──────────────────────────────────┐ │
│ │ Return                 +2.37 %  ⓘ│ │
│ │ Estimated set-aside −29.79 EGP  ⓘ│ │
│ │ Return after set-aside +2.19 %  ⓘ│ │
│ │ Inflation (Egypt)       0.79 %  ⓘ│ │
│ │   shipped estimate               │ │
│ │ Real after set-aside   +1.40 %  ⓘ│ │
│ │ real before set-aside: +1.57 %   │ │
│ ├──────────────────────────────────┤ │
│ │ ▲ KEPT purchasing power          │ │
│ │   +236.00 EGP after set-aside   ⓘ│ │
│ │   Needed: 19,164.00 EGP (+0.82 %)│ │
│ │ For planning only. Zakat is on   │ │
│ │ actual value.                    │ │
│ └──────────────────────────────────┘ │
│ ● 1 item not updated this period ›   │
│ Items                                │
│  Fund A                      +4.21 % │
│  Fund B                      −2.00 % │
│ Excluded                             │
│  US stock — USD→EGP missing   [Add]  │
│ Other months [Return|Set-aside|Real] │
│  Mar 2026      +0.90 %   ▲ kept      │
│  Feb 2026      −0.40 %   ▼ lost      │
└──────────────────────────────────────┘
```
(Numbers below the ladder in S7 are illustrative, not test values.)

---

## 5. Exit states (summary)

| Flow | Success | Cancel | Error |
|---|---|---|---|
| Setup | Empty Home | Back to step 1 | — (local only) |
| Add/edit | S4 + "Saved" | Discard confirm if changed | Inline per field + top summary; write fail = nothing saved |
| Record | Back to S4, recalculated | Dismiss (confirm if changed) | Inline; value left required when out > value |
| Update all | Origin + "Updated n. m still old." | "Save n updates?" (fetched rates already kept) | Refresh fail = saved rates used, type instead; write fail = nothing saved, rows kept |
| Assumptions edit | Row updated; dependents recalc | Dismiss | Inline (rate ≤ 0; inflation outside −50 %…1000 %) |
| Delete (item / entry / rate / override) | Gone + Undo toast 10 s | Undo | — |

---

## 6. Edge cases

- **Empty:** no investments → S2 empty state. No rates → S8 rate section "Rates appear here when an investment needs one." Only first money in → S4 history has one row; S7 shows months since start.
- **No network:** only the rate refresh and the inline **Fetch** use the network. Offline: buttons stay visible; tap → "You're offline. Your saved rates are used. Type a rate if you have a newer one." No other screen ever waits on the network.
- **Fetched vs typed same date:** typed wins (D1); the fetched row shows "replaced by your rate".
- **Large numbers:** full precision with grouping, never "1.2M" for money. At large Dynamic Type the label stacks above the number. Percent to 2 decimals.
- **Zero / closed:** closed items leave Open, stay in Closed and in every past period. All closed → "0.00 EGP"; past periods still shown.
- **Return not available:** D ≤ 0 → "Not available" + why (AC-25). Under 1 year → no "Per year" row (AC-6).
- **Base currency change:** confirm; recalc; new missing rates → Home banner lists them, refresh offered.
- **Arabic / RTL:** layout mirrors; numbers, ISO codes and % stay LTR as one unit ("+15.50 %"); digit style follows the device locale; stepper arrows and chevrons mirror.
- **Unit picker:** search (code and name, EN and AR) · "Most used" (≤ 5, story §6.3) · "All" sorted by **code**, localized name as subtitle. Metal units: "Gold, grams (24k) · XAU-g".
- **Accessibility:** 44 pt targets, Dynamic Type, markers are text + icon, kept/lost carries a word and a sign.

---

## 7. Shariah surface

- **Setup step 2:** each disputed choice with one-line why + Source (A1–A3, B2–B4, B7). Nothing pre-selected where the zakat file says "ask".
- **Add/edit:** intent → zakat share + A9 status line + Source, always visible; overrides named in the why.
- **Record:** "Interest (to purify)" kind with its line and Source.
- **Item detail:** zakat line + Source; interest to purify shown apart from return.
- **Period view:** label "Estimated set-aside", never "zakat due" (D5), with "Zakat is due once a year on your zakat date". Every real figure carries the A6 wording. Set-aside and inflation are separate lines, never folded.
- **Assumptions:** all zakat choices and no-zakat years, each with Source.
- **Gold view:** "yardstick, not a price index"; zakat math unchanged (A8).
- **`[U]` references** show "source not yet verified".
- **Never shown:** buy/sell/hold advice; any inflation-adjusted zakat base.

---

## 8. Where this departs from the story's assumptions

1. **Intent is a visible required field** (D5) and fills the zakat share; "Company pays zakat" and "Custom %" are overrides on top. Intent and override must be stored so the why sheet can name them.
2. **Inline rate capture** (type or Fetch) in the add form, record sheet and missing-rate rows; all go into the one rate history (story §6.1 channel, no new path).
3. **Typo check** (> 50 % change) on typed values and rates — non-blocking.
4. **"Same" button** in Update all records the last value again on the new date.
5. **"Stale now"** = not updated in the current calendar month (story defines staleness per period only).
6. **Unit picker** sorts "All" by code with localized name (story lets UX choose).
7. **"Estimated set-aside"** replaces "Zakat estimate / after zakat" in every label (D5); the story's formulas are unchanged.

---

## Questions for PM

- **PM-Q1 — "Dividends only" method.** It is 2.5 % of dividends held, not a % of value; story §9.4 has no formula for it. Is it "0 % of value + set-aside on income money-out in the period"? Until then the setup option can be shown but S7 cannot compute it.
- **PM-Q2 — What does the nisab choice drive in v1?** Story §11 keeps nisab out of scope (only "zakat due this year: yes/no"). Asked at setup, it changes nothing on screen. Proposal: show "Your zakatable total is below / above nisab ({grams} = {x} EGP)" in the Year view, using the gold/silver rate already kept. Yes / no?
- **PM-Q3 — Stale threshold.** I used "not updated this calendar month". Yasmin may update quarterly and see a stale banner two months of three. Keep monthly, or add a user setting (scope — your call)?
- **PM-Q4 — Refresh scope.** Does the online source give **historical** rates (for the inline **Fetch** on a past start date or a past month end), or only today's? If only today, the inline Fetch is shown only when the date needed is today.
- **PM-Q5 — Item set-aside and real since start.** §9.2 defines no since-start set-aside or real figure; item detail needs them. Use the §9.1/§9.4/§9.5 period formulas with S = start date?
- **PM-Q6 — Asset type list.** Pensions are now a setup question, and "rental" is an intent. Is Pension a v1 type, and does rental property stay under "Other" with intent Rental?
- **PM-Q7 — Lunar rate over Gregorian periods.** Setup default is lunar 2.5 %. Story §9.4 pro-rates with Y = 365. Which Y goes with lunar (354?) and which with solar 2.577 % (365)?
- **PM-Q8 — Price × quantity.** Khaled knows the share price, not the total. May the value field accept "price per unit" when quantity is set (input helper, stores the total)? It cuts Update-all typing for stocks.
