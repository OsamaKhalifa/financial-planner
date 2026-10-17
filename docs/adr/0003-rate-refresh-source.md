# ADR-0003 — Online rate refresh source

**Status:** proposed · 2026-10-16 · architect · verified by live requests on 2026-10-16

## Decision

The user-triggered refresh (story §6.1, AC-25…AC-30) makes **one GET of one fixed URL** — the USD file of the open-source **fawazahmed0 `currency-api`** — which carries FX for 340 codes *and* gold (`xau`) and silver (`xag`) in one response; on failure it retries the project's documented Cloudflare mirror once, then reports failure.

### Endpoint

| | URL |
|---|---|
| Primary | `https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.min.json` |
| Fallback (same data, project-documented) | `https://latest.currency-api.pages.dev/v1/currencies/usd.min.json` |

Both URLs are compile-time constants. No query string, no custom headers, no cookies → the request is byte-identical for every user (AC-26). The user's units are applied **after** download, locally.

### Response shape (observed)

```json
{ "date": "2026-10-16",
  "usd": { "egp": 53.43725844, "sar": 3.75, "eur": 0.89086065, "xau": 0.000239066, "xag": 0.0172747, ... } }
```

- `date` = the source's "as of" day → stored as the rate date (AC-27), never the phone's date.
- `usd.<code>` = units of `<code>` per 1 USD. For metals that is **troy ounces per USD**, so USD per ounce = `1 / xau`.
- Size: ~6 KB minified. Parsed with `jsonDecode`; every number is read via `toString()` into `Decimal.parse` (never kept as `double`).

### What is stored

For each pair the user needs right now — every open item's unit → base, and XAU-g → base, XAG-g → base (also XAU-g/XAG-g → USD if base is USD) — one `Rate` row: `rate`, `asOf = date`, `source = 'currency-api'`. Computed from the single USD snapshot:

- `A→B = usd[b] / usd[a]` (USD→B when A = USD).
- `XAU-g→B = usd[b] / (usd.xau × 31.1034768)` (AC-30: 3,110.34768 USD/oz → XAU-g→USD 100.00).

This cross is computed **once, at fetch time, from one source's quotes of one day**, and stored as a plain direct rate. It is not the runtime third-currency chain that story Q6 excludes: lookups still never chain. Without it, refresh could not price gold in EGP at all (the source quotes metals only against currencies, and AC-30 already implies USD/oz → per-gram arithmetic).

A pair the source lacks is skipped and listed as "not covered" (UX S6). An identical row (same pair, date, source) is not stored twice. Manual rates on the same date win at lookup time (AC-28), not by deleting anything.

### Failure and offline

Timeout 10 s per URL. Primary fails (network error, non-200, unparsable JSON, missing `date`/`usd`) → fallback once → fails → `RefreshResult.failed`, **nothing is written** (one Drift transaction for all rows of a successful fetch), the UI says it failed, all figures keep using stored rates (AC-29). No retry loop, no background schedule (AC-25).

### Terms and limits (checked 2026-10-16)

- Repository `github.com/fawazahmed0/exchange-api`: licence **CC0-1.0**, active (last push 2026-10-01), README states "Free", "No Rate limits", "Daily Updated", and asks clients to implement the jsdelivr → pages.dev fallback — which we do.
- No key, no account, no attribution requirement (we still show the source name per rate, story §6.1).
- Freshness: daily. The jsdelivr copy was ~12 h behind on the check (`date: 2026-10-15`, `s-maxage=43200`); the pages.dev copy had 2026-10-16. Harmless: the stored date is the source's date.
- Accuracy spot-check same minute: gold 4,182.94 USD/oz vs 4,189.50 at gold-api.com (0.16 %); USD→EGP 53.437 vs 53.465 at open.er-api.com (0.05 %). Good enough for a planning figure the user can override by typing.
- All 29 currencies in the v1 unit list (spec §2.1) are present.

## Why

**Problem:** owner decision Q2 — an optional, keyless, privacy-neutral refresh of FX *and* gold/silver, with a source "as of" date, at zero running cost and with no server of our own.

This source is the only one checked that covers EGP/SAR/KWD/PKR **and** metals in **one** keyless request with no stated rate limit and a public-domain licence. One request = one parser, one failure path, one privacy argument.

## Rejected alternatives

- **open.er-api.com (ExchangeRate-API open access) + api.gold-api.com for metals** — both work keyless today (verified), but two sources, two failure modes, two terms pages; ExchangeRate-API's open tier requires attribution and is rate-limited, and gold-api.com has no published terms for this use.
- **Frankfurter / ECB reference rates** — official and stable, but ~30 currencies only: no EGP, SAR, AED, KWD, QAR, PKR. Disqualified by the supported markets.
- **goldapi.io, metals-api, Open Exchange Rates** — need an API key; a key shipped in the app is public, and a per-user key is an account we do not want.
- **Asking only for the user's currencies** — leaks holdings (story §6.1).

## Trigger to revisit

- The source stops updating, disappears, or changes licence → switch to the open.er-api.com + gold-api.com pair above (same `RateRefresher`, second parser).
- Users report fetched rates materially off (> 1 %) from their bank's.
- A server phase arrives: the server can proxy one fixed snapshot for all users.
