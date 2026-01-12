# Dotfiles Optimizer

Analyze, optimize, and secure your dotfiles with intelligent recommendations for best practices, modern CLI tools, and configuration improvements.

## Features

- **Smart Analysis**: Context-aware optimization focusing on what you're working on
- **Security Validation**: Automatic checks for exposed credentials and insecure configurations
- **Modern Tools**: Recommendations for faster, better CLI alternatives
- **Best Practices**: Guidance on shell config organization and performance
- **Priority System**: Clear classification of critical, recommended, and optional improvements

## Installation

```bash
# Install from marketplace
claude plugin install dotfiles-optimizer

# Or install locally
claude plugin install /path/to/dotfiles-optimizer
```

## Configuration

Create `.claude/dotfiles-optimizer.local.md` to configure:

```yaml
---
dotfiles_path: /Users/yourusername/.dotfiles
default_shell: zsh
enable_proactive_warnings: true
---
```

**Configuration options**:
- `dotfiles_path`: Path to your dotfiles directory (default: `/Users/kriscard/.dotfiles`)
- `default_shell`: Your shell (zsh, bash, fish)
- `enable_proactive_warnings`: Show security warnings when editing configs (default: true)

## Usage

### Natural Language (Skill Orchestrator)

Ask Claude naturally:
- "Optimize my dotfiles"
- "Check my shell configuration"
- "How can I improve my zsh setup?"
- "Audit my dotfiles for security issues"

### Commands

**`/optimize`** - Full optimization workflow
```bash
/optimize              # Analyze entire dotfiles
/optimize zsh          # Focus on zsh configs
/optimize --apply      # Auto-apply fixes
/optimize --security   # Security audit only
```

**`/audit`** - Read-only analysis
```bash
/audit                 # Complete health check
/audit --verbose       # Detailed report
```

## What It Checks

### Security
- ✅ Exposed API keys and tokens
- ✅ Hardcoded passwords
- ✅ Insecure file permissions
- ✅ Credential management patterns

### Performance
- ✅ Shell startup time optimization
- ✅ Lazy loading opportunities
- ✅ Plugin efficiency

### Modern Tools
- ✅ Suggests `eza` instead of `ls`
- ✅ Suggests `bat` instead of `cat`
- ✅ Suggests `fd` instead of `find`
- ✅ Suggests `ripgrep` instead of `grep`
- ✅ Suggests `zoxide` instead of `cd`

### Configuration
- ✅ Modular organization
- ✅ Cross-platform compatibility
- ✅ Best practice patterns
- ✅ Git configuration setup

## Components

- **dotfiles-optimizer** skill: Main orchestrator for intelligent analysis
- **dotfiles-best-practices** skill: Knowledge base for patterns and tools
- **dotfiles-analyzer** agent: Deep analysis and recommendations
- **Security hook**: Validates config changes for exposed credentials

## Example Output

```
🔴 Critical Issues (2)
  - API key detected in .zshrc line 45
  - .gitconfig-work has insecure permissions (644, should be 600)

🟡 Recommended Improvements (5)
  - Use `eza` instead of `ls` for better output
  - Enable lazy loading for nvm (saves 300ms startup time)
  - Modularize .zshrc using zsh.d/ pattern
  - Add .env.example for credential templates
  - Configure git commit signing

🟢 Optional Enhancements (3)
  - Try `starship` prompt for better performance
  - Consider `tmux` plugin manager (tpm)
  - Add bat theme matching your Catppuccin setup
```

## Requirements

- Claude Code CLI
- Access to dotfiles directory
- Bash/Zsh shell environment

## License

MIT License - see LICENSE file for details
