---
name: process-inbox
description: One-by-one inbox review with intelligent PARA placement suggestions
allowed-tools: [Read, Write, Bash, AskUserQuestion, obsidian]
---

# Process Inbox Command

EXECUTE THIS WORKFLOW NOW. Do not describe it - actually run the commands and process notes.

## Step 1: Check CLI and List Inbox

Run this command NOW:
```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

If `CLI_UNAVAILABLE`: Ask user "Obsidian CLI isn't available. May I use Obsidian MCP instead?" and wait for confirmation before continuing.

Then list inbox notes:
```bash
obsidian files folder="0 - Inbox/"
```

Report the count: "Found X notes to process"

If count is 0: Say "Inbox is empty!" and stop.

## Step 2: Process Each Note One-by-One

For EACH note in the inbox, do ALL of these steps:

### 2.1 Read the Note

```bash
obsidian read path="0 - Inbox/[filename]"
```

Display to user:
- `[N/TOTAL] Note: "[filename]"`
- Show first 15 lines of content
- Show any existing tags/frontmatter

### 2.2 Analyze and Suggest Placement

Apply PARA decision logic:
- Has deadline or active project work? → `1 - Projects/[Project Name]/`
- Ongoing responsibility? → `2 - Areas/[Area Name]/`
- Reference material? → `3 - Resources/`
- Completed/inactive? → `4 - Archives/`
- Unsure? → Suggest skip

Tell user your suggestion with reasoning:
```
Suggested: 3 - Resources/
Reason: Reference material about [topic], no immediate action needed.
Tags: [topic-tag]
```

### 2.3 Ask User What To Do

Use AskUserQuestion tool with these options:
- "Move to [suggested location]" (Recommended)
- "Move to different location"
- "Skip for now"
- "Delete note"
- "Stop processing"

WAIT for user response before continuing.

### 2.4 Execute User's Choice

**Move**: Read content, create in new location, delete from inbox:
```bash
# Get content first, then:
obsidian create path="[target]/[filename]" content="[CONTENT]" silent
obsidian delete path="0 - Inbox/[filename]" silent
```

**Different location**: Ask where, then move there.

**Skip**: Leave in inbox, continue to next note.

**Delete**: Confirm first, then:
```bash
obsidian delete path="0 - Inbox/[filename]" silent
```

**Stop**: Show summary and end.

### 2.5 Report Progress

After each note: "Progress: X/Y processed (Z remaining)"

Then immediately continue to the next note.

## Step 3: Final Summary

After all notes processed (or user stops):

```
Inbox Processing Complete!

Processed: X notes
- Projects: X
- Areas: X
- Resources: X
- Archives: X
- Deleted: X
- Skipped: X

Remaining in inbox: X
```

## Reference: Tag Suggestions

Subject tags only (folder handles content type):
- javascript, react, css, typescript, web, career, personal, tools
- Status: active, interview
- TIL: til/[topic]

Do NOT use: project, area, reference, daily, moc, meeting (folders handle these)

## Reference: CLI Commands

```bash
# List inbox
obsidian files folder="0 - Inbox/"

# Read note
obsidian read path="0 - Inbox/note.md"

# Move (create + delete)
obsidian create path="3 - Resources/note.md" content="$CONTENT" silent
obsidian delete path="0 - Inbox/note.md" silent

# Delete
obsidian delete path="0 - Inbox/note.md" silent
```
