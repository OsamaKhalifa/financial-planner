# Story — My Investments

**Status:** v1 draft · 2026-10-16 · PM hat · review loop 1 applied (owner decisions + consultant CHANGES_REQUESTED) · 2026-10-17: added Private equity type and expected vs actual (§5.5, §5.6, AC-46…AC-75, AC-58b; owner Q10–Q15; review loop 1 applied)
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
| **Asset type** — stock · fund/ETF · sukuk · gold · silver · cash deposit · crypto · private equity · other (real estate, pension, anything else) | * | Breakdown by asset class (UC-2); picks the zakat rule set (Part B); decides whether a market or grams are asked. Real estate and pension stay under "other" in v1 (Q8). **Private equity** = a stake in a business not listed on a market, e.g. money put into a friend's project (owner Q10, §5.5). **Pension is not a v1 type**: it is "other", its zakat share is asked per item with B7 as help, so no pension question at setup. |
| **Intent** — trading · long-term · personal use · rental | * where the Shariah file needs it (below); * for private equity (trading or long-term only) | Decides the zakatable base: trading vs long-term vs personal use (B2, B3, B5, B6). |
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
| private equity | trading (to sell) | 100 % of value, no method question (Shariah file P-1) |
| private equity | long-term (for its profit) | **asked**, per item, nothing pre-selected (P-1): known zakatable % (user enters it; IIFA Res 121 (3/13) §1) · zakat on profit received only → 0 % of value and r_z × each income payout, charged once (same math as dividends-only, §9.4), with the notice "Zakat: {r_z} of each profit payout you record, not of the project's value. Each payout is counted once." ({r_z} from the zakat year setting) · full value → 100 %. **No 25 % proxy.** Help text from P-1 item 6. If Q2 = yes (case C, §5.5): 100 % offered with the P-1 item 5 text, no method question. |
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
- A **sale** on date d lowers the value by that amount on d, unless the user records the value left. If that would go below 0, the user must enter the value left (≥ 0).
- Income received in hand = money out (kind: income). **Income does not change the recorded value** and never asks for a value left, whatever its size (Q12): "Value left" is offered only while the kind is sale; with kind income it is not offered and nothing typed in it before is saved (AC-78). Income kept inside the investment is not recorded; it shows up in the next value update.
- **Interest (to purify)** (Z-6, Quran 2:278–279):
  - **Held interest H** of an item on a date = interest kept inside the item − interest given away from inside the item, up to that date.
  - For return, gain and zakat, the item's value is **recorded value − H**. So interest never counts as return and never enters the zakat base.
  - Interest kept inside the item raises the recorded value by that amount on its date (unless a value update is recorded that day), and H by the same amount: no effect on return.
  - Interest paid out to the user: no effect on value or return.
  - Interest given away **from inside the item** lowers the recorded value and H by the same amount: no effect on return.
  - Interest given away **from interest paid out to me** changes neither the item's value nor H: no effect on return.
  - **To purify** total (per item and overall) = all interest recorded − all interest given away (from both places). Shown on its own, never netted against zakat.
- No lot tracking, unit prices or FIFO. Needed only for tax (BRD non-goal).

### 5.5 Private equity — **new type** (owner Q10)

Owner's case: Yasmin puts 100,000 EGP into a friend's project and gets profit every quarter at a fixed %.

| Field | For private equity |
|---|---|
| Market | absent (not listed). |
| Intent | required: **trading** (to sell) or **long-term** (for its profit). Personal use and rental are not offered. Why: the zakat share depends on it (Shariah file P-1). |
| Item unit | default: base currency. |
| Quantity | optional (e.g. "shares" in the project). |
| Zakat share | required; per §5.1 (Shariah file P-1). |
| Expected profit % + payout schedule; expected value growth % + value-check schedule | optional, as for every type (§5.6). |

- Existing "other" items are **not** moved to private equity by themselves: a silent change of type could change the zakat share.
- Profit received is recorded as **money out, kind income** (§5.3), as today (by hand, or by confirming a pending row, §5.6).
- **Two questions** (Shariah file P-2; "Not sure" allowed; the answers never block saving): **Q2** "If the project loses money, do you still get all your money back?" (no / yes / not sure) — required on **every** private equity item, because case C changes the zakat base even with no payouts (P-1 item 5); **Q1** "Is this % a share of the project's real profit, or a fixed % of the money you put in?" (share of profit / fixed % of my money / not sure) — required only when an expected profit % is set. The answers pick a **case** and one notice on the item, with a Source link, text exactly as in P-2 (with no % set, Q1 is not asked: Q2 = no → case **A**, since without a % case B cannot happen; Q2 = yes → **C**; Q2 = not sure → the **?** notice):
  - **A** share of profit + no → no notice; payouts count as return (P-4).
  - **B** fixed % + no → the P-2 case B notice; payouts count as return (P-4; **owner decision Q14**), and that line shows "source not yet verified" until the consultant's case B open item closes (P-4b). The item gets the stored tag **"Shariah risk"**, shown on the item (owner Q14).
  - **C** Q2 = yes (any Q1) → the P-2 case C notice; **every income payout on the item is "to purify"**: left out of gain and return, added to the "to purify" total, never netted against zakat (P-4, as Z-6). The user may give them away with the existing record "interest given away" (from interest paid out to me), shown here as **"Given away from payouts (to purify)"** with the help line "Money from these payouts that you gave to charity. Giving it away does not count as zakat." No new record kind. Capital coming back is a sale, not income. Zakat share: 100 % offered with the P-1 item 5 text, no method question.
  - **?** any "not sure" and Q2 ≠ yes → the P-2 "Ask your partner…" notice; payouts count as return (P-2, P-4). No tag.
  - Changing Q1/Q2 later re-applies the case, the notice and the tag to **all** past payouts (P-4).
- For §5.6, case C payouts still count as **received** against the expected payouts: they are what came in.
- **Note for UC-2 (dashboard, next feature):** a risk view per asset type that uses the stored "Shariah risk" tag. Not in this story (owner Q15).

### 5.6 Expected vs actual — **any type, optional per item** (owner Q11, Q13)

The user knows what was agreed (a % a year, paid every quarter) or what they planned (the fund grows 12 % a year). Today the app shows only what happened. Pain: a payout that never came, or a value nobody checked, goes unnoticed, and recording each one is a chore. This section puts a **pending row** on each schedule date, filled with the expected amount, so recording the actual is one tap. **In-app only**: no notification, no background work (BRD: no notifications in v1).

**Two separate plans, each optional:**

| Plan | Fields | Hidden for |
|---|---|---|
| **Expected income** | **payout schedule** (monthly · quarterly · every 6 months · yearly); optional **expected profit %** (> 0) — needs a schedule | gold, silver, crypto (they pay nothing in hand) |
| **Expected value** | **value-check schedule** (same choices); optional **expected value growth %** (> −100 %; 0 and negative allowed) — needs a schedule | gold, silver (their value moves with the shared metal rate; rate staleness is §9.3) |

Why two schedules, not one: dividends quarterly but a value check monthly is common. One shared schedule would either ask for values too rarely or create payout rows that are not due. Why a schedule may stand alone: a profit share with no fixed % still comes at a fixed cadence, and a value-check row is useful with no growth target (the user types the value).

**Words** (Shariah file P-3): field labels "Expected profit (your estimate, % per year)" and "Expected value growth (your estimate, % per year)", each with "An estimate, not a promise. Not used for zakat or return." Never "interest", "guaranteed", "promised", "fixed return" or "yield" for these figures. A payout not recorded reads "No payout recorded for {period}. Expected around {date}." ({period} = the day after the previous payout date, to d_k; {date} = d_k), never "late", "missed" or "default"; on private equity add "In a partnership, no profit means no payout." A value below the plan reads "Value is below your estimate."

**Per type** (P-3 table): a cash deposit with a payout schedule must answer "Islamic account (profit share) or conventional account (interest)?" before it can be saved (architect Q-E3); conventional shows "This is interest. Record it as money out 'interest (to purify)', not as income." Private equity asks Q1/Q2 (§5.5). Stock, fund/ETF, sukuk, other: no notice. The P-3 notices for gold, silver and crypto are not used: those types have no expected profit field.

**Conventional cash deposit** (P-4b): its payout rows are labelled **"Expected interest (to purify)"**; the check mark records **interest (to purify), paid out to me**, not income; an interest record (not income) resolves the row. This label and the P-3 notice above are the only allowed uses of the word "interest" for expected figures.

**Dates.** Payout dates d_k and check dates c_k = start date + k × m months (m = 1, 3, 6, 12), k = 1, 2, … Always counted from the start date (no drift). If the day does not exist in that month, the last day of the month is used. Why start + one period: it matches the owner's case with no extra field; a deal paid a few days off still matches (window below).

**Expected payout** `P_k = round2( C(d_(k−1)) × p × m / 12 )`, d_0 = start date.
- p = expected profit %, **per year, of the money in** (not of the value). Why: an agreement is quoted "20 % a year on your money"; per year keeps one number across schedules. When saved, the app shows the amount per payout ("5,000.00 EGP every 3 months"), so a user who meant "% per payout" sees the mistake.
- **C(date)** = total money in − total money out of kind **sale**, dated on or before that date, in item unit, not below 0. Income does not lower C. Money in another unit is converted at the rate on its own date (§6.1). Missing rate → no expected amounts for the item, and the user is told which pair is missing.
- Money in or out counts from the **next** payout period. Why: no day weighting; the user corrects the amount when confirming.
- Rounded to 2 decimals.

**Expected value** `V_exp(t) = round2( max(0, Σ over money in (+) and sales (−) dated on or before t of amount × (1 + g)^((t − date) / 365)) )`. g = expected value growth % per year. Only actual records count; interest records are not flows.
- Why compound by days/365: same base as the annualised return (§9.2); an item that grows exactly at g with no flows shows annualised return = g.
- Why sales only: income does not change the recorded value (§5.4, Q12), so it does not change the plan either.
- V_exp never uses the user's own value updates, so confirming one row never changes another row's amount.

**Pending rows** (owner Q13).
- One row per schedule date on or before today: a **payout row** (amount P_k, or empty without a %) and a **value row** (amount V_exp(c_k), or empty without a growth %). Rows are created **only when the app opens or the item is viewed**, never in the background. A pending amount follows the current plan until the row is resolved.
- **Pending is not actual.** A pending row never feeds gain, return, the zakat set-aside, real return, purchasing power, staleness (§9.3), or any total.
- The user resolves a row in one of three ways:
  - **Check mark (one tap, no form)** — "Received this amount" on a payout row, "Value is as expected" on a value row (AC-76): it becomes actual at the shown amount, dated on the schedule date — a payout row becomes money out, kind income (conventional deposit: interest, above); a value row becomes a value update. A row with no amount has **"Add amount"** instead: the user types the amount, and the row becomes actual on its date.
  - **Edit, then save:** actual with the amount and date the user typed. The date may move at most **7 days** before or after the row date (architect Q-E2), so it still matches the row. A value may be below the expected value or below the money in.
  - **Skip:** a payout row shows "No payout recorded for {period}. Expected around {date}."; a value row records nothing.
- **"Confirm all as expected"** on the item, with the line "Confirm only money that really came in." (P-4b) when the item has a pending payout row, and the line "Confirm only if the value is still about this." when it has a pending value row (both lines when it has both; AC-76): every pending row that has an amount becomes actual at its amount and date, in one action.
- **Undo** is offered right after a check mark, "Confirm all as expected" or a skip; it removes the records that action made and puts the rows back to pending.
- **Row labels** (P-4b): a pending payout row reads "Expected payout (not received yet)" (private equity case C: "Expected payout (to purify when received)"; conventional deposit: "Expected interest (to purify)"). A pending value row reads "Expected value (check it)": it is a value to check, not money to receive, so no money-received wording appears on it. Never "profit due" or "owed".
- **No duplicates:** an actual record entered by hand (income for a payout row, value update for a value row) dated within **7 days** before or after the schedule date resolves that row with its own amount (oldest row first; one record resolves one row). Interest records never resolve a payout row, except on a conventional deposit, where only they do.
- A payout row still pending from d_k + 8 days also shows the "No payout recorded…" line. Why 7 days: a friend pays a few days off; no setting (no evidence one is needed).
- Home shows a **"N to confirm"** pill on each open item that has pending rows, N = that item's pending rows. No total across items.

**Shown per item** (expected vs actual):
- each row: date, expected amount, actual amount, state (pending · received · skipped; value rows: pending · recorded · skipped);
- payouts since start: **expected so far** = Σ P_k with d_k ≤ today (pending and skipped included); **received** = all actual income; **difference** = received − expected so far;
- payouts in a month or year view: expected = Σ P_k with d_k inside the period; received = income dated inside the period;
- at each actual value update: actual (net of held interest H), V_exp, difference in amount and in % of V_exp.
- **Charts, item screen only** (owner Q13), one at a time with a **Payouts | Value** switch (only the chart(s) the item has a plan for; no switch with one): value — expected line V_exp(t) and actual line through actual value updates only; income — cumulative expected payouts and cumulative actual income. Actual lines use actual records only; pending rows are hollow points at their expected amount.

**Edits.** Changing the %, a schedule or the start date recomputes every date and amount from the start. Actual records stay as they are; pending rows and skips are rebuilt for the new dates. No history of terms in v1.
- **Start date** can be changed when editing an item (owner feedback 2026-10-23). The first money in (and, for gold/silver, the start value update) moves with it to the new date. The new date may not be in the future and may not be after the date of any other record of the item; the error names the earliest such record date. Why: a record before the start would be money in or out before the item existed (AC-77).

**Closed item** (full sale, §5.3): no row after the closing date. Rows on or before it can still be resolved; the item is not in the list count.

**What this does not change:** return, gain, zakat set-aside, real return and purchasing power (§9) use actual records only and never an expected figure. No expected real return and no expected after-zakat figure (they would repeat §9.5–9.6 on made-up numbers). **No portfolio totals** of expected figures: items with and without a plan would mix.

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
`Z_div_item = r_z × (sum of money out of kind income dated inside the period)` — only for items on the dividends-only method (s = 0), and for private equity on "zakat on profit received only" (Shariah file P-1). **No T/Y factor**: each dividend is charged once, when received (consultant answer (a), IIFA Res 28 (3/4) §3). Converted to base at the rate on **each dividend's date** (not at E), because each dividend is charged on its own date.
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

**Private equity (§5.5)**

- **AC-46** Given a new private equity item, Then no market is asked, intent offers only trading and long-term, quantity is optional, and the item unit defaults to the base currency; When saved without intent, Then it is rejected and intent is named. Given an existing "other" item, Then after the update it is still "other" with the same zakat share.
- **AC-47** Given a new private equity item with intent "trading", Then the zakat share is 100 % with no method question. Given intent "long-term", Then the user must pick one of: known zakatable %, zakat on profit received only, full value — nothing pre-selected, no 25 % option, saving without a pick is rejected (P-1). Given "Friend's project" (below) on "profit received only" with income 5,000 on 2026-04-20, 2026-07-14 and 2026-10-15, When viewing year 2026 (so far) on 2026-10-17, Then the set-aside on its value is 0 and its set-aside = 0.025 × 15,000 = **375.00** (no T/Y factor), and the item shows "Zakat: 2.5 % of each profit payout you record, not of the project's value. Each payout is counted once." (lunar setting).

**Expected vs actual (§5.6)** — "Friend's project" below = private equity, long-term, EGP, start **2026-01-15**, first money in **100,000**, expected profit **20 %**, payout schedule **quarterly**.

- **AC-48** Given a gold, silver or crypto item, Then no payout schedule or expected profit % is asked; Given gold or silver, Then no value-check schedule or growth % is asked. Given an expected profit % without a payout schedule, or a growth % without a value-check schedule, or expected profit % = 0, or growth % = −100 %, When saving, Then it is rejected. Given a fund, start 2026-01-01, 10,000, growth **−10 %**, Then it saves and V_exp on 2027-01-01 = **9,000.00**. Given a stock with none of the four fields, Then it saves and has no expected figure and no pending row.
- **AC-49** Given "Friend's project", When saved, Then it shows "5,000.00 EGP every 3 months" (100,000 × 20 % × 3/12) and payout dates **2026-04-15, 2026-07-15, 2026-10-15, 2027-01-15**. Given a fund with 10,000, 10 %, monthly, Then each payout = **83.33**.
- **AC-50** Given start 2026-01-31 and a monthly schedule, Then the dates are **2026-02-28, 2026-03-31, 2026-04-30**. Given start 2024-02-29 and yearly, Then **2025-02-28, 2026-02-28, 2027-02-28, 2028-02-29**.
- **AC-51** Given "Friend's project" with no income recorded and the app not opened since 2026-01-15, Then no row is stored before the app opens; When the app is opened on 2026-10-17, Then three pending payout rows exist (2026-04-15, 2026-07-15, 2026-10-15), each **5,000.00**; the April and July rows show "No payout recorded for … Expected around …" and the October row does not (it would from 2026-10-23); since start: expected so far **15,000.00**, received **0.00**, difference **−15,000.00**; each row reads "Expected payout (not received yet)"; Home shows "3 to confirm".
- **AC-52** Given AC-51 on 2026-10-17, When the user taps "Received this amount" on the April row, Then income 5,000.00 dated 2026-04-15 is recorded with no other input; When the user edits the July row to 4,000 and saves, Then income 4,000.00 dated 2026-07-15; When the user skips the October row, Then it shows "No payout recorded for 2026-07-16 – 2026-10-15. Expected around 2026-10-15. In a partnership, no profit means no payout." Then since start: expected so far **15,000.00**, received **9,000.00**, difference **−6,000.00**; year 2026: **15,000.00 / 9,000.00** (expected / received); July **5,000.00 / 4,000.00**; October **5,000.00 / 0.00**; the item has no pending row.
- **AC-53** Given AC-51 on 2026-10-17, Then "Confirm all as expected" shows the line "Confirm only money that really came in."; When the user picks it once, Then three income records of 5,000.00 exist, dated 2026-04-15, 2026-07-15 and 2026-10-15; received **15,000.00**, difference **0.00**, and no pending row is left.
- **AC-54** Given "Friend's project" with income entered by hand: 5,000 on 2026-04-20 and **10,000** on 2026-07-14, When the app is opened on 2026-10-17, Then the April row is received 5,000.00, the July row is received 10,000.00, only the October row is pending, and no extra income record is created; expected so far **15,000.00**, received **15,000.00**, difference **0.00**. Given also income 2,000 on 2026-05-30, Then no row takes it, received = **17,000.00**, difference **+2,000.00**.
- **AC-55** Given "Friend's project" with money in 20,000 on 2026-08-01 and a sale of 50,000 on 2026-11-01, Then the payouts are 2026-10-15 = **5,000.00**, 2027-01-15 = **6,000.00** (120,000 × 5 %), 2027-04-15 = **3,500.00** (70,000 × 5 %).
- **AC-56** Given AC-51 (three pending rows), When the user records a full sale of 100,000 on 2026-12-01 with value left 0, Then the item is closed; When it is viewed on 2027-02-01, Then no 2027-01-15 row exists, the three rows can still be confirmed, and Home's "to confirm" count does not include them.
- **AC-57** Given a payout schedule monthly with no %, start 2026-01-31, and income entered by hand 1,200 on 2026-03-05 and 900 on 2026-04-02, When viewed on 2026-05-07, Then the 2026-02-28 row is received 1,200.00, the 2026-03-31 row is received 900.00, the 2026-04-30 row is pending with no amount and no "No payout recorded" line; its check mark asks for the amount; on 2026-05-10, Then that row shows the "No payout recorded" line; received since start = **2,100.00**; no expected amount is shown.
- **AC-58** Given a cash deposit (Islamic account), start 2026-01-01, 10,000, expected profit 10 %, monthly, and an interest record of 83.33 "paid out to me" on 2026-02-01 and no income, When viewed on 2026-02-09, Then the 2026-02-01 row (83.33) is still pending and shows the "No payout recorded" line (interest does not resolve it); received = **0.00**.
- **AC-58b** Given the AC-58 deposit marked **conventional**, Then the 2026-02-01 row reads "Expected interest (to purify)" with **83.33**; When the user taps "Received this amount", Then an interest record 83.33 "paid out to me" dated 2026-02-01 is stored and no income; to purify = **83.33**; the value stays **10,000.00** and the return for February = **0.00 %**. Given instead an interest record 83.33 paid out to me entered by hand on 2026-02-03, Then it resolves the row; Given an income record on 2026-02-03, Then the row stays pending.
- **AC-59** Given AC-51 after the April row was confirmed (5,000.00), When the user changes the expected profit to 24 %, Then the July and October pending rows show **6,000.00**, the April income stays **5,000.00**, expected so far = **18,000.00**, received = **5,000.00**.
- **AC-60** Given a fund, start 2026-01-01, 10,000, growth 12 %, no other flows, Then V_exp on 2027-01-01 = **11,200.00**. Given instead money in 2,000 on 2026-04-01 and a value update 12,400 on 2026-07-01, Then at that update V_exp = 10,000 × 1.12^(181/365) + 2,000 × 1.12^(91/365) = **12,635.39**, difference **−235.39 (−1.86 %)**, "Value is below your estimate."; Given then a sale of 3,000 on 2026-08-15 and a value update 10,100 on 2026-09-28, Then V_exp = **9,948.16** (… − 3,000 × 1.12^(44/365)), difference **+151.84 (+1.53 %)**.
- **AC-61** Given a fund, start 2026-01-01, 10,000, growth 12 %, value check monthly, no other flows, When the app is first opened on 2026-03-05, Then two pending value rows exist: 2026-02-01 = **10,096.72** and 2026-03-01 = **10,184.88**; When the user taps the check mark on February, Then a value update 10,096.72 dated 2026-02-01 is recorded and the March row still shows 10,184.88; When the user edits March to 9,800 and saves, Then a value update 9,800.00 dated 2026-03-01 is recorded, difference **−384.88 (−3.78 %)**. Given instead a value update entered by hand on 2026-02-05, Then it resolves the February row and no second value update is created.
- **AC-62** Given AC-61 on 2026-03-05 before any row is resolved, Then the item's value chart has the expected line through V_exp, an actual line with the one point 10,000 on 2026-01-01, and hollow points at 10,096.72 (2026-02-01) and 10,184.88 (2026-03-01); after the two rows are resolved as in AC-61, Then the actual line has points 10,000, 10,096.72 and 9,800.00 and there is no hollow point. Given AC-52, Then the income chart shows cumulative expected 5,000 / 10,000 / 15,000 on the three payout dates and cumulative actual 5,000 / 9,000 on 2026-04-15 / 2026-07-15. No expected chart appears outside the item screen.
- **AC-63** Given AC-51 (three pending rows), Then gain, every return, the zakat set-aside, every real figure, the purchasing-power gap, every portfolio total and the "value not updated" marker equal those of the same item with no plan; removing the plan changes none of them; portfolio totals show no expected figure. Given any pending row, When the app is closed or in the background for any length of time, Then it creates no row, shows no notification and makes no network request.

**Shariah answers for expected profit (§5.5, §5.6)**

- **AC-64** Given any private equity item, even with no schedule and no %, Then Q2 must be answered ("Not sure" allowed) or saving is rejected, and Q1 is not asked; Given Q2 = yes, Then the case C notice shows and 100 % is offered with the P-1 item 5 text. When an expected profit % is set, Then Q1 must be answered too; no answer itself blocks saving. With no % set: Q2 = no → no notice and no tag (case A); Q2 = not sure → the "Ask your partner…" text. With a % set: the notice shown is: share of profit + no → none; fixed % + no → the P-2 case B text; Q2 = yes → the case C text; any "not sure" with Q2 ≠ yes → the "Ask your partner…" text; each with a Source link.
- **AC-65** Given "Friend's project" with income 5,000 on 2026-04-15 and 5,000 on 2026-07-15 and no value update (value stays 100,000, §5.4), When Q1 = share of profit and Q2 = no (case A), Then since start gain = **10,000.00**, simple ROI = **10.00 %**, to purify = **0.00**; When the user changes Q2 to yes (case C), Then gain = **0.00**, simple ROI = **0.00 %**, to purify = **10,000.00**, the April and July rows still show "received", and the zakat share offered is 100 % with the P-1 item 5 text.
- **AC-66** Given AC-65 with Q1 = fixed % and Q2 = no (case B), Then gain = **10,000.00** (payouts are return) and that line shows "source not yet verified", the case B notice shows, and the item carries the tag **"Shariah risk"**, still there after the app is closed and reopened; When Q1 is changed to share of profit, Then the tag is gone. Given Q1 = not sure and Q2 = no, or case C, Then no tag.
- **AC-67** Given a cash deposit with a payout schedule, Then the user is asked "Islamic account (profit share) or conventional account (interest)?"; conventional → the P-3 "This is interest…" notice. Given a stock, fund/ETF, sukuk or other item with an expected profit %, Then no such notice. Given any expected figure, Then its label and help line are the P-3 texts, and the words "interest", "guaranteed", "promised", "fixed return", "yield", "late", "missed" and "default" do not appear in it — except the two allowed uses of "interest" on a conventional deposit: the P-3 notice and the row label "Expected interest (to purify)" (P-4b).
- **AC-68** Given "Friend's project" (value 100,000) and income 5,000 on 2026-04-15, Then the value stays **100,000.00** with no value update; since start gain = **5,000.00**, simple ROI = **5.00 %**. When the user records income 150,000 on 2026-05-01, Then it saves without asking for a value left and the value stays **100,000.00**. When the user records a sale of 30,000 on 2026-06-01, Then the value = **70,000.00**. Given AC-60's fund plus income 500 on 2026-05-01, Then V_exp on 2026-07-01 is still **12,635.39**.
- **AC-69** Given the AC-51 April row (2026-04-15), When the user edits its date to 2026-04-22 or 2026-04-08, Then it saves; to 2026-04-23 or 2026-04-07, Then it is rejected.
- **AC-70** Given a cash deposit with a payout schedule and no Islamic/conventional answer, When saving, Then it is rejected and the question is named. Given a cash deposit with no payout schedule, Then the question is not asked.
- **AC-71** Given AC-65 in case C (to purify **10,000.00**), When the user records "Given away from payouts (to purify)" 4,000 on 2026-08-01, Then it shows the help line "Money from these payouts that you gave to charity. Giving it away does not count as zakat.", it is stored as "interest given away" from interest paid out to me, to purify = **6,000.00**, gain stays **0.00**, and the zakat set-aside is unchanged.
- **AC-72** Given AC-51 on 2026-10-17, When the user taps "Received this amount" on April and then Undo, Then no income record exists, the April row is pending at 5,000.00, received = **0.00**, Home shows "3 to confirm"; When the user picks "Confirm all as expected" and then Undo, Then no income record exists and three rows are pending; When the user skips October and then Undo, Then October is pending again.
- **AC-73** Given AC-57 on 2026-05-10, Then the 2026-04-30 row offers "Add amount" and no "Received this amount"; When the user adds 950, Then income 950.00 dated 2026-04-30 is stored, received since start = **3,050.00**, and the row is received.
- **AC-74** Given an item with both a payout plan and a value plan, Then its screen shows one chart at a time and the user switches between Payouts and Value; Given an item with only a payout plan, Then only the payouts chart shows and there is no switch.
- **AC-75** Given on 2026-10-17 "Friend's project" as in AC-51 (3 pending rows) and a fund, start **2026-08-17**, 10,000, growth 12 %, value check monthly, no value update (pending rows 2026-09-17 and 2026-10-17), When Home is viewed, Then "Friend's project" shows "**3** to confirm", the fund shows "**2** to confirm", and no total is shown; after "Confirm all as expected" on "Friend's project", Then it shows no pill and the fund still shows "**2** to confirm".

**Owner feedback (2026-10-23)**

- **AC-76** Given "شقة مدينتي" = other, personal use, EGP, start **2026-01-01**, first money in **4,913,500**, expected value growth **3 %**, value check **monthly**, no payout schedule, no other record, When viewed on 2026-02-05, Then one pending row exists, dated 2026-02-01, labelled "Expected value (check it)", amount V_exp = 4,913,500 × 1.03^(31/365) = **4,925,850.71**; the words "Received this amount", "Expected payout", "received" and "Confirm only money that really came in." do not appear on the item; "Confirm all as expected" shows the line "Confirm only if the value is still about this."; the row's check mark reads "Value is as expected", and tapping it records a value update 4,925,850.71 dated 2026-02-01 and no money out. Given an item with both a payout plan and a value plan, Then the line "Confirm only money that really came in." shows only while it has a pending payout row, and "Confirm only if the value is still about this." only while it has a pending value row (both when it has both); payout rows keep the AC-51 / AC-52 wording.
- **AC-77** Given "Friend's project" with no record other than its first money in, When on 2026-10-17 the user changes the start date from 2026-01-15 to **2026-02-10** and saves, Then the first money in 100,000 is dated 2026-02-10; the pending payout rows are exactly 2026-05-10 and 2026-08-10, each **5,000.00** (no row on 2026-04-15, 2026-07-15 or 2026-10-15; 2026-11-10 is not yet due); expected so far = **10,000.00**; Home shows "2 to confirm". When the user changes it to 2026-10-18, Then it is rejected (future date). Given instead income 5,000 on 2026-04-20 and 10,000 on 2026-07-14, When the user changes the start date to 2026-05-01, Then it is rejected and the error names **2026-04-20**; to 2026-04-20, Then it saves. Given a gold item started 2026-03-01, When its start date is changed to 2026-02-01, Then its first money in and its start value update (grams) are both dated 2026-02-01.
- **AC-78** Given "Friend's project" (value 100,000), When the user records money out with kind "Sale", Then "Value left" is offered; When the user types 60,000 in it, switches the kind to "Income received", enters 5,000 on 2026-04-15 and saves, Then "Value left" is not offered while "Income received" is selected, exactly one record is stored (income 5,000.00 dated 2026-04-15), no value update is recorded, and the value stays **100,000.00** (§5.4, Q12).
- **AC-79** Given base currency **USD**, a rate of **52 EGP per USD** on the view date, AC-76's "شقة مدينتي" with no value update, and "Madinty real estate" = other, rental, EGP, start 2026-01-15, first money in 1,000,000, expected profit **32 %**, payout schedule quarterly, value update 1,100,000 on 2026-10-15, no other flow, When Home is viewed, Then every row shows its asset type ("other" on both); "شقة مدينتي" shows **4,913,500.00 EGP** with **94,490.38 USD** under it in smaller text (4,913,500 ÷ 52) and since-start return **0.00 %**, and under it in smaller text "est. growth {pct}/yr" with {pct} = 3 % (no "est. payouts": it has no expected profit %); "Madinty real estate" shows **1,100,000.00 EGP** with **21,153.85 USD** under it, since-start return **10.00 %** (§9.2), and under it in smaller text "est. payouts {pct}/yr" with {pct} = 32 % (no "est. growth": it has no growth %). The return on a Home row is the item-unit return (§6.2), never the base-currency one (owner, 2026-10-23), **except gold and silver**, whose row shows the base-currency return: in grams the return is about 0 % after every buy, because a buy adds grams and value alike, so a gram figure misleads. Given a gold item, unit XAU-g, start 2026-01-01, first money in **5,000 USD** at **100 USD per pure gram** (50 pure g), no other record, and **110 USD per pure gram** on the view date, Then its gram return is 50 ÷ 50 − 1 = **0.00 %**, its USD return is (50 × 110) ÷ 5,000 − 1 = **10.00 %**, and the row shows **50.00 XAU-g**, **5,500.00 USD** under it, and return **10.00 %**, not 0.00 %. Given instead "Madinty real estate" with **50 EGP per USD** on 2026-01-15 and **55 EGP per USD** on 2026-10-15 and on the view date, Then its EGP return is 1,100,000 ÷ 1,000,000 − 1 = **10.00 %** and its USD return is (1,100,000 ÷ 55) ÷ (1,000,000 ÷ 50) − 1 = 20,000 ÷ 20,000 − 1 = **0.00 %**; the row shows **1,100,000.00 EGP**, **20,000.00 USD** under it, and return **10.00 %**, not 0.00 %. Given an item with both an expected profit % and an expected value growth %, Then both show on one line, "est. payouts {pct}/yr" then "est. growth {pct}/yr"; given an item with neither, Then no expected figure shows. Given a USD item (base USD), Then its value shows once. Why the growth % too (owner, 2026-10-23): the owner treats appreciation like profit, expected vs actual, and his own sheet has a "Yearly appreciation %" column. The words "est. payouts {pct}/yr" and "est. growth {pct}/yr" are the consultant's (layout and {pct} format: docs/product/ux/my-investments.md S2) and follow the P-3 words rule (AC-67); the figures are never added to any total (§5.6).

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
- Reminders to update values (BRD: no notifications in v1). Pending rows (§5.6) are created and shown only inside the app.
- Private equity: contract documents, partner lists, the business's own profit-sharing calculation, a history of changed terms (§5.6 recomputes from the start).
- Expected figures in portfolio totals, expected real or after-zakat figures, pro-rata (day-weighted) expected profit. Charts outside the item screen.
- A risk view per asset type using the "Shariah risk" tag — goes to UC-2, the dashboard (Q15). This story only stores and shows the tag.
- A Home "To confirm" filter, and a "Use Private equity" link under "other" (cut in review loop 1).
- Any advice on what to buy, sell or hold.

## 12. Shariah touchpoints

Answered by the consultant (Z-1…Z-7 in zakat-on-investments.md) and applied above. Still open on their side, to close before release:
- Pure vs gross weight for nisab — practice, primary source **[U]** (Z-4).
- AAOIFI SS 21 section number for purification **[U]** (Z-6).
- Named-scholar confirmation of "real return" display — owner may request (A6.2).

Private equity and expected vs actual (2026-10-17): answered in zakat-on-investments.md "Answers for Private equity (2026-10-17)" P-1…P-5 and applied in §5.1, §5.5, §5.6, §9.4 (AC-47, AC-58b, AC-64…AC-67, AC-71; P-3 / P-4b wording in AC-51…53, AC-60). P-1 item 7 replaces UX verdict item 4 for business stakes. Still open on the consultant's side:
- **Z-8** Case B ruling (fixed % of money, capital not guaranteed) has no primary source yet **[U]**; the "counts as return" line shows "source not yet verified". Owner decided (Q14): payouts count as return, with a "Shariah risk" tag.
- **Z-9** AAOIFI SS 12 / SS 13 section numbers, incl. periodic payouts as advances on account **[U]**.
- **Z-10** Pending-row wording: **closed** by P-4b (row labels, "Received this amount", the line under "Confirm all"; §5.6, AC-51…53, AC-58b).

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
| Q10 | Business stakes: own type? | **Decided (owner, 2026-10-17):** new type **"Private equity"**, e.g. money in a friend's project paid a fixed % on a fixed schedule (§5.5). |
| Q11 | Expected vs actual? | **Decided (owner, 2026-10-17):** for **every** type, optional per item: expected profit % + payout schedule vs income received, with a signal when a payout is late (worded per Shariah file P-3: "No payout recorded…"); expected value growth % + value-check schedule vs value updates, with a "value update due" signal (§5.6). Q13 replaced the signals with pending rows. |
| Q12 | Should money out of kind **income** lower the recorded value? | **Decided (2026-10-17, review loop 1; architect, consultant P-4b no objection):** no. Only sales lower the value; income never asks for a value left (§5.4, §5.6 V_exp, AC-68). Code change needed: today the value replay subtracts every money out. |
| Q13 | How does the user record actuals on the schedule? | **Decided (owner, 2026-10-17):** a **pending row** on each payout and value-check date, filled with the expected amount; never actual until confirmed (one-tap check mark, edit then save, or skip → "No payout recorded…"); "Confirm all as expected" per item; created only when the app opens or the item is viewed. Growth % and actual results may be negative. Item screen charts: expected line vs actual line (actual records only), pending points hollow (§5.6). |
| Q14 | Case B (fixed % of money, capital at risk)? | **Decided (owner, 2026-10-17):** payouts count as return; the item stores and shows the tag **"Shariah risk"**. Case C stays "to purify" (P-4); "not sure" follows P-2 (§5.5). |
| Q15 | Risk view per asset? | **Decided (owner, 2026-10-17):** goes to UC-2 (dashboard, next feature). Here: store and show the tag only. |

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

---

## Test map

Owner: QA. Every AC has a test. **D** = `test/features/investments/domain/acceptance_test.dart` (test named `AC-n …`, engine end to end). **R** = repository/data test. **S** = screen test in `test/features/investments/presentation/` (each runs in `en` and `ar`; test named `AC-n: …`). **G** = `test/golden_path_widget_test.dart` + `integration_test/`.

| AC | Proving tests |
|---|---|
| 1, 2 | D `AC-1`, `AC-2`; S `investment_form_screen_test` `AC-1` (×2), `AC-2` |
| 3 | D `AC-3`; R `drift_investments_repository_test` `AC-3: a third value update keeps all three` |
| 4 | D `AC-4`; R `AC-4: a closed item read back from storage…`; S `item_detail_screen_test` `AC-4` |
| 5 | D `AC-5`; S `investment_form_screen_test` `AC-5`, `item_detail_screen_test` `AC-5` |
| 6, 7 | D `AC-6`, `AC-7`; S `investment_form_screen_test` `AC-6`, `AC-7` (×2) |
| 8 | S `setup_screen_test` `AC-8`; S `investment_form_screen_test` `AC-8` (+ `computing figures with no zakat year…` and `jewellery with no ruling…` in the engine tests: no silent default) |
| 9 | D `AC-9` |
| 10, 11 | D `AC-10`, `AC-11` |
| 12, 13, 14 | D `AC-12`, `AC-13`, `AC-14`; G (April view 4.21 % / 30.69) |
| 15 | D `AC-15`; S `period_screen_test` `AC-15` |
| 16 | D `AC-16` |
| 17, 18 | D `AC-17`, `AC-18`; S `period_screen_test` `AC-17`, `AC-18` (switch + help text) |
| 19, 19b | D `AC-19`, `AC-19b`; S `home_screen_test` `AC-19`, `item_detail_screen_test` `AC-19`, `record_sheet_test` `AC-19` |
| 20 | D `AC-20` |
| 21 | D `AC-21`; S `home_screen_test` `AC-21`, `item_detail_screen_test` `AC-21`, `period_screen_test` `AC-21` |
| 22 | D `AC-22`; S `period_screen_test` `AC-22` |
| 23, 24 | D `AC-23`, `AC-24`; S `investment_form_screen_test` `AC-24` |
| 25 | S `update_all_screen_test` `AC-25`; `rate_refresher_test` `AC-25`; G (zero requests); the harness fails any screen test that makes a request it did not declare |
| 26, 27 | `rate_refresher_test` `AC-26`, `AC-27`; S `update_all_screen_test` `AC-27` |
| 28 | D `AC-28`; R `drift_assumptions_repository_test` `AC-28`; `rate_refresher_test` `AC-28`; S `assumptions_screen_test` `AC-28` |
| 29 | `rate_refresher_test` `AC-29`; S `update_all_screen_test` `AC-29` |
| 30 | `rate_refresher_test` `AC-30` |
| 31 | D `AC-31` |
| 32 | D `AC-32`; R `drift_assumptions_repository_test` `AC-32`; `shipped_inflation_loader_test` `AC-32`; S `inflation_series_screen_test` `AC-32/33`, `AC-32` |
| 33, 34 | D `AC-33`, `AC-34`; S `inflation_series_screen_test` `AC-32/33` |
| 35 | S `item_detail_screen_test` `AC-35`, `period_screen_test` `AC-35` |
| 36, 38 | D `AC-36`, `AC-38` |
| 37 | D `AC-37` (incl. since-start −3.85 %); S `investment_form_screen_test` `AC-37` |
| 39 | D `AC-39`; S `period_screen_test` `AC-39` |
| 40 | D `AC-40`; S `home_screen_test` (stale banner) |
| 41 | D `AC-41`; S `period_screen_test` `AC-41` |
| 42, 43, 44 | D `AC-42`, `AC-43`, `AC-44`; S `unit_picker_test` `AC-42`, `AC-43`, `AC-44` |
| 45 | D `AC-45`; S `period_screen_test` `AC-45` (×2: with and without a gold rate) |
| 46 | D `AC-46`; S `investment_form_screen_test` `AC-46`; R `migration_test` `AC-46 after the update, v1 data reads back the same…; "other" stays "other"` |
| 47 | D `AC-47` (375.00); `zakat_rules_test` `AC-47 private equity…`, `AC-47 every private-equity rule cites B6`; S `investment_form_screen_test` `AC-47`, `item_detail_screen_test` `AC-47` (notice text) |
| 48 | D `AC-48` (9,000.00); `investment_draft_test` `plan fields: hidden types, schedule needed, % limits (AC-48)`; `formulas_test` `AC-48/60 expectedValue…`; S `investment_form_screen_test` `AC-48` |
| 49 | D `AC-49`; `formulas_test` `AC-49 expectedPayout…`; S `investment_form_screen_test` `AC-49` (payout preview) |
| 50 | D `AC-50`; `core/dates_test` `AC-50 addMonths…` |
| 51 | D `AC-51`; R `drift_investments_repository_test` `AC-51: reading the plan writes no row`; S `item_detail_screen_test` `AC-51`, `home_screen_test` `AC-51, AC-75` |
| 52 | D `AC-52`; S `item_detail_screen_test` `AC-52, AC-72`, `period_screen_test` `AC-52` (July 5,000 / 4,000) |
| 53 | D `AC-53`; S `item_detail_screen_test` `AC-53, AC-72` |
| 54 | D `AC-54`; S `record_sheet_test` `AC-54` (hand income says it also records the payout) |
| 55 | D `AC-55` |
| 56 | D `AC-56`; S `item_detail_screen_test` `AC-56`, `home_screen_test` `AC-56: a closed item is not counted` |
| 57 | D `AC-57`; S `item_detail_screen_test` `AC-57, AC-73` |
| 58 | D `AC-58`; S `item_detail_screen_test` `AC-58` |
| 58b | D `AC-58b` (to purify 83.33, value 10,000.00, February 0.00 %); S `item_detail_screen_test` `AC-58b` |
| 59 | D `AC-59` |
| 60 | D `AC-60`; `formulas_test` `AC-48/60 expectedValue…`; S `item_detail_screen_test` `AC-61, AC-60` ("below your estimate") |
| 61 | D `AC-61`; S `item_detail_screen_test` `AC-61, AC-60` |
| 62 | D `AC-62`; `widgets/plan_chart_test` `AC-62` (×3); S `item_detail_screen_test` `AC-62, AC-74`, `period_screen_test` `AC-62: no expected figure in portfolio scope` |
| 63 | D `AC-63`; `architecture_test` `AC-63 actual figures never import the plan`, `AC-63 no background work in features…`; S `item_detail_screen_test` `AC-63`; the harness fails any undeclared request |
| 64 | D `AC-64`; `investment_test` `AC-64 private equity case table…`; `investment_draft_test` `Q1 is required only with a %… (AC-64, AC-70)`; S `investment_form_screen_test` `AC-64` |
| 65 | D `AC-65`; `zakat_rules_test` `AC-65 case C is 100 % as a debt…`; S `item_detail_screen_test` `AC-65, AC-71` |
| 66 | D `AC-66`; `investment_test` `AC-66 the Shariah risk tag…`; R `drift_investments_repository_test` (Q1/Q2 round trip); S `item_detail_screen_test` `AC-66` (×2) |
| 67 | `l10n/expected_words_test` `AC-67` (×2); S `investment_form_screen_test` `AC-67, AC-70`, `AC-67: a stock…` |
| 68 | D `AC-68`; S `record_sheet_test` `AC-68: income above the value does not ask for the value left` |
| 69 | D `AC-69` (hand records d ± 7 / ± 8); S `record_sheet_test` `AC-69` (×2: window bounds, date outside refused) |
| 70 | D `AC-70`; `investment_draft_test` `… (AC-64, AC-70)`; S `investment_form_screen_test` `AC-67, AC-70` |
| 71 | D `AC-71`; S `item_detail_screen_test` `AC-71`, `AC-65, AC-71` |
| 72 | D `AC-72` (skip only); S `item_detail_screen_test` `AC-52, AC-72`, `AC-53, AC-72` (Undo of ✓, Confirm all and skip) |
| 73 | D `AC-73`; S `item_detail_screen_test` `AC-57, AC-73` |
| 74 | S `item_detail_screen_test` `AC-62, AC-74`, `AC-74: with both plans…` |
| 75 | D `AC-75`; S `home_screen_test` `AC-51, AC-75` — both use a fund started 2026-08-17, not AC-61's 2026-01-01 (see thin spots) |

**Known thin spots (not blockers):** AC-9 is proven on the enum only (no test that the setup screen stores the matched pair). AC-12/13/14/16/20/36/38 are proven in the engine, not on screen. AC-25's unit test waits 100 ms of real time; the screen and golden-path tests carry the real guarantee. The D1 budget test (`drift_investments_repository_test`, 12k entries under 200 ms) uses a wall-clock `Stopwatch` and can flake on a slow CI host.

**Thin spots for AC-46…75 (QA, 2026-10-17):** AC-75 as written cannot hold: AC-61's fund (start 2026-01-01, monthly) has 9 pending rows on 2026-10-17, so Home would show 12, not 5; the tests use a fund started 2026-08-17 (PM to fix the AC). AC-75's Home test writes the three incomes directly instead of using "Confirm all". AC-72's Undo leaves "3 to confirm" checked on the item screen, not on Home. AC-51/52 screens check the difference amount but not its minus sign; AC-52's skip line period text is checked in the engine only. AC-69's "04-07 rejected" is covered only by the date field's bounds. AC-63 compares the real figure after set-aside, not before it, and no portfolio real or purchasing-power total. AC-47 checks the total set-aside 375.00, not that the value part is 0.
