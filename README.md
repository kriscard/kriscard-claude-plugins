# kriscard-claude-plugins

Personal Claude Code plugin marketplace - skills, commands, and agents for maximum productivity.

## Installation

Add this marketplace from GitHub:

```bash
claude plugin marketplace add kriscard/kriscard-claude-plugins
```

Install plugins you need:

```bash
claude plugin install essentials@kriscard           # Core workflow tools
claude plugin install ideation@kriscard             # Brain dumps → specs
claude plugin install content@kriscard              # Blog posts & talks
claude plugin install architecture@kriscard         # System design
claude plugin install ai-development@kriscard       # LLM/RAG tools
claude plugin install developer-tools@kriscard      # Coding agents
claude plugin install testing@kriscard              # Test specialists
claude plugin install obsidian-second-brain@kriscard # Knowledge management
```

## Plugins

| Plugin | Description | How to Use |
|--------|-------------|------------|
| [essentials](./plugins/essentials) | Core workflow tools - commits, research, deep thinking, PRs, and discipline enforcement | **Commands:** `/commit`, `/pr`, `/ultrathink`, `/de-slopify`, `/search-web`, `/issue`<br>**Auto-enforces:** Skill usage across all interactions |
| [ideation](./plugins/ideation) | Transform brain dumps into structured implementation artifacts | **Natural language:** "I want to build..."<br>**Commands:** `/refine-spec`, `/validate-output`<br>**Workflow:** Confidence → Questions → Contract → PRDs → Specs |
| [content](./plugins/content) | Blog posts, documentation, and conference talks | **Commands:** `/write-blog`, `/create-talk`<br>**Natural language:** "Write a blog about...", "Help me document..." |
| [architecture](./plugins/architecture) | System design, technical leadership, and architecture documentation | **Commands:** `/arch-doc`, `/check-spec`, `/analyze-repo`, `/explain-codebase`<br>**Skills:** Senior architect, CTO advisor, product strategist |
| [ai-development](./plugins/ai-development) | LLM/RAG development and prompt engineering | **Commands:** `/deep-analyze`<br>**Skills:** AI engineer, prompt engineer |
| [developer-tools](./plugins/developer-tools) | Coding, frontend, and debugging specialists | **Natural language:** "Build a login form", "Fix this bug"<br>**Auto-selects:** Best specialist agent for your task |
| [testing](./plugins/testing) | Unit, integration, and E2E testing | **Commands:** `/test-suite` (runs all layers)<br>**Agents:** Unit, integration, automation test developers |
| [obsidian-second-brain](./plugins/obsidian-second-brain) | Obsidian vault manager - PARA, daily workflows, OKR tracking | **Commands:** `/daily-startup`, `/process-inbox`, `/review-okrs`, `/maintain-vault`<br>**Auto-runs:** Daily note reminder on startup |

**Legend:** Commands use `/command` syntax. Natural language triggers work automatically. ⭐ marks primary entry points.

## Development

Quick start for contributing:

```bash
pnpm install                                          # Install dependencies
pnpm run create-plugin my-plugin --description "..."  # Create new plugin
pnpm run sync                                         # Update marketplace.json
pnpm run typecheck                                    # Type check
pnpm run format                                       # Format code
```

### Plugin Structure

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json      # Manifest (required)
├── README.md            # Documentation (required)
├── commands/            # Slash commands (*.md)
├── skills/              # Skills (*/SKILL.md)
├── agents/              # Agents (*.md)
└── hooks/               # Event hooks (hooks.json)
```

The `pnpm run sync` command auto-discovers, validates, and updates the marketplace manifest.

## License

MIT
