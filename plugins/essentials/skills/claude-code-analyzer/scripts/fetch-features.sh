#!/usr/bin/env bash
# Claude Code Feature Reference
# Displays Claude Code capabilities with optional doc fetching

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}Claude Code Features${NC}"
echo -e "${BLUE}===================${NC}"
echo ""

# Embedded feature list (always available)
show_features() {
    echo -e "${GREEN}Core Capabilities:${NC}"
    echo ""

    echo -e "${CYAN}Extensibility:${NC}"
    echo "  - Agents: Custom AI assistants for specific tasks (.claude/agents/)"
    echo "  - Skills: Bundled workflows with resources (.claude/skills/)"
    echo "  - Slash Commands: Quick shortcuts for operations (.claude/commands/)"
    echo "  - CLAUDE.md: Project-specific context and instructions"
    echo ""

    echo -e "${CYAN}Code Operations:${NC}"
    echo "  - Multi-file editing with intelligent context"
    echo "  - Code generation from natural language"
    echo "  - Refactoring with pattern preservation"
    echo "  - Test generation and modification"
    echo "  - Documentation generation"
    echo ""

    echo -e "${CYAN}Codebase Understanding:${NC}"
    echo "  - Semantic code search (function definitions, usages)"
    echo "  - Project structure analysis"
    echo "  - Dependency graph awareness"
    echo "  - Git history integration"
    echo ""

    echo -e "${CYAN}Terminal & System:${NC}"
    echo "  - Command execution with sandboxing"
    echo "  - Background task management"
    echo "  - MCP server integration"
    echo "  - Web search and fetching"
    echo ""

    echo -e "${CYAN}Workflow Features:${NC}"
    echo "  - Plan mode for complex tasks"
    echo "  - Todo tracking (TodoWrite)"
    echo "  - Context summarization"
    echo "  - Session persistence"
    echo ""
}

# Documentation URLs for reference
show_docs() {
    echo -e "${GREEN}Documentation Links:${NC}"
    echo ""
    echo "  Agents:        https://docs.claude.ai/en/docs/claude-code/sub-agents"
    echo "  Skills:        https://docs.claude.ai/en/docs/agents-and-tools/agent-skills"
    echo "  Commands:      https://docs.claude.ai/en/docs/claude-code/slash-commands"
    echo "  CLAUDE.md:     https://anthropic.com/engineering/claude-code-best-practices"
    echo "  MCP Servers:   https://docs.claude.ai/en/docs/claude-code/mcp"
    echo ""
}

# Check for --json flag
if [[ "${1:-}" == "--json" ]]; then
    # JSON output for programmatic use
    cat << 'EOF'
{
  "extensibility": {
    "agents": "Custom AI assistants in .claude/agents/",
    "skills": "Bundled workflows in .claude/skills/",
    "commands": "Slash commands in .claude/commands/",
    "claude_md": "Project context in CLAUDE.md"
  },
  "code_operations": [
    "Multi-file editing",
    "Code generation",
    "Refactoring",
    "Test generation",
    "Documentation generation"
  ],
  "codebase_features": [
    "Semantic code search",
    "Project structure analysis",
    "Dependency awareness",
    "Git integration"
  ],
  "system_features": [
    "Command execution",
    "Background tasks",
    "MCP integration",
    "Web search"
  ],
  "workflow_features": [
    "Plan mode",
    "Todo tracking",
    "Context summarization",
    "Session persistence"
  ],
  "documentation_urls": {
    "agents": "https://docs.claude.ai/en/docs/claude-code/sub-agents",
    "skills": "https://docs.claude.ai/en/docs/agents-and-tools/agent-skills",
    "commands": "https://docs.claude.ai/en/docs/claude-code/slash-commands",
    "claude_md": "https://anthropic.com/engineering/claude-code-best-practices",
    "mcp": "https://docs.claude.ai/en/docs/claude-code/mcp"
  }
}
EOF
else
    show_features
    show_docs
fi
