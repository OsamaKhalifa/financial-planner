import assert from "node:assert/strict";
import { test } from "node:test";
import { fromGeminiResponse, geminiUrl, toGeminiRequest } from "./gemini.ts";

test("maps the neutral request to Gemini", () => {
  assert.deepEqual(toGeminiRequest({ instruction: "Be brief.", input: "Hi", maxOutputTokens: 64 }), {
    systemInstruction: { parts: [{ text: "Be brief." }] },
    contents: [{ role: "user", parts: [{ text: "Hi" }] }],
    generationConfig: { maxOutputTokens: 64 },
  });
});

test("joins the text parts of the first candidate", () => {
  const body = { candidates: [{ content: { parts: [{ text: "a" }, { thought: true }, { text: "b" }] } }] };
  assert.equal(fromGeminiResponse(body), "ab");
});

test("returns null when there is no text", () => {
  assert.equal(fromGeminiResponse({}), null);
  assert.equal(fromGeminiResponse(null), null);
  assert.equal(fromGeminiResponse({ candidates: [{ content: { parts: [] } }] }), null);
});

test("builds the model URL", () => {
  assert.equal(
    geminiUrl("gemini-2.5-flash"),
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
  );
});
