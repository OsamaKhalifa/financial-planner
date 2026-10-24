# Story — Zakat (yearly zakat, its sources, and its distribution)

**Status:** v1 draft · 2026-10-23 · PM hat · 2026-10-23: owner scope change (notification §5.4, "Start distribution" §8, log §9) · owner answers Q-O1…Q-O7 · **review loop 1 applied** (consultant BLOCKER item 1 + items 2–11, Part C C1–C11; owner rule: on a Shariah question the consultant's ruling wins)
**Owner:** @OsamaKhalifa
**Shariah input:** [zakat-on-investments.md](../shariah/zakat-on-investments.md) — every zakat rule below comes from that file; section names (A1, B9, C2, …) point into it. Yearly zakat rules are **Part C (C1–C11)**. No rule here is new.
**Relation to BRD:** this story is **UC-3 (Calculate my zakat)**. It reads the list of [my-investments.md](my-investments.md) and does not change it. Today the Zakat tab is empty (`lib/features/zakat/presentation/zakat_screen.dart`).

---

## 1. Who

- **Yasmin** (Salaried Saver) — cash, gold, a fund; one currency; gives zakat once a year on a Hijri date.
- **Khaled** (DIY Investor) — shares in more than one currency; needs each holding converted on the due date; may give zakat in another currency.

## 2. What

Be told when my zakat year ends, see how much zakat I owe for that year and where each part comes from, freeze that result when I start giving it out, and log what I give, in any currency, until the logged amounts reach the zakat due.

## 3. Why (the financial outcome)

**Pain today:**
- The list in My Investments already holds the values, the zakat share and its source per item. To get the yearly amount, the user must still redo by hand: value on one exact date, convert each currency at that date's rate, apply each share, add wealth not in the list, deduct short-term debts, price the nisab in gold or silver on that date.
- A Hijri due date moves about 11 days a year against the Gregorian calendar, so the date itself is easy to lose (owner decision 2026-10-23: one local notification per year).
- After giving in several parts and currencies, the user has no record of how much of which year is still to give. Market research: Zoya ties zakat to the holding list; Musaffa keeps a record of zakat paid ([my-investments-market.md](../research/my-investments-market.md)). Neither shows both with a source per line.

**Outcome:** for each zakat year, on its due date, one amount in the base currency — **zakat due**, or **0 because below nisab** — with every line that makes it up and its rule, and **remaining** = due − distributed. The user gives the right amount, from the right date, and can show how it was reached.

---

## 4. Terms used in this story

| Term | Meaning |
|---|---|
| **Zakat year setting** | Existing setting (`Settings.zakatYear`): **lunar** r = 2.5 % or **solar** r = 2.577 % (A1, A2; a 366-day solar year still uses 2.577 %, C1). Here only r is used: no T/Y factor (A1). |
| **Cycle date** | The day + month the user's zakat year ends on: a **Hijri** day + month (lunar) or a **Gregorian** day + month (solar). No year (C1). |
| **Zakat year** | One cycle. It ends on its **due date** = the cycle date in that calendar year. Label: the Hijri year of the due date ("1447 AH") or the Gregorian year ("2026"). |
| **Due date** | The Gregorian date the year ends. Lunar: the cycle date converted with the **Umm al-Qura** calendar (converter: architect). The user may move it (§5.3, C3). |
| **Line** | One source of zakatable wealth in a year: an investment, an **extra line**, or the **debts** line. |
| **Extra line** | Wealth not in My Investments, typed on one year: **cash not in the list** (B1) or **money owed to me — good debt** (B9, C5). Nothing else. |
| **Zakatable base** | Σ zakatable amounts of all lines − debts (if deducted), not below 0. |
| **Year state** | **open** (due date after today, live estimate) → **due** (due date today or past, live, not started) → **distributing** (started: result frozen) → **settled** (the amounts logged reach the zakat due; that is all it means, C11). |
| **Distributed / remaining** | Distributed = Σ counted amounts of the log entries, in the year's base currency (§9). Remaining = max(0, zakat due − distributed). |

## 5. The zakat year

### 5.1 Cycle date — asked, never defaulted
- Asked the first time the Zakat tab is used, in the calendar of the zakat year setting: lunar → Hijri day 1–30 + Hijri month; solar → Gregorian day + month (29 February allowed). Nothing pre-filled. Help text (C1): **"Your zakat date is the day your wealth first reached nisab, counted in {Hijri | Gregorian} months. If you already give zakat on a set date, use that date."** ("Hijri" for lunar, "Gregorian" for solar; C1, A2.) Also shown on this step (per consultant C2): **"Zakat from years before {first year} is not counted here. If any of it was not given, it is still owed."** ({first year} = the label of the first year, §5.2.)
- **Changing the zakat year setting (lunar ↔ solar) asks the cycle date again**; the change is not saved until it is given (owner).
- **A change of calendar or cycle date never rebuilds a year** (per consultant C2; owner pick (a), OQ-1). Every existing year — open, due, distributing or settled — keeps its calendar, label, due date, r, lines and notification. The new calendar / cycle date applies from the year **after** the last existing year: its due date is the first new-cycle date after that year's due date. The user is told "The new date applies from the year after {label}." Why: zakat already due, or about to be due, must not be pushed later (C2). A first new year shorter than a hawl is giving early, which is allowed (C2, C6); every later solar year is about 11 days longer, which r = 2.577 % covers (C2 rule 3).

### 5.2 Due dates
- **Lunar:** due date of Hijri year H = Umm al-Qura Gregorian date of (cycle day, cycle month, H). If that month has 29 days in year H and the cycle day is 30, the 29th is used (per consultant C3: never later than the real end of the year).
- **Solar:** cycle day + month in each Gregorian year; 29 February → 28 February in a non-leap year (same "last day of the month" rule as my-investments §5.6). Never later than the real anniversary.
- A year runs from the day after the previous year's due date to its own due date, inclusive. "Previous year's due date" always means its **real** due date — the moved date if it was moved (§5.3; per consultant C3, C6). For the first year, "previous due date" = the cycle date one year before its due date, in the same calendar (per consultant C6, PM-Q4). The next year exists from the day after a due date, whatever the state of the past year.
- **First year:** the year whose due date is the first on or after the day the cycle date is saved. The app creates no earlier year (owner, Q-O1).

### 5.3 Moving a due date (moon sighting) — per consultant C3
- **Lunar:** the user may move the due date of an open or due year at most **2 days earlier or later** than the computed date. Under every Hijri due date: **"Hijri dates use the Umm al-Qura calendar. If your month began on another day where you live, move your due date."**
- **Solar:** at most **2 days earlier**, never later (moving later delays zakat for no reason, C2).
- The moved date is that year's due date for every figure (values, rates, nisab), for its state and for its notification (§5.4). The label does not change. The next year is computed from the cycle date again, not from the moved date (no drift).

### 5.4 Year-end notification (owner decision 2026-10-23; text per consultant C10)
- **One local notification per zakat year.** Scheduled on the phone only: no server, no network request to schedule or show it.
- **When (owner, Q-O4):** two settings next to the cycle date, both chosen by the user: **days before** N, a whole number **0–60**, default **0** (= on the due date itself); and **time of day**, default **09:00** device time. Fire moment = (due date − N days) at that time. Why 0–60: owner choice. These are product settings, not Shariah settings, so defaults are allowed.
- **Text (per consultant C10):** N = 0 → **"Your zakat year {year} ends today. Open to see your zakat."**; N > 0 → **"Your zakat year {year} ends on {date}. Open to see your zakat."** ({date} = the due date). {year} = the year's label ("1448 AH", "2027"). Why: when it is scheduled, the app does not know whether the year will reach nisab, so it must not say zakat is due (C10, A3). Tone choice (owner): no notification or due text uses "late", "missed", "overdue" or "default".
- **Opening it lands on that zakat year.**
- **On / off (owner, PM-Q3):** a third setting next to days before and time. **On by default** once permission is given. Off → no notification is scheduled (the scheduled one is removed); the due text on the Zakat tab still shows. On again → the coming notification is scheduled per the rules below.
- **Dates in texts:** every date in a notification or Zakat-tab text uses the app's medium date format in the user's locale; ACs give the **en** form (e.g. "Oct 20, 2027").
- **Scheduling:** the app keeps **at most one** notification, for the coming due date (the first on or after today), checked at every app start and after every change of due date, days before or time. A change of calendar or cycle date does not move it (§5.1: the coming year keeps its due date). If the fire moment is already past, that year gets none. If the year is already distributing at the fire moment, none is shown. **Known limit:** with no background work, if the app is not opened between two due dates, the second one is scheduled only at the next app start after the first.
- **Permission:** asked in context, when the user saves the cycle date and the app has not asked before. **Never on first launch**, never at any other time. Denied → no notification; everything else works, including the due text below.
- **Due text on the Zakat tab** (per consultant C10), for every year in state **due**, with its due date; it needs no permission and goes away when the year is started:
  - Z > 0: **"Your zakat for {year} is due."**
  - Z = 0: **"Your zakat year {year} ended on {date}. Below nisab: no zakat due."**
  - Incomplete (§7): **"Your zakat year {year} ended on {date}. Complete it to see your zakat."**
- **"Do not delay" line** (per consultant C2 / PM-Q6): **"Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason."**, with Source → C2. Shown on years that are **due with Z > 0**, **due and incomplete**, and **distributing**. Not on open, below-nisab or settled years. Not in the notification.

## 6. What goes into a year (lines)

### 6.1 One line per investment
- Every My Investments item **open at the end of the due date** gets a line. Items started after the due date, or closed (full sale) on or before it, get none. Items with share 0 % (e.g. personal home, company pays zakat) get a 0.00 line with their reason, so nothing is hidden.
- **Value** = the item's value at the end of the due date as My Investments computes it (my-investments §5.4: last value update, flows, gold/silver grams × metal rate), **net of held interest H** (Z-6). Market value, never cost (Shariah file "Edge cases": loss positions). Never inflation-adjusted (A6.1).
- **Rate** = the latest rate for the pair on or before the due date (my-investments §6.1 lookup). The line shows "converted at {rate} on {rate date}" (A7). A rate dated after the due date is never used. **Missing rate** → the line shows "{from}→{base} rate missing", never 1:1; the year is **incomplete** (§7).
- **Older than the due date** (per consultant, A3, A7, B3): the line shows its **value date** (the date of the latest value update or money in/out on or before the due date; gold/silver: the metal rate's date) when it is before the due date, and a rate's date with "not the rate of {due date}" when they differ. With either, the line shows: **"Zakat is on the value on your due date. If it changed, add a value or rate for {due date}."** The year is **not** made incomplete by this. The same applies to the nisab metal rate (§7) and to log entries (§9, against their rate date).
- **Share** s and **source section** = `resolve()` in `zakat_rules.dart`, the same rule the item uses today (Part B). If the rule needs an answer the user has not given (jewellery ruling, long-term method), the line shows which question to answer and the year is incomplete. Nothing is filled in.
- **Dividends-only** stocks/funds and private equity on **"profit received only"**: s = 0, line 0.00, with the notice **"Zakat on your dividends is counted with your cash. If that cash is not in this year's lines, add it as an extra cash line."** (Z-1, Z-Q5 answer) or the P-4c text. No r × income is added (Z-Q5: zakat is on what is held on the due date, A4).
- **Zakatable amount** = value in base × s.
- Picking an item line opens that investment's detail, where the user sees and edits it. An open or due year shows the change on return, with no other step. A distributing or settled year does not change (§8); the user is told to recompute it to use new values. A deleted item's line in a frozen year stays, and opens nothing.

### 6.2 Extra lines (on one year) — C5
- Fields: label, amount (> 0), currency, kind: **cash not in the list** (B1) or **money owed to me** (B9). Share 100 %. No other kind: gold, goods held for sale or a business go in My Investments, where Part B gives each its share (C5).
- "Money owed to me" is accepted only when the user states the debtor is able and willing to pay (good debt, B9). A doubtful debt is not a line; the text says: "A doubtful debt has no zakat until you receive it." (B9, IIFA Res 1 (1/2)).
- Converted at the rate on the due date, like an item (A7). They belong to that year only. The next year starts with no extra lines.
- Picking an extra line in an open or due year edits it.

### 6.3 Debts I must pay within 12 months (A5, C4)
- One amount per year, in the base currency, default 0. **Deduction on by default**; the user may turn it off (A5; "off" is the Shafi'i view, same formula, C4).
- When on, it is one negative line. When off, it shows as "not deducted".
- Its why-text (A5) states the dispute: **"Scholars differ on long-term debts such as a mortgage. Some deduct only the part due in the next 12 months, some the whole debt, some none. This app deducts only what you enter here."**

## 7. Formulas (all `Decimal`; amounts in base currency)

- `L_i` = zakatable amount of line i (items and extra lines).
- `debts` = the A5 amount if deduction is on, else 0.
- `B = max(0, Σ L_i − debts)` — the **zakatable base**, compared with nisab **after** the deduction (C4, Z-Q6 answer).
- `nisab = grams × metal rate on the due date`; grams = 85 (gold) or 595 (silver), the user's **nisab standard** (A3). Asked once, nothing pre-selected, then a setting the user may change. Metal rate = the latest on or before the due date; if it is older, the §6.1 "older than the due date" date and note show.
- **Zakat due** `Z = round2(r × B)` if `B ≥ nisab`, else **0**, labelled "Below nisab: no zakat due for this year." r = 2.5 % lunar or 2.577 % solar, also in a 366-day solar year (A1, A2, C1).
- Per line, shown for "where it comes from": `round2(r × L_i)`, and `−round2(r × debts)` for the debts line. Z is computed from B, not from the rounded lines; they may differ by up to 0.01 per line.
- All wealth is added together by value, gold and silver included (A8); the line "Gold, silver and all other wealth are added together by value." is shown.
- Shown with the nisab result: "Nisab is checked on the due date only." (A4) and **"Based on the lines of this year only. Add other cash or money owed to you as an extra line. Add other assets in My Investments."** (Z-4, C5).
- **Incomplete year:** any line with a missing rate or an unanswered question, no nisab standard, or no metal rate for it → no Z is shown, the reasons are listed, and distribution cannot start.
- **Empty year:** no investment line and no extra line (a debts figure alone does not count) → "Nothing to count yet.", no Z, no below-nisab verdict, and distribution cannot start (PM-Q1). Why: B = 0 here means the app knows nothing, so "below nisab" would not be true.
- **Open year** (due date after today): figures use the latest values and rates on or before today, labelled **"Estimate. Your zakat year ends on {due date}."** (per consultant C10: true also when the year ends below nisab; A3, A7: values on the due date).

## 8. Start distribution (replaces "confirm")

- **Start distribution** is offered only in state **due** (due date today or past) and when the year is complete and not empty. It freezes: every line (name, value, unit, rate, rate date, share, source, amount), debts and its on/off, nisab standard, metal rate and amount, r, base currency, B and Z, and the start date. State → **distributing**; with Z = 0 (below nisab) the same action is named **"Close this year"** (PM-Q2: there is nothing to distribute) and the year is settled at once, shown as **"below nisab: no zakat due"**, never "settled" alone (C11).
- **Undo** (PM-Q7): starting (or closing) takes one action, with no extra question. **Undo** is offered for 10 seconds after it, only while the log is empty; it returns the year to **due**, live, as before. It is the user's own act, so it does not break "the app never deletes a year by itself".
- A **frozen year (distributing or settled) never changes by itself**: later value updates, rate edits, setting changes (nisab standard, zakat year, base currency), and item edits or deletions leave it as it was.
- **Recompute** (a distributing or settled year; per consultant C9): recomputes every line from today's data for that due date and freezes the new result in one step. The log stays exactly as it is and counts toward the new Z; any shortfall is still to give. State: settled if distributed ≥ new Z, else distributing. If the new Z is below distributed, the §9 "more than due" texts show.
- The app never starts distribution, recomputes or deletes a year by itself. A due year not started stays **due** (C2: its zakat is owed). The only automatic state changes: open → due when the due date comes (or a moved due date passes), and distributing ↔ settled by the rule above.

## 9. Distribution log

- An entry = date, amount (> 0), **currency** (any currency of the unit list; not XAU-g / XAG-g), optional note. Added to a distributing or settled year. Editable and deletable. No entries on an open or due year.
- **Entry date:** not after today, and **after the previous year's due date** (C6: keeps the entry inside the year's own hawl). On or before it → refused. "Previous year's due date" = its real (moved) date; first year: the §5.2 "previous due date" (per consultant C6, PM-Q4).
- **Counted amount** (in the year's frozen base currency): an entry in that currency counts as is. An entry in another currency (owner OQ-5; per consultant C8) counts `round2(amount × rate)`, with the rate = the latest rate for the pair on or before the **rate date** (my-investments §6.1 lookup, inverse included):
  - **View 1 — the day given** (Sahibayn: Abu Yusuf and Muhammad): rate date = the entry date.
  - **View 2 — the due date** (Abu Hanifa): rate date = the year's due date.
  - The entry shows "counted at {rate} on {date of that rate}", and "not the rate of {rate date}" when the two dates differ (§6.1).
- **Rate view** — a Zakat setting, next to the cycle date, nisab standard and notification settings. **Asked, no default** (C8; "Ask at setup vs default (Part C)"), the first time the user logs an entry in a currency other than the year's base, with both views and their references. Later it can be changed there. The view used is stored on each entry; a change applies to **new entries only** (per consultant C8, PM-Q5: a gift counted under one valid view stays counted). When the user changes it, the app says: **"Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view."** Editing an entry's amount, currency or date counts it with the current view; editing only its note keeps the rate and view it was saved with.
- **Missing rate:** the entry cannot be saved until the user types the rate for that pair on the rate date. It is stored as a manual dated rate, like any other (my-investments §6.1), and used. Never 1:1.
- **Distributed** = Σ counted amounts; **remaining** = max(0, Z − distributed). When distributed ≥ Z → **settled automatically**; if an edit or deletion drops it below Z → distributing again.
- **Given before the due date** (per consultant C6, [S]): counts toward the year, marked "given before the due date", with the help line **"This counts if you held nisab when you gave it and you gave it as zakat. The Maliki school accepts this only shortly before the due date."** Its Source marks the Maliki clause "source not yet verified" (C6: [U]).
- **Given more than due** (per consultant C7): shows **"Given {x} more than due."** and under it **"Some scholars (Hanafi) let you count this toward next year if you gave it as zakat. Others (Shafi'i) count it as sadaqah. The app does not move it."** Moving it to next year is not in v1 (owner OQ-4; valid under both views, C7).
- **What "settled" claims** (per consultant C11): on every settled year and in the log help: **"The app counts what you log. It cannot check that each person may receive zakat (Quran 9:60), or that you gave it as zakat. Do not log interest you gave away: it is not zakat."** No text in the Zakat tab says "zakat paid", "accepted", "fulfilled" or "your duty is done" (Arabic: no برئت الذمة, no تقبّل).

## 10. History

- All years, newest due date first. Each: label in its own calendar ("1447 AH" / "2026"), due date, zakat due (open or due: the live figure, marked "estimate"), distributed, state (open · due · distributing · settled; a settled year with Z = 0 reads "below nisab: no zakat due").
- Each year has a detail: due date (and the computed date if moved), calendar and r, nisab standard / rate / amount, every line, debts, B, Z, start date, log entries (date, amount, currency, rate and rate date if any, counted amount, note), distributed, remaining, state.

---

## 11. Acceptance criteria

**Yasmin's year** (used below unless stated): base **EGP**, zakat year **lunar** (r = 2.5 %), nisab **gold 85 g**, a year whose due date is **D = 2026-10-20**, today **2026-10-23**, state **due**. Money ACs fix D directly; the calendar ACs (AC-1…AC-6) check how D is derived. Rates: XAU-g→EGP **5,000.00**, XAG-g→EGP **60.00**, USD→EGP **48.00**, all dated 2026-10-20; USD→EGP **50.00** dated 2026-10-21. Value dates: Savings' last value update is dated **2026-10-01**; every other item's value is dated D. Locale **en** for every text.

| Line | Rule | Value at end of D | In EGP | Share | Zakatable | Zakat on line | Source |
|---|---|---|---|---|---|---|---|
| Savings | cash deposit | 120,000 EGP | 120,000.00 | 100 % | 120,000.00 | 3,000.00 | B1 |
| Gold bar | gold, 50 g, 24k | 50 XAU-g | 250,000.00 | 100 % | 250,000.00 | 6,250.00 | B2 |
| US shares | stock, trading | 2,000 USD | 96,000.00 | 100 % | 96,000.00 | 2,400.00 | B3 |
| EGX shares | stock, long-term, 25 % proxy | 80,000 EGP | 80,000.00 | 25 % | 20,000.00 | 500.00 | B3 |
| Home | other, personal use, 0 % (user confirmed) | 3,000,000 EGP | 3,000,000.00 | 0 % | 0.00 | 0.00 | B5 |
| Cash at home | extra, cash | 10,000 EGP | 10,000.00 | 100 % | 10,000.00 | 250.00 | B1 |
| Loan to my brother | extra, owed to me (good) | 500 USD | 24,000.00 | 100 % | 24,000.00 | 600.00 | B9 |
| Debts within 12 months | deducted | 20,000 EGP | −20,000.00 | — | −20,000.00 | −500.00 | A5 |

Σ L_i = 520,000.00 · B = **500,000.00** · nisab = 85 × 5,000 = **425,000.00** · Z = 0.025 × 500,000 = **12,500.00**.

**Cycle and due dates (§5.1–5.3)**

- **AC-1** Given zakat year lunar and no cycle date, When the user opens the Zakat tab, Then a Hijri day (1–30) and Hijri month are asked, nothing pre-filled, with the C1 help text "Your zakat date is the day your wealth first reached nisab, counted in Hijri months. If you already give zakat on a set date, use that date.", and no zakat figure shows until both are given. Given solar, Then a Gregorian day + month is asked with the help text "Your zakat date is the day your wealth first reached nisab, counted in Gregorian months. If you already give zakat on a set date, use that date.", 29 February accepted, 31 April refused. Given solar, 20 October, being saved on 2026-01-05, Then the step also shows "Zakat from years before 2026 is not counted here. If any of it was not given, it is still owed." (C2); given lunar 1 Ramadan saved on 2026-10-23, Then it names "1448 AH".
- **AC-2** Given lunar, cycle date 1 Ramadan, Then year **1447 AH** is due **2026-02-18** and **1448 AH** is due **2027-02-08** (Umm al-Qura; both verified 2026-10-23), and each shows the C3 line "Hijri dates use the Umm al-Qura calendar. If your month began on another day where you live, move your due date." Given cycle day 30 and a year in which that month has 29 days in Umm al-Qura, Then the due date is the 29th.
- **AC-3** Given solar, cycle date 20 October, Then year **"2026"** is due **2026-10-20** and **"2027"** is due **2027-10-20**. Given 29 February, Then 2027 → **2027-02-28**, 2028 → **2028-02-29**.
- **AC-4** Given solar, 20 October, saved on 2026-01-05, Then the first year is "2026" (due 2026-10-20) and no earlier year exists (owner, Q-O1); Given instead 20 October saved on 2026-10-21, Then the first year is "2027" and no "2026" exists; on 2026-10-19 "2026" is **open**, on 2026-10-20 **due**. On 2026-10-21, Then "2027" exists and is **open**, and "2026" stays **due** until the user starts distribution.
- **AC-5** Given AC-2's 1447 AH (computed 2026-02-18), When the user moves the due date to 2026-02-16 or 2026-02-20, Then it saves and every figure of 1447 AH uses the moved date; to 2026-02-15 or 2026-02-21, Then it is refused. The label stays "1447 AH" and 1448 AH's due date does not change. Given solar "2027" (computed 2027-10-20), Then 2027-10-18 and 2027-10-19 save; 2027-10-17 and **2027-10-21** are refused (solar: earlier only, C3). Given a distributing year, Then its due date cannot be moved.
- **AC-6** (consultant C2 example) Given lunar, cycle date 1 Ramadan, today 2026-10-23, settled 1447 AH (due 2026-02-18, Z 12,500.00) and open **1448 AH (due 2027-02-08)** with one extra line and its notification scheduled, When the user switches the zakat year setting to solar and gives 20 October, Then the user is told "The new date applies from the year after 1448 AH."; 1447 AH is unchanged; 1448 AH keeps its label, due date **2027-02-08**, r = 2.5 %, its extra line and its notification; the next year is **"2027", due 2027-10-20**, r = 2.577 %; no year due after 2027-02-08 replaces 1448 AH. Given instead a year in state **due** (or distributing) when the change is made, Then it keeps its calendar, due date and r, and the new cycle applies from the year after the open year. Given solar 20 October and open "2027" (due 2027-10-20), When the user changes the cycle date to 1 March, Then "2027" keeps 2027-10-20 and the next year is "2028", due 2028-03-01.

**Nisab (§7)**

- **AC-7** Given no nisab standard, When the user opens a year, Then gold 85 g and silver 595 g are asked with both references (A3), nothing pre-selected, and no Z shows until answered; it is not asked again after that. Given Yasmin's year, Then nisab = **425,000.00 EGP** "on 2026-10-20"; Given silver, Then **35,700.00 EGP** (595 × 60).
- **AC-8** Given no XAU-g→EGP rate on or before D, Then the nisab reads "Add a gold rate to see the nisab", no Z shows, and the year is incomplete.

**Lines and the total (§6, §7)**

- **AC-9** Given Yasmin's year, Then the lines are exactly the table above, each with value in its own unit, "converted at {rate} on {date}" where a rate is used ("converted at 48.00 on Oct 20, 2026" on US shares), value in EGP, share, zakatable amount, zakat on the line and a source link; Σ L_i = **520,000.00**, B = **500,000.00**, Z = **12,500.00**. No figure uses Y (354.367).
- **AC-10** Given Yasmin's year with zakat year solar, Then Z = 0.02577 × 500,000 = **12,885.00**.
- **AC-11** Given a Savings value update 130,000 dated 2026-10-22, Then Savings is still **120,000.00**; Given instead 125,000 dated 2026-10-20, Then **125,000.00**. The USD→EGP 50.00 dated 2026-10-21 is not used for any line. Given instead only USD→EGP 47.00 dated 2026-10-10, Then US shares = **94,000.00** and Loan to my brother = **23,500.00**, both show "converted at 47.00 on Oct 10, 2026" (and the AC-45 note), Σ L_i = **517,500.00**, B = **497,500.00**, Z = **12,437.50**. Given the US shares cost 3,000 USD, Then the line still uses 2,000 USD (market value, not cost).
- **AC-12** Given no USD→EGP rate on or before D, Then US shares and Loan to my brother show "USD→EGP rate missing", no 1:1 value, no Z shows, the year is incomplete and names both lines.
- **AC-13** Given an item started 2026-10-21, or an item fully sold on 2026-09-01, Then it has no line. Given Home (0 %), Then it has a **0.00** line with its B5 reason.
- **AC-14** Given Savings with interest 500 kept inside (recorded value 120,500, H = 500), Then its line is **120,000.00** and Z = **12,500.00** (Z-6).
- **AC-15** Given EGX shares on dividends-only with income 1,000 dated 2026-05-01, Then its share is 0 %, its line **0.00** with "Zakat on your dividends is counted with your cash. If that cash is not in this year's lines, add it as an extra cash line." (Z-1, Z-Q5), no amount for the income is added, B = **480,000.00**, Z = **12,000.00**. Given a private equity item on "profit received only", Then its line is 0.00 with the P-4c text.
- **AC-16** Given a gold item with intent personal use and no jewellery ruling, or a long-term stock with no long-term method, Then its line names the question to answer, no value is filled in, no Z shows, and the year is incomplete.
- **AC-17** (domain rule; proven by unit test) Given Yasmin's year, Then Cash at home and Loan to my brother count at 100 % with sources B1 / B9; an extra line with amount 0 or no currency is refused; only the kinds "cash not in the list" and "money owed to me" exist (C5); "money owed to me" is refused until the user states the debtor is able and willing to pay, and shows "A doubtful debt has no zakat until you receive it."; When year "2027" opens, Then it has no extra lines.
- **AC-18** Given a new year, Then debts = 0 with deduction on. Given Yasmin's year with deduction off, Then the debts line shows "not deducted", B = **520,000.00**, Z = **13,000.00**. Given debts 600,000, Then B = **0.00** and Z = **0.00**, below nisab.
- **AC-19** Given debts 100,000, Then B = **420,000.00** < 425,000.00, Z = **0.00**, labelled "Below nisab: no zakat due for this year.", with B and the nisab shown; Given silver, Then Z = **10,500.00**. Given debts 95,000, Then B = **425,000.00** = nisab and Z = **10,625.00**. In every case the A4, A8 and Z-4 / C5 lines of §7 show.
- **AC-20** Given any state, Then the app never stores an answer the user did not give for the cycle date, nisab standard, jewellery ruling, long-term method or rate view; never turns the debt deduction off; never starts distribution, recomputes, rebuilds or deletes a year; never adds a log entry; changes a state only as §8 allows; and never changes the My Investments "no zakat due this year" switch.
- **AC-21** Given Yasmin's year (due), When the user picks the Savings line, Then Savings' investment detail opens; When they record a value update 140,000 dated 2026-10-15 and come back, Then Savings = **140,000.00**, B = **520,000.00**, Z = **13,000.00**, with no other step. When they pick Cash at home, Then it can be edited; the debts line edits the debts amount.
- **AC-22** Given any figure of a year (r, nisab grams, each share, each rate, debts, the below-nisab label, each extra line), Then it links to its section: A1/A2, A3, the line's Part B section, A7, A5/C4, A3, B1/B9/C5. A linked rule tagged **[U]** shows "source not yet verified". The debts why-text reads "Scholars differ on long-term debts such as a mortgage. Some deduct only the part due in the next 12 months, some the whole debt, some none. This app deducts only what you enter here." (A5). No inflation-adjusted figure appears anywhere in the Zakat tab (A6).
- **AC-45** Given Yasmin's year, Then the Savings line shows "value of Oct 1, 2026" and "Zakat is on the value on your due date. If it changed, add a value or rate for Oct 20, 2026."; Gold bar, US shares, EGX shares, Home and the extra lines show no value-date note. Given AC-11's only USD→EGP rate 47.00 dated 2026-10-10, Then US shares and Loan to my brother each show "converted at 47.00 on Oct 10, 2026", "not the rate of Oct 20, 2026" and the same note. Given the only XAU-g→EGP rate is 5,000.00 dated 2026-10-15, Then the nisab shows "not the rate of Oct 20, 2026" and the note. In every case the year stays complete and Start distribution is offered. When the user adds a Savings value update dated 2026-10-20, Then the Savings note is gone.

**Start distribution and recompute (§8)**

- **AC-23** Given a year due 2027-10-20 and today 2026-10-23 (open), Then its figures use the latest values and rates on or before today, read "Estimate. Your zakat year ends on Oct 20, 2027.", and Start distribution is refused. Given Yasmin's year (due, complete), Then Start distribution is offered and there is no separate confirm action. Given an incomplete year (AC-8, AC-12, AC-16, or no nisab standard), Then it is refused and the reasons are named. Given a due year with no investment line and no extra line (debts 20,000 or none), Then it reads "Nothing to count yet.", shows no Z and no below-nisab text, and Start distribution is refused (PM-Q1).
- **AC-43** Given Yasmin's year (due, log empty), When the user starts distribution, Then it is distributing at once with no extra question, and Undo is offered; When they pick Undo within 10 seconds, Then the year is **due** again and shows live values (a Savings update made meanwhile shows); after 10 seconds, or once a log entry exists, Undo is not offered (PM-Q7).
- **AC-24** Given Yasmin's year started on 2026-10-23 (distributing), When the user records Savings = 200,000 dated 2026-10-18, edits the 2026-10-20 gold rate to 6,000, changes the nisab standard to silver, changes the base currency, and deletes Home, Then the year still shows every line, nisab **425,000.00** (gold) and Z = **12,500.00** as frozen; Home's line stays and opens nothing; picking Savings opens it and says the year is frozen and must be recomputed to use new values.
- **AC-25** Given AC-24 with only the Savings and gold-rate changes (gold standard kept) and log entries totalling 5,000.00, When the user recomputes, Then Savings = **200,000.00**, Gold bar = **300,000.00**, Σ L_i = **650,000.00**, B = **630,000.00**, nisab = **510,000.00**, Z = **15,750.00**, frozen again in one step; the log is unchanged (5,000.00), remaining = **10,750.00**, state distributing (C9).

**Distribution log (§9)**

- **AC-26** Given Yasmin's year distributing (Z = 12,500.00), When the user adds 5,000 EGP on 2026-10-21 with note "Masjid", Then distributed = **5,000.00**, remaining = **7,500.00**, state distributing; When they add 7,500 EGP on 2026-10-23, Then distributed = **12,500.00**, remaining = **0.00**, state **settled** with no other step, and the year shows the C11 line "The app counts what you log. It cannot check that each person may receive zakat (Quran 9:60), or that you gave it as zakat. Do not log interest you gave away: it is not zakat." An entry of 0, or dated 2026-10-24, is refused. Deleting the 7,500 entry returns distributed to 5,000.00 and the state to distributing. Given a due or open year, Then no entry can be added.
- **AC-27** Given AC-26 settled (12,500.00 distributed), When the user recomputes to Z = 15,750.00 (AC-25), Then distributed = **12,500.00**, remaining = **3,250.00**, state **distributing**. Given instead a recompute after Savings is corrected to 100,000 (Σ L_i 500,000, B 480,000, Z = **12,000.00**), Then remaining = **0.00**, settled, and the AC-29 texts show "Given 500.00 more than due." (C9).
- **AC-28** Given Yasmin's year as solar "2026" (previous year "2025" due 2025-10-20), When the user adds 2,000 EGP dated 2026-10-01 (before D), Then it is accepted, counted in distributed, marked "given before the due date", with the C6 help line "This counts if you held nisab when you gave it and you gave it as zakat. The Maliki school accepts this only shortly before the due date."; its Source marks the Maliki clause "source not yet verified" (C6 [U]); an entry dated **2025-10-21** is accepted; dated **2025-10-20** is refused. Given instead "2025"'s due date was moved to **2025-10-18** (§5.3), Then **2025-10-19** is accepted and **2025-10-18** is refused (the real date counts, C6).
- **AC-46** (first year, PM-Q4, C6) Given solar, 20 October, saved on 2026-01-05 (first year "2026", no "2025" exists), "2026" distributing, Then an entry dated **2025-10-21** is accepted and one dated **2025-10-20** is refused.
- **AC-29** Given Z = 12,500.00 and entries 13,000.00, Then remaining = **0.00**, settled, "Given 500.00 more than due." shows, and under it "Some scholars (Hanafi) let you count this toward next year if you gave it as zakat. Others (Shafi'i) count it as sadaqah. The app does not move it."; no other year's distributed or remaining changes.
- **AC-30** Given Yasmin's year distributing (Z 12,500.00) and no rate view yet, When the user logs 100 **USD** on 2026-10-22, Then the rate view is asked — "the day given (Sahibayn)" / "the due date (Abu Hanifa)", with references, nothing pre-selected (C8) — and the entry is not saved until answered. With **day given**: counted at USD→EGP 50.00 on 2026-10-21 (latest on or before 2026-10-22) = **5,000.00**, remaining **7,500.00**, and the entry shows "counted at 50.00 on Oct 21, 2026" and "not the rate of Oct 22, 2026". With **due date**: counted at 48.00 on 2026-10-20 = **4,800.00**, remaining **7,700.00**, with no "not the rate of" text. The view is asked again for no later entry. It can be changed in the Zakat settings; When the user changes it, Then the app says "Amounts already logged keep the rate they were counted at. Edit an amount to count it with the new view.", the 100 USD entry still counts as before, and once the user edits that entry's amount, currency or date it counts with the new view; a note-only edit keeps the old rate and view (PM-Q5, C8). Given a user who logs only EGP entries, Then the rate view is never asked.
- **AC-31** Given a due year below nisab (Z = 0.00), Then the start action is named "Close this year" (not "Start distribution"); When the user picks it, Then it reads **"below nisab: no zakat due"** (never "settled" alone) and remaining = 0.00.
- **AC-41** Given any text in the Zakat tab and the notification, in en and ar, Then none contains "zakat paid", "accepted", "fulfilled", "your duty is done", برئت الذمة or تقبّل; the C11 line shows on every settled year and in the log help.
- **AC-42** Given the AC-30 user on day-given view, When they log 200 **SAR** on 2026-10-22 and no SAR→EGP (or EGP→SAR) rate exists on or before 2026-10-22, Then the entry cannot be saved until they type a rate; When they type 13.00, Then a manual rate SAR→EGP 13.00 dated 2026-10-22 is stored in the rate history and the entry counts **2,600.00**; with due-date view the rate asked for is dated 2026-10-20. No entry ever counts 1:1. Given a year started in EGP and the base currency later changed to USD, Then that year's entries still count in EGP.

**History (§10)**

- **AC-32** Given solar years "2025" settled (due 2025-10-20, Z 11,000.00, distributed 11,000.00), "2026" = Yasmin's year distributing with 5,000.00 distributed (as solar: Z 12,885.00), and "2027" open (due 2027-10-20), Then the history lists, in this order: "2027 · Oct 20, 2027 · {live Z} estimate · 0.00 · open", "2026 · Oct 20, 2026 · 12,885.00 · 5,000.00 · distributing", "2025 · Oct 20, 2025 · 11,000.00 · 11,000.00 · settled". Given a settled year with Z = 0, Then its state reads "below nisab: no zakat due". Given a lunar year, Then its label reads "1447 AH"; after a calendar change (AC-6), lunar and solar years sit together, ordered by due date.
- **AC-33** Given Yasmin's year with its due date moved from the computed 2026-10-20 to 2026-10-21 (§5.3), started, with the two AC-30 / AC-42 entries, Then its detail shows due date 2026-10-21 and computed 2026-10-20, lunar r = 2.5 %, gold 85 g / 5,000.00 / 425,000.00, the eight lines of the table, B, Z, start date, each entry with date, amount, currency, rate, rate date, counted amount and note, distributed, remaining and state.

**Year-end notification and due text (§5.4)**

- **AC-34** Given a fresh install, When the app first launches and until the cycle date is saved, Then no notification permission is asked. When the user saves the cycle date for the first time, Then permission is asked once; later cycle-date saves do not ask again.
- **AC-35** Given solar, 20 October, saved on 2026-01-05 with permission granted, and days before and time never changed, Then days before shows **0** and time shows **09:00**, and exactly one local notification is scheduled, for **2026-10-20 09:00** device time, text **"Your zakat year 2026 ends today. Open to see your zakat."**. Given instead lunar, cycle date **1 Ramadan**, saved on **2026-10-23** (= 12 Jumada al-Awwal 1448) with permission granted, Then the first year is **1448 AH** (1 Ramadan 1448 = **2027-02-08**, Umm al-Qura) and the one notification is at **2027-02-08 09:00**, text **"Your zakat year 1448 AH ends today. Open to see your zakat."** No notification text says zakat "is due". No network request is made to schedule or show it. No notification or due text contains "late", "missed", "overdue" or "default".
- **AC-36** Given the AC-35 notification, When the user opens it, Then the app opens on year "2026" (state due).
- **AC-37** Given solar, 20 October, today 2026-10-23, permission granted, and "2027" open (due 2027-10-20) with its notification scheduled, When the user moves 2027's due date to 2027-10-18, Then the 2027-10-20 notification is removed and one is scheduled for 2027-10-18 09:00. When the user changes the days before or the time, Then it is rescheduled to the new fire moment. When the user changes the cycle date or the calendar (AC-6), Then the notification of "2027" does not move. At every app start, **at most one** notification exists: for the first due date on or after today, and none when that date's fire moment is past (AC-40) or permission is denied (AC-38).
- **AC-38** Given permission denied, Then no notification is scheduled, the cycle date saves, and AC-39 still holds.
- **AC-39** Given on 2026-10-23 "2025" due with Z = 11,000.00, "2026" due with Z = 0.00 (below nisab) and "2024" due and incomplete (USD rate missing), none started, Then the Zakat tab (locale en) shows "Your zakat for 2025 is due.", "Your zakat year 2026 ended on Oct 20, 2026. Below nisab: no zakat due." and "Your zakat year 2024 ended on Oct 20, 2024. Complete it to see your zakat.", each with its due date, with or without notification permission; When the user starts distribution on "2025", Then its text goes away and the other two remain. Given an open year, Then no due text shows for it. **"Do not delay" line** (C2, PM-Q6): "Most scholars hold that zakat should be given when it falls due, and not delayed without a valid reason." with Source → C2 shows on "2025" (due, Z > 0), on "2024" (due, incomplete) and on "2025" after it is started (distributing); it does not show on "2026" (below nisab), on an open year, on a settled year, or in any notification text.
- **AC-40** Given solar, 20 October, today 2026-10-23, locale **en**, "2027" open (due 2027-10-20), permission granted, When the user sets days before = **3** and time = **20:30**, Then the one notification is at **2027-10-17 20:30**, text **"Your zakat year 2027 ends on Oct 20, 2027. Open to see your zakat."** (the app's medium date format); When they set days before back to 0, Then it is at 2027-10-20 20:30 with "Your zakat year 2027 ends today. Open to see your zakat." Days before = 60 saves; 61 or −1 is refused. Given instead cycle date 25 October and today 2026-10-23, When the user sets days before = 5, Then the fire moment 2026-10-20 is past, year "2026" (due 2026-10-25) gets no notification, and the due text (AC-39) still shows from 2026-10-25.
- **AC-44** Given solar, 20 October, today 2026-10-23, permission granted, "2027" open (due 2027-10-20), Then the notification setting is **on** and one notification is scheduled for 2027-10-20 09:00; When the user turns it **off**, Then no notification is scheduled (the 2027-10-20 one is removed), also after an app start or a change of due date, days before or time; on 2027-10-20 the due text (AC-39) still shows. When they turn it **on** again, Then one notification is scheduled for 2027-10-20 09:00 (PM-Q3).

---

## 12. Out of scope

- Zakat al-fitr.
- Per-acquisition hawl (Shafi'i/Hanbali) and nisab continuity during the year — single due date only (A4, "What we do not handle").
- Restarting the zakat date after a below-nisab due date (Hanafi view, C4): v1 keeps the cycle date; giving on it counts as giving early (C6).
- Agricultural produce, livestock, minerals.
- Recipients: who received it, eligibility categories (Quran 9:60), receipts. A log entry has only date, amount, currency and note (C11 says what the app can and cannot check).
- Giving zakat in gold or silver grams (log entries are in currencies only).
- Moving an amount given above zakat due to the next year (owner OQ-4; C7).
- Any notification other than the one year-end notification per year (§5.4): no second reminder, no repeat when a year stays due, no notification for distribution progress, no notification in other features. No background work.
- Debts as a list (UC-5). Here: one "within 12 months" figure (A5) and good-debt extra lines (B9).
- Years before the first one (Q-O1); carrying extra lines to the next year.
- Any change to My Investments: its estimated set-aside, its "no zakat due this year" switch and its figures are unchanged.
- Paying zakat through the app; any advice on what to give or to whom.
- Interest purification (Z-6) beyond leaving interest out of the base.

## 13. Shariah touchpoints (islamic-consultant)

| # | Point | Rule in the file | Status |
|---|---|---|---|
| 1 | r per calendar, no T/Y; 366-day solar year | A1, A2, C1 | answered: 2.577 % always (Z-Q4) |
| 2 | Single due date, nisab checked on it only | A4 | covered |
| 3 | Cycle-date help; day 30 → 29th; moving a date (lunar ±2, solar earlier only) | C1, C3 | answered (Z-Q7); day-30 reading [U] |
| 4 | Calendar / cycle-date change never pushes zakat later | C2 | answered (BLOCKER item 1 closed, §5.1, AC-6) |
| 5 | Nisab standard asked, priced on the due date, pure grams | A3, Z-4 [U] | covered |
| 6 | Values on the due date, market not cost, not inflation-adjusted | A7, Edge cases, A6 | covered |
| 7 | FX on the due date, shown with date | A7 | covered |
| 8 | Item shares and sources | Part B via `zakat_rules.dart` | covered |
| 9 | Dividends / profit-only items in the real year | Z-1, A4 | answered (Z-Q5) |
| 10 | Interest out of the base | Z-6, B1 | covered |
| 11 | Extra lines: cash, good debt only; doubtful excluded | B1, B9, C5 | covered |
| 12 | Debt deduction on by default; nisab after the deduction | A5, C4 | answered (Z-Q6) |
| 13 | Combined by value, gold and silver included | A8 | covered |
| 14 | Below nisab → 0; "below nisab: no zakat due" | A3, C4, C11 | covered |
| 15 | Given before the due date; earliest date | C6 [S] | answered (Z-Q1) |
| 16 | Given more than due | C7 | answered (Z-Q2) |
| 17 | Giving in another currency; rate view asked | A7, C8 | answered (Z-Q3); built in v1 (owner OQ-5) |
| 18 | Recompute after part was given | C9 | answered (Z-Q8) |
| 19 | Notification and due-text wording | C10 | applied |
| 20 | What "settled" claims; banned words | C11 | applied |

Before release the consultant reviews the Arabic of every text in §5 and §6–§9 (as for P-4c).

## 14. Decisions and open questions

### 14.1 Owner (all decided, 2026-10-23; PM-Q3 in §14.1b)

- **Q-O1** First year: the next due date only (first on or after the day the cycle date is saved) (§5.2, AC-4).
- **Q-O2** Moving records on a calendar or cycle-date change: superseded — no year is rebuilt (OQ-1 / C2), so nothing moves.
- **Q-O3** Moving a due date: lunar ±2 days; solar up to 2 days earlier only (per consultant C3; §5.3, AC-5).
- **Q-O4** Notification: the user picks a time (default 09:00) and days before N (0–60, default 0) (§5.4, AC-35, AC-37, AC-40).
- **Q-O5** Notification text: per consultant C10 (owner rule: the consultant's ruling wins on Shariah) (§5.4, AC-35, AC-40).
- **OQ-1** Change of calendar or cycle date: option (a) — existing years keep their due date; the new cycle applies from the year after (C2; §5.1, AC-6).
- **OQ-4** Moving extra given to next year: not in v1; the C7 line names both views (§9, AC-29).
- **OQ-5** Entries in other currencies: in v1, with the rate view asked per C8 (§9, AC-30, AC-42).

### 14.1b UX questions (docs/product/ux/zakat.md, 2026-10-23)

- **PM-Q1** Empty year → **decided (PM):** "Nothing to count yet.", no verdict, no Start (§7, AC-23).
- **PM-Q2** Below-nisab start label → **decided (PM):** "Close this year", same action (§8, AC-31).
- **PM-Q7** Start without a dialog → **decided (PM):** one action + 10 s Undo while the log is empty (§8, AC-43).
- **PM-Q3** On/off for the year-end notification → **decided (owner, 2026-10-23):** yes, on by default once permission is given; off schedules nothing, the due text still shows (§5.4, AC-44).
- **PM-Q4** Earliest log date in the first year → **decided (consultant, C6):** the day after the cycle date one year before the first due date; for later years, the day after the previous year's real (moved) due date (§5.2, §9, AC-28, AC-46).
- **PM-Q5** Rate-view change → **decided (consultant, C8):** new entries only, with the change text; editing an entry's amount, currency or date recounts it; a note-only edit does not (§9, AC-30).
- **PM-Q6** "Do not delay" line → **decided (consultant, C2): shown** on due (Z > 0 or incomplete) and distributing years, not elsewhere, not in the notification (§5.4, AC-39).

### 14.2 Islamic-consultant

All of Z-Q1…Z-Q8 are answered in zakat-on-investments.md "Answers to the zakat story" and applied: Z-Q1 → C6; Z-Q2 → C7; Z-Q3 → C8; Z-Q4 → C1 / A2 (2.577 % always; the "2.5775 % in a leap year" premise was an error in A2, now corrected); Z-Q5 → Z-1 / A4; Z-Q6 → C4; Z-Q7 → C3; Z-Q8 → C9. Z-Q1…Z-Q8 and PM-Q4…Q6 are closed (consultant "Answers to loop 1"). No question is open. Still **[U]** in the file: the day-30 reading (C3), the Maliki limit on early giving (C6).

## 15. Doc changes needed (not made by this story)

- **docs/product/brd.md §5 Non-goals**, line "No notifications in v1 (opt-in local reminders in v1.1 maybe)." → must allow this one: e.g. "No notifications in v1, except one local zakat year-end notification (stories/zakat.md §5.4; owner decision 2026-10-23)." Owner or orchestrator edits it.
- my-investments.md §5.6 and §11 cite that BRD line for their own "no notification" rules. They stay true for that feature; no change needed.

---

## Test map

Owner: QA. Every AC has a test, named `AC-n …`. **U** = unit (domain: dates, lines, totals, states, log counting, notification scheduling against a fake scheduler) under `test/features/zakat/domain/`. **W** = widget test under `test/features/zakat/presentation/` (en and ar). **I** = `integration_test/` golden path: set cycle date (permission asked) and nisab → Yasmin's lines → open Savings, edit, back → Start distribution → an EGP entry and a USD entry (rate view asked) → settled → history → detail; plus a launch from the notification payload.

Tags: **T** `test/l10n/zakat_story_texts_test.dart` (texts word for word, en); **Q** `test/features/zakat/presentation/year_screen_audit_test.dart` (QA audit of the year screen); **G** `test/golden_path_zakat_widget_test.dart` (headless run of the flow in `integration_test/golden_path_zakat_test.dart`).

| AC | U | W | I |
|---|---|---|---|
| 1 | — | cycle date asked per calendar, nothing pre-filled, C1 help text ("Hijri" / "Gregorian months"), past-years line naming "2026" / "1448 AH", 31 Apr refused; **T** | ✓ (lunar) |
| 2 | 1447 AH → 2026-02-18, 1448 AH → 2027-02-08; day 30 → 29 | label "1447 AH"; C3 line; **T** | — |
| 3 | solar dates; 29 Feb rule | — | — |
| 4 | first year (saved before / after the due date); open → due by date; next year from D + 1; due stays | — | — |
| 5 | lunar ±2; solar −2…0 (2027-10-21 refused); label and next year unchanged; frozen year cannot move | move refused out of range | — |
| 6 | C2 example: 1448 AH keeps 2027-02-08 and r 2.5 %; next "2027" due 2027-10-20 at 2.577 %; due / distributing kept; cycle-date change → "2028" due 2028-03-01; a year moved later after the change stays listed, in order; the new cycle starts the day after the later of its computed and moved date | "applies from the year after 1448 AH"; **T** | — |
| 7 | 425,000.00 / 35,700.00 | nisab asked, nothing pre-selected | ✓ |
| 8 | incomplete without metal rate | "Add a gold rate…"; **T** | — |
| 9 | full table, Σ, B, Z; Y unused | every line shows its parts and source link; **T**; extra lines show share and zakat on the line (**Q**) | ✓ |
| 10 | 12,885.00 | — | — |
| 11 | value/rate on or before D; 47.00 case (94,000.00 + 23,500.00 → Σ 517,500.00, B 497,500.00, Z 12,437.50); not cost | "converted at 47.00 on Oct 10, 2026" on both USD lines; **T** | — |
| 12 | incomplete, two lines named | missing-rate text | — |
| 13 | in/out of the year; 0 % line kept | — | — |
| 14 | net of H | — | — |
| 15 | 0 line, B 480,000, Z 12,000.00; PE same | notice with the extra-cash sentence; **T**; **Q** | — |
| 16 | unanswered question → incomplete | question named on the line | — |
| 17 | 100 %, B1/B9; only two kinds; refusals; good-debt statement required; next year empty (domain only) | **T** | — |
| 18 | off → 13,000.00; debts > lines → 0 | "not deducted"; **T** | — |
| 19 | below / at / silver | below-nisab label + A4, A8, Z-4 / C5 lines | — |
| 20 | no silent answer (incl. rate view); no auto start/recompute/rebuild/delete/entry; only §8 state moves; switch untouched | **Q** | — |
| 21 | — | line opens item detail; back → 13,000.00 | ✓ (**G**) |
| 22 | every figure has a section; [U] flag | links and "source not yet verified"; debts why-text with the long-term-debts dispute; no inflation figure; **T**; **Q** | — |
| 23 | estimate when open; start guard (state, completeness, empty year) | "Estimate. Your zakat year ends on Oct 20, 2027."; reasons named; no confirm action; "Nothing to count yet." with no verdict | ✓ (**G**) |
| 24 | frozen after every listed change | deleted line opens nothing; "recompute" message | ✓ (one change) |
| 25 | recompute → 15,750.00; log kept; remaining 10,750.00 | — | — |
| 26 | distributed / remaining / auto settled; refusals; delete → distributing; no entry on open/due | log entry, totals, C11 line on settled; **T** | ✓ (**G**) |
| 27 | settled → recompute → distributing, 3,250.00; recompute to 12,000.00 → 500.00 more | — | — |
| 28 | early entry counted and marked; 2025-10-21 accepted, 2025-10-20 refused; moved 2025-10-18 → 10-19 accepted, 10-18 refused | C6 help line; Maliki clause Source "source not yet verified"; **T** | — |
| 29 | over-distribution, no other year changes | "Given 500.00 more than due." + C7 line; **T** | — |
| 30 | day given 5,000.00 / due date 4,800.00; asked once; change keeps old entries, an edit of amount, currency or date recounts, a note-only edit does not; EGP-only never asked | rate view asked, nothing pre-selected; "counted at 50.00 on Oct 21, 2026" + "not the rate of Oct 22, 2026"; change text; **T**; a note-only edit keeps rate, rate date, view and amount (`gift_sheet_test.dart`) | ✓ (USD entry) (**G**) |
| 31 | Z = 0 start → below nisab at once | action named "Close this year"; "below nisab: no zakat due", no "settled" alone; **T** | — |
| 32 | order and states | rows in order, medium dates (en), labels per calendar, below-nisab state | ✓ (**G**) |
| 33 | — | detail shows every listed part, incl. entry rate and counted amount; **Q** | ✓ (**G**) |
| 34 | — | no permission on first launch; asked once on first cycle-date save | ✓ |
| 35 | solar: 2026-10-20 09:00; lunar 1 Ramadan saved 2026-10-23 → 1448 AH, 2027-02-08 09:00; C10 texts; no "is due"; banned words; no network | defaults 0 and 09:00 shown next to the cycle date; **T** | — |
| 36 | — | — | ✓ (payload → year "2026") (**G**) |
| 37 | reschedule on due-date move, days-before/time change, app start; no move on cycle/calendar change; at most one (none when past or denied) | — | — |
| 38 | denied → none scheduled, cycle date saved | due text without permission | — |
| 39 | three due texts by result; gone after start; none for open; "do not delay" line on due Z > 0 / incomplete / distributing only, never in a notification | three texts (en, "Oct 20, 2026" / "Oct 20, 2024"), then two; C2 line and Source where due; **T**; **Q** | — |
| 40 | N = 3 at 20:30 → 2027-10-17 20:30, "ends on Oct 20, 2027" (en); back to 0 → "ends today"; 0–60 bounds; past fire moment → none | days before 61 / −1 refused; **T** | — |
| 41 | `l10n` word scan, en and ar | C11 line on settled year and log help; **Q** | — |
| 42 | missing SAR rate → typed rate stored as manual rate, 2,600.00; due-date view asks for 2026-10-20; never 1:1; year keeps EGP after base change; a foreign gift with no rate is refused | rate asked before save; recompute after a base change keeps EGP and the log (`year_screen_test.dart`) | — |
| 43 | Undo → due, live values; not after 10 s or once the log has an entry | one action, no question; Undo offered then gone | ✓ (**G**) |
| 44 | off → none scheduled (kept off across app start and changes); on → 2027-10-20 09:00 again | setting on by default after permission; due text with it off | — |
| 45 | value date / rate date before D → date, "not the rate of", note; year stays complete; note gone after a D update | Savings note; USD lines; nisab rate note; **T**; **Q** | — |
| 46 | first year: 2025-10-21 accepted, 2025-10-20 refused | **T** | — |
