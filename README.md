# agent-skills

Lean, quota-conscious personal agentic workflow skills (Layer 1 — cross-repo PR lifecycle & quality loop), synthesized from `t3code`/`tstack`, `pstack`'s structural principles, and deterministic repo guardrails (`manithy` & `article36`).

## Strict 3-model lineup

Cross-model review (`review-loop`) uses **only** these three models, always picking **1 reviewer from a different provider** than the builder (never 3-way council fan-out):

| Role / Provider | Model ID |
| --- | --- |
| Antigravity | `gemini-4-neon` |
| Codex | `gpt-6.1-sol` |
| Claude | `claude-opus-5-5` |

## Skills included

| Skill | Trigger | Purpose |
| --- | --- | --- |
| `review-loop` | `"review loop"` / before opening or merging a PR | Adversarial cross-model diff review (1 different-provider reviewer, max 2–3 rounds, finding ledger, zero scope creep). |
| `file-pr` | `"file a PR"` | Diff inspection, secret scan, repo verification (`pnpm verify`, changelog check), problem-first PR description, T3 PR linking. |
| `babysit-pr` | `"babysit"` | Event-driven PR monitoring via `watch_pull_request` (no sleep/poll), fixing real CI/bot findings, dismissing false positives with reason. |
| `ship-pr` | `"ship PR"` / `"full stop"` / `"full send"` | End-to-end orchestrator: prove → `review-loop` → `file-pr` → `babysit-pr`. Defaults to **stop at merge gate**; merges only when explicitly authorized. |
| `harden-repo` | `"harden repo"` / after a repeat agent mistake | Converts recurring agent mistakes into deterministic checks (lint, type, script, test, git hook, CI) instead of adding prose to `AGENTS.md`. |

## Architecture (2 layers)

- **Layer 1 (this repo):** Personal PR lifecycle & cross-model workflow installed globally across projects (`~/.claude/skills`, `~/.codex/skills`, `~/.agents/skills`, and Antigravity `config/skills`).
- **Layer 2 (each codebase's `.claude/skills/`):** Repo-specific domain skills (e.g., `add-feature`, `add-migration`, `change-api-contract`, `weekly-release`).

## Install

```bash
./install.sh          # symlink all skills into local harnesses
./install.sh --check  # verify installed symlinks
./install.sh --uninstall
```
