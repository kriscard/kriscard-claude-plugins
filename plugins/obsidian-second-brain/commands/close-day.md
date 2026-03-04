# Close Day — End-of-Day Processing

Review today's daily note, extract what matters, file it properly, and set up tomorrow. This is a 5-minute ritual, not a lengthy report.

## Obsidian Access

Use Obsidian CLI commands directly via Bash. If a CLI command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Step 1: Read Today's Daily Note

```bash
YEAR=$(date +%Y)
TODAY=$(date +%Y-%m-%d)
obsidian read path="2 - Areas/Daily Ops/$YEAR/$TODAY.md"
```

Parse everything captured: free-form writing, meeting notes, ideas, commitments, tasks mentioned, people referenced.

## Step 2: Vault Connection Discovery

After reading today's note, run these queries:

```bash
# What themes are most active right now?
obsidian search query="<theme 1 from today>" format=json
obsidian search query="<theme 2 from today>" format=json
obsidian search query="<theme 3 from today>" format=json
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

## Step 4: Suggest Filing Locations

For each extracted item, recommend where it should live in PARA:

| Item | Type | Suggested Location | Action |
|------|------|-------------------|--------|
| ... | Insight | `3 - Resources/` | Create or append to note |
| ... | Task | Daily note tasks section | Add checkbox |
| ... | Idea | `0 - Inbox/` or existing note | Add to running log |

## Step 5: Suggest Backlinks

Identify terms in today's note that should link to existing notes:
- People mentioned -> link to their note if exists
- Projects mentioned -> link to project notes in `1 - Projects/`
- Concepts mentioned -> link to relevant notes in `3 - Resources/`

Present as: "Consider adding these backlinks: [[Person]], [[Project]], [[Concept]]"

## Step 6: Carry Forward

### What to carry into tomorrow
Based on today's note:
- Unfinished priorities
- Commitments due soon
- Momentum to maintain

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

### Filing Suggestions
[Table of where things should go]

### Backlinks to Add
[List of suggested links]

### Carry Forward
[What matters for tomorrow]

### Quick Wrap (if not completed)
[Draft answers to reflection questions]

Keep output concise. Focus on filing and surfacing what matters, not summarizing the day.
