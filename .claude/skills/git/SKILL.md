---
name: git-standards
description: Git conventions for commits, branches, and using git as a context source. Use when committing code, creating branches, or needing to understand repository history.
---

# Git Standards

## Core Principles

- **Git as context** - Use git to understand the codebase before making changes
- **Atomic commits** - Each commit represents one logical change
- **Clear history** - Commit messages document why, not how

## Git as Context

Use git to understand before acting:

- `git log --oneline -20` - Recent history for commit style and patterns
- `git log --oneline <file>` - File history
- `git diff <branch>...HEAD` - Changes since branching
- `git blame <file>` - Change attribution

## Commit Messages

Follow [tbaggery](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) format:

```
Subject line, 50 chars max, imperative mood

Body wrapped at 72 chars. Explain why, not how.
```

**Subject line:**

- 50 characters max (hard limit)
- Imperative mood: "Add feature" not "Added feature"
- Capitalize first word, no period at end

**Body:**

- Blank line after subject
- Wrap at 72 characters (hard limit)
- Explain why, not how

**Example:**

```
Add rate limiting to webhook endpoints

Prevents abuse from high-frequency callers. Limits set per
API key with configurable thresholds.
```

## Branch Naming

Use `<type>/<description>` in kebab-case:

- `feature/user-authentication`
- `fix/webhook-race-condition`
- `chore/upgrade-dependencies`

Types: `feature`, `fix`, `refactor`, `chore`, `docs`
