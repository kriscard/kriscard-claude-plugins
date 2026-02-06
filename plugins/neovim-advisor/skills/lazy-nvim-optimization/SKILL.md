---
name: Lazy.nvim Optimization
description: "Neovim/lazy.nvim: Use ONLY for lazy.nvim specific issues - startup profiling, lazy-loading specs, plugin priorities. For general Neovim, use neovim-best-practices."
version: 0.1.0
---

# Lazy.nvim Optimization

Optimize Neovim startup time and runtime performance through effective lazy-loading strategies and plugin configuration with lazy.nvim.

## Understanding Startup Performance

Neovim startup involves several phases:

1. **Initialization** - Load init.lua, set options
2. **Plugin loading** - Load plugin managers and plugins
3. **Plugin configuration** - Run setup() functions
4. **UI render** - Display first buffer

**Target startup times:**
- Excellent: < 30ms
- Good: 30-50ms
- Acceptable: 50-100ms
- Needs optimization: > 100ms

Measure with:
```bash
nvim --startuptime startup.log
```

## Lazy-Loading Strategies

### When to Lazy-Load

**Always lazy-load:**
- File explorers (cmd: "NvimTreeToggle")
- Git interfaces (cmd: "Neogit", "LazyGit")
- Debuggers (keys for debug actions)
- Language-specific plugins (ft: "rust", "go")
- Tools used occasionally (cmd or keys)

**Don't lazy-load:**
- Colorschemes (priority: 1000)
- nvim-treesitter (needed for syntax immediately)
- Core UI (statusline, which-key if showing on startup)
- LSP base setup (though servers can lazy-load by filetype)

**Conditionally lazy-load:**
- Completion (event: "InsertEnter")
- Git decorations (event: "BufReadPost")
- Auto-pairs (event: "InsertEnter")
- Telescope (cmd: "Telescope" or keys)

### Loading Triggers

#### By Command

Load when command is first used:

```lua
{
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
}
```

**Use for:** Plugins with clear command interfaces

**Multiple commands:**
```lua
cmd = { "Telescope", "Tele" }
```

#### By Keymap

Load when keymap is pressed:

```lua
{
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
  },
}
```

**Use for:** Plugins accessed via keybindings

**Complex keymaps:**
```lua
keys = {
  { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep", mode = "n" },
}
```

#### By Filetype

Load for specific file types:

```lua
{
  "rust-lang/rust.vim",
  ft = { "rust" },
}
```

**Use for:** Language-specific tooling

**Multiple filetypes:**
```lua
ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
```

#### By Event

Load on Neovim events:

```lua
{
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
}
```

**Common events:**
- `VeryLazy` - After startup complete (defer non-critical plugins)
- `BufReadPost` - After opening a buffer
- `BufNewFile` - When creating new file
- `InsertEnter` - Entering insert mode
- `CmdlineEnter` - Opening command line
- `LspAttach` - When LSP attaches

**Multiple events:**
```lua
event = { "BufReadPost", "BufNewFile" }
```

#### Lazy Flag

Prevent automatic loading:

```lua
{
  "nvim-lua/plenary.nvim",
  lazy = true,  -- Only load when required as dependency
}
```

**Use for:** Dependency-only plugins

## Optimization Patterns

### Pattern 1: Telescope with FZF Native

```lua
{
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    telescope.load_extension("fzf")
  end,
}
```

**Key optimizations:**
- Lazy-load on cmd and keys
- FZF native for faster sorting
- plenary.nvim loads automatically as dependency

### Pattern 2: LSP with Filetype Loading

```lua
{
  "neovim/nvim-lspconfig",
  ft = { "lua", "python", "typescript", "rust" },  -- Load only for these filetypes
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Configure LSP servers
  end,
}
```

**Alternative:** Load on `LspAttach` event

### Pattern 3: Completion on Insert

```lua
{
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",  -- Load when entering insert mode
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    require("cmp").setup({})
  end,
}
```

**Optimization:** No startup cost, only loads when actually needed

### Pattern 4: Deferred UI Enhancement

```lua
{
  "folke/todo-comments.nvim",
  event = "VeryLazy",  -- Defer until after startup
  config = function()
    require("todo-comments").setup({})
  end,
}
```

**Use for:** Nice-to-have features that aren't immediately visible

### Pattern 5: Conditional Loading

```lua
{
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  cond = function()
    return vim.fn.executable("node") == 1  -- Only if Node.js available
  end,
}
```

**Use for:** Plugins with external dependencies

## Profiling Tools

### Built-in Profiling

**Startup time:**
```bash
nvim --startuptime startup.log
# View with: nvim startup.log
```

**Lazy.nvim profile:**
```vim
:Lazy profile
```

Shows:
- Load time per plugin
- Total time
- Event triggers

### Analyzing Startup Log

Look for:
1. **Slow sourcing** - Files taking > 10ms
2. **Plugin init** - Plugins loading at startup
3. **Heavy configs** - setup() taking > 5ms

**Example analysis:**
```
020.123  000.050: sourcing ~/.config/nvim/init.lua
025.456  005.333: require('plugins.telescope')  ← Too slow!
030.789  005.333: setup telescope               ← Should be deferred
```

**Fix:** Lazy-load telescope with cmd or keys

### Common Bottlenecks

**Problem 1: Loading all plugins at startup**
```lua
-- Bad
return {
  "plugin/name",
}

-- Good
return {
  "plugin/name",
  cmd = "PluginCommand",
}
```

**Problem 2: Heavy setup() at startup**
```lua
-- Bad
return {
  "plugin/name",
  config = function()
    -- Runs at startup!
    require("plugin").setup({
      -- Heavy configuration
    })
  end,
}

-- Good
return {
  "plugin/name",
  event = "VeryLazy",  -- Defer setup
  config = function()
    require("plugin").setup({})
  end,
}
```

**Problem 3: Synchronous operations**
```lua
-- Bad
vim.fn.system("git status")  -- Blocks startup

-- Good
vim.defer_fn(function()
  vim.fn.system("git status")
end, 100)  -- Defer 100ms
```

## Performance Checklist

**Startup optimization:**
- [ ] Colorscheme has `priority = 1000`
- [ ] Only essential plugins load at startup
- [ ] File explorers load on cmd/keys
- [ ] Git interfaces load on cmd/keys
- [ ] Completion loads on `InsertEnter`
- [ ] Language plugins load on filetype
- [ ] UI enhancements load on `VeryLazy`

**Runtime optimization:**
- [ ] Telescope uses fzf-native extension
- [ ] Treesitter parsers installed only for used languages
- [ ] LSP servers only for filetypes you use
- [ ] Heavy plugins have lazy-loading
- [ ] No plugins duplicating built-in 0.10+ features

**Config optimization:**
- [ ] No synchronous system calls at startup
- [ ] setup() functions only run when plugins load
- [ ] No heavy computation in init.lua
- [ ] Keymaps defined with plugin lazy-loading
- [ ] Auto-commands use specific events, not "*"

## Lazy.nvim Features

### Lockfile

Lazy.nvim maintains `lazy-lock.json`:

```json
{
  "telescope.nvim": {
    "branch": "master",
    "commit": "abc123"
  }
}
```

**Benefits:**
- Reproducible plugin versions
- Controlled updates
- Easy rollback

**Workflow:**
```vim
:Lazy update     " Update all plugins
:Lazy restore    " Restore to lockfile versions
```

**Commit lockfile to version control**

### Profile View

Access with `:Lazy profile`:

Shows:
- Load time per plugin
- Load reason (cmd, keys, event)
- Total startup time

**Use to identify:**
- Plugins loading unnecessarily
- Slow plugin configurations
- Missing lazy-loading opportunities

### Lazy Commands

```vim
:Lazy              " Open UI
:Lazy update       " Update all plugins
:Lazy sync         " Install missing + update + clean
:Lazy clean        " Remove unused plugins
:Lazy profile      " Show startup profile
:Lazy log          " Show recent changes
:Lazy restore      " Restore to lockfile
```

## Advanced Techniques

### Lazy-Load LSP Servers by Filetype

Instead of loading all LSP at once:

```lua
-- Create filetype-specific LSP files
-- lua/plugins/lsp-lua.lua
return {
  "neovim/nvim-lspconfig",
  ft = "lua",
  config = function()
    require("lspconfig").lua_ls.setup({})
  end,
}

-- lua/plugins/lsp-typescript.lua
return {
  "neovim/nvim-lspconfig",
  ft = { "typescript", "javascript" },
  config = function()
    require("lspconfig").tsserver.setup({})
  end,
}
```

**Benefit:** LSP only loads for languages you actually edit

### Smart Event Combinations

```lua
{
  "plugin/name",
  event = { "BufReadPost", "BufNewFile" },
  cond = function()
    -- Additional condition
    return vim.fn.argc() > 0  -- Only if files provided
  end,
}
```

### Lazy-Load UI Enhancements

```lua
{
  "folke/noice.nvim",
  event = "VeryLazy",
  init = function()
    -- Set options before plugin loads
    vim.o.cmdheight = 0
  end,
  config = function()
    require("noice").setup({})
  end,
}
```

## Troubleshooting Slow Startups

### Step 1: Measure Baseline

```bash
nvim --startuptime startup.log
```

Check total time at bottom of log.

### Step 2: Identify Slow Plugins

Look for entries > 10ms:
```
050.123  015.000: require('plugins.slow-plugin')
```

### Step 3: Add Lazy-Loading

For each slow plugin, add appropriate trigger:
- cmd for command-based plugins
- keys for keymap-based plugins
- ft for language-specific plugins
- event for everything else

### Step 4: Verify Improvement

```bash
nvim --startuptime startup-after.log
```

Compare total times.

### Step 5: Use Lazy Profile

```vim
:Lazy profile
```

Verify plugins only load when expected.

## Additional Resources

### Reference Files

For detailed information, consult:
- **`references/lazy-loading-decision-tree.md`** - Decision tree for choosing lazy-loading strategy
- **`references/profiling-guide.md`** - Advanced profiling techniques

### Example Files

Working examples in `examples/`:
- **`optimized-config.lua`** - Complete optimized lazy.nvim configuration

## Quick Reference

**Loading triggers:**
- `cmd` - Load on command
- `keys` - Load on keymap
- `ft` - Load on filetype
- `event` - Load on Neovim event
- `lazy = true` - Never auto-load

**Events for deferred loading:**
- `VeryLazy` - After startup (defer non-critical plugins)
- `BufReadPost` - After opening buffer
- `InsertEnter` - Entering insert mode
- `LspAttach` - LSP attached

**Profiling commands:**
```bash
nvim --startuptime startup.log  # Startup profiling
```

```vim
:Lazy profile                   # Plugin load times
```

**Target startup time: < 50ms**

Apply these strategies to achieve fast, responsive Neovim with full plugin functionality.
