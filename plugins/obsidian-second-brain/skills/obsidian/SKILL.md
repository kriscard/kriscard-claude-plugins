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

CLI-first approach to all vault operations. Always use `obsidian` commands directly.
If commands fail, tell the user: "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Quick Reference

| Operation | CLI Command |
|-----------|------------|
| Read file | `obsidian read path="..."` |
| Create file | `obsidian create path="..." content="..." silent` |
| Append | `obsidian append path="..." content="..." silent` |
| Search | `obsidian search query="..." format=json` |
| List files | `obsidian files folder="..." format=json` |
| Daily note | `obsidian daily:read` |

## File Targeting

| Parameter | Behavior | Example |
|-----------|----------|---------|
| `file=<name>` | Wikilink-style resolution (no path/ext needed) | `file=Recipe` finds `Recipes/Recipe.md` |
| `path=<path>` | Exact path from vault root | `path="3 - Resources/TIL/til-2026-02-16.md"` |

## Vault Structure

Default vault: `/Users/kriscard/obsidian-vault-kriscard`

Key paths:
- `0 - Inbox/` - Incoming notes
- `1 - Projects/` - Active projects
- `2 - Areas/` - Ongoing responsibilities
- `3 - Resources/` - Reference material
- `4 - Archives/` - Completed/inactive
- `Templates/` - Note templates

## Gotchas

- Always use `silent` flag for non-interactive operations — without it Obsidian opens the file and steals focus
- Paths with spaces need quoting: `path="3 - Resources/TIL/note.md"`
- `file=` resolution is wikilink-style (name only, no ext) — use `path=` when you know the exact path
- CLI requires Obsidian to be running with CLI enabled — if commands fail, tell user to check Settings > General > CLI
- `delete` sends to trash by default — add `permanent` flag only when user explicitly confirms permanent deletion
- `format=json` is essential when parsing output programmatically — text format is for display only

## Best Practices

1. **Use `silent` flag** - Always add `silent` for non-interactive operations
2. **Use `format=json`** - For parsing output programmatically
3. **Prefer `file=`** - When you know the name but not the path
4. **Use `path=`** - When you know the exact path
5. **Batch operations** - Use parallel calls when checking multiple files
6. **Templates** - Use `template=` parameter when creating from templates
7. **Confirmation** - Never delete without explicit user confirmation

## CLI Requirements

Obsidian CLI requires:
- Obsidian with CLI enabled: Settings > General > Command line interface
- Obsidian must be running

If CLI commands fail, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Reference Files

| Reference | Contents |
|-----------|----------|
| [cli-reference.md](references/cli-reference.md) | Full CLI commands: file ops, daily notes, tasks, tags, links, properties, templates, outline, vault info, flags, output formats |
| [obsidian-utils.md](references/obsidian-utils.md) | obsidian-utils.sh wrapper script commands |
