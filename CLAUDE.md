# CLAUDE.md

This is a Claude Code plugin marketplace repository.

## Repository Structure

```
kriscard-claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest
├── plugins/
│   ├── essentials/           # Core workflow tools
│   ├── ideation/             # Brain dump → specs
│   ├── content/              # Blog + talks
│   ├── architecture/         # System design
│   ├── ai-development/       # LLM/RAG tools
│   ├── developer-tools/      # Coding agents
│   └── testing/              # Test agents
├── scripts/
│   └── sync-marketplace.ts   # Auto-sync script
└── package.json
```

## Plugin Structure

Each plugin follows this structure:

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── README.md                 # Plugin documentation
├── commands/                 # Slash commands (*.md)
├── skills/                   # Skills (*/SKILL.md)
└── agents/                   # Agents (*.md)
```

## Development Commands

```bash
pnpm install                                          # Install dependencies
pnpm run create-plugin <name> --description "..."     # Create new plugin
pnpm run sync                                         # Update marketplace.json from plugins
pnpm run typecheck                                    # Type check TypeScript files
pnpm run format                                       # Format all files
```

## Adding Content

When adding new skills, commands, or agents:

1. Place files in the correct plugin directory
2. Follow existing patterns for file structure
3. Run `pnpm run sync` to update the marketplace
4. Test locally with `claude --plugin-dir ./plugins/<name>`

## Naming Conventions

- Plugin names: kebab-case (e.g., `developer-tools`)
- Command files: kebab-case.md (e.g., `init-ultrathink.md`)
- Skill directories: kebab-case (e.g., `blog-writer/`)
- Agent files: kebab-case.md (e.g., `code-simplifier.md`)

## Orchestration Philosophy

This marketplace uses **context-appropriate orchestration** - different patterns for different plugin types.

### Orchestration Patterns

| Pattern | When to Use | Entry Point | Example Plugin |
|---------|-------------|-------------|----------------|
| **Skill-based** | Workflow should start implicitly on user intent | Natural language | `ideation`, `content` |
| **Command-based** | Users need explicit control over workflow | `/command` | `obsidian-second-brain` |
| **Hybrid** | Need both implicit and explicit entry points | Skills + Commands | `architecture`, `ai-development` |
| **Agent-only** | Components work independently, no coordination needed | Context-based | `developer-tools`* |

*Developer-tools now includes `code-assistant` skill orchestrator for intelligent agent selection.

### Design Principles

1. **Single Responsibility**: Orchestrators coordinate, they don't do the work
2. **Progressive Enhancement**: Components work alone, orchestrator provides "happy path"
3. **Clear Entry Points**: Obvious what to invoke and when
4. **User Control**: Can always access components directly if preferred

### When to Add Orchestration

Add an orchestrator when:
- ✅ Multiple components must coordinate to complete a workflow
- ✅ Users need guidance on which component to use
- ✅ Complex multi-step processes benefit from automation
- ✅ Workflow has a clear "entry point" that makes sense to users

Skip orchestration when:
- ❌ Components work perfectly fine independently
- ❌ Orchestration adds complexity without value
- ❌ Users know exactly which specialist they need

### Layered Architecture

```
Orchestration Layer (skills/commands)
  ↓ [Coordinates workflows]

Component Layer (agents, sub-skills, MCP)
  ↓ [Execute specific tasks]

Output Layer (files, summaries, actions)
```

### Examples from This Marketplace

**Skill-based Orchestration:**
- `ideation` - Confidence scoring → questions → contract → PRDs → specs
- `blog-writer` - Brain dump → polished blog post with SEO
- `code-assistant` - Auto-selects best specialist agent for coding task

**Command-based Orchestration:**
- `/daily-startup` - Coordinates agents + skills + MCP for morning workflow
- `/test-suite` - Runs unit + integration + E2E tests in sequence

**Hybrid:**
- `architecture` - Commands for docs, skills for advisory

See [docs/ORCHESTRATION-PATTERNS.md](./docs/ORCHESTRATION-PATTERNS.md) for detailed guidance.
