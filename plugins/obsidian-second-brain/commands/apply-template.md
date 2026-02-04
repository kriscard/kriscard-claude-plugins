---
name: apply-template
description: Apply templates to notes interactively - select from all available templates
allowed-tools: [Read, Write, obsidian]
---

# Apply Template Command

Interactively select and apply templates to notes in the vault.

## Purpose

Help user apply structured templates to existing or new notes. Shows all available templates, lets user select, and applies template to current or specified note.

## Workflow

### Step 1: List Available Templates

1. Scan `Templates/` folder
2. List all `.md` files (exclude Archive/ subfolder)
3. Organize by category:
   - Daily & Planning (Daily Notes, Weekly Planning, Monthly Goals, Quarterly Goals)
   - Meetings (Meeting Notes, 1-on-1 Meeting Notes)
   - Projects & Work (Project Brief, Project Planning, Feature Implementation, Bug Fix, Problem Solving)
   - Learning & Knowledge (Learning, Learning Tech Template, Book Reviews)
   - Organization (MOC Template, General Notes, People)
   - Other templates

4. Display to user:
```
Available Templates:

Daily & Planning:
  1. Daily Notes
  2. Weekly Planning
  3. Monthly Goals
  4. Quarterly Goals

Meetings:
  5. Meeting Notes
  6. 1-on-1 Meeting Notes

Projects & Work:
  7. Project Brief
  8. Project Planning
  9. Feature Implementation
  10. Bug Fix
  11. Problem Solving

Learning & Knowledge:
  12. Learning
  13. Learning Tech Template
  14. Book Reviews

Organization:
  15. MOC Template
  16. General Notes
  17. People

Other:
  18. Communicate your work
  19. Weekly Workout

Which template would you like to apply?  (Enter number or name)
```

### Step 2: Get Template Selection

1. User selects template by number or name
2. Validate selection
3. If invalid: Ask again
4. Read selected template content from `Templates/[template-name].md`

### Step 3: Determine Target Note

Ask user:
```
Where should this template be applied?
1. Current note (if opened in context)
2. Specify note path
3. Create new note
```

**Option 1: Current note**
- If note path provided in conversation context
- Apply template to existing note

**Option 2: Specify path**
- Ask: "Enter note path (relative to vault root)"
- Example: `1 - Projects/New Project.md`
- Validate path
- Check if note exists:
  - If yes: Ask "Note exists. Append template or replace content?"
  - If no: Create new note with template

**Option 3: Create new note**
- Ask: "Enter new note name and location"
- Example: `New Project` in `1 - Projects/`
- Suggest appropriate PARA location based on template type:
  - Project templates → `1 - Projects/`
  - Learning templates → `3 - Resources/`
  - Daily/Planning → `2 - Areas/Daily Ops/` or `2 - Areas/Goals/`
  - Meeting → Varies, ask user
- Create note with template

### Step 4: Apply Template

**If note exists:**
- Ask: "Append template or replace content?"
  - **Append**: Add template content to end of note
  - **Replace**: Replace entire note content with template
  - **Cancel**: Don't apply

**If creating new note:**
- Create note with template content
- Set initial metadata:
  - Created date
  - Suggested tags based on template type
  - Any template-specific frontmatter

### Step 5: Process Template

**Template processing:**
1. Read template content
2. Replace placeholders:
   - `{{date}}` → Current date
   - `{{date:YYYY-MM-DD}}` → Formatted date
   - `{{FIELD}}` → Prompt user for value or leave as is
3. Apply processed content to note

**Metadata suggestions:**
- Project templates → Add tags: `[project, subject, active]`
- Learning templates → Add tags: `[reference, subject]`
- Meeting templates → Add tags: `[meeting, subject]`
- Daily templates → Add tags: `[daily]`

### Step 6: Confirmation

Report to user:
```
Template applied successfully!

Note: 1 - Projects/New Project.md
Template: Project Brief
Action: Created new note

Next steps:
- Fill in template sections
- Add tags: [project, career, active]
- Link to relevant areas and resources

Would you like to apply another template?
```

## Template Type → Location Suggestions

**Project templates** (Project Brief, Project Planning, Feature Implementation, Bug Fix):
- Suggest: `1 - Projects/[Project Name]/`
- Ask for project name if creating new

**Learning templates** (Learning, Learning Tech Template, Book Reviews):
- Suggest: `3 - Resources/`
- Good for reference materials

**Meeting templates** (Meeting Notes, 1-on-1):
- Suggest asking user for location
- Could be in project folder or area folder
- 1-on-1s typically go in `2 - Areas/Careers/1on1/`

**Daily/Planning templates** (Daily Notes, Weekly Planning, Monthly/Quarterly Goals):
- Daily Notes → `2 - Areas/Daily Ops/`
- Weekly Planning → `2 - Areas/Daily Ops/Weekly/M - Month YYYY/`
- Monthly Goals → `2 - Areas/Goals/Monthly/`
- Quarterly Goals → `2 - Areas/Goals/Quarterly/`

**Organization templates** (MOC Template, People):
- MOC → `MOCs/`
- People → `2 - Areas/Relationships/`

**General Notes**:
- Ask user for appropriate location

## Tools Usage

**Obsidian MCP:**
- `obsidian_list_files_in_dir` - List templates
- `obsidian_get_file_contents` - Read template content
- `obsidian_append_content` - Apply template to note
- Create or update notes

**Read tool:**
- Fallback for reading templates if Obsidian MCP unavailable

**Write tool:**
- Fallback for creating notes if needed

## Configuration

Read from `.claude/obsidian-second-brain.local.md`:
- `vault_path`

## Best Practices

- **Show all templates**: Don't pre-filter, let user choose
- **Suggest location**: Based on template type, but let user override
- **Process placeholders**: Replace date/time placeholders automatically
- **Preserve content**: When appending, don't lose existing content
- **Confirm actions**: Always confirm before replacing content
- **Offer guidance**: Suggest next steps after applying template

## Error Handling

- **Template not found**: Show error, let user select again
- **Note path invalid**: Ask for valid path
- **Permission error**: Report, suggest alternative action
- **Template read error**: Try fallback methods
- **Obsidian MCP unavailable**: Use Read/Write tools directly

## Related Skills

- **template-patterns** - Template selection guidance and usage patterns
- **vault-structure** - Folder structure and suggested locations
- **obsidian-workflows** - When to use different templates

## Related Agents

No agents typically involved, but:
- **para-organizer** might suggest better location
- **tag-optimizer** might suggest tags after template applied

## Special Template Handling

**Daily Notes template:**
- Should be named with date: `YYYY-MM-DD.md`
- Location: `2 - Areas/Daily Ops/`
- Auto-fill date placeholders

**OKR templates:**
- Quarterly: `Quaterly Goals - QN YYYY.md` (in `2 - Areas/Goals/Quarterly/`)
- Monthly: `M - Month YYYY.md` (in `2 - Areas/Goals/Monthly/`)
- Weekly: `YYYY-Www.md` (in `2 - Areas/Daily Ops/Weekly/M - Month YYYY/`)

**Project templates:**
- Suggest asking for project name
- Create in: `1 - Projects/[Project Name]/`
- May create project folder if doesn't exist

## Example Interaction

```
Assistant: Available Templates:

Daily & Planning:
  1. Daily Notes
  2. Weekly Planning
  3. Monthly Goals
  4. Quarterly Goals

Projects & Work:
  5. Project Brief
  6. Project Planning
  ...

Which template would you like to apply?

User: 5 (Project Brief)