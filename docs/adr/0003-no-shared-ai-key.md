# ADR-0003 — No shared AI key: users bring their own

**Status:** accepted · 2026-10-17 · decided by @OsamaKhalifa · supersedes the shared route of ADR-0002

## Decision

The app has no shared AI service. To use cloud AI, the user turns it on in Settings, picks a provider from `defaultAiVendors` (`lib/core/ai/ai_vendors.dart`) and saves their own key. Nothing is picked by default.

Removed: the "App's shared AI" option, `CloudAiClient`, `aiProxyConfigProvider`, the Cloudflare Worker (`ai-proxy/`) and its CI job.

`AiClient` and `aiClientProvider` stay as in ADR-0002. Features do not change.

## Why

- The shared route ran on the owner's Gemini key: every user spent the owner's free quota, and their text passed through the owner's server.
- The app token that guarded the Worker ships in the app, so anyone could extract it and use the owner's quota.
- No shared key means nothing to bill, cap or operate.

## Consequences

- `aiClientProvider` returns `AiUnavailable` when cloud AI is off, no provider is picked, or the picked provider has no key. Features must handle it (unchanged rule).
- A stored `ai.vendor` that is missing or no longer offered reads as "none picked".
- Each user spends their own vendor quota.

## Trigger to revisit

The app gets real user accounts and a paid plan; then a server route with per-user auth can come back.
