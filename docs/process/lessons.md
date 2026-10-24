# Lessons

Owned by the `retro` agent. One line per lesson, max 25 entries. Format and rules in [.claude/agents/retro.md](../../.claude/agents/retro.md).

- 2026-10-16 · harness · Project agents were not loadable by name because the session started in another repo with a same-named `architect` agent; agents ran as general agents reading their role file; happened again 2026-10-17 (My Investments) and in zakat feature (architect ran as general-purpose) · cost: no wrong output yet, risk of wrong agent · status: open
- 2026-10-17 · product-manager · PM wrote a zakat rule (dividends-only → set-aside 0) without the consultant; UX caught the contradiction with the consultant's ruling · cost: forced BLOCKER loop 3 on the story · status: open
- 2026-10-17 · qa · AC-37 test asserted only simple ROI, so 5 engine bugs (e.g. metals since-start return 0% instead of −3.85%) and the gold gross/pure 14% overvalue passed tests; keep: QA recomputing every worked number from the story found 0 story bugs · cost: 2 code-review loops · status: open
- 2026-10-17 · orchestrator · Owner corrected the ask channel 3 times: questions left in plain text, "run the 3 commands below" with no commands shown, asking for a go between phases · cost: 3 human corrections · status: folded → CLAUDE.md, orchestrator.md (fixed in session)
- 2026-10-24 · developer · Code review found 2 BLOCKERS in state-change paths (year vanished after cycle change + moved due date; Recompute after base-currency change crashed the tab); both reproduced by a failing test first · cost: 1 code-review loop · status: open
- 2026-10-24 · product-manager · Story needed 2 loops (consultant BLOCKER: rebuilding due years; UX found wrong AC-11 number) and QA later found the UX doc contradicting story AC-9 (extra lines without share/zakat): same fact written in two docs drifted · cost: 1 story loop + 1 late QA finding · status: open
- 2026-10-24 · orchestrator · Main moved 4 commits mid-work; generated-file/ARB conflicts at rebase were cheaper after squashing code commits first; keep: squash before rebase · cost: low (worked well) · status: open
