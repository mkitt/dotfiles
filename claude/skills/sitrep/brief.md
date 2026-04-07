# brief

What needs attention going forward. Forward-looking.

Default period: today. Default scope: current user.

## Gathering

Run available sources in parallel for the resolved scope and period.

### Local Git

Check the current working directory and any repos from memory:

- `git log --oneline @{upstream}..HEAD 2>/dev/null` — unpushed commits → In progress
- `git diff --stat HEAD` — uncommitted changes → In progress
- `git stash list` — stashed work → In progress

Self scope only. Skip if scoped to another person.

### GitHub

Use `gh` CLI or `activity-github` subagent:

- PRs requesting [scope]'s review → Needs attention
- [scope]'s open PRs → In progress
- PR comments needing response → Needs attention

### Linear

`mcp__claude_ai_Linear__list_issues`:

- In-progress issues: `assignee: "me"`, `state: "started"` → In progress
- High-priority unstarted: `assignee: "me"`, `priority: 1` or `priority: 2` → Needs attention
- For another person, use `assignee: "<name>"` instead of `"me"`
- Skip issues not updated in 2+ weeks (backlog)

### Calendar

`mcp__claude_ai_Google_Calendar__gcal_list_events`:

- Events within the period, with times → Schedule
- Skip if scoped to another person

### Slack

`mcp__claude_ai_Slack__slack_search_public_and_private`:

- `to:<@slack_id> after:<last_workday>` — things directed at [scope]
- Direct questions and open threads → Needs attention
- Slackbot reminders: `from:slackbot to:<@slack_id>` → Reminders
- Self-DMs: `from:<@slack_id> in:<@slack_id>` — notes to self → Reminders

### Gmail

`mcp__claude_ai_Gmail__gmail_search_messages`:

- `is:unread` — count and top senders only (lightweight, not full triage)
- Skip if scoped to another person

## Output

```
Brief — <period description>

Schedule:
- 10:00 — Meeting name
- 14:00 — Meeting name

Needs attention:
- PR review requested by Jane (#1234)
- Linear issue blocked on your input

In progress:
- Your open PR: feature description (#5678)
- Linear: issue title (started)

Reminders:
- Research widgets (Slack reminder)
- Check deployment metrics (note to self)
```

If Gmail is available and there are unread emails, append:

```
Email: 12 unread — 3 from Jane, 2 from Linear notifications
```
