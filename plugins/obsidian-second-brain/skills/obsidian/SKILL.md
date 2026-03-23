---
name: obsidian
description: >-
  Performs all Obsidian vault operations — reading notes, creating files, appending
  content, searching, and listing files — using CLI-first approach. Make sure
  to use this skill whenever the user mentions obsidian, vault,
  notes, daily note, or any vault file operation. If the user mentions Obsidian in
  any context, use this skill.
---

# Obsidian Operations Skill

This skill defines how to interact with Obsidian vaults. **Always use CLI directly. If it fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."**

## Quick Reference

| Operation | CLI Command |
|-----------|------------|
| Read file | `obsidian read path="..."` |
| Create file | `obsidian create path="..." content="..." silent` |
| Append | `obsidian append path="..." content="..." silent` |
| Search | `obsidian search query="..." format=json` |
| List files | `obsidian files folder="..." format=json` |
| Daily note | `obsidian daily:read` |

## Using obsidian-utils.sh

The shared utility script handles all operations. Located at:
```
${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh
```

### Script Commands

| Operation | Command | Example |
|-----------|---------|---------|
| Read file | `./obsidian-utils.sh read "path.md"` | Read by exact path |
| Read by name | `./obsidian-utils.sh read-file "Recipe"` | Wikilink-style resolution |
| List files | `./obsidian-utils.sh list "folder/" json` | List with format |
| Create file | `./obsidian-utils.sh create "path.md" "content"` | Create note |
| Create from template | `./obsidian-utils.sh create-template "path.md" "Template"` | Use template |
| Append | `./obsidian-utils.sh append "path.md" "content"` | Append to note |
| Prepend | `./obsidian-utils.sh prepend "path.md" "content"` | Prepend after frontmatter |
| Search | `./obsidian-utils.sh search "query" json` | Search vault |
| Delete | `./obsidian-utils.sh delete "path.md"` | Delete note (trash) |
| Move | `./obsidian-utils.sh move "old.md" "new.md"` | Move/rename |
| Daily note | `./obsidian-utils.sh daily read` | Read today's daily |
| Daily append | `./obsidian-utils.sh daily append "content"` | Append to daily |
| Tasks | `./obsidian-utils.sh tasks all` | List all tasks |
| Tags | `./obsidian-utils.sh tags` | List tags with counts |
| Backlinks | `./obsidian-utils.sh backlinks "path.md"` | List backlinks |
| Unresolved | `./obsidian-utils.sh unresolved` | Find broken links |
| Orphans | `./obsidian-utils.sh orphans` | Find orphan files |
| Outline | `./obsidian-utils.sh outline "path.md"` | Show headings |
| Properties | `./obsidian-utils.sh properties "path.md"` | List frontmatter |
| Set property | `./obsidian-utils.sh property-set "path.md" "key" "value"` | Set frontmatter |
| Templates | `./obsidian-utils.sh templates` | List templates |
| Template read | `./obsidian-utils.sh template-read "Name"` | Get resolved template |

## CLI Commands Reference

### File Targeting

Two ways to target files:

| Parameter | Behavior | Example |
|-----------|----------|---------|
| `file=<name>` | Wikilink-style resolution (no path/ext needed) | `file=Recipe` finds `Recipes/Recipe.md` |
| `path=<path>` | Exact path from vault root | `path="3 - Resources/TIL/til-2026-02-16.md"` |

### File Operations

```bash
# Read file content
"obsidian" read path="2 - Areas/Daily Ops/2026/2026-02-14.md"
"obsidian" read file="Recipe"  # wikilink resolution

# List files in folder (json for parsing)
"obsidian" files folder="0 - Inbox/" format=json

# Create new file
"obsidian" create path="3 - Resources/TIL/til-2026-02-14.md" content="# TIL..." silent

# Create from template
"obsidian" create path="note.md" template="Daily Notes" silent

# Append to file (silent = don't open)
"obsidian" append path="note.md" content="\n## New Section" silent

# Append inline (no newline added)
"obsidian" append path="note.md" content=" - item" silent inline

# Prepend after frontmatter
"obsidian" prepend path="note.md" content="# Header" silent

# Move/rename file
"obsidian" move path="old.md" to="folder/new.md"

# Delete file (to trash)
"obsidian" delete path="note.md"

# Delete permanently
"obsidian" delete path="note.md" permanent

# Search vault
"obsidian" search query="meeting notes" format=json limit=20
```

### Daily Notes

```bash
# Read today's daily note
"obsidian" daily:read

# Append to daily note
"obsidian" daily:append content="- [ ] Buy groceries" silent

# Prepend to daily note
"obsidian" daily:prepend content="# Morning Notes" silent

# Open daily note (just get path)
"obsidian" daily silent
```

### Tasks

```bash
# List all tasks
"obsidian" tasks all

# List tasks from daily note
"obsidian" tasks daily

# List incomplete tasks
"obsidian" tasks todo

# List completed tasks
"obsidian" tasks done

# Toggle a task
"obsidian" task path="note.md" line=8 toggle

# Mark task done
"obsidian" task path="note.md" line=8 done
```

### Tags

```bash
# List all tags with counts
"obsidian" tags all counts

# Get info about specific tag
"obsidian" tag name="project" verbose
```

### Links & Graph

```bash
# List backlinks to a file
"obsidian" backlinks path="note.md" counts

# List outgoing links
"obsidian" links path="note.md"

# Find broken (unresolved) links
"obsidian" unresolved verbose counts

# Find orphan files (no incoming links)
"obsidian" orphans

# Find dead-end files (no outgoing links)
"obsidian" deadends
```

### Properties (Frontmatter)

```bash
# List properties of a file
"obsidian" properties path="note.md" format=yaml

# Set a property
"obsidian" property:set path="note.md" name="status" value="complete"

# Set property with type
"obsidian" property:set path="note.md" name="priority" value="5" type=number

# Read a property value
"obsidian" property:read path="note.md" name="status"

# Remove a property
"obsidian" property:remove path="note.md" name="draft"
```

### Templates

```bash
# List available templates
"obsidian" templates

# Read template (with variables resolved)
"obsidian" template:read name="Daily Notes" resolve

# Read template raw
"obsidian" template:read name="Daily Notes"
```

### Outline & Structure

```bash
# Show headings tree
"obsidian" outline path="note.md" format=tree

# Show headings as markdown
"obsidian" outline path="note.md" format=md
```

### Vault Info

```bash
# Full vault info
"obsidian" vault

# Specific info
"obsidian" vault info=files    # file count
"obsidian" vault info=size     # vault size
```

### CLI Flags

| Flag | Effect |
|------|--------|
| `silent` | Don't open file after operation |
| `overwrite` | Replace existing file |
| `inline` | Append/prepend without adding newline |
| `permanent` | Delete permanently (skip trash) |
| `resolve` | Resolve template variables |
| `verbose` | Include extra details |
| `counts` | Include occurrence counts |
| `total` | Return count only |

### Output Formats

| Format | Use for |
|--------|---------|
| `format=json` | Parsing in code |
| `format=text` | Human readable |
| `format=yaml` | Properties/frontmatter |
| `format=tree` | Outline hierarchy |
| `format=md` | Markdown output |

### Multiline Content

Use `\n` for newlines and `\t` for tabs:

```bash
"obsidian" create path="note.md" content="# Title\n\nBody text\n\n- Item 1\n- Item 2" silent
```


## Vault Structure

Default vault: `/Users/kriscard/obsidian-vault-kriscard`

Key paths:
- `0 - Inbox/` - Incoming notes
- `1 - Projects/` - Active projects
- `2 - Areas/` - Ongoing responsibilities
- `3 - Resources/` - Reference material
- `4 - Archives/` - Completed/inactive
- `Templates/` - Note templates

## Best Practices

1. **Use `silent` flag** - Always add `silent` for non-interactive operations
2. **Use `format=json`** - For parsing output programmatically
3. **Prefer `file=`** - When you know the name but not the path
4. **Use `path=`** - When you know the exact path
5. **Batch operations** - Use parallel calls when checking multiple files
6. **Templates** - Use `template=` parameter when creating from templates
8. **Confirmation** - Never delete without explicit user confirmation

## CLI Requirements

Obsidian CLI requires:
- Obsidian with CLI enabled: Settings → General → Command line interface
- Obsidian must be running

If CLI commands fail, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."
