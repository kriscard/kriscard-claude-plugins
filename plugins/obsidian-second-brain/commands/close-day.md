# Close Day — End-of-Day Processing

Review today's daily note, extract what matters, file it properly, and set up tomorrow. This is a 5-minute ritual, not a lengthy report.

## Obsidian Access

Use Obsidian CLI commands directly via Bash. If a CLI command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Step 1: Read Today's Daily Note

```bash
obsidian daily:read
```

Parse everything captured: free-form writing, meeting notes, ideas, commitments, tasks mentioned, people referenced.

## Step 2: Vault Connection Discovery

After reading today's note, run these queries:

```bash
# What themes are most active right now?
obsidian search:context query="<theme 1 from today>" limit=10
obsidian search:context query="<theme 2 from today>" limit=10
obsidian search:context query="<theme 3 from today>" limit=10

# Trace connections to today's note
obsidian backlinks file="<today's note>"
```

Surface findings as: "Today you wrote about X. This connects to [[note]] from [date] where you were thinking about Y. Worth revisiting?"

Flag recurring themes: "This is the third time [topic] has come up in the past two weeks."

## Step 3: Extract & Categorize

### Action Items
- Things promised to others
- Things to follow up on
- Deadlines mentioned

### Ideas & Insights
- Observations about work patterns
- Ideas for projects, content, or experiments
- Realizations or shifts in perspective

### People & Commitments
- Follow-ups owed
- Meetings to schedule
- Messages to send

### Questions Raised
- Things to investigate
- Decisions pending
- Uncertainties to resolve

### Open Tasks Check
```bash
obsidian tasks todo daily
```
Cross-reference extracted action items against existing tasks — flag any that are missing or incomplete.

## Step 4: Update Project Notes

Cross-reference today's daily note with active projects and update their notes in-place, respecting the existing template structure.

### 4a. List active projects

```bash
obsidian files folder="1 - Projects/" format=json
```

### 4b. Match projects mentioned today

From the extracted content (Step 3), identify which active projects were worked on — by name, topic, or task context. Include both explicit mentions and implied work (e.g., coding on a feature that belongs to a project).

### 4c. Read matched project notes

For each matched project, read its main note to understand current structure and content:
```bash
obsidian read path="1 - Projects/<project-name>/<main-note>.md"
```

### 4d. Update project sections in-place

For each matched project, update the relevant template sections. **Never append raw entries at the bottom — always patch existing sections.**

**Update `📍 Current Status`** — Replace the status summary and date:
```bash
obsidian patch path="1 - Projects/<project-name>/<main-note>.md" heading="📍 Current Status" operation=replace content="_Updated: <today's date>_\n\n<updated status summary incorporating today's progress>\n\n### What's in progress\n<merged list: keep existing items still relevant + add new from today>\n\n### Open questions / Blockers\n<keep unresolved items + add new ones from today, remove resolved ones>"
```

**Update `🧠 Key Decisions`** (only if a decision was made today):
```bash
obsidian patch path="1 - Projects/<project-name>/<main-note>.md" heading="🧠 Key Decisions" operation=append content="| <today's date> | <decision> | <why> |"
```

**Update `📝 Notes & Context`** (only if new insights emerged):
```bash
obsidian patch path="1 - Projects/<project-name>/<main-note>.md" heading="📝 Notes & Context" operation=append content="\n<new insight or context>"
```

**Guidelines:**
- Only update if there's meaningful progress — skip trivial mentions
- Preserve existing content in each section; merge, don't overwrite blindly
- For `Current Status`: update the date, rewrite the status summary to reflect current state, and merge in-progress items (keep what's still active, add new, remove completed)
- For `Key Decisions`: only add rows, never remove existing ones
- Use the user's own language from the daily note
- If a project note doesn't follow the standard template, adapt — find the closest matching sections and update those

### 4e. Report what was updated

Present a summary:
```
Updated project notes:
- [[Project A]] — status + in-progress updated
- [[Project B]] — new decision logged
Skipped (mentioned but no actionable progress): Project C
```

## Step 5: Suggest Filing Locations

For each extracted item, recommend where it should live in PARA:

| Item | Type | Suggested Location | Action |
|------|------|-------------------|--------|
| ... | Insight | `3 - Resources/` | Create or append to note |
| ... | Task | Daily note tasks section | Add checkbox |
| ... | Idea | `0 - Inbox/` or existing note | Add to running log |

## Step 6: Suggest Backlinks

```bash
# Check existing outgoing links before suggesting new ones
obsidian links file="<today's note>"
```

Identify terms in today's note that should link to existing notes (skip links that already exist):
- People mentioned -> link to their note if exists
- Projects mentioned -> link to project notes in `1 - Projects/`
- Concepts mentioned -> link to relevant notes in `3 - Resources/`

Present as: "Consider adding these backlinks: [[Person]], [[Project]], [[Concept]]"

## Step 7: Carry Forward

### What to carry into tomorrow
Based on today's note:
- Unfinished priorities
- Commitments due soon
- Momentum to maintain

Write carry-forward items to today's note:
```bash
obsidian daily:append content="## Carry Forward\n- [item 1]\n- [item 2]"
```

### Quick Wrap Answers
If the Quick Wrap section wasn't filled in today's daily note, draft answers:
- Did I explore anything new today?
- What did I actually move forward?
- What bottleneck became obvious?
- One thing to carry into tomorrow?

## Output Format

### Today's Extraction
[Categorized list of items pulled from the note]

### Vault Connections
[Recurring themes, connections to older notes]

### Project Notes Updated
[List of projects updated with progress entries]

### Filing Suggestions
[Table of where things should go]

### Backlinks to Add
[List of suggested links]

### Carry Forward
[What matters for tomorrow]

### Quick Wrap (if not completed)
[Draft answers to reflection questions]

Keep output concise. Focus on filing and surfacing what matters, not summarizing the day.
