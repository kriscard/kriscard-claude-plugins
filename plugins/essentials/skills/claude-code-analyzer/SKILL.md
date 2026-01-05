---
name: claude-code-analyzer
description: Analyze Claude Code usage patterns, project structure, and discover community resources for workflow optimization
tools: Read, Glob, Grep, Bash
model: opus
---

# Claude Code Analyzer

Optimize your Claude Code workflow by analyzing usage patterns, detecting project structure, and discovering community resources.

## Capabilities

| Feature           | Script                 | Purpose                                      |
| ----------------- | ---------------------- | -------------------------------------------- |
| Usage Analysis    | `analyze.sh`           | Extract tool/model usage from history        |
| Project Detection | `analyze-claude-md.sh` | Detect stack, suggest CLAUDE.md improvements |
| Feature Reference | `fetch-features.sh`    | List Claude Code capabilities                |
| GitHub Discovery  | `github-discovery.sh`  | Find community skills/agents/commands        |

## Workflow

### 1. Analyze Current Project

Run project structure detection:

```bash
bash scripts/analyze-claude-md.sh
```

Interprets JSON output to identify:

- Missing CLAUDE.md or incomplete sections
- Undocumented commands or patterns
- Framework-specific suggestions

### 2. Review Usage Patterns

Analyze Claude Code history for current project:

```bash
bash scripts/analyze.sh --current-project
```

Or analyze all projects:

```bash
bash scripts/analyze.sh
```

Identifies:

- Most-used tools (optimize auto-allow)
- Model distribution (cost awareness)
- Active projects

### 3. Discover Community Resources

Search GitHub for relevant resources:

```bash
bash scripts/github-discovery.sh all [query]
bash scripts/github-discovery.sh skills react
bash scripts/github-discovery.sh agents typescript
```

### 4. Generate Recommendations

Based on analysis, provide actionable suggestions:

- CLAUDE.md improvements (load `references/best-practices.md`)
- Settings optimizations
- New skills or agents to create
- Community resources to adopt

## Quick Commands

```bash
# Full analysis
bash scripts/analyze-claude-md.sh && bash scripts/analyze.sh --current-project

# Features reference
bash scripts/fetch-features.sh
bash scripts/fetch-features.sh --json

# GitHub discovery
bash scripts/github-discovery.sh all
bash scripts/github-discovery.sh skills
```

## Output Interpretation

### Project Analysis Output

```json
{
  "detected": {
    "package_manager": "pnpm",
    "framework": "nextjs",
    "testing": "vitest",
    "typescript": "true"
  },
  "suggestions": [
    "Document pnpm commands in CLAUDE.md",
    "Document Next.js App Router vs Pages Router usage"
  ]
}
```

### Usage Analysis Output

```json
{
  "tool_usage": { "Read": 150, "Edit": 89, "Bash": 45 },
  "model_usage": { "claude-sonnet-4-20250514": 200 },
  "auto_allowed_tools": ["Read", "Glob"]
}
```

## Recommendation Patterns

### No CLAUDE.md Detected

1. Run `analyze-claude-md.sh` for stack detection
2. Generate CLAUDE.md template from detected info
3. Include commands from package.json scripts
4. Add architecture notes based on directory structure

### Underutilized Features

If analysis shows limited tool variety:

- Suggest LSP for code navigation
- Recommend Explore agents for searches
- Propose skills for repeated workflows

### High Tool Usage Without Auto-Allow

If frequently used tools aren't auto-allowed:

- Suggest adding to `autoAllowedTools` in settings
- Reference trust levels in best-practices.md

## Dependencies

- `jq` - JSON processing (required for analyze.sh)
- `gh` - GitHub CLI (optional, enhances github-discovery.sh)

Install: `brew install jq gh`
