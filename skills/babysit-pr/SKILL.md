---
name: babysit-pr
description: Monitor an open pull request through CI checks and review comments using event-driven watching, fix real findings, and report readiness without polling loops.
---

# Babysit a pull request

## Rules

1. **Handle existing state first:** check `gh pr checks` and existing review comments/threads before starting a watch.
2. **Event-driven waiting only:** in T3 Code, call `watch_pull_request` on the PR URL and **end your turn**. Never run `sleep`, `while` loops, `gh pr checks --watch`, or timers to poll a PR.
3. **On each wake:**
   - **Failing CI check:** fetch the failed job log (`gh run view <id> --log-failed`), diagnose root cause, apply the minimal fix, verify locally, and push.
   - **Review comment (human or bot):**
     - If genuine: fix minimally, verify, push, and reply briefly citing the fix.
     - If false positive or out of scope: reply concisely with the technical reason rather than churning code.
     - If a comment requires a product/architecture decision: stop and ask the user.
   - **Merge conflict:** rebase cleanly onto the base branch (`git fetch origin <base> && git rebase origin/<base>`), re-run verification, and `git push --force-with-lease`.
4. **Before handing back to the user:** always call `unwatch_pull_request` so the thread returns cleanly to the user's inbox.
