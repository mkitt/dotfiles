---
name: commit-groups
description: Create an outline of files and/or chunks to be staged
disable-model-invocation: true
allowed-tools: Bash, Skill
---

# Commit Groups

Analyze all uncommitted changes and propose logical groupings that each form an atomic, coherent commit.

## Constraints

- **NEVER run `git add`, `git stage`, or any command that modifies the index.** The user stages files themselves.
- You may run `git commit` when the user explicitly asks you to (via `/commit` or direct request).
- You may run read-only git commands: `git status`, `git diff`, `git log`, `git show`, etc.

## Steps

1. **Gather context** by running the following in parallel:
   - `git status` to see all modified, staged, and untracked files
   - `git diff` to see unstaged changes with content
   - `git diff --cached` to see already-staged changes

2. **Analyze the changes** and identify natural groupings based on:
   - Shared purpose (feature, bugfix, refactor, config, docs, tests)
   - Logical coupling (files that must ship together to stay consistent)
   - Dependency order (foundational changes before dependent ones)

3. **Present the outline** using the output format below.

## Output Format

An ordered list of groups. Each group has a short title and the files or chunks to stage:

```
1. <Short title>
   - path/to/file.ext
   - path/to/other.ext

2. <Short title>
   - path/to/file.ext (hunks: <description of which hunks>)
   - path/to/another.ext
```

When a file has unrelated changes that belong to different groups, list it with a `(hunks: ...)` note describing which parts of the diff belong to that group.

## Guidelines

- Order groups from most foundational to most dependent
- Keep groups small and atomic — each should be a single logical change
- If everything belongs in one commit, say so (don't force unnecessary splits)
- If changes are already staged, note them as a pre-existing group
