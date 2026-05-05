# Daily Startup Workflow

Run an interactive daily startup session to begin the day with clarity and focus.

## Purpose

Guide the user through their daily startup routine efficiently. Auto-create all relevant periodic notes, then interactively surface relevant information and set priorities.

## Obsidian Access

Use Obsidian CLI commands directly via Bash. If a CLI command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Today's Context (auto-loaded)

### Vault rules

!`obsidian read path="AGENTS.md" 2>/dev/null || echo "(AGENTS.md not found)"`

### Today's daily note (may not exist yet)

!`obsidian daily:read 2>/dev/null || echo "(today's daily note doesn't exist yet — Step 1 will create it)"`

### Yesterday's daily note (for carry-forward)

!`obsidian read path="2 - Areas/Daily Ops/$(date +%Y)/$(date -v-1d +%Y-%m-%d).md" 2>/dev/null || echo "(yesterday's note not found)"`

### Inbox

!`obsidian files folder="0 - Inbox/" format=json 2>/dev/null || echo "[]"`

### Active projects

!`obsidian files folder="1 - Projects/" format=json 2>/dev/null || echo "[]"`

### Today's date variables

!`echo "TODAY=$(date +%Y-%m-%d) DOW=$(date +%u) DOM=$(date +%d) MONTH=$(date +%m) YEAR=$(date +%Y) WEEK=$(date +%G-W%V) QUARTER=$((($(date +%-m) - 1) / 3 + 1))"`

## Workflow

### Step 1: Batch Check & Create Periodic Notes (FAST)

**IMPORTANT: Execute this step efficiently with minimal round-trips.**

**1a. Detect which periods apply today:**

Date variables are pre-loaded above (`TODAY`, `DOW`, `DOM`, `MONTH`, `YEAR`, `WEEK`, `QUARTER`). For today's daily note path:

```bash
obsidian daily:path
```

Periods to check:
- **Quarterly**: If MONTH is 01, 04, 07, or 10 AND DOM is 01
- **Monthly**: If DOM is 01
- **Weekly**: If DOW is 1 (Monday)
- **Daily**: Always

**1b. Batch check existence (PARALLEL):**

```bash
obsidian files folder="2 - Areas/Daily Ops/$YEAR/" format=json
obsidian files folder="2 - Areas/Daily Ops/Weekly/M - Month YYYY/" format=json  # if Monday
obsidian files folder="2 - Areas/Goals/Monthly/" format=json  # if 1st
obsidian files folder="2 - Areas/Goals/Quarterly/" format=json  # if quarter start
```

**1c. Batch fetch templates (PARALLEL, only for missing notes):**

```bash
# Use template:read with resolve for variable substitution
obsidian template:read name="Daily Notes" resolve title="$TODAY"
obsidian template:read name="Weekly Planning" resolve title="$WEEK"  # if needed
obsidian template:read name="Monthly Goals" resolve  # if needed
obsidian template:read name="Quarterly Goals" resolve  # if needed
```

**1d. Auto-create missing notes (no confirmation needed):**

For each missing note, create using the template content:
- Replace template variables: `{{date}}`, `{{title}}`, `{{week}}`, `{{month}}`, `{{quarter}}`, `{{year}}`

```bash
obsidian create path="2 - Areas/Daily Ops/$YEAR/$TODAY.md" content="$PROCESSED_TEMPLATE" silent
```

**CRITICAL**: Always use the full template content - never create empty or partial notes.

**1e. Report what was created:**

Single summary: "Created: daily (2026-01-27), weekly (2026-W05)" or "All periodic notes already exist."

**Note Paths & Formats:**

| Type | Path | Format | Template |
|------|------|--------|----------|
| Quarterly | `2 - Areas/Goals/Quarterly/Quaterly Goals - QN YYYY.md` | `Quaterly Goals - Q1 2026` | `Templates/Quarterly Goals.md` |
| Monthly | `2 - Areas/Goals/Monthly/M - Month YYYY.md` | `1 - January 2026` | `Templates/Monthly Goals.md` |
| Weekly | `2 - Areas/Daily Ops/Weekly/M - Month YYYY/YYYY-Www.md` | `2 - February 2026/2026-W06` | `Templates/Weekly Planning.md` |
| Daily | `2 - Areas/Daily Ops/YYYY/YYYY-MM-DD.md` | `2026/2026-02-02` | `Templates/Daily Notes.md` |

**Note:** The quarterly folder has a typo ("Quaterly" instead of "Quarterly") - preserve this to match existing vault structure.

### Step 2: Check Yesterday's Carry-Forward

**CRITICAL: Always check yesterday's carry-forward before setting today's priorities.**

Yesterday's daily note is pre-loaded above. Parse the "Carry Forward → Tomorrow" section. If items exist, prepend them to today's note:

```bash
obsidian daily:prepend content="**Carry forward from yesterday:**\n- [ ] Item 1\n- [ ] Item 2"
```

### Step 3: Gather Context

Inbox and active projects are pre-loaded above. Fetch the remaining dynamic context:

```bash
obsidian base:query path="MOCs/Active Projects.base" format=json

# Today's open tasks (from daily note and projects)
obsidian tasks todo daily

# Open tasks across active projects
obsidian tasks todo path="1 - Projects/" total

# Current weekly plan context
obsidian read path="2 - Areas/Daily Ops/$YEAR/$WEEK.md"
```

**Report combined:**
- "Inbox: X notes" (if X > 0, mention `/process-inbox`)
- "Active projects: [list top 5]"
- "Open tasks today: N"
- "Carry-forward items: [list if any]"

### Step 4: Interactive Focus Setting

Now engage the user (this is the interactive part):

**Use AskUserQuestion** with multiSelect for project focus:
```
Question: "Which projects are you focusing on today?"
Options: [top 3-4 active projects from Step 3]
multiSelect: true
```

### Step 5: Set Priorities

**Use AskUserQuestion:**
```
Question: "Top priority for today?"
Options:
- "[Carry-forward item 1]" (if any)
- "[Project 1 related task]"
- "[Project 2 related task]"
- "Something else (I'll type it)"
```

Or simply ask: "What are your top 3 priorities?" and let them type.

### Step 6: Update Daily Note & Summarize

1. Update today's daily note sections in-place (never append new sections at the bottom):

```bash
# Use daily:append only for adding to existing sections
obsidian daily:append content="..." silent
```

2. Provide final summary:

```
Notes: daily, weekly (if created)
Inbox: X notes
Carry-forward: [items from yesterday]
Focus: [selected projects]
Priorities: [listed]
```

## Configuration

Vault path: `/Users/kriscard/obsidian-vault-kriscard`

## Performance Guidelines

1. **Batch operations**: Check all note existence in parallel, not sequentially
2. **Fetch templates in parallel**: If 3 notes missing, fetch 3 templates at once
3. **Auto-create notes**: Don't ask permission for each periodic note - just create missing ones
4. **Single interactive phase**: All user questions come AFTER notes are created
5. **Minimize round-trips**: Prefer fewer CLI calls with more data over many small calls
6. **Use native daily commands**: `daily:read`, `daily:append`, `daily:prepend`, `daily:path` instead of manual path construction

## Template Handling (CRITICAL)

**ALWAYS use templates when creating notes:**

1. Fetch template content: `obsidian template:read name="Daily Notes" resolve title="$TODAY"`
2. If resolve doesn't substitute all variables, replace manually:
   - `{{date}}` -> `2026-01-27`
   - `{{title}}` -> Note title
   - `{{week}}` -> `W05`
   - `{{month}}` -> `January`
   - `{{quarter}}` -> `Q1`
   - `{{year}}` -> `2026`
3. Create note with full processed template content
4. **NEVER create empty notes** - if template fetch fails, report error
