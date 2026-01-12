---
name: process-inbox
description: One-by-one inbox review with intelligent PARA placement suggestions
allowed-tools: [Read, Write, Bash, obsidian]
---

# Process Inbox Command

Guide the user through processing inbox notes one by one with intelligent PARA placement suggestions.

## Purpose

Help user achieve "inbox zero" by reviewing each note, suggesting appropriate PARA categorization, and moving notes to their proper location.

## Workflow

### Step 1: Initialize

1. Count notes in `0 - PARA/0 - Inbox/`
2. Report: "Found X notes to process"
3. If X = 0:
   - Celebrate: "Inbox is empty!"
   - Exit command
4. If X > 0: Continue to processing

### Step 2: Process Each Note

For each note in inbox, do the following:

**2.1 Display Note**
- Show note filename
- Show note content (first 10-20 lines or full if short)
- Show note metadata (tags, created date if available)

**2.2 Analyze and Suggest**

Use the para-organizer agent logic to analyze:
- Does it support an active project? → Projects
- Is it an ongoing responsibility? → Areas
- Is it reference material? → Resources
- Is it from completed work? → Archives
- Still uncertain? → Skip for now

Suggest PARA category with reasoning:
```
Suggested placement: 1 - Projects/[Project Name]/
Reasoning: This note appears to be related to [project] and contains actionable tasks.
```

**2.3 Suggest Tags**

Based on content, suggest appropriate tags following Tag Taxonomy:
- Content type (project/area/reference/etc.)
- Subject (javascript/react/career/etc.)
- Special purpose (active/interview/etc.)

**2.4 Get User Decision**

Ask user:
```
What would you like to do?
1. Move to suggested location (1 - Projects/)
2. Specify different location
3. Skip (leave in inbox)
4. Delete note
5. Stop processing
```

**2.5 Execute Action**

Based on user choice:
- **Move**: Use Obsidian MCP to move note to target folder
- **Specify**: Ask for target path, then move
- **Skip**: Mark with #to-process tag for later
- **Delete**: Confirm, then delete using Obsidian MCP
- **Stop**: End processing session

**2.6 Update Metadata**

When moving note:
- Add suggested tags
- Update frontmatter if present
- Add processing date

**2.7 Track Progress**

After each note:
- Report: "Processed X of Y notes"
- Show: "Remaining: Z notes"

### Step 3: Summary

After processing all notes (or user stops):
```
Inbox Processing Complete!

Processed: X notes
Moved to Projects: X
Moved to Areas: X
Moved to Resources: X
Archived: X
Deleted: X
Skipped: X
Remaining in inbox: X
```

## PARA Decision Logic

Reference this decision tree:

**Is this for an active project with a deadline?**
→ YES: `0 - PARA/1 - Projects/[Project Name]/`

**Is this an ongoing responsibility?**
→ YES: `0 - PARA/2 - Areas/[Area Name]/`

**Is this reference material for future use?**
→ YES: `0 - PARA/3 - Resources/`

**Is this completed or inactive?**
→ YES: `0 - PARA/4 - Archives/`

**Still unsure?**
→ Skip, leave in inbox

## Tag Suggestion Logic

Follow Tag Taxonomy rules:
- **Maximum 3-4 tags**
- **Required**: Content type + Subject
- **Optional**: Special purpose

Content types: flashcards, reference, project, area, meeting, daily, moc
Subjects: javascript, react, css, typescript, web, career, personal, tools

## Tools Usage

**Obsidian MCP:**
- `obsidian_list_files_in_dir` - List inbox notes
- `obsidian_get_file_contents` - Read note content
- `obsidian_patch_content` - Update note metadata
- `obsidian_delete_file` - Delete notes (with confirmation)

**Use Obsidian's move functionality** or recreate note in new location.

## Configuration

Read from `.claude/obsidian-second-brain.local.md`:
- `vault_path` - Vault location

## Best Practices

- **One note at a time**: Don't batch, process individually
- **Explain reasoning**: Always explain why suggesting specific placement
- **Respect user decisions**: If user chooses different location, trust their judgment
- **Link while processing**: Suggest linking to related notes/projects
- **Be encouraging**: Celebrate progress ("5 down, 3 to go!")

## Error Handling

- **Empty inbox**: Celebrate and exit
- **Note read error**: Skip note, report issue, continue
- **Move error**: Report, ask user to move manually, continue
- **User cancels mid-process**: Save progress, report what was completed

## Related Skills

- **obsidian-workflows** - PARA principles and inbox processing
- **vault-structure** - Folder structure and paths
- **template-patterns** - If notes need templates applied

## Related Agents

The **para-organizer agent** may activate proactively during this command to provide placement suggestions.

## Example Interaction

```
Assistant: Found 5 notes in inbox. Let's process them!

[1/5] Note: "React 19 features to explore"
Content: New features in React 19 including...

Suggested placement: 0 - PARA/3 - Resources/
Reasoning: Reference material about React features, no immediate action needed.
Suggested tags: [reference, react]

What would you like to do?
1. Move to Resources
2. Specify different location
3. Skip
4. Delete
5. Stop

User: 1