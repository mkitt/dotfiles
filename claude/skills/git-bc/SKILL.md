---
name: git-bc
description: >-
  Post-merge branch cleanup. Switches to the default branch, pulls latest, and
  deletes the stale local branch. Use after a PR merges.
argument-hint: "[branch-name]"
allowed-tools: Bash
---

# git-bc — Branch Cleanup

Run these commands in order. Stop and report any error.

```bash
STALE=$([ -n "$ARGUMENTS" ] && echo "$ARGUMENTS" || git branch --show-current)
DEFAULT=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')
DEFAULT=${DEFAULT:-main}

git switch "$DEFAULT" && git pull --ff-only && git branch -D "$STALE" && git remote prune origin
```

Report one line: `Switched to <default>, pulled, deleted <stale>, pruned remote refs.`
