---
name: daily-startup
description: Interactive daily workflow session - create daily note, check inbox, surface tasks, review OKRs
allowed-tools: [Read, Write, Bash, obsidian]
---

# Daily Startup Workflow

Run an interactive daily startup session to begin the day with clarity and focus.

## Purpose

Guide the user through their daily startup routine in an interactive, personalized way. Create the daily note, surface relevant information, and set priorities for the day.

## Workflow

Execute the following steps interactively, asking the user for confirmation at each stage:

### Step 1: Create Daily Note

1. Get today's date in format `YYYY-MM-DD`
2. Check if daily note already exists at `1 - Notes/Daily Notes/YYYY-MM-DD.md`
3. If note doesn't exist:
   - Ask user: "Create today's daily note?"
   - If yes:
     - Read template from `Templates/Daily Notes.md`
     - Create note at `1 - Notes/Daily Notes/YYYY-MM-DD.md`
     - Apply template with today's date
     - Confirm creation: "Daily note created for [date]"
4. If note already exists:
   - Inform user: "Daily note for [date] already exists"
   - Ask: "Open it for review?"

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
   - Daily note status
   - Inbox count
   - Active projects identified
   - Priorities set

## Configuration

Read configuration from `.claude/obsidian-second-brain.local.md`:
- `vault_path` - Path to Obsidian vault

Default: `/Users/kriscard/obsidian-vault-kriscard`

## Tools Usage

**Obsidian MCP tools:**
- `obsidian_get_file_contents` - Read daily note template
- `obsidian_list_files_in_dir` - List inbox notes, projects
- `obsidian_append_content` - Create or update daily note

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

- **Missing template**: Use basic daily note structure if `Daily Notes.md` not found
- **Vault path not configured**: Ask user for vault path
- **Obsidian MCP unavailable**: Fall back to bash/read tools
- **No active projects**: Suggest creating first project

## Related Skills

- **obsidian-workflows** - For PARA and second brain principles
- **vault-structure** - For vault path and folder structure
- **template-patterns** - For daily note template usage

## Example Interaction

```
Assistant: Good morning! Let's start your day.

Create today's daily note? (2025-01-11)
User: Yes