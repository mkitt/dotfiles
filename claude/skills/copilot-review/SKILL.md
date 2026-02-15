---
name: copilot-review
description: Triage Copilot review comments on a PR. Categorizes each as Fix, Dismiss, or Decide with actionable recommendations.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob
---

# Copilot Review Triage

Read Copilot's review comments on the current PR and triage each one with an actionable recommendation.

## Steps

1. **Identify the PR** by running:
   - `gh pr view --json number,title,headRefName,url` from the current branch
   - If no PR is found, ask the user for a PR number

2. **Fetch Copilot review comments** by running:
   - `gh api repos/{owner}/{repo}/pulls/{number}/comments --jq '.[] | select(.user.login | test("copilot|github-actions|bot"; "i")) | {id, path, line, body, diff_hunk, created_at, in_reply_to_id}'`
   - Also check for PR review threads: `gh api repos/{owner}/{repo}/pulls/{number}/reviews --jq '.[] | select(.user.login | test("copilot|github-actions|bot"; "i")) | {id, body, state}'`
   - If no Copilot comments are found, tell the user and stop

3. **For each comment**, read the referenced file and surrounding code to understand context, then categorize it:
   - **Fix** — The comment identifies a real issue worth addressing
   - **Dismiss** — The comment is a false positive, not applicable, or the existing code is already correct
   - **Decide** — The comment raises a valid point but it's a judgment call (style preference, trade-off, scope question)

4. **Present the triage** using the output format below.

## Output Format

```
## PR #<number>: <title>
<url>

### Summary
- <N> comments total: <X> Fix, <Y> Dismiss, <Z> Decide

---

### Fix

#### <path>:<line>
> <quoted Copilot comment — brief>

**Recommendation:** <what to change and why>

**Suggested change:**
<code block showing the fix>

---

### Dismiss

#### <path>:<line>
> <quoted Copilot comment — brief>

**Why dismiss:** <short explanation>

**Dismiss response:**
> <ready-to-paste dismissal message for the PR comment>

---

### Decide

#### <path>:<line>
> <quoted Copilot comment — brief>

**Trade-off:** <explain both sides>

**If you agree:** <what to change>
**If you disagree:** <dismissal response to paste>
```

## Guidelines

- Order sections: Fix first, then Decide, then Dismiss (most actionable first)
- Within each section, group by file path
- Keep dismiss responses professional and brief (1-2 sentences)
- For fixes, show the actual code change — don't just describe it
- For decisions, be genuinely neutral — present both sides fairly
- If a Copilot comment is about something already handled elsewhere in the code, note that in the dismissal
- If multiple comments relate to the same underlying issue, group them together
- Read the actual source files before making recommendations — don't rely solely on the diff hunk
