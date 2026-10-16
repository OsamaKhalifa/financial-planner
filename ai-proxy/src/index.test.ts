import assert from "node:assert/strict";
import { afterEach, test } from "node:test";
import worker, { type Env } from "./index.ts";

const realFetch = globalThis.fetch;
afterEach(() => {
  globalThis.fetch = realFetch;
});

function env(allowed = true): Env {
  return {
    GEMINI_API_KEY: "key",
    GEMINI_MODEL: "model-x",
    APP_TOKEN: "secret",
    RATE_LIMITER: { limit: async () => ({ success: allowed }) },
  };
}

function call(body: unknown, { token = "secret", path = "/v1/complete", e = env() } = {}) {
  return worker.fetch(
    new Request(`https://proxy.test${path}`, {
      method: "POST",
      headers: { "x-app-token": token, "content-type": "application/json" },
      body: JSON.stringify(body),
    }),
    e,
  );
}

const valid = { instruction: "Be brief.", input: "Hi", maxOutputTokens: 64 };

function stubGemini(status: number, body: unknown, headers: Record<string, string> = {}) {
  const calls: { url: string; init: RequestInit }[] = [];
  globalThis.fetch = async (url, init) => {
    calls.push({ url: String(url), init: init! });
    return new Response(JSON.stringify(body), { status, headers });
  };
  return calls;
}

test("forwards to Gemini and returns neutral text", async () => {
  const calls = stubGemini(200, { candidates: [{ content: { parts: [{ text: "Hello" }] } }] });
  const res = await call(valid);
  assert.equal(res.status, 200);
  assert.deepEqual(await res.json(), { text: "Hello" });
  assert.match(calls[0].url, /models\/model-x:generateContent$/);
  assert.equal((calls[0].init.headers as Record<string, string>)["x-goog-api-key"], "key");
});

test("rejects a wrong app token", async () => {
  assert.equal((await call(valid, { token: "nope" })).status, 401);
});

test("rejects unknown paths", async () => {
  assert.equal((await call(valid, { path: "/other" })).status, 404);
});

test("returns 429 when the rate limit is hit", async () => {
  const res = await call(valid, { e: env(false) });
  assert.equal(res.status, 429);
  assert.equal(res.headers.get("retry-after"), "60");
});

test("rejects a bad body", async () => {
  for (const body of [null, { input: "x" }, { ...valid, maxOutputTokens: 0 }, { ...valid, input: "x".repeat(20_001) }]) {
    assert.equal((await call(body)).status, 400, JSON.stringify(body)?.slice(0, 40));
  }
});

test("passes the Gemini quota error through as 429", async () => {
  stubGemini(429, {}, { "retry-after": "12" });
  const res = await call(valid);
  assert.equal(res.status, 429);
  assert.equal(res.headers.get("retry-after"), "12");
});

test("maps other Gemini errors and empty replies to 502", async () => {
  stubGemini(500, {});
  assert.equal((await call(valid)).status, 502);
  stubGemini(200, { candidates: [] });
  assert.equal((await call(valid)).status, 502);
});
