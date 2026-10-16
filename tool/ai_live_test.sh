#!/usr/bin/env bash
# Live AI test on the booted iOS simulator: real Gemini, real device storage,
# local Worker. The key stays in $AI_ENV_FILE, outside the repo. See ADR-0002.
set -euo pipefail

ENV_FILE="${AI_ENV_FILE:-$HOME/.config/financial-planner/ai.env}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

[[ -f "$ENV_FILE" ]] || { echo "Missing $ENV_FILE (see ADR-0002)."; exit 1; }
if grep -q 'PASTE_YOUR_KEY_HERE' "$ENV_FILE" || ! grep -qE '^GEMINI_API_KEY=.{20,}$' "$ENV_FILE"; then
  echo "Put your Gemini key in $ENV_FILE first."; exit 1
fi
DEVICE="$(xcrun simctl list devices booted | grep -Eo '\([0-9A-F-]{36}\)' | head -1 | tr -d '()')"
[[ -n "$DEVICE" ]] || { echo "Boot an iOS simulator first."; exit 1; }

cp "$ENV_FILE" "$ROOT/ai-proxy/.dev.vars"
LOG="$(mktemp -t ai-proxy)"
cd "$ROOT/ai-proxy"
[[ -d node_modules ]] || npm ci --silent
set -m
npx wrangler dev --ip 127.0.0.1 --port 8787 >"$LOG" 2>&1 &
WORKER=$!
set +m
trap 'kill -- -$WORKER 2>/dev/null || true; rm -f "$ROOT/ai-proxy/.dev.vars"' EXIT

for _ in $(seq 60); do
  curl -s -o /dev/null http://127.0.0.1:8787/ && break
  sleep 1
done
curl -s -o /dev/null http://127.0.0.1:8787/ || { echo "Worker did not start; log: $LOG"; exit 1; }

cd "$ROOT"
flutter test integration_test/ai_live_test.dart -d "$DEVICE" --dart-define-from-file="$ENV_FILE"
