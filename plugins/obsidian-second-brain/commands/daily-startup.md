---
name: daily-startup
description: Interactive daily workflow session - create periodic notes (daily/weekly/monthly/quarterly), check inbox, surface tasks, review OKRs
allowed-tools: [Read, Write, Bash, obsidian]
---

# Daily Startup Workflow

Run an interactive daily startup session to begin the day with clarity and focus.

## Purpose

Guide the user through their daily startup routine efficiently. Auto-create all relevant periodic notes, then interactively surface relevant information and set priorities.

## Workflow

### Step 1: Batch Check & Create Periodic Notes (FAST)

**IMPORTANT: Execute this step efficiently with minimal round-trips.**

**1a. Detect which periods apply today (single date calculation):**

```bash
# Calculate all dates at once
TODAY=$(date +%Y-%m-%d)
DOW=$(date +%u)           # 1=Monday
DOM=$(date +%d)           # Day of month
MONTH=$(date +%m)
YEAR=$(date +%Y)
WEEK=$(date +%G-W%V)      # ISO week
QUARTER=$((($MONTH - 1) / 3 + 1))
```

Periods to check:
- **Quarterly**: If MONTH is 01, 04, 07, or 10 AND DOM is 01
- **Monthly**: If DOM is 01
- **Weekly**: If DOW is 1 (Monday)
- **Daily**: Always

**1b. Batch check existence (PARALLEL):**

Make ONE call to list each relevant directory, then check results locally:
- `obsidian_list_files_in_dir` for `2 - Areas/Daily Ops/`
- `obsidian_list_files_in_dir` for `2 - Areas/Daily Ops/Weekly/M - Month YYYY/` (if Monday, e.g., `2 - February 2026`)
- `obsidian_list_files_in_dir` for `2 - Areas/Goals/Monthly/` (if 1st)
- `obsidian_list_files_in_dir` for `2 - Areas/Goals/Quarterly/` (if quarter start)

**1c. Batch fetch templates (PARALLEL, only for missing notes):**

If notes are missing, fetch all needed templates in parallel:
- `obsidian_get_file_contents` for `Templates/Daily Notes.md`
- `obsidian_get_file_contents` for `Templates/Weekly Planning.md` (if needed)
- `obsidian_get_file_contents` for `Templates/Monthly Goals.md` (if needed)
- `obsidian_get_file_contents` for `Templates/Quarterly Goals.md` (if needed)

**1d. Auto-create missing notes (no confirmation needed):**

For each missing note, create using the template content:
- Replace template variables: `{{date}}`, `{{title}}`, `{{week}}`, `{{month}}`, `{{quarter}}`, `{{year}}`
- Use `obsidian_append_content` to create each note
- **CRITICAL**: Always use the full template content - never create empty or partial notes

**1e. Report what was created:**

Single summary: "Created: daily (2026-01-27), weekly (2026-W05)" or "All periodic notes already exist."

**Note Paths & Formats:**

| Type | Path | Format | Template |
|------|------|--------|----------|
| Quarterly | `2 - Areas/Goals/Quarterly/Quaterly Goals - QN YYYY.md` | `Quaterly Goals - Q1 2026` | `Templates/Quarterly Goals.md` |
| Monthly | `2 - Areas/Goals/Monthly/M - Month YYYY.md` | `1 - January 2026` | `Templates/Monthly Goals.md` |
| Weekly | `2 - Areas/Daily Ops/Weekly/M - Month YYYY/YYYY-Www.md` | `2 - February 2026/2026-W06` | `Templates/Weekly Planning.md` |
| Daily | `2 - Areas/Daily Ops/YYYY-MM-DD.md` | `2026-02-02` | `Templates/Daily Notes.md` |

**Note:** The quarterly folder has a typo ("Quaterly" instead of "Quarterly") - preserve this to match existing vault structure.

### Step 2: Gather Context (PARALLEL)

**Fetch inbox count and projects in parallel:**

- `obsidian_list_files_in_dir` for `0 - Inbox/`
- `obsidian_list_files_in_dir` for `1 - Projects/`

**Report combined:**
- "Inbox: X notes" (if X > 0, mention `/process-inbox`)
- "Active projects: [list top 5]"

### Step 3: Interactive Focus Setting

Now engage the user (this is the interactive part):

**Use AskUserQuestion** with multiSelect for project focus:
```
Question: "Which projects are you focusing on today?"
Options: [top 3-4 active projects from Step 2]
multiSelect: true
```

### Step 4: Set Priorities

**Use AskUserQuestion:**
```
Question: "Top priority for today?"
Options:
- "[Project 1 related task]"
- "[Project 2 related task]"
- "Something else (I'll type it)"
```

Or simply ask: "What are your top 3 priorities?" and let them type.

### Step 5: Update Daily Note & Summarize

1. Add focus projects and priorities to daily note
2. Provide final summary:

```
✓ Notes: daily, weekly (if created)
✓ Inbox: X notes
✓ Focus: [selected projects]
✓ Priorities: [listed]
```

## Configuration

Vault path: `/Users/kriscard/obsidian-vault-kriscard`

## Tools Usage

**Obsidian MCP tools (use in parallel where possible):**
- `obsidian_list_files_in_dir` - Batch check existence of notes, list inbox/projects
- `obsidian_get_file_contents` - Fetch templates (parallel for all needed)
- `obsidian_append_content` - Create notes from templates

**AskUserQuestion tool:**
- Project focus selection (multiSelect)
- Priority setting

## Performance Guidelines

1. **Batch operations**: Check all note existence in parallel, not sequentially
2. **Fetch templates in parallel**: If 3 notes missing, fetch 3 templates at once
3. **Auto-create notes**: Don't ask permission for each periodic note - just create missing ones
4. **Single interactive phase**: All user questions come AFTER notes are created
5. **Minimize round-trips**: Prefer fewer MCP calls with more data over many small calls

## Template Handling (CRITICAL)

**ALWAYS use templates when creating notes:**

1. Fetch template content from `Templates/[Type] Notes.md`
2. Replace variables in template:
   - `{{date}}` → `2026-01-27`
   - `{{title}}` → Note title
   - `{{week}}` → `W05`
   - `{{month}}` → `January`
   - `{{quarter}}` → `Q1`
   - `{{year}}` → `2026`
3. Create note with full processed template content
4. **NEVER create empty notes** - if template fetch fails, report error

## Error Handling

- **Missing template**: Report error, don't create empty note
- **MCP unavailable**: Fall back to Bash + Read tools
- **No projects**: Skip project selection step

## Example Interactions

### Example 1: Monday (Fast Auto-Create)
```
Assistant: Good morning!

✓ Created: weekly (2026-W02), daily (2026-01-12)
Inbox: 3 notes (run /process-inbox when ready)
Active projects: Website Redesign, API Documentation, Team Onboarding

[AskUserQuestion: Which projects for today? - multiSelect]
User: Website Redesign, API Documentation

[AskUserQuestion: Top priority?]
User: Finish homepage mockups

Summary:
✓ Notes: weekly, daily
✓ Inbox: 3 notes
✓ Focus: Website Redesign, API Documentation
✓ Priority: Finish homepage mockups
```

### Example 2: Quarter Start (Jan 1)
```
Assistant: Good morning! Happy New Year!

✓ Created: quarterly (2026-Q1), monthly (2026-01), weekly (2026-W01), daily (2026-01-01)
Inbox: 0 notes
Active projects: [list]

[Continues with focus/priority questions...]
```

### Example 3: Regular Tuesday
```
Assistant: Good morning!

✓ Created: daily (2026-01-13)
Inbox: 5 notes (run /process-inbox when ready)
Active projects: [list]

[Continues with focus/priority questions...]
```
