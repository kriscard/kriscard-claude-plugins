#!/usr/bin/env bash
# GitHub Claude Code Discovery
# Search GitHub for community Claude Code resources

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Search type (default: all)
SEARCH_TYPE="${1:-all}"
QUERY="${2:-}"

# URL encode function
urlencode() {
    local string="$1"
    python3 -c "import urllib.parse; print(urllib.parse.quote('$string'))"
}

# Check for gh CLI
HAS_GH="false"
if command -v gh &> /dev/null; then
    # Check if authenticated
    if gh auth status &> /dev/null; then
        HAS_GH="true"
    fi
fi

# Build search URL for GitHub web
get_search_url() {
    local path="$1"
    local query="$2"
    local base_query="path:${path}"

    if [[ -n "$query" ]]; then
        base_query="${base_query} ${query}"
    fi

    local encoded
    encoded=$(urlencode "$base_query")
    echo "https://github.com/search?q=${encoded}&type=code"
}

# Search with gh CLI
search_with_gh() {
    local path="$1"
    local query="$2"
    local search_query="path:${path}"

    if [[ -n "$query" ]]; then
        search_query="${search_query} ${query}"
    fi

    # Search and return results
    gh api search/code \
        -X GET \
        -F "q=${search_query}" \
        -F "per_page=20" \
        --jq '.items | map({
            repository: .repository.full_name,
            path: .path,
            url: .html_url
        })' 2>/dev/null || echo "[]"
}

# Display usage
show_usage() {
    echo "Usage: $0 [TYPE] [QUERY]"
    echo ""
    echo "Types:"
    echo "  all       Search all Claude Code resources (default)"
    echo "  agents    Search for agents (.claude/agents)"
    echo "  skills    Search for skills (.claude/skills)"
    echo "  commands  Search for slash commands (.claude/commands)"
    echo "  claude-md Search for CLAUDE.md examples"
    echo ""
    echo "Query: Optional search term to filter results"
    echo ""
    echo "Examples:"
    echo "  $0 all typescript"
    echo "  $0 skills react"
    echo "  $0 agents"
}

# Handle help
if [[ "$SEARCH_TYPE" == "-h" ]] || [[ "$SEARCH_TYPE" == "--help" ]]; then
    show_usage
    exit 0
fi

echo -e "${BLUE}GitHub Claude Code Discovery${NC}" >&2
echo -e "${BLUE}============================${NC}" >&2
echo "" >&2

if [[ "$HAS_GH" == "false" ]]; then
    echo -e "${YELLOW}Note: gh CLI not installed or not authenticated${NC}" >&2
    echo -e "${YELLOW}Providing web search URLs instead${NC}" >&2
    echo "" >&2
fi

# Define search paths
declare -A SEARCH_PATHS
SEARCH_PATHS[agents]=".claude/agents"
SEARCH_PATHS[skills]=".claude/skills"
SEARCH_PATHS[commands]=".claude/commands"
SEARCH_PATHS[claude-md]="CLAUDE.md"

# Determine which paths to search
PATHS_TO_SEARCH=()
case "$SEARCH_TYPE" in
    all)
        PATHS_TO_SEARCH=("agents" "skills" "commands" "claude-md")
        ;;
    agents|skills|commands|claude-md)
        PATHS_TO_SEARCH=("$SEARCH_TYPE")
        ;;
    *)
        echo -e "${RED}Unknown search type: $SEARCH_TYPE${NC}" >&2
        show_usage
        exit 1
        ;;
esac

# Collect results
results_json="{"
first_type=true

for type in "${PATHS_TO_SEARCH[@]}"; do
    path="${SEARCH_PATHS[$type]}"
    echo -e "${GREEN}Searching for ${type}...${NC}" >&2

    if [[ "$first_type" == "true" ]]; then
        first_type=false
    else
        results_json+=","
    fi

    if [[ "$HAS_GH" == "true" ]]; then
        # Use gh CLI for actual search
        type_results=$(search_with_gh "$path" "$QUERY")
        results_json+="\"${type}\":{\"results\":${type_results},\"search_url\":\"$(get_search_url "$path" "$QUERY")\"}"
    else
        # Provide web URLs only
        results_json+="\"${type}\":{\"results\":[],\"search_url\":\"$(get_search_url "$path" "$QUERY")\"}"
    fi
done

results_json+="}"

# Build final output
jq -n \
    --arg search_type "$SEARCH_TYPE" \
    --arg query "$QUERY" \
    --arg has_gh "$HAS_GH" \
    --argjson results "$results_json" \
    --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    '{
        metadata: {
            timestamp: $timestamp,
            search_type: $search_type,
            query: $query,
            gh_cli_available: ($has_gh == "true")
        },
        results: $results
    }'

echo "" >&2
echo -e "${GREEN}Discovery complete${NC}" >&2

if [[ "$HAS_GH" == "false" ]]; then
    echo "" >&2
    echo -e "${YELLOW}Tip: Install and authenticate gh CLI for better results:${NC}" >&2
    echo -e "  brew install gh && gh auth login" >&2
fi
