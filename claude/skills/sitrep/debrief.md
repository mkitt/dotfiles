# debrief

What happened during a time period. Backward-looking.

Default period: last workday. Default scope: current user.

## Gathering

Run available sources in parallel for the resolved scope and period.

### Local Git

Check the current working directory and any repos from memory:

- `git log --author="<name>" --after="<start_date>" --oneline` — local commits
- `git stash list` — stashed work (self scope only)
- `git branch --sort=-committerdate | head -5` — recently active branches

Local commits that haven't been pushed are often the most relevant
work — they represent what you were actually doing, not just what's
been shared. Include these even if they also appear in GitHub.

### GitHub

Use the `activity-github` subagent via the Agent tool:

- PRs merged by [scope] in the period
- PRs reviewed by [scope] in the period
- Notable commits by [scope] in the period

### Linear

`mcp__claude_ai_Linear__list_issues`:

- Completed issues: `assignee: "me"`, `state: "completed"`, `updatedAt: "-P<N>D"`
- For another person, use `assignee: "<name>"` instead of `"me"`

### Slack

`mcp__claude_ai_Slack__slack_search_public_and_private`:

- Person scope: `from:<@slack_id> after:<start_date>` — substantive
  messages only, skip greetings, reactions, short acks
- Channel scope: `in:<#channel> after:<start_date>` — all activity
- Self-DMs: `from:<@slack_id> in:<@slack_id>` — notes, links, thoughts
  captured during the period → Activity

### Calendar

`mcp__claude_ai_Google_Calendar__gcal_list_events`:

- Events within the period
- Skip if scoped to another person

## Output

Group by theme for multi-day periods, not by day.

### Person scope (default)

```
Debrief — <period description>

Completed:
- Item one
- Item two

Activity:
- Discussion or review
- Meeting name
```

### Channel scope

```
Debrief — #channel, <period description>

Key threads:
- Topic — summary (participants)

Decisions:
- What was decided
```
