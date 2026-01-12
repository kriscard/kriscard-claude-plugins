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

| Name | Description | Orchestration & Components |
|------|-------------|----------------------------|
| [essentials](./plugins/essentials) | Core workflow tools - commits, research, deep thinking, PRs, and discipline enforcement | **Pattern:** Command-based + Meta-orchestration<br>**Entry:** `/commit`, `/pr`, `/ultrathink`, etc. + Always-on skill enforcement<br><br>**Commands:** `/commit`, `/init-ultrathink`, `/ultrathink`, `/de-slopify`, `/pr`, `/search-web`, `/issue`<br>**Skills:** `using-superpowers` ⭐ (Meta-orchestrator enforces skill usage)<br>**Agents:** `git-committer`, `researcher`, `context-manager`, `code-simplifier`, `claude-optimizer`, `meta-agent` |
| [ideation](./plugins/ideation) | Transform brain dumps into structured implementation artifacts: contracts, phased PRDs, and implementation specs | **Pattern:** Hybrid (Skill + Command orchestration)<br>**Entry:** Natural language - "I want to build..." OR `/validate-output` for validation<br><br>**Commands:** `/refine-spec`, `/validate-output` ⭐ (Validates ideation outputs)<br>**Skills:** `ideation` ⭐ (Orchestrates: confidence scoring → questions → contract → PRDs → specs) |
| [content](./plugins/content) | Content creation toolkit: blog posts, documentation, and conference talks | **Pattern:** Hybrid (Command + Skill orchestration)<br>**Entry:** `/write-blog`, `/create-talk` OR natural language - "Write a blog about...", "Help me document..."<br><br>**Commands:** `/write-blog` ⭐ (Blog posts), `/create-talk` ⭐ (Conference talks)<br>**Skills:** `blog-writer` ⭐, `doc-coauthoring` ⭐, `conference-talk-builder` ⭐ (Each orchestrates complete content workflow)<br>**Agents:** `tutorial-engineer`, `docs-architect` |
| [architecture](./plugins/architecture) | System design, technical leadership, and architecture documentation toolkit | **Pattern:** Hybrid (Command + Skill orchestration)<br>**Entry:** `/arch-doc` commands OR natural language architecture discussions<br><br>**Commands:** `/arch-doc`, `/check-spec`, `/analyze-repo`, `/explain-codebase`<br>**Skills:** `senior-architect` ⭐, `cto-advisor` ⭐, `product-strategist` ⭐ |
| [ai-development](./plugins/ai-development) | LLM/RAG development and prompt engineering toolkit | **Pattern:** Hybrid (Command + Skill orchestration)<br>**Entry:** `/deep-analyze` OR natural language LLM/RAG discussions<br><br>**Commands:** `/deep-analyze`<br>**Skills:** `ai-engineer` ⭐, `prompt-engineer` ⭐ |
| [developer-tools](./plugins/developer-tools) | Development agents for coding, frontend, and debugging | **Pattern:** Hybrid (Skill + Agent orchestration)<br>**Entry:** Natural language coding requests OR context-based agent activation<br><br>**Skills:** `code-assistant` ⭐ (Auto-selects best specialist based on context)<br>**Agents:** `coder`, `typescript-coder`, `frontend-developer`, `nextjs-developer`, `frontend-security-coder`, `debugger`, `code-reviewer`, `code-refactoring-specialist`, `ui-ux-designer` |
| [testing](./plugins/testing) | Unit, integration, and E2E testing specialists | **Pattern:** Command-based orchestration<br>**Entry:** `/test-suite` OR context-based agent activation<br><br>**Commands:** `/test-suite` ⭐ (Coordinates all three test layers)<br>**Agents:** `unit-test-developer`, `integration-test-developer`, `automation-test-developer` |
| [obsidian-second-brain](./plugins/obsidian-second-brain) | Comprehensive Obsidian vault manager for PARA organization, daily workflows, OKR tracking, and knowledge maintenance | **Pattern:** Command-based orchestration + Event hooks<br>**Entry:** `/daily-startup`, `/process-inbox`, etc. (explicit workflow triggers)<br><br>**Commands:** `/daily-startup` ⭐ (Orchestrates agents + skills + MCP), `/apply-template`, `/maintain-vault`, `/process-inbox`, `/review-okrs`<br>**Skills:** `obsidian-workflows`, `template-patterns`, `vault-structure`<br>**Agents:** `link-maintainer`, `okr-tracker`, `para-organizer`, `tag-optimizer`<br>**Hook:** SessionStart - Daily note reminder |

### Orchestration Pattern Legend

- ⭐ **Primary entry point** - Main orchestrator that coordinates other components
- **Skill-based:** Triggers implicitly via natural language intent
- **Command-based:** Explicit `/command` invocation by user
- **Meta-orchestration:** Always-on enforcement across all interactions
- **Hybrid:** Multiple entry points (commands + skills)
- **Agent-only:** Individual specialists, no central coordinator

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
