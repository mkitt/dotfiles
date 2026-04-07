---
name: sitrep
description: >-
  Daily situation report. Gathers activity from connected sources (GitHub, Slack,
  Linear, Calendar, Gmail) to debrief what happened, brief what's ahead, and
  muster a composed summary. Use when the user wants to review activity, check
  what's coming up, or prepare a daily update.
argument-hint: "<debrief|brief|muster> [scope] [period]"
allowed-tools: Read, Glob, Grep, Bash, Agent, ToolSearch, mcp__claude_ai_Gmail__gmail_get_profile, mcp__claude_ai_Gmail__gmail_search_messages, mcp__claude_ai_Google_Calendar__gcal_list_events, mcp__claude_ai_Linear__list_issues, mcp__claude_ai_Slack__slack_search_channels, mcp__claude_ai_Slack__slack_search_public_and_private
---

# Sitrep

Daily situation report. Gathers activity from connected sources to orient you.

## Commands

Parse the first word of `$ARGUMENTS` to identify the command, then read the
corresponding file for detailed instructions.

- `debrief` — what happened. Read [debrief.md](debrief.md).
- `brief` — what's ahead. Read [brief.md](brief.md).
- `muster` — compose a standup. Read [muster.md](muster.md).

## Source Detection

Before gathering data, detect which sources are available in this session.
Only query sources that are connected. Skip unavailable sources silently —
never error or suggest the user connect something.

- **Local Git** — always available via `git` CLI in the current repo
- **GitHub** — always available via `gh` CLI and `activity-github` subagent
- **Calendar** — available if `mcp__claude_ai_Google_Calendar__*` tools exist
- **Gmail** — available if `mcp__claude_ai_Gmail__*` tools exist
- **Linear** — available if `mcp__claude_ai_Linear__*` tools exist
- **Slack** — available if `mcp__claude_ai_Slack__*` tools exist

MCP tools may be deferred (lazy-loaded). Use `ToolSearch` to load tools
before first use — e.g., `ToolSearch("select:mcp__claude_ai_Linear__list_issues")`
or `ToolSearch("+Linear list")`. Batch-load all needed MCP tools at the start
of a command to avoid mid-run failures.

A debrief with only GitHub is still useful — it shows PRs and commits.
A brief without Calendar still shows PRs and issues. Degrade gracefully.

## Memory

Check conversation context and memory for cached details before resolving
at runtime. Memory avoids redundant lookups and provides context the skill
can't infer (repos, channels, team). Useful memory keys:

- **Identity** — name, Slack ID, email, timezone
- **Repos** — sibling repositories to scan for git activity
- **Channels** — Slack channels relevant to the user's work (PR reviews, team)
- **Linear** — team name, active project context

## Identity

Use identity details from memory when available.
For anything not in memory, infer at runtime:

- **Name** — `git config user.name`
- **Slack ID** — if Slack is available, resolve from profile
- **Email** — if Gmail is available, `gmail_get_profile`

## Scope

Commands that accept a `[scope]` use the arguments after the command word
and before any time period to determine what to gather:

- **No scope** — defaults to the current user (identity above)
- **Person** — a name like `frank` or `@jane`. Resolve via Slack user
  search to get their ID, then filter queries to that person.
- **Channel** — starts with `#` like `#team-ai`. Resolve via
  `slack_search_channels` to get the channel ID.

When scoped to another person, sources that require their private access
(Calendar, Gmail) are skipped silently.

## Time Periods

All commands accept time periods as the last argument(s):

- (none) — command-specific default
- `yesterday` — last workday
- `today` — today
- `this-week` — Monday of current week through today
- `last-week` — Monday through Friday of previous week
- `next-week` — Monday through Friday of next week
- `N days ago` or `N hours` — relative window
- `YYYY-MM-DD` — specific date
- Natural language — "since Monday", "last 2 hours"

### Workday Logic

- Tuesday through Friday: previous day is last workday
- Monday: debrief covers Friday through Sunday (full weekend window)
- Saturday/Sunday: debrief covers Friday through today, brief targets Monday
- After holidays: last workday before the break

## Output Conventions

- Concise, one-line items
- No emoji
- Omit empty sections entirely
- Deduplicate across sources — a Linear issue and its GitHub PR are one item,
  prefer the more specific description

## Help

If `$ARGUMENTS` is empty, `help`, or unrecognized, display:

```
/sitrep — daily situation report

Commands:
  debrief [scope] [period]   what happened (default: last workday)
  brief [scope] [period]     what's ahead (default: today)
  muster [period]            debrief + brief composed (default: last workday)

Scope:
  (none)                     your activity
  frank, @jane               someone's activity
  #team-ai                   a channel's activity

Periods:
  yesterday, today, this-week, last-week, next-week
  N days ago, N hours, YYYY-MM-DD, or natural language

Sources detected automatically from connected MCPs.
```

## Input: $ARGUMENTS
