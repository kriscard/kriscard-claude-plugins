# kriscard-claude-plugins

Personal Claude Code plugin marketplace - skills, commands, and agents for maximum productivity.

## Installation

Add this marketplace to Claude Code:

```bash
/plugin marketplace add kriscard/kriscard-claude-plugins
```

Then install the plugins you need:

```bash
# Core workflow tools (recommended for everyone)
/plugin install essentials@kriscard

# Transform brain dumps into specs
/plugin install ideation@kriscard

# Blog writing & conference talks
/plugin install content@kriscard

# System design & architecture
/plugin install architecture@kriscard

# LLM/RAG development
/plugin install ai-development@kriscard

# Coding agents
/plugin install developer-tools@kriscard

# Testing agents
/plugin install testing@kriscard

# Obsidian knowledge management
/plugin install obsidian-second-brain@kriscard
```

## Plugins

| Name | Description | Contents |
|------|-------------|----------|
| [essentials](./plugins/essentials) | Core workflow tools - commits, research, deep thinking, PRs, and discipline enforcement | **Commands:** `/commit` - Semantic git commits<br>`/init-ultrathink` - Generate comprehensive CLAUDE.md<br>`/ultrathink` - Deep thinking mode<br>`/de-slopify` - Remove AI-generated code slop<br>`/pr` - Quick PR creation<br>`/search-web` - Web search integration<br>`/issue` - Jira ticket workflow<br>**Skills:** `using-superpowers` - Discipline enforcement for skill usage<br>`claude-code-analyzer` - Analyze Claude Code usage patterns<br>**Agents:** `git-committer`, `researcher`, `context-manager`, `code-simplifier`, `claude-optimizer`, `meta-agent` |
| [ideation](./plugins/ideation) | Transform brain dumps into structured implementation artifacts: contracts, phased PRDs, and implementation specs | **Commands:** `/refine-spec` - Interactive specification refinement<br>**Skills:** `ideation` - Confidence-gated workflow: Brain dump → Contract → PRDs → Specs |
| [content](./plugins/content) | Content creation toolkit: blog posts, documentation, and conference talks | **Skills:** `blog-writer` - Brain dump → polished blog post<br>`doc-coauthoring` - Documentation collaboration<br>`conference-talk-builder` - Story Circle presentations<br>**Agents:** `tutorial-engineer`, `docs-architect` |
| [architecture](./plugins/architecture) | System design, technical leadership, and architecture documentation toolkit | **Commands:** `/arch-doc` - Architecture documentation<br>`/check-spec` - Specification validation<br>`/analyze-repo` - Repository analysis<br>`/explain-codebase` - Codebase explanation<br>**Skills:** `senior-architect` - System design & architecture<br>`cto-advisor` - Technical leadership guidance<br>`product-strategist` - Product strategy |
| [ai-development](./plugins/ai-development) | LLM/RAG development and prompt engineering toolkit | **Commands:** `/deep-analyze` - Multi-dimensional analysis<br>**Skills:** `ai-engineer` - LLM/RAG specialist<br>`prompt-engineer` - Prompt optimization |
| [developer-tools](./plugins/developer-tools) | Development agents for coding, frontend, and debugging | **Agents:** `coder`, `typescript-coder`, `frontend-developer`, `nextjs-developer`, `frontend-security-coder`, `debugger`, `code-reviewer`, `code-refactoring-specialist`, `ui-ux-designer` |
| [testing](./plugins/testing) | Unit, integration, and E2E testing specialists | **Agents:** `unit-test-developer`, `integration-test-developer`, `automation-test-developer` |
| [obsidian-second-brain](./plugins/obsidian-second-brain) | Comprehensive Obsidian vault manager for PARA organization, daily workflows, OKR tracking, and knowledge maintenance | **Commands:** `/apply-template` - Apply templates to notes<br>`/daily-startup` - Interactive daily workflow<br>`/maintain-vault` - Vault health check<br>`/process-inbox` - One-by-one inbox review<br>`/review-okrs` - Multi-level OKR reviews<br>**Skills:** `obsidian-workflows` - PARA method & PKM<br>`template-patterns` - Template selection guidance<br>`vault-structure` - Vault organization<br>**Agents:** `link-maintainer`, `okr-tracker`, `para-organizer`, `tag-optimizer`<br>**Hook:** SessionStart reminder for daily notes |

## Development

This is a pnpm workspace with TypeScript support.

```bash
# Install dependencies
pnpm install

# Create a new plugin
pnpm run create-plugin my-plugin --description "Plugin description" --all

# Sync marketplace with plugins
pnpm run sync

# Type check
pnpm run typecheck

# Format code
pnpm run format
```

### Adding a New Plugin

#### Using the Generator (Recommended)

```bash
# Create plugin with all component directories
pnpm run create-plugin my-plugin --description "My plugin description" --all

# Or specify only what you need
pnpm run create-plugin my-plugin --description "My plugin" --agents --commands
```

#### Manual Setup

1. Create `plugins/your-plugin/.claude-plugin/plugin.json`:
   ```json
   {
     "name": "your-plugin",
     "version": "0.1.0",
     "description": "Plugin description",
     "author": {
       "name": "Chris Cardoso",
       "email": "contact@christophercardoso.dev"
     },
     "license": "MIT",
     "keywords": []
   }
   ```

2. Add components: agents, commands, skills, hooks
3. Create README.md
4. Run `pnpm run sync` to update marketplace.json

The sync script auto-discovers plugins and validates them before updating the marketplace manifest.

### Plugin Structure

Each plugin follows this structure:

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest (required)
├── README.md                 # Plugin documentation (required)
├── .gitignore                # For local configs (if needed)
├── agents/                   # Autonomous agents (*.md)
├── commands/                 # Slash commands (*.md)
├── skills/                   # Skills (*/SKILL.md)
└── hooks/                    # Event hooks (hooks.json)
```

### Validation

The sync script validates all plugins:
- ✅ Name matches directory (kebab-case)
- ✅ Valid semver version
- ✅ Required fields present (name, version, description, author)
- ✅ Author has name and email

Run validation:
```bash
pnpm run sync
```

## License

MIT
