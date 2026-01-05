#!/usr/bin/env bash
# Claude Code History Analyzer
# Parses JSONL conversation files to extract usage patterns

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default paths
CLAUDE_DIR="${HOME}/.claude"
PROJECTS_DIR="${CLAUDE_DIR}/projects"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

# Parse arguments
SCOPE="all"
TARGET_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            SCOPE="file"
            TARGET_FILE="$2"
            shift 2
            ;;
        --current-project)
            SCOPE="current"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --file <path>      Analyze single JSONL file"
            echo "  --current-project  Analyze current project only"
            echo "  -h, --help         Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

# Check for jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required but not installed${NC}" >&2
    echo "Install with: brew install jq" >&2
    exit 1
fi

# Create temp directory for intermediate files
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Get auto-allowed tools from settings
get_auto_allowed_tools() {
    if [[ -f "$SETTINGS_FILE" ]]; then
        jq -r '.autoAllowedTools // [] | .[]' "$SETTINGS_FILE" 2>/dev/null || echo ""
    fi
}

# Find conversation files based on scope
find_conversation_files() {
    case "$SCOPE" in
        file)
            if [[ -f "$TARGET_FILE" ]]; then
                echo "$TARGET_FILE"
            else
                echo -e "${RED}Error: File not found: $TARGET_FILE${NC}" >&2
                exit 1
            fi
            ;;
        current)
            local current_hash
            current_hash=$(echo -n "$(pwd)" | shasum -a 256 | cut -c1-64)
            local project_dir="${PROJECTS_DIR}/${current_hash}"
            if [[ -d "$project_dir" ]]; then
                find "$project_dir" -name "*.jsonl" -type f 2>/dev/null
            else
                echo -e "${YELLOW}No Claude history found for current project${NC}" >&2
            fi
            ;;
        all)
            find "$PROJECTS_DIR" -name "*.jsonl" -type f 2>/dev/null
            ;;
    esac
}

# Extract tool usage from a single file
extract_tool_usage() {
    local file="$1"
    jq -r 'select(.type == "tool_use") | .name // empty' "$file" 2>/dev/null
}

# Extract model usage from a single file
extract_model_usage() {
    local file="$1"
    jq -r 'select(.model != null) | .model' "$file" 2>/dev/null
}

# Main analysis
echo -e "${BLUE}Claude Code History Analyzer${NC}" >&2
echo -e "${BLUE}=============================${NC}" >&2
echo "" >&2

# Collect all files
mapfile -t FILES < <(find_conversation_files)

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo -e "${YELLOW}No conversation files found${NC}" >&2
    echo '{"metadata":{"scope":"'"$SCOPE"'","conversations":0},"tool_usage":{},"model_usage":{},"auto_allowed_tools":[]}'
    exit 0
fi

echo -e "${GREEN}Found ${#FILES[@]} conversation file(s)${NC}" >&2

# Process files and aggregate data
TOOL_COUNTS="$TEMP_DIR/tools.txt"
MODEL_COUNTS="$TEMP_DIR/models.txt"
PROJECT_COUNTS="$TEMP_DIR/projects.txt"

touch "$TOOL_COUNTS" "$MODEL_COUNTS" "$PROJECT_COUNTS"

for file in "${FILES[@]}"; do
    # Extract project name from path
    project_name=$(echo "$file" | sed -E 's|.*/projects/([^/]+)/.*|\1|')
    echo "$project_name" >> "$PROJECT_COUNTS"

    # Process file line by line to avoid memory issues
    while IFS= read -r line; do
        # Extract tool name if tool_use
        tool=$(echo "$line" | jq -r 'select(.type == "tool_use") | .name // empty' 2>/dev/null)
        if [[ -n "$tool" ]]; then
            echo "$tool" >> "$TOOL_COUNTS"
        fi

        # Extract model if present
        model=$(echo "$line" | jq -r 'select(.model != null) | .model // empty' 2>/dev/null)
        if [[ -n "$model" ]]; then
            echo "$model" >> "$MODEL_COUNTS"
        fi
    done < "$file"
done

# Aggregate counts
tool_usage=$(sort "$TOOL_COUNTS" | uniq -c | sort -rn | head -20 | awk '{print "{\"tool\":\""$2"\",\"count\":"$1"}"}' | jq -s 'map({(.tool): .count}) | add // {}')
model_usage=$(sort "$MODEL_COUNTS" | uniq -c | sort -rn | awk '{print "{\"model\":\""$2"\",\"count\":"$1"}"}' | jq -s 'map({(.model): .count}) | add // {}')
project_activity=$(sort "$PROJECT_COUNTS" | uniq -c | sort -rn | head -10 | awk '{print "{\"project\":\""$2"\",\"conversations\":"$1"}"}' | jq -s '.')

# Get auto-allowed tools
auto_allowed=$(get_auto_allowed_tools | jq -R -s 'split("\n") | map(select(length > 0))')

# Build final JSON output
jq -n \
    --arg scope "$SCOPE" \
    --argjson conversations "${#FILES[@]}" \
    --argjson tool_usage "$tool_usage" \
    --argjson model_usage "$model_usage" \
    --argjson project_activity "$project_activity" \
    --argjson auto_allowed "$auto_allowed" \
    --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    '{
        metadata: {
            timestamp: $timestamp,
            scope: $scope,
            conversations: $conversations
        },
        tool_usage: $tool_usage,
        model_usage: $model_usage,
        project_activity: $project_activity,
        auto_allowed_tools: $auto_allowed
    }'

echo "" >&2
echo -e "${GREEN}Analysis complete${NC}" >&2
