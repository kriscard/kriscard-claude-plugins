---
name: nvim-plugins
description: "Get personalized plugin recommendations based on workflow or existing configuration analysis. Use when user says '/neovim-advisor:nvim-plugins', wants plugin suggestions, or needs Neovim plugin advice."
disable-model-invocation: true
---

# Recommend Plugins

Provide personalized Neovim plugin recommendations based on user workflow or by analyzing existing configuration.

## Task

Help user discover plugins that enhance their Neovim experience through either workflow-based questions or configuration analysis.

## Workflow

### 1. Determine Recommendation Approach

If argument provided:
- `workflow` - Ask about user's needs and workflow
- `config` - Analyze existing configuration

If no argument, ask user:

```
How should I recommend plugins?
- "Ask about my workflow" - Answer questions to get personalized suggestions
- "Analyze my config" - Review installed plugins and suggest improvements
- "Both" - Comprehensive recommendations
```

Use AskUserQuestion tool.

### 2. Workflow-Based Recommendations

If workflow approach selected:

#### Ask Workflow Questions

Use AskUserQuestion with multiple questions:

**Question 1: Tech Stack**
```
What languages/frameworks do you primarily work with? (select multiple)
- TypeScript/JavaScript
- Python
- Rust
- Go
- Other (specify)
```

**Question 2: Development Focus**
```
What type of development do you do most?
- Web frontend (React, Vue, etc.)
- Backend/API development
- Systems programming
- Data science/ML
- DevOps/Infrastructure
- General purpose
```

**Question 3: Existing Tools**
```
What tools do you currently use?
- Git (GitHub, GitLab, etc.)
- Docker/Kubernetes
- Databases (which ones?)
- Cloud platforms (AWS, GCP, Azure)
- Testing frameworks
```

**Question 4: Workflow Preferences**
```
What features are most important to you?
- Fast fuzzy finding
- Git integration
- Debugging capabilities
- AI assistance (Copilot, ChatGPT)
- Note-taking/documentation
- Terminal integration
```

#### Generate Recommendations

Based on answers, recommend relevant plugins:

**For TypeScript/JavaScript:**
- typescript-tools.nvim (better than tsserver)
- package-info.nvim (show package versions)
- nvim-ts-autotag (auto-close JSX tags)

**For Python:**
- nvim-dap-python (debugging)
- venv-selector.nvim (virtual environment)
- neotest-python (testing)

**For Rust:**
- rust-tools.nvim or rustaceanvim
- crates.nvim (Cargo.toml management)

**For Git workflows:**
- diffview.nvim (PR reviews)
- octo.nvim (GitHub integration)
- git-conflict.nvim (merge conflict resolution)

**For AI assistance:**
- copilot.lua + copilot-cmp
- ChatGPT.nvim
- codeium.nvim (free alternative)

**For note-taking:**
- obsidian.nvim (Obsidian integration)
- neorg (Neovim-native)
- markdown-preview.nvim

Present recommendations with:
- Plugin name and URL
- Why it's relevant to their workflow
- Installation snippet
- Basic configuration example

### 3. Config-Based Recommendations

If config analysis approach selected:

#### Locate Configuration

Use same logic as check-config:
1. Check argument path
2. Check settings file
3. Default to ~/.config/nvim

#### Analyze Installed Plugins

Read lazy.nvim lock file and plugin specs:

```bash
# Check lazy-lock.json
cat ~/.config/nvim/lazy-lock.json
```

Or read plugin files:

```lua
-- Read lua/plugins/*.lua files
```

Use Read and Glob tools.

#### Identify Plugin Categories

Categorize existing plugins:
- Plugin manager: lazy.nvim, packer, etc.
- LSP/Completion: lspconfig, cmp, etc.
- Syntax: treesitter
- UI: lualine, bufferline, etc.
- File navigation: telescope, nvim-tree, etc.
- Git: gitsigns, fugitive, etc.
- Editing: autopairs, surround, etc.

#### Find Gaps and Improvements

Check for missing categories:
- [ ] Fuzzy finder (telescope or fzf-lua)
- [ ] File explorer (oil, nvim-tree, or neo-tree)
- [ ] Git interface (lazygit, neogit, or fugitive)
- [ ] Debugging (nvim-dap)
- [ ] Testing (neotest)
- [ ] Terminal (toggleterm)
- [ ] Session management
- [ ] AI assistance

For each installed plugin, check:
- Is there a better/more modern alternative?
- Is it actively maintained?
- Are there complementary plugins?

#### Delegate to Plugin Advisor Agent

For deep analysis, use Task tool:

```
Use plugin-advisor agent to:
- Analyze installed plugins
- Check for outdated plugins
- Suggest modern alternatives
- Recommend complementary tools
- Identify unused plugins
```

Agent has web access to check:
- GitHub stars/activity
- Latest releases
- Community recommendations

### 4. Present Recommendations

Show results in organized format:

```markdown
## Plugin Recommendations

### Essential Missing Plugins

**1. nvim-dap (Debugging)**
- Why: You're using TypeScript but have no debugger
- URL: https://github.com/mfussenegger/nvim-dap
- Setup:
  ```lua
  return {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end },
    },
  }
  ```

**2. neotest (Testing)**
- Why: Run tests directly in Neovim
- URL: https://github.com/nvim-neotest/neotest
- With: neotest-jest for TypeScript testing
- Setup:
  ```lua
  return {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
  }
  ```

### Upgrade Opportunities

**1. Replace nvim-tree with oil.nvim**
- Why: Edit filesystem like a buffer, more intuitive
- Current: nvim-tree.lua
- Recommended: stevearc/oil.nvim
- Migration: Easy, similar keybindings available

**2. Add telescope-fzf-native.nvim**
- Why: 10x faster sorting for telescope
- Complement to: Your existing telescope setup
- Setup:
  ```lua
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  }
  ```

### Workflow Enhancements

**For Git workflow:**
- diffview.nvim - Better diff viewing
- octo.nvim - Manage PRs from Neovim
- git-conflict.nvim - Easier merge conflict resolution

**For TypeScript development:**
- typescript-tools.nvim - Better performance than tsserver
- package-info.nvim - See package versions inline
- nvim-ts-autotag - Auto-close JSX tags

### Performance Optimizations

**Plugins to lazy-load:**
1. todo-comments.nvim - Add `event = "VeryLazy"`
2. gitsigns.nvim - Already optimized ✓
3. telescope.nvim - Add cmd/keys triggers

Would you like me to:
- Install these plugins?
- Show detailed setup for any plugin?
- Generate a complete installation script?
```

### 5. Provide Installation Help

If user wants to install, offer options:

```
How would you like to proceed?
- Add one plugin at a time (I'll guide you)
- Generate lazy.nvim specs for all recommendations
- Create installation script
- Just show me the list (I'll install manually)
```

#### For Interactive Installation

Guide user through adding each plugin:

1. Create plugin file
2. Add configuration
3. Explain setup
4. Test installation

Use Write tool to create files.

#### For Batch Installation

Generate all plugin specs in one file:

```lua
-- lua/plugins/recommended.lua
return {
  -- All recommended plugins
}
```

### 6. Load Reference Knowledge

Reference neovim-best-practices skill for:
- Plugin recommendation list
- Installation patterns
- Configuration examples

## Advanced Features

### Check Plugin Compatibility

For each recommendation, verify:
- Neovim version compatibility
- No conflicts with existing plugins
- Dependencies available

### Personalization from Settings

Check `.claude/neovim-advisor.local.md`:

```yaml
---
tech_stack:
  - typescript
  - python
plugin_preferences:
  - prefer oil.nvim over nvim-tree
  - use telescope not fzf
---
```

Respect user preferences in recommendations.

### Community Trends

Use WebFetch to check:
- awesome-neovim repository
- Reddit r/neovim discussions
- This Week in Neovim
- GitHub trending

Mention trending/new plugins when relevant.

## Example Recommendations by Profile

### Web Developer Profile
- typescript-tools.nvim (LSP)
- package-info.nvim (dependencies)
- nvim-ts-autotag (JSX)
- rest.nvim (API testing)
- tailwindcss-colorizer-cmp.nvim

### Python Data Scientist
- nvim-dap-python (debugging)
- jupyter-kernel.nvim (notebooks)
- molten-nvim (inline execution)
- venv-selector.nvim (environments)

### Systems Programmer
- rust-tools.nvim or rustaceanvim
- go.nvim (Go development)
- cmake-tools.nvim (C/C++)
- dap configurations for native debugging

### DevOps Engineer
- kubernetes.nvim
- yaml-companion.nvim
- helm.nvim
- terraform.nvim

## Tips

- Always explain WHY a plugin is recommended
- Show working configuration snippets
- Link to official documentation
- Mention alternatives for transparency
- Consider user's existing setup
- Respect performance (don't over-recommend)

## Important

- Never install plugins without user consent
- Verify URLs before sharing
- Check plugin is maintained (updated recently)
- Warn about experimental/alpha plugins
- Suggest trying one plugin at a time

Help users discover tools that genuinely improve their workflow without overwhelming them.
