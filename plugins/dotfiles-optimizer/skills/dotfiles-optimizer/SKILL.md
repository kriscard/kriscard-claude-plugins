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

Coordinate comprehensive analysis and optimization of dotfiles with intelligent, context-aware recommendations.

## Purpose

This skill orchestrates the complete dotfiles optimization workflow: analyzing configurations, identifying issues, recommending improvements, and optionally applying fixes. It reads the dotfiles path from user settings in `.claude/dotfiles-optimizer.local.md` (defaults to `~/.dotfiles`). Supports modular zsh configuration, Neovim, Tmux, Git multi-config setup, and themed terminal environments.

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

**Examples**:
```bash
/optimize                    # Full analysis of all components
/optimize zsh                # Analyze shell configuration only
/optimize --security         # Security audit across all components
/optimize zsh --apply        # Analyze shell and auto-apply fixes
/optimize --performance      # Performance optimization focus
```

## When to Use

Activate this skill when users request:
- General optimization ("optimize my dotfiles", "improve my shell")
- Security audits ("check for exposed credentials", "audit my configs")
- Performance improvements ("make my shell faster", "speed up zsh startup")
- Modern tool recommendations ("what CLI tools should I use")
- Configuration analysis ("analyze my setup", "check my tmux config")

## Workflow

Follow this orchestration workflow when activated:

### 1. Determine Scope

**Context-aware scoping**: Analyze what the user is currently working on or explicitly requested:

- **If user is editing a specific config file** (e.g., `.zshrc`, `tmux.conf`):
  - Focus analysis on that component and related files
  - Example: Editing `.zshrc` → analyze shell configuration (zsh.d/, aliases, functions)

- **If user requests specific component** (e.g., "optimize my zsh"):
  - Scope to that component only
  - Components: shell (zsh), editor (nvim), multiplexer (tmux), git, terminal (kitty/ghostty)

- **If user requests general optimization**:
  - Analyze entire dotfiles structure
  - Prioritize critical issues first, then component-by-component

**Configuration loading**: Check for user settings in `.claude/dotfiles-optimizer.local.md`:
- Default path: `/Users/kriscard/.dotfiles`
- User can override with `dotfiles_path` field in frontmatter
- User can disable proactive warnings with `enable_proactive_warnings: false`

### 2. Invoke Analysis Agent

Call the `dotfiles-analyzer` agent to perform deep analysis:

```
Invoke dotfiles-analyzer agent with:
- Scope: [determined above]
- Depth: deep (2-3 minute comprehensive analysis)
- Focus areas: security, performance, modern tools, configuration patterns
```

The agent will:
- Parse configuration files
- Check for security issues (exposed credentials, insecure permissions)
- Identify performance bottlenecks (startup time, lazy loading opportunities)
- Suggest modern CLI tool alternatives
- Validate configuration patterns against best practices

### 3. Reference Best Practices

Consult the `dotfiles-best-practices` skill for knowledge about:
- Modern CLI tools and their benefits
- Shell performance optimization techniques
- Security patterns for credential management
- Configuration organization strategies
- Git workflow improvements

Use this knowledge to enhance the analyzer's findings with context and rationale.

### 4. Generate Prioritized Recommendations

Organize findings into three priority levels:

**🔴 Critical Issues**
- Security vulnerabilities (exposed API keys, passwords, tokens)
- Insecure file permissions (should be 600/700 for sensitive files)
- Breaking configuration errors
- Data loss risks

**🟡 Recommended Improvements**
- Performance optimizations (lazy loading, startup time)
- Modern tool suggestions (eza instead of ls)
- Better configuration patterns (modular organization)
- Missing best practices (git signing, env templates)

**🟢 Optional Enhancements**
- Aesthetic improvements (themes, prompts)
- Nice-to-have features (additional plugins)
- Alternative approaches (different tools)
- Advanced configurations

**Output format**:
```
## Analysis Results for [Scope]

🔴 Critical Issues (N)
  - Issue 1 with location and remediation
  - Issue 2 with location and remediation

🟡 Recommended Improvements (N)
  - Improvement 1 with rationale and benefit
  - Improvement 2 with rationale and benefit

🟢 Optional Enhancements (N)
  - Enhancement 1 with description
  - Enhancement 2 with description
```

### 5. Offer to Apply Fixes

After presenting recommendations:

**For Critical Issues**:
- Strongly recommend immediate fixes
- Offer to apply automatically with user confirmation
- Explain risks of not fixing

**For Recommended Improvements**:
- Ask which improvements user wants to apply
- Can apply all, selected, or none
- Provide implementation guidance

**For Optional Enhancements**:
- Present as "nice-to-haves"
- User can request specific ones
- Don't push for these

**Application workflow**:
```
Ask: "Which fixes would you like to apply?"
Options:
- All critical issues (recommended)
- All recommended improvements
- Specific items (let me choose)
- None (just wanted the analysis)
```

**If `--apply` flag was passed**:
- Apply all critical issues automatically
- Apply all recommended improvements automatically
- Skip optional enhancements (user can request separately)
- Show progress for each fix applied

If user chooses to apply interactively:
- Use Read tool to examine current configs
- Use Edit tool to make precise changes
- Explain each change as it's made
- Validate changes don't break syntax

**Backup strategy** (always, before modifying any file):
```bash
cp ~/.dotfiles/.zshrc ~/.dotfiles/.zshrc.backup.$(date +%Y%m%d-%H%M%S)
```
Create timestamped backups so changes are always reversible.

### 6. Integration with Existing Tools

The user has an existing `dotfiles` CLI script at `/Users/kriscard/.dotfiles/dotfiles`. Complement this tool:

**This plugin provides**:
- Intelligent analysis and recommendations
- Security scanning
- Best practice validation
- Modern tool suggestions

**The dotfiles script provides**:
- Installation automation (`dotfiles init`)
- Health checks (`dotfiles doctor`)
- Syncing (`dotfiles sync`)
- Backup management (`dotfiles backup`)

**Recommendation**: When user needs to run init, sync, or backup operations, suggest using their existing `dotfiles` script. Focus this plugin on analysis and optimization guidance.

## Component-Specific Analysis

### Shell (Zsh)

Analyze the modular configuration in `zsh/zsh.d/`:
- `00-env.zsh` - Environment variables (check for exposed credentials)
- `10-options.zsh` - Shell options (validate settings)
- `20-completions.zsh` - Completion system (check for performance)
- `30-plugins.zsh` - Plugin loading (identify slow plugins, suggest lazy loading)
- `40-lazy.zsh` - Lazy loading patterns (validate implementation)
- `50-keybindings.zsh` - Key mappings (check for conflicts)
- `60-aliases.zsh` - Aliases (suggest modern tool alternatives)
- `70-functions.zsh` - Functions (optimize complex functions)
- `80-integrations.zsh` - External integrations (validate configurations)
- `99-local.zsh.example` - Local overrides (check for security)

**Key checks**:
- Startup time profiling (should be <500ms)
- Plugin lazy loading opportunities
- Modern aliases (eza, bat, fd, ripgrep, zoxide)
- Secure environment variable handling

### Editor (Neovim)

Analyze `.config/nvim/`:
- LSP configurations (validate server setups)
- Plugin management (check for outdated or conflicting plugins)
- Performance (startup time, lazy loading)
- Keybindings (identify conflicts)

### Multiplexer (Tmux)

Analyze `.config/tmux/`:
- Plugin configuration
- Keybinding sanity
- Performance settings
- Integration with sesh session manager

### Git

Analyze git configuration files:
- `.gitconfig` - Main configuration
- `.gitconfig-personal` - Personal settings
- `.gitconfig-work` - Work settings
- Check for exposed credentials
- Validate signing configuration
- Suggest workflow improvements

### Terminal (Kitty/Ghostty)

Analyze `.config/kitty/` and `.config/ghostty/`:
- Theme consistency (Catppuccin Macchiato)
- Font configuration
- Performance settings
- Key mappings

## Modern Tool Recommendations

Reference these tool replacements (from user's existing setup):

| Traditional | Modern Alternative | User Has | Benefit |
|-------------|-------------------|----------|---------|
| `ls` | `eza` | ✅ | Git integration, icons |
| `cat` | `bat` | ✅ | Syntax highlighting |
| `find` | `fd` | ✅ | Faster, simpler syntax |
| `grep` | `ripgrep` | ✅ | Blazing fast search |
| `cd` | `zoxide` | ✅ | Smart jumping |

Validate these are properly aliased and configured. Suggest additional modern tools if relevant.

## Security Validation

Always check for:
1. **Exposed credentials**: API keys, tokens, passwords in plain text
2. **File permissions**: Sensitive files should be 600 (user read/write only)
3. **History settings**: Ensure sensitive commands aren't logged
4. **Git safety**: Validate `.gitignore` patterns for secrets
5. **Environment files**: Check `.env` vs `.env.example` patterns

## Performance Optimization

Check for:
1. **Shell startup time**: Profile and identify slow components
2. **Lazy loading**: Defer loading of tools not used in every session
3. **Completion caching**: Validate completion cache strategies
4. **Plugin efficiency**: Identify slow or redundant plugins

## Output Best Practices

**Be specific**:
- Include file paths and line numbers
- Show before/after examples
- Explain why changes help

**Be actionable**:
- Provide exact commands or edits
- Link to documentation when relevant
- Offer to make changes

**Be educational**:
- Explain rationale for recommendations
- Reference best practices
- Help user learn, not just fix

## Additional Resources

### Related Skills

- **dotfiles-best-practices** - Detailed knowledge base for patterns and modern tools

### Agent Invocation

Use the `dotfiles-analyzer` agent for deep analysis:
- Activated by this orchestrator
- Can also trigger proactively on critical security issues
- Provides detailed, file-by-file analysis

### Commands

Users can also invoke explicitly via commands:
- `/optimize` - Full workflow (same as this skill)
- `/audit` - Read-only analysis without offering fixes

## Example Session

```
User: "Optimize my dotfiles"

1. Determine scope: Entire dotfiles (no specific context)
2. Invoke dotfiles-analyzer agent for comprehensive analysis
3. Reference dotfiles-best-practices for context
4. Generate findings:

   🔴 Critical Issues (2)
     - API key in zsh.d/00-env.zsh line 45: GITHUB_TOKEN=ghp_xxx
     - .gitconfig-work has permissions 644, should be 600

   🟡 Recommended Improvements (5)
     - Enable lazy loading for nvm (saves ~300ms startup)
     - Use eza with git integration (already installed, needs alias)
     - Modularize .zshrc further (move local config to 99-local.zsh)
     - Add .env.example template for safe credential patterns
     - Enable git commit signing for security

   🟢 Optional Enhancements (3)
     - Consider starship prompt for better performance
     - Add bat theme matching Catppuccin setup
     - Configure tmux plugin manager (tpm) for easier plugin management

5. Ask: "Which fixes would you like to apply?"
   User: "All critical and recommended"

6. Apply fixes with explanations:
   - Move GITHUB_TOKEN to .env (not committed)
   - Update .gitconfig-work permissions to 600
   - Add lazy loading wrapper for nvm
   - Create eza alias with --git flag
   - [Continue for each fix...]

7. Verify changes and confirm completion
```

## Notes

- Always load dotfiles path from user settings or default to `/Users/kriscard/.dotfiles`
- Respect existing `dotfiles` CLI script - complement, don't replace
- Focus on intelligent analysis - let user's script handle mechanical operations
- Prioritize security issues always
- Be context-aware - don't over-analyze when user has specific request
- Provide education along with fixes
