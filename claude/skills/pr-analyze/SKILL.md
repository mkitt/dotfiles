---
name: pr-analyze
description: Analyze a PR and recommend review comments. Use when asked to review, analyze, or look at a PR. Takes a PR number or URL. Examples - "review PR #142", "analyze this PR", "look at PR 154".
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, AskUserQuestion
---

# PR Analyze

Analyze a pull request and recommend review comments, categorized by severity. Does not post comments until the user approves.

## Phase 1: Analyze

1. **Identify the PR** from the user's input (number, URL, or branch name):
   - `gh pr view <identifier> --json number,title,headRefName,url,author,body`
   - If ambiguous, ask the user to clarify

2. **Fetch the diff**:
   - `gh pr diff <number>`
   - If the diff is very large, note the size and focus on non-lockfile, non-generated changes

3. **Read the diff thoroughly** and categorize findings into three tiers:
   - **Must-fix** — Bugs, security issues, broken logic, missing error handling, convention violations that the project explicitly prohibits
   - **Worth discussing** — Design trade-offs, naming choices, unrelated changes bundled in, missing tests, subtle behavioral changes that deserve a callout
   - **Looks good** — Notable positives worth calling out (good patterns, smart decisions, nice cleanups)

4. **For each finding**, note:
   - The file and approximate line (from the diff)
   - A concise description of the issue
   - Why it matters
   - A suggested fix or question to pose (for must-fix and worth-discussing items)

5. **If context is insufficient** from the diff alone (e.g., need to understand surrounding code, trace a type, check a convention), ask the user:

   > "I'd like to check out this branch locally to read some source files for better context. Want me to run `gh pr checkout <number>`?"

   Do not checkout without asking. Stay diff-only by default.

6. **Present the analysis** using the output format below, ending with a recommendation.

## Phase 2: Post (user-initiated)

Only proceed here when the user asks to post comments (e.g., "post those", "submit the review", "leave those comments").

7. **Confirm what to post** — the user may have edited the list, dropped items, or changed wording. Confirm which comments to post and the review type:
   - **Approve** — approve with comments
   - **Request changes** — block on must-fix items
   - **Comment** — neutral, just leaving feedback

8. **Post the review** as a single GitHub review with inline comments using the `gh api` reviews endpoint. Keep comment text professional and concise.

## Output Format

```
## PR #<number>: <title>
<url>

### Summary
<1-2 sentence description of what this PR does>

<N> findings: <X> must-fix, <Y> worth discussing, <Z> looks good

---

### Must-fix

**<file>:<line> — <short title>**
<description of the issue and why it matters>
Suggested fix: <concrete suggestion or code snippet>

---

### Worth discussing

**<file>:<line> — <short title>**
<description and trade-off>

---

### Looks good

- <file> — <what's good about it>

---

### Recommendation
<Approve | Request changes | Comment> — <brief rationale>
```

## Guidelines

- Order sections: Must-fix, Worth discussing, Looks good
- Within each section, group by file path
- Be concise — this is a focused scan, not a dissertation
- Compare the diff against the PR description — flag changes that aren't part of the stated goal
- Check for project convention violations (read CLAUDE.md and project docs if available)
- Don't nitpick style if the project has automated formatting
- Don't flag things that linters/typecheckers would already catch
- If the PR is clean, say so — an empty must-fix section is a good thing
- The "looks good" section is optional — only include when something genuinely stands out
- Show the reviewer username context is not needed since the user is the reviewer
- If the diff includes lockfile changes, skip them unless something looks wrong
