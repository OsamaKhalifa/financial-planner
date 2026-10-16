// The only vendor-specific code in the AI stack. To change vendor, replace
// this file and the fetch call in index.ts; the app does not change.

export interface NeutralRequest {
  instruction: string;
  input: string;
  maxOutputTokens: number;
}

export function geminiUrl(model: string): string {
  return `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(model)}:generateContent`;
}

export function toGeminiRequest(req: NeutralRequest): unknown {
  return {
    systemInstruction: { parts: [{ text: req.instruction }] },
    contents: [{ role: "user", parts: [{ text: req.input }] }],
    generationConfig: { maxOutputTokens: req.maxOutputTokens },
  };
}

/** Joined text of the first candidate, or null when there is none. */
export function fromGeminiResponse(body: unknown): string | null {
  const parts = (body as any)?.candidates?.[0]?.content?.parts;
  if (!Array.isArray(parts)) return null;
  const text = parts
    .map((p: any) => (typeof p?.text === "string" ? p.text : ""))
    .join("");
  return text.length > 0 ? text : null;
}
