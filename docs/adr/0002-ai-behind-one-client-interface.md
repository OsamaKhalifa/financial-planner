# ADR-0002 — AI behind one client interface and our own proxy

**Status:** accepted · 2026-10-16 · decided by @OsamaKhalifa

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

## Own Gemini key (added 2026-10-16)

A user may enter their own Gemini key in Settings (`lib/features/settings/settings_screen.dart`). Then `aiClientProvider` gives `GeminiAiClient`, which calls Google **directly** — the key and the data never pass through our Worker. Without an own key, the shared Worker route is used.

- The switch and the key live in `AiSettingsStore` (`lib/core/ai/ai_settings.dart`) on top of `flutter_secure_storage` (Keychain / Keystore). No repository interface: settings never move to a server.
- The key goes in the `x-goog-api-key` header, never in a URL.
- **Accepted cost:** the Gemini mapping now exists twice — `ai-proxy/src/gemini.ts` and `lib/core/ai/gemini_ai_client.dart`. A vendor change touches both, still no feature.

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

1. Create a Gemini API key in Google AI Studio. The model is the alias `gemini-flash-lite-latest` in both `ai-proxy/wrangler.toml` and `GeminiAiClient` — an alias, because pinned models get retired for new users (`gemini-2.5-flash` returned 404 in 2026-10).
2. In `ai-proxy/`: `npm ci`, `npx wrangler login`, `npx wrangler secret put GEMINI_API_KEY`, `npx wrangler secret put APP_TOKEN` (a long random string), `npx wrangler deploy`.
3. Run the app with `--dart-define=AI_PROXY_URL=<worker url> --dart-define=AI_APP_TOKEN=<same token>`.

**Live test** (real Gemini, real device storage, local Worker): put your key in `~/.config/financial-planner/ai.env` (outside the repo), boot an iOS simulator, run `tool/ai_live_test.sh`. Not part of CI — it needs a key and spends quota.

## Trigger to revisit

A feature needs streaming or multi-turn chat, the on-device client is built, or the app gets real user accounts (then replace `APP_TOKEN` with per-user auth).
