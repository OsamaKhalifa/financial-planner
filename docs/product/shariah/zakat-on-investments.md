# Zakat on investments ("My Investments" page)

**Owner:** islamic-consultant · **Status:** v0 draft · 2026-10-16
**Feeds:** "My Investments" story (ROI before/after zakat and inflation), UC-1, UC-3.

## How to read this file

- Every rule has a **Reference**. Tag meaning:
  - **[V]** — verified in this pass against the primary page (Quran text, sunnah.com, iifa-aifi.org, amjaonline.org).
  - **[S]** — verified only through a secondary source (named). Good enough to show the user, not good enough to quote word for word.
  - **[U]** — not verified in this pass. The app may show it only with the label "source not yet verified". Must be checked before release.
- **AAOIFI Shariah Standard No. 35 (Zakah)** is behind a paywall. I could not read its text. All section numbers for SS 35 are **[U]**. Where I cite SS 35, I cite it by title only.
- Where scholars disagree, the app shows the views and **the user picks**. The app never picks for them.
- Arabic terms: *hawl* = one lunar year of ownership; *nisab* = minimum wealth that makes zakat due; *thaman* = money / medium of value; *urud al-tijara* = trade goods.

---

## Part A — Cross-cutting rules

### A1. Rate: 2.5% (lunar year)

- **Rule:** Zakat on money, gold, silver, trade goods and their income is one-fortieth (2.5%) of the zakatable base, once per lunar year.
- **Reference:**
  - Abu Dawud 1573 (Ali ibn Abi Talib): on 200 dirhams, 5 dirhams; on 20 dinars, half a dinar. That is 1/40. Graded sahih by al-Albani. **[V]** (sunnah.com/abudawud:1573)
  - IIFA Resolution 2 (2/2), 1985: "one-fourth of the one-tenth (2.5%)" on rental yield. **[V]** (iifa-aifi.org/en/32196.html)
- **App:** `zakat = base × 0.025` when the user's year type is lunar.

### A2. Solar year option: 2.577%

- **Rule:** If the user keeps their zakat year on the solar (Gregorian) calendar, some bodies adjust the rate to 2.577% to cover the ~11 extra days. Others reject any change to the 1/40 rate. **Disagreement — user picks.**
- **Reference:**
  - AAOIFI SS 35 allows a solar year at 2.577% (2.5775% in a leap year). **[S]** via National Zakat Foundation UK (nzf.org.uk/knowledge/can-a-solar-year-be-used-for-zakat-calculation) and Islamic Markets summary. Section number **[U]**.
  - Opposing view: Mufti Online (South Africa, Hanafi) — the rate is fixed by text at 1/40; no one may adjust it. Pay on the lunar date. **[S]** (islamqa.org/hanafi/muftionline/104249)
- **App:** Setting "Zakat year: Lunar (2.5%) / Solar (2.577%, AAOIFI)". Default **Lunar**. Show both references on the setting.

### A3. Nisab: gold 85 g or silver 595 g

- **Rule:** Zakat is due only if total zakatable wealth on the zakat date is at or above nisab. Nisab for gold is 20 dinars (≈ 85 g); for silver 200 dirhams / 5 awaq (≈ 595 g). For cash and mixed wealth, scholars differ on which one to use. **User picks.**
- **Reference:**
  - Silver: "No zakat on less than five awaq (of silver)" — Bukhari 1447, Muslim 979 (Abu Sa'id al-Khudri). 5 awaq = 200 dirhams. **[S]** (hadithunlocked.com/bukhari:1405 shows the chains and gloss)
  - Gold and silver together: Abu Dawud 1573 — nothing on gold until 20 dinars; on 200 dirhams, 5 dirhams. **[V]**
  - Gram figures (85 g, 595 g): standard modern conversion (dinar ≈ 4.25 g, dirham ≈ 2.975 g). **[S]** (seekersguidance.org, Shaykh Badhib; Qatar Charity fatwa 12220). Some older works give 612 g for silver (en.tohed.com commentary on Nasa'i 2488) — this is a known variance in the dirham weight.
  - Which to use for cash: silver view = more benefit to the poor; gold view = closer to today's value of the original nisab; Yusuf al-Qaradawi (*Fiqh al-Zakah*) is reported to prefer gold. **[S]** (seekersguidance.org "Should the minimum zakatable amount be measured by the gold or silver standards?"). Qaradawi's exact text **[U]**.
- **App:**
  - Setting "Nisab standard: Gold 85 g / Silver 595 g". No default chosen silently — ask at onboarding of zakat, show both with references.
  - `nisab_value = grams × price_per_gram(base currency, zakat date)`. Price per gram is user-entered or from the price source (BRD open decision 1).
  - Compare **total** zakatable base (all items, all currencies, after conversion — see A9) to nisab. Not item by item.

### A4. Hawl: one lunar year, measured on the total, not per item

- **Rule (mainstream practice):** The user has one zakat date. On that date, if wealth has been at or above nisab for a lunar year, zakat is due on **all** zakatable wealth held that day — including money/stock added during the year. Each item does **not** need its own year.
- **Reference:**
  - "No zakat is payable on property till a year passes on it" — Abu Dawud 1573. **[V]**
  - Adding new wealth of the same kind to the existing hawl (*al-mal al-mustafad*): Hanafi school (e.g. al-Marghinani, *al-Hidayah*, Kitab al-Zakah). **[U]**
  - Gold bought with saved money takes the hawl of that money: Jordan General Iftaa Department. **[S]** (islamqa.org/shafii/darul-iftaa-jordan/226851)
  - IIFA Res 28 (3/4) §4: sale proceeds during the year are added to wealth and zakat paid on the total at year end. **[V]** (iifa-aifi.org/en/32294.html)
- **Other view:** Shafi'i and Hanbali schools give new wealth that is not profit/offspring of existing wealth its own hawl from the day it was acquired. **[U]** Practically, this view is hard to track by hand; many zakat bodies advise the single-date method as easier and safer (the poor get more, not less).
- **App:** One zakat date per user. Base = value of all zakatable items on that date. Setting "Hawl method: single zakat date (Hanafi, default) / per-acquisition hawl (Shafi'i/Hanbali)" — **v1 implements only the single date**; the second is listed under "What we do not handle".
- **Nisab during the year:** Hanafis: nisab must exist at start and end of the year; dipping below during the year does not break it. Others: must stay above all year. **[U]** v1 checks the zakat date only and tells the user this.

### A5. Deductible liabilities

- **Rule:** Many scholars allow debts that are due now (or due within the coming year) to be deducted from zakatable wealth. Views differ on long-term debts (e.g. a mortgage): deduct only the instalments due in the next 12 months, deduct all, or deduct none. **User picks.**
- **Reference:**
  - AAOIFI SS 35 lists which liabilities may be deducted from the zakat base. **[S]** scope only (islamicmarkets.com summary); details **[U]**.
  - Shafi'i view that debt does not reduce zakat (al-Nawawi, *al-Majmu'*) **[U]**.
- **App:** v1: one optional field "Debts I must pay within 12 months". Deduction is on by default; user may turn off. Full treatment waits for UC-5 (debts).

### A6. Inflation-adjusted ("real") values

**Position — three separate questions:**

1. **Is the zakat base inflation-adjusted?** **No.** Zakat is 2.5% of what the wealth is worth **on the zakat date** (market value, or cash balance as it stands). IIFA Res 28 (3/4) §3 says trading shares pay 2.5% of **market value**; Res 2 (2/2) and Res 1 (1/2) work on actual amounts held or received. **[V]** I found **no recognized view** that computes zakat on an inflation-adjusted figure. The app must never do that and must never suggest it.

2. **May the app show the user an inflation-adjusted return of their own wealth, for planning?** **No Shariah rule found that forbids it, and none is engaged.** A "real value" chart is information the owner sees about their own property — it is not a contract, a debt, or a price. Riba applies to exchanges and debts (Quran 2:275–279; Muslim 1587). **[V for Quran; S for Muslim 1587]**. The IIFA itself treats loss of purchasing power as a real thing worth protecting against: Res 75 (6/8), 1993, allows salaries to be indexed to the cost of living, and Res 115 (9/12), 2000, allows people to hedge against expected inflation by denominating in gold, a basket, or a stronger currency. **[V for 75 (6/8) — iifa-aifi.org/en/32475.html; S for 115 (9/12)]**
   - **Status:** this is my reading, not a fatwa on "real-return charts". **Flag for the owner:** if he wants a named-scholar confirmation, that is a follow-up.

3. **What is NOT allowed (must never be built):** linking a **debt** (money owed to or by the user) to an inflation index or price level, so the debtor repays more than the nominal amount.
   - **Reference:** IIFA Res 42 (4/5), Kuwait, 10–15 Dec 1988: a debt is settled in the same currency, and fixed debts **may not be tied to the price level**. **[V]** (iifa-aifi.org/en/32336.html). Reaffirmed by Res 115 (9/12) (2000) and Res 231 (2/24) (2019, which allows only an *after-the-fact* settlement in hyperinflation, never a pre-agreed index clause). **[S]**
   - **App:** when UC-5 debts come, the "real value" view must **not** appear on debts, and no "inflation-adjusted amount owed" may be computed or shown.

- **App wording rule:** label the real figures "Purchasing power (for planning only — zakat is always on today's actual value)". Keep "after zakat" and "after inflation" as two separate steps; never fold inflation into the zakat base.

### A7. Currency conversion (multi-currency holdings)

- **Rule:**
  1. Paper money and bank balances in any currency take the rulings of gold and silver for zakat. All currencies are zakatable cash.
  2. Convert every holding to the base currency at the exchange rate **on the zakat due date**, add them up, then compare the total to nisab (nisab also priced in base currency on that date).
  3. Paying zakat in a different currency than the asset is permitted (paying the equivalent value of cash zakat).
- **Reference:**
  - IIFA Res 21 (9/3), Amman, Oct 1986: paper currencies are money and "subject to the rulings … for gold and silver with regard to … Zakāh". **[V]** (iifa-aifi.org/en/32270.html)
  - Rate on the due date (anniversary): Darul Iftaa Mahmudiyyah (Zambia, Hanafi) — use the rate of the day zakat became due; a higher rate may be used voluntarily. **[S]** (islamqa.org/hanafi/daruliftaazambia/134900). No AAOIFI or IIFA text found on the exchange-rate date. **[U]**
  - Convert each currency and add: National Zakat Foundation UK (Mufti Faraz Adam). **[S]** (nzf.org.uk/knowledge/is-zakat-due-on-all-currencies)
  - Paying in another currency (paying value, *qimah*): Hanafi school allows paying zakat by value. **[U]** For cash-to-cash this is routine practice; no recognized body found that forbids it.
- **App:** `base_value = Σ (item_value_in_item_currency × fx_rate(item_currency→base, zakat_date))`. FX rate is user-editable. Show "converted at rate X on date D". The zakat result is shown in base currency; the user may pay in any currency.

### A8. Gold and silver as unit of value (owner question)

- **Status of gold and silver in fiqh:** gold and silver are *thaman* by nature — the original money of Shariah. Nisab is defined in their weight (A3), and the IIFA gives paper money their rulings (Res 21 (9/3), **[V]**). So measuring wealth in grams of gold is close to how Shariah itself measures nisab.
- **Recognized views on measuring wealth in gold:**
  - Nisab in gold weight — Abu Dawud 1573. **[V]**
  - Denominating amounts in gold to protect against inflation — IIFA Res 115 (9/12). **[S]**
  - I found **no view** that zakat itself is computed "in gold" for non-gold assets; zakat is on each asset's value on the due date, then converted. **Showing** a total in grams of gold is a display choice, not a Shariah rule. It is fine as long as the zakat calculation itself follows A1–A7.
- **Caution — riba al-fadl:** "Gold for gold, silver for silver … like for like, equal for equal, hand to hand; whoever adds or asks more has dealt in riba. If the kinds differ, sell as you wish, if it is hand to hand." — Muslim 1587 (Ubadah ibn al-Samit). **[S]** (sunnah.com/muslim:1587a; text via ihadis.com)
  - If the app ever models **buying gold with gold** or **exchanging gold against a gold-denominated balance**, the amounts must be equal in weight and same-session. Gold bought with money must be hand-to-hand (spot), not deferred. A "gold-denominated debt" (e.g. lend 10 g, repay 10 g) is allowed (Res 115 (9/12)), but lend 10 g, repay 11 g is riba.
  - Combining gold and silver to reach nisab: Hanafi and Maliki combine by value; Shafi'i (and one Hanbali narration) do not. **[S]** (islamweb.net/en/fatwa/81848 — secondary) **[U]** for primary. v1 combines by value (all assets together) and states this.
- **App:** a "show in grams of gold" toggle is acceptable. It must not change the zakat math. Any future gold-to-gold exchange feature needs a separate review by me.

### A9. What the app shows as "why"

Each item gets one status line + one reference link. Template:

> **Zakat: Yes, on 100% of market value.** You hold this to sell. Trade goods pay 2.5% of market value. — IIFA Res 28 (3/4) §3.

Statuses: `Zakatable (full value)`, `Zakatable (part: X%)`, `Zakatable on income only`, `Not zakatable`, `Depends on your choice` (opens the views). Every number on the screen (2.5%, 2.577%, 85 g, 595 g, 25%, 30%) links to the section in this file.

---

## Part B — Asset types

### B1. Cash and bank savings (incl. foreign currency)

- **Rule:** Full balance is zakatable.
- **Base:** balance on the zakat date, converted to base currency (A7).
- **Reference:** Quran 9:34–35 (hoarding gold and silver); Abu Dawud 1573 **[V]**; IIFA Res 21 (9/3) (paper money = gold/silver rulings) **[V]**.
- **Edge cases:**
  - Interest earned in a conventional account: it is not the owner's wealth; it must be given away (purification), and is not counted as wealth. **[U]** — belongs to the purification topic (BRD §8).
  - Fixed deposits with a break penalty: count the balance; scholars who follow the "access" logic of B7 deduct the penalty. **[U]**
- **Default:** 100%. User override: no.

### B2. Gold and silver

- **Bullion, coins, gold held as savings/investment:** zakatable on the **market value** (or weight × price) on the zakat date. **Reference:** Quran 9:34; Abu Dawud 1573 **[V]**.
- **Jewelry for personal use — disagreement, user picks:**
  - **Zakat due** (Hanafi school): Abu Dawud 1563 — the Prophet asked a woman whose daughter wore gold bracelets if she paid their zakat, and warned her when she said no. Graded hasan (al-Albani). **[V]** (sunnah.com/abudawud:1563)
  - **No zakat on permitted worn jewelry** (Maliki, Shafi'i, Hanbali): reports that Aisha did not pay zakat on the jewelry of the orphans in her care (Muwatta Malik, Kitab al-Zakah). **[U]**
  - All schools agree jewelry kept as savings/investment, or beyond normal use, is zakatable. **[U]**
- **Base for jewelry (if zakatable):** gold/silver content weight × spot price. Gemstones are not counted unless held for trade. **[U]**
- **Default:** bullion/coins 100%. Jewelry: follows user setting "Personal jewelry: zakatable / not zakatable". User override per item: yes (intent field).

### B3. Shares / stocks

**Intent decides the base.** User marks each holding.

| Intent | Base | Reference |
|---|---|---|
| **Trading** (bought to sell for gain) | **100% of market value** on zakat date + dividends held | IIFA Res 28 (3/4) §3, Res 121 (3/13) **[V]** |
| **Long-term** — company data known | Shareholder's share of the company's **zakatable assets** (cash, receivables, inventory) — or the exact zakat the company would owe per share | IIFA Res 28 (3/4) §3 "normal original way"; Res 121 (3/13) §1 **[V]**; AAOIFI SS 35 **[U]** sections |
| **Long-term** — no company data | **View 1: dividends only** (2.5% of dividends held at zakat date) | IIFA Res 28 (3/4) §3 (held for return, amount unknowable → zakat on dividends only, citing Res 2 (2/2)) **[V]** |
| | **View 2: 25% of market value as proxy for zakatable assets**, then 2.5% (= 0.625% of market value) | National Zakat Foundation UK, based on its muftis' study of FTSE 100 balance sheets **[S]** (nzf.org.uk/knowledge/shares-unit-trusts-and-equity-investments). **AMJA endorsement of 25%: NOT FOUND — do not attribute to AMJA.** |
| | **View 3: full market value as precaution** | Reported as permitted by many scholars **[S]** (Human Appeal USA summary, not a trusted body) **[U]** primary |

- **Note on Res 121 (3/13) §1:** it asks the shareholder to "make the maximum possible investigations" to find the zakatable portion before falling back to dividends-only. So View 1 is the IIFA fallback, not the first choice. A proxy % (View 2) is one way to make that "investigation" practical. **[V]** for the IIFA text; the link to the proxy is my reading.
- **Practical method with no balance-sheet data (individual):** user picks one of: (a) dividends only — IIFA; (b) 25% proxy — NZF; (c) full value — precautionary. Default for long-term: **ask the user**; pre-select nothing. If the user enters a known zakatable % (e.g. from a screening provider), use it (`zakatable_portion_pct`).
- **Edge cases:** company already pays zakat (e.g. Saudi listed companies pay to ZATCA by law) → IIFA Res 28 (3/4) §1 — shareholder does not pay again on that share. **[V]** App: "Company pays zakat for me" checkbox → 0%. Interest income inside the company: purification topic, not zakat.

### B4. Mutual funds / ETFs / sukuk

- **Funds and ETFs:** same logic as shares, at the fund level. Trading → full market value. Long-term → zakatable portion of the fund's assets (cash + receivables + trading inventory + the zakatable part of the shares it holds), or the fund's published zakat per unit if it publishes one. Fallbacks as B3. **Reference:** IIFA Res 28 (3/4), 121 (3/13) by analogy **[V]**; AAOIFI SS 35 covers investment funds **[U]**.
- **Sukuk:** depends on the type. Sukuk held for trading → market value. Sukuk held to maturity: if the underlying is cash/receivables (e.g. murabaha sukuk) → full value; if the underlying is a real asset (ijara sukuk) → zakat on the income, like rental property (Res 2 (2/2)). **[U]** — AAOIFI SS 35 and SS 17 (Investment Sukuk) section numbers not verified. Practical default: **100% of face/market value** (safer for the poor) with override.
- **Money-market / cash funds:** 100% (they hold cash and receivables). **[U]** by analogy to B1.
- **Defaults:** equity fund long-term: ask (as B3); sukuk: 100%; money-market: 100%. Override: yes.

### B5. Real estate

| Use | Zakat | Base | Reference |
|---|---|---|---|
| Personal home / personal use | No | — | IIFA Res 2 (2/2): no zakat on real estate itself **[V]** (general rule that personal-use items are exempt **[U]** for hadith-level cite) |
| Rental | Not on the property. **On the rental income** held on the zakat date (as part of cash) | net rental savings | IIFA Res 2 (2/2), 1985: no zakat on the property; 2.5% on the yield after a lunar year from receipt **[V]**; Jordan Iftaa same **[S]** |
| Bought to resell (trade goods) | Yes | **100% of market value** on zakat date | Trade-goods rule: Abu Dawud 1562 (Samurah ibn Jundub: we were ordered to pay sadaqah on what we prepared for sale) **[U]** — grading disputed (al-Albani: da'if); IIFA Res 28 (3/4) §3 applies the trade rule to shares **[V]**; AAOIFI SS 35 **[U]** |
| Land held, intent unclear | Depends on intent at purchase | — | Users must state intent |

- **Edge case:** rental income is usually spent before the year ends. Only what is still held on the zakat date counts (it joins cash). Res 2 (2/2) "one year from receipt" vs. the single-date method — in practice, if income goes into a savings balance, it is covered by B1 on the zakat date. **App: v1 adds rental income to cash; it does not track each rent payment's own year.**
- **Defaults:** personal 0%, rental 0% on property (income via cash), resale 100%. Override: intent only.

### B6. Business ownership / private equity

- **Rule:** An owner pays on their share of the business's zakatable assets: cash, receivables (good debts), inventory at market/sale value, less short-term liabilities. Fixed assets (buildings, machines) are not zakatable.
- **Reference:** IIFA Res 28 (3/4) §2 — the company computes zakat as one person's wealth; same logic for a private business **[V]**; AAOIFI SS 35 (net-assets method) **[U]** sections; trade goods: Abu Dawud 1562 **[U]**.
- **Private equity / passive stake, no data:** fall back as B3 (dividends only / proxy / full).
- **Default:** user enters "zakatable portion %" (no safe default exists). If unknown: ask (as B3). Override: yes.

### B7. Retirement / pension accounts with withdrawal limits

Views (user picks):
1. **No zakat until it can be accessed** — Dr. Main Al-Qudah (AMJA), fatwa 21964, 2006: if you cannot legally withdraw before the due date, no zakat; if you can, it is zakatable. **[V]** (amjaonline.org/fatwa/en/21964). Also Dr. Walid al-Manisi (deferral until withdrawn). **[S]** (raleighmasjid.org)
2. **Zakat on the accessible amount** = balance minus early-withdrawal penalty and tax — attributed to the Fiqh Council of North America. **[S]** (zakat.org summary) — FCNA primary text **[U]**.
3. **Full balance every year** (precaution). **[S]** only.
- **App:** setting per pension item: "Not accessible — no zakat until withdrawn" / "Accessible amount after penalty & tax" (user enters that amount or %) / "Full balance". Default: **ask**.
- After withdrawal, the money is cash (B1).

### B8. Crypto

- **Status:** **Disagreement — user choice. Gharar flag.** The IIFA, at its 24th session (Dubai, Nov 2019), Resolution 237 (24/8), did not issue a final ruling and called for more study; a symposium followed in 2021. **[S]** (iifa-aifi.org/en/28253.html — closing statement only). Other national bodies prohibited it (e.g. Egypt's Dar al-Ifta) **[U]**. Scholars who permit holding it generally treat it as money or trade goods → zakat on full market value **[U]**.
- **App:** if the user holds crypto, show: "Scholars differ on whether this is permitted. If you hold it, most who permit it say zakat is due on its full market value." Default: **100% of market value**; user may set otherwise. No coin lists in v1 (separate `crypto.md`).

### B9. Debts owed to the user (preview — UC-5)

- **Rule:** Good debt (debtor able and willing to pay) → zakatable every year, as if cash in hand. Doubtful debt (debtor insolvent or denying) → no zakat until received; then one year's zakat (per IIFA, after a year passes from receipt).
- **Reference:** IIFA Res 1 (1/2), Jeddah, Dec 1985. **[V]** (iifa-aifi.org/en/32192.html). Saudi Permanent Committee, same. **[S]**
- **App (later):** debt item with "Debtor will pay: yes / doubtful". Yes → 100%; doubtful → 0% until marked received. No inflation view on debts (A6.3).

---

## Edge cases (cross-cutting)

- **Mixed intent:** user bought shares long-term but now intends to sell → intent at the zakat date governs for trade goods. **[U]** App: let the user change intent; the zakat date value uses the current intent.
- **Loss positions:** zakat is on current market value, not cost. A stock bought at 100 and now 60 pays on 60 (trading) — never on cost. **[V]** (Res 28 (3/4) §3, "market value").
- **Wealth below nisab:** zero zakat, but ROI-after-zakat screen still shows the item; label "below nisab this year".
- **Haram income inside an asset:** not zakat — goes to purification (BRD §8, separate file).
- **Company already paid zakat:** see B3 (Res 28 (3/4) §1).

## What we do not handle (v1)

- Per-acquisition hawl (Shafi'i/Hanbali). Single zakat date only.
- Nisab continuity during the year — only the zakat date is checked.
- Computing a company's zakatable assets from its balance sheet.
- Agricultural produce, livestock, minerals (different rates: 5%/10%, etc.).
- Zakat al-fitr.
- Long-term liabilities beyond one user-entered "due within 12 months" figure.
- Gold-to-gold exchange flows (riba al-fadl checks) — must be reviewed before any such feature.
- Interest purification — separate topic.
- Paying zakat / tracking recipients.

## Open verification items (must close before release)

1. AAOIFI SS 35 section numbers (rate, shares, funds, sukuk, liabilities). Needs a copy of the standard.
2. AMJA position on long-term shares — the 25% proxy is **NZF**, not AMJA, as far as I could verify.
3. FCNA retirement-account resolution — primary text.
4. Muwatta reference on Aisha and jewelry; Abu Dawud 1562 grading.
5. A named-scholar confirmation for showing real (inflation-adjusted) returns (A6.2), if the owner wants one.

---

## Inputs the app needs per investment

| Field | Type | Why | Default | User may override? |
|---|---|---|---|---|
| `asset_type` | enum: cash, gold, silver, stock, fund, sukuk, real_estate, business, pension, crypto, debt_owed_to_me, other | picks the rule set (Part B) | — (required) | yes (it is their input) |
| `intent` | enum: trading / long_term / personal_use / rental | trading vs long-term vs personal decides base (B2, B3, B5) | stock, fund: **ask**; gold/silver bullion: long_term (still 100%); jewelry: personal_use; real estate: **ask** | yes |
| `currency` | ISO code | conversion on zakat date (A7) | base currency | yes |
| `current_value` (or `quantity` + `unit_price`; for gold/silver `grams` + `purity`) | Decimal | the base is market value on the zakat date, not cost | — | yes |
| `cost_basis`, `acquired_date` | Decimal, date | ROI only. **Not** used for zakat base or hawl (A4) | — | yes |
| `zakatable_portion_pct` | Decimal 0–100 | how much of value is zakatable | cash 100; gold/silver bullion 100; jewelry per setting (100 or 0); stock/fund trading 100; stock/fund long-term per chosen method (25 for NZF proxy, 0 + dividends for IIFA fallback, 100 precaution); sukuk 100; money-market 100; real estate personal 0, rental 0 (income via cash), resale 100; business **ask**; pension per method; crypto 100; debt good 100 / doubtful 0 | yes, with the chosen method's reference shown |
| `long_term_method` | enum: dividends_only (IIFA) / proxy_25 (NZF) / full_value / known_pct | only for long-term stock/fund/business with no exact data (B3) | none — **ask** | yes |
| `company_pays_zakat` | bool | IIFA Res 28 (3/4) §1 → 0% | false | yes |
| `dividends_or_income_held` | Decimal | dividends/rent still held on zakat date (or simply included in cash) | 0 | yes |
| `pension_access` | enum: not_accessible / accessible_after_penalty / full | B7 | **ask** | yes |
| `accessible_amount` | Decimal | B7 view 2 (balance − penalty − tax) | — | yes |
| `debt_status` | enum: good / doubtful | B9 (UC-5) | good | yes |

**User-level settings (once, not per item):** `nisab_standard` (gold 85 g / silver 595 g — ask), `zakat_year` (lunar 2.5% default / solar 2.577%), `zakat_date`, `base_currency`, `jewelry_ruling` (zakatable / not — ask), `deduct_short_term_debts` (on by default) + amount, gold and silver price per gram on zakat date, FX rates on zakat date (editable).

---

## Answers to the PM story (Z-1..Z-7)

Story: `docs/product/stories/my-investments.md` §12. Each answer points to the section above that holds the citation.

- **Z-1 — Zakat share per asset type.** Base is **market value on the zakat date** × zakat share. Defaults are in Part B and the last table ("Inputs the app needs"). Long-term shares/funds have no single default: the user picks dividends-only (IIFA Res 28 (3/4), 121 (3/13)), the 25% proxy (NZF), or full value — B3. **Wahed's 30% is not a ruling I can cite**; do not use it, not even as an example in the UI.
  - Dividends-only means s = 0 for the share itself and zakat falls on the dividends **where they are held** (usually cash). If the cash is not in the list, the app must tell the user "zakat on your dividends is counted with your cash".
- **Z-2 — Rate and year.** Lunar: r = 2.5%, Y = 354.367 days (mean lunar year). Solar: r = 2.577%, Y = 365 (AAOIFI SS 35 [S]) — A1, A2. **The pair must stay matched.** 2.5% with Y = 365 is neither view: it under-states zakat by ~3% for a lunar payer.
- **Z-3 — Monthly pro-rata estimate.** **Allowed as a planning figure. No ruling against it, and none needed:** it is a presentation choice, not a zakat calculation. Zakat is due only once, on the zakat date, on total wealth ≥ nisab that has completed a hawl (A3, A4). So the monthly figure must:
  1. be labelled "estimated zakat set-aside (planning). Actual zakat is due once a year on your zakat date";
  2. never be called "zakat due" or "zakat paid";
  3. use r and Y as a matched pair (Z-2);
  4. be 0 when the user says no zakat is due this year (already in story §9.4).
  Supporting idea: paying zakat early (*ta'jil*) is allowed by the majority, based on al-Abbas paying early — Abu Dawud 1624, Tirmidhi 678. **[U]**, not verified in this pass. It shows that setting money aside before the due date is fine. It does **not** make a monthly amount due.
- **Z-4 — Nisab.** Metal and weight: user picks gold 85 g or silver 595 g (A3). Count **pure** gold/silver content: pure g = g × karat/24. This is common practice; I did not verify a primary source for pure vs gross weight **[U]**. If the list is not all the user's wealth, the app cannot decide nisab. Keep the story's yes/no switch ("zakat due this year"), with the help text "decide using all your zakatable wealth, not only this list". The full nisab check belongs to UC-3.
- **Z-5 — Gold/silver as unit or base.** **No objection.** Gold and silver are *thaman*, and nisab is set in their weight (A8). Base view C is fine as a display. Zakat is still computed per A1–A7 and only then shown in grams. Caution: riba al-fadl (Muslim 1587, A8). The app must never model gold-for-gold at unequal weight, or a deferred gold purchase.
- **Z-6 — Interest on conventional deposits.** **Do not count it as return. Show it separately as "to purify".**
  - **Reference:** Quran 2:275 and 2:278–279. 2:279 says "if you repent, you may have your principal", so the owner's right is the principal only. **[V]**
  - Disposing of non-permissible income for charity (purification), not keeping it: AAOIFI SS 21 (financial papers), purification section **[U]** for the section number.
  - The interest is not the owner's wealth. It is not part of the zakat base, and giving it away does **not** count as zakat (B1 edge case).
  - **Story change:** money out kind "interest (to purify)". It is excluded from gain and return, shown as its own total, and never netted against zakat.
- **Z-7 — FX rate for zakat.** The rate on the zakat due date: Darul Iftaa Mahmudiyyah [S]. Paper money takes the rulings of gold and silver: IIFA Res 21 (9/3) [V]. See A7. In the story's monthly estimate, the period-end rate is fine because it is a planning figure. The real zakat (UC-3) uses the rate on the zakat date.

### Ask at setup vs default (disputed views)

| View | App behaviour | Reason |
|---|---|---|
| Nisab metal (gold / silver) | **(a) Ask, no default** | Both views are live among recognized scholars. Neither is a safe default for everyone (A3). |
| Lunar 2.5% vs solar 2.577% | **(b) Default lunar 2.5%, Y = 354.367** | Both sides accept the lunar year. The dispute is only whether a solar year may be used (A2). Solar stays a setting. |
| Personal jewelry | **(a) Ask, no default** | A school-level split (Hanafi vs the other three), B2. Asked only if the user adds jewelry. |
| Long-term shares method | **(a) Ask, no default** (per item, or once as a portfolio setting) | IIFA dividends-only vs NZF 25% proxy vs full value give very different bases (B3). |
| Pensions | **(a) Ask, no default** | It depends on the user's own withdrawal rules, which the app cannot know (B7). |
| Crypto | **(b) Default 100% of market value**, with a notice that permissibility is disputed | The dispute is about whether holding it is allowed. Among those who allow it, I know of no lower base [U]. The notice tells the user about the dispute (B8). |

### Verdict on the story's Shariah content: **CHANGES_REQUESTED**

1. **§5 line 61 (Zakat share):** remove "a proxy like Wahed's 30 % for long-held equities". Replace with "per asset type and intent, from zakat-on-investments.md Part B; long-term shares/funds: user picks dividends-only (IIFA) / 25% proxy (NZF) / full value". Add an **intent** field (trading / long-term / personal use). The default share depends on it (B2, B3).
2. **§5 line 53 (Asset type):** if "other" covers real estate, business or pension, its zakat share must default to **ask**, not 100% or 0% (B5–B7).
3. **§9.4 lines 185–188 and §10 line 215:** set r_z and Y from the user's zakat-year setting as a matched pair: lunar 2.5% / 354.367 (default), or solar 2.577% / 365. Rename the figure "estimated zakat set-aside (planning)", per Z-3. **Recompute AC-9, AC-10, AC-11, AC-20, AC-23** (lines 233, 238, 239, 260, 263). Example: AC-10 lunar gives Z = 0.025 × 23,000 × 365/354.367 = **592.25**, not 575.00. AC-9 gives **30.69**, not 29.79.
4. **§5.1 / §4 (Money out kinds):** add the kind "interest (to purify)". Exclude it from gain and return, and show it as its own total (Z-6). Add one AC for this.
5. **§9.4 line 191 (no-zakat switch):** add the help text "decide using all your zakatable wealth, not only this list" (Z-4).
6. **§7 (option C):** add one line: "zakat is computed in money per the Shariah file, then shown in grams; no gold-for-gold exchange is modelled" (A8, Muslim 1587).
7. **Every "why" text for a zakat figure** links to the section of this file (A9). Line 6 says the rules are placeholders; once items 1–6 are done, it can point here.

No BLOCKER. Nothing in the story computes or hides a riba figure in a way that helps the user deal in riba. Item 4 closes the one gap: today, interest would be counted as profit.
