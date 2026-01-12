---
name: dotfiles-optimize
description: Comprehensive dotfiles optimization workflow - analyze configurations, recommend improvements, and apply fixes
argument-hint: "[component] [--apply] [--security|--performance|--modern-tools]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "AskUserQuestion", "Skill"]
---

# Optimize Dotfiles Command

Run comprehensive dotfiles optimization workflow: analyze configurations, identify issues, recommend improvements, and optionally apply fixes.

## Arguments

**Component Scope** (optional, positional):
- `zsh` - Analyze shell configuration only
- `tmux` - Analyze tmux configuration only
- `nvim` - Analyze Neovim configuration only
- `git` - Analyze git configuration only
- `terminal` - Analyze terminal configs (Kitty/Ghostty) only
- `all` or omitted - Analyze entire dotfiles structure

**Flags** (optional):
- `--apply` - Automatically apply recommended fixes without confirmation
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

## Workflow

Execute this complete optimization workflow:

### 1. Parse Arguments and Determine Scope

Parse command arguments to determine:
- **Component scope**: Which components to analyze (from positional argument or default to all)
- **Focus area**: Security, performance, modern-tools, or comprehensive (from flags)
- **Auto-apply mode**: Whether `--apply` flag is present

Load user configuration from `.claude/dotfiles-optimizer.local.md`:
- Read file if exists
- Extract `dotfiles_path` from frontmatter (default: `/Users/kriscard/.dotfiles`)
- Check `enable_proactive_warnings` setting

### 2. Invoke Dotfiles-Optimizer Skill

Activate the `dotfiles-optimizer` skill using the Skill tool:
- Pass determined scope and focus area
- Skill will orchestrate the analysis workflow
- Skill invokes dotfiles-analyzer agent
- Skill references dotfiles-best-practices for context

The skill handles:
- Calling dotfiles-analyzer agent for deep analysis
- Organizing findings into priority levels (🔴 Critical, 🟡 Recommended, 🟢 Optional)
- Providing context and rationale from best-practices skill
- Generating actionable recommendations

### 3. Present Findings

Display analysis results in prioritized format:

```
## Optimization Results for [Scope]

🔴 Critical Issues (N)
  1. [Issue with location and fix]
  2. [Issue with location and fix]

🟡 Recommended Improvements (N)
  1. [Improvement with rationale]
  2. [Improvement with rationale]

🟢 Optional Enhancements (N)
  1. [Enhancement with description]
  2. [Enhancement with description]
```

### 4. Apply Fixes

**If `--apply` flag is present**:
- Apply all critical issues automatically
- Apply all recommended improvements automatically
- Skip optional enhancements (user can request separately)
- Show progress for each fix applied
- Create backups before modifying files

**If `--apply` flag is NOT present**:
- Ask user which fixes to apply using AskUserQuestion tool:
  - "All critical issues (recommended)"
  - "All recommended improvements"
  - "Let me choose specific items"
  - "None (just wanted the analysis)"

**Applying fixes**:
For each fix to apply:
1. Use Read tool to examine current configuration
2. Use Edit tool to make precise changes (prefer Edit over Write)
3. Explain what's being changed and why
4. For file creation, use Write tool
5. For permission changes, use Bash tool: `chmod 600 file`
6. Validate changes don't break syntax

**Backup strategy**:
Before modifying files:
```bash
# Create backup with timestamp
cp ~/.dotfiles/.zshrc ~/.dotfiles/.zshrc.backup.$(date +%Y%m%d-%H%M%S)
```

### 5. Verify Changes

After applying fixes:
- Test critical configurations (e.g., shell syntax with `zsh -n file`)
- Measure performance improvements if applicable (startup time)
- Confirm security issues resolved
- Provide summary of changes made

### 6. Integration with Existing Dotfiles CLI

The user has a `dotfiles` CLI script at `/Users/kriscard/.dotfiles/dotfiles`.

**After optimization, suggest**:
- If files were modified: `dotfiles sync` to apply changes
- For system-wide updates: `dotfiles init` to reinstall
- For backups: User's script handles this (`dotfiles backup`)

**Do NOT**:
- Duplicate functionality of user's script
- Suggest reinventing their automation
- Override their installation workflow

**Focus on**:
- Configuration analysis and optimization
- Intelligent recommendations
- Precise file edits
- Let their script handle mechanical operations

## Focus Area Details

**Security Focus** (`--security`):
- Scan for exposed credentials (API keys, tokens, passwords)
- Check file permissions on sensitive files
- Validate `.gitignore` patterns
- Review history security settings
- Check for secure credential management patterns

**Performance Focus** (`--performance`):
- Profile shell startup time
- Identify lazy loading opportunities
- Check completion caching
- Review plugin efficiency
- Measure before/after improvements

**Modern Tools Focus** (`--modern-tools`):
- Validate modern CLI tools (eza, bat, fd, rg, zoxide)
- Check if tools are installed
- Verify proper aliasing
- Recommend additional tools
- Validate configurations

## Examples by Use Case

**Quick Security Audit**:
```bash
/optimize --security
```
Scans all configs for security issues, presents findings, asks about fixes.

**Shell Performance Optimization**:
```bash
/optimize zsh --performance
```
Profiles shell startup, identifies bottlenecks, suggests lazy loading.

**Auto-Fix Critical Issues**:
```bash
/optimize --security --apply
```
Finds and automatically fixes all security vulnerabilities.

**Comprehensive Analysis and Selective Fixes**:
```bash
/optimize
```
Full analysis, user chooses which fixes to apply interactively.

**Modern Tool Setup**:
```bash
/optimize --modern-tools
```
Validates modern CLI tool installation and configuration.

## Tips

**For Users**:
- Run `/optimize` periodically for maintenance
- Use `--security` before committing changes
- Use `--performance` if shell feels slow
- Try `--apply` for quick fixes of obvious issues
- Use scope (zsh, tmux, etc.) to focus on specific components

**For Implementation**:
- Always prioritize security issues
- Be specific with file paths and line numbers
- Provide exact commands for fixes
- Explain why changes help (educational)
- Respect existing user automation (dotfiles script)
- Use Edit tool for modifications (precise)
- Create backups before changes
- Test configurations after modifications

## Error Handling

**If dotfiles path doesn't exist**:
- Check configured path in `.claude/dotfiles-optimizer.local.md`
- Try default `/Users/kriscard/.dotfiles`
- If neither exists, report error and suggest configuration

**If component not found**:
- Report which component is missing
- Continue with available components
- Don't fail entire command

**If syntax error after changes**:
- Restore from backup immediately
- Report error to user
- Explain what went wrong

**If permission denied**:
- Suggest using sudo if appropriate
- Check file ownership
- Provide manual fix instructions

## Notes

- This command is a shortcut to the dotfiles-optimizer skill
- Main workflow is handled by skill orchestrator
- Command adds argument parsing and apply logic
- User can also trigger workflow via natural language (skill activation)
- Integrates with user's existing `dotfiles` CLI script
- Focus on analysis and intelligent fixes, not mechanical operations
