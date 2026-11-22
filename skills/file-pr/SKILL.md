---
name: file-pr
description: Inspect a branch diff, scan for secrets, verify repo checks, and open a concise problem-first GitHub pull request linked to the current thread.
---

# File a pull request

## Preflight checklist

1. **Check existing PR:** `gh pr list --head "$(git branch --show-current)" --state open`. If one exists, update it instead of creating a duplicate.
2. **Inspect the whole diff:** run `git status --short`, `git log --oneline <base>..HEAD`, and `git diff --stat <base>...HEAD`. Confirm no stray scratch files, debug logs, or unintended edits slipped in.
3. **Secret scan:** inspect the diff for real API keys, tokens, passwords, connection strings, or `.env*` files (only `.env.example` is allowed). Abort and remove any secret before pushing.
4. **Run repo checks:**
   - Run the repo's verification command (`pnpm verify`, or the scoped app/script checks when changes stay strictly within one scope—always state exactly what ran).
   - If the repo enforces PR changelog notes (e.g. `package.json` has `changelog:check`), run `pnpm changelog:check` and add a short note or mark internal-only as appropriate.
5. **Respect repo review rules:** if the repo uses a second-reviewer convention (e.g. `manithy`'s `Hard part, second reviewer: <name>`), include it in the PR body.

## PR description format (problem-first)

Lead with **why**, not a file-by-file dump:

```markdown
## Why
One to two sentences on the problem or user outcome.

## What changed
- Concise bullets grouped by behavior/slice.

## Proof
- Exact commands run and observed results (test counts, build status, dry-run output, or UI check).
```

## After creating or pushing

- Push with `git push -u origin <branch>` (never force-push `main` or `production`).
- When in T3 Code, immediately call `link_pull_request` (or `link_pull_requests` for stacked PRs) with the full PR URL.
