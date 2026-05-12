# CLAUDE.md

This is a Claude Code plugin marketplace repository.

## Repository Structure

```
kriscard-claude-plugins/
├── .claude-plugin/
│   └── marketplace.json         # Marketplace manifest (auto-generated)
├── plugins/
│   ├── ai-development/          # LLM/RAG, prompt engineering
│   ├── architecture/            # System design, ADRs, C4 diagrams
│   ├── assistant/               # Personal assistant, status tracking
│   ├── content/                 # Blog posts, docs, conference talks
│   ├── developer-tools/         # Coding agents (TS, React, Next.js, debugger, reviewer)
│   ├── dotfiles-optimizer/      # Shell config audit and optimization
│   ├── essentials/              # Core workflow tools (commit, researcher, simplifier)
│   ├── ideation/                # Brain dump → contracts → PRDs → specs
│   ├── interactive-learning/    # /learn sessions with Excalidraw diagrams
│   ├── neovim-advisor/          # Neovim config validation and optimization
│   ├── obsidian-second-brain/   # PARA, OKR tracking, vault maintenance
│   ├── studio-startup/          # End-to-end startup workflow
│   ├── testing/                 # Unit, integration, E2E test agents
│   └── til/                     # Today I Learned capture
├── scripts/
│   └── sync-marketplace.ts      # Auto-sync script
└── package.json
```

## Plugin Structure

Each plugin follows this structure (per [Anthropic plugin spec](https://code.claude.com/docs/en/plugins-reference)):

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest (only file in here)
├── README.md                    # Plugin documentation
├── skills/                      # Skills as <name>/SKILL.md (preferred)
├── commands/                    # Legacy flat .md files (use skills/ for new plugins)
├── agents/                      # Subagent definitions (*.md)
├── hooks/                       # Event handlers (hooks.json)
├── monitors/                    # Background monitors (v2.1.105+)
├── .mcp.json                    # MCP server configurations
└── settings.json                # Default settings (e.g., default agent)
```

### Frontmatter rules (verified against official docs)

**Skills (`SKILL.md`):**
- Required: `name`, `description`
- Recommended: trigger phrases in description ("Use when..." / "Make sure to use this skill whenever...")
- Optional: `paths` (glob auto-activation), `argument-hint`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `effort`
- Description budget: combined `description` + `when_to_use` truncated at **1,536 characters**

**Agents (in `agents/`):**
- Required: `name`, `description`
- Optional: `tools`, `disallowedTools`, `model` (default `inherit`), `color`, `effort`, `skills` (preload)
- **NOT supported on plugin-shipped agents:** `mcpServers`, `hooks`, `permissionMode` (silently ignored — security restriction)
- Default `model: inherit` respects user session preference. Use `model: haiku` only for genuinely lightweight read-only agents.

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
- Command files: kebab-case.md (e.g., `analyze-repo.md`)
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

*Developer-tools is agent-only. Slash commands handle explicit multi-step workflows (`/react-best-practices`, `/pr-review`); the model picks the right specialist agent for direct requests.

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
- (Coding work uses slash commands and direct agent invocation — no mega-orchestrator skill, per the official Anthropic marketplace pattern)

**Command-based Orchestration:**
- `/daily-startup` - Coordinates agents + skills + MCP for morning workflow
- `/test-suite` - Runs unit + integration + E2E tests in sequence

**Hybrid:**
- `architecture` - Commands for docs, skills for advisory

See [docs/ORCHESTRATION-PATTERNS.md](./docs/ORCHESTRATION-PATTERNS.md) for detailed guidance.
