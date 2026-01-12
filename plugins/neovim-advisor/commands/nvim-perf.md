---
name: analyze-performance
description: Analyze Neovim startup performance, identify slow plugins, and provide optimization recommendations
argument-hint: "[--detailed]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - AskUserQuestion
  - Task
---

# Analyze Neovim Performance

Profile Neovim startup time, identify bottlenecks, and provide actionable optimization recommendations.

## Task

Run startup profiling, analyze results, identify slow plugins and configurations, and suggest specific optimizations to improve performance.

## Workflow

### 1. Check Prerequisites

Verify Neovim is available:

```bash
which nvim
nvim --version
```

If not found, inform user and exit.

### 2. Ask User Preferences

Use AskUserQuestion to determine analysis scope:

```
Question: "What level of analysis do you want?"
Options:
- "Quick startup time" - Just measure total time
- "Standard profiling" - Startuptime log + basic analysis
- "Deep analysis" - Full profiling + agent analysis + recommendations
```

### 3. Run Startup Profiling

Execute neovim with profiling:

```bash
# Create startup log
nvim --startuptime /tmp/nvim-startup-$(date +%s).log --headless -c 'qa!'

# Store log path for analysis
```

Use Bash tool to run command.

### 4. Analyze Startup Log

Read the startup log and analyze:

**Quick Analysis:**
- Total startup time (last line)
- Compare against targets:
  - Excellent: < 30ms
  - Good: 30-50ms
  - Acceptable: 50-100ms
  - Needs work: > 100ms

**Standard Analysis:**
- Total time
- Top 5 slowest items
- Plugins loading at startup
- Heavy configuration functions

**Deep Analysis:**
- Complete breakdown by phase
- All items > 5ms
- Plugin load reasons
- Suggested optimizations

Use Read tool to parse log file.

### 5. Run Lazy.nvim Profile (if available)

Check if lazy.nvim is installed:

```bash
nvim --headless -c "lua if pcall(require, 'lazy') then print('LAZY_AVAILABLE') end" -c 'qa!' 2>&1
```

If available, suggest running `:Lazy profile` interactively or use agent for analysis.

### 6. Delegate to Performance Analyzer Agent

For deep analysis, use Task tool:

```
Use performance-analyzer agent to:
- Analyze startup log in detail
- Profile lazy.nvim if available
- Identify optimization opportunities
- Generate specific recommendations
```

Agent has access to:
- Read (for config files)
- Bash (for nvim profiling commands)
- Write (for generating reports)

### 7. Identify Bottlenecks

Common bottlenecks to check:

**Heavy init.lua:**
Look for slow sourcing of init.lua (> 5ms)

**Too many startup plugins:**
Count plugins loading at startup vs lazy-loaded

**Slow plugin configs:**
Identify setup() functions taking > 5ms

**Treesitter compilation:**
Check if parsers are compiling at startup

**LSP initialization:**
Check if LSP servers loading immediately

Use Grep and Read to check config files for these patterns.

### 8. Generate Recommendations

Based on findings, provide specific fixes:

**For slow plugins:**
```lua
-- Current (loads at startup)
return {
  "nvim-telescope/telescope.nvim",
}

-- Recommended (lazy-load)
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>" },
  },
}
```

**For heavy configs:**
```lua
-- Current (heavy setup at startup)
return {
  "plugin/name",
  config = function()
    -- Complex setup code
  end,
}

-- Recommended (defer loading)
return {
  "plugin/name",
  event = "VeryLazy",
  config = function()
    -- Same setup, but deferred
  end,
}
```

**For missing priority:**
```lua
-- Current
return {
  "folke/tokyonight.nvim",
  config = function()
    vim.cmd("colorscheme tokyonight")
  end,
}

-- Recommended
return {
  "folke/tokyonight.nvim",
  priority = 1000,  -- Load first!
  config = function()
    vim.cmd("colorscheme tokyonight")
  end,
}
```

### 9. Present Results

Show results in clear format:

```markdown
## Performance Analysis Results

### Startup Time: 45.2ms (Good ✓)

### Performance Breakdown
- Initialization: 3.2ms (7%)
- Plugin loading: 18.5ms (41%)
- Configuration: 15.3ms (34%)
- UI render: 8.2ms (18%)

### Slow Items (> 5ms)
1. telescope.nvim - 12.3ms (loading at startup)
2. nvim-treesitter - 8.9ms (expected, syntax highlighting)
3. lualine.nvim - 5.1ms (acceptable, UI component)

### Optimization Opportunities

**High Priority:**
1. **Lazy-load Telescope** (saves ~12ms)
   - Add cmd and keys triggers
   - Location: lua/plugins/telescope.lua

2. **Defer todo-comments** (saves ~3ms)
   - Add event = "VeryLazy"
   - Location: lua/plugins/todo-comments.lua

**Medium Priority:**
3. **Optimize LSP loading** (saves ~2ms)
   - Load by filetype instead of startup
   - Location: lua/plugins/lsp.lua

### Estimated Improvement
Applying all recommendations: **45ms → 28ms** (38% faster)

Would you like me to apply these optimizations?
```

### 10. Offer Optimizations

If issues found, ask:

```
How would you like to proceed?
- Apply all optimizations automatically
- Show me the changes first (recommended)
- I'll do it manually
- Generate optimization script
```

If user wants changes:
- Show exact file modifications
- Use Edit tool to apply
- Verify syntax is correct
- Recommend re-testing

### 11. Generate Report (Optional)

If --detailed flag or user requests, create markdown report:

```bash
# Write detailed report
```

Use Write tool to create `/tmp/neovim-performance-report-<timestamp>.md`

Report includes:
- Full startup log analysis
- All items with timings
- Plugin-by-plugin breakdown
- Optimization recommendations
- Before/after comparison
- Links to relevant documentation

### 12. Suggest Re-Test

After optimizations:

```
To verify improvements, run:
  nvim --startuptime startup-after.log --headless -c 'qa!'

Or re-run:
  /analyze-performance
```

## Advanced Analysis

### Memory Profiling

If requested, check memory usage:

```bash
nvim --headless -c "lua print('Memory:', collectgarbage('count'), 'KB')" -c 'qa!'
```

### Plugin-Specific Profiling

For specific slow plugin, suggest:

```vim
:Lazy profile  " Interactive UI
```

### Continuous Monitoring

Suggest creating startup benchmark script:

```bash
#!/bin/bash
# benchmark-startup.sh
for i in {1..10}; do
  nvim --startuptime /tmp/startup-$i.log --headless -c 'qa!'
  tail -1 /tmp/startup-$i.log | awk '{print $1}'
done | awk '{sum+=$1; count++} END {print "Average:", sum/count "ms"}'
```

## Tips

- Load lazy-nvim-optimization skill for deep profiling knowledge
- Reference neovim-best-practices for optimization patterns
- Be specific about locations and line numbers
- Show before/after comparisons
- Test recommendations before suggesting

## Settings

Check `.claude/neovim-advisor.local.md` for:
```yaml
---
neovim_path: ~/.config/nvim
performance_target: 40  # Target startup time in ms
---
```

## Example Usage

User: `/analyze-performance`
→ Run profiling
→ Analyze results
→ Show recommendations
→ Offer to optimize

User: `/analyze-performance --detailed`
→ Deep analysis
→ Generate full report
→ Specific recommendations

## Important

- Always create temporary files in /tmp/
- Clean up profiling logs after analysis
- Never modify config without permission
- Verify nvim commands work before running
- Handle errors gracefully (nvim not found, etc.)

Provide actionable, specific performance optimization guidance to help users achieve fast startup times.
