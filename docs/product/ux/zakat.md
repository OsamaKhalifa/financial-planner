# UX flow — Zakat (yearly zakat, its sources, its distribution)

**Owner:** ux-expert · **Status:** v1 draft · 2026-10-23 · Part C (C1–C11) applied · review loop 1 applied (consultant "Answers to loop 1", PM decisions PM-Q1/Q2/Q3/Q7)
**Input:** [story](../stories/zakat.md) (§ and AC numbers point there) · [zakat rules](../shariah/zakat-on-investments.md) (A1…B9, C1…C11; on Shariah wording this file wins, owner 2026-10-23) · [my-investments UX](my-investments.md) (S2…S9 are its screens)
**Platform:** Material 3 with `.adaptive` widgets, `Navigator.push` + bottom sheets (ADR-0002). English + Arabic (RTL).
**Open Shariah items:** none. Texts or clauses still marked **[U]** in the file (day-30 reading C3, Maliki clause C6) show "source not yet verified" in their Source sheet.
**Dates:** examples here read "20 Oct 2026"; the app uses its medium date format in the user's locale (en "Oct 20, 2026", story §5.4).

---

## 0. Decisions this design is built on

| # | Decision | Why |
|---|---|---|
| U1 | **One Year screen (Z2) for every year and every state.** The state decides which blocks show and what is editable. The tab root is Z2 for the *focus year*. | One screen to learn and test; History opens the same screen. |
| U2 | **Focus year** = the oldest year in state *due*, else the oldest *distributing*, else the *open* year. | The tab opens on the year that needs the user. Others: due texts (§2.3) and History. |
| U3 | **Ask only what is missing.** First visit: up to 3 steps (nisab, cycle date, reminder). Later: only the step that became empty. | No re-asking (AC-7); no silent answers (AC-20). |
| U4 | **No new settings screen.** Nisab, cycle date, reminder and the giving-rate view are rows in the Zakat section of **Assumptions (S8)**. The Zakat app bar opens S8 there. | S8 already holds every assumption behind the numbers. |
| U5 | **Start distribution = one tap + Undo** (10 s, only while the log is empty; Undo returns the year to *due*, live). A fixed line under the button says what it does. | Same pattern as S4's one-tap ✓. AC-23, AC-43 (PM-Q7). |
| U6 | **The money math is on the first screen:** result → "How it adds up" → every line. Each figure opens the why sheet (S9) with its Source. | Never bury the math. |
| U7 | **One cycle-date control for both calendars:** dropdowns *Month* + *Day*. No calendar grid: the cycle date has no year. | §5.1; the app has no Hijri picker. |
| U8 | **A calendar or cycle-date change never rebuilds an existing year.** Every year keeps its calendar, due date and r; the new cycle starts the day after the last existing year's due date (C2). | Zakat already owed is never pushed later. |

---

## 1. Screen list

| # | Screen | Kind | Notes |
|---|---|---|---|
| Z1 | **Zakat setup** — steps a/b/c (+ z if the zakat year is not set) | Zakat tab body, one step per page | Shown while an answer is missing. |
| Z2 | **Year screen** | Tab root (focus year) or pushed | Blocks per state, §2.4. |
| Z3 | **Cycle-date control** | Inline component | Z1b and S8. Lives in `widgets/fields.dart` next to `DateField`. |
| Z4 | **Move due date** sheet | Bottom sheet | Lunar −2…+2; solar −2…0. |
| Z5 | **Extra line** sheet | Bottom sheet, add + edit | Cash / good debt only (C5). |
| Z6 | **Debts** sheet | Bottom sheet | One amount in base. |
| Z7 | **Amount given** sheet | Bottom sheet, add + edit | Date, amount + currency, note. |
| Z8 | **History** | Pushed | All years → Z2. |
| S8 | Assumptions | **extended** | Zakat section +4 rows (§2.8). |
| S4 | Item detail | **extended** | Optional frozen-year banner (§2.4.6). |
| S9 | Why sheet | **reused** | New Source strings: A4, A5, A7, A8, B9, C1…C11, Z-4. |

**Navigation:** Zakat app bar: title, **History** icon (Z8), **Assumptions** icon (S8 at Zakat). Pushed screens cover the tab bar. The notification selects the Zakat tab and pushes Z2 of its year (AC-36); if that year no longer exists, the focus year shows.

---

## 2. Flows

### 2.1 First visit — Zakat setup (Z1)

**Entry point:** Zakat tab, while nisab standard or cycle date is missing. Each step: **Next** (primary, enabled when answered) and **Back**. No Skip: no figure can show without these (AC-1, AC-7).

0. **Step z — zakat year**, only if `Settings.zakatYear` is null (today S1 requires it, so this guards broken data). Same radio rows + Source as S8 (A1, A2), nothing pre-selected.
1. **Step a — "Which nisab do you use?"**
   - Two RadioListTiles, **nothing selected**: "Gold — 85 g", "Silver — 595 g". With a metal rate: "= 425,000.00 EGP at your rate of 20 Oct 2026"; without: "Add a gold rate to see it" (not needed to answer).
   - Why line: "Zakat is due only if your zakatable wealth reaches the nisab. Scholars differ on which metal to use for money." + **Source** (S9 → A3; [U] parts → "source not yet verified").
   - Saved on Next (a setting; leaving the tab keeps it).
2. **Step b — "When does your zakat year end?"**
   - **Help (C1, exact):** "Your zakat date is the day your wealth first reached nisab, counted in Hijri months. If you already give zakat on a set date, use that date." Solar: "Hijri months" → "**Gregorian months**" (consultant, loop 1). Under it: "Not today's date, unless that is your zakat date." (stops a new payer being told zakat is due today, a year early).
   - Calendar line: "Hijri calendar (Umm al-Qura), because your zakat year is lunar · Change" (→ S8 zakat-year row).
   - **Z3**, both empty (§2.2).
   - Live card when both are picked: "**Next due date: 1 Ramadan 1448 AH**" / "{weekday} {g-date} 2027". Solar: "**Next due date: 20 Oct 2026**" / "{h-date} AH". "This year is called 1448 AH." Rule: first due date on or after today (Q-O1); no earlier year. Under the card (info style, Source C2, exact): "Zakat from years before {first year} is not counted here. If any of it was not given, it is still owed."
   - Lunar day 30: helper "In a year where this month has 29 days, the 29th is used." (C3)
3. **Step c — "Remind me"**
   - **Days before:** number field with − / + buttons (48 dp), value 0, range 0–60. Helper "0 = on the due date." Outside → "Enter 0 to 60."
   - **Time:** adaptive time picker field, 09:00.
   - Preview: "One notification on {weekday} 20 Oct 2026 at 09:00: 'Your zakat year 2026 ends today. Open to see your zakat.'" (§2.7) Past fire moment: "This time has passed for 2026, so 2026 gets no notification. This tab still shows when its year ends." (AC-40)
   - Line: "Your phone will ask if this app may show notifications. Nothing is sent from your phone."
   - **Save** → one write (cycle date + days + time) → the **system** permission prompt, only if never asked (AC-34). No custom pre-prompt; the line above is the context.
4. **Lands on Z2** of the first year.

**Exits:** Save → Z2. Leaving mid-way → saved nisab stays; reopens at the first missing step. Denied → toast "Notifications are off. This tab still shows when your zakat year ends." (AC-38); never asked again. Write fail → "Could not save. Nothing was changed. Try again."

### 2.2 Cycle-date control (Z3)

Two `DropdownMenu`s on one row (stacked under 360 pt or text scale ≥ 1.3): **Month**, then **Day**. Each ≥ 48 dp. Both empty until picked.

| | Lunar (Hijri) | Solar (Gregorian) |
|---|---|---|
| Month | 12 rows "9 · Ramadan" (number + name) | 12 localized month names |
| Day | 1–30 always | 1–31; days past the month's length disabled (Feb 1–29) |
| Bad combo | none possible | day 31, then April → "April has 30 days. Pick a day." Save blocked (AC-1) |

- Hijri names (EN, consultant to confirm): Muharram, Safar, Rabi' al-Awwal, Rabi' al-Thani, Jumada al-Ula, Jumada al-Akhirah, Rajab, Sha'ban, Ramadan, Shawwal, Dhu al-Qa'dah, Dhu al-Hijjah. AR: محرم، صفر، ربيع الأول، ربيع الآخر، جمادى الأولى، جمادى الآخرة، رجب، شعبان، رمضان، شوال، ذو القعدة، ذو الحجة.
- 29 Feb: helper "In other years, 28 February is used."
- VoiceOver: "Zakat month, Ramadan, 9 of 12" · "Zakat day, 1".

### 2.3 Zakat tab root and the due texts

1. **Due texts** at the top, one per year in state *due*, oldest first (AC-39, C10). Tonal card, info icon, **no red, no warning icon**. Tap → Z2 of that year. No permission needed. Gone once the year is started. Never for an open year. Three versions (C10, exact):
   - Z > 0: "**Your zakat for {year} is due.**"
   - Z = 0: "**Your zakat year {year} ended on {date}. Below nisab: no zakat due.**"
   - Incomplete: "**Your zakat year {year} ended on {date}. Complete it to see your zakat.**"
2. **Z2 of the focus year** below.

### 2.4 Year screen (Z2)

**Order:** header → result card (+ primary action) → given card (frozen) → How it adds up → Investments → Extra lines → Debts → fixed notes. Example = Yasmin's year (story §11).

#### 2.4.1 Header
- Label + **state chip** (text always): *Open · estimate* / *Due* / *Distributing* / *Settled* / *Below nisab: no zakat due* (a frozen Z = 0 year never reads "Settled" alone, C11, AC-31).
- Due date, both calendars. Lunar: "**1 Ramadan 1448 AH**" over "{weekday} {g} 2027", then (C3, exact, bodySmall): "Hijri dates use the Umm al-Qura calendar. If your month began on another day where you live, move your due date." Solar: "**20 Oct 2026**" over "{h} AH".
- **Move date** text button (open and due only; AC-5) → Z4. Moved: "Moved from {computed} (Umm al-Qura)". The Hijri label stays the cycle date.
- Frozen years: "Started on 23 Oct 2026 · Lunar · 2.5 %".

#### 2.4.2 Result card — one per state

| State | Big number | Lines under it | Primary action |
|---|---|---|---|
| Open | **12,500.00 EGP** + chip "Estimate" | "Estimate. Your zakat year ends on {due date}." (C10, loop 1) · "Uses today's values and rates." | none · "You can start distribution from {due date}." |
| Due, complete | **Zakat due 12,500.00 EGP** | "2.5 % of 500,000.00 EGP zakatable wealth ⓘ" · **delay line** | **Start distribution** · "Freezes this year's figures. Later changes to your investments, rates or settings will not change it." |
| Due, below nisab | **0.00 EGP** | "**Below nisab: no zakat due for this year.**" · "Zakatable 420,000.00 EGP · nisab 425,000.00 EGP" ⓘ | **Close this year** (same action, AC-31) · "Freezes this year's figures. No zakat is due." |
| Due, empty (no investment line, no extra line; debts alone do not count) | none | "**Nothing to count yet.**" No Z, no below-nisab text (AC-23, PM-Q1) | **Add investment** (→ Investments tab, S3) · text button **Add a line here** (Z5). Start not offered |
| Incomplete (before start) | none | "**Zakat can't be worked out yet.** {n} things are missing:" + one fix row each (below) · **delay line** if due | none; Start disabled, its tap shows the same list (AC-23) |
| Distributing | **Remaining 7,500.00 EGP** | "Zakat due 12,500.00 · given 5,000.00" + progress bar · **delay line** | FAB **Add amount given** (Z7) |
| Settled | **Settled** | "The amounts you logged reach the zakat due." (C11) + the C11 line (§2.4.7) | FAB **Add amount given** stays |
| Frozen below nisab | **0.00 EGP** | "Below nisab: no zakat due." | none |

**Delay line** (PM-Q6, consultant loop 1, exact; info style: bodySmall, info icon, onSurfaceVariant, no red; tap → S9 Source C2): "Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason." Shown on due years with Z > 0 or incomplete, and on distributing years. Never on open, below-nisab, empty or settled years, never in the notification.

**Fix rows** (≥ 48 dp, text + icon; AC-8, AC-12, AC-16):

| Reason | Fix |
|---|---|
| "USD→EGP rate missing on 20 Oct 2026 · US shares, Loan to my brother" | **Add rate** → inline rate entry (my-investments 2.8) for that date; Fetch only if the date is today |
| "Add a gold rate to see the nisab" (on 20 Oct 2026) | **Add rate** (XAU-g→base) |
| "Is jewellery that is worn zakatable? Not answered · Wedding ring" | **Answer** → S8 jewellery row (Source B2) |
| "How are long-held shares counted? Not chosen · EGX shares" | **Choose** → S8 long-term row; "per item" → S3 of that item |
| "Nisab not chosen" | **Choose** → Z1 step a as a sheet |

Back on Z2 the fixed row is gone; figures appear when the list is empty.

**Start distribution:** one tap → Distributing; snackbar "1448 AH started. Figures frozen. · **Undo**". Below nisab → frozen at once (AC-31); snackbar "1448 AH closed. Below nisab: no zakat due. · Undo".

#### 2.4.3 How it adds up (always open)

`FigureRow`s, end-aligned numbers, each ⓘ → S9:

| Row | Example | Source |
|---|---|---|
| Lines total | 520,000.00 EGP | A7, A8 |
| − Debts within 12 months | −20,000.00 EGP · or "not deducted" | A5 |
| = Zakatable wealth | **500,000.00 EGP** (never below 0) | A5, C4 (nisab after deduction) |
| Nisab · gold 85 g | 425,000.00 EGP · "85 g × 5,000.00 on 20 Oct 2026" (older rate → old-date marker, below) | A3, Z-4 [U] |
| Reaches nisab? | "Yes — 500,000.00 ≥ 425,000.00" / "No — below nisab" | A3, C4 |
| × Rate | 2.5 % (lunar) / 2.577 % (solar, every year) | A1 / A2 |
| = Zakat due | **12,500.00 EGP** | A1 |

- Zakat due why: "Worked out from the zakatable wealth, not by adding the line amounts, so lines can differ by up to 0.01 each."
- Deduction-off why adds C4: "With deduction off, the full total is compared with nisab (Shafi'i view)."
- Nisab ⓘ → **Change** (S8), open and due years only.

**Old-date marker** (consultant loop 1 item 4; due and frozen years, not open years — those are estimates on today's data). A line takes the latest value, FX rate and metal rate on or before the due date (A3, A7). When that date is **before** the due date:
- On the line (and the nisab row, and a log entry's rate): "value from 30 Sep 2026" / "rate from 10 Oct 2026 · not the rate of 20 Oct 2026". Text + clock icon, onSurfaceVariant, never red.
- Once, under this card when any marker exists (exact): "Zakat is on the value on your due date. If it changed, add a value or rate for {due date}."
- **Due years:** each marker has an action — **Add value for 20 Oct 2026** (opens S5 Value of that item, date set to the due date) or **Add rate for 20 Oct 2026** (inline rate entry). Back on Z2 the figures update live. **Frozen years:** marker only; its why sheet says "Recompute to use a newer value."
- The year is **not** incomplete because of an old date; Start stays possible.

#### 2.4.4 Investments (items open at the end of the due date)

S2 two-column row (start ≥ 40 %, end ≤ 60 %, empty lines collapse):

| # | Start | End |
|---|---|---|
| 1 | **Name** | **Zakatable amount in base** (titleMedium) "96,000.00 EGP" |
| 2 | "100 % of 96,000.00 EGP" | "zakat 2,400.00" (bodySmall) |
| 3 | only if unit ≠ base: "2,000.00 USD · converted at 48.00 on 20 Oct 2026" (A7); value or rate before the due date → old-date marker + action (§2.4.3) | — |
| 4 | rule "Stock · trading" + **Source** text button (48 dp) → S9 Part B section | — |

- Order: zakatable amount, highest first; 0.00 rows last. Title "Your investments (5)".
- **0 % rows** stay (AC-13): "0.00 EGP" + reason ("Personal use: 0 % · B5").
- **Dividends-only / profit received only** (AC-15): "0.00 EGP" + "Zakat on your dividends is counted with your cash. If that cash is not in this year's lines, add it as an extra cash line." (Z-1, Z-Q5) or the P-4c text, + button **Add cash line** (Z5, kind cash).
- **Missing rate:** end "—", line 3 "USD→EGP rate missing · Add". Never 1:1.
- **Unanswered question:** end "—", line 2 names it + **Answer**.
- **Interest kept inside:** line 2 "net of 500.00 interest kept inside (to purify)" ⓘ → Z-6 (AC-14).
- **Row tap → S4** (`Navigator.push`). Open/due year: new figures on return, no other step — Z2 watches the same providers (AC-21).
- No item on the due date: "No investments on this date." + **Add investment** (→ Investments tab, S3).

#### 2.4.5 Extra lines and debts

- **Extra lines (2)** + **Add line** (open, due). Row: label | amount in base; line 2 own amount + rate if not base; line 3 "Cash not in the list · B1" / "Money owed to me · B9". Tap → Z5. Frozen: read-only.
- **Debts:** "Debts I must pay within 12 months" | "−20,000.00 EGP"; line 2 "zakat −500.00"; `Switch.adaptive` **Deduct** on its own row (on for a new year, AC-18; off → "not deducted", no minus). Tap amount → Z6. Source A5.

#### 2.4.6 Frozen years (distributing, settled, frozen below nisab)

- **Banner** under the header (tonal, info): "Frozen on 23 Oct 2026. Later changes do not change this year." + **Recompute**.
- Lines, debts, switch, Move date: read-only. Log: editable.
- **Investment row → S4** with a top banner: "1448 AH is frozen. Changes here do not change it. Recompute it to use new values." (AC-24). One optional S4 argument; nothing else in S4 changes.
- **Deleted item:** row stays, no chevron, not tappable, "Deleted from your investments".
- **Recompute** (C9): dialog "Recompute 1448 AH from today's data for {due date}?" + preview "Zakat due: 12,500.00 → 15,750.00 EGP · given stays 5,000.00 EGP" + help (C9) "What you already gave counts toward the new figure." · **Recompute** / Cancel. Dialog, not Undo: it replaces frozen figures. New Z below given → the C7 lines (§2.4.7).

#### 2.4.7 The given card (distributing, settled)

- "**Given 5,000.00 of 12,500.00 EGP**" + LinearProgressIndicator (fills from the start edge) + "Remaining 7,500.00 EGP". VoiceOver: "Given 5,000 of 12,500 Egyptian pounds. Remaining 7,500."
- **Log**, newest first. Row: date | counted amount **in the year's currency**; line 2, other currency only (AC-30, Yasmin's rates: 48.00 dated 20 Oct, 50.00 dated 21 Oct; entry 100 USD on 22 Oct):
  - day view: "100.00 USD · counted at 50.00 on 21 Oct 2026 (rate on the day you gave)" → **5,000.00 EGP**; the rate is older than the entry date → "not the rate of 22 Oct 2026" marker (§2.4.3).
  - due-date view: "100.00 USD · counted at 48.00 on 20 Oct 2026 (rate on your due date)" → **4,800.00 EGP**.
  - line 3: note. Before the due date: "Given before the due date" ⓘ → S9 with the C6 line. Tap → Z7. Delete inside Z7 + Undo (no swipe: one gesture per row).
- **Given more than due** (C7, exact): "Given 500.00 more than due." + "Some scholars (Hanafi) let you count this toward next year if you gave it as zakat. Others (Shafi'i) count it as sadaqah. The app does not move it."
- **On every settled year and in the log help** (C11, exact): "The app counts what you log. It cannot check that each person may receive zakat (Quran 9:60), or that you gave it as zakat. Do not log interest you gave away: it is not zakat."
- Reaching Z by an entry: snackbar "The amounts you logged reach the zakat due for 1448 AH." No celebration, no streak. Never "paid", "accepted", "fulfilled", "your duty is done" (AR: no برئت الذمة, no تقبّل).
- Empty log: "Nothing logged yet. Add each amount you give."

#### 2.4.8 Fixed notes (end of Z2, bodySmall, every state)

"Nisab is checked on the due date only." (A4) · "Gold, silver and all other wealth are added together by value." (A8) · "Based on the lines of this year only. Add other cash or money owed to you as an extra line. Add other assets in My Investments." (Z-4, C5). Each → S9 with its Source (AC-19, AC-22).

### 2.5 Sheets

**Z4 — Move due date** (open, due). Title "Move the due date". Vertical RadioListTiles (no left/right meaning, RTL-safe), each "{weekday} {d Mon yyyy}":
- **Lunar:** −2, −1, computed ("· Umm al-Qura"), +1, +2. Line: the C3 text.
- **Solar:** −2, −1, computed. Line: "You can move a solar date earlier only. Giving early is allowed; giving later delays zakat." (C3, C2)
- Info: "All figures and the notification use the new date. Next year is not affected." **Save**. Frozen years: no button.

**Z5 — Extra line** (add, edit; C5). Kind `SegmentedButton`: **Cash not in the list · Money owed to me** (none pre-selected). Under it: "Other assets (gold, goods for sale, a business) go in My Investments, where each gets its zakat share." + **Open My Investments**. Label (required). Amount > 0 + currency (base pre-filled; not a Shariah setting). Owed to me → required checkbox "The person is able and willing to pay me back." + "A doubtful debt has no zakat until you receive it." + Source B9 (AC-17). Live: "= 24,000.00 EGP at 48.00 on 20 Oct 2026" or "USD→EGP rate missing on 20 Oct 2026 · Add". "Counted in 1448 AH only." **Save**. Edit: **Delete** + Undo.

**Z6 — Debts.** AmountField in base, "Debts I must pay within the next 12 months". Help "Instalments and bills due in the next year." Under it (A5, exact, also in the debts why sheet): "Scholars differ on long-term debts such as a mortgage. Some deduct only the part due in the next 12 months, some the whole debt, some none. This app deducts only what you enter here." + Source A5. **Save**.

**Z7 — Amount given** (add, edit).
- **Date** (`DateField`): last = today (AC-26); **first = the day after the previous year's real due date** (moved if it was moved; C6). First year: the day after the cycle date one year before the first due date, in that year's calendar (C6, PM-Q4 approved; e.g. solar "2026" → first 21 Oct 2025, AC-28). Typed date outside → "Pick a date after {date}, the end of your previous zakat year."
- **Amount > 0 + currency** (unit picker, the year's currency pre-filled; no XAU-g / XAG-g).
- **Other currency:**
  - **Rate view** — asked once, the first time, inline, **nothing selected**, entry not saved until answered (C8, AC-30). Radio labels (consultant, exact): "( ) the rate on the day you gave (Abu Yusuf and Muhammad)" · "( ) the rate on your due date (Abu Hanifa)". Under them: "Scholars differ on the rate." + **Source** C8. Saved to S8; not asked again.
  - Live (entry 22 Oct): day view "= 5,000.00 EGP · counted at 50.00 on 21 Oct 2026"; due-date view "= 4,800.00 EGP · counted at 48.00 on 20 Oct 2026". No rate on or before the rate date → inline "1 SAR = ____ EGP on {rate date}" (stored as a typed rate, AC-42; Fetch only if the date is today). Save blocked until a rate exists; never 1:1.
- **Note** (optional).
- **Before the due date** → live line (C6, exact): "This counts if you held nisab when you gave it and you gave it as zakat. The Maliki school accepts this only shortly before the due date."
- Help (collapsed "About logging"): the C11 line.
- **Save**. Edit: **Delete** + Undo.

### 2.6 History (Z8)

**Entry point:** History icon.
- One row per year, newest due date first (AC-32). Start: label in its own calendar ("1448 AH" / "2026") + state chip; line 2 due date. End: zakat due (open/due: live + "estimate"; incomplete "—"); line 2 "given 5,000.00".
- Lunar and solar years mix after a calendar change, ordered by due date.
- Tap → Z2 (pushed). A past frozen year = §2.4.6, all AC-33 parts shown.

### 2.7 Due-date notification

- One per year, per §5.4. **Text (C10, owner 2026-10-23):** N = 0 "**Your zakat year {year} ends today. Open to see your zakat.**"; N > 0 "**Your zakat year {year} ends on {date}. Open to see your zakat.**" ({date} = due date in the user's locale). True in every case, below nisab included. Never "is due".
- No badge on the tab, no count on the app icon.

### 2.8 Settings afterwards — Assumptions (S8), Zakat section

Existing rows stay (zakat year, long-term, jewellery). Added, each with Title + **Source**:
1. **Nisab standard** — two radio rows, Source A3. Help "Frozen years keep the nisab they were started with."
2. **Zakat cycle date** — "1 Ramadan (Hijri) · Change" → sheet with Z3 + the C1 help.
3. **Reminder** — `SwitchListTile.adaptive` "Year-end notification", **on** once permission is given (AC-44, PM-Q3). Off → nothing scheduled; subtitle "Off. This tab still shows when your zakat year ends." On → "On the due date at 09:00 · Change" → sheet with step c (days before, time). Denied in phone settings: the switch is disabled with "Notifications are off for this app in your phone settings. · Open settings" (OS page; the app never asks again).
4. **Rate for giving in another currency** — "Not asked yet" until Z7 asks; then the two Z7 radio rows + Source C8. On change, snackbar + line under the row (PM-Q5, consultant, exact): "Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view."

**Changing the calendar or the cycle date (C2, U8).** Before saving, a sheet lists what keeps its date, then the new first year:

```
Change to solar (Gregorian)?
These years keep their dates and rate:
  1447 AH · Settled · 18 Feb 2026 · 2.5 %
  1448 AH · Open    · {g} 2027    · 2.5 %   ← its lines stay with it
Your solar cycle starts after {g} 2027.
[ Month ▾ ] [ Day ▾ ]   (Z3, Gregorian, C1 help)
First solar year: 2027, ends 20 Oct 2027 (2.577 %).
                         [Cancel]  [ Save ]
```
- Zakat year radio tap → this sheet (the radio does not change until Save). Cycle-date Change → the same sheet without the calendar line.
- The first new year runs from the day after the last kept year's due date to the first new cycle date after it, so it is never longer than one year.
- Cancel → nothing changes. No records move (Q-O2's move no longer applies).

---

## 3. Every number: label and why

| Number | Where | Label | Why sheet says | Source |
|---|---|---|---|---|
| Zakat due / estimate | Z2, Z8 | Zakat due · Estimate | r × zakatable wealth if ≥ nisab; from B, not rounded lines | A1/A2 |
| Below nisab 0.00 | Z2, Z8 | Below nisab: no zakat due for this year. | B < nisab on the due date | A3, C4 |
| Lines total | Z2 | Lines total | Σ zakatable amounts, converted on the due date | A7, A8 |
| Debts | Z2, Z6 | Debts I must pay within 12 months | on/off by the user | A5, C4 |
| Zakatable wealth | Z2 | Zakatable wealth | lines − debts, not below 0 | A5, C4 |
| Nisab | Z1a, Z2, S8 | Nisab · gold 85 g | grams × metal rate on the due date | A3, Z-4 [U] |
| Rate r | Z2 | × 2.5 % | zakat-year setting; full year, no day factor | A1/A2 |
| Line value | Z2 | 96,000.00 EGP | value at end of due date, market not cost, net of interest kept inside, never inflation-adjusted | Edge cases, Z-6, A6 |
| Line rate | Z2, Z5 | converted at 48.00 on 20 Oct 2026 | latest rate on or before the due date, typed or fetched | A7 |
| Share | Z2 | 100 % of … | the item's rule (`resolve()`) | Part B |
| Zakat on line | Z2 | zakat 2,400.00 | r × zakatable amount, rounded | A1/A2 |
| Given / remaining | Z2 | Given · Remaining | Σ entries in the year's currency; remaining = due − given, not below 0 | C9, C11 |
| Entry in other currency | Z2, Z7 | 100.00 USD · counted at 50.00 on 21 Oct 2026 | the user's rate view (day given: Abu Yusuf and Muhammad; due date: Abu Hanifa); old entries keep their rate | C8 |
| Old-date marker | Z2 | value from / rate from {date} · not the rate of {due date} | zakat is on the value on the due date; add a value or rate for it | A3, A7 |
| Given more than due | Z2 | Given 500.00 more than due. | both views, not moved | C7 |
| Due date | Z1b, Z2 | 1 Ramadan 1448 AH · {g} | cycle date + Umm al-Qura; day-30 rule; moved or not | C1, C3 |

**VoiceOver:** each row = label, value, unit, marker in one phrase. Investment row: "US shares. Zakatable 96,000 Egyptian pounds, 100 percent of 96,000. 2,000 US dollars converted at 48 on 20 October 2026. Zakat on this line 2,400. Stock, trading. Opens the investment." Signs as words.

---

## 4. ASCII sketches (EN, LTR; Arabic mirrors, numbers stay LTR)

**Z2 — Yasmin's year, due, complete**
```
┌──────────────────────────────────────┐
│ Zakat                    [⏱] [⚙]     │
│ 1448 AH                     ( Due )  │
│ {d} {Hijri month} 1448 AH            │
│ Tue 20 Oct 2026          Move date   │
│ Hijri dates use the Umm al-Qura      │
│ calendar. If your month began on …   │
│ ┌──────────────────────────────────┐ │
│ │ Zakat due        12,500.00 EGP  ⓘ│ │
│ │ 2.5 % of 500,000.00 EGP zakatable│ │
│ │ [     Start distribution      ]  │ │
│ │ Freezes this year's figures.     │ │
│ │ ⓘ Most scholars hold that zakat  │ │
│ │ should be given when it falls …  │ │
│ └──────────────────────────────────┘ │
│ How it adds up                       │
│ Lines total          520,000.00 EGP ⓘ│
│ − Debts (12 months)  −20,000.00 EGP ⓘ│
│ = Zakatable wealth   500,000.00 EGP ⓘ│
│ Nisab · gold 85 g    425,000.00 EGP ⓘ│
│ Reaches nisab?                  Yes ⓘ│
│ × Rate (lunar)               2.5 %  ⓘ│
│ = Zakat due           12,500.00 EGP ⓘ│
│ Your investments (5)                 │
│ US shares             96,000.00 EGP  │
│ 100 % of 96,000.00      zakat 2,400  │
│ 2,000.00 USD · at 48.00 on 20 Oct    │
│ Stock · trading        [Source]      │
│ Home                       0.00 EGP  │
│ Personal use: 0 %      [Source]      │
│ Extra lines (2)          [Add line]  │
│ Debts within 12 months −20,000.00 EGP│
│ Deduct                        (on)   │
│ Nisab is checked on the due date only│
└──────────────────────────────────────┘
```

**Z2 — distributing (top)**
```
│ 1448 AH                 (Distributing)│
│ Started on 23 Oct 2026 · Lunar · 2.5 %│
│ ⓘ Frozen on 23 Oct 2026.  [Recompute]│
│ Remaining              7,500.00 EGP  │
│ Zakat due 12,500.00 · given 5,000.00 │
│ ██████████░░░░░░░░░░░░░░░            │
│ 22 Oct 2026              5,000.00 EGP│
│ 100.00 USD · counted at 50.00 on     │
│ 21 Oct 2026 (rate on the day you gave)│
│ Masjid                               │
│ ⓘ Most scholars hold that zakat      │
│ should be given when it falls due, … │
│                  [ + Add amount given]│
```

---

## 5. Exit states

| Flow | Success | Cancel | Error |
|---|---|---|---|
| Setup Z1 | Z2 of the first year | leave tab → resumes at the first missing step | write fail: nothing saved, told so |
| Start / Close | frozen + Undo | Undo within 10 s, log empty | refused with reasons when incomplete |
| Z4–Z7 | sheet closes, Z2 updated | swipe down; "Discard changes?" if typed | inline: amount > 0, date window, good-debt checkbox, rate needed, days 0–60 |
| Recompute | new frozen figures, log kept | Cancel | write fail: old figures kept |
| Calendar / cycle change | new cycle after the last kept year | Cancel: nothing changes | — |

## 6. Edge cases

- **Empty — no investment line, no extra line** (a debts figure alone does not count): result card "Nothing to count yet." + primary **Add investment** (→ Investments tab, S3) + **Add a line here** (Z5). No Z, no below-nisab text, no Start (AC-23, PM-Q1).
- **No network:** nothing needs it. Fetch only in a rate fix dated today.
- **Several due years:** one due text each; focus = oldest; each started on its own.
- **Large numbers:** full digits with grouping, never "1.2M". Large text: label above number; end column moves under start (S2 rule).
- **Debts > lines:** B = 0.00, below nisab; never negative.
- **Base currency change:** open and due years recompute (may become incomplete for new rates); frozen years and their logs keep their currency (AC-30).
- **Below nisab on the due date:** cycle date kept (C4, v1); giving on the next date counts as early, never "late".
- **Day 30 / 29 Feb:** Z3 helpers; the date shown is the real one.
- **Device time zone change:** reminder follows device time; no UI.

## 7. Shariah surface

- Z1a: both metals, nothing selected, Source A3. Z1b: C1 help. Z1c: none.
- Z2: r, nisab, each share, each rate, debts, below-nisab, each extra line → A1/A2, A3, Part B, A7, A5/C4, B1/B9 (AC-22). A4, A8, Z-4/C5 notes always. Umm al-Qura line (C3). No inflation figure anywhere (A6).
- Due texts: three C10 versions. Notification: C10 "ends today / ends on {date}" text (§2.7).
- Z1b: past-years line (C2). Z2: delay line (C2, PM-Q6) on due (Z > 0, incomplete) and distributing years; old-date markers (A3, A7). Z6: long-term debts dispute (A5).
- Log: C6 line on early entries, C6 date window (real previous due date; first year per PM-Q4), C7 two-views line, C8 rate view (asked, no default, views named), PM-Q5 change text, C11 line on settled years and in log help. Recompute: C9.
- Banned on every Zakat screen: "zakat paid", "accepted", "fulfilled", "your duty is done" (C11). Kept as tone (C10 note): no "late", "missed", "overdue"; helper says "0 = on the due date", not "default". Due texts are info colour, never error.
- Consultant reviews the Arabic of: due texts, notification text, C1/C3/C6/C7/C8/C11 lines, below-nisab label, Z5 texts, state chips (مفتوحة · مستحقة · قيد التوزيع · مسجَّلة بالكامل · دون النصاب: لا زكاة واجبة). Settled is "مسجَّلة بالكامل" (fully logged), never "مكتملة" (reads close to "fulfilled", C11), Hijri month names.

## 8. RTL and accessibility

- Rows mirror (start = right). Each amount + unit, %, rate and Gregorian date is one LTR isolate; Hijri dates in Arabic read RTL ("1 رمضان 1448 هـ"), "AH" → "هـ". Digits follow the device locale.
- Progress bar and chevrons mirror. Z4 options are vertical, so no direction issue.
- Targets ≥ 48 dp (Source buttons too). Chips, fix rows and due texts carry words, not only colour. Dynamic Type: the result number wraps under its label.

## 9. Where this departs from the story

Undo (AC-43), "Close this year" (AC-31), the empty state (AC-23), the notification switch (AC-44), the calendar change (AC-6, C2) and other-currency entries (AC-30, C8) are now in the story. Left:

1. **"Add cash line"** shortcut on dividends-only rows; **Open My Investments** in Z5.
2. **Recompute preview** (old → new) in its dialog.
3. **Frozen-year banner on S4.**
4. **Old-date actions** "Add value / rate for {due date}" (consultant loop 1 item 4 asks for the marker and the note; the action is UX).

---

## Decisions log (all closed)

- **PM-Q1** empty year → "Nothing to count yet" (PM, AC-23). **PM-Q2** "Close this year" (PM, AC-31). **PM-Q3** notification on/off (owner, AC-44). **PM-Q7** one tap + Undo (PM, AC-43).
- **PM-Q4** first-year earliest log date, **PM-Q5** rate-view change → new entries only, **PM-Q6** delay line shown → consultant "Answers to loop 1".
- **For the PM:** AC-23 still reads "Estimate. Zakat is due on Oct 20, 2027."; the UX uses the consultant's "Estimate. Your zakat year ends on {due date}." (loop 1 item 3). AC-30 names the views "(Sahibayn)"; the UX labels use "(Abu Yusuf and Muhammad)" (loop 1 UX item 2).
