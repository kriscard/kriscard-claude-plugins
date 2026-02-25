---
name: dotfiles-best-practices
description: >-
  Provides reference knowledge about modern CLI tools, shell optimization
  patterns, and dotfiles security best practices. Loaded automatically by the
  dotfiles-optimizer skill when detailed best-practice context is needed. Use
  when the user asks about specific shell patterns, modern tool alternatives
  (eza, bat, fd, ripgrep), or dotfiles conventions.
version: 0.1.0
---

# Dotfiles Best Practices

Essential knowledge for modern dotfiles configuration, organization, and tooling.

## Purpose

Provide reference knowledge about dotfiles best practices, modern CLI tools, security patterns, and performance optimization. This skill serves as a knowledge base for the dotfiles-optimizer orchestrator and can be referenced directly when users ask about specific best practices.

## Modern CLI Tools

### Core Replacements

Use these modern alternatives for better performance and user experience:

**eza (replaces ls)**
- **Benefit**: Git integration, icons, better formatting
- **Configuration**: `alias ls='eza --icons --group-directories-first'`
- **Advanced**: `alias ll='eza -lah --icons --git'` shows git status inline
- **Why**: 3-5x faster, colored output, tree view built-in

**bat (replaces cat)**
- **Benefit**: Syntax highlighting, line numbers, git integration
- **Configuration**: `alias cat='bat --paging=never'`
- **Theme**: Match terminal theme (e.g., Catppuccin)
- **Why**: Readable code viewing, integrated pager

**fd (replaces find)**
- **Benefit**: 5-10x faster, simpler syntax, respects .gitignore
- **Usage**: `fd pattern` instead of `find . -name "pattern"`
- **Configuration**: `alias find='fd'` for transparent replacement
- **Why**: Intuitive defaults, parallel execution

**ripgrep (replaces grep)**
- **Benefit**: 10-100x faster, respects .gitignore, multi-line search
- **Usage**: `rg pattern` instead of `grep -r pattern`
- **Configuration**: Use config file at `~/.config/ripgrep/ripgreprc`
- **Why**: Blazing speed, smart defaults

**zoxide (replaces cd)**
- **Benefit**: Frecency-based jumping, interactive selection
- **Setup**: `eval "$(zoxide init zsh)"`
- **Usage**: `z project` jumps to frequently used directory
- **Why**: Eliminates repetitive directory navigation

### Additional Modern Tools

**starship** - Fast, customizable prompt
- Cross-shell compatible (zsh, bash, fish)
- 10-50x faster than Powerlevel10k
- Minimal configuration with great defaults

**delta** - Better git diffs
- Syntax highlighting for diffs
- Side-by-side comparison
- Integrates with bat themes

**lazygit** - Terminal UI for git
- Visual interface for complex operations
- Keyboard-driven workflow
- Better than raw git for interactive work

## Shell Performance Optimization

### Startup Time Best Practices

**Target**: Shell startup <500ms

**Key strategies**:

1. **Lazy loading for version managers**:
   - NVM loading eagerly adds 200-400ms
   - Defer loading until `node`, `npm`, or `nvm` is called
   - Pattern: Unfunction wrapper that loads on first use

2. **Selective completion loading**:
   - Only load completions for installed tools
   - Check with `[[ -x "$(command -v tool)" ]]` before loading
   - Cache completion dumps for 24 hours

3. **Plugin optimization**:
   - Audit plugins quarterly, remove unused
   - Use plugin managers with lazy loading (zinit, zplug)
   - Prefer native functions over plugins when possible

4. **PATH management**:
   - Check for duplicates: `echo $PATH | tr ':' '\n' | sort | uniq -d`
   - Use functions to add paths uniquely
   - Keep PATH minimal, use absolute paths when possible

### Lazy Loading Pattern

```zsh
# Generic lazy loader
lazy_load() {
  local cmd=$1
  local load_cmd=$2

  eval "$cmd() {
    unfunction $cmd
    $load_cmd
    $cmd \"\$@\"
  }"
}

# Usage for NVM
lazy_load nvm 'export NVM_DIR="$HOME/.nvm"; source "$NVM_DIR/nvm.sh"'
lazy_load node 'export NVM_DIR="$HOME/.nvm"; source "$NVM_DIR/nvm.sh"'
lazy_load npm 'export NVM_DIR="$HOME/.nvm"; source "$NVM_DIR/nvm.sh"'
```

### Profiling Tools

```bash
# Measure total startup time
time zsh -i -c exit

# Detailed profiling (add to .zshrc temporarily)
zmodload zsh/zprof
# ... rest of config ...
zprof  # Shows function call times
```

## Configuration Organization

### Modular Structure Pattern

Organize shell configuration by concern with load-order prefixes:

```
zsh/zsh.d/
├── 00-env.zsh           # Environment variables, PATH
├── 10-options.zsh       # Shell options (setopt)
├── 20-completions.zsh   # Completion system
├── 30-plugins.zsh       # Plugin loading
├── 40-lazy.zsh          # Lazy loading functions
├── 50-keybindings.zsh   # Key bindings
├── 60-aliases.zsh       # Command aliases
├── 70-functions.zsh     # Custom functions
├── 80-integrations.zsh  # External tool integrations
└── 99-local.zsh         # Local overrides (not committed)
```

**Benefits**:
- Easy to locate specific configurations
- Clear load order
- Can disable modules by renaming (`.zsh.disabled`)
- Separates concerns cleanly

**Main .zshrc**:
```zsh
export ZSH="$HOME/.dotfiles/zsh"

for config_file in "$ZSH/zsh.d"/*.zsh(N); do
  source "$config_file"
done
```

### Version Control Best Practices

**What to commit**:
- Configuration templates
- Scripts and functions
- Plugin lists
- `.env.example` files

**What NOT to commit**:
- Secrets (.env, tokens)
- Local overrides (99-local.zsh)
- Machine-specific paths
- Cache files (.zcompdump)

**.gitignore patterns**:
```gitignore
# Secrets
.env
*_token
*_secret
*_key

# Local overrides
**/99-local.zsh
**/*.local.*

# Cache
*.zwc
.zcompdump*
.DS_Store
```

## Security Patterns

### Credential Management

**Never hardcode credentials**:
```zsh
# ❌ BAD
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"

# ✅ GOOD
# In .env (not committed)
GITHUB_TOKEN=ghp_xxxxxxxxxxxx

# In 99-local.zsh (not committed)
[ -f "$HOME/.dotfiles/.env" ] && source "$HOME/.dotfiles/.env"
```

**Use .env.example pattern**:
```bash
# .env.example (committed as template)
GITHUB_TOKEN=ghp_your_token_here
OPENAI_API_KEY=sk-your_key_here
AWS_ACCESS_KEY_ID=your_access_key
```

### File Permissions

**Sensitive files should be 600** (user read/write only):
- `.gitconfig-work`, `.gitconfig-personal` (if containing tokens)
- `.env` files
- `.ssh/config`
- `.netrc`, `.authinfo`

```bash
chmod 600 ~/.dotfiles/.gitconfig-work
```

### History Security

**Prevent sensitive commands in history**:
```zsh
# In zsh.d/10-options.zsh
setopt HIST_IGNORE_SPACE  # Commands starting with space aren't logged

# Exclude patterns (zsh 5.3+)
HISTORY_IGNORE="(ls|cd|pwd|exit|clear)*"
```

**Usage**: Prefix sensitive commands with space
```bash
# Not logged due to leading space
 export API_KEY=secret
```

## Git Configuration Patterns

### Multi-Config Strategy

Separate personal and work configurations:

**Main .gitconfig**:
```gitconfig
[user]
    name = Chris Cardoso

[includeIf "gitdir:~/personal/"]
    path = ~/.dotfiles/.gitconfig-personal

[includeIf "gitdir:~/work/"]
    path = ~/.dotfiles/.gitconfig-work

[core]
    editor = nvim
    pager = delta

[init]
    defaultBranch = main
```

**Personal config** (`.gitconfig-personal`):
```gitconfig
[user]
    email = contact@christophercardoso.dev
    signingkey = PERSONAL_GPG_KEY

[commit]
    gpgsign = true
```

**Work config** (`.gitconfig-work`):
```gitconfig
[user]
    email = chris.cardoso@company.com
    signingkey = WORK_GPG_KEY

[commit]
    gpgsign = true
```

**Benefits**:
- Automatic email switching based on directory
- Different signing keys for personal vs work
- Easy to manage separate identities

### Useful Git Aliases

```gitconfig
[alias]
    # Status and logs
    st = status -sb
    lg = log --graph --oneline --decorate --all
    last = log -1 HEAD --stat

    # Quick operations
    co = checkout
    cob = checkout -b
    cm = commit -m
    ca = commit --amend

    # Undo
    undo = reset HEAD~1 --soft
    unstage = reset HEAD --

    # Cleanup
    prune = fetch --prune
    clean-merged = !git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d
```

## Theme Consistency

### Catppuccin Integration

Maintain consistent theming across all tools:

**Supported tools**:
- Terminal (Kitty, Ghostty, iTerm2)
- Bat (syntax highlighting)
- Tmux
- Neovim
- Starship (prompt)
- Delta (git diffs)

**Configuration pattern**:
```zsh
# In zsh.d/00-env.zsh
export THEME_FLAVOUR=macchiato  # or frappe, latte, mocha

# Bat
export BAT_THEME="Catppuccin Macchiato"

# Ensure all tools reference $THEME_FLAVOUR
```

**Benefits**:
- Consistent visual experience
- Single variable to change entire theme
- Reduces eye strain with cohesive colors

## Tmux Best Practices

### Plugin Management

Use TPM (Tmux Plugin Manager):

```tmux
# In tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'catppuccin/tmux'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Initialize TPM (keep at bottom)
run '~/.tmux/plugins/tpm/tpm'
```

### Sensible Defaults

```tmux
# Use Ctrl-a as prefix (easier than Ctrl-b)
set -g prefix C-a
unbind C-b

# Start windows at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Vi mode
setw -g mode-keys vi

# Mouse support
set -g mouse on

# Faster escape time (for Vim)
set -s escape-time 0

# Increase scrollback
set -g history-limit 10000
```

## Neovim Configuration

### Lua-Based Modern Config

Use Lazy.nvim for plugin management:

```lua
-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
```

### LSP Setup

Modern LSP configuration with Mason:

```lua
-- In plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "tsserver", "pyright" }
    })
  end
}
```

## Terminal Configuration

### Kitty Best Practices

```conf
# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes

# Font (with ligatures)
font_family JetBrains Mono
font_size 14.0

# Theme
include catppuccin-macchiato.conf

# Tabs
tab_bar_style powerline
tab_powerline_style slanted
```

### Ghostty Best Practices

```conf
# Theme
theme = catppuccin-macchiato

# Font
font-family = "JetBrains Mono"
font-size = 14

# Performance
window-padding-x = 10
window-padding-y = 10

# Shell integration
shell-integration = true
```

## Additional Resources

### Reference Files

For detailed patterns and implementation:
- **Example configurations in your actual dotfiles**: `/Users/kriscard/.dotfiles`
- **Modern tool documentation**: Check official sites for latest features

### Related Skills

- **dotfiles-optimizer**: Main orchestrator that uses this knowledge
- **dotfiles-analyzer**: Agent that applies these patterns in analysis

## Quick Reference

**Performance**:
- Shell startup <500ms
- Lazy load version managers
- Cache completions

**Security**:
- Never commit secrets
- Use .env + .env.example pattern
- Sensitive files chmod 600

**Organization**:
- Modular structure with numeric prefixes
- Separate concerns (env, options, aliases, functions)
- Local overrides in 99-local.zsh

**Modern Tools**:
- eza (ls), bat (cat), fd (find), rg (grep), z (cd)
- Configure with dotfiles for consistency
- Check existence before aliasing

**Git**:
- Multi-config with includeIf
- Separate personal/work identities
- Commit signing recommended

**Themes**:
- Consistent across all tools
- Single $THEME_FLAVOUR variable
- Catppuccin integration recommended
