# Story — My Investments

**Status:** v1 draft · 2026-10-16 · PM hat · review loop 1 applied (owner decisions + consultant CHANGES_REQUESTED)
**Owner:** @OsamaKhalifa
**Research:** [my-investments-market.md](../research/my-investments-market.md)
**Shariah input:** [zakat-on-investments.md](../shariah/zakat-on-investments.md) — every zakat rule below comes from that file; section names (A1, B3, …) point into it.
**Relation to BRD:** this story **replaces UC-1 (Record my holdings)** and covers the ROI part of **UC-2** (owner decision Q1: one list, not two).

---

## 1. Who

- **Yasmin** (Salaried Saver) — adds money to a fund every month, owns some gold. Lives and spends in one currency.
- **Khaled** (DIY Investor) — holds stocks on more than one market (e.g. EGX and NASDAQ), in more than one currency, enters positions by hand.

## 2. What

Keep a hand-entered list of my investments, in any currency or in gold/silver grams, and see — per item, per month, per year — how much each one and the whole list really grew: before zakat, after the estimated zakat set-aside, and after inflation, in my base currency (or in grams of gold/silver).

## 3. Why (the financial outcome)

**Pain today:**
- General trackers (Sharesight, Kubera, Getquin) measure return but ignore zakat. Islamic apps (Zoya, Musaffa, Wahed) compute zakat but measure no return. Nobody we found shows **return after zakat and after inflation** together (research takeaway 1).
- A user whose currency loses 20–30 % a year can see a "profit" that is really a loss of purchasing power. A user who adds money monthly sees deposits counted as profit in naive trackers. Interest on a conventional deposit is counted as profit by every general tracker.

**Outcome:** the user knows, in money and in percent, whether their invested wealth **kept its purchasing power after setting aside zakat** for each month and year — a yes/no with a gap amount they can act on (save more, change mix — their decision; we give no advice).

---

## 4. Terms used in this story

| Term | Meaning |
|---|---|
| **Unit** | What an amount is measured in: a currency (ISO 4217 code, e.g. EGP, USD) or a metal unit: **XAU-g** = one gram of pure (24k) gold, **XAG-g** = one gram of pure (999) silver. |
| **Item unit** | The unit an investment's value is kept in. |
| **Base currency** | The one currency the user picks for totals, monthly/yearly views and zakat amounts. All totals are computed in it. |
| **Grams view** | Optional way to see totals in XAU-g or XAG-g instead of the base currency (§7). Computed in the base currency first, then converted. |
| **Rate** | "1 [unit A] = r [unit B] on date d". Covers FX rates and gold/silver prices. Entered by the user or fetched on request (§6.1). |
| **Money in** | Money the user put into an item: the first purchase and any later addition. Includes fees paid. |
| **Money out** | Money taken out of an item. Kinds: **sale** (partial or full), **income** (dividend, rent, profit share received in hand). |
| **Interest (to purify)** | Interest received on an item (e.g. a conventional deposit). **Not** money out, **not** return, **not** zakatable (Z-6). Tracked as its own total. |
| **Value update** | The user records what an item is worth on a date. |
| **Inflation series** | Annual inflation rates of one economy (a country or the euro area), by calendar year. Shipped with the app; user may override (§8.1). |
| **Home inflation** | The inflation series used to judge the whole portfolio's purchasing power. Default: the series of the base currency. |
| **Zakat year setting** | A matched pair: **lunar** r = 2.5 %, Y = 354.367 days (default) or **solar** r = 2.577 %, Y = 365 (A1, A2). Never mixed. |
| **Estimated zakat set-aside** | This story's zakat figure for a month or year. A planning estimate, **not** "zakat due" or "zakat paid" (Z-3). Real zakat is UC-3. |

---

## 5. The investment (fields)

`*` = required. No field exists without a user need.

| Field | Req. | User need |
|---|---|---|
| **Name** | * | Tell items apart ("Al Rajhi shares", "Gold bar 50 g"). |
| **Asset type** — stock · fund/ETF · sukuk · gold · silver · cash deposit · crypto · other (real estate, business, pension, anything else) | * | Breakdown by asset class (UC-2); picks the zakat rule set (Part B); decides whether a market or grams are asked. Real estate, business and pension stay under "other" in v1 (Q8). **Pension is not a v1 type**: it is "other", its zakat share is asked per item with B7 as help, so no pension question at setup. |
| **Intent** — trading · long-term · personal use · rental | * where the Shariah file needs it (below) | Decides the zakatable base: trading vs long-term vs personal use (B2, B3, B5). |
| **Market** (exchange) — e.g. Tadawul, EGX, NASDAQ, NYSE, LSE, DFM, ADX, Boursa Kuwait, QSE, Bursa Malaysia, BIST, PSX, or "other market + country" | * for stock; optional for fund/ETF and sukuk; absent for others | Same ticker exists on several markets; UC-4 screening needs it. Gives the item's **country**, which picks its default inflation series (§8). |
| **Item unit** | * | What the value is kept in. Default: the market's trading currency for a stock; the base currency otherwise; XAU-g / XAG-g for gold / silver (§7). |
| **Start date** | * | First money in. Needed for annualised return and for placing money in the right month/year. Not in the future. |
| **First money in** — amount + unit | * | What the user paid, fees included. Denominator of every return. Unit defaults to the item unit; may differ (EGP for a USD stock, EGP for gold). Must be > 0. |
| **Current value** (first value update) — amount + date | * | What it is worth now. If not given, equals first money in converted to the item unit on the start date. For gold/silver this is not typed: it is the pure grams. |
| **Quantity** — number + "shares/units/grams" | * for gold/silver; optional otherwise | Gold/silver: grams drive value and nisab. Others: check against the broker statement; no return or zakat calculation uses it in v1. Input help (UX-Q8): when quantity is set, a value may be typed as "price per unit"; the stored value is price × current quantity, shown before saving. Quantity does not change by itself on money in/out. |
| **Purity** — karat (24, 22, 21, 18) or fineness | * for gold/silver | Pure grams = grams × karat ÷ 24 (silver: × fineness ÷ 1000). Nisab counts pure content (Z-4). |
| **Zakat share** — 0 % to 100 % of value | * | Part of the value that is zakatable. Default per asset type **and intent**, from zakat-on-investments.md Part B and its table "Inputs the app needs per investment". The user may override and always sees the rule and its source (A9). |
| **Inflation series** | * (defaulted) | Which inflation applies to this item's own real return (§8). |
| **Notes** | optional | Broker, account, reminders. |

### 5.1 Zakat share defaults (summary; the Shariah file is the source)

| Asset type | Intent | Default zakat share |
|---|---|---|
| cash deposit | — | 100 % (B1). Interest on it is never in the base (Z-6). |
| gold / silver | long-term (bullion, default) | 100 % (B2) |
| gold / silver | personal use (jewellery) | the user's jewellery setting: 100 % or 0 % — **asked** the first time jewellery is added (B2) |
| stock, fund/ETF | **asked**, no default | trading → 100 %; long-term → the user's **long-term method**, **asked** (per item or once as a portfolio setting): dividends-only (IIFA) → 0 % of value, and a set-aside of r_z × each "income received" (dividend) on the item, charged once (§9.4, consultant answer (a), IIFA Res 28 (3/4) §3); if the same dividend is also recorded as money in to a cash item in this list, that cash entry shows "Already counted as dividend zakat on {item}?"; 25 % proxy (NZF) → 25 %; full value → 100 % (B3, B4) |
| sukuk | — | 100 % (B4) |
| crypto | — | 100 % of market value, with a notice that scholars dispute whether holding it is permissible (B8) |
| other (real estate, business, pension, …) | asked | **ask** — nothing is filled in silently (B5–B7). Where the Shariah file gives a value for the intent (personal use → 0 %, rental → 0 % with rent zakat via cash, trading/resale → 100 %), it is **offered** with its source and applies only when the user confirms it. Business and pension: no value offered. |

### 5.2 Settings asked once (no silent defaults)

Disputed views are **asked at first setup** and can be changed later. Each answer shows its source.
- **Zakat year:** lunar (2.5 %, 354.367 days) or solar (2.577 %, 365 days). Lunar is pre-selected and shown, never applied silently (consultant: default lunar; owner: no silent defaults).
- **Long-term shares method** (asked at setup or when the first long-term stock/fund is added).
- **Jewellery ruling** (asked when jewellery is first added).
- Nisab metal (gold 85 g / silver 595 g) is asked by UC-3, not here; this story only uses the yes/no "zakat due this year" switch (§9.4).

### 5.3 Item history

All dated, all kept, all editable and deletable by the user:
- **Money in** — date, amount, unit.
- **Money out** — date, amount, unit, kind (sale / income).
- **Interest (to purify)** — date, amount, unit, and where it is: **paid out to me** or **kept inside this item**.
- **Interest given away** — date, amount, and from where: **from inside this item** or **from interest paid out to me**.
- **Value update** — date, value in item unit. (Gold/silver: a change of grams instead.)

**Item state:** *open* while value > 0; *closed* when the user records a full sale (value set to 0). Closed items stay in all past months and years.

### 5.4 Additional buys, partial sells, income, interest — **in v1**

Additional buys and partial sells are in: without them, Yasmin's monthly deposit would count as profit (research takeaway 2).

- Money in on date d raises the item's value by that amount (converted to item unit) on d, unless the user records a value update on d.
- Money out on date d lowers the value by that amount on d, unless the user records the value left. If that would go below 0, the user must enter the value left (≥ 0).
- Income received in hand = money out (kind: income). Income kept inside the investment is not recorded; it shows up in the next value update.
- **Interest (to purify)** (Z-6, Quran 2:278–279):
  - **Held interest H** of an item on a date = interest kept inside the item − interest given away from inside the item, up to that date.
  - For return, gain and zakat, the item's value is **recorded value − H**. So interest never counts as return and never enters the zakat base.
  - Interest kept inside the item raises the recorded value by that amount on its date (unless a value update is recorded that day), and H by the same amount: no effect on return.
  - Interest paid out to the user: no effect on value or return.
  - Interest given away **from inside the item** lowers the recorded value and H by the same amount: no effect on return.
  - Interest given away **from interest paid out to me** changes neither the item's value nor H: no effect on return.
  - **To purify** total (per item and overall) = all interest recorded − all interest given away (from both places). Shown on its own, never netted against zakat.
- No lot tracking, unit prices or FIFO. Needed only for tax (BRD non-goal).

---

## 6. Units, rates and the base currency

### 6.1 Where rates come from

**Manual (always available, offline):** the user enters "1 USD = 50.00 EGP on 2026-04-30". Each rate is kept with its date. Same mechanism for FX, gold and silver.

**Optional online refresh (owner decision Q2):**
- Only when the user asks for it. **No background fetch**, ever.
- Gets the latest FX rates and gold/silver prices from one free public source (choice: architect).
- **Sends no user data.** The request is the same for every user: no list of the user's currencies, no amounts, no identifiers. (Asking only for the user's currencies would reveal what they hold.)
- Each fetched rate is stored as a dated history entry exactly like a manual one, with the source's own "as of" date (not the phone's date) and the source name.
- Gold/silver priced per troy ounce are stored per pure gram: price per gram = price per ounce ÷ 31.1034768.
- **A manual rate on the same date and pair wins** over a fetched one. Both are kept; the manual one is used.
- If the refresh fails (offline, source down), nothing changes and the user is told it failed. Every figure still works from stored rates.
- Fetches the latest rates only (Q9, decided). Rates for past dates come from earlier refreshes or manual entry. So a fetch for a specific past date (e.g. a past start date) is not offered; a fetch inside a form is offered only when the date needed is today, and it runs the same identical request.

**Rate lookup:**
- A rate for A→B also serves B→A (inverse).
- **Rate used for a date:** the latest rate for that pair dated on or before that date. A month uses the rate at its start boundary for opening value, the rate on each flow's date for that flow, and the rate at month end for closing value and the zakat set-aside.
- **Stale rate:** if the rate used is dated before the period start, the figure is shown but marked "rate not updated in this period".
- **Missing rate:** if no rate exists on or before the date, the item is **left out** of base totals for that period and the user is told which item and which pair is missing. Never 1:1.
- No conversion through a third currency in v1 (Q6). The grams view needs only the gold/silver rate against the base currency (§7), so this is not a blocker.

### 6.2 Return in item unit vs base currency — **both per item, base only for totals**

- **Return in item unit:** "how did the asset itself do?" (a USD stock flat in USD).
- **Return in base currency:** "what did it do for my wealth?" (the same stock +10 % in EGP because EGP fell).
- Both are true; hiding either misleads Khaled. Totals need one unit, so they are in the base currency (or grams view). If item unit = base currency, the two figures are equal and shown once.

### 6.3 Choosing units (picker order)

Wherever the user chooses a unit (item unit, money in/out unit, rate pair, base currency), the list starts with **up to 5 most-used units**, then all other units alphabetically by code.
"Most used" = number of the user's investments whose item unit is that unit (open and closed). Ties: alphabetical by code. The base currency is always in the top group (it counts as used even with 0 items). XAU-g and XAG-g are units like any other. **v1 unit list:** the architect's 29 currencies (spec §2.1) plus **SEK, NOK, DKK** (Muslims in non-euro Europe), plus XAU-g and XAG-g — not all of ISO 4217. Before a base currency exists (first setup), the phone's region currency takes the base currency's place. Alphabetical by code is language-neutral and testable; UX may sort by localized name instead (UX decision).

---

## 7. Gold and silver — decided

**Decision (owner Q4, consultant Z-5: no objection):**
- Gold and silver are **units** (XAU-g, XAG-g) with dated rates, using the same mechanism as FX. Gold/silver items are held in pure grams. One gold-rate update revalues every gold item and gives the nisab in money (nisab weight × gold rate; UC-3).
- The user may see totals in a **grams view** (gold or silver). It is a view: everything is computed in the base currency, then converted at the gold/silver rate of each date (BV and flows at their dates, EV and the zakat set-aside at E).
- **Zakat is computed in money** per the Shariah file, **then shown in grams**. No gold-for-gold exchange is modelled (A8, Muslim 1587).
- In the grams view the return in grams **already is** the "real" measure: **no inflation step**. "Kept purchasing power" means "after the zakat set-aside, my grams did not fall".
- Label: gold is a **yardstick, not a price index**. Gold swings a lot: in a strong gold year a sound portfolio looks like a loss in grams, and the reverse.

Why not "asset type only": the user would recompute money value by hand each time and keep the gold price in two places (value and nisab).

---

## 8. Inflation

### 8.1 Where the rate comes from — **shipped defaults + user override** (owner decision Q3)

- The app **ships default annual inflation rates** (latest official annual CPI change) for the countries of all supported markets and currencies, plus the euro area. Each value carries its **source** and **"as of" year**.
  - *Candidate dataset (architect confirms):* World Bank WDI indicator **FP.CPI.TOTL.ZG** "Inflation, consumer prices (annual %)" (sourced from IMF International Financial Statistics). For the euro area: Eurostat HICP annual rate. Use actual values only, not forecasts (e.g. not IMF WEO projections).
  - Shipped values change only with an app update.
- The user may **override any year of any series**. The user's value wins, also after an app update ships a new value for that year. Removing the override brings back the shipped value.
- **Years after the last value** (shipped or user): the latest earlier year's rate is used, marked "inflation assumed from YEAR". If a series has no value at all, real figures using it are not shown and the user is told which series is empty.
- **Series for an item** (its own real return): stock → market's country; fund/ETF/sukuk with a market → market's country; others → default country of the item unit (USD → United States, EGP → Egypt, SAR → Saudi Arabia, EUR → euro area, …); gold/silver items → home inflation. User may override per item.
- **Home inflation** (portfolio, every figure in base currency): default series of the base currency; user may override (reports in USD but lives in Egypt → Egypt).

### 8.2 Inflation for a period

`i_period = Π over calendar years y touched by the period of (1 + π_y)^(d_y / D_y) − 1`
π_y = annual rate for year y, d_y = days of the period in year y, D_y = days in year y (365 or 366).

### 8.3 Aggregating real return across items — **convert to base, then deflate by home inflation** (owner Q5)

| Method | Answers | Problem |
|---|---|---|
| **Convert to base first, deflate by home inflation** (chosen for totals) | "Can my whole wealth still buy the same basket **where I live**?" FX moves count, as they should for someone who spends in the home currency. | A US stock's figure mixes US market + FX + home inflation — so the own-market real is also shown per item. |
| Deflate each item by its own inflation, then weight | Nothing coherent: averages purchasing power of different baskets and ignores currency moves. Can show "positive" while the user lost purchasing power at home (AC-12). | Rejected for totals. |

- **Per item**, two real figures: (a) **own-market real** = item-unit return deflated by the item's series; (b) **real in base** = base return deflated by home inflation.
- **Totals**: real in base only. They are **not** the average of item own-market reals; the user is told this.
- Every real figure is labelled "Purchasing power (for planning only — zakat is always on today's actual value)" (A6). Inflation never touches the zakat base.

---

## 9. Formulas (all money in `Decimal`; percentages shown to 2 decimals)

### 9.1 Period and Modified Dietz return

A period runs from the end of day **S** to the end of day **E**; T = E − S in days. Months and years are Gregorian (Q7). The **current** month or year ends **today** (E = today) and is labelled "so far".

- **BV** = value at end of S (last value on or before S), **EV** = value at end of E. Values are always net of held interest H (§5.4).
- **Flows** = money in (+) and money out (−) dated after S up to and including E. Interest records are never flows. **CF** = sum of flows.
- Weight of a flow on date t: **W = (E − t) / T**.
- **D** (average capital) = BV + Σ W·flow.
- **Return R = (EV − BV − CF) / D.** If D ≤ 0, return is "not available".

An item that starts inside the period has BV = 0 and its first money in is a flow on its start date.
Portfolio: BV, EV and every flow are first converted to the base currency (§6.1), summed across items, then the formula is applied once.
Why Modified Dietz: money-weighted ("did *my* money grow"), no iteration (IRR can fail), used by Sharesight for private investors (research takeaways 2, 3, 5). **Known limit:** over long periods with large flows it can drift from the exact money-weighted return (IRR). Stated to the user.

### 9.2 Per item, since start

- **Gain** = current value + total money out − total money in (item unit and base currency).
- **Simple ROI** = gain ÷ total money in.
- **Since-start return** = Modified Dietz with S = start date (BV = first money in, no flow on S), E = latest value date.
- **Annualised return** = (1 + since-start return)^(365 / T) − 1, **only if T ≥ 365 days**; otherwise not shown (research takeaway 4).
- With no money in/out after the start, simple ROI = since-start return.
- **Since-start set-aside, return after set-aside, and real returns** (UX-Q5): the §9.4 and §9.5 formulas over the same period (S = start date, E = latest value date, T = days held), inflation per §8.2 over that period. If the held period includes years switched to "no zakat due", T in the set-aside counts only the days outside those years, and dividends dated in those years are not charged. Labels as in §9.4 and §8.3.

### 9.3 Staleness

If an item has neither a value update nor a flow inside a period (gold/silver: no rate update), its closing value is carried forward and its figure is marked "value not updated in this period". A total that includes such items says how many.

**Stale now** (UX-Q3, decided): an item is stale today if it has no value update and no money in/out in the **current calendar month**; a rate is stale if it has no entry (typed or fetched) dated in the current calendar month. Same rule as the month marker, so "today" and the month view never disagree. No user setting in v1: a user who updates quarterly does have stale monthly figures, and saying so is honest. Revisit only with evidence that the banner drives users away.

### 9.4 Estimated zakat set-aside

`Z_item = r_z × s × EV_item × (T / Y)`
r_z and Y = the user's zakat year setting, **always as a matched pair**: lunar 2.5 % / 354.367 (default) or solar 2.577 % / 365 (A1, A2, Z-2). s = zakat share. EV_item is net of held interest. Computed in money (item unit), converted to the base currency at the rate on E (Z-7: fine for a planning figure; UC-3 uses the rate on the zakat date).
`Z_div_item = r_z × (sum of money out of kind income dated inside the period)` — only for items on the dividends-only method (s = 0). **No T/Y factor**: each dividend is charged once, when received (consultant answer (a), IIFA Res 28 (3/4) §3). Converted to base at the rate on **each dividend's date** (not at E), because each dividend is charged on its own date.
`Z` (portfolio) = Σ (Z_item + Z_div_item) in base currency.

- Label everywhere: **"estimated zakat set-aside (planning). Actual zakat is due once a year on your zakat date."** Never "zakat due" or "zakat paid" (Z-3).
- Each zakat figure's "why" points to its section of zakat-on-investments.md (A9): rate and year (A1/A2), the asset rule (Part B), FX (A7).
- **Return after zakat set-aside:** `R_z = (EV − BV − CF − Z) / D`.
- **"No zakat due this year" switch:** if on, Z = 0 for periods in that year. Help text: **"Decide using all your zakatable wealth, not only this list."** (Z-4). The full nisab check is UC-3.
- **Nisab hint** next to the switch (consultant answer (b)): "Nisab: {weight} {metal} = {amount} {base} on {date} (your {metal} rate)" for the chosen metal (gold 85 g / silver 595 g; both lines if not chosen yet), and "Zakatable total in this list: Σ (value × zakat share)" at today's values and rates. The switch is never set automatically. No rate for the metal → "Add a {metal} rate to see the nisab".

### 9.5 After inflation

- Real return before zakat: `(1 + R) / (1 + i) − 1`
- Real return after zakat set-aside: `(1 + R_z) / (1 + i) − 1`
i = i_period of the relevant series (§8). Grams view: not computed (§7).

### 9.6 "Did my wealth keep its purchasing power?"

For a period, in base currency, with home inflation i:

- **Needed end value** = `(BV + CF + i × D) / (1 − q)`, q = Z / EV (0 if no zakat).
- **Needed return** = (Needed end value − BV − CF) / D.
- **Purchasing-power gap** = (EV − Z) − (BV + CF + i × D). **≥ 0 → kept; < 0 → lost**, by that amount.
- Equivalent check: real return after zakat set-aside ≥ 0.
- Grams view: i = 0, all amounts in grams (§7).

A measurement, not advice. No suggestion of what to buy or sell.

---

## 10. Acceptance criteria

Unless stated: item unit = base currency = EGP; zakat year = **lunar (r = 2.5 %, Y = 354.367)**. Expected figures rounded to 2 decimals; tests compare full-precision results within 0.005. All figures below were re-checked with a script.

**Fields and history**

- **AC-1** Given an investment without name, asset type, item unit, start date, first money in, or zakat share; or a stock without market; or a stock/fund/other without intent; or gold/silver without grams and purity, When the user saves it, Then it is rejected and each missing field is named.
- **AC-2** Given first money in of 0 or a start date after today, When saving, Then it is rejected.
- **AC-3** Given an item with value updates on 2026-01-31 (1,000) and 2026-02-28 (1,100), When the user adds an update 2026-03-31 (1,050), Then all three are kept and the February figures still use 1,100.
- **AC-4** Given an item worth 1,000, When the user records a sale of 1,000 with value left 0, Then the item is closed and still appears in every past month it was held.

**Zakat share defaults and settings**

- **AC-5** Given a stock with intent "long-term", method "dividends-only", value 50,000 at both ends of 2026, and income received 400 on 2026-03-15 and 600 on 2026-09-15 (zakat year lunar), When viewing year 2026, Then its zakat share is 0 %, the set-aside on its value is 0, and its set-aside = 0.025 × 1,000 = **25.00** (no T/Y factor); When viewing March 2026, Then set-aside = **10.00**; September 2026 = **15.00**; other months = 0.
- **AC-6** Given a new crypto item, Then its zakat share defaults to 100 % and a notice says scholars dispute whether holding it is permissible.
- **AC-7** Given a new "other" item (e.g. real estate), When saved without a zakat share the user confirmed, Then it is rejected — no default is applied. Given intent "personal use", Then 0 % is offered with its source (B5), and is used only after the user confirms it; Given intent "business" or a pension, Then no value is offered.
- **AC-8** Given a first-time user, When setup completes, Then the zakat year, and the long-term method before the first long-term stock/fund is saved, have each been answered by the user; none is applied without being shown.
- **AC-9** Given zakat year = solar, Then r = 2.577 % and Y = 365 are used together; Given lunar, Then 2.5 % and 354.367. No other combination is possible.

**Simple ROI and annualised**

- **AC-10** Given "Fund A": start 2025-01-01, first money in 10,000, value 11,500 on 2026-01-01, no other flows, When viewing since start, Then gain = 1,500, simple ROI = 15.00 %, since-start return = 15.00 %, annualised = 15.00 % (T = 365).
- **AC-11** Given start 2026-03-01, money in 1,000, value 1,050 on 2026-09-01, When viewing since start, Then simple ROI = 5.00 % and no annualised figure is shown (T = 184).

**Mid-period money (Modified Dietz)**

- **AC-12** Given "Fund A" worth 10,000 on 2026-03-31, money in 4,000 on 2026-04-16, value 14,500 on 2026-04-30, When viewing April 2026, Then W = 14/30, D = 11,866.67, return = 500 / 11,866.67 = **4.21 %** (not 45.00 %).
- **AC-13** Given AC-12's "Fund A" plus "Fund B" (zakat share 0) worth 5,000 on 2026-03-31 and 4,900 on 2026-04-30, When viewing April 2026 totals, Then BV = 15,000, CF = 4,000, EV = 19,400, D = 16,866.67, return = **2.37 %**.
- **AC-14** Given AC-13, Fund A zakat share 100 %, Egypt inflation 2026 = 10 %, When viewing April 2026 totals, Then set-aside Z = 0.025 × 14,500 × 30 / 354.367 = **30.69**, labelled "estimated zakat set-aside (planning)…"; return after set-aside = **2.19 %**; i = 1.10^(30/365) − 1 = **0.79 %**; real after set-aside = **1.39 %**.

**After zakat, after inflation, purchasing power (one year)**

- **AC-15** Given a stock (EGX, EGP), zakat share 100 %, value 20,000 on 2025-12-31 and 23,000 on 2026-12-31, no flows, Egypt inflation 2026 = 10 %, When viewing year 2026, Then: return = **15.00 %**; Z = 0.025 × 23,000 × 365 / 354.367 = **592.25**; return after set-aside = **12.04 %**; real before zakat = **4.55 %**; real after set-aside = **1.85 %**; needed end value = **22,581.48**; needed return = **12.91 %**; gap = 22,407.75 − 22,000 = **+407.75 → kept**.
- **AC-16** Given AC-15 with zakat year = solar, Then Z = 0.02577 × 23,000 × 365 / 365 = **592.71**.
- **AC-17** Given AC-15 but end value 22,000, Then Z = **566.50**, gap = **−566.50 → lost**, real after set-aside = **−2.58 %**.
- **AC-18** Given AC-15 and the "no zakat due this year" switch on for 2026, Then after-set-aside figures equal before-zakat figures, and the switch shows "Decide using all your zakatable wealth, not only this list."

**Interest (to purify)**

- **AC-19** Given a cash deposit (zakat share 100 %) worth 10,000 on 2025-12-31, interest 500 recorded on 2026-06-30 as "kept inside this item", value update 10,500 on 2026-12-31, When viewing year 2026, Then: return = **0.00 %**; gain = 0; set-aside Z = 0.025 × 10,000 × 365 / 354.367 = **257.50** (interest not in the base); to purify = **500.00**, shown on its own and not subtracted from Z. When the user then records "interest given away" 500 on 2027-01-05, Then to purify = 0 and the 2027 return is not affected.
- **AC-19b** Given a cash deposit (zakat share 100 %) worth 10,000 on 2025-12-31, interest 300 recorded on 2026-06-30 as "paid out to me", and "interest given away" 300 from interest paid out to me on 2026-07-10, value 10,000 on 2026-12-31, When viewing year 2026, Then: to purify = 300.00 after 2026-06-30 and **0.00** after 2026-07-10; item value stays **10,000** and H = **0** throughout; return = **0.00 %**; set-aside Z = **257.50**.

**Multi-currency**

- **AC-20** Given base EGP, home inflation Egypt 2026 = 20 %, US 2026 = 3 %; USD→EGP 50.00 on 2025-12-31 and 55.00 on 2026-12-31; "US stock" (NASDAQ, USD, share 0) 1,000 → 1,050 USD; "EGX stock" (EGP, share 0) 50,000 → 60,000 EGP; no flows; When viewing 2026, Then:
  US stock: return in USD = **5.00 %**, own-market real = **1.94 %**, return in EGP = **15.50 %**, real in base = **−3.75 %**;
  totals: BV 100,000, EV 117,750, return = **17.75 %**, real in base = **−1.88 %**, gap = **−2,250.00 → lost**;
  and totals do **not** show the average of own-market reals (+0.97 %).
- **AC-21** Given a USD item, base EGP, no USD/EGP rate on or before 2026-04-30, When viewing April 2026 totals, Then the item is left out and the user is told "US stock — USD→EGP rate missing".
- **AC-22** Given only USD→EGP 50.00 dated 2026-01-15, When viewing May 2026, Then 50.00 is used and the figure is marked "rate not updated in this period".
- **AC-23** Given only EGP→USD = 0.02 on 2026-04-30, When converting 1,000 USD to EGP that day, Then the result is 50,000 EGP.
- **AC-24** Given a USD stock bought with 50,000 EGP on 2026-03-01 when USD→EGP = 50.00, Then first money in in item unit = 1,000 USD.

**Online refresh**

- **AC-25** Given the user has not asked for a refresh, When the app runs for any length of time, Then it makes no network request for rates.
- **AC-26** Given the user asks for a refresh, Then the request contains no currency list from the user's data, no amounts and no identifiers — it is identical for every user.
- **AC-27** Given a refresh returns USD→EGP 48.50 "as of 2026-10-15" from source X, Then one history entry is stored: pair USD→EGP, 48.50, date 2026-10-15, source X — regardless of the phone's date.
- **AC-28** Given a manual USD→EGP 49.00 on 2026-10-15, When a refresh returns 48.50 for the same date, Then both are kept and 49.00 is used.
- **AC-29** Given the phone is offline, When the user asks for a refresh, Then no rate changes, the user is told it failed, and all figures are unchanged.
- **AC-30** Given the source gives gold at 3,110.34768 USD per troy ounce, Then the stored rate is XAU-g→USD **100.00**.

**Inflation choice and shipped defaults**

- **AC-31** Given a new stock on Tadawul, Then its inflation series is Saudi Arabia; a cash deposit in USD → United States; after a user override to Egypt → Egypt for its own-market real.
- **AC-32** Given a shipped Egypt 2025 rate, Then it shows its source and "as of 2025". Given the user overrides Egypt 2025 to 30 %, Then 30 % is used, and still after an app update ships a new Egypt 2025 value; When the user removes the override, Then the shipped value is used.
- **AC-33** Given Egypt's last value is 2025 = 25 % and none for 2026, When viewing a 2026 period, Then 25 % is used and marked "inflation assumed from 2025".
- **AC-34** Given a period with S = 2025-11-30, E = 2026-01-31 (31 days in each year), π_2025 = 10 %, π_2026 = 20 %, Then i = 1.10^(31/365) × 1.20^(31/365) − 1 = **2.39 %**.
- **AC-35** Given any real figure, Then it carries the label "Purchasing power (for planning only — zakat is always on today's actual value)".

**Gold and silver**

- **AC-36** Given base EGP, XAU-g→EGP 4,000 on 2025-12-31 and 5,000 on 2026-12-31, "Gold" 20 g at 21k (pure **17.5 g**), share 100 %, Egypt inflation 2026 = 20 %, no flows, When viewing 2026, Then: return in gold = **0.00 %**; return in EGP = **25.00 %**; Z = 0.025 × 87,500 × 365 / 354.367 = **2,253.14 EGP**; return after set-aside = **21.78 %**; real after set-aside = **1.48 %**; gap = 85,246.86 − 84,000 = **+1,246.86 → kept**.
- **AC-37** Given XAU-g→EGP 5,000 on 2026-03-01, When the user buys 10 g of 24k gold paying 52,000 EGP that day, Then money in in gold unit = **10.40 XAU-g**, and that day the return in gold = return in EGP = **−3.85 %**.
- **AC-38** Given one gold-rate update, Then every gold item's base value changes with it, with no per-item value update.
- **AC-39** Given the grams view (gold) and AC-36, When viewing 2026, Then BV = EV = **17.50 g**, Z is computed in EGP (2,253.14) and shown as **0.45 g**, return after set-aside = **−2.58 %**, no inflation figure is shown, result "lost 0.45 g", and the view is labelled "gold is a yardstick, not a price index".

**Staleness and edge cases**

- **AC-40** Given an item started 2026-01-10 with 1,000 and first value update 2026-06-20 = 1,200, Then Feb–May returns = 0.00 % each, marked "value not updated", and June holds the whole gain.
- **AC-41** Given a period where D ≤ 0, Then the return is "not available", never a division error or ±∞.

**Unit picker order**

- **AC-42** Given base EGP and investments in USD ×3, EGP ×2, SAR ×1, XAU-g ×1, When the user chooses a unit anywhere, Then the list starts **USD, EGP, SAR, XAU-g**, then all other units in code order (AED, AUD, …) without repeating those four.
- **AC-43** Given investments in 6 different units, none in the base currency, Then the top group is the base currency plus the 4 most used (ties alphabetical by code).
- **AC-44** Given a new user with no investments and base SAR, Then the list starts with SAR, then all units alphabetical.

**Nisab hint**

- **AC-45** Given base EGP, XAU-g→EGP 5,000 and XAG-g→EGP 60 on 2026-10-16, nisab metal not chosen, items: cash deposit 100,000 (share 100 %) and long-term stock 50,000 (NZF 25 %), When the user looks at the "no zakat due" switch on 2026-10-16, Then it shows "Nisab: 85 g gold = **425,000.00 EGP**" and "Nisab: 595 g silver = **35,700.00 EGP**", "Zakatable total in this list: **112,500.00 EGP**", and the help text from §9.4; and the switch stays as the user left it. Given no gold rate, Then the gold line reads "Add a gold rate to see the nisab".

---

## 11. Out of scope (v1)

- Background or automatic rate refresh. Fetching past (historical) rates (Q9). Price feeds for stocks/funds.
- Online inflation data (shipped with the app only).
- Conversion through a third currency (Q6).
- IRR, time-weighted return, benchmarks, forecasts, goal projections.
- Lots, unit prices, FIFO, tax, capital-gains reports.
- Splitting return into price / income / currency parts.
- Purification beyond the "to purify" total and "interest given away" record: no purification of mixed-income shares/funds (separate Shariah story, BRD §8).
- Halal screening (UC-4). Nisab computation, zakat date, zakat paid record (UC-3).
- Deducting debts from zakatable wealth (UC-5 / A5).
- Any gold-for-gold exchange or deferred gold purchase (A8).
- Inflation figures on debts — never (A6.3; relevant to UC-5).
- Reminders to update values (BRD: no notifications in v1).
- Any advice on what to buy, sell or hold.

## 12. Shariah touchpoints

Answered by the consultant (Z-1…Z-7 in zakat-on-investments.md) and applied above. Still open on their side, to close before release:
- Pure vs gross weight for nisab — practice, primary source **[U]** (Z-4).
- AAOIFI SS 21 section number for purification **[U]** (Z-6).
- Named-scholar confirmation of "real return" display — owner may request (A6.2).

## 13. Owner decisions and open questions

| # | Question | Status |
|---|---|---|
| Q1 | Merge with UC-1? | **Decided: yes.** |
| Q2 | Price/FX/gold feed? | **Decided:** optional user-triggered refresh of FX and gold/silver; manual stays; source = architect (§6.1). |
| Q3 | Default inflation rates? | **Decided:** shipped yearly CPI with source and "as of" year; user override wins (§8.1). Dataset = architect. |
| Q4 | Gold/silver base view? | **Decided: yes**, grams view, no CPI step, "yardstick" label (§7). |
| Q5 | Real totals method? | **Decided:** convert to base, deflate by home inflation (§8.3). |
| Q6 | Conversion through a third unit? | **Decided: not in v1.** |
| Q7 | Hawl-year view? | **Decided:** Gregorian only in v1; hawl year with UC-3. |
| Q8 | Real estate own type? | **Decided:** under "other" in v1. |
| Q9 | Should a refresh also fill past month-end rates (history), so past months are not stale? | **Decided (orchestrator, scope cut):** not in v1 — a history request is large, and a request tailored to the user's dates would reveal when they invested. Revisit if users report stale past months. |

## 14. Answers to the UX doc's questions (docs/product/ux/my-investments.md)

| UX question | Answer |
|---|---|
| PM-Q1 dividends-only computation | Consultant owns it: zakat-on-investments.md Z-1 and B3. Applied: s = 0, set-aside = r_z × dividends in the period, no T/Y (§5.1, §9.4, AC-5). |
| PM-Q2 what the nisab choice drives | Consultant owns it: zakat-on-investments.md Z-4 / A3. Nisab check is UC-3 (§11). |
| PM-Q3 stale threshold | Calendar month, no setting (§9.3). |
| PM-Q4 historical rates from refresh | No; latest only. In-form fetch only when the date needed is today (§6.1, Q9). |
| PM-Q5 since-start set-aside and real | Yes, same formulas over the held period (§9.2). |
| PM-Q6 pension type; rental | Pension = "other", share asked, no setup question. Rental property = "other" with intent rental; share still asked, no default (§5, AC-7). |
| PM-Q7 lunar/solar Y | Matched pair: lunar 2.5 % / 354.367, solar 2.577 % / 365 (§9.4, AC-9). |
| PM-Q8 price × quantity | Yes, as input help; stores the total (§5 Quantity). |
