---
name: Neovim Best Practices
description: This skill should be used when the user asks about "neovim config", "nvim setup", "vim best practices", "neovim patterns", "modern neovim", "lua configuration", "neovim 0.10", or wants guidance on configuring Neovim following current standards and conventions.
version: 0.1.0
---

# Neovim Best Practices

Modern Neovim configuration follows specific patterns that leverage Lua, built-in LSP, and the plugin ecosystem effectively. This skill provides guidance on structuring configurations, choosing plugins, and following current best practices.

## Core Principles

### Lua Over Vimscript

Prefer Lua for all configuration. Neovim 0.5+ has first-class Lua support with better performance and cleaner syntax than Vimscript.

**Structure:**
```
~/.config/nvim/
├── init.lua          # Entry point
└── lua/
    └── <username>/   # Namespace your config
        ├── init.lua
        ├── options.lua
        ├── keymaps.lua
        ├── autocmds.lua
        └── lazy.lua  # Plugin manager setup
```

**Entry point pattern:**
```lua
-- init.lua
require("<username>")
```

**Module organization:**
```lua
-- lua/<username>/init.lua
require("<username>.options")
require("<username>.keymaps")
require("<username>.autocmds")
require("<username>.lazy")
```

### Plugin Management with lazy.nvim

Use lazy.nvim as the modern plugin manager. It provides lazy-loading, lockfile management, and excellent performance.

**Setup pattern:**
```lua
-- lua/<username>/lazy.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  -- Configuration options
})
```

**Plugin specs:**
Create individual plugin files in `lua/plugins/`:
```lua
-- lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",  -- Lazy-load on command
  keys = {           -- Lazy-load on keymap
    { "<leader>ff", "<cmd>Telescope find_files<cr>" },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      -- Configuration
    })
  end,
}
```

### Modern Configuration Patterns

**Options:**
```lua
-- lua/<username>/options.lua
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
-- Use opt for vim options, not vim.o/vim.wo/vim.bo directly
```

**Keymaps:**
```lua
-- lua/<username>/keymaps.lua
local keymap = vim.keymap.set

-- Set leader key first
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use descriptive opts
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })

-- Prefer lua functions over vim commands when possible
keymap("n", "<Esc>", function() vim.cmd("nohlsearch") end, { desc = "Clear highlights" })
```

**Autocommands:**
```lua
-- lua/<username>/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Create augroup for organization
local highlight_group = augroup("YankHighlight", { clear = true })

autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})
```

## Configuration Structure Best Practices

### File Organization

Separate concerns into focused files:

**Core configuration files:**
- `init.lua` - Entry point only
- `options.lua` - Vim options and settings
- `keymaps.lua` - Key mappings
- `autocmds.lua` - Autocommands and event handlers
- `lazy.lua` - Plugin manager setup

**Plugin files:**
Create one file per plugin or logical group in `lua/plugins/`:
- `colorscheme.lua` - Color scheme
- `lsp.lua` - LSP configuration
- `treesitter.lua` - Treesitter
- `telescope.lua` - Fuzzy finder
- `gitsigns.lua` - Git integration

**Utility modules:**
Optional `lua/<username>/util/` for shared functions:
- `util/init.lua` - Common utilities
- `util/lsp.lua` - LSP helpers
- `util/keymaps.lua` - Keymap utilities

### Namespace Your Configuration

Always namespace under your username to avoid conflicts:

```lua
-- lua/kriscard/init.lua
require("kriscard.options")
require("kriscard.keymaps")
```

This prevents collisions with plugin code and makes the config portable.

## LSP Configuration

Neovim has built-in LSP client. Use nvim-lspconfig for server configurations.

**Recommended setup:**
```lua
-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "tsserver", "pyright" },
    })

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Configure each server
    lspconfig.lua_ls.setup({ capabilities = capabilities })
    lspconfig.tsserver.setup({ capabilities = capabilities })
  end,
}
```

**On-attach pattern:**
```lua
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
```

## Plugin Ecosystem Essentials

### Must-Have Plugins

**Plugin manager:**
- lazy.nvim - Modern, fast, lazy-loading

**LSP & Completion:**
- nvim-lspconfig - LSP configurations
- mason.nvim - LSP/DAP/linter installer
- nvim-cmp - Completion engine
- cmp-nvim-lsp - LSP completion source

**Syntax & UI:**
- nvim-treesitter - Better syntax highlighting
- telescope.nvim - Fuzzy finder
- nvim-tree or oil.nvim - File explorer

**Git:**
- gitsigns.nvim - Git decorations
- lazygit.nvim or fugitive.vim - Git interface

**Quality of life:**
- which-key.nvim - Keymap hints
- nvim-autopairs - Auto-close brackets
- Comment.nvim - Easy commenting

### Plugin Selection Criteria

Evaluate plugins based on:

1. **Maintenance**: Active development, recent commits
2. **Dependencies**: Minimal external requirements
3. **Performance**: Lazy-loadable, minimal startup impact
4. **Documentation**: Clear usage examples
5. **Community**: Stars, issues, discussions

Prefer plugins that:
- Use Lua API
- Support lazy-loading
- Have minimal dependencies
- Are actively maintained

Avoid plugins that:
- Require external binaries not in Mason
- Have not been updated in 2+ years
- Have many open critical issues
- Duplicate built-in functionality (0.10+)

## Performance Optimization

### Lazy-Loading Strategies

Load plugins only when needed:

**By command:**
```lua
{ "plugin/name", cmd = "CommandName" }
```

**By keymap:**
```lua
{ "plugin/name", keys = "<leader>x" }
```

**By filetype:**
```lua
{ "plugin/name", ft = { "python", "lua" } }
```

**By event:**
```lua
{ "plugin/name", event = "BufReadPost" }
```

**Defer loading:**
```lua
{
  "plugin/name",
  lazy = true,  -- Don't load automatically
  dependencies = { "other/plugin" },
}
```

### Startup Optimization

Measure startup time:
```bash
nvim --startuptime startup.log
```

Common optimizations:
1. Lazy-load all plugins except essentials (colorscheme, treesitter)
2. Use `lazy = true` for plugins loaded by others
3. Defer heavy plugins with `event = "VeryLazy"`
4. Profile with `:Lazy profile`

## Keybinding Patterns

### Leader Key Usage

Set leader early in init.lua:
```lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
```

**Organize by prefix:**
- `<leader>f` - Find/search (telescope)
- `<leader>g` - Git operations
- `<leader>b` - Buffer management
- `<leader>w` - Window management
- `<leader>l` - LSP operations
- `<leader>t` - Terminal/tests

### Keymap Best Practices

**Use descriptive options:**
```lua
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {
  desc = "Find files",
  silent = true,
})
```

**Prefer Lua functions:**
```lua
keymap("n", "<leader>w", function()
  vim.cmd.write()
  print("File saved")
end, { desc = "Save file" })
```

**Use which-key for discoverability:**
```lua
require("which-key").add({
  { "<leader>f", group = "Find" },
  { "<leader>ff", desc = "Find files" },
  { "<leader>fg", desc = "Live grep" },
})
```

## Common Mistakes to Avoid

### Using set Instead of opt

```lua
-- Bad
vim.cmd("set number")

-- Good
vim.opt.number = true
```

### Global Keymaps Without Options

```lua
-- Bad
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {})

-- Good
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {
  desc = "Find files",
  silent = true,
})
```

### Not Lazy-Loading Plugins

```lua
-- Bad - loads everything at startup
return { "plugin/name" }

-- Good - loads when needed
return {
  "plugin/name",
  cmd = "PluginCommand",
  keys = "<leader>x",
}
```

### Hardcoding Paths

```lua
-- Bad
require("kriscard.config")

-- Good - use stdpath
local config_path = vim.fn.stdpath("config") .. "/lua/kriscard"
```

## Version-Specific Features

### Neovim 0.10+ Features

Take advantage of modern features:

**Built-in commenting:**
```lua
vim.keymap.set("n", "gcc", "gcc", { remap = true })
-- Can replace Comment.nvim in 0.10+
```

**Improved diagnostics:**
```lua
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  float = { border = "rounded" },
})
```

**Inlay hints:**
```lua
vim.lsp.inlay_hint.enable(true)
```

### Deprecated Patterns

Avoid deprecated APIs:

**Old autocommand syntax:**
```lua
-- Bad (deprecated)
vim.cmd([[
  augroup MyGroup
    autocmd!
    autocmd BufWritePre * echo "Saving..."
  augroup END
]])

-- Good
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    print("Saving...")
  end,
})
```

## Additional Resources

### Reference Files

For detailed information, consult:
- **`references/plugin-recommendations.md`** - Curated plugin list by category
- **`references/lsp-setup.md`** - Comprehensive LSP configuration guide
- **`references/migration-guide.md`** - Migrating from Vimscript to Lua

### Example Files

Working examples in `examples/`:
- **`init.lua`** - Complete minimal config
- **`lazy-spec-example.lua`** - Plugin specification patterns

## Quick Reference

**File structure checklist:**
- [ ] `init.lua` exists at config root
- [ ] Configuration namespaced under username in `lua/`
- [ ] Plugin specs in `lua/plugins/` directory
- [ ] Options, keymaps, autocmds separated into files
- [ ] Using lazy.nvim for plugin management

**Code quality checklist:**
- [ ] All config in Lua (no Vimscript)
- [ ] Using `vim.opt` for options
- [ ] Using `vim.keymap.set` for keymaps
- [ ] Using `vim.api.nvim_create_autocmd` for autocommands
- [ ] Plugins lazy-loaded where possible
- [ ] Descriptive keymap descriptions
- [ ] No deprecated APIs

**Performance checklist:**
- [ ] Startup time under 50ms (measure with `--startuptime`)
- [ ] Plugins lazy-loaded by cmd/keys/ft/event
- [ ] Heavy plugins deferred with `event = "VeryLazy"`
- [ ] No synchronous operations at startup

Follow these patterns for maintainable, performant, and modern Neovim configurations.
