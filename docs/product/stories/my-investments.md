# Story — My Investments

**Status:** v0 draft · 2026-10-16 · PM hat · not ready until open questions in §10 are closed
**Owner:** @OsamaKhalifa
**Research:** [my-investments-market.md](../research/my-investments-market.md)
**Shariah input:** [zakat-on-investments.md](../shariah/zakat-on-investments.md) (being written by the Islamic consultant — every zakat rule below is a placeholder until that file exists)
**Relation to BRD:** this story is the concrete form of **UC-1 (Record my holdings)** plus the ROI part of **UC-2**. See open question Q1.

---

## 1. Who

- **Yasmin** (Salaried Saver) — adds money to a fund every month, owns some gold. Lives and spends in one currency.
- **Khaled** (DIY Investor) — holds stocks on more than one market (e.g. EGX and NASDAQ), in more than one currency, enters positions by hand.

## 2. What

Keep a hand-entered list of my investments, in any currency or in gold/silver grams, and see — per item, per month, per year — how much each one and the whole list really grew: before zakat, after zakat, and after inflation, in my reporting currency.

## 3. Why (the financial outcome)

**Pain today:**
- General trackers (Sharesight, Kubera, Getquin) measure return but ignore zakat. Islamic apps (Zoya, Musaffa, Wahed) compute zakat but measure no return. Nobody we found shows **return after zakat and after inflation** together (research takeaway 1).
- A user whose currency loses 20–30 % a year can see a "profit" that is really a loss of purchasing power. A user who adds money monthly sees deposits counted as profit in naive trackers.

**Outcome:** the user knows, in money and in percent, whether their invested wealth **kept its purchasing power after paying zakat** for each month and year — a yes/no with a gap amount they can act on (save more, change mix — their decision; we give no advice).

---

## 4. Terms used in this story

| Term | Meaning |
|---|---|
| **Unit** | What an amount is measured in: a currency (ISO 4217 code, e.g. EGP, USD) or a metal unit: **XAU-g** = one gram of pure (24k) gold, **XAG-g** = one gram of pure (999) silver. |
| **Item unit** | The unit an investment's value is kept in. |
| **Base unit** | The one unit the user picks for totals, monthly/yearly views and zakat amounts. Normally a currency; see §7 for gold/silver. |
| **Rate** | "1 [unit A] = r [unit B] on date d", entered by the user. Covers both FX rates and gold/silver prices. |
| **Money in** | Money the user put into an item: the first purchase and any later addition. Includes fees paid. |
| **Money out** | Money the user took out of an item: a partial or full sale, or income received in hand (dividend, rent, profit share). |
| **Value update** | The user records what an item is worth on a date. |
| **Inflation series** | Annual inflation rates of one economy (a country or the euro area), by calendar year, entered by the user. |
| **Home inflation** | The inflation series used to judge the whole portfolio's purchasing power. Default: the series of the base currency. |

---

## 5. The investment (fields)

`*` = required. No field exists without a user need.

| Field | Req. | User need |
|---|---|---|
| **Name** | * | Tell items apart ("Al Rajhi shares", "Gold bar 50 g"). |
| **Asset type** — stock · fund/ETF · sukuk · gold · silver · cash deposit · crypto · other | * | Breakdown by asset class (UC-2); drives the default zakat share (from the consultant) and whether a market or grams are asked. List = BRD UC-1 plus sukuk (zakat treatment differs per Wahed's proxies, research takeaway 7). Real estate goes under "other" in v1 (Q8). Crypto is entered by hand only and its zakat share waits on the consultant (BRD §5). |
| **Market** (exchange) — e.g. Tadawul, EGX, NASDAQ, NYSE, LSE, DFM, ADX, Boursa Kuwait, QSE, Bursa Malaysia, BIST, PSX, or "other market + country" | * for stock; optional for fund/ETF and sukuk; absent for others | Identifies where the security trades (same ticker exists on several markets; UC-4 screening needs it). Gives the item's **country**, which picks its default inflation series (§8). |
| **Item unit** | * | What the value is kept in. Default: the market's trading currency for a stock; the base unit otherwise; XAU-g / XAG-g for gold / silver (§7). |
| **Start date** | * | First money in. Needed for annualised return and for placing the money into the right month/year. Not in the future. |
| **First money in** — amount + unit | * | What the user paid, fees included. The denominator of every return. Unit defaults to the item unit; may differ (e.g. paid EGP for a USD stock, or EGP for gold). Must be > 0. |
| **Current value** (first value update) — amount + date | * | What it is worth now. If not given, equals first money in converted to the item unit on the start date. For gold/silver this is not typed: it is the pure grams (below). |
| **Quantity** — number + "shares/units/grams" | * for gold/silver; optional otherwise | Gold/silver: the grams are what the user knows and what drives value and nisab. Others: lets the user check the entry against their broker statement; no calculation uses it in v1. |
| **Purity** — karat (24, 22, 21, 18) or fineness | * for gold/silver | Converts weight to pure grams: pure grams = grams × karat ÷ 24 (silver: × fineness ÷ 1000). |
| **Zakat share** — 0 % to 100 % of value | * | Part of the value that is zakatable. Default comes from asset type, per the consultant's rulings (100 % / 0 % / a proxy like Wahed's 30 % for long-held equities — example only, not a ruling). The user may override and sees the default's source. |
| **Inflation series** | * (defaulted) | Which inflation applies to this item's own real return (§8). Default from market country or item unit; user may override. |
| **Notes** | optional | Broker, account, reminders. Free text. |

**Item history** (all dated, all kept, all editable and deletable by the user):
- **Money in** — date, amount, unit.
- **Money out** — date, amount, unit, kind (sale / income).
- **Value update** — date, value in item unit. (Gold/silver: a change of grams instead.)

**Item state:** *open* while value > 0; *closed* when the user records a full sale (value set to 0). Closed items stay in all past months and years.

### 5.1 Additional buys and partial sells — **in v1**

Decision: in. Without them, Yasmin's monthly deposit into her fund would be counted as profit — the exact error research takeaway 2 names. Both Sharesight and Kubera base return on money in / money out.

Rules:
- Money in on date d raises the item's value by that amount (converted to item unit) on d, unless the user records a value update on d.
- Money out on date d lowers the value by that amount on d, unless the user records the value left. If that would go below 0, the user must enter the value left (≥ 0).
- Income received in hand = money out (kind: income). Income kept inside the investment (reinvested) is not recorded; it shows up in the next value update.
- No lot tracking, no unit prices, no FIFO. Not needed for return; needed only for tax, which is a BRD non-goal.

---

## 6. Units, rates and the base unit

### 6.1 Rates come from the user (device-only)

- The user enters rates by hand: "1 USD = 50.00 EGP on 2026-04-30". Each rate is kept with its date, like value history (same mechanism for FX, gold and silver — one channel, not three).
- A rate for A→B also serves B→A (inverse).
- **Rate used for a date:** the latest rate for that pair dated on or before that date. A month's figures use the rate at the month's start boundary for opening value, the rate on each flow's date for that flow, and the rate at the month end for closing value and zakat.
- **Stale rate:** if the rate used is dated before the period start, the figure is shown but marked "rate not updated in this period".
- **Missing rate:** if no rate exists on or before the date, the item is **left out** of base totals for that period and the user is told which item and which pair is missing. Never silently assumed 1:1.
- No price or FX feed in v1 (BRD §9 #1 stays open; research takeaway 8). No conversion through a third currency in v1 (Q6).

### 6.2 Return in item unit vs return in base unit — **show both per item, base only for totals**

- **Return in item unit** answers "how did the asset itself do?" (a USD stock flat in USD).
- **Return in base unit** answers "what did it do for my wealth?" (the same stock +10 % in EGP because EGP fell).
- Both are true and answer different questions; hiding either misleads Khaled. Totals and month/year aggregation need one unit, so they are in the base unit only. When item unit = base unit, the two figures are equal and shown once.

### 6.3 Choosing units (currency picker order)

Wherever the user chooses a unit (item unit, money in/out unit, rate pair, base unit), the list starts with **up to 5 most-used units**, then all other units in alphabetical order of code.
"Most used" = number of the user's investments whose item unit is that unit (open and closed). Ties: alphabetical by code. The base unit is always in the top group (it counts as used even with 0 items). XAU-g and XAG-g are units like any other. Alphabetical by code is language-neutral and testable; UX may sort by localized name instead (UX decision).

---

## 7. Gold and silver — evaluation and recommendation

Owner asked: gold (and silver) as an asset type only, as a currency-like unit, or as a selectable base unit?

| Option | User gets | Cost / risk |
|---|---|---|
| **A. Asset type only** (value typed in money) | Simplest. | User must recompute value in money every time; gold held in grams is what users actually know. Nisab (defined by weight) needs a gold price anyway, entered somewhere else. Two places for one price. |
| **B. Gold/silver as units** (XAU-g, XAG-g) with a dated rate like FX | Enter grams + karat once. One gold-rate update revalues **all** gold items and gives the **nisab in base currency** (nisab × gold rate). Return in gold terms is visible: plain bullion = 0 % in gold, making charges/premium show up as a loss vs metal. | Needs purity input. A gold rate per currency the user reports in. Same mechanism as FX, so no new machinery. |
| **C. Gold/silver as base unit** (see whole wealth in grams of gold) | Answers "is my wealth growing in gold terms?" — a yardstick many Muslim users relate to (dinar/dirham, nisab). Gold price is easier to look up than a CPI number. | Gold is volatile: in a strong gold year a sound portfolio looks like a loss, and the reverse. Gold ≠ the basket the user buys (food, rent), so it is **not** purchasing power in the CPI sense. Needs a gold rate for every currency held (no conversion via a third currency in v1). |

**Interaction with inflation:** gold is a store of value over long periods but not a price index. When the base unit is gold or silver, the return in that unit **already is** the "real" measure in that view — applying a CPI on top would double-count. So in a metal base: no inflation step, and "keep wealth stable" means "after zakat, my grams did not fall".

**Interaction with nisab:** nisab is defined by weight of gold or silver (exact weights and the gold-vs-silver choice: consultant / UC-3). Option B makes the nisab-in-money figure fall out of the gold/silver rate the user already keeps.

**Recommendation:** **B in v1** (gold and silver are units; gold/silver items are held in pure grams). **C as an owner decision (Q4)** — I recommend allowing it in v1 as a view, because it costs almost nothing once B exists, with the rule above (no CPI step) and a plain label that gold is a yardstick, not a price index. The consultant is reviewing the Shariah angle separately.

---

## 8. Inflation

### 8.1 Where the rate comes from

- The user enters **annual inflation rates per series, per calendar year** (e.g. Egypt 2026 = 20 %). No built-in default numbers: a number shipped in the app is stale within months and wrong per country (Q3). The app names the source to look up (the country's official CPI) — wording is UX.
- **Series for an item** (used for that item's own real return): stock → the market's country; fund/ETF/sukuk with a market → market's country; others → the default country of the item unit (USD → United States, EGP → Egypt, SAR → Saudi Arabia, EUR → euro area, …); gold/silver items → home inflation. User may override per item.
- **Home inflation** (used for the portfolio and for every figure in base unit): the default series of the base currency; user may override (e.g. reports in USD but lives in Egypt → picks Egypt).
- **Missing year:** if a year in the period has no rate, the latest earlier year's rate is used and the figure is marked "inflation assumed from YEAR". If no earlier rate exists, real figures for that period are not shown.

### 8.2 Inflation for a period

`i_period = Π over calendar years y touched by the period of (1 + π_y)^(d_y / D_y) − 1`
where π_y = annual rate for year y, d_y = days of the period in year y, D_y = days in year y (365 or 366).

### 8.3 Aggregating real return across items — **decision: convert to base, then deflate by home inflation**

| Method | Answers | Problem |
|---|---|---|
| **Convert to base first, deflate by home inflation** (chosen for totals) | "Can my whole wealth still buy the same basket **where I live**?" — the owner's goal. FX loss/gain is counted, as it should be for someone who spends in the home currency. | A US stock's figure mixes US market + FX + home inflation. That is why per-item real return in its own market is shown too (below). |
| **Deflate each item by its own inflation, then weight** | Nothing coherent: it averages purchasing power in different baskets, and ignores currency moves. Can show "positive" while the user lost purchasing power at home (AC-12). | Rejected for totals. |

So:
- **Per item**, two real figures: (a) **own-market real** = item-unit return deflated by the item's series ("did this USD stock beat US inflation?" — honors "the market drives the inflation"); (b) **real in base** = base-unit return deflated by home inflation.
- **Totals (month, year)**: real in base only. Totals are **not** the average of item own-market reals; this is stated to the user.

The owner may still prefer otherwise — Q5.

---

## 9. Formulas (all money in `Decimal`; percentages shown to 2 decimals)

### 9.1 Period and Modified Dietz return

A period runs from the end of day **S** to the end of day **E**; T = E − S in days. Months and years are Gregorian (hawl-year view: Q7).

- **BV** = value at end of S (last value on or before S), **EV** = value at end of E.
- **Flows** = money in (+) and money out (−) dated after S up to and including E. **CF** = sum of flows.
- Weight of a flow on date t: **W = (E − t) / T**.
- **D** (average capital) = BV + Σ W·flow.
- **Return R = (EV − BV − CF) / D.** If D ≤ 0, return is "not available" for that period.

An item that starts inside the period has BV = 0 and its first money in is a flow on its start date.
For the portfolio: BV, EV and every flow are first converted to the base unit (§6.1), then summed across items, then the formula is applied once.
Chosen because: money-weighted (answers "did *my* money grow"), no iteration (IRR can fail), used by Sharesight for private investors (research takeaways 2, 3, 5). **Known limit:** over long periods with large flows it can drift from the exact money-weighted return (IRR). Stated to the user in the "why".

### 9.2 Per item, since start

- **Gain** = current value + total money out − total money in (in item unit; and in base unit).
- **Simple ROI** = gain ÷ total money in.
- **Since-start return** = Modified Dietz with S = start date (BV = first money in, no flow on S), E = latest value date.
- **Annualised return** = (1 + since-start return)^(365 / T) − 1, **only if T ≥ 365 days**; otherwise not shown (Sharesight rule, research takeaway 4).
- With no money in/out after the start, simple ROI = since-start return.

### 9.3 Staleness

If an item has neither a value update nor a flow inside a period (gold/silver: no rate update), its closing value is carried forward and the item's figure for that period is marked "value not updated in this period". A total that includes such items says how many.

### 9.4 After zakat

**Zakat for a period** (an estimate for planning, not a ruling on when zakat is due — consultant to confirm, Z-3):
`Z_item = r_z × s × EV_item × (T / Y)`
r_z = annual zakat rate (placeholder 2.5 %, Z-2), s = zakat share, Y = length of the zakat year in days (placeholder 365, Z-2). In the item unit, then converted to base at the rate on E.
`Z` (portfolio) = Σ Z_item in base.

**Return after zakat:** `R_z = (EV − BV − CF − Z) / D`.
If the user states they owe no zakat this year (wealth below nisab — UC-3, Z-4), Z = 0 for periods in that year.

### 9.5 After inflation

- Real return before zakat: `(1 + R) / (1 + i) − 1`
- Real return after zakat: `(1 + R_z) / (1 + i) − 1`
i = i_period of the relevant series (§8). In a gold/silver base: not computed (§7).

### 9.6 "Did my wealth keep its purchasing power?" (the metric to act on)

For a period, in base unit, with home inflation i:

- **Needed end value** = `(BV + CF + i × D) / (1 − q)`, where q = Z / EV (the period's zakat as a share of end value; 0 if no zakat).
- **Needed return** = (Needed end value − BV − CF) / D.
- **Purchasing-power gap** = (EV − Z) − (BV + CF + i × D). **≥ 0 → kept; < 0 → lost**, by that amount.
- Equivalent check: real return after zakat ≥ 0.
- Metal base: i = 0 (§7).

This is a measurement, not advice. No suggestion of what to buy or sell.

---

## 10. Acceptance criteria

Unless stated: item unit = base unit = EGP, zakat placeholder r_z = 2.5 %, Y = 365. Expected figures rounded to 2 decimals; tests compare with full-precision results within 0.005.

**Fields and history**

- **AC-1** Given an investment without name, asset type, item unit, start date, first money in, zakat share, or (for a stock) market, or (for gold/silver) grams and purity, When the user saves it, Then it is rejected and each missing field is named.
- **AC-2** Given first money in of 0 or a start date after today, When saving, Then it is rejected.
- **AC-3** Given an item with value updates on 2026-01-31 (1,000) and 2026-02-28 (1,100), When the user adds an update 2026-03-31 (1,050), Then all three are kept and the February figures still use 1,100.
- **AC-4** Given an item worth 1,000, When the user records money out 1,000 with value left 0, Then the item is closed and still appears in every past month it was held.

**Simple ROI and annualised**

- **AC-5** Given item "Fund A": start 2025-01-01, first money in 10,000, value 11,500 on 2026-01-01, no other flows, When viewing since start, Then gain = 1,500, simple ROI = 15.00 %, since-start return = 15.00 %, annualised = 15.00 % (T = 365).
- **AC-6** Given start 2026-03-01, money in 1,000, value 1,050 on 2026-09-01, When viewing since start, Then simple ROI = 5.00 % and no annualised figure is shown (T = 184 < 365).

**Mid-period money (Modified Dietz)**

- **AC-7** Given "Fund A" worth 10,000 on 2026-03-31, money in 4,000 on 2026-04-16, value 14,500 on 2026-04-30, When viewing April 2026, Then W = 14/30, D = 11,866.67, return = 500 / 11,866.67 = **4.21 %** (not 45.00 %, which counts the deposit as profit).
- **AC-8** Given AC-7's "Fund A" plus "Fund B" (zakat share 0) worth 5,000 on 2026-03-31 and 4,900 on 2026-04-30, When viewing April 2026 totals, Then BV = 15,000, CF = 4,000, EV = 19,400, D = 16,866.67, return = **2.37 %**.
- **AC-9** Given AC-8 and Fund A zakat share 100 %, Egypt inflation 2026 = 10 %, When viewing April 2026 totals, Then Z = 0.025 × 14,500 × 30/365 = **29.79**, return after zakat = 370.21 / 16,866.67 = **2.19 %**, i = 1.10^(30/365) − 1 = **0.79 %**, real return after zakat = **1.40 %**.

**After zakat, after inflation, keep purchasing power (one year)**

- **AC-10** Given a stock item (EGX, EGP), zakat share 100 %, value 20,000 on 2025-12-31 and 23,000 on 2026-12-31, no flows, Egypt inflation 2026 = 10 %, When viewing year 2026, Then:
  return = **15.00 %**; Z = **575.00**; return after zakat = **12.13 %** (12.125 %); real before zakat = **4.55 %**; real after zakat = **1.93 %**; needed end value = 22,000 / (1 − 0.025) = **22,564.10**; needed return = **12.82 %**; purchasing-power gap = 22,425 − 22,000 = **+425.00 → kept**.
- **AC-11** Given AC-10 but end value 22,000, When viewing year 2026, Then Z = 550.00, gap = 21,450 − 22,000 = **−550.00 → lost**, real after zakat = **−2.50 %**.

**Multi-currency**

- **AC-12** Given base EGP, home inflation Egypt 2026 = 20 %, US inflation 2026 = 3 %; rates USD→EGP 50.00 on 2025-12-31 and 55.00 on 2026-12-31; item "US stock" (NASDAQ, USD, zakat share 0) 1,000 USD → 1,050 USD; item "EGX stock" (EGP, zakat share 0) 50,000 → 60,000 EGP; no flows; When viewing year 2026, Then:
  US stock: return in USD = **5.00 %**, own-market real (US 3 %) = **1.94 %**, return in EGP = 57,750 / 50,000 − 1 = **15.50 %**, real in base = **−3.75 %**;
  totals: BV 100,000, EV 117,750, return = **17.75 %**, real in base = **−1.88 %**, gap = 117,750 − 120,000 = **−2,250.00 → lost**;
  and the totals do **not** show the per-item average of own-market reals (which would be +0.97 %).
- **AC-13** Given an item in USD and base EGP with no USD/EGP rate dated on or before 2026-04-30, When viewing April 2026 totals, Then the item is left out of the totals and the user is told "US stock — USD→EGP rate missing". No 1:1 assumption.
- **AC-14** Given only a USD→EGP rate of 50.00 dated 2026-01-15, When viewing May 2026, Then 50.00 is used for opening and closing values and the figure is marked "rate not updated in this period".
- **AC-15** Given only a rate EGP→USD = 0.02 on 2026-04-30, When converting 1,000 USD to EGP on 2026-04-30, Then the result is 50,000 EGP (inverse used).
- **AC-16** Given a USD stock bought with 50,000 EGP on 2026-03-01 when USD→EGP = 50.00, When saving, Then first money in in item unit = 1,000 USD.

**Inflation choice**

- **AC-17** Given a new stock on Tadawul, When it is saved without override, Then its inflation series is Saudi Arabia; Given a cash deposit in USD, Then United States; Given the user overrides to Egypt, Then Egypt is used for its own-market real return.
- **AC-18** Given Egypt inflation 2025 = 25 % entered and 2026 not entered, When viewing a 2026 period, Then 25 % is used and the figure is marked "inflation assumed from 2025".
- **AC-19** Given a period 2025-12-01 to 2026-01-31 (end of S = 2025-11-30, T = 62: 31 days in 2025, 31 in 2026) with π_2025 = 10 %, π_2026 = 20 %, Then i = 1.10^(31/365) × 1.20^(31/365) − 1 = **2.39 %**.

**Gold and silver**

- **AC-20** Given base EGP, gold rate XAU-g→EGP 4,000 on 2025-12-31 and 5,000 on 2026-12-31, item "Gold" 20 g at 21k (pure = **17.5 g**), zakat share 100 %, Egypt inflation 2026 = 20 %, no flows, When viewing year 2026, Then: return in gold = **0.00 %**; return in EGP = 87,500 / 70,000 − 1 = **25.00 %**; Z = **2,187.50 EGP**; return after zakat = **21.88 %**; real after zakat = **1.56 %**; gap = 85,312.50 − 84,000 = **+1,312.50 → kept**.
- **AC-21** Given a gold rate 5,000 EGP on 2026-03-01, When the user buys 10 g of 24k gold paying 52,000 EGP that day, Then money in in gold unit = **10.40 XAU-g**, and on that day return in gold = return in EGP = **−3.85 %** (premium/making charge shows as a loss vs metal).
- **AC-22** Given one gold-rate update, When it is saved, Then every gold item's value in base changes using it, with no per-item value update.
- **AC-23** *(only if Q4 = yes)* Given base XAU-g and AC-20's item, When viewing 2026, Then return = **0.00 %**, Z = **0.44 XAU-g** (0.4375), return after zakat = **−2.50 %**, no inflation figure is shown, and the result is "lost 0.44 g".

**Staleness and edge cases**

- **AC-24** Given an item started 2026-01-10 with 1,000 and first value update 2026-06-20 = 1,200, When viewing months, Then Feb–May return = 0.00 % each and marked "value not updated", and June holds the whole gain.
- **AC-25** Given a period where D ≤ 0, Then the return is "not available", never a division error or ±∞.
- **AC-26** Given the user states "no zakat due for 2026", When viewing 2026, Then after-zakat figures equal before-zakat figures.

**Unit picker order**

- **AC-27** Given base EGP and investments in USD ×3, EGP ×2, SAR ×1, XAU-g ×1, When the user chooses a unit anywhere, Then the list starts **USD, EGP, SAR, XAU-g**, followed by all other units in alphabetical code order (AED, AUD, …) without repeating those four.
- **AC-28** Given investments in 6 different units, Then only the 5 most used are on top (ties alphabetical by code), base included even if used by 0 items (replacing the 5th).
- **AC-29** Given a new user with no investments and base SAR, Then the list starts with SAR, then all units alphabetical.

---

## 11. Out of scope (v1)

- Price, FX, gold, inflation feeds (BRD §9 #1 still open). All entered by hand.
- Conversion through a third currency (Q6).
- IRR, time-weighted return, benchmarks, forecasts, goal projections.
- Lots, unit prices, FIFO, tax, capital-gains reports.
- Splitting return into price / income / currency parts (Sharesight style).
- Purification of non-compliant income (separate Shariah story, BRD §8).
- Halal screening (UC-4). Nisab computation and zakat payment record (UC-3) — this story only uses "zakat due this year: yes/no".
- Deducting debts from zakatable wealth (UC-5 / consultant).
- Reminders to update values (BRD: no notifications in v1).
- Any advice on what to buy, sell or hold.

## 12. Shariah touchpoints — needed from the Islamic consultant

All in `docs/product/shariah/zakat-on-investments.md`, each with a cited reference.

- **Z-1** Zakatable share per asset type: stock (trading vs long-term holding), fund/ETF, sukuk, gold, silver (bullion vs personal jewellery), cash deposit, crypto. Is market value or a proxy (e.g. company zakatable-assets share) the base?
- **Z-2** Rate and year: 2.5 % per lunar year — on a Gregorian year, 2.5 % or about 2.577 % (365/354)? Which Y to use?
- **Z-3** Is showing a **monthly zakat estimate** (pro-rata) acceptable, or misleading since zakat is due only at hawl on wealth above nisab? If not, after-zakat applies to yearly/hawl views only.
- **Z-4** Nisab: which metal and weight; on pure gold content (karat) or gross weight; how the "below nisab → no zakat" switch should work when the investments list is not all of the user's wealth.
- **Z-5** Gold/silver as a unit or base of account (§7): any Shariah objection or preference?
- **Z-6** Interest earned on conventional deposits: should it be counted as return at all, or excluded / shown as "to purify"?
- **Z-7** Rate for zakat on a foreign-currency item: the rate on the hawl date — confirm.

## 13. Open questions for the owner

| # | Question | My recommendation |
|---|---|---|
| Q1 | Is "My Investments" the same thing as UC-1 "Record my holdings"? | Yes — merge; one list, not two. |
| Q2 | Price/FX/gold feed in v1 (BRD §9 #1)? | No. Manual + history + staleness marks. Revisit if users skip updates. |
| Q3 | Ship default inflation numbers? | No defaults; user enters; real figures hidden until a rate exists. |
| Q4 | Allow gold/silver as base unit (view wealth in grams)? | Yes as a view, no CPI step, clear "yardstick, not price index" label. |
| Q5 | Totals' real return: convert to base then deflate by home inflation (recommended) vs average of per-item own-market reals? | Convert-then-deflate; per-item own-market real shown on each item. |
| Q6 | Allow conversion through a third unit (e.g. USD→EGP→XAU-g) when no direct rate exists? | Not in v1; revisit if Q4 = yes and users find entering gold rate per currency heavy. |
| Q7 | Yearly view by Gregorian year only, or also by the user's hawl year? | Gregorian in v1; hawl year belongs with UC-3. |
| Q8 | Real estate as its own type? | "Other" in v1; no evidence yet of need for rent/expense modelling. |
