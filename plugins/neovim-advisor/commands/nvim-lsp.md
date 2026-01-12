---
name: nvim-lsp
description: Interactive LSP configuration for specific languages with Mason integration
argument-hint: "[language]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
---

# Setup LSP

Interactive LSP (Language Server Protocol) configuration for specific languages with proper Mason, nvim-lspconfig, and nvim-cmp integration.

## Task

Configure LSP servers for specified languages with proper installation, keybindings, completion integration, and formatting setup.

## Workflow

### 1. Determine Languages

If language argument provided, use it. Otherwise ask:

```
Which language(s) would you like to set up LSP for? (select multiple)
- TypeScript/JavaScript
- Python
- Rust
- Go
- Lua
- C/C++
- Java
- Other (specify)
```

Use AskUserQuestion tool.

### 2. Check Existing LSP Setup

Look for existing LSP configuration:

```bash
# Check for lspconfig
find ~/.config/nvim -name "*lsp*.lua"
```

Use Glob and Read tools to check:
- Is nvim-lspconfig installed?
- Is Mason installed?
- Is nvim-cmp with cmp-nvim-lsp installed?
- Are any servers already configured?

### 3. Verify Prerequisites

Check if base LSP plugins exist:

**Required plugins:**
- neovim/nvim-lspconfig
- williamboman/mason.nvim
- williamboman/mason-lspconfig.nvim
- hrsh7th/cmp-nvim-lsp (for completion)

If missing, offer to add them first.

### 4. Language-Specific Configuration

For each selected language, provide:

#### TypeScript/JavaScript

**Server:** tsserver
**Mason name:** typescript-language-server

**Configuration:**
```lua
return {
  "neovim/nvim-lspconfig",
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "tsserver" },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("lspconfig").tsserver.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Disable tsserver formatting (use prettier/biome instead)
        client.server_capabilities.documentFormattingProvider = false

        -- Keybindings
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
          },
        },
      },
    })
  end,
}
```

**Additional recommendations:**
- prettier for formatting
- eslint for linting
- typescript-tools.nvim (alternative to tsserver, faster)

#### Python

**Server:** pyright or pylsp
**Mason name:** pyright

**Configuration:**
```lua
require("lspconfig").pyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
    },
  },
})
```

**Additional setup:**
- black for formatting
- mypy for type checking
- ruff for linting
- venv-selector.nvim for virtual environments

#### Rust

**Server:** rust-analyzer
**Mason name:** rust-analyzer

**Configuration:**
```lua
require("lspconfig").rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
```

**Recommended plugin:**
- rust-tools.nvim or rustaceanvim
- crates.nvim for Cargo.toml

#### Go

**Server:** gopls
**Mason name:** gopls

**Configuration:**
```lua
require("lspconfig").gopls.setup({
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})
```

**Additional:**
- go.nvim plugin
- goimports for formatting

#### Lua

**Server:** lua_ls (formerly sumneko_lua)
**Mason name:** lua-language-server

**Configuration:**
```lua
require("lspconfig").lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },  -- Recognize vim global for Neovim config
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
```

#### C/C++

**Server:** clangd
**Mason name:** clangd

**Configuration:**
```lua
require("lspconfig").clangd.setup({
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
  },
})
```

**Additional:**
- cmake-tools.nvim
- clangd_extensions.nvim

#### Java

**Server:** jdtls
**Mason name:** jdtls

**Note:** Java LSP is complex, recommend nvim-jdtls plugin:

```lua
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
}
```

### 5. Create or Update LSP Configuration File

Check if LSP file exists:
- `lua/plugins/lsp.lua`
- Or create it

#### If No LSP Setup Exists

Create complete LSP configuration:

```lua
-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  ft = { [languages from selection] },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- Mason setup
    require("mason").setup({
      ui = { border = "rounded" },
    })

    require("mason-lspconfig").setup({
      ensure_installed = { [servers for selected languages] },
      automatic_installation = true,
    })

    -- Capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Common on_attach function
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true }

      -- Navigation
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

      -- Information
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

      -- Actions
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      -- Formatting
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)

      -- Diagnostics
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    end

    -- Configure each server
    local lspconfig = require("lspconfig")
    [Server configurations for each language]
  end,
}
```

Use Write tool to create file.

#### If LSP Exists

Use Edit tool to add new server configurations.

### 6. Configure Diagnostics

Add diagnostic configuration if not present:

```lua
-- In config function
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
```

### 7. Setup Completion Integration

Ensure nvim-cmp is configured with LSP source:

Check `lua/plugins/cmp.lua` includes:

```lua
sources = {
  { name = "nvim_lsp" },  -- LSP completions
  { name = "buffer" },
  { name = "path" },
}
```

If not configured, offer to set it up.

### 8. Add Formatting (Optional)

Ask user about formatting:

```
Would you like to set up formatting?
- Use LSP formatter
- Use external formatter (prettier, black, etc.)
- Set up later
```

If external formatter, recommend conform.nvim:

```lua
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        typescript = { "prettierd", "prettier" },
        python = { "black", "isort" },
        rust = { "rustfmt" },
        go = { "goimports", "gofumpt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })
  end,
}
```

### 9. Verify Setup

After configuration, guide user to verify:

```bash
# Restart Neovim
# Open a file in the configured language
# Check LSP is working:
:LspInfo
:checkhealth lsp

# Test features:
# - Hover over a symbol (K)
# - Go to definition (gd)
# - Trigger completion (Ctrl+Space)
```

### 10. Present Summary

Show what was configured:

```markdown
## LSP Setup Complete

### Configured Languages
- TypeScript/JavaScript (tsserver)
- Python (pyright)

### Files Created/Modified
- lua/plugins/lsp.lua (created)
- lua/plugins/cmp.lua (verified)

### Installed via Mason
- typescript-language-server
- pyright

### Keybindings Added
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format buffer
- `[d` / `]d` - Navigate diagnostics

### Next Steps
1. Restart Neovim
2. Open a TypeScript or Python file
3. Run `:checkhealth lsp` to verify
4. Try the keybindings

### Additional Recommendations
- Add prettier for TypeScript formatting
- Add black for Python formatting
- Consider typescript-tools.nvim for better performance

Would you like me to set up formatting or add any recommended plugins?
```

## Advanced Options

### Language-Specific Enhancements

**For each language, mention:**
- Recommended formatters
- Linters
- Debug adapters (nvim-dap)
- Testing frameworks (neotest)
- Language-specific plugins

### Settings from User Config

Check `.claude/neovim-advisor.local.md`:

```yaml
---
tech_stack:
  - typescript
  - python
---
```

Auto-suggest LSP for listed languages.

### Inlay Hints (Neovim 0.10+)

If Neovim 0.10+, enable inlay hints:

```lua
local on_attach = function(client, bufnr)
  -- Enable inlay hints
  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end
```

## Tips

- Load neovim-best-practices skill for LSP reference
- Check references/lsp-setup.md for comprehensive guide
- Test each server after configuration
- Provide working examples
- Explain what each setting does

## Important

- Always verify file paths before writing
- Check if LSP already configured to avoid duplicates
- Test configuration is syntactically correct
- Recommend restarting Neovim after changes
- Guide through troubleshooting if issues arise

Help users get fully functional LSP setup with minimal friction.
