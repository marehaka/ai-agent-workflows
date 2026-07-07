# Close-Record — <issue/block id>: <short scope>

<!--
The baton between agents. The WORKER writes sections 1–5 before or with the
PR. The MAINTAINER appends section 6. The ORCHESTRATOR reads once, promotes
candidates, archives. One file, three writers.

Rule: no PR without a close-record. Every field below earned its place by
being, at some point, the missing piece that made review expensive.
-->

## 1. What changed, and why

<!-- 3–8 lines. The change and its reason, not a diff narration. -->

## 2. Verification

- Type check: <pass/fail + numbers>
- Tests: <suites run, added, results>
- Lint: <result>
- Manual verification: <what was actually exercised, or "none" — say so>

## 3. Known risks  ⚠ most important section

<!-- Shared files other branches touch (name them), migrations, external
     dependencies, anything the reviewer must know BEFORE merging.
     "None identified" is a valid entry; silence is not. -->

## 4. Out of scope

<!-- What this block deliberately did NOT do, so nobody assumes it did. -->

## 5. Handoff notes

- **To reviewer:** <what to look at hardest>
- **To planner:** <follow-up candidates, discovered issues (verified as
  non-duplicates before filing)>
- **Decision/learning candidates:** <anything worth promoting to the logs>

---

## 6. Reviewer verdict *(appended by the maintainer)*

- Technical acceptance: <accepted / changes requested + why>
- Merged: <PR link / sha>
- Issue state: <closed / follow-ups filed>
- Repo hygiene: <branch cleanup, main sync>
