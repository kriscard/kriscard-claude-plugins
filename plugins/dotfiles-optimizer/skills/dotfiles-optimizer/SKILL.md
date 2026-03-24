---
name: dotfiles-optimizer
disable-model-invocation: true
description: >-
  Analyzes and optimizes shell configurations (zsh, tmux, git), audits dotfiles for
  security issues, identifies performance bottlenecks, and recommends modern CLI
  tool replacements. Make sure to use this skill whenever the user wants to optimize
  dotfiles, improve shell startup time, audit configs, or modernize their dev
  environment.
version: 0.1.0
---

# Dotfiles Optimizer - Main Orchestrator

Coordinate comprehensive analysis and optimization of dotfiles with intelligent, context-aware recommendations. Reads the dotfiles path from `.claude/dotfiles-optimizer.local.md` (defaults to `~/.dotfiles`).

## Arguments

When invoked via `/optimize`, the following arguments are supported:

**Component Scope** (optional, positional):
- `zsh` - Shell configuration only
- `tmux` - Tmux configuration only
- `nvim` - Neovim configuration only
- `git` - Git configuration only
- `terminal` - Terminal configs (Kitty/Ghostty) only
- `all` or omitted - Entire dotfiles structure

**Flags** (optional):
- `--apply` - Automatically apply critical and recommended fixes without confirmation
- `--security` - Focus analysis on security issues only
- `--performance` - Focus analysis on performance optimization only
- `--modern-tools` - Focus on modern tool recommendations only

**Examples**: `/optimize`, `/optimize zsh`, `/optimize --security`, `/optimize zsh --apply`, `/optimize --performance`

## When to Use

Activate this skill when users request:
- General optimization ("optimize my dotfiles", "improve my shell")
- Security audits ("check for exposed credentials", "audit my configs")
- Performance improvements ("make my shell faster", "speed up zsh startup")
- Modern tool recommendations ("what CLI tools should I use")
- Configuration analysis ("analyze my setup", "check my tmux config")

## Workflow

### 1. Determine Scope

Infer scope from context: if user is editing a specific config file, focus there. If they request a specific component, scope to it. Otherwise analyze everything. Load dotfiles path from `.claude/dotfiles-optimizer.local.md` (default: `/Users/kriscard/.dotfiles`). Check for `dotfiles_path` override and `enable_proactive_warnings` setting.

### 2. Invoke Analysis Agent

Call `dotfiles-analyzer` agent with the determined scope for deep analysis (2-3 min). The agent parses configs, checks security issues, identifies performance bottlenecks, suggests modern CLI alternatives, and validates patterns against best practices.

### 3. Reference Best Practices

Consult `dotfiles-best-practices` skill for modern CLI tools, shell performance techniques, security patterns, config organization strategies, and git workflow improvements. Use this to enhance the analyzer's findings with context and rationale.

### 4. Generate Prioritized Recommendations

Organize findings into three tiers:
- **Critical**: Security vulnerabilities, insecure permissions, breaking errors, data loss risks
- **Recommended**: Performance optimizations, modern tool suggestions, better patterns, missing best practices
- **Optional**: Aesthetic improvements, nice-to-have features, alternative approaches

Format output as: `## Analysis Results for [Scope]` with each tier listing count and items with location/remediation/rationale.

### 5. Offer to Apply Fixes

Present options: all critical (recommended), all improvements, specific items, or none. For `--apply` flag: auto-apply critical + recommended, skip optional. When applying: use Read/Edit tools, explain each change, validate syntax. Always create timestamped backups before modifying files.

### 6. Integration with Existing Tools

The user's `dotfiles` CLI (`/Users/kriscard/.dotfiles/dotfiles`) handles init, sync, backup, and doctor. This plugin provides analysis, security scanning, best practice validation, and modern tool suggestions. Defer to their script for mechanical operations.

## Gotchas

- Always create timestamped backups before modifying any file -- changes to shell config can break the terminal
- The user has an existing `dotfiles` CLI script -- complement it, don't duplicate its functionality (init, sync, backup)
- Default dotfiles path is `/Users/kriscard/.dotfiles` -- check `.claude/dotfiles-optimizer.local.md` for overrides
- Security issues (exposed credentials) are ALWAYS critical priority -- never downgrade them
- Don't suggest replacing tools the user already has configured -- check existing aliases first

## Output Best Practices

- Include file paths and line numbers; show before/after examples
- Provide exact commands or edits; link to docs when relevant
- Explain rationale -- help user learn, not just fix

## Reference Files

| File | Contents |
|------|----------|
| `references/component-analysis.md` | Per-component analysis details, modern tool table, security and performance checklists |
| `references/analysis-patterns.md` | Credential detection regex, lazy loading templates, tool configs, common issue fixes |

## Related

- **Skill**: `dotfiles-best-practices` -- knowledge base for patterns and modern tools
- **Agent**: `dotfiles-analyzer` -- deep file-by-file analysis, activated by this orchestrator
- **Commands**: `/optimize` (full workflow), `/audit` (read-only analysis)

## Example Session

```
User: "Optimize my dotfiles"

1. Scope: Entire dotfiles (no specific context)
2. Invoke dotfiles-analyzer for comprehensive analysis
3. Reference dotfiles-best-practices for context
4. Findings:
   Critical (2): API key in zsh.d/00-env.zsh:45, .gitconfig-work perms 644->600
   Recommended (5): Lazy load nvm (-300ms), eza alias, modularize .zshrc,
     .env.example template, git commit signing
   Optional (3): starship prompt, bat Catppuccin theme, tpm for tmux
5. User: "All critical and recommended"
6. Apply each fix with backup, explanation, and syntax validation
7. Verify changes and confirm completion
```
