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

## Detection Flow

```
1. Try CLI: Run obsidian-utils.sh status
2. If CLI_AVAILABLE: Use CLI commands via Bash
3. If CLI_UNAVAILABLE: Ask user to confirm MCP usage, then use MCP tools
```

## Using obsidian-utils.sh

The shared utility script handles detection automatically. Located at:
```
${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh
```

### Commands

| Operation | Command | Example |
|-----------|---------|---------|
| Check status | `./obsidian-utils.sh status` | Shows CLI availability |
| Read file | `./obsidian-utils.sh read "path.md"` | Read note content |
| List files | `./obsidian-utils.sh list "folder/"` | List directory contents |
| Create file | `./obsidian-utils.sh create "path.md" "content"` | Create new note |
| Append | `./obsidian-utils.sh append "path.md" "content"` | Append to note |
| Prepend | `./obsidian-utils.sh prepend "path.md" "content"` | Prepend to note |
| Search | `./obsidian-utils.sh search "query"` | Search vault |
| Delete | `./obsidian-utils.sh delete "path.md"` | Delete note |
| Daily note | `./obsidian-utils.sh daily read` | Read today's daily note |
| Daily append | `./obsidian-utils.sh daily append "content"` | Append to daily |

### Interpreting Output

When CLI is unavailable, output starts with `CLI_UNAVAILABLE` and provides MCP fallback instructions:

```
CLI_UNAVAILABLE
MCP_TOOL: mcp__mcp-obsidian__obsidian_get_file_contents
OPERATION: read
PARAM: filepath=path/to/note.md
---
Obsidian CLI not available. Use MCP tool 'mcp__mcp-obsidian__obsidian_get_file_contents' instead.
```

**When you see this output:**
1. Inform user: "Obsidian CLI isn't available. May I use Obsidian MCP instead?"
2. Wait for confirmation
3. Use the specified MCP tool

## CLI Commands (Direct)

When CLI is available, use these Obsidian CLI commands directly:

### File Operations
```bash
# Read file content
obsidian read path="2 - Areas/Daily Ops/2026-02-14.md"

# List files in folder
obsidian files folder="0 - Inbox/"

# Create new file
obsidian create path="3 - Resources/TIL/til-2026-02-14.md" content="# TIL..." silent

# Append to file
obsidian append path="note.md" content="\n## New Section" silent

# Search vault
obsidian search query="React hooks"
```

### Daily Notes
```bash
# Read today's daily note
obsidian daily:read

# Append to daily note
obsidian daily:append content="- New task" silent

# Prepend to daily note
obsidian daily:prepend content="# Morning Notes" silent
```

### Metadata & Properties
```bash
# Get file properties
obsidian properties path="note.md"

# Set property
obsidian property:set path="note.md" key="status" value="complete"
```

### CLI Flags
- `silent` - No output confirmation
- `overwrite` - Replace existing file
- `format=json|csv|md|text` - Output format

## MCP Tools Reference

When CLI unavailable, use these MCP tools:

| Operation | MCP Tool |
|-----------|----------|
| Read file | `mcp__mcp-obsidian__obsidian_get_file_contents` |
| List files | `mcp__mcp-obsidian__obsidian_list_files_in_dir` |
| Create/Append | `mcp__mcp-obsidian__obsidian_append_content` |
| Patch content | `mcp__mcp-obsidian__obsidian_patch_content` |
| Search | `mcp__mcp-obsidian__obsidian_simple_search` |
| Delete | `mcp__mcp-obsidian__obsidian_delete_file` |
| Daily note | `mcp__mcp-obsidian__obsidian_get_periodic_note` |
| Batch read | `mcp__mcp-obsidian__obsidian_batch_get_file_contents` |

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

1. **Batch operations** - Use parallel calls when checking multiple files
2. **Silent mode** - Use `silent` flag for non-interactive operations
3. **Error handling** - If CLI fails mid-operation, fall back to MCP
4. **Templates** - Always fetch and use templates when creating notes
5. **Confirmation** - Never delete without explicit user confirmation

## CLI Requirements

Obsidian CLI requires:
- Obsidian v1.12+ (early access)
- Catalyst license
- CLI enabled: Settings → General → Command line interface
- Obsidian must be running

If any requirement isn't met, CLI commands will fail and MCP fallback is needed.
