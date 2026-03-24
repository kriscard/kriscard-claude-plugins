---
name: dotfiles-best-practices
disable-model-invocation: true
user-invocable: false
description: >-
  Provides reference knowledge about modern CLI tools, shell optimization patterns,
  and dotfiles security best practices. Make sure to use this skill whenever the
  user asks about shell patterns, modern tool alternatives (eza, bat, fd, ripgrep),
  zsh optimization, or dotfiles conventions. Also loaded automatically by the
  dotfiles-optimizer skill.
version: 0.1.0
---

# Dotfiles Best Practices

Reference knowledge for modern dotfiles configuration, organization, and tooling. Serves as the knowledge base for the dotfiles-optimizer orchestrator.

## User-Specific Decisions

**Theme**: Catppuccin Macchiato across all tools (set via `$THEME_FLAVOUR=macchiato`)

**Shell structure**: Modular `zsh.d/` with numeric prefix load ordering:

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
└── 99-local.zsh         # Local overrides (NOT committed)
```

**Main .zshrc** sources all modules:
```zsh
export ZSH="$HOME/.dotfiles/zsh"

for config_file in "$ZSH/zsh.d"/*.zsh(N); do
  source "$config_file"
done
```

## Reference Files

| File | Contents |
|------|----------|
| [modern-cli-tools.md](references/modern-cli-tools.md) | eza, bat, fd, rg, zoxide, starship, delta, lazygit |
| [shell-performance.md](references/shell-performance.md) | Startup optimization, lazy loading pattern, profiling |
| [security-patterns.md](references/security-patterns.md) | Credentials, file permissions, history security, .gitignore |
| [git-config.md](references/git-config.md) | Multi-identity includeIf, aliases |
| [terminal-config.md](references/terminal-config.md) | Kitty, Ghostty, tmux, neovim, Catppuccin theming |

## Gotchas

- Claude tends to suggest Powerlevel10k over Starship -- this setup uses Starship for cross-shell compat and speed
- NVM lazy loading is critical -- eagerly sourcing nvm.sh adds 200-400ms to startup
- Never alias over system commands unconditionally -- check tool exists first with `command -v`
- The `99-local.zsh` pattern means local overrides are NOT committed -- don't suggest editing them as shared config
- File permissions on `.env` and git config files must be 600, not 644

## Quick Reference

**Performance**: Shell startup <500ms, lazy load version managers, cache completions

**Security**: Never commit secrets, use .env + .env.example pattern, sensitive files chmod 600

**Organization**: Modular numeric-prefix structure, separate concerns, local overrides in 99-local.zsh

**Modern Tools**: eza (ls), bat (cat), fd (find), rg (grep), z (cd) -- check existence before aliasing

**Git**: Multi-config with includeIf, separate personal/work identities, commit signing recommended

**Themes**: Consistent Catppuccin Macchiato across all tools, single `$THEME_FLAVOUR` variable
