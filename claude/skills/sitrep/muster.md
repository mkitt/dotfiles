# muster

Compose a standup from debrief + brief. Self only — no scope argument.

Default: debrief(last workday) + brief(today).

## Time Parsing

- (none) → debrief: last workday, brief: today (or next workday if today is a weekend)
- `weekly` → debrief: this-week, brief: next-week
- Other period → debrief: that period, brief: today

### Weekend / Monday Handling

On **Monday**, debrief covers **Friday through Sunday** (the full weekend
window). Work happens on weekends even without standups — capture it all.

On **Saturday or Sunday**, shift both periods:
- **Debrief** covers Friday through today
- **Brief** targets Monday (next workday)

This matches Sunday-evening standup prep and Monday-morning catch-up.

## Steps

1. Parse time argument and resolve debrief and brief periods

2. Run [debrief.md](debrief.md) with the debrief period (self scope)

3. Run [brief.md](brief.md) with the brief period (self scope)

4. Compose into three sections:
   - **Debrief** — from debrief: completed work, activity, self-DMs
   - **Brief** — from brief: schedule, in progress, needs attention, reminders
   - **Notes** — anything that doesn't fit above: items to discuss,
     blockers waiting on others, open questions

5. Deduplicate across sources — a Linear issue and its PR are one item

6. Present the draft — never post automatically

## Output

```
<Name>'s <Month Day, Year> muster.

*Debrief:*
- Item 1
- Item 2

*Brief:*
- Item 1
- Item 2

*Notes:*
- Topic (if any)
```

Keep items concise — aim for 3 to 5 per section.
Omit Notes if nothing warrants it.
