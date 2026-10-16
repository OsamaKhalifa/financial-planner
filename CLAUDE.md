# Financial Planner — project rules

Flutter mobile app, iOS + Android. **No server side in v1.** All data on device.
State mgmt: **Riverpod** + feature-first folders. Dart null-safe.
Storage: SQLite via Drift, **always behind a repository interface** — a server store may replace it later. See [ADR-0001](docs/adr/0001-data-access-behind-repositories.md).

## Always

- **Swim the existing channel.** Before adding a new file, class, or helper, find the one that already does most of the job and extend it. A new parallel path looks clean on day one and splits the codebase in two by month three.
- **No over-engineering.** Three similar lines is fine. Do not design for hypotheticals.
- **Constructor injection** everywhere. No service locators, no globals.
- **No comments explaining WHAT.** Only non-obvious WHY.
- **Commit and push freely** on feature branches and open PRs without asking (side project — this overrides the global "ask before committing" rule). Only the human merges to `main`.
- **Never add Claude/AI attribution** to commits, PRs, or review comments.
- **Never fix a bug before you understand the root cause.** Reproduce, write a failing test, then fix.
- All money math uses `Decimal`, never `double`.
- **Runtime data never lives in the repo.** The DB file goes only in the app sandbox (`path_provider` app-support dir). Tests use an in-memory DB. Anything personal for local testing (sample numbers, exports) goes in `local/` — gitignored. CI fails if a DB file is ever tracked.
- Every Shariah-related rule must cite a trusted reference (AAOIFI, specific scholar, specific hadith/ayah). No "I think it is halal."

## Agent harness

Eight role agents live in `.claude/agents/` (incl. `retro`, which improves the harness from lessons in `docs/process/lessons.md`). Rules in [docs/process/agent-loop.md](docs/process/agent-loop.md).

**Loop cap: 2.** A reviewer who still blocks after loop 2 → escalate to the human. Correctness or Shariah bugs can force loop 3, must be labeled BLOCKER.

Agents never add scope. Scope changes come from the human only.

## Where to read first

- Product: [docs/product/brd.md](docs/product/brd.md)
- Process: [docs/process/agent-loop.md](docs/process/agent-loop.md)
- Architecture decisions: `docs/adr/NNNN-title.md` (one file per decision)

## Testing

- 100% automated. No manual test steps in the done gate.
- Unit tests next to the file: `foo.dart` → `foo_test.dart`.
- Widget tests for every screen.
- Integration tests for every end-to-end flow listed in the BRD.
- `flutter test` must pass on CI before merge.

## Branches & commits

- Branches: `feat/<short>`, `fix/<short>`, `chore/<short>`, `docs/<short>`.
- Commit style: `<type>: <imperative one-liner>`. Body if needed. No AI attribution.
- Only the human merges to `main`. PRs require green CI.
- PR description stays short: what, why, how it was tested. No template.
