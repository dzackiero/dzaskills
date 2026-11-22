---
name: harden-repo
description: Turn a repeated agent mistake or preventable review bug into a deterministic structural guardrail (lint rule, type, script, test, git hook, or CI check) instead of adding prose to AGENTS.md.
---

# Harden the repo (encode lessons in structure)

Inspired by `pstack`'s *Encode Lessons in Structure* and the deterministic ratchets in `article36` & `manithy`.

## When to use

- An agent (or review loop) catches the same class of mistake twice.
- A bug slipped past local checks and was only caught by a reviewer or CI (e.g. invalid GitHub Actions expression, stale script path in docs, forbidden edit, missing changelog note).

## Hierarchy of fixes (pick the highest practical layer)

1. **Make it unrepresentable in types / schema** (TypeScript strict types, Zod contracts in `packages/contracts`).
2. **Lint or static analysis** (ESLint rule, `actionlint` on `.github/workflows/*.yml`, `check-agents-md.mjs`).
3. **Ratchet script** (a small Node script + baseline list that can only shrink, e.g. legacy style blocks or migration journal check).
4. **Unit test or regression test** covering the exact edge case.
5. **Git hook / harness hook** (`.githooks/pre-commit`, `lefthook.yml`, `.claude/settings.json`) so *every* harness—Claude Code, Codex, Antigravity, and manual git—hits the same wall.
6. **Prose in `AGENTS.md` (last resort):** keep `AGENTS.md` short (~60–120 lines); add one crisp bullet only if no automated check can catch it.

## Workflow

1. Name the exact failure mode in one sentence.
2. Pick the smallest deterministic check from the hierarchy above.
3. Prove the check fails on the bad case and passes on the fixed case.
4. Wire it into the repo's single check entrypoint (`pnpm verify`, `scripts/*.spec.mjs`, `.githooks/`, or CI).
