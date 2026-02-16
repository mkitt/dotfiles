---
name: commit-staged
description: Create a commit for staged files
disable-model-invocation: true
allowed-tools: Bash, Skill
---

Create a git commit for the currently staged files.

1. **Load the git skill** for commit message standards
2. **Check staged changes** with `git diff --cached --stat` and `git diff --cached`
3. **Review recent commits** with `git log --oneline -5` for style consistency
4. **Draft the commit message** following the git skill guidelines:
   - Subject: 50 chars max, imperative mood, capitalized, no period
   - Body: Explain why (not how), wrapped at 72 chars
   - Include the Claude Code footer
5. **Immediately execute `git commit`** with the drafted message

Do NOT ask for text approval - Claude Code's permission prompt handles that.
If no files are staged, inform the user and do not create an empty commit.
