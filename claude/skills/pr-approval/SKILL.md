---
name: pr-approval
description: >-
  Help a human reviewer clear a pull-request queue. Two modes: TRIAGE sweeps the
  whole open queue cheaply (one GraphQL query, no deep read) and renders a
  worklist of the single next action + owner per PR, ordered to drain fastest;
  REVIEW fans out a per-PR analyst (Opus, read-only) for the approve /
  request-changes decision on specific PRs. Use when asked to "go through",
  "triage", "clear the queue", "review", or "should I approve" one or more PRs.
argument-hint: "[pr-numbers|urls|all] [--triage|--review] [--mode recommend|confirm] [--noob] [--repo owner/repo]"
---

**Arguments:** $ARGUMENTS

# PR approval

Get a reviewer through a queue quickly, with the depth to trust each call and
clear pointers when they need to look closer. **You never merge, and every
action that publishes to GitHub needs the reviewer's explicit yes.**

## Pick the mode

- **Triage** — a map of the whole queue: one cheap sweep, one next action +
  owner per PR, ordered to drain fastest. No deep read, no subagents.
  Use it when **no PR is named**, the args say `all` / `--triage`, or there are
  **more than ~5 PRs**. This is the "what's the state of everything?" mode.
- **Review** — the deep, per-PR approve / request-changes decision, via the
  Opus [`pr-approval-analyst`](../../agents/pr-approval-analyst.md) subagent.
  Use it when **specific PRs are named** (`/pr-approval 549`), for `--review`,
  or when drilling into one triage flagged as needing judgment.

Triage answers "what do I do next, across all of them?"; review answers "should
I approve _this_ one?". They compose: triage the board, then drill into the ones
that need judgment. Default to triage when the ask is broad, review when narrow.

---

# Triage mode

## T1 — Resolve the set

Default to **all open PRs** (`gh pr list --state open`) unless specific numbers
are given. Determine the repo (`--repo`, URL, or current checkout).

## T2 — One sweep (no fan-out)

A **single** GraphQL query for every PR — no subagents, no diff read:
`number, title, bodyText, author{login}, isDraft, reviewDecision,
mergeStateStatus, autoMergeRequest{enabledAt},
commits(last:1){…statusCheckRollup{state}},
reviewThreads(first:100){nodes{isResolved}}`. Everything below derives from this
one payload (plus the issue key parsed from title/body/branch).

## T3 — Reconcile across PRs (before classifying)

One cheap cross-PR pass — the thing an isolated per-PR analyst structurally
can't do. Only assert a relationship on an **explicit** signal (body text, or a
clear same-issue + overlapping-files match); never guess:

- **Group by issue** — bucket PRs sharing an `AGENT-###` (or issue) ref. Siblings
  on one issue are common (a doc PR + its implementation, or a stack); surface
  the grouping so the reviewer sees the shape.
- **Supersedes / duplicate** — scan bodies for "supersedes / replaces / re-derived
  from #N". If this PR supersedes an open #N (or #N is closed and this re-derives
  it), mark **#N** a `close` candidate ("superseded by #this"). Two open PRs on
  one issue with overlapping files → flag the likely duplicate.
- **Stack / land-order** — "stacked on / depends on #N" means #N lands first;
  do not put the dependent in `merge` ahead of its base. Note the order.

Feed the results into T4 (a superseded PR → `close`; a stacked PR's `merge`
waits on its base).

## T4 — Classify each PR into ONE next action (first match wins)

Ordered most-blocking-in, but rendered quick-wins-first (T5):

- **close** — superseded or duplicate **per T3**. Owner: author.
- **finish** — draft. Owner: author.
- **fix CI** — CI rollup is `FAILURE`. Owner: author.
- **address** — `reviewDecision == CHANGES_REQUESTED`. Owner: author.
- **resolve comments** — unresolved threads > 0. Owner: author. Add a **rebase**
  tag too if also `DIRTY`.
- **rebase** — `DIRTY`/`BEHIND`, no open threads. Owner: author. _Caveat:
  `DIRTY`/`UNKNOWN` on a just-pushed PR is often GitHub's mergeability recompute
  lagging, not a real conflict — say "may be stale," don't confidently call it._
- **merge** — `APPROVED` + clean + 0 open threads, and (per T3) any base it's
  stacked on has landed. Owner: the merge-key holder (human). Note the two-key
  requirement.
- **approve** — needs a qualifying approval; clean, CI green, no open threads.
  Owner: a reviewer **other than the author**. Bot-authored → a human review
  (genuine maker≠checker). Self-authored (you) → "another reviewer" (GitHub
  won't let you approve your own). If **auto-merge is on**, note "approve → it
  lands itself once green + both keys."

## T5 — Render the worklist

Group by action tier, **quickest wins first** (`close` → `merge` →
`approve`/auto-merge → `rebase` → `resolve`/`address` → `fix CI` → `finish`),
each PR one line: `#n · title · owner · action`. Keep sibling/stack groups
visually together. Lead with a roll-up (`N open · X merge · Y approve · Z
resolve …`) and close with a one-line **fastest-drain** path. Note CI color and
what each PR is `blocked-on` in plain English — never pass the raw
`BLOCKED`/`DIRTY` enum through.

## T6 — Offer the worklist artifact

When the set is **large (≥6)** or on request, offer an HTML artifact: an
effort-tiered table (tier dividers with counts; columns PR / what it is / owner /
action; a "fastest drain" footer), theme-aware, semantic action pills. Private
by default — **remind them to share** it with the right audience. Small sets stay
in the terminal.

## T7 — Drill down

Triage never publishes — it's a map. For any PR that needs judgment, offer to
**drop into review mode** (`review <n>`). To actually approve/merge/close, route
through the gated action path below (explicit yes each). Same safety model.

---

# Review mode

## Mode dial (review only)

- `recommend` (**default**) — analyze and recommend only. Never publishes. The
  tuning mode: watch it agree with your own calls first.
- `confirm` — additionally lets you clear trivially-approvable PRs with a single
  batch confirmation. Still one explicit yes; never silent.

Read from `--mode`; default `recommend`.

## `--noob` — onboarding context (review only)

Off by default. Set it when the reviewer is **new to this repo or this body of
work** (they will not be the last). When on, each analyst card leads with an
**ELI5 & how we got here** block written for a first-time reader:

- **ELI5 the intent** — ≤ 3 plain sentences: what this PR is actually trying to
  do and why anyone should care. Expand only the acronyms/terms that actually
  appear in this PR's diff or card; assume no prior context.
- **How we got here** — the groundwork that made this necessary, as **≤ 4
  one-line steps**: the predecessor issues / PRs / ADRs in the lineage and the
  one thing each contributed, so the reader sees the arc, not just this diff.

**Keep it tight.** The block leads a decision card, not a wiki page — cap it at
roughly 150 words total. Rich context, disciplined length: if a term doesn't
appear in the card, don't stop to define it.

Ignored in triage (a cheap sweep with no deep read) — if a triaged PR needs this,
drop into review on it. `--eli5` is an accepted alias.

## R1 — Resolve the PR list

Parse `$ARGUMENTS` into PR numbers (bare, `#537`, or full URLs → derive
`--repo`). Determine the repo. Note `--noob`/`--eli5` if present (adds the
onboarding block per PR — see the `--noob` section).

## R2 — Enrich with the plan (best-effort)

Detect Linear tools (`mcp__*Linear*` / `mcp__*linear*` — load via `ToolSearch`
if deferred). For each PR whose body references an issue (e.g. `AGENT-###`),
fetch the issue title + description as a **plan summary** for that PR's analyst.
If Linear is unavailable or there's no reference, skip silently. Never block.

Also do a quick **sibling check** (the T3 reconcile, scoped to the named set +
open queue): if a reviewed PR shares an issue with, supersedes, or is stacked on
another PR, note it in the digest ("#537 is the ADR doc for the #541
implementation") — the isolated analyst can't see its siblings, so surface it here.

**When `--noob` is set**, don't stop at the PR's own issue — walk the lineage:
follow the issue's "Follows / Context" chain (predecessor `AGENT-###` issues,
ADRs) and any predecessor PRs, capturing one line each on what they laid down.
This traced lineage is the raw material for the analyst's "how we got here" — the
cross-PR history the isolated analyst can't reconstruct on its own.

## R3 — Fan out (parallel)

Spawn **one `pr-approval-analyst` per PR in a single message** (multiple `Agent`
calls together) so they run concurrently, each isolated. Pass: PR number,
`--repo`, the plan summary if any, and the mode — and, when `--noob`, the traced
lineage plus an instruction to produce the **ELI5 & how we got here** block.
Wait for all cards.

## R4 — Combine into the digest

Render cards most-blocking first (`request-changes` / `blocked-on-ci` /
`needs-rebase` → `dive-deeper` → `approve-with-nits` → `approve`). Lead with a
roll-up: `N PRs · X approvable · Y need changes · Z need your eyes`. Keep each
card compact — a decision surface, not a wall of text. When `--noob`, each card
**opens** with the ELI5 & how-we-got-here block — context before verdict.

## R5 — Recommend, then act only on explicit go

**recommend mode:** State the recommended verdict + next action per PR. Stop. Do
not publish. Offer to switch to `confirm` for the trivial ones.

**confirm mode:**

- **Trivial bucket** — collect PRs meeting _every_ trivial criterion (below),
  present one line each, ask a single batch question: _"Approve these N? [y]"_.
  On an explicit yes, run `gh pr review <n> --approve` for each (**no comment
  body** — a bare approve is clean). Report each result.
- **Everything else** — never batched. For `request-changes`, draft the feedback
  (from the analyst's blockers), show it, post only on explicit yes as
  `gh pr review <n> --request-changes --body "…"` (or `--comment` for a softer
  note). One yes per PR.

**After any approval — read back the merge gate.** A submitted approval does not
mean the PR can merge. Immediately re-read (`gh pr view <n> --json
reviewDecision,mergeStateStatus`) and say in plain English what still stands
between it and merge — "approved; still needs a CODEOWNER", "approved; only the
`@archer merge` key remains". Never leave a bare "approved" that implies it's
ready; if `reviewDecision` didn't flip to `APPROVED`, say why.

**Never, in any mode:** approve silently, approve a PR you authored (GitHub
rejects it — surface analysis only), approve a bot-authored PR, or touch merge.
Approval is the **GitHub review key only** — the merge key stays with the human
(in able-archer, the separate `@archer merge` step; don't go near it).

### Trivial criteria (all must hold)

Docs / locale / tests / comments / config **only** — no source-logic change ·
no sensitive-path flag · small (roughly ≤ a few hundred substantive lines) ·
CI green · no open blockers · no unresolved review threads · plan fidelity
aligned · human-authored (not you, not a bot). Any doubt → not trivial. This
whitelist is the binding safety constraint; keep it conservative.

## R6 — Offer an artifact (where it makes sense)

If there are **≥2 PRs** or any `dive-deeper` verdict, offer the digest as an HTML
artifact. On yes: publish via `Artifact`, then **remind them it's private** —
ask who should see it. A single clean PR stays in the terminal.

---

## Guardrails recap

- Gathering is read-only; the analyst never switches branches (concurrent-agent
  safety) and never edits.
- Triage never publishes. In review, publishing actions (`approve`,
  `request-changes`, comments) require an explicit yes each — one batch yes only
  for the trivial bucket.
- You produce the review key, never the merge; you never approve your own or a
  bot's PR.
