---
name: daily-startup
description: Interactive daily workflow session - create periodic notes (daily/weekly/monthly/quarterly), check inbox, surface tasks, review OKRs
allowed-tools: [Read, Write, Bash, obsidian]
---

# Daily Startup Workflow

Run an interactive daily startup session to begin the day with clarity and focus.

## Purpose

Guide the user through their daily startup routine in an interactive, personalized way. Intelligently create all relevant periodic notes (daily, weekly if Monday, monthly if 1st, quarterly if quarter start), surface relevant information, and set priorities for the day.

## Workflow

Execute the following steps interactively, asking the user for confirmation at each stage:

### Step 1: Create Periodic Notes

Intelligently detect which periods are starting today and offer to create missing periodic notes.

**Detection Logic:**

1. Get today's date and day of week
2. Determine which periods are starting:
   - **Quarterly**: If today is Jan 1, Apr 1, Jul 1, or Oct 1
   - **Monthly**: If today is the 1st of any month
   - **Weekly**: If today is Monday
   - **Daily**: Always

**Creation Order (ask separately for each missing note):**

**Quarterly Note** (if Q1/Q2/Q3/Q4 starts today):
- Path: `1 - Notes/Quarterly Notes/YYYY-QQ.md` (e.g., 2026-Q1.md)
- Template: `Templates/Quarterly Notes.md`
- Check if exists, ask: "Create quarterly note for Q[N] YYYY?"
- Format: `2026-Q1`, `2026-Q2`, etc.

**Monthly Note** (if month starts today):
- Path: `1 - Notes/Monthly Notes/YYYY-MM.md` (e.g., 2026-01.md)
- Template: `Templates/Monthly Notes.md`
- Check if exists, ask: "Create monthly note for [Month YYYY]?"
- Format: `2026-01`, `2026-02`, etc.

**Weekly Note** (if Monday):
- Path: `1 - Notes/Weekly Notes/YYYY-Www.md` (e.g., 2026-W02.md)
- Template: `Templates/Weekly Notes.md`
- Check if exists, ask: "Create weekly note for Week [W]?"
- Format: ISO week number: `2026-W01`, `2026-W02`, etc.
- Use ISO 8601 week numbering (Monday as week start)

**Daily Note** (always):
- Path: `1 - Notes/Daily Notes/YYYY-MM-DD.md` (e.g., 2026-01-12.md)
- Template: `Templates/Daily Notes.md`
- Check if exists, ask: "Create today's daily note?"
- Format: `2026-01-12`

**Behavior:**

- Check each applicable period in order (quarterly → monthly → weekly → daily)
- For each missing note:
  - Ask user if they want to create it
  - If yes: Read template, create note, confirm creation
  - If no: Skip and continue to next period
  - If already exists: Inform user, ask if they want to open for review
- Be conversational: "Today starts Q1 2026. Create quarterly note?"
- Handle special case where it's already exists gracefully

### Step 2: Check Inbox

1. Count notes in `0 - PARA/0 - Inbox/`
2. Report to user: "You have X notes in your inbox"
3. If X > 0:
   - Ask: "Would you like to process inbox notes now?"
   - If yes: Suggest running `/process-inbox` command
   - If no: Add to today's tasks as reminder
4. If X = 0:
   - Celebrate: "Inbox is empty!"

### Step 3: Surface Active Projects

1. List notes from `0 - PARA/1 - Projects/` (exclude Archives)
2. Show user: "Active projects: [list of 3-5 most recent projects]"
3. Ask: "Which projects are you focusing on today?"
4. Let user select 1-3 projects
5. Add selected projects to daily note as links

### Step 4: Review OKRs (Optional)

1. Ask user: "Check OKRs for the day?"
2. If yes:
   - Look for most recent OKR notes in `1 - Notes/OKRS/`
   - Show relevant quarterly/monthly/weekly goals
   - Highlight any goals due this week
3. If no: Skip to next step

### Step 5: Set Today's Focus

1. Ask user: "What are your top 3 priorities for today?"
2. Let user input priorities
3. Add to daily note under "Today's Focus" section

### Step 6: Open Daily Note

1. Ask user: "Open today's daily note?"
2. If yes: Provide path and suggest opening
3. Summarize startup session:
   - Periodic notes created (daily/weekly/monthly/quarterly)
   - Inbox count
   - Active projects identified
   - Priorities set

## Configuration

Read configuration from `.claude/obsidian-second-brain.local.md`:
- `vault_path` - Path to Obsidian vault

Default: `/Users/kriscard/obsidian-vault-kriscard`

## Tools Usage

**Obsidian MCP tools:**
- `obsidian_get_file_contents` - Read periodic note templates (Daily/Weekly/Monthly/Quarterly)
- `obsidian_list_files_in_dir` - List inbox notes, projects, check for existing periodic notes
- `obsidian_append_content` - Create or update periodic notes
- `obsidian_get_periodic_note` - Get current periodic notes (daily, weekly, monthly, quarterly)

**Read tool:**
- Read plugin configuration
- Read template file if Obsidian MCP not available

**Bash tool:**
- Count inbox notes
- List projects
- Use only if Obsidian MCP unavailable

## Best Practices

- **Be conversational**: Ask questions naturally, don't script responses
- **Be flexible**: Let user skip steps they don't need
- **Be concise**: Keep summaries brief and actionable
- **Link everything**: Add [[wiki links]] to projects, areas, OKRs
- **Respect preferences**: Remember if user consistently skips certain steps

## Error Handling

- **Missing templates**: Use basic note structure if periodic templates not found (Daily/Weekly/Monthly/Quarterly Notes.md)
- **Vault path not configured**: Ask user for vault path
- **Obsidian MCP unavailable**: Fall back to bash/read tools for checking/creating periodic notes
- **No active projects**: Suggest creating first project
- **Invalid week/quarter calculations**: Use ISO 8601 standards, handle edge cases (Dec 29-Jan 4)

## Related Skills

- **obsidian-workflows** - For PARA and second brain principles
- **vault-structure** - For vault path and folder structure
- **template-patterns** - For daily note template usage

## Example Interactions

### Example 1: Regular Monday (Week + Day)
```
Assistant: Good morning! Let's start your day.

Today is Monday, the start of a new week. Create weekly note for Week 2? (2026-W02)
User: Yes

Assistant: Weekly note created for 2026-W02.

Create today's daily note? (2026-01-12)
User: Yes

Assistant: Daily note created for 2026-01-12.

You have 3 notes in your inbox. Would you like to process them now?
User: No

Assistant: I'll add inbox processing to your tasks.

Active projects:
1. Website Redesign
2. API Documentation
3. Team Onboarding Guide

Which projects are you focusing on today?
User: 1 and 2

Assistant: Added Website Redesign and API Documentation to your daily note.

What are your top 3 priorities for today?
User: 
1. Finish homepage mockups
2. Review API endpoints
3. Team standup at 10am

Assistant: Priorities added to your daily note.

Summary:
- Created weekly note (2026-W02) and daily note (2026-01-12)
- 3 notes in inbox (reminder added)
- Focus projects: Website Redesign, API Documentation
- Priorities set for the day

Ready to start your day\!
```

### Example 2: First Day of Quarter (Jan 1 - Quarterly + Monthly + Weekly + Daily)
```
Assistant: Good morning\! Happy New Year\!

Today starts Q1 2026. Create quarterly note?
User: Yes

Assistant: Quarterly note created for 2026-Q1.

First day of January. Create monthly note?
User: Yes

Assistant: Monthly note created for 2026-01.

Today is Monday, start of a new week. Create weekly note for Week 1?
User: Yes

Assistant: Weekly note created for 2026-W01.

Create today's daily note? (2026-01-01)
User: Yes

Assistant: Daily note created for 2026-01-01.

[Continues with inbox, projects, OKRs, priorities...]
```

### Example 3: Regular Tuesday (Daily Only)
```
Assistant: Good morning\! Let's start your day.

Create today's daily note? (2026-01-13)
User: Yes

Assistant: Daily note created for 2026-01-13.

[Continues with inbox, projects, priorities...]
```
