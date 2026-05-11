# Skill-First Mode

Before doing ANY work on the user's request, search for and load the most relevant skills.

## Input

If arguments were provided:

$ARGUMENTS

If no arguments above, ask the user:

> Skill-first mode active. What do you want to work on?

Then **stop and wait** for their response.

## Step 1: Match Skills to the Prompt

Identify the **1-3 most specific** skills that directly address the request. Precision over breadth — load only what's needed.

### Selection Rules

1. **Pick the most specific skill first** — if the user asks about LSP config, load `nvim-lsp`, not `neovim-best-practices`
2. **Only add a second/third skill if it covers a clearly different aspect** of the prompt
3. **Never load a general skill when a specific one exists** — e.g. don't load `code-assistant` when `react-best-practices` covers it
4. **Cap at 3 skills max** — if you think you need more, pick the 3 most relevant
5. **If nothing matches closely, say so** — don't force-load unrelated skills

### Important: Skills Only

This reference lists **skills only** — components loaded via the `Skill` tool. **Never attempt to load agents** (e.g., `typescript-coder`, `code-reviewer`, `unit-test-developer`) via the Skill tool — agents are spawned via the Agent tool and will fail if loaded as skills. Use the orchestrator skill that coordinates them instead.

### Skill Reference by Domain

Use this to identify candidates, then narrow down to the most specific 1-3.

**Neovim:**
- `neovim-best-practices` — general config, keymaps, autocommands
- `lazy-nvim-optimization` — startup time, lazy-loading, profiling
- `nvim-plugins` — plugin recommendations, alternatives
- `nvim-lsp` — LSP setup, Mason, language servers
- `nvim-perf` — profiling, bottleneck identification
- `nvim-check-config` — config validation, best practices audit

**Frontend / React / Next.js:**
- `react-best-practices` — component audit, patterns, performance rules
- `code-assistant` — orchestrates frontend-developer, nextjs-developer, frontend-security-coder agents

**TypeScript / Code Quality:**
- `code-assistant` — orchestrates typescript-coder, code-reviewer, debugger, refactoring agents
- `de-slopify` — remove AI-generated comments

**Architecture:**
- `senior-architect` — system design, C4 diagrams, ADRs
- `arch-doc` — architecture documentation

**Testing:**
- `test-suite` — orchestrates unit-test-developer, integration-test-developer, automation-test-developer agents

**Git:**
- `commit` — semantic commits, conventional format
- `pr` — pull request creation

**Dotfiles / Shell:**
- `dotfiles-optimizer` — dotfiles analysis and optimization

**Content:**
- `blog-writer` — brain dump to blog post with SEO
- `tech-document-creator` — RFCs, product design docs, architecture proposals, ADRs

**AI / LLM:**
- `ai-engineer` — RAG, vector search, agent orchestration
- `prompt-engineer` — prompt diagnosis and improvement
- `claude-developer-platform` — Claude API, Anthropic SDK

**Learning:**
- `interactive-teaching` — guided learning, Socratic method

**Obsidian:**
- `obsidian` — vault operations, notes, daily notes

**Plugin Development:**
- `claude-code-analyzer` — analyze Claude Code internals
- `plugin-structure` — plugin scaffold, manifest, components
- `skill-development` — skill creation best practices

**Specs / Product:**
- `spec` — spec writing
- `deep-spec` — detailed specifications
- `ideation` — brain dump to PRD

**Communication:**
- `check-communication` — staff-level communication review

### Quick Match Examples

| Prompt | Load | Skip |
|--------|------|------|
| "My LSP feels slow opening React files" | `nvim-lsp`, `nvim-perf` | `neovim-best-practices` |
| "Is this React component good?" | `react-best-practices` | `code-assistant` |
| "Write unit tests for this service" | `test-suite` | `code-assistant` |
| "Create a blog post about streaming" | `blog-writer` | `code-assistant` |
| "Optimize my Neovim startup" | `nvim-perf`, `lazy-nvim-optimization` | `neovim-best-practices` |
| "Help me build a RAG pipeline" | `ai-engineer` | `prompt-engineer` |
| "Review this PR comment tone" | `check-communication` | `code-assistant` |

## Step 2: Load Skills

For EACH matching skill, call the **Skill tool** to load it. Do NOT just mention them — you must actually invoke the Skill tool for each one.

Report what you loaded:

> **Loaded skills:**
> - `skill-name-1` — reason it matches
> - `skill-name-2` — reason it matches

## Step 3: Execute

Respond to the user's original prompt using the knowledge and instructions from all loaded skills. Follow each loaded skill's workflow and guidelines.

## Rules

- **Load 1-3 skills max** — be selective, not exhaustive
- **Specific beats general** — always prefer the narrower, more targeted skill
- **Actually call Skill()** — reading a skill file is NOT the same as loading it
- **Stay in skill-first mode** for the entire conversation — repeat this process for each new prompt
- **Never load check-skills itself** — avoid recursion
