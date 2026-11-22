---
name: ship-pr
description: Orchestrate a branch from implementation proof through cross-model review, PR creation, and CI monitoring. Defaults to stopping at the merge gate for human approval (full-stop); merges only when explicitly authorized (full-send).
---

# Ship a pull request

Two modes:
- **Default (`full-stop`):** prove → `review-loop` → `file-pr` → `babysit-pr` → **stop at merge gate** and hand back to the user with evidence.
- **Explicit merge (`full-send`):** same pipeline + merge automatically **only when the user explicitly asked to merge** in the current request.

## Pipeline

1. **Gather real proof** on the current HEAD commit:
   - Run tests/typecheck/build/smoke/dry-run covering the changed behavior.
   - Mocked unit tests alone do not prove UI or workflow validity (e.g., lint GitHub Actions YAML with `actionlint`, test CLI `--dry-run`, or verify UI in browser when requested).
2. **Cross-model review (`review-loop`):**
   - Run 1 approved cross-provider reviewer (`gemini-4-neon` / `gpt-6.1-sol` / `claude-opus-5-5`).
   - Fix `BLOCKER` and valid `SHOULD` findings; run Round 2 verification if needed.
3. **Open or update PR (`file-pr`):**
   - Secret scan, problem-first body with proof, link PR in T3 Code.
4. **Monitor CI & reviews (`babysit-pr`):**
   - Watch via `watch_pull_request` until all checks finish and review findings are resolved.
5. **Merge gate** (all must be true on the latest commit SHA):
   - Verification proof covers the latest commit.
   - Zero open `BLOCKER` findings from `review-loop`.
   - All CI checks pass (0 failing, 0 pending).
   - No unresolved human change requests; repo-specific review rules (e.g., `Hard part, second reviewer`) satisfied.
   - Branch is mergeable with no conflicts.
   - **Never** bypass branch protection (`--admin` is forbidden).

## Ending the run

- In default (`full-stop`) mode: call `unwatch_pull_request`, summarize the proof, review findings fixed, and CI status, and let the user merge.
- In authorized (`full-send`) mode: merge cleanly (`gh pr merge --merge --delete-branch` or the repo's merge convention), call `unwatch_pull_request`, and report the merge commit SHA.
