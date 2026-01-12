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
```

## Plugins

### essentials

Core workflow tools for daily development.

**Commands:**
- `/commit` - Semantic git commits with conventional format
- `/init-ultrathink` - Generate comprehensive CLAUDE.md
- `/ultrathink` - Deep thinking mode for complex problems
- `/de-slopify` - Remove AI-generated code slop
- `/pr` - Quick PR creation with template
- `/search-web` - Web search integration

**Skills:**
- `using-superpowers` - Discipline enforcement for skill usage

**Agents:**
- `git-committer` - Semantic commits with pre-commit handling
- `researcher` - Research docs, APIs, best practices
- `context-manager` - Context across agents and long tasks
- `code-simplifier` - Refactor without changing behavior

### ideation

Transform messy brain dumps into structured implementation artifacts.

**Skills:**
- `ideation` - Confidence-gated workflow: Brain dump → Contract → PRDs → Specs

### content

Content creation pipeline for blogs, docs, and talks.

**Skills:**
- `blog-writer` - Brain dump → polished blog post with SEO
- `doc-coauthoring` - Documentation collaboration
- `conference-talk-builder` - Story Circle presentations

**Agents:**
- `tutorial-engineer` - Step-by-step tutorials
- `docs-architect` - Technical documentation

### architecture

System design and technical leadership toolkit.

**Skills:**
- `senior-architect` - System design & architecture
- `cto-advisor` - Technical leadership guidance
- `product-strategist` - Product strategy

**Commands:**
- `/arch-doc` - Architecture documentation
- `/check-spec` - Specification validation
- `/analyze-repo` - Repository analysis
- `/explain-codebase` - Codebase explanation

**Agents:**
- `code-reviewer` - Code review

### ai-development

LLM/RAG development and prompt engineering.

**Skills:**
- `ai-engineer` - LLM/RAG specialist
- `prompt-engineer` - Prompt optimization

**Commands:**
- `/deep-analyze` - Multi-dimensional analysis

### developer-tools

Development agents for coding and debugging.

**Agents:**
- `coder` - General implementation
- `typescript-coder` - TypeScript specialist
- `frontend-developer` - Frontend development
- `nextjs-developer` - Next.js specialist
- `frontend-security-coder` - Security-focused frontend
- `debugger` - Debugging specialist

### testing

Testing specialists for comprehensive coverage.

**Agents:**
- `unit-test-developer` - Unit testing
- `integration-test-developer` - Integration testing
- `automation-test-developer` - E2E testing

## Development

This is a pnpm workspace with TypeScript support.

```bash
# Install dependencies
pnpm install

# Type check
pnpm run typecheck

# Build & sync marketplace
pnpm run build:all

# Format code
pnpm run format
```

### Adding a New Plugin

1. Create `plugins/your-plugin/.claude-plugin/plugin.json`
2. Add components: agents, commands, skills
3. Run `pnpm run sync` to update marketplace.json

The sync script auto-discovers plugins and updates the marketplace manifest.

## License

MIT
