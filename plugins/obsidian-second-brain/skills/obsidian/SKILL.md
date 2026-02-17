---
description: >-
  Use when performing ANY Obsidian vault operations: reading notes, creating files,
  appending content, searching, or listing files. Covers CLI-first approach with
  MCP fallback. Essential for all Obsidian-related commands and agents.

  Trigger phrases: "obsidian", "vault", "create note", "read note", "append to note",
  "search vault", "list files", "daily note", "periodic note", "TIL note"
---

# Obsidian Operations Skill

This skill defines how to interact with Obsidian vaults. **Always prefer CLI when available, fall back to MCP with user confirmation.**

## Quick Reference

| Operation | CLI Command | MCP Fallback |
|-----------|------------|--------------|
| Read file | `"$OBSIDIAN_CLI" read path="..."` | `mcp__mcp-obsidian__obsidian_get_file_contents` |
| Create file | `"$OBSIDIAN_CLI" create path="..." content="..." silent` | `mcp__mcp-obsidian__obsidian_append_content` |
| Append | `"$OBSIDIAN_CLI" append path="..." content="..." silent` | `mcp__mcp-obsidian__obsidian_append_content` |
| Search | `"$OBSIDIAN_CLI" search query="..." format=json` | `mcp__mcp-obsidian__obsidian_simple_search` |
| List files | `"$OBSIDIAN_CLI" files folder="..." format=json` | `mcp__mcp-obsidian__obsidian_list_files_in_dir` |
| Daily note | `"$OBSIDIAN_CLI" daily:read` | `mcp__mcp-obsidian__obsidian_get_periodic_note` |

## Detection Flow

```
1. Check CLI: Run detection command (see below)
2. If CLI_AVAILABLE: Use CLI commands via Bash with $OBSIDIAN_CLI
3. If CLI_UNAVAILABLE: Ask user to confirm MCP usage, then use MCP tools
```

### CLI Detection Pattern

**IMPORTANT:** Claude Code's Bash doesn't inherit PATH from ~/.zprofile. Use this pattern:

```bash
# Check CLI availability (try PATH, then macOS app location)
OBSIDIAN_CLI="${OBSIDIAN_CLI:-$(command -v obsidian 2>/dev/null || echo '/Applications/Obsidian.app/Contents/MacOS/Obsidian')}"
"$OBSIDIAN_CLI" vault &>/dev/null && echo "CLI_AVAILABLE" || echo "CLI_UNAVAILABLE"
```

After detection, use `"$OBSIDIAN_CLI"` for all commands (not bare `obsidian`).

## Using obsidian-utils.sh

The shared utility script handles detection and all operations. Located at:
```
${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh
```

### Script Commands

| Operation | Command | Example |
|-----------|---------|---------|
| Check status | `./obsidian-utils.sh status` | Shows CLI availability |
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
"$OBSIDIAN_CLI" read path="2 - Areas/Daily Ops/2026-02-14.md"
"$OBSIDIAN_CLI" read file="Recipe"  # wikilink resolution

# List files in folder (json for parsing)
"$OBSIDIAN_CLI" files folder="0 - Inbox/" format=json

# Create new file
"$OBSIDIAN_CLI" create path="3 - Resources/TIL/til-2026-02-14.md" content="# TIL..." silent

# Create from template
"$OBSIDIAN_CLI" create path="note.md" template="Daily Notes" silent

# Append to file (silent = don't open)
"$OBSIDIAN_CLI" append path="note.md" content="\n## New Section" silent

# Append inline (no newline added)
"$OBSIDIAN_CLI" append path="note.md" content=" - item" silent inline

# Prepend after frontmatter
"$OBSIDIAN_CLI" prepend path="note.md" content="# Header" silent

# Move/rename file
"$OBSIDIAN_CLI" move path="old.md" to="folder/new.md"

# Delete file (to trash)
"$OBSIDIAN_CLI" delete path="note.md"

# Delete permanently
"$OBSIDIAN_CLI" delete path="note.md" permanent

# Search vault
"$OBSIDIAN_CLI" search query="meeting notes" format=json limit=20
```

### Daily Notes

```bash
# Read today's daily note
"$OBSIDIAN_CLI" daily:read

# Append to daily note
"$OBSIDIAN_CLI" daily:append content="- [ ] Buy groceries" silent

# Prepend to daily note
"$OBSIDIAN_CLI" daily:prepend content="# Morning Notes" silent

# Open daily note (just get path)
"$OBSIDIAN_CLI" daily silent
```

### Tasks

```bash
# List all tasks
"$OBSIDIAN_CLI" tasks all

# List tasks from daily note
"$OBSIDIAN_CLI" tasks daily

# List incomplete tasks
"$OBSIDIAN_CLI" tasks todo

# List completed tasks
"$OBSIDIAN_CLI" tasks done

# Toggle a task
"$OBSIDIAN_CLI" task path="note.md" line=8 toggle

# Mark task done
"$OBSIDIAN_CLI" task path="note.md" line=8 done
```

### Tags

```bash
# List all tags with counts
"$OBSIDIAN_CLI" tags all counts

# Get info about specific tag
"$OBSIDIAN_CLI" tag name="project" verbose
```

### Links & Graph

```bash
# List backlinks to a file
"$OBSIDIAN_CLI" backlinks path="note.md" counts

# List outgoing links
"$OBSIDIAN_CLI" links path="note.md"

# Find broken (unresolved) links
"$OBSIDIAN_CLI" unresolved verbose counts

# Find orphan files (no incoming links)
"$OBSIDIAN_CLI" orphans

# Find dead-end files (no outgoing links)
"$OBSIDIAN_CLI" deadends
```

### Properties (Frontmatter)

```bash
# List properties of a file
"$OBSIDIAN_CLI" properties path="note.md" format=yaml

# Set a property
"$OBSIDIAN_CLI" property:set path="note.md" name="status" value="complete"

# Set property with type
"$OBSIDIAN_CLI" property:set path="note.md" name="priority" value="5" type=number

# Read a property value
"$OBSIDIAN_CLI" property:read path="note.md" name="status"

# Remove a property
"$OBSIDIAN_CLI" property:remove path="note.md" name="draft"
```

### Templates

```bash
# List available templates
"$OBSIDIAN_CLI" templates

# Read template (with variables resolved)
"$OBSIDIAN_CLI" template:read name="Daily Notes" resolve

# Read template raw
"$OBSIDIAN_CLI" template:read name="Daily Notes"
```

### Outline & Structure

```bash
# Show headings tree
"$OBSIDIAN_CLI" outline path="note.md" format=tree

# Show headings as markdown
"$OBSIDIAN_CLI" outline path="note.md" format=md
```

### Vault Info

```bash
# Full vault info
"$OBSIDIAN_CLI" vault

# Specific info
"$OBSIDIAN_CLI" vault info=files    # file count
"$OBSIDIAN_CLI" vault info=size     # vault size
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
"$OBSIDIAN_CLI" create path="note.md" content="# Title\n\nBody text\n\n- Item 1\n- Item 2" silent
```

## MCP Tools Reference

When CLI unavailable, use these MCP tools (with user confirmation):

| Operation | MCP Tool |
|-----------|----------|
| Read file | `mcp__mcp-obsidian__obsidian_get_file_contents` |
| Read multiple | `mcp__mcp-obsidian__obsidian_batch_get_file_contents` |
| List files | `mcp__mcp-obsidian__obsidian_list_files_in_dir` |
| Create/Append | `mcp__mcp-obsidian__obsidian_append_content` |
| Patch content | `mcp__mcp-obsidian__obsidian_patch_content` |
| Search | `mcp__mcp-obsidian__obsidian_simple_search` |
| Complex search | `mcp__mcp-obsidian__obsidian_complex_search` |
| Delete | `mcp__mcp-obsidian__obsidian_delete_file` |
| Daily note | `mcp__mcp-obsidian__obsidian_get_periodic_note` |
| Recent changes | `mcp__mcp-obsidian__obsidian_get_recent_changes` |

## MCP Fallback Confirmation

**Always confirm before using MCP.** Example interaction:

```
You: Obsidian CLI isn't available (Obsidian may not be running or CLI not enabled).
     May I use Obsidian MCP to read your vault instead?

User: Yes, go ahead

You: [Uses MCP tools]
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
6. **Error handling** - If CLI fails mid-operation, fall back to MCP
7. **Templates** - Use `template=` parameter when creating from templates
8. **Confirmation** - Never delete without explicit user confirmation

## CLI Requirements

Obsidian CLI requires:
- Obsidian v1.12+ (early access)
- Catalyst license
- CLI enabled: Settings → General → Command line interface
- Obsidian must be running

If any requirement isn't met, CLI commands will fail and MCP fallback is needed.
