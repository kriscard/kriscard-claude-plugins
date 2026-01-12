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
- Skill directories: kebab-case (e.g., `using-superpowers/`)
- Agent files: kebab-case.md (e.g., `code-simplifier.md`)
