---
name: create-pr
description: Create a pull request for the current branch
disable-model-invocation: true
allowed-tools: Bash, Skill
---

Create a GitHub pull request for the current branch.

1. **Invoke the `github` skill** (via the Skill tool) to load PR standards into context
2. **Check branch status** with `git status` and confirm the branch is not `main`
3. **Review all commits on this branch** with `git log --oneline main..HEAD` and `git diff main...HEAD --stat`
4. **Read the full diff** with `git diff main...HEAD` to understand all changes
5. **Push the branch** with `git push -u origin HEAD` if not already pushed
6. **Draft the PR title and body** following the github skill guidelines:
   - Title: Short, under 70 chars
   - Body: Summary, test plan, and Claude Code footer
7. **Immediately execute `gh pr create`** with the drafted title and body

Do NOT ask for text approval - Claude Code's permission prompt handles that.
If already on `main`, inform the user they need to be on a feature branch.
If a PR already exists for this branch, inform the user and provide the URL.
