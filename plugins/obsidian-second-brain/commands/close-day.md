# Close Day — End-of-Day Processing

Review today's daily note, extract what matters, file it properly, and set up tomorrow. This is a 5-minute ritual, not a lengthy report.

## Obsidian Access

Use Obsidian CLI commands directly via Bash. If a CLI command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Today's Context (auto-loaded)

### Vault rules

!`obsidian read path="AGENTS.md" 2>/dev/null || echo "(AGENTS.md not found — confirm vault path before any write)"`

### Today's daily note

!`obsidian daily:read 2>/dev/null || echo "(no daily note for today — run /daily-startup first)"`

### Active projects

!`obsidian files folder="1 - Projects/" format=json 2>/dev/null || echo "[]"`

## Step 1: Parse Today's Daily Note

The daily note is loaded above. Parse everything captured: free-form writing, meeting notes, ideas, commitments, tasks mentioned, people referenced.

## Step 2: Process Claude Session Log

Read today's Claude session log:

```bash
obsidian read path="2 - Areas/Daily Ops/$(date +%Y)/Claude Sessions/$(date +%Y-%m-%d).md"
```

Session blocks follow: `## HH:MM — <project>` with **Decisions**, **Lessons**, **Action items**, **Files touched**. Use the active-projects list (loaded above) to build keyword set for filtering.

### 2a. Match-then-summarize filter

Split session blocks into two buckets:

**Bucket A — On-project sessions** (project header matches an active project):
- Ingest in full. Merge their Decisions, Lessons, Action items into the Step 4 extraction.
- These feed Step 5 project updates directly.

**Bucket B — Off-project sessions** (everything else: dotfiles, neovim, plugin work, etc.):
- Present as a one-line summary each: `[HH:MM — project] <one-line takeaway from Lessons or Decisions>`
- Ask user: "Capture any of these as TIL / resource notes?" — proceed only on explicit pick.

### 2b. Cross-reference with daily note

Surface anything from on-project sessions that's **not** reflected in today's daily note:
- Decisions made in a session but not recorded
- Action items committed to in a session but not in the daily checklist
- Insights worth promoting

Present as: "From Claude sessions today, these aren't in your daily note yet — capture them?" (proposes additions, does not auto-write to the daily note).

## Step 3: Vault Connection Discovery

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

## Step 4: Extract & Categorize

Sources: today's daily note (Step 1) + on-project Claude sessions (Step 2, Bucket A).

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

## Step 5: Update Project Notes

Cross-reference today's daily note + on-project sessions with active projects and update their notes in-place, respecting the existing template structure.

### 5a. Reuse the active-projects list

(Loaded in the "Active projects" section at the top — no need to re-fetch.)

### 5b. Match projects mentioned today

From the extracted content (Step 4), identify which active projects were worked on — by name, topic, or task context. Include both explicit mentions and implied work (e.g., coding on a feature that belongs to a project).

### 5c. Read matched project notes

For each matched project, read its main note to understand current structure and content:
```bash
obsidian read path="1 - Projects/<project-name>/<main-note>.md"
```

### 5d. Update project sections in-place

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

### 5e. Discover related notes (QMD semantic search)

For each matched project, surface vault notes that are conceptually related but not yet linked from the project's `🔗 Links & References` section.

```bash
# Run per project — use the project name + 1-2 distinguishing keywords
qmd query "<project name> <topic keyword>" --json -n 5
```

Then check which links already exist in the project note:

```bash
obsidian links file="1 - Projects/<project-name>/<main-note>.md"
```

**Filter rules:**
- Drop hits whose path starts with `2 - Areas/Daily Ops/` (those are session/daily noise, not durable references).
- Drop hits already present in the project's outgoing links.
- Drop hits with `source: claude-memory` frontmatter unless the user explicitly opts in (per `AGENTS.md`, those are agent-written and need human curation before being elevated to project links).
- Keep at most 3 candidates per project — quality over quantity.

**Propose, don't write.** Surface as:

```
[[Project A]] — related notes worth linking:
  - [[note-1]] (folder: 3 - Resources/...) — <why this matches: shared topic / shared tag>
  - [[note-2]] (folder: 3 - Resources/...) — <why>
Approve any to append to 🔗 Links & References?
```

Only after explicit approval, append the chosen ones:

```bash
obsidian patch path="1 - Projects/<project-name>/<main-note>.md" heading="🔗 Links & References" operation=append content="\n- [[<note-name>]]"
```

### 5f. Report what was updated

Present a summary:
```
Updated project notes:
- [[Project A]] — status + in-progress updated, 2 related notes linked
- [[Project B]] — new decision logged
Skipped (mentioned but no actionable progress): Project C
```

## Step 6: Suggest Filing Locations

For each extracted item, recommend where it should live in PARA:

| Item | Type | Suggested Location | Action |
|------|------|-------------------|--------|
| ... | Insight | `3 - Resources/` | Create or append to note |
| ... | Task | Daily note tasks section | Add checkbox |
| ... | Idea | `0 - Inbox/` or existing note | Add to running log |

## Step 7: Suggest Backlinks

```bash
# Check existing outgoing links before suggesting new ones
obsidian links file="<today's note>"
```

Identify terms in today's note that should link to existing notes (skip links that already exist):
- People mentioned -> link to their note if exists
- Projects mentioned -> link to project notes in `1 - Projects/`
- Concepts mentioned -> link to relevant notes in `3 - Resources/`

Present as: "Consider adding these backlinks: [[Person]], [[Project]], [[Concept]]"

## Step 8: Carry Forward

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
[Categorized list of items pulled from the daily note + on-project sessions]

### Claude Sessions — Off-Project Highlights
[One-liners from off-project sessions; user picks any to capture]

### Session ↔ Daily Note Gaps
[Decisions / action items from sessions not yet in daily note — propose adding]

### Vault Connections
[Recurring themes, connections to older notes]

### Project Notes Updated
[List of projects updated with progress entries + related notes linked]

### Related Notes (proposed, not written)
[Per-project candidates from QMD semantic search — awaiting approval]

### Filing Suggestions
[Table of where things should go]

### Backlinks to Add
[List of suggested links]

### Carry Forward
[What matters for tomorrow]

### Quick Wrap (if not completed)
[Draft answers to reflection questions]

Keep output concise. Focus on filing and surfacing what matters, not summarizing the day.
