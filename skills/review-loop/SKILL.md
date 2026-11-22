---
name: review-loop
description: Run a focused, quota-conscious cross-model adversarial code review on a diff or PR using only the approved 3-model lineup (gemini-4-neon, gpt-6.1-sol, claude-opus-5-5). Use before opening or merging a non-trivial PR.
---

# Cross-model review loop

One fresh reviewer from a **different provider** catches bugs the builder is blind to—without paying for a 3-model council.

## Approved model lineup (strict)

Use **only** these three models:

- `gemini-4-neon` (Antigravity)
- `gpt-6.1-sol` (Codex)
- `claude-opus-5-5` (Claude)

Rules:
1. Call `orchestrator_capabilities` once per thread before delegating.
2. Pick **exactly 1** reviewer from a **different provider** than your own current model:
   - If you are `gemini-4-neon`: prefer `gpt-6.1-sol` (if Codex is authenticated), otherwise `claude-opus-5-5`.
   - If you are `claude-opus-5-5`: prefer `gpt-6.1-sol` (if Codex is authenticated), otherwise `gemini-4-neon`.
   - If you are `gpt-6.1-sol`: prefer `claude-opus-5-5`, otherwise `gemini-4-neon`.
3. Never silently switch to an unapproved model (no Haiku/Sonnet/Flash fallback). If a specifically requested model is unavailable (e.g., Codex not logged in), state why and either use the remaining approved cross-provider model or ask the user.
4. Every review round is a **fresh** `delegate_task` (`role: "review"`, `isolation: "shared"`, `mode: "async"`). Do not reuse a review thread with `t3_thread_send`.

## Round budget

- **Default max: 2 rounds.**
  - **Round 1:** Full adversarial review of the diff against base branch (security, workflow/CI validity, edge cases, contract safety, repo conventions).
  - **Round 2:** Verify ONLY the Round 1 fixes and check for regressions introduced by the fixes. Do not hunt for new nits.
- **Extended max: 3 rounds** ONLY if an open `BLOCKER` or `SHOULD` touches auth, permissions, billing, migrations, secrets, or concurrency.
- Stop immediately once the verdict is `APPROVE` or only `NIT`s remain.

## Finding ledger & scope control

Track every finding from Round 1 in a compact ledger: `ID | Severity (BLOCKER/SHOULD/NIT) | Outcome (fixed / pushed back with reason / deferred)`.

- Fix all `BLOCKER` findings before merging.
- Fix genuine `SHOULD` findings with the **smallest clean edit**; push back concisely with evidence if a suggestion is wrong or out of scope.
- Ignore style-only `NIT`s unless trivial and obviously better.
- Re-run relevant tests/checks after applying fixes, then run Round 2 if any `BLOCKER` or risky `SHOULD` was fixed.
