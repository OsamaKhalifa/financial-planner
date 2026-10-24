# Zakat on investments ("My Investments" page)

**Owner:** islamic-consultant · **Status:** v0 draft · 2026-10-16 · updated 2026-10-17 (Private equity, expected profit) · updated 2026-10-23 (Part C — yearly zakat, UC-3) · updated 2026-10-23 (loop 1: C6, C8, C10; PM-Q4..Q6)
**Feeds:** "My Investments" story (ROI before/after zakat and inflation), UC-1, UC-3 ("Zakat" story, `stories/zakat.md`).

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
  - AAOIFI SS 35 allows a solar year at 2.577%. **[S]** via National Zakat Foundation UK (nzf.org.uk/knowledge/can-a-solar-year-be-used-for-zakat-calculation) and Islamic Markets summary. Section number **[U]**. Checked again 2026-10-23: the NZF page gives 2.577% and says **nothing** about leap years.
  - The same adjustment (add 11/354 to the rate) is credited to the "International Organization of the Contemporary Fiqh of Zakah" by fiqh.islamonline.net ("calculating zakah on the solar calendar"). **[S]**
  - "2.5775% in a leap year" appears only in commercial calculators (Wahed). No trusted body found. **Not used** (Z-Q4).
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

### B6. Private equity (app type `privateEquity`) — business ownership, stake in a private project

Example (owner): money put into a friend's project, profit paid on a schedule.

- **Rule:** An owner pays on their share of the business's zakatable assets: cash, receivables (good debts), inventory at market/sale value, less short-term liabilities. Fixed assets (buildings, machines) are not zakatable.
- **Reference:** IIFA Res 28 (3/4) §2 — the company computes zakat as one person's wealth; same logic for a private business **[V]**; IIFA Res 121 (3/13) §1 — investigate the zakatable part first **[V]**; AAOIFI SS 35 (net-assets method) **[U]** sections; trade goods: Abu Dawud 1562 **[U]**.
- **Zakat methods the app offers (user picks, nothing pre-selected):**
  1. **Known zakatable %** — user enters it (the project's cash + receivables + stock of goods, as % of its value). First choice: Res 121 (3/13) §1 asks the owner to find the real zakatable part.
  2. **Zakat on profit received only** — s = 0; set-aside = r_z × each payout of kind income (same math as dividends-only, §9.4). Valid by analogy: Res 28 (3/4) §3 allows zakat on yield only for shares held for return when the zakatable part cannot be known, citing Res 2 (2/2). A passive stake held for its profit is the same case. **[V]** for the texts; the analogy is my reading.
  3. **Full value** — precaution.
  - **Not offered: the 25% NZF proxy.** It comes from listed FTSE 100 balance sheets. It says nothing about a small private project.
- **Held to sell (trading intent):** if the user holds the stake to sell it for a gain → 100% of value, no method question (Res 28 (3/4) §3, trade rule **[V]**).
- **Help text under the methods:** "If the project mostly buys and sells goods, most of its value is usually zakatable." (follows from the rule above; no extra source needed).
- **Capital guaranteed back (see B6.1, case C):** not a stake. It is money lent → zakat as a good debt, 100% of the amount put in (B9, IIFA Res 1 (1/2) **[V]**). The app offers 100% with this reason.
- **Default:** ask. Override: yes.

### B6.1 Fixed profit % — partnership or loan?

- **Rule:** In a valid partnership (musharakah) or mudarabah, profit is a **share of the actual profit** (e.g. "30% of the profit"). It may not be a lump sum or a **fixed % of the capital**. No partner or manager may guarantee the capital or a profit. A fixed return on guaranteed capital is a loan with a benefit, which is riba.
- **Reference:**
  - IIFA Res 30 (5/4), 1988, *Muqaradah and investment certificates*: item 4 — no guarantee from the manager "for the capital or a fixed profit"; if such a clause exists, it is void. Item 6 — no specific amount may be stipulated; only profit (excess over capital) is divided. **[V]** (iifa-aifi.org/en/32300.html)
  - IIFA Res 10 (10/2), 1985: an increase on a loan agreed at its start is riba. **[V]** (iifa-aifi.org/en/32234.html)
  - Quran 2:275, 2:278–279 ("you may have your principal"). **[V]**
  - AAOIFI SS 13 (Mudarabah) §8/1: profit by "agreed percentage of the profit and not … a lump sum or a percentage of the capital"; §8/5: a lump-sum condition voids the contract. **[S]** (excerpts on islamicmarkets.com / islamqa.org fatwacentre 179139; full text paywalled).
  - AAOIFI SS 12 (Sharikah): same rule for partnership. **[U]** section numbers.
  - TKBB (Turkey) Participation Finance Standard No. 7, Musharakah, 2025: Art. 17 no profit guarantee for any partner; Art. 19 losses in proportion to capital, "the contrary cannot be agreed upon". **[V]** (tkbb.org.tr PDF)
  - Do **not** cite "every loan that brings a benefit is riba" as a hadith. It is weak as a hadith; the rule rests on Res 10 (10/2) and the Quran.
- **Three cases the app must tell apart (two questions, below):**
  - **A. Share of actual profit, capital at risk** → valid partnership. Payouts are return.
  - **B. Fixed % of capital, capital at risk** → partnership with an invalid profit term (Res 30 (5/4) item 4: the condition is void). It is not a loan, because the user can lose. In a defective (*fasid*) mudarabah, the profit belongs to the capital owner and the worker gets a fair wage (Hanafi and Shafi'i). **[U]** So the payouts are not riba in themselves. Payouts count as return, with a notice to fix the terms.
  - **C. Capital guaranteed back (with a fixed % or any set return)** → a loan with a stipulated benefit = riba (Res 10 (10/2), Q 2:279). The user's right is the capital only. Payouts above the capital → "to purify" (Z-6 treatment).

### B6.2 Losses

- **Rule:** In a partnership, losses follow the capital shares (TKBB Std 7 Art. 19 **[V]**; AAOIFI SS 12 **[U]**). In mudarabah, the money loss falls on the capital provider; the manager loses his work, unless he was negligent (Res 30 (5/4) "First, fourth element" and item 4 **[V]**).
- **App:** nothing new. The user records a lower value with the existing value update. Return and zakat use that value.

### B7. Retirement / pension accounts with withdrawal limits

Views (user picks):
1. **No zakat until it can be accessed** — Dr. Main Al-Qudah (AMJA), fatwa 21964, 2006: if you cannot legally withdraw before the due date, no zakat; if you can, it is zakatable. **[V]** (amjaonline.org/fatwa/en/21964). Also Dr. Walid al-Manisi (deferral until withdrawn). **[S]** (raleighmasjid.org)
2. **Zakat on the accessible amount** = balance minus early-withdrawal penalty and tax — attributed to the Fiqh Council of North America. **[S]** (zakat.org summary) — FCNA primary text **[U]**.
3. **Full balance every year** (precaution). **[S]** only.
- **App:** setting per pension item: "Not accessible — no zakat until withdrawn" / "Accessible amount after penalty & tax" (user enters that amount or %) / "Full balance". Default: **ask**.
- After withdrawal, the money is cash (B1).

### B8. Crypto

- **Status:** **Disagreement — user choice. Gharar flag.** The IIFA, at its 24th session (Dubai, Nov 2019), Resolution 237 (8/24), did not issue a final ruling and called for more study; a symposium followed in 2021. **[S]** (iifa-aifi.org/en/28253.html — closing statement only). Other national bodies prohibited it (e.g. Egypt's Dar al-Ifta) **[U]**. Scholars who permit holding it generally treat it as money or trade goods → zakat on full market value **[U]**.
- **App:** if the user holds crypto, show: "Scholars differ on whether this is permitted. If you hold it, most who permit it say zakat is due on its full market value." Default: **100% of market value**; user may set otherwise. No coin lists in v1 (separate `crypto.md`).

### B9. Debts owed to the user (preview — UC-5)

- **Rule:** Good debt (debtor able and willing to pay) → zakatable every year, as if cash in hand. Doubtful debt (debtor insolvent or denying) → no zakat until received; then one year's zakat (per IIFA, after a year passes from receipt).
- **Reference:** IIFA Res 1 (1/2), Jeddah, Dec 1985. **[V]** (iifa-aifi.org/en/32192.html). Saudi Permanent Committee, same. **[S]**
- **App (later):** debt item with "Debtor will pay: yes / doubtful". Yes → 100%; doubtful → 0% until marked received. No inflation view on debts (A6.3).

---

## Part C — Yearly zakat (UC-3)

Story: [stories/zakat.md](../stories/zakat.md). This part covers only what the yearly calculation and the distribution log need. Rate, nisab, values, FX and item shares stay in Parts A and B.

### C1. Cycle date and due date (hawl)

- **Rule:** Zakat falls due when 12 lunar months have passed since the user's wealth first reached nisab. That day, every year, is the zakat date. With the solar option (A2), it is the same day and month in each Gregorian year, with r = 2.577%.
- **Reference:**
  - Abu Dawud 1573: no zakat until a year passes. **[V]** Muwatta Malik (Ibn Umar) says the same, with al-Shaybani *al-Asl* and al-Sarakhsi *al-Mabsut* — via Islamic Portal (islamqa.org/hanafi/islamicportal/175831). **[S]**
  - Quran 9:36 (twelve months) and 2:189 (the new moons are time markers for people). **[V]**
  - "The first time your wealth surpasses the Nisaab amount, that would be your Zakat-versary" — Darul Iftaa Birmingham (islamqa.org/hanafi/daruliftaa-birmingham/245155). **[S]**
  - If the date is not known, use a best estimate: common fatwa practice. No named primary source found. **[U]**
- **App:**
  - Help text on the cycle-date question: "Your zakat date is the day your wealth first reached nisab, counted in Hijri months. If you already give zakat on a set date, use that date."
  - One r per year. No T/Y factor (A1). A leap solar year still uses 2.577% (A2, Z-Q4).

### C2. Changing the calendar or the cycle date

- **Rule:** Zakat that is already due must not be pushed back. A zakat date may move earlier: that is giving early (C6). It may not move later in a way that makes one year longer than one hawl. Most scholars hold that zakat must be given when it falls due. Delay without a valid excuse is not allowed.
- **Reference:**
  - Delay after the year ends is not allowed without a valid excuse. Malik, Ahmad and most scholars hold that zakat is due at once. — Saudi Permanent Committee, via islamqa.info 13981. **[S]** Primary texts **[U]**.
  - Hanafi: "It is not permissible to change your zakat date." You may give early on an estimate. On the real date, work out what is owed and make up any shortfall. Late zakat stays a debt until it is paid. — FatwaCentre (Mufti Abdur-Rahman Mangera, Mufti Zubair Patel), islamqa.org/hanafi/fatwacentre/178985. **[S]**
- **App:**
  1. A year that is **due**, distributing or settled is never rebuilt by a change of calendar or cycle date. It keeps its calendar, due date and r. A due year stays due until the user starts it, because its zakat is already owed.
  2. Only **open** years may be rebuilt. After the change, the first new due date must be **on or before** the old due date of the open year. A first new year that ends later is not allowed. How the app meets this is a product choice.
  3. After a switch from lunar to solar, every later year is about 11 days longer. That is the A2 view, and r = 2.577% covers it. Rule 2 applies only to the year of the change.

### C3. Umm al-Qura vs local sighting; moving the due date

- **Rule:** A lunar month starts when the new moon is seen. It has 29 or 30 days. A calculated calendar (Umm al-Qura) can differ from local sighting by one or two days. The user's year ends on the cycle day as their own community counts the month.
- **Reference:**
  - Bukhari 1909: fast when you see the new moon; if it is hidden, complete thirty days. **[S]** Bukhari 1907: a month may have 29 nights. **[S]** (ihadis.com, tohed.com; sunnah.com refused the fetch.) Quran 2:189. **[V]**
  - Using Umm al-Qura as the converter is a product choice, not a Shariah rule. "±2 days covers sighting differences" is my reading. **[U]**
- **App:**
  - **Lunar:** the user may move the due date 1–2 days earlier or later. The moved date is the due date for values, rates, nisab and the notification.
  - **Cycle day 30 in a month with 29 days:** use the 29th, the last day of that month. My reading **[U]**: this is never later than the real end of the year, so at worst the user gives one day early (C6).
  - **Solar:** there is no sighting reason to move the date. Moving it earlier is giving early (C6), so that is fine. Moving it later delays zakat for no reason (C2). Shariah view: solar dates may move **earlier only**.
  - Line under a Hijri due date: "Hijri dates use the Umm al-Qura calendar. If your month began on another day where you live, move your due date."

### C4. Nisab on the due date, after deductions

- **Rule:** On the due date, value all zakatable wealth and take off the debts the user deducts (A5). Then compare what is left with nisab. If it is below nisab, no zakat is due for that year.
- **Reference:**
  - Hanafi: "after evaluating one's zakaatable assets one will deduct his liabilities and debts". If the rest reaches nisab, zakat is due. — Council of Ulama Eastern Cape (islamqa.org/hanafi/councilofulama/50867), citing Ibn Abidin, *Radd al-Muhtar* 2/260. **[S]**
  - Shafi'i: debt does not cancel zakat (A5). In the app this is "deduction off", so the gross total is compared.
  - Hanafi: nisab must be held at the start and the end of the year — Islamic Portal 175831. **[S]**
- **App:** `B = max(0, Σ L_i − debts)`, and zakat is due if `B ≥ nisab`. Both are taken on the due date. With deduction off, `debts = 0`, so the gross total is compared. That is the Shafi'i view, and it needs no second switch.
- **Edge case — below nisab on the due date:** in the Hanafi view, the zakat date lapses. A new one starts on the day wealth next reaches nisab, and zakat is due one lunar year after that day (Islamic Portal 175831 **[S]**). v1 keeps the cycle date, so giving on it counts as giving early (C6): valid, never late. This is listed under "What we do not handle".

### C5. Money owed to me and cash outside the list (extra lines)

- **Rule:** Same as B1 and B9. A good debt counts at its full amount every year. A doubtful debt counts nothing until it is received. Once received, it is cash.
- **Reference:** IIFA Res 1 (1/2) **[V]**; B1.
- **App:** extra lines take only cash and good debts, both at 100%. A good debt needs the user to state that the debtor is able and willing to pay. Other kinds of wealth (gold, goods held for sale, a business) are not extra lines. They go in My Investments, where Part B gives each one its share.

### C6. Giving before the due date (ta'jil)

- **Rule:** The Hanafi, Shafi'i and Hanbali schools allow zakat to be given before it falls due. Conditions: the user already holds nisab when giving, and gives the money as zakat. The Shafi'i school also limits this to one year ahead. The Maliki school allows it only shortly before the due date. **[U]**
- **Reference:**
  - Abu Dawud 1624 (Ali): al-Abbas asked to give his zakat before it fell due, and the Prophet allowed it. Graded hasan by al-Albani, da'if by Zubair Ali Zai. **[S]** (sunnah.com listing seen through search; the page refused a direct fetch.) Tirmidhi 678 **[U]**.
  - Conditions: nisab held when giving; one year ahead only; giver and recipient still eligible at the end of the year. — Darul Iftaa Jordan, Q 2974 (islamqa.org/shafii/darul-iftaa-jordan/228000). **[S]**
  - Hanafi: give early, then check the amount on the real date — FatwaCentre 178985. **[S]**
- **App:**
  - A log entry dated before the due date counts toward that year and is marked "given before the due date".
  - Help line: "This counts if you held nisab when you gave it and you gave it as zakat. The Maliki school accepts this only shortly before the due date."
  - Earliest allowed date: the day after the previous year's due date. That keeps the entry inside the year's own hawl, which also meets the one-year limit.
  - "Previous year's due date" is that year's **real** due date: the moved date if the user moved it (C3). Not the computed date.
  - **First year in the app** (no previous year, PM-Q4): earliest date = the day after the cycle date one year before the first due date, in the first year's own calendar (lunar: same Hijri day and month in the year before, Umm al-Qura, day-30 rule of C3; solar: same Gregorian day in the year before, 29 Feb → 28 Feb). Why: the cycle date is the day wealth reached nisab (C1), so the first hawl starts there.
  - The Maliki clause of the help line is still **[U]** (Open item 7). Its Source sheet shows "source not yet verified" for that clause only.

### C7. Giving more than due

- **Rule:** **Scholars disagree — the user picks.**
  - Hanafi: an extra amount given **as zakat** may count toward next year's zakat.
  - Shafi'i: the extra is voluntary sadaqah. It cannot become next year's zakat, because each year's zakat needs its own intention.
- **Reference:** Darul Uloom Deoband, fatwa 28/76/D=01/1435, citing *Fatawa Darul Uloom* 6:93 (islamqa.org/hanafi/darulifta-deoband/109918). **[S]** Darul Iftaa Jordan, Q 3602 (islamqa.org/shafii/darul-iftaa-jordan/228988). **[S]**
- **App:** show "Given {x} more than due." Not moving the extra is valid under both views, because the next year is still given in full. Below that, show: "Some scholars (Hanafi) let you count this toward next year if you gave it as zakat. Others (Shafi'i) count it as sadaqah. The app does not move it."

### C8. Giving in another currency

- **Rule:** Cash zakat may be given in another currency (A7). **Scholars differ on which exchange rate counts it — the user picks.**
  - View 1: the rate on the day it is given. This is the view of the Sahibayn (Abu Yusuf and Muhammad), "the day of payment". Several contemporary Hanafi muftis prefer it, partly because it is better for the poor.
  - View 2: the rate on the due date. This is Abu Hanifa's view, "the day it became due".
- **Reference:**
  - fatwa-ca (islamqa.org/hanafi/fatwa-ca/178598) explains both views. **[S]**
  - Darul Iftaa Mahmudiyyah (islamqa.org/hanafi/daruliftaazambia/134900): use the due-date rate; a higher rate is allowed. **[S]**
  - Muftionline (islamqa.org/hanafi/muftionline/46417): use the value at the time of giving. **[S]**
  - Primary text, *Radd al-Muhtar* (Kitab al-Zakah). **[U]**
- **App (v1, updated 2026-10-23 loop 1):** log entries may be in **any currency** (owner OQ-5). This replaces "base currency only".
  1. **Rate view: (a) ask, no default.** Asked once, the first time the user logs an entry in a currency other than the year's base. Both views shown with who holds them and their Source: "the rate on the day you gave (Abu Yusuf and Muhammad)" / "the rate on your due date (Abu Hanifa)". Nothing pre-selected. The entry is not saved until answered. Never asked of a user who logs only base-currency entries.
  2. Then a Zakat setting the user may change.
  3. **Each entry stores the view, the rate and the rate date it was counted at.** A later change of view applies to **new entries only**. Old entries keep their counted amount. The user may edit an old entry to recount it (PM-Q5 answer).
  4. Rate = the rate on the rate date. If the app uses an older rate (latest on or before), it shows that rate's date and says it is not the rate of the rate date. Never 1:1.
  5. Shown on each entry: "{amount} {currency} at {rate} on {rate date} ({view})". The rate date must be the date of the rate used.

### C9. Recomputing after part was given

- **Rule:** Zakat due is the correct amount on the due date, not the first figure the app computed. If that figure was wrong, amounts already given as zakat count toward the corrected figure, and any shortfall is still owed. If the corrected figure is lower than what was given, C7 applies to the extra.
- **Reference:**
  - FatwaCentre 178985: on the real date, work out what is owed, then make up any shortfall or deal with any excess. Unpaid zakat stays a debt. **[S]**
  - SeekersGuidance (Mawlana Ilyas Patel): you may give a projected amount, then check it on the true date. **[S]**
- **App:** recompute is allowed and the log is kept. The state follows distributed vs the new Z (story §8). If the new Z is below distributed, show the C7 text.

### C10. Due-date notification wording

- **Rule:** The app must not tell the user that an act of worship is due when it has not checked. On the due date the zakat year ends. Whether zakat is due depends on nisab (A3, C4). When the app schedules the notification, it does not know that yet.
- **Reference:** Abu Dawud 1573: nothing is due below 20 dinars or 200 dirhams. **[V]** See also A3.
- **App:**
  - **"Your zakat for {year} is due today" is not acceptable as one fixed text.** In a below-nisab year it is false. Acceptable: "Your zakat year {year} ends today. Open to see your zakat." That is true in every case.
  - In-tab text for a year in state due, where the app knows the result:
    - Z > 0: "Your zakat for {year} is due."
    - Z = 0: "Your zakat year {year} ended on {date}. Below nisab: no zakat due."
    - Incomplete: "Your zakat year {year} ended on {date}. Complete it to see your zakat."
  - The ban on "late / missed / overdue" comes from P-3, which is about payouts, not zakat. For zakat it is a tone choice.
  - **Decided (loop 1, PM-Q6): show** this line, with Source → C2: "Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason." It shows on a due year (Z > 0 or incomplete) and on a distributing year. Not on open, below-nisab or settled years. Not in the notification. Info colour, never error.

### C11. What "settled" may and may not claim

- **Rule:** Zakat is fulfilled only when it is given **as zakat** to people in the eight groups named in Quran 9:60. The app records amounts only. It cannot know the user's intention, and it cannot know whether a recipient may receive zakat. Interest given away is not zakat (Z-6).
- **Reference:**
  - Quran 9:60. **[V]**
  - Each year's zakat needs its own intention — Darul Iftaa Jordan, Q 3602. **[S]**
  - Sadaqah given in good faith to someone who did not qualify (a rich man, a thief) was accepted — Bukhari 1421, Muslim 1022. **[S]** (ihadis.com, hadithunlocked.com)
  - Does this also cover obligatory zakat? Abu Hanifa and Muhammad: yes, if the giver took care. Abu Yusuf, and one Shafi'i view: no. **[U]** The app must not judge either way.
- **App:**
  - "Settled" means only one thing: **the amounts you logged reach the zakat due.** The app must say so. Show one line on every settled year and in the log help: "The app counts what you log. It cannot check that each person may receive zakat (Quran 9:60), or that you gave it as zakat. Do not log interest you gave away: it is not zakat."
  - Never write "zakat paid", "accepted", "fulfilled" or "your duty is done". In Arabic, avoid برئت الذمة and تقبّل.
  - A below-nisab year reads "below nisab: no zakat due", never "settled" alone.

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
- Paying zakat. Recipients and whether they may receive zakat: the log records amounts only (C11).
- A new zakat date after a below-nisab year (C4). The cycle date is kept, so giving on it counts as giving early.
- Counting an amount given above the zakat due toward next year (C7, Hanafi view).
- Zakat of years before the first year in the app (owner Q-O1). If any of it was not given, it is still owed (FatwaCentre 178985 **[S]**, C2). The app must say this once, on the cycle-date step (loop 1 item 1).

## Open verification items (must close before release)

1. AAOIFI SS 35 section numbers (rate, shares, funds, sukuk, liabilities). Needs a copy of the standard.
2. AMJA position on long-term shares — the 25% proxy is **NZF**, not AMJA, as far as I could verify.
3. FCNA retirement-account resolution — primary text.
4. Muwatta reference on Aisha and jewelry; Abu Dawud 1562 grading.
5. A named-scholar confirmation for showing real (inflation-adjusted) returns (A6.2), if the owner wants one.
6. Private equity items (B6.1, P-1..P-5): case B (*fasid* mudarabah) primary text; AAOIFI SS 12 and SS 13 sections; see "Open items for this section" at the end.
7. Part C: Tirmidhi 678; the Maliki limit on giving early (C6; searched 2026-10-23, not found — the reported "about a month" in *Mukhtasar Khalil* is unverified); *Radd al-Muhtar* on value at the day of giving vs the due date (C8); the Hanafi split on zakat given to someone who turns out not eligible (C11); "best estimate" when the nisab date is unknown (C1); the day-30 rule (C3); the minority Hanafi report that zakat is not due at once (C10 line); al-Suyuti's text of "ijtihad is not undone by ijtihad" (PM-Q5).

---

## Inputs the app needs per investment

| Field | Type | Why | Default | User may override? |
|---|---|---|---|---|
| `asset_type` | enum: cash, gold, silver, stock, fund, sukuk, real_estate, business, pension, crypto, debt_owed_to_me, other. **App v1 types:** stock, fund, sukuk, gold, silver, cashDeposit, crypto, **privateEquity** (B6), other | picks the rule set (Part B) | — (required) | yes (it is their input) |
| `profit_basis` (privateEquity only) | enum: share_of_profit / fixed_pct_of_capital / not_sure | B6.1 cases A/B | — **ask** (required when `expected_profit_pct` is set) | yes |
| `capital_guaranteed` (privateEquity only) | enum: no / yes / not_sure | B6.1 case C | — **ask** | yes |
| `expected_profit_pct` + `payout_schedule` | Decimal (% per year) + enum: monthly / quarterly / every 6 months / yearly / none | planning only (Answers 2026-10-17, P-3). **Never used for zakat or return.** | empty (optional, any type) | yes |
| `expected_value_growth_pct` + `value_check_schedule` | Decimal (% per year) + enum: monthly / quarterly / every 6 months / yearly | planning only (P-3). **Never used for zakat or return.** | empty (optional, any type) | yes |
| `intent` | enum: trading / long_term / personal_use / rental | trading vs long-term vs personal decides base (B2, B3, B5) | stock, fund: **ask**; gold/silver bullion: long_term (still 100%); jewelry: personal_use; real estate: **ask** | yes |
| `currency` | ISO code | conversion on zakat date (A7) | base currency | yes |
| `current_value` (or `quantity` + `unit_price`; for gold/silver `grams` + `purity`) | Decimal | the base is market value on the zakat date, not cost | — | yes |
| `cost_basis`, `acquired_date` | Decimal, date | ROI only. **Not** used for zakat base or hawl (A4) | — | yes |
| `zakatable_portion_pct` | Decimal 0–100 | how much of value is zakatable | cash 100; gold/silver bullion 100; jewelry per setting (100 or 0); stock/fund trading 100; stock/fund long-term per chosen method (25 for NZF proxy, 0 + dividends for IIFA fallback, 100 precaution); sukuk 100; money-market 100; real estate personal 0, rental 0 (income via cash), resale 100; business **ask**; pension per method; crypto 100; debt good 100 / doubtful 0 | yes, with the chosen method's reference shown |
| `long_term_method` | enum: dividends_only (IIFA) / proxy_25 (NZF) / full_value / known_pct | stock/fund: all four (B3). **privateEquity: known_pct / dividends_only ("profit received only") / full_value — no proxy_25** (B6). Trading intent → 100%, no method. Case C (capital guaranteed) → 100% as a debt (B9) | none — **ask** | yes |
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
  Supporting idea: paying zakat early (*ta'jil*) is allowed by the majority, based on al-Abbas paying early — Abu Dawud 1624 **[S]** (see C6), Tirmidhi 678 **[U]**. It shows that setting money aside before the due date is fine. It does **not** make a monthly amount due.
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

### UX questions (docs/product/ux/my-investments.md PM-Q1, PM-Q2)

**(a) How "dividends only" is computed (B3; IIFA Res 28 (3/4) §3, Res 2 (2/2) [V])**
- **What the user enters:** nothing new. The existing money-out kind **"Income received"** on the share/fund item is the dividend.
- **Share of the holding's value:** s = 0. No set-aside on the market value.
- **Set-aside for a period:** `r_z × (sum of "Income received" dated inside the period)`.
  - It is **not** multiplied by T/Y. The IIFA charges 2.5% once on the dividend after a year from receipt. Setting it aside when the dividend arrives is a planning choice (early set-aside, Z-3), so each dividend is charged exactly once.
  - Over a full year, the total is r_z × that year's dividends.
- **Rate:** the same matched r_z as the user's zakat-year setting (A1/A2). Default 2.5%.
- **Why text:** "Zakat only on dividends you received, as the IIFA rules for shares held for income when company data is unknown. — IIFA Res 28 (3/4) §3."
- **Edge case (double count):** if the user also records the same dividend as money in to a cash item in this list, it would be counted twice. On that cash item's money-in, show the hint "Already counted as dividend zakat on {item}?". Do not try to resolve it automatically.

**(b) What the nisab choice changes on screen in v1 (A3)**
- **Show the threshold as a hint** next to the "No zakat due for {year}" switch (S8 Zakat row and the S7 Year overflow):
  "Nisab: 85 g gold = 425,000 EGP on 16 Oct 2026 (your gold rate)", or 595 g silver.
- **Next to it, show "Zakatable total in this list:"** Σ (value × zakat share). Add the line "Decide using all your zakatable wealth, not only this list" (Z-4).
- **The switch is never set automatically.** The list is not all the user's wealth (Z-4), so the app gives the numbers and the user decides.
- **No rate for the chosen metal:** show "Add a gold rate to see the nisab", with the inline rate entry.
- **Nisab not chosen yet:** show both lines (gold and silver) and the Source link.
- Nothing else changes in v1. Full nisab logic stays in UC-3.

### Verdict on the UX doc (docs/product/ux/my-investments.md): **CHANGES_REQUESTED**

1. **S7 ladder example, lines 240 and 399:** "−29.79 EGP" uses 2.5% with Y = 365. With the lunar default, Y = 354.367, so it is **−30.69 EGP**. Recompute the lines below it. PM-Q7 is answered by Z-2: lunar 2.5%/354.367, solar 2.577%/365.
2. **S3 Pension (lines 71, 117):** the option "On the amount you could withdraw" needs an input for the accessible amount (or %), meaning balance minus penalty and tax (B7). Without it, the app cannot compute that view.
3. **S3/S4 Crypto:** add the notice "Scholars differ on whether holding crypto is permitted. Those who permit it say zakat is on full market value." Default share 100% (B8). Today the doc has no crypto notice.
4. **S3 "Other" + Long-term (line 116):** a business or private stake must ask for a zakatable % (B6). It must not reuse the shares method (dividends / 25%), which is for listed shares and funds only. "Other" + Personal use → 0%.
5. **S5 interest line (line 168):** add "Giving it away does not count as zakat." (B1, Z-6)
6. **Setup step 2, long-held shares row (line 69):** name the source in each option: "Dividends only (IIFA) · 25 % of value (NZF proxy) · Full value (precaution)". The user should not choose blind before opening Source.
7. **Nisab hint:** add it as in (b) above. It answers PM-Q2.

Everything else on the Shariah surface passes. That covers: the setup step with nothing pre-selected and lunar as the default; "Not now" asked in context rather than defaulted; the "Estimated set-aside" label and the once-a-year line; the A6 wording on every real figure; interest kept apart from return; the gold view leaving the zakat math unchanged; and `[U]` shown as "source not yet verified". No BLOCKER.

---

## Answers for Private equity (2026-10-17)

Owner decisions (not reviewed here): new type **Private equity**; optional **expected profit %** + **payout schedule**, and **expected value growth %** + **value-check schedule**, on **every** type. Sources are in B6, B6.1, B6.2, Z-6 and A8. The PM turns each line into an AC.

### P-1. Zakat share for Private equity (B6)

1. Ask the intent: **long-term (for its profit)** or **to sell**.
2. To sell → 100% of value. No method question.
3. Long-term → user picks one method, nothing pre-selected:
   - "Known zakatable %" (user enters %) — IIFA Res 121 (3/13) §1;
   - "Zakat on profit received only" — s = 0, set-aside = r_z × each payout of kind income, charged once (same math as dividends-only, AC-5) — IIFA Res 28 (3/4) §3 by analogy;
   - "Full value" — precaution.
4. **Do not offer the 25% NZF proxy** for Private equity.
5. If `capital_guaranteed` = yes (case C) → offer 100% with the text "This works like money you lent. Zakat is on the full amount, as a debt owed to you. — IIFA Res 1 (1/2)." No method question.
6. Help text under the methods: "If the project mostly buys and sells goods, most of its value is usually zakatable."
7. This replaces UX verdict item 4 for business stakes: "profit received only" **is** allowed for Private equity; the 25% proxy is still not.

### P-2. Fixed % — the two questions and the notices (B6.1)

When to ask (updated 2026-10-17, loop 1):
- **Q2: on every Private equity item**, at save, required, "Not sure" allowed. This is wider than the orchestrator's "when a schedule is set". Reason: case C changes the zakat base to 100% as a debt (P-1 item 5) even with no payouts. Profit can also be recorded by hand with no schedule. A guaranteed-capital loan without a schedule must still reach case C.
- **Q1: only when `expected_profit_pct` is set.** With no %, there is no fixed % to test. Case B needs Q1 = fixed %, so it cannot happen without a %. Cases A and "?" follow from Q2 alone.
- Q1 "Is this % a share of the project's real profit, or a fixed % of the money you put in?" → share of profit / fixed % of my money / not sure.
- Q2 "If the project loses money, do you still get all your money back?" → no / yes / not sure.

The app saves whatever the user answers. It never blocks saving. It shows one notice on the item (form and detail page), with a "Source" link:

| Answers | Case | Notice (exact text) | Source link |
|---|---|---|---|
| share of profit + no | A | none | — |
| fixed % + no | B | "A fixed % of the money you put in is not a valid profit share. In a partnership, your profit must be a part of the project's real profit. You may want to change the terms with your partner." | IIFA Res 30 (5/4) item 4 → B6.1 |
| Q2 = yes (any Q1) | C | "Your money comes back even if the project loses. This works like a loan. Extra money on a loan is riba. The app shows these payouts as "to purify", not as profit." | IIFA Res 10 (10/2); Quran 2:279 → B6.1 |
| any "not sure" (and Q2 ≠ yes) | ? | "Ask your partner two things: Is your profit a part of the real profit? Can you lose money? The answers decide if this is a partnership or a loan." | IIFA Res 30 (5/4) → B6.1 |

### P-3. Expected profit and expected value growth — all types

**Allowed as planning figures on every type.** They are the user's own estimate about their own wealth. They are not a contract term. "Expected profit" is a normal term in Islamic finance (TKBB Std 7 Art. 18 **[V]**). No rule forbids showing it (same reasoning as A6.2, Z-3).

**Wording rules (everywhere these figures appear):**
- Field labels: "Expected profit (your estimate, % per year)", "Expected value growth (your estimate, % per year)".
- One line under the field: "An estimate, not a promise. Not used for zakat or return."
- Never use the words "interest", "guaranteed", "promised", "fixed return" or "yield" for these figures.
- Never use them in zakat, return, gain or after-inflation math. Those use only recorded money in/out and value updates.
- Missing payout: "No payout recorded for {period}. Expected around {date}." Not "late", not "missed", not "default". On Private equity add: "In a partnership, no profit means no payout." (A payout before the project's accounts close is an advance on account — AAOIFI SS 13 **[U]** section.)
- Value below the estimate: "Value is below your estimate." Not "loss against target".

**Types where an expected profit % is itself a flag** (shown once, under the expected-profit field, only when it is filled in):

| Type | Show | Why |
|---|---|---|
| cashDeposit | Ask "Is this an Islamic account (profit share) or a conventional account (interest)?" Conventional → notice "This is interest. Record it as money out "interest (to purify)", not as income." Islamic → label stays "Expected profit (estimate)". | Z-6; Quran 2:278–279 **[V]** |
| gold, silver — **not shown in v1** (field hidden for these types; text kept for later) | "Gold and silver do not earn profit by themselves. If you lend gold and get back more gold, or a fixed % on lent gold, that is riba." | Muslim 1587 **[S]**; A8 |
| crypto — **not shown in v1** (field hidden; text kept for later) | "Scholars differ on crypto (see B8). A fixed return for lending your coins works like a loan with a benefit." | B8 **[S]**; the loan reading is mine **[U]** |
| privateEquity | P-2 questions and notices | B6.1 |
| stock, fund, sukuk, other (incl. rent) | none | Fixed profit is normal in ijara and murabaha sukuk and in rent (Res 2 (2/2) **[V]**). A manager's guarantee inside mudarabah/musharakah sukuk is an issuer issue (AAOIFI Shari'ah Board statement on sukuk, Feb 2008 **[S]**); the user cannot check it; out of v1. |

### P-4. How payouts count (B6.1)

- Case A and case B: payouts (money out, kind income) count as **return**. Case B keeps its notice. The "profit received only" zakat method uses them.
- Case C: every payout of kind income on the item is shown as **"to purify"**: excluded from gain and return, added to the "to purify" total, never netted against zakat (same as Z-6). Getting the capital back is a sale/withdrawal, not income.
- The user can change Q1/Q2 at any time. The treatment follows the current answers, for all past payouts.
- The app shows the reason and the source. It does not judge the user.

### P-4b. Review of the story, 2026-10-17 (pending rows, Z-10, income not lowering value)

- **Owner decision Q14 (case B):** payouts count as return, and the item gets a "Shariah risk" tag. Accepted. The "counts as return" line keeps "source not yet verified" until the open item on case B is closed.
- **Conventional cash deposit with a payout schedule.** Confirming a pending row must record **"interest (to purify)", paid out to me**, not income. An interest record must resolve that row. The row label is "Expected interest (to purify)". Here the word "interest" is required: it is the truth (Z-6, Quran 2:278–279). This is the one exception to the banned-word rule in P-3. Without it, one tap counts interest as return.
- **Z-10, pending payout rows:**
  - Row label: "Expected payout (not received yet)". Never "profit due" or "owed".
  - Private equity case C: "Expected payout (to purify when received)".
  - Check-mark label: "Received this amount".
  - "Confirm all as expected": one line under it, "Confirm only money that really came in."
  - Reason: a confirmed row becomes the user's own record, and that record feeds return, "to purify" and the zakat set-aside.
- **Income payouts do not lower the item's value** (architect's choice). No Shariah problem. "Dividends only" and "profit received only" use r_z × the income records, with s = 0, so the item's value does not enter that math. Methods with s > 0 charge on the value still inside the item, which is correct. Income paid out is zakatable where it is held (Z-1 note on cash). Case C: the value stays equal to the money lent, which is the right debt base (B9).

### P-4c. Loop 1 texts (2026-10-17)

- **Case C give-away record** (reuses "interest given away (from interest paid out to me)"). On a case C item, label: **"Given away from payouts (to purify)"**. Help line: "Money from these payouts that you gave to charity. Giving it away does not count as zakat." The word "interest" is not needed here: the case C notice already says why (B6.1, Z-6).
- **Notice under "Zakat on profit received only"** (replaces the UX proposal in ux/my-investments.md §2.12.1): "Zakat: {r_z} of each profit payout you record, not of the project's value. Each payout is counted once." Source: IIFA Res 28 (3/4) §3, by analogy (B6). {r_z} = 2.5% or 2.577%, from the user's zakat year setting (A1, A2). Fixed "2.5%" is wrong for a solar-year user.
- **Conventional deposit pending rows:** P-4b stands (orchestrator decision Q-E1).

### P-5. Losses (B6.2)

Nothing new. The existing value update lets the value drop. Return and zakat use that value.

### Open items for this section

- **[U]** Case B ruling (defective mudarabah: profit belongs to the capital owner, worker gets a fair wage). Needs a primary Hanafi/Shafi'i text. Until then, the case B "counts as return" line shows "source not yet verified". **Owner decided (Q14, 2026-10-17):** case B payouts count as return, and the item gets a "Shariah risk" tag.
- **[U]** AAOIFI SS 12 section numbers; SS 13 §8/1 and §8/5 are **[S]** only.
- **[U]** AAOIFI SS 13 section on periodic payouts as advances on account.
- **[U]** Crypto lending as a loan with a benefit.
- **Before release:** I must review the Arabic text of Q1, Q2, the P-2 notices, the P-3 labels and lines, and the P-4b/P-4c texts. Wording in Arabic decides the fiqh meaning (e.g. ربح vs فائدة).

---

## Answers to the zakat story (Z-Q1..Z-Q8)

Story: `docs/product/stories/zakat.md` §14.2. 2026-10-23.

- **Z-Q1 — Giving early.** Yes. The amount counts toward the year and is marked "given before the due date". Conditions: the user held nisab when giving and gave it as zakat (C6). The tag is now **[S]**: Abu Dawud 1624, which al-Albani grades hasan, and Darul Iftaa Jordan Q 2974. Show the C6 help line instead of "source not yet verified". Earliest entry date: the day after the previous year's due date.
- **Z-Q2 — Giving more than due.** Scholars disagree (C7). Hanafi (Deoband 28/76/D=01/1435): the extra may count toward next year if it was given as zakat. Shafi'i (Darul Iftaa Jordan Q 3602): the extra is sadaqah. "Not moved" is valid under both views, so keep it and show the C7 line naming both views.
- **Z-Q3 — Another currency.** Allowed (A7). Which rate counts it is disputed: the rate on the day given (Sahibayn) or on the due date (Abu Hanifa). The user picks (C8). For v1, base currency only is fine, with the C8 help line.
- **Z-Q4 — Leap solar year.** Use **2.577% always.** The NZF page gives 2.577% with no leap-year rule. The 2.5775% figure comes only from a commercial calculator. Also, 2.5 × 366/354.367 = 2.582%, so "2.5775% for 366 days" does not match its own idea. The A2 text is corrected.
- **Z-Q5 — Dividends / profit received only.** A 0.00 line plus the notice is correct. Do not add r × income: zakat is on what is held on the due date (A4). Dividends still held are already cash, and spent ones are gone. Adding r × income would count held dividends twice and charge spent ones. Add to the notice: "If that cash is not in this year's lines, add it as an extra cash line."
- **Z-Q6 — Order of deduction and nisab.** Confirmed: nisab is compared with B **after** the deduction (C4; Council of Ulama Eastern Cape, citing *Radd al-Muhtar* 2/260 **[S]**). With deduction off (the Shafi'i view), the same formula compares the gross total.
- **Z-Q7 — Day 30, and a moved date.** Day 30 in a 29-day month: use the 29th (C3). This is my reading **[U]**, and it is never late. A moved date: yes, values, rates and nisab all use it (C3; Bukhari 1909 **[S]**).
- **Z-Q8 — Recompute after giving.** Yes. Amounts already given count toward the new figure. Any shortfall is still owed, and any extra follows C7 (C9; FatwaCentre 178985 **[S]**).

### Ask at setup vs default (Part C)

| View | App behaviour | Reason |
|---|---|---|
| Month start: Umm al-Qura vs local sighting | **(b) Default Umm al-Qura.** The user moves the date ±1–2 days, with the C3 line. | Sighting is the basis (Bukhari 1909). A converter is needed to give any date at all, and the move covers the gap. |
| Debt deduction before nisab | **(b) Default on** (A5, unchanged) | "Off" is the Shafi'i view, using the same formula (C4). |
| Giving early (most schools vs Maliki) | **(b) Count it**, with the mark and the Maliki line | Most schools allow it. The user decides what to log, and the line names the other view (C6). |
| Amount given above zakat due | **(b) Not moved**, with the line naming both views | Valid under both views (C7). |
| Rate for a gift in another currency | **(a) Ask, no default** (v1 has other-currency entries, OQ-5). Asked once, at the first such entry. A later change applies to new entries only. | Both views are live among Hanafi muftis (C8). |

### Verdict on the zakat story: **BLOCKER** (item 1). Items 2–11: CHANGES_REQUESTED.

1. **BLOCKER — §5.1, §5.2 "First year", AC-6 (changing the calendar or the cycle date).**
   - The problem: today a change rebuilds **due** years as well as open ones (§5.1 says "open or due year"). The first rebuilt year is the first due date on or after the change.
   - Example: lunar, cycle date 1 Ramadan. 1448 AH is open and due about 2027-02-08. On 2026-10-23 the user switches to solar, 20 October. The first new year is "2027", due 2027-10-20.
   - Impact: zakat on wealth whose year ends around 2027-02-08 moves about 8 months later, and the only notification is set for the late date. A due year that gets rebuilt loses zakat that is already owed. Most scholars do not allow delaying zakat that is due (C2).
   - Fix: C2 App rules 1 and 2. Never rebuild a year that is due or later. The first new due date must be on or before the old due date of the open year. Add an AC with this example. This also matches §8 and AC-20 ("never deletes a year").
2. **§5.4 and AC-35 (notification text), Q-O5.**
   - The fixed text "Your zakat for {year} is due today" is false in a below-nisab year. Use a text that is true in both cases (C10).
   - The in-tab due text (§5.4 last bullet, AC-39) needs the three texts of C10, one per result.
   - Drop "following the Shariah file's wording rule (P-3)". P-3 is about payouts, so for zakat this ban is a tone choice, not a Shariah rule.
3. **§4 "settled", §9, AC-26, AC-31:** add the C11 line on every settled year and in the log help. Add an AC that the line shows and that no text says "zakat paid", "accepted" or "fulfilled".
4. **§9 "Given before the due date", AC-28:** replace "source not yet verified" with the C6 help line (now [S]). Refuse entries dated on or before the previous year's due date, and add that to the AC.
5. **§9 "Given more than due", AC-29:** add the C7 line naming both views under "Given {x} more than due".
6. **§9 "Currency", AC-30:** add the C8 help line.
7. **§6.1 dividends notice, AC-15:** append "If that cash is not in this year's lines, add it as an extra cash line." (Z-Q5)
8. **§7 line "Add any other zakatable wealth as an extra line":** extra lines take only cash and good debts. Change it to "Add other cash or money owed to you as an extra line. Add other assets in My Investments." (C5)
9. **§5.1 cycle-date question, AC-1:** add the C1 help text. Without it, a new payer may enter today's date and be told zakat is due today, one year early.
10. **§5.3, Q-O3:** the Shariah view is ±1–2 days for lunar and **earlier only** for solar (C3). Add the C3 Umm al-Qura line under the due date. AC-5 needs a solar case.
11. **§13 rows 3, 8, 11, 14–18 and §14.2:** close Z-Q1..Z-Q8 by pointing to C1–C11. The §14.2 Z-Q4 premise ("AAOIFI uses 2.5775% in a leap year [S]") came from an error in this file. A2 is now corrected.

**Worked numbers re-checked:** the §11 table, and AC-7, 10, 11, 15, 18, 19, 21, 25, 27, 29 and 32. All are correct.

---

## Answers to loop 1 (PM-Q4..Q6)

Story `stories/zakat.md` §14.1b; UX `ux/zakat.md` "Open questions". 2026-10-23.

- **PM-Q4 — Earliest log date in the first year. Approved.** The day after the cycle date one year before the first due date, in that year's own calendar. Why: the user's cycle date is the day wealth reached nisab (C1), so the first hawl starts there. An entry after it is inside the hawl, with nisab held (C6 conditions; Abu Dawud 1624 **[S]**; Darul Iftaa Jordan Q 2974 **[S]**). Story §5.2 already defines it this way. Rule text is now in C6. For every later year, "previous due date" means the real (moved) due date.
- **PM-Q5 — Rate view changed later. Approved: new entries only.** A gift counted under one valid view stays counted. A later change of view does not undo it. This is the maxim "ijtihad is not undone by another ijtihad" (*al-ijtihad la yunqad bi-l-ijtihad*). Al-Suyuti lists it among the general maxims in *al-Ashbah wa al-Naza'ir*. Example: someone whose view of the qibla changes after prayer does not repeat the prayer. — via Mawsu'at al-Qawa'id al-Fiqhiyyah, dorar.net/qfiqhia/1164 **[S]**. Al-Suyuti's text **[U]**. The user may recount an old entry by editing it. That is their own act. Recounting at a higher value is always allowed (Darul Iftaa Mahmudiyyah **[S]**, C8). When the user changes the view, the app tells them: "Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view."
- **PM-Q6 — The "do not delay" line. Yes, show it.** Text: "Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason." Source → C2. Where: due years (Z > 0 or incomplete) and distributing years. Not on open, below-nisab or settled years. Not in the notification. Why: this is the ruling behind the user's choice to give now or wait. Without it the user decides in the dark. Reference: Malik, Ahmad and most scholars — Saudi Permanent Committee via islamqa.info 13981 **[S]**. Late zakat stays a debt — FatwaCentre 178985 **[S]**. The Prophet hurried to give out gold of sadaqah he held, because he did not want it to stay with him overnight — Bukhari 1430 (Uqbah ibn al-Harith; also 851, 1221) **[S]** (ihadis.com/en/bukhari/hadith/1430). "Most scholars" is there because a minority Hanafi report holds the duty is not immediate **[U]**. It is not a tone problem: it has no "late", "missed" or "overdue" in it.
- **C8 with other-currency entries in v1. Confirmed:** ask once, no default, both views named (Sahibayn / Abu Hanifa) with Source. C8 "App" is rewritten, so it no longer says "base currency only".

### Owner decisions checked (owner rule 2026-10-23: on Shariah, this file wins)

| Decision | Shariah check |
|---|---|
| Q-O1 first year only, no earlier years | **Allowed as scope.** But unpaid zakat of past years stays owed (C2). The app must say so once (loop 1 item 1). |
| OQ-1 (a) no year rebuilt; new cycle after the last year | **Compliant**, stricter than C2. The first new year is never longer than one year of its own calendar. If it is shorter, the user is giving early (C6). |
| Q-O3 lunar ±2, solar earlier only | Compliant (C3). |
| Q-O4 days before 0–60, time 09:00 | Product setting. No Shariah issue. |
| Q-O5 notification text per C10 | Compliant. |
| OQ-4 extra given not moved | Compliant (C7). |
| OQ-5 other-currency entries in v1 | Compliant with C8 as rewritten. |
| Tone: no "late / missed / overdue" | Allowed as tone, **only because** the due text stays until the year is started and the PM-Q6 line shows. |
| PM-Q3 (pending) notification off switch | No Shariah issue either way. The due text must stay. |

No owner decision is overruled. One provisional UX/PM pick is reversed: PM-Q6 "not shown" → **shown**.

### Verdict on the zakat story (loop 1) and the UX doc: **CHANGES_REQUESTED**

No BLOCKER. Nothing computes or hides a riba figure. Interest stays out of the base (AC-14) and out of the log (C11).

**Worked numbers re-checked:** §11 table (Σ 520,000.00, B 500,000.00, Z 12,500.00), AC-7, 10 (12,885.00), 11 (517,500.00 / 497,500.00 / 12,437.50), 14, 15, 18, 19, 21, 25 (650,000.00 / 630,000.00 / 510,000.00 / 15,750.00 / 10,750.00), 26, 27 (3,250.00; 12,000.00 → 500.00 more), 29, 30 (5,000.00 / 4,800.00), 32, 42 (2,600.00). All correct. Wrong only in UX examples (UX item 1).

**For the PM (story):**
1. **§5.1 / AC-1 — years before the first year (Q-O1).** On the cycle-date step add: "Zakat from years before {first year} is not counted here. If any of it was not given, it is still owed." Source → C2. Impact: a user whose wealth reached nisab years ago thinks the app's first year is all they owe.
2. **AC-1, §5.1 — solar help text.** AC-1 says solar gets "the same help text", which says "counted in Hijri months". For solar it must read "counted in Gregorian months". The rest stays (C1, A2).
3. **§7 "Open year", AC-23 — "Estimate. Zakat is due on {due date}."** This is the C10 problem again: in a below-nisab year it is false. Use "Estimate. Your zakat year ends on {due date}."
4. **§6.1, §7, §9 — values and rates older than the due date.** A line takes the latest value, FX rate and metal rate on or before the due date. Zakat is on the value on the due date (A3, A7, B3). Show the value date on each line when it is before the due date. Show the rate date with "not the rate of {due date}" when they differ, for lines, the nisab metal rate and log entries. Add: "Zakat is on the value on your due date. If it changed, add a value or rate for {due date}." Do not make the year incomplete. Impact: a share price from months ago can under-state zakat, and the user cannot see it.
5. **§5.2, §9 — "previous year's due date".** Say it means the real due date (moved if moved, C3, C6). Impact: with the computed date, an entry given inside the previous year's real hawl can count for the next year. That is giving two years ahead, beyond the Shafi'i one-year limit.
6. **§9, AC-28 — first year.** Close PM-Q4 (C6). Add an AC: solar 20 October saved 2026-01-05, first year "2026": an entry dated 2025-10-21 is accepted, 2025-10-20 refused.
7. **§9, AC-30 — rate-view change.** Close PM-Q5 (C8 item 3). Add the change text: "Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view."
8. **§5.4 / §7 — PM-Q6.** Add the C10 line to due (Z > 0, incomplete) and distributing years, with Source C2, and an AC (extend AC-39).
9. **AC-28 — "no 'source not yet verified'".** The Maliki clause of the C6 line is still [U]. Its Source sheet marks that clause "source not yet verified". The help line itself stays.
10. **Z6 / A5 — long-term debts.** The debts why-text must state the dispute: "Scholars differ on long-term debts such as a mortgage. Some deduct only the part due in the next 12 months, some the whole debt, some none. This app deducts only what you enter here." (A5). Add it to AC-22's list.

**For UX (ux/zakat.md):**
1. **§2.4.7 log row, §2.5 Z7 live line, §4 distributing sketch — wrong rate pair.** "100.00 USD at 48.00 on 21 Oct 2026 (rate on the day you gave)" and "= 4,800.00 EGP at 48.00 on 21 Oct 2026" are wrong. In Yasmin's data, 48.00 is dated 20 Oct and 50.00 is dated 21 Oct. Day view, entry 21 Oct: "at 50.00 on 21 Oct 2026 (rate on the day you gave) = 5,000.00 EGP". Due-date view: "at 48.00 on 20 Oct 2026 (rate on your due date) = 4,800.00 EGP". Impact: the screen would claim one view while using the other's rate.
2. **§2.5 Z7 rate view.** Name who holds each view in the radio labels: "the rate on the day you gave (Abu Yusuf and Muhammad)" / "the rate on your due date (Abu Hanifa)" (AC-30, C8). Add the PM-Q5 change text to the S8 row (§2.8 item 4).
3. **§2.4.2 Open row.** "Estimate. Zakat is due on {due date}." → "Estimate. Your zakat year ends on {due date}." (PM item 3).
4. **§2.4.2 result card — PM-Q6.** Add the C10 line under the due (Z > 0, incomplete) and distributing cards. Info style.
5. **§2.1 step b — solar help.** Confirmed: "Hijri months" → "Gregorian months". Add the past-years line (PM item 1).
6. **§2.4.4 rows, §2.4.3 nisab row — stale dates.** Show the value date / rate date and the PM item 4 note when it is before the due date.
7. **§2.5 Z6 why — long-term debts dispute** (PM item 10).
8. **§7 Arabic chip "مكتملة" for settled.** In Arabic it reads as "complete", which comes close to "fulfilled" (C11). Use "مسجَّلة بالكامل" (fully logged), or another word that speaks of the record, not the worship. The full Arabic review stays before release.
9. **§9 items 7–8.** Close them: the story no longer rebuilds years, and C8 now covers other-currency entries.

---

## Review of the built Zakat tab (2026-10-24)

Code reviewed: `lib/features/zakat/**`, the `zakat*`, `src_C*`, `src_A4..A8`, `src_B9`, `src_Z4`, `hijriMonth` and `reminder*` keys in `app_en.arb` / `app_ar.arb`.

**Verdict: BLOCKER** (item 1). Items 2–7: CHANGES_REQUESTED.

1. **BLOCKER — a lunar year can disappear after a cycle change (C2).** `yearSlots` / `_slotsOf` end the old cycle at the first slot whose **moved** due date is on or after the new cycle's `from`. `from` is the open year's due date + 1 day. Moving that open lunar year 1–2 days later (allowed by C3) after the change drops the year from the list. Its zakat is no longer shown, and the notification moves to the next cycle. Same harm as the loop-0 BLOCKER: zakat already owed is lost. Rule: a year that existed when the cycle changed must never be dropped. Test the computed key, not the moved date, against the next cycle's start, or start the new cycle after the latest date the open year may be moved to.
2. **Recompute after a base-currency change (C9).** Recompute freezes the year in the new base currency, but gifts keep the old base. Gifts in the old base have no stored rate, so `counted()` fails. Gifts in a third currency are counted in the old base and added to a Z in the new base, so "settled" or "more than due" can be false. Rule: recompute keeps the year's frozen base currency.
3. **Arabic fixes** — `src_C11`, `zakatGiftOverHelp`, `zakatMoveSolarLine`, `src_C9`, `zakatRateViewChanged`. Exact strings: see the handback of this review.
4. **`zakatReasonTrading` uses a fixed "2.5 %"** — wrong for a solar-year user (A2, P-4c). Use the user's r.
5. **Gift sheet live line** — when the rate used is older than the rate date, it must also say "not the rate of {date}" before save (C8 item 4). The saved row already does.
6. **Magic numbers** — `ZakatYear` (`0.025`, `0.02577`) and `_gold`/`_silver` (85, 595) must point to this file (A1, A2, A3).
7. **Editing only the note of an old foreign-currency gift recounts it** with the current view and rate. Allowed by PM-Q5, but only as the user's own choice. Keep the stored view and rate unless the amount, currency or date changes.

Checked and compliant: nisab after the debt deduction; deduction on by default, with the long-term-debt dispute shown; extra lines cash and good debts only, metals refused; due, distributing and settled years kept when the cycle changes (apart from item 1); solar move earlier only, up to 2 days, and lunar ±2; Hijri day 30 → 29; 2.5 % / 2.577 %; gifts counted at the stored rate and view; recompute keeps gifts; "more than due" names both views and is not carried over; C10 due, below-nisab and incomplete texts; "do not delay" line only on due (Z > 0 or incomplete) and distributing years; C11 line on every settled year and in the log help; below-nisab frozen year never reads "Settled"; rate view asked once, no default, both views named; cycle-date help (Hijri / Gregorian); past-years line; notification text per C10, 09:00, 0–60 days. Arabic chip "مسجَّلة بالكامل" approved. ربح / فائدة are used correctly.
