#!/usr/bin/env bash
# obsidian-utils.sh - Unified Obsidian operations with CLI-first, MCP fallback
#
# Usage: source this script and use the functions, OR call directly:
#   ./obsidian-utils.sh read "path/to/note.md"
#   ./obsidian-utils.sh append "path/to/note.md" "content"
#   ./obsidian-utils.sh list "folder/"
#   ./obsidian-utils.sh search "query"
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

    if command -v obsidian &>/dev/null; then
        # Try a simple command to verify CLI is working (Obsidian must be running)
        if obsidian vault &>/dev/null; then
            CLI_AVAILABLE="true"
            return 0
        fi
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
# Core Operations
# ============================================================================

# Read a file from the vault
# Usage: obsidian_read "path/to/note.md"
obsidian_read() {
    local path="$1"

    if obsidian_cli_available; then
        obsidian read path="$path" 2>/dev/null
    else
        print_mcp_fallback "read" "mcp__mcp-obsidian__obsidian_get_file_contents" "filepath=$path"
    fi
}

# List files in a directory
# Usage: obsidian_list "folder/" [format]
obsidian_list() {
    local folder="$1"
    local format="${2:-text}"

    if obsidian_cli_available; then
        obsidian files folder="$folder" format="$format" 2>/dev/null
    else
        print_mcp_fallback "list" "mcp__mcp-obsidian__obsidian_list_files_in_dir" "dirpath=$folder"
    fi
}

# Create a new file
# Usage: obsidian_create "path/to/note.md" "content" [overwrite]
obsidian_create() {
    local path="$1"
    local content="$2"
    local overwrite="${3:-false}"

    if obsidian_cli_available; then
        local flags=""
        [[ "$overwrite" == "true" ]] && flags="overwrite"
        obsidian create path="$path" content="$content" $flags silent 2>/dev/null
        echo "Created: $path"
    else
        print_mcp_fallback "create" "mcp__mcp-obsidian__obsidian_append_content" "filepath=$path" "content=<content>"
    fi
}

# Append content to a file
# Usage: obsidian_append "path/to/note.md" "content"
obsidian_append() {
    local path="$1"
    local content="$2"

    if obsidian_cli_available; then
        obsidian append path="$path" content="$content" silent 2>/dev/null
        echo "Appended to: $path"
    else
        print_mcp_fallback "append" "mcp__mcp-obsidian__obsidian_append_content" "filepath=$path" "content=<content>"
    fi
}

# Prepend content to a file
# Usage: obsidian_prepend "path/to/note.md" "content"
obsidian_prepend() {
    local path="$1"
    local content="$2"

    if obsidian_cli_available; then
        obsidian prepend path="$path" content="$content" silent 2>/dev/null
        echo "Prepended to: $path"
    else
        print_mcp_fallback "prepend" "mcp__mcp-obsidian__obsidian_patch_content" "filepath=$path" "operation=prepend" "content=<content>"
    fi
}

# Search the vault
# Usage: obsidian_search "query" [format]
obsidian_search() {
    local query="$1"
    local format="${2:-text}"

    if obsidian_cli_available; then
        obsidian search query="$query" format="$format" 2>/dev/null
    else
        print_mcp_fallback "search" "mcp__mcp-obsidian__obsidian_simple_search" "query=$query"
    fi
}

# Delete a file (with confirmation in output)
# Usage: obsidian_delete "path/to/note.md"
obsidian_delete() {
    local path="$1"

    if obsidian_cli_available; then
        obsidian delete path="$path" silent 2>/dev/null
        echo "Deleted: $path"
    else
        print_mcp_fallback "delete" "mcp__mcp-obsidian__obsidian_delete_file" "filepath=$path"
    fi
}

# Get daily note (today's)
# Usage: obsidian_daily [action] [content]
#   action: read, append, prepend
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
            *)
                echo "Unknown action: $action" >&2
                return 1
                ;;
        esac
    else
        print_mcp_fallback "daily:$action" "mcp__mcp-obsidian__obsidian_get_periodic_note" "period=daily"
    fi
}

# Get vault info
# Usage: obsidian_vault_info
obsidian_vault_info() {
    if obsidian_cli_available; then
        obsidian vault 2>/dev/null
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
# Main - Direct CLI invocation
# ============================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    command="${1:-status}"
    shift || true

    case "$command" in
        read)
            obsidian_read "$@"
            ;;
        list)
            obsidian_list "$@"
            ;;
        create)
            obsidian_create "$@"
            ;;
        append)
            obsidian_append "$@"
            ;;
        prepend)
            obsidian_prepend "$@"
            ;;
        search)
            obsidian_search "$@"
            ;;
        delete)
            obsidian_delete "$@"
            ;;
        daily)
            obsidian_daily "$@"
            ;;
        vault)
            obsidian_vault_info
            ;;
        status)
            obsidian_status
            ;;
        *)
            echo "Unknown command: $command" >&2
            echo "Usage: $0 {read|list|create|append|prepend|search|delete|daily|vault|status} [args...]"
            exit 1
            ;;
    esac
fi
