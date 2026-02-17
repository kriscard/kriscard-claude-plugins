#!/usr/bin/env bash
# obsidian-utils.sh - Unified Obsidian operations with CLI-first, MCP fallback
#
# Usage: source this script and use the functions, OR call directly:
#   ./obsidian-utils.sh read "path/to/note.md"
#   ./obsidian-utils.sh append "path/to/note.md" "content"
#   ./obsidian-utils.sh list "folder/"
#   ./obsidian-utils.sh search "query"
#
# New commands (from CLI docs):
#   ./obsidian-utils.sh tasks [all|daily|done|todo]
#   ./obsidian-utils.sh tags [all] [counts]
#   ./obsidian-utils.sh backlinks "file"
#   ./obsidian-utils.sh links "file"
#   ./obsidian-utils.sh unresolved
#   ./obsidian-utils.sh orphans
#   ./obsidian-utils.sh outline "file"
#   ./obsidian-utils.sh properties "file"
#   ./obsidian-utils.sh property-set "file" "name" "value"
#   ./obsidian-utils.sh property-read "file" "name"
#   ./obsidian-utils.sh templates
#   ./obsidian-utils.sh template-read "name"
#
# Environment:
#   OBSIDIAN_VAULT_PATH - Required for MCP fallback instructions
#   OBSIDIAN_PREFER_MCP - Set to "true" to skip CLI detection

set -euo pipefail

# Configuration
OBSIDIAN_VAULT_PATH="${OBSIDIAN_VAULT_PATH:-/Users/kriscard/obsidian-vault-kriscard}"
CLI_AVAILABLE=""

# ============================================================================
# Detection Functions
# ============================================================================

# Check if Obsidian CLI is available and working
obsidian_cli_available() {
    if [[ -n "$CLI_AVAILABLE" ]]; then
        [[ "$CLI_AVAILABLE" == "true" ]]
        return
    fi

    if [[ "${OBSIDIAN_PREFER_MCP:-}" == "true" ]]; then
        CLI_AVAILABLE="false"
        return 1
    fi

    # Try a simple command to verify CLI is working (Obsidian must be running)
    if obsidian vault &>/dev/null; then
        CLI_AVAILABLE="true"
        return 0
    fi

    CLI_AVAILABLE="false"
    return 1
}

# Print MCP fallback instruction
print_mcp_fallback() {
    local operation="$1"
    local mcp_tool="$2"
    shift 2
    local params=("$@")

    echo "CLI_UNAVAILABLE"
    echo "MCP_TOOL: $mcp_tool"
    echo "OPERATION: $operation"
    for param in "${params[@]}"; do
        echo "PARAM: $param"
    done
    echo "---"
    echo "Obsidian CLI not available. Use MCP tool '$mcp_tool' instead."
    echo "Confirm with user before using MCP tools."
}

# ============================================================================
# Core File Operations
# ============================================================================

# Read a file from the vault
# Usage: obsidian_read "path/to/note.md"
# Note: Use file= for wikilink-style resolution, path= for exact path
obsidian_read() {
    local path="$1"

    if obsidian_cli_available; then
        obsidian read path="$path" 2>/dev/null
    else
        print_mcp_fallback "read" "mcp__mcp-obsidian__obsidian_get_file_contents" "filepath=$path"
    fi
}

# Read a file by name (wikilink-style resolution)
# Usage: obsidian_read_file "Recipe" (finds Recipe.md anywhere)
obsidian_read_file() {
    local file="$1"

    if obsidian_cli_available; then
        obsidian read file="$file" 2>/dev/null
    else
        print_mcp_fallback "read" "mcp__mcp-obsidian__obsidian_simple_search" "query=$file"
    fi
}

# List files in a directory
# Usage: obsidian_list "folder/" [format: text|json]
obsidian_list() {
    local folder="$1"
    local format="${2:-json}"

    if obsidian_cli_available; then
        obsidian files folder="$folder" format="$format" 2>/dev/null
    else
        print_mcp_fallback "list" "mcp__mcp-obsidian__obsidian_list_files_in_dir" "dirpath=$folder"
    fi
}

# Create a new file
# Usage: obsidian_create "path/to/note.md" "content" [template] [overwrite:true|false]
obsidian_create() {
    local path="$1"
    local content="${2:-}"
    local template="${3:-}"
    local overwrite="${4:-false}"

    if obsidian_cli_available; then
        local cmd="obsidian create path=\"$path\" silent"
        [[ -n "$content" ]] && cmd="$cmd content=\"$content\""
        [[ -n "$template" ]] && cmd="$cmd template=\"$template\""
        [[ "$overwrite" == "true" ]] && cmd="$cmd overwrite"
        eval "$cmd" 2>/dev/null
        echo "Created: $path"
    else
        print_mcp_fallback "create" "mcp__mcp-obsidian__obsidian_append_content" "filepath=$path" "content=<content>"
    fi
}

# Create a file from template
# Usage: obsidian_create_from_template "path/to/note.md" "TemplateName"
obsidian_create_from_template() {
    local path="$1"
    local template="$2"

    if obsidian_cli_available; then
        obsidian create path="$path" template="$template" silent 2>/dev/null
        echo "Created from template: $path"
    else
        print_mcp_fallback "create" "mcp__mcp-obsidian__obsidian_append_content" "filepath=$path"
    fi
}

# Append content to a file
# Usage: obsidian_append "path/to/note.md" "content" [inline:true|false]
obsidian_append() {
    local path="$1"
    local content="$2"
    local inline="${3:-false}"

    if obsidian_cli_available; then
        local cmd="obsidian append path=\"$path\" content=\"$content\" silent"
        [[ "$inline" == "true" ]] && cmd="$cmd inline"
        eval "$cmd" 2>/dev/null
        echo "Appended to: $path"
    else
        print_mcp_fallback "append" "mcp__mcp-obsidian__obsidian_append_content" "filepath=$path" "content=<content>"
    fi
}

# Prepend content to a file (after frontmatter)
# Usage: obsidian_prepend "path/to/note.md" "content" [inline:true|false]
obsidian_prepend() {
    local path="$1"
    local content="$2"
    local inline="${3:-false}"

    if obsidian_cli_available; then
        local cmd="obsidian prepend path=\"$path\" content=\"$content\" silent"
        [[ "$inline" == "true" ]] && cmd="$cmd inline"
        eval "$cmd" 2>/dev/null
        echo "Prepended to: $path"
    else
        print_mcp_fallback "prepend" "mcp__mcp-obsidian__obsidian_patch_content" "filepath=$path" "operation=prepend" "content=<content>"
    fi
}

# Delete a file
# Usage: obsidian_delete "path/to/note.md" [permanent:true|false]
obsidian_delete() {
    local path="$1"
    local permanent="${2:-false}"

    if obsidian_cli_available; then
        local cmd="obsidian delete path=\"$path\""
        [[ "$permanent" == "true" ]] && cmd="$cmd permanent"
        eval "$cmd" 2>/dev/null
        echo "Deleted: $path"
    else
        print_mcp_fallback "delete" "mcp__mcp-obsidian__obsidian_delete_file" "filepath=$path"
    fi
}

# Move/rename a file
# Usage: obsidian_move "path/to/note.md" "new/path/or/name.md"
obsidian_move() {
    local path="$1"
    local to="$2"

    if obsidian_cli_available; then
        obsidian move path="$path" to="$to" 2>/dev/null
        echo "Moved: $path -> $to"
    else
        echo "CLI_UNAVAILABLE"
        echo "Move not supported via MCP. Use CLI or manual move."
    fi
}

# ============================================================================
# Search Operations
# ============================================================================

# Search the vault
# Usage: obsidian_search "query" [format: text|json] [limit]
obsidian_search() {
    local query="$1"
    local format="${2:-json}"
    local limit="${3:-}"

    if obsidian_cli_available; then
        local cmd="obsidian search query=\"$query\" format=\"$format\""
        [[ -n "$limit" ]] && cmd="$cmd limit=$limit"
        eval "$cmd" 2>/dev/null
    else
        print_mcp_fallback "search" "mcp__mcp-obsidian__obsidian_simple_search" "query=$query"
    fi
}

# ============================================================================
# Daily Notes
# ============================================================================

# Get daily note (today's)
# Usage: obsidian_daily [action: read|append|prepend] [content]
obsidian_daily() {
    local action="${1:-read}"
    local content="${2:-}"

    if obsidian_cli_available; then
        case "$action" in
            read)
                obsidian daily:read 2>/dev/null
                ;;
            append)
                obsidian daily:append content="$content" silent 2>/dev/null
                echo "Appended to daily note"
                ;;
            prepend)
                obsidian daily:prepend content="$content" silent 2>/dev/null
                echo "Prepended to daily note"
                ;;
            open)
                obsidian daily silent 2>/dev/null
                ;;
            *)
                echo "Unknown action: $action" >&2
                return 1
                ;;
        esac
    else
        print_mcp_fallback "daily:$action" "mcp__mcp-obsidian__obsidian_get_periodic_note" "period=daily"
    fi
}

# ============================================================================
# Tasks
# ============================================================================

# List tasks
# Usage: obsidian_tasks [filter: all|daily|done|todo] [verbose:true|false]
obsidian_tasks() {
    local filter="${1:-all}"
    local verbose="${2:-false}"

    if obsidian_cli_available; then
        local cmd="obsidian tasks"
        case "$filter" in
            all) cmd="$cmd all" ;;
            daily) cmd="$cmd daily" ;;
            done) cmd="$cmd done" ;;
            todo) cmd="$cmd todo" ;;
        esac
        [[ "$verbose" == "true" ]] && cmd="$cmd verbose"
        eval "$cmd" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Tasks command not available via MCP."
    fi
}

# Toggle a task
# Usage: obsidian_task_toggle "path/to/note.md" "line_number"
obsidian_task_toggle() {
    local path="$1"
    local line="$2"

    if obsidian_cli_available; then
        obsidian task path="$path" line="$line" toggle 2>/dev/null
        echo "Toggled task at $path:$line"
    else
        echo "CLI_UNAVAILABLE"
        echo "Task toggle not available via MCP."
    fi
}

# ============================================================================
# Tags
# ============================================================================

# List tags
# Usage: obsidian_tags [all:true|false] [counts:true|false]
obsidian_tags() {
    local all="${1:-true}"
    local counts="${2:-true}"

    if obsidian_cli_available; then
        local cmd="obsidian tags"
        [[ "$all" == "true" ]] && cmd="$cmd all"
        [[ "$counts" == "true" ]] && cmd="$cmd counts"
        eval "$cmd" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Tags command not available via MCP. Use search instead."
    fi
}

# Get tag info
# Usage: obsidian_tag "tagname" [verbose:true|false]
obsidian_tag() {
    local name="$1"
    local verbose="${2:-true}"

    if obsidian_cli_available; then
        local cmd="obsidian tag name=\"$name\""
        [[ "$verbose" == "true" ]] && cmd="$cmd verbose"
        eval "$cmd" 2>/dev/null
    else
        print_mcp_fallback "tag" "mcp__mcp-obsidian__obsidian_simple_search" "query=#$name"
    fi
}

# ============================================================================
# Links
# ============================================================================

# List backlinks to a file
# Usage: obsidian_backlinks "path/to/note.md" [counts:true|false]
obsidian_backlinks() {
    local path="$1"
    local counts="${2:-true}"

    if obsidian_cli_available; then
        local cmd="obsidian backlinks path=\"$path\""
        [[ "$counts" == "true" ]] && cmd="$cmd counts"
        eval "$cmd" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Backlinks not available via MCP."
    fi
}

# List outgoing links from a file
# Usage: obsidian_links "path/to/note.md"
obsidian_links() {
    local path="$1"

    if obsidian_cli_available; then
        obsidian links path="$path" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Links not available via MCP."
    fi
}

# List unresolved (broken) links
# Usage: obsidian_unresolved [verbose:true|false]
obsidian_unresolved() {
    local verbose="${1:-true}"

    if obsidian_cli_available; then
        local cmd="obsidian unresolved"
        [[ "$verbose" == "true" ]] && cmd="$cmd verbose counts"
        eval "$cmd" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Unresolved links not available via MCP."
    fi
}

# List orphan files (no incoming links)
# Usage: obsidian_orphans
obsidian_orphans() {
    if obsidian_cli_available; then
        obsidian orphans 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Orphans not available via MCP."
    fi
}

# List dead-end files (no outgoing links)
# Usage: obsidian_deadends
obsidian_deadends() {
    if obsidian_cli_available; then
        obsidian deadends 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Dead-ends not available via MCP."
    fi
}

# ============================================================================
# Outline & Structure
# ============================================================================

# Show file outline (headings)
# Usage: obsidian_outline "path/to/note.md" [format: tree|md]
obsidian_outline() {
    local path="$1"
    local format="${2:-tree}"

    if obsidian_cli_available; then
        obsidian outline path="$path" format="$format" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Outline not available via MCP."
    fi
}

# ============================================================================
# Properties
# ============================================================================

# List properties of a file
# Usage: obsidian_properties "path/to/note.md" [format: yaml|tsv]
obsidian_properties() {
    local path="$1"
    local format="${2:-yaml}"

    if obsidian_cli_available; then
        obsidian properties path="$path" format="$format" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Properties not available via MCP. Read file and parse frontmatter."
    fi
}

# Set a property on a file
# Usage: obsidian_property_set "path/to/note.md" "name" "value" [type]
obsidian_property_set() {
    local path="$1"
    local name="$2"
    local value="$3"
    local type="${4:-text}"

    if obsidian_cli_available; then
        obsidian property:set path="$path" name="$name" value="$value" type="$type" 2>/dev/null
        echo "Set property $name=$value on $path"
    else
        print_mcp_fallback "property:set" "mcp__mcp-obsidian__obsidian_patch_content" "filepath=$path" "target_type=frontmatter" "target=$name" "content=$value"
    fi
}

# Read a property from a file
# Usage: obsidian_property_read "path/to/note.md" "name"
obsidian_property_read() {
    local path="$1"
    local name="$2"

    if obsidian_cli_available; then
        obsidian property:read path="$path" name="$name" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Property read not available via MCP. Read file and parse frontmatter."
    fi
}

# Remove a property from a file
# Usage: obsidian_property_remove "path/to/note.md" "name"
obsidian_property_remove() {
    local path="$1"
    local name="$2"

    if obsidian_cli_available; then
        obsidian property:remove path="$path" name="$name" 2>/dev/null
        echo "Removed property $name from $path"
    else
        echo "CLI_UNAVAILABLE"
        echo "Property remove not available via MCP."
    fi
}

# ============================================================================
# Templates
# ============================================================================

# List templates
# Usage: obsidian_templates
obsidian_templates() {
    if obsidian_cli_available; then
        obsidian templates 2>/dev/null
    else
        print_mcp_fallback "templates" "mcp__mcp-obsidian__obsidian_list_files_in_dir" "dirpath=Templates/"
    fi
}

# Read template content
# Usage: obsidian_template_read "TemplateName" [resolve:true|false]
obsidian_template_read() {
    local name="$1"
    local resolve="${2:-true}"

    if obsidian_cli_available; then
        local cmd="obsidian template:read name=\"$name\""
        [[ "$resolve" == "true" ]] && cmd="$cmd resolve"
        eval "$cmd" 2>/dev/null
    else
        print_mcp_fallback "template:read" "mcp__mcp-obsidian__obsidian_get_file_contents" "filepath=Templates/$name.md"
    fi
}

# ============================================================================
# Vault Info
# ============================================================================

# Get vault info
# Usage: obsidian_vault_info [info: name|path|files|folders|size]
obsidian_vault_info() {
    local info="${1:-}"

    if obsidian_cli_available; then
        if [[ -n "$info" ]]; then
            obsidian vault info="$info" 2>/dev/null
        else
            obsidian vault 2>/dev/null
        fi
    else
        echo "CLI_UNAVAILABLE"
        echo "Vault path: $OBSIDIAN_VAULT_PATH"
        echo "Use MCP tools with this vault path."
    fi
}

# Check CLI status
# Usage: obsidian_status
obsidian_status() {
    if obsidian_cli_available; then
        echo "CLI_AVAILABLE"
        echo "Obsidian CLI is available and working."
        obsidian vault 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Obsidian CLI not available."
        echo "Possible reasons:"
        echo "  - Obsidian not running"
        echo "  - CLI not enabled (Settings > General > Command line interface)"
        echo "  - Obsidian version < 1.12"
        echo ""
        echo "Fallback: Use MCP tools (mcp__mcp-obsidian__*)"
        echo "Default vault: $OBSIDIAN_VAULT_PATH"
    fi
}

# ============================================================================
# Aliases
# ============================================================================

# Get all aliases in vault
# Usage: obsidian_aliases [all:true|false]
obsidian_aliases() {
    local all="${1:-true}"

    if obsidian_cli_available; then
        local cmd="obsidian aliases"
        [[ "$all" == "true" ]] && cmd="$cmd all verbose"
        eval "$cmd" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Aliases not available via MCP."
    fi
}

# ============================================================================
# Word Count
# ============================================================================

# Get word count for a file
# Usage: obsidian_wordcount "path/to/note.md"
obsidian_wordcount() {
    local path="$1"

    if obsidian_cli_available; then
        obsidian wordcount path="$path" 2>/dev/null
    else
        echo "CLI_UNAVAILABLE"
        echo "Wordcount not available via MCP."
    fi
}

# ============================================================================
# Main - Direct CLI invocation
# ============================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    command="${1:-status}"
    shift || true

    case "$command" in
        # Core file operations
        read)
            obsidian_read "$@"
            ;;
        read-file)
            obsidian_read_file "$@"
            ;;
        list)
            obsidian_list "$@"
            ;;
        create)
            obsidian_create "$@"
            ;;
        create-template)
            obsidian_create_from_template "$@"
            ;;
        append)
            obsidian_append "$@"
            ;;
        prepend)
            obsidian_prepend "$@"
            ;;
        delete)
            obsidian_delete "$@"
            ;;
        move)
            obsidian_move "$@"
            ;;
        search)
            obsidian_search "$@"
            ;;
        # Daily notes
        daily)
            obsidian_daily "$@"
            ;;
        # Tasks
        tasks)
            obsidian_tasks "$@"
            ;;
        task-toggle)
            obsidian_task_toggle "$@"
            ;;
        # Tags
        tags)
            obsidian_tags "$@"
            ;;
        tag)
            obsidian_tag "$@"
            ;;
        # Links
        backlinks)
            obsidian_backlinks "$@"
            ;;
        links)
            obsidian_links "$@"
            ;;
        unresolved)
            obsidian_unresolved "$@"
            ;;
        orphans)
            obsidian_orphans
            ;;
        deadends)
            obsidian_deadends
            ;;
        # Structure
        outline)
            obsidian_outline "$@"
            ;;
        # Properties
        properties)
            obsidian_properties "$@"
            ;;
        property-set)
            obsidian_property_set "$@"
            ;;
        property-read)
            obsidian_property_read "$@"
            ;;
        property-remove)
            obsidian_property_remove "$@"
            ;;
        # Templates
        templates)
            obsidian_templates
            ;;
        template-read)
            obsidian_template_read "$@"
            ;;
        # Vault
        vault)
            obsidian_vault_info "$@"
            ;;
        status)
            obsidian_status
            ;;
        # Misc
        aliases)
            obsidian_aliases "$@"
            ;;
        wordcount)
            obsidian_wordcount "$@"
            ;;
        *)
            echo "Unknown command: $command" >&2
            echo ""
            echo "Usage: $0 <command> [args...]"
            echo ""
            echo "File Operations:"
            echo "  read <path>              Read file content"
            echo "  read-file <name>         Read file by name (wikilink resolution)"
            echo "  list <folder> [format]   List files in folder"
            echo "  create <path> [content] [template] [overwrite]"
            echo "  create-template <path> <template>"
            echo "  append <path> <content> [inline]"
            echo "  prepend <path> <content> [inline]"
            echo "  delete <path> [permanent]"
            echo "  move <path> <to>"
            echo "  search <query> [format] [limit]"
            echo ""
            echo "Daily Notes:"
            echo "  daily [read|append|prepend|open] [content]"
            echo ""
            echo "Tasks:"
            echo "  tasks [all|daily|done|todo] [verbose]"
            echo "  task-toggle <path> <line>"
            echo ""
            echo "Tags:"
            echo "  tags [all] [counts]"
            echo "  tag <name> [verbose]"
            echo ""
            echo "Links:"
            echo "  backlinks <path> [counts]"
            echo "  links <path>"
            echo "  unresolved [verbose]"
            echo "  orphans"
            echo "  deadends"
            echo ""
            echo "Structure:"
            echo "  outline <path> [format: tree|md]"
            echo ""
            echo "Properties:"
            echo "  properties <path> [format: yaml|tsv]"
            echo "  property-set <path> <name> <value> [type]"
            echo "  property-read <path> <name>"
            echo "  property-remove <path> <name>"
            echo ""
            echo "Templates:"
            echo "  templates"
            echo "  template-read <name> [resolve]"
            echo ""
            echo "Vault:"
            echo "  vault [info: name|path|files|folders|size]"
            echo "  status"
            echo ""
            echo "Misc:"
            echo "  aliases [all]"
            echo "  wordcount <path>"
            exit 1
            ;;
    esac
fi
