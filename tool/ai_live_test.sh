#!/usr/bin/env bash
# Live AI test on the booted iOS simulator: real Gemini, real device storage.
# The key stays in $AI_ENV_FILE, outside the repo. See ADR-0005.
set -euo pipefail

ENV_FILE="${AI_ENV_FILE:-$HOME/.config/financial-planner/ai.env}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

[[ -f "$ENV_FILE" ]] || { echo "Missing $ENV_FILE (see ADR-0005)."; exit 1; }
if grep -q 'PASTE_YOUR_KEY_HERE' "$ENV_FILE" || ! grep -qE '^GEMINI_API_KEY=.{20,}$' "$ENV_FILE"; then
  echo "Put your Gemini key in $ENV_FILE first."; exit 1
fi
DEVICE="$(xcrun simctl list devices booted | grep -Eo '\([0-9A-F-]{36}\)' | head -1 | tr -d '()')"
[[ -n "$DEVICE" ]] || { echo "Boot an iOS simulator first."; exit 1; }

cd "$ROOT"
flutter test integration_test/ai_live_test.dart -d "$DEVICE" --dart-define-from-file="$ENV_FILE"
