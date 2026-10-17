# Retro 2026-10-17 · My Investments — proposed edits

Status: **proposal**. Nothing below is applied. Owner says yes or no per edit. Lessons are in [lessons.md](lessons.md).

## Proposed edits (all net zero)

1. **`.claude/agents/product-manager.md` line 31** (39 → 39 lines). The PM rule told the PM to write zakat formulas, so the PM wrote a zakat rule alone.
   - Before: `- **Financial math stays in the BRD.** Formulas for ROI, risk, zakat go here, not in code first.`
   - After: `- **Financial math stays in the BRD.** Formulas for ROI and risk go here, not in code first. Zakat, riba and screening rules come only from \`docs/product/shariah/*\` — link the consultant's rule, never write your own.`

2. **`.claude/agents/qa.md` line 24** (42 → 42 lines). AC-37 test checked one output; the engine was wrong on others. Also keeps what worked: QA recomputes the story's numbers.
   - Before: `- Every acceptance criterion in a story maps to at least one test. You keep the map in the story file.`
   - After: `- Every acceptance criterion maps to at least one test that asserts **every** number the criterion names, recomputed by you from the story. You keep the map in the story file.`

3. **`.claude/agents/orchestrator.md` line 26** (51 → 51 lines). Asking channel is fixed; one gap left: "run the 3 commands below" with no commands shown.
   - Before: `... and ask only through the desktop question prompt (never a question left in plain text).`
   - After: `... and ask only through the desktop question prompt (never a question left in plain text). Any step the human must run is shown in full in that prompt.`

## PRUNE

- **`CLAUDE.md` line 25** (48 → 47). The loop cap repeats `agent-loop.md` lines 26–36 (one home per rule). Line 23 already links there. Cut it.
- **`orchestrator.md` line 18** (51 → 50). "Only correctness bugs or Shariah compliance can force a 3rd loop" repeats `agent-loop.md` lines 32–35. Cut it.
- **`agent-loop.md` line 3** (74 → 74). Says "Seven roles"; the table has eight. Change to "Eight roles".

## Question for the owner (not an edit)

- **Who walks the app on the simulator?** `agent-loop.md` line 72 says "human, not an agent"; `developer.md` line 26 tells the developer to run the app in a simulator; `CLAUDE.md` line 37 says no manual steps at all. This session the orchestrator walked the simulator by hand while the developer's integration test drove the same simulator, and the walkthrough was unreliable. Proposal: developer line 26 → `3. Run the golden-path integration test — green.` and keep the human walk in the done gate. Impact if left: agents keep clashing on one simulator (slow, not a blocker).

## Not logged (over the 3-lesson cap)

- Parallel PR on `main` also made an ADR-0002 → two ADR-0002 files, rebase needed. Cost: one rebase. Log it if it happens again.
- Usage limit stopped 3 reviewers mid-task. Not a harness rule; no edit.
