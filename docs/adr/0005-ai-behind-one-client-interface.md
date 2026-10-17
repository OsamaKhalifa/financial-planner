# ADR-0005 — AI behind one client interface and our own proxy

**Status:** accepted · 2026-10-16 · decided by @OsamaKhalifa

> **2026-10-17:** the shared route (`CloudAiClient`, the `ai-proxy/` Worker, the app token) is removed by [ADR-0006](0006-no-shared-ai-key.md). Users bring their own key. The interface and the vendor registry below still apply.

## Decision

Features use AI only through `AiClient` (`lib/core/ai/ai_client.dart`): one method, `complete(AiPrompt) → AiReply`, and three errors (`AiUnavailable`, `AiQuotaExceeded`, `AiFailure`). The implementation is chosen in exactly one place, `aiClientProvider` (`lib/core/ai/ai_providers.dart`).

v1 has one real implementation, `CloudAiClient`. It does **not** call an AI vendor. It calls our own Cloudflare Worker (`ai-proxy/`) with a vendor-neutral body — `{instruction, input, maxOutputTokens}` → `{text}`. Only the Worker knows the vendor (Gemini today, in `ai-proxy/src/gemini.ts`).

Cloud AI is **opt-in**: `aiSettingsProvider.cloudEnabled` is `false` by default. Off, or without proxy config, every call throws `AiUnavailable`. Features must handle that.

## Why

- Owner requirement: change the AI vendor later without rewriting features.
- Two seams make that true: the interface (swap or add an implementation, e.g. on-device) and the neutral wire format (swap the vendor by redeploying the Worker — no app release).
- A vendor key can never ship in the app: anyone can extract it. The Worker holds it as a secret.
- Product promise is "data stays on the device". Opt-in keeps that the default.

Like ADR-0001, this is an approved exception to "no interface with a single implementation": on-device clients (Apple Foundation Models, Gemini Nano) are the planned second implementation.

## Own key, any vendor (added 2026-10-16)

In Settings (`lib/features/settings/settings_screen.dart`) the user turns cloud AI on, then picks a provider from a list: **App's shared AI** (our Worker, no key) or one of the vendors in `defaultAiVendors` (`lib/core/ai/ai_vendors.dart`) with their own key. Today the list holds Google Gemini only.

- **Adding a vendor** = write its `AiClient` + add one `AiVendor` entry (id, name, key help, data notice, client factory). The Settings list, key field, storage and `aiClientProvider` pick it up with no change; features never change. `test/support/fake_ai_vendor.dart` proves it in the tests.
- Vendor names appear only in the vendor's client file and its `AiVendor` entry.
- With an own key, the vendor client calls the vendor **directly** — the key and the data never pass through our Worker.
- Settings live in `AiSettingsStore` (`lib/core/ai/ai_settings.dart`) on `flutter_secure_storage` (Keychain / Keystore): `ai.cloudEnabled`, `ai.vendor`, one `ai.apiKey.<vendorId>` per vendor. A stored vendor that is no longer offered falls back to the shared service. No repository interface: settings never move to a server.
- Keys go in a header, never in a URL.
- **Accepted cost:** the Gemini mapping exists twice — `ai-proxy/src/gemini.ts` (shared route) and `lib/core/ai/gemini_ai_client.dart` (own key).

## Cost: the shared key never bills

- **Never enable billing** on the Google Cloud project that owns the shared `GEMINI_API_KEY`. Without billing, Gemini cannot charge: over the free limit it answers 429, which the app shows as `AiQuotaExceeded`.
- The Worker caps traffic before Google sees it: 5 requests/min per IP and 10 requests/min for all users together (`ai-proxy/wrangler.toml`). Keep the global cap below the model's free requests-per-minute (AI Studio → Rate limits). The free requests-per-day can still run out on a busy day; users then get 429 until the next day, never a bill.
- Cloudflare Workers free plan also never bills; over its daily request limit it returns errors.
- Own-key users spend their own quota.

## Rules

- Features import `ai_client.dart` and `ai_providers.dart` only. Never `cloud_ai_client.dart`, never a vendor SDK.
- Feature tests override `aiClientProvider` with `FakeAiClient` (`test/support/fake_ai_client.dart`).
- The AI never computes money or a Shariah ruling. It may only explain or suggest; our own code decides.
- The Worker never logs request or response bodies.

## What we do NOT build now

No streaming, chat history, tool calls, images, prompt registry, response cache, or on-device client.

## Known limits

- The `APP_TOKEN` is inside the app, so it can be extracted. It only blocks casual abuse. The real caps are the per-IP rate limit and the vendor's free quota.
- On the Gemini free tier, Google may use prompts to improve its products. Users must be told this when they opt in.

## Rejected alternatives

- **Vendor SDK in the app** — leaks the key, and a vendor change means an app release.
- **Generic multi-vendor library in the app** (e.g. a LangChain-style layer) — a big dependency for one method.

## Setup (manual, by the owner)

None for the app. Users create their own key (Google AI Studio for Gemini) and paste it in Settings. The Gemini model is the alias `gemini-flash-lite-latest` in `GeminiAiClient` — an alias, because pinned models get retired for new users (`gemini-2.5-flash` returned 404 in 2026-10).

**Live test** (real Gemini, real device storage): put your key in `~/.config/financial-planner/ai.env` (outside the repo), boot an iOS simulator, run `tool/ai_live_test.sh`. Not part of CI — it needs a key and spends quota.

## Trigger to revisit

A feature needs streaming or multi-turn chat, the on-device client is built, or the app gets real user accounts (then replace `APP_TOKEN` with per-user auth).
