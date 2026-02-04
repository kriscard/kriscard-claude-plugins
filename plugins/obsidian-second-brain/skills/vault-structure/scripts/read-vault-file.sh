#!/bin/bash
# Helper script to read vault configuration files using Obsidian MCP

set -e

VAULT_PATH="${VAULT_PATH:-/Users/kriscard/obsidian-vault-kriscard}"

if [ -z "$1" ]; then
    echo "Usage: $0 <filename>"
    echo "Example: $0 'Tag Taxonomy.md'"
    echo ""
    echo "Common files:"
    echo "  - Tag Taxonomy.md"
    echo "  - Tag MOC.md"
    echo "  - PARA Method Implementation.md"
    echo "  - Vault Organization Guide.md"
    echo "  - Vault Maintenance Guide.md"
    exit 1
fi

FILENAME="$1"

# Try common locations
LOCATIONS=(
    "3 - Resources/Obsidian org/$FILENAME"
    "MOCs/$FILENAME"
    "$FILENAME"
)

echo "Searching for: $FILENAME"
echo "Vault path: $VAULT_PATH"
echo ""

for location in "${LOCATIONS[@]}"; do
    full_path="$VAULT_PATH/$location"
    if [ -f "$full_path" ]; then
        echo "Found at: $location"
        echo "---"
        cat "$full_path"
        exit 0
    fi
done

echo "File not found. Tried locations:"
for location in "${LOCATIONS[@]}"; do
    echo "  - $location"
done
exit 1
