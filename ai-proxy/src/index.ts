import {
  fromGeminiResponse,
  geminiUrl,
  toGeminiRequest,
  type NeutralRequest,
} from "./gemini.ts";

export interface Env {
  GEMINI_API_KEY: string;
  GEMINI_MODEL: string;
  APP_TOKEN: string;
  RATE_LIMITER: RateLimiter;
  GLOBAL_LIMITER: RateLimiter;
}

interface RateLimiter {
  limit(options: { key: string }): Promise<{ success: boolean }>;
}

const MAX_INPUT_CHARS = 20_000;
// Not exported: a Worker module may only export handlers.
const RETRY_DELAY_MS = 1_000;
const MAX_OUTPUT_TOKENS = 4_096;

// Never log request or response bodies: they hold the user's financial data.
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    if (request.method !== "POST" || url.pathname !== "/v1/complete") {
      return json({ error: "not found" }, 404);
    }
    if (!sameSecret(request.headers.get("x-app-token") ?? "", env.APP_TOKEN)) {
      return json({ error: "unauthorized" }, 401);
    }
    const ip = request.headers.get("cf-connecting-ip") ?? "unknown";
    if (
      !(await env.RATE_LIMITER.limit({ key: ip })).success ||
      !(await env.GLOBAL_LIMITER.limit({ key: "all" })).success
    ) {
      return json({ error: "rate limited" }, 429, { "retry-after": "60" });
    }
    const neutral = parseNeutralRequest(await request.json().catch(() => null));
    if (neutral === null) return json({ error: "bad request" }, 400);

    const send = () =>
      fetch(geminiUrl(env.GEMINI_MODEL), {
        method: "POST",
        headers: {
          "content-type": "application/json",
          "x-goog-api-key": env.GEMINI_API_KEY,
        },
        body: JSON.stringify(toGeminiRequest(neutral)),
      });
    let upstream = await send();
    // 503 = Gemini overloaded ("high demand"); it usually clears in a second.
    if (upstream.status === 503) {
      await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY_MS));
      upstream = await send();
    }
    if (upstream.status === 429) {
      const retryAfter = upstream.headers.get("retry-after");
      return json({ error: "quota exceeded" }, 429, retryAfter ? { "retry-after": retryAfter } : {});
    }
    if (!upstream.ok) return json({ error: "upstream error" }, 502);

    const text = fromGeminiResponse(await upstream.json().catch(() => null));
    return text === null ? json({ error: "empty reply" }, 502) : json({ text });
  },
};

export function parseNeutralRequest(body: unknown): NeutralRequest | null {
  const b = body as Record<string, unknown> | null;
  if (typeof b?.instruction !== "string" || typeof b.input !== "string") return null;
  if (b.instruction.length + b.input.length > MAX_INPUT_CHARS) return null;
  const max = b.maxOutputTokens ?? 1024;
  if (!Number.isInteger(max) || (max as number) < 1 || (max as number) > MAX_OUTPUT_TOKENS) return null;
  return { instruction: b.instruction, input: b.input, maxOutputTokens: max as number };
}

function sameSecret(given: string, expected: string): boolean {
  if (!expected || given.length !== expected.length) return false;
  let diff = 0;
  for (let i = 0; i < given.length; i++) diff |= given.charCodeAt(i) ^ expected.charCodeAt(i);
  return diff === 0;
}

function json(body: unknown, status = 200, headers: Record<string, string> = {}): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json", ...headers },
  });
}
