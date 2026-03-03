---
name: pr-review-comments
description: Triage PR review comments, apply fixes, and reply back. Categorizes each as Fix, Dismiss, or Decide with actionable recommendations.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob
---

# PR Review Comment Triage

Read review comments on the current PR and triage each one with an actionable recommendation. After user approval, apply fixes, commit, push, and reply to each comment in the PR.

## Phase 1: Triage

1. **Identify the PR** by running:
   - `gh pr view --json number,title,headRefName,url,author` from the current branch
   - If no PR is found, ask the user for a PR number

2. **Fetch review comments** by running:
   - `gh api repos/{owner}/{repo}/pulls/{number}/comments --jq '.[] | select(.user.login != "<author>") | {id, path, line, body, diff_hunk, created_at, in_reply_to_id, user: .user.login}'`
   - Also check for PR reviews: `gh api repos/{owner}/{repo}/pulls/{number}/reviews --jq '.[] | select(.user.login != "<author>" and .body != "") | {id, body, state, user: .user.login}'`
   - Replace `<author>` with the PR author's login from step 1
   - This captures comments from all reviewers — Copilot, bots, and humans alike
   - If no review comments are found, tell the user and stop

3. **For each comment**, read the referenced file and surrounding code to understand context, then categorize it:
   - **Fix** — The comment identifies a real issue worth addressing
   - **Dismiss** — The comment is a false positive, not applicable, or the existing code is already correct
   - **Decide** — The comment raises a valid point but it's a judgment call (style preference, trade-off, scope question)

4. **Present the triage** using the output format below.

## Phase 2: User Review

5. **Ask the user to review the triage.** Wait for them to:
   - Approve or revise dismissal reasons
   - Make calls on each "Decide" item (fix or dismiss)
   - Confirm which "Fix" items to address (or override any to dismiss)

Do not proceed until the user has signed off.

## Phase 3: Apply & Respond

6. **Apply fixes** for all confirmed fix items. Make the code changes in the codebase.

7. **Commit and push** once all fixes are applied:
   - Stage the changed files and commit with a descriptive message
   - Push to the remote branch

8. **Reply to PR comments** using the commit SHA from step 7:
   - For each **fixed** comment: reply with `Updated in <sha>` and a brief note on what changed
   - For each **dismissed** comment: reply with the approved dismissal reason
   - Use: `gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies -f body="<message>"`
   - Keep replies professional and concise

## Output Format

```
## PR #<number>: <title>
<url>

### Summary
- <N> comments total: <X> Fix, <Y> Dismiss, <Z> Decide

---

### Fix

#### <path>:<line> — @<reviewer>
> <quoted comment — brief>

**Recommendation:** <what to change and why>

**Suggested change:**
<code block showing the fix>

---

### Decide

#### <path>:<line> — @<reviewer>
> <quoted comment — brief>

**Trade-off:** <explain both sides>

**If you agree:** <what to change>
**If you disagree:** <dismissal reason>

---

### Dismiss

#### <path>:<line> — @<reviewer>
> <quoted comment — brief>

**Why dismiss:** <short explanation>

**Dismiss response:**
> <ready-to-paste dismissal message>
```

## Guidelines

- Order sections: Fix first, then Decide, then Dismiss (most actionable first)
- Within each section, group by file path
- Keep dismiss responses professional and brief (1-2 sentences)
- For fixes, show the actual code change — don't just describe it
- For decisions, be genuinely neutral — present both sides fairly
- If a comment is about something already handled elsewhere in the code, note that in the dismissal
- If multiple comments relate to the same underlying issue, group them together
- Read the actual source files before making recommendations — don't rely solely on the diff hunk
- Include the reviewer username in each item so the user knows who said what
- Copilot is a common reviewer — its comments can be dismissed more liberally when they miss context
