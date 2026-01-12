# neovim-advisor

Neovim configuration advisor that helps you maintain an optimal, modern, and performant Neovim setup.

## Features

- **Configuration Validation**: Check your neovim config for best practices, common mistakes, and structural issues
- **Performance Analysis**: Analyze startup time, identify slow plugins, and get optimization recommendations
- **Plugin Recommendations**: Get personalized plugin suggestions based on your workflow or existing configuration
- **LSP Setup**: Interactive LSP configuration for your tech stack
- **Proactive Assistance**: Automatically detects potential issues and suggests improvements

## Commands

- `/check-config` - Validate your Neovim configuration
- `/analyze-performance` - Analyze startup performance and identify bottlenecks
- `/recommend-plugins` - Get plugin recommendations based on workflow or current config
- `/setup-lsp` - Configure LSP servers for your languages

## Installation

### From Marketplace (Recommended)

```bash
claude plugin install neovim-advisor
```

### Local Development

```bash
git clone https://github.com/kriscard/kriscard-claude-plugins.git
cd kriscard-claude-plugins/plugins/neovim-advisor
claude --plugin-dir .
```

## Configuration

Create `.claude/neovim-advisor.local.md` in your project to customize behavior:

```markdown
---
neovim_path: ~/.config/nvim
tech_stack:
  - typescript
  - python
  - rust
plugin_preferences:
  - prefer oil.nvim over nvim-tree
  - use telescope over fzf
validation_rules:
  - enforce lazy-loading
  - no vimscript in config
---

# Neovim Advisor Settings

Add any additional notes or preferences here.
```

### Configuration Options

- **neovim_path**: Path to your Neovim config directory (default: `~/.config/nvim`)
- **tech_stack**: List of languages/frameworks you work with (for LSP recommendations)
- **plugin_preferences**: Your preferred plugins/alternatives
- **validation_rules**: Custom rules to enforce in validation

## Prerequisites

- Neovim 0.9+ (0.10+ recommended)
- lazy.nvim plugin manager (for performance analysis features)

## Usage Examples

### Check Configuration

```bash
/check-config
```

The advisor will ask what you'd like to validate, then analyze your config for:
- Proper file structure
- Plugin syntax and lazy.nvim specs
- Modern best practices
- Common mistakes and issues

### Analyze Performance

```bash
/analyze-performance
```

Get detailed startup profiling with:
- Total startup time breakdown
- Slowest plugins identified
- Specific optimization recommendations

### Get Plugin Recommendations

```bash
/recommend-plugins
```

Choose between:
- **Workflow-based**: Answer questions about your needs, get tailored suggestions
- **Config-based**: Analyze your existing plugins, suggest alternatives and missing essentials

## How It Works

The plugin uses three specialized agents:

1. **config-validator**: Reads and validates your neovim configuration files
2. **plugin-advisor**: Analyzes plugins and suggests improvements (with web access to check latest versions)
3. **performance-analyzer**: Runs neovim headless profiling to identify bottlenecks

All agents provide suggestions only - they never modify your configuration automatically.

## License

MIT

## Author

Chris Cardoso (contact@christophercardoso.dev)
