# dzaskills

A lean, quota-conscious collection of reusable AI coding agent skills for pull request workflows, cross-model code review, CI monitoring, and deterministic repository hardening.

Built to work across any codebase and any supported agent harness (Claude Code, Codex, generic `~/.agents/skills` clients, and T3 Code / Antigravity).

## Skills included

| Skill | Typical trigger | What it does |
| --- | --- | --- |
| `review-loop` | `"review loop"` / before opening or merging a non-trivial PR | Runs a focused adversarial code review with **one** reviewer from a different model provider than the builder (max 2–3 rounds, tracked finding ledger, zero scope creep). |
| `file-pr` | `"file a PR"` | Inspects the branch diff, scans for accidentally staged secrets, runs the repo's local verification checks, and opens a concise problem-first GitHub PR. |
| `babysit-pr` | `"babysit"` | Monitors an open PR's CI checks and review comments using event-driven watching (no sleep/polling loops), fixes real findings, and reports readiness. |
| `ship-pr` | `"ship PR"` / `"full stop"` / `"full send"` | End-to-end orchestrator: verify → `review-loop` → `file-pr` → `babysit-pr`. Defaults to stopping at the merge gate (`full-stop`); merges only when explicitly authorized (`full-send`). |
| `harden-repo` | `"harden repo"` / after a repeated agent mistake | Turns recurring agent mistakes or preventable bugs into deterministic guardrails (lint rules, types, scripts, tests, git hooks, or CI checks) instead of piling prose into `AGENTS.md`. |

## Typical workflow

```text
implement & verify ──▶ review-loop ──▶ file-pr ──▶ babysit-pr ──▶ merge gate
                          ▲                                           │
                          └───────── fix real findings ───────────────┘

(or invoke `ship-pr` to run the entire pipeline; use `harden-repo` whenever a bug repeats)
```

## Cross-model review lineup

To keep reviews sharp without burning quota on multi-model fan-out, `review-loop` picks **one** reviewer from a different provider than the model that wrote the code, restricted to:

| Provider | Model ID |
| --- | --- |
| Antigravity | `gemini-4-neon` |
| Codex | `gpt-6.1-sol` |
| Claude | `claude-opus-5-5` |

## Two-layer setup

- **Layer 1 (`dzaskills`, global):** Repo-agnostic PR lifecycle and quality-loop skills installed once per machine.
- **Layer 2 (per repository):** Project-specific domain playbooks (feature checklists, migration safety, release procedures, etc.) checked into each repo's own skills directory alongside deterministic git hooks and CI checks.

## Installation

```bash
git clone git@github.com:dzackiero/dzaskills.git
cd dzaskills
./install.sh          # symlink all skills into detected local agent harnesses
./install.sh --check  # verify all symlinks are healthy
```

`install.sh` symlinks every folder under `skills/` into:

- `~/.claude/skills/`
- `~/.codex/skills/`
- `~/.agents/skills/`
- `~/.t3/userdata/providers/antigravity/*/config/skills/` (when present)

To remove all symlinks managed by this repo:

```bash
./install.sh --uninstall
```

## Adding or customizing skills

Each skill lives in `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name` and `description`) followed by concise markdown instructions. After adding a new skill folder, re-run `./install.sh` to link it across all harnesses.
