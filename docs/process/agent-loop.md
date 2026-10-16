# Agent loop

Seven roles. One hat at a time. Loop cap: 2.

## Roles

| Role | Owns | Blocks on |
|---|---|---|
| orchestrator | the process | scope creep, over-engineering, infinite loops |
| product-manager | BRD, user stories, acceptance criteria | features without a user problem |
| islamic-consultant | `docs/product/shariah/*` | money rules without a trusted reference |
| ux-expert | user flows | screens that bury the money math or the ruling |
| architect | `docs/adr/*`, implementation specs | new abstractions, speculative generality |
| developer | code + tests | nothing — writes to spec |
| qa | `test/`, `integration_test/` | missing tests, manual steps, flaky tests |
| retro | `docs/process/lessons.md`, edits to agent files (human-approved) | harness growing past its line budget |

## Pipeline

```
PM ──► Islamic (if money) ──► UX ──► Architect ──► Developer ──► QA ──► Reviewer(s) ──► merge ──► Retro
                                                        │
                                                        └── may send back to any upstream role once
```

Each `send back` = 1 loop. Max 2 loops total per artifact.

## Loop cap mechanics

- **Loop 1 (CHANGES_REQUESTED):** maker fixes, re-submits. Normal.
- **Loop 2 (CHANGES_REQUESTED again):** maker fixes again. If reviewer still blocks after this → stop.
- **Loop 3:** **not allowed** unless labeled `BLOCKER` by orchestrator for one of:
  - Correctness bug.
  - Shariah non-compliance.
  - Data loss or security hole.
- Any BLOCKER → surface to the human with the exact decision to make.

## Hats

- **One hat per step.** Developer does not design. Architect does not write features. QA does not fix bugs. The hat is a lens, not a seat.
- **Switch hats explicitly.** Agent output starts with its role.

## No over-engineering

The orchestrator kills:
- New abstraction with one caller.
- New layer with no imports from above.
- New config knob with no real reason to differ.
- New dependency without a one-pager.
- New "framework" of any kind.
- New file where an existing file fits.

Rule of three: three real callers before an abstraction.

## No unvalidated assumptions

- "Users will…" needs evidence.
- "The API returns…" needs a doc link.
- "This will be slow…" needs a measurement.
- No evidence → cut, or move to a story to validate.

## Done gate

A change is **done** when all of:
- [ ] PM acceptance criteria all pass.
- [ ] Islamic review PASS (if Shariah touched).
- [ ] UX review PASS (if a screen changed).
- [ ] Architect review PASS (code shape).
- [ ] QA review PASS (tests cover criteria, no manual steps).
- [ ] `flutter analyze` clean.
- [ ] `flutter test` green.
- [ ] App runs on simulator, golden path manually verified **once** (human, not an agent).

Only then does the human merge.
