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

# Remove a *separate* worktree on the stale branch (not the current one) so
# the branch is free to delete. Errors if the worktree has uncommitted changes.
CURRENT=$(git rev-parse --show-toplevel)
WORKTREE=$(git worktree list --porcelain | awk -v b="refs/heads/$STALE" '
  /^worktree / { wt = $2 }
  $0 == "branch " b { print wt }
')
if [ -n "$WORKTREE" ] && [ "$WORKTREE" != "$CURRENT" ]; then
  git worktree remove "$WORKTREE" || exit 1
fi

git switch "$DEFAULT" && git pull --ff-only && git branch -D "$STALE" && git remote prune origin
```

Report one line: `Switched to <default>, pulled, deleted <stale>, pruned remote refs.`
If a worktree was removed, prepend `Removed worktree <path>, `.
