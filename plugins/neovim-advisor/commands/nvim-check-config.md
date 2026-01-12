---
name: nvim-check-config
description: Validate Neovim configuration for file structure, plugin syntax, best practices, and common mistakes
argument-hint: "[path-to-config]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - AskUserQuestion
  - Task
---

# Check Neovim Configuration

Validate the user's Neovim configuration following modern best practices.

## Task

Perform comprehensive validation of Neovim configuration, checking file structure, plugin specifications, best practices compliance, and identifying common mistakes.

## Workflow

### 1. Locate Configuration

Check for configuration path:

1. If path argument provided, use it
2. Check settings file `.claude/neovim-advisor.local.md` for `neovim_path`
3. Default to `~/.config/nvim`

Use Read tool to verify path exists.

### 2. Ask What to Validate

Use AskUserQuestion to ask user what aspects to check:

```
Question: "What would you like to validate?"
Options:
- "Everything" - Complete validation (all checks)
- "File structure" - Check init.lua, directory organization
- "Plugin syntax" - Validate lazy.nvim specs
- "Best practices" - Modern patterns check
- "Common mistakes" - Find issues
```

### 3. Perform Validation

Based on user selection, run appropriate checks:

#### File Structure Validation

Check for:
- [ ] `init.lua` exists at config root
- [ ] `lua/<username>/` directory exists (namespaced config)
- [ ] Core files present: `options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`
- [ ] Plugins in `lua/plugins/` directory (if using lazy.nvim)
- [ ] No deprecated `init.vim` (unless hybrid config)

Use Glob and Read tools to check files.

#### Plugin Syntax Validation

For lazy.nvim plugins in `lua/plugins/`:
- [ ] Valid plugin specs (return table format)
- [ ] Dependencies declared correctly
- [ ] Lazy-loading configured (cmd, keys, ft, event)
- [ ] Config functions properly defined
- [ ] No syntax errors in plugin files

Use Read and Grep to analyze plugin files.

#### Best Practices Check

Validate against modern patterns:
- [ ] All config in Lua (minimal Vimscript)
- [ ] Using `vim.opt` for options (not `vim.cmd("set")`)
- [ ] Using `vim.keymap.set` for keymaps
- [ ] Using `vim.api.nvim_create_autocmd` for autocommands
- [ ] Plugins have lazy-loading where appropriate
- [ ] No deprecated APIs

Use Grep to search for patterns.

#### Common Mistakes Detection

Look for:
- [ ] Duplicate keymaps (grep for repeated keys)
- [ ] Colorscheme without `priority = 1000`
- [ ] Heavy plugins loading at startup
- [ ] Missing dependencies in plugin specs
- [ ] Hardcoded paths (not using stdpath)
- [ ] Synchronous operations in init.lua

Use Grep and Read tools to detect issues.

### 4. Delegate to Agent (Optional)

For comprehensive validation, use Task tool to invoke `config-validator` agent:

```
Use config-validator agent for deep analysis of configuration
```

The agent will read all files and provide detailed report.

### 5. Present Findings

Show results in structured format:

```markdown
## Configuration Validation Results

### File Structure: ✓ PASS / ✗ FAIL
- [✓] init.lua exists
- [✓] Namespaced under lua/username/
- [✗] Missing autocmds.lua

### Plugin Syntax: ✓ PASS / ✗ FAIL
- [✓] All plugins have valid specs
- [✗] telescope.nvim missing lazy-loading

### Best Practices: ✓ PASS / ✗ FAIL
- [✓] Using Lua exclusively
- [✓] Modern API usage
- [✗] Some plugins use deprecated vim.api.nvim_set_keymap

### Common Mistakes: 2 issues found
1. Colorscheme doesn't have priority = 1000
2. Telescope loads at startup (should lazy-load on cmd/keys)

## Recommendations

1. Add priority to colorscheme plugin
2. Add lazy-loading to telescope with cmd = "Telescope"
3. Create lua/username/autocmds.lua for autocommands
4. Update keymaps to use vim.keymap.set

Would you like me to fix these issues?
```

### 6. Offer to Fix (Interactive)

If issues found, ask user:

```
Would you like me to fix these issues automatically?
- Yes, fix all issues
- Let me choose which to fix
- No, I'll fix manually
```

If user wants fixes:
- Use Edit tool to apply fixes
- Show what was changed
- Recommend testing

## Tips

- Load neovim-best-practices skill knowledge
- Reference lazy-nvim-optimization for plugin checks
- Be specific about file locations (use full paths)
- Provide code examples for fixes
- Link to relevant documentation

## Settings File

Check `.claude/neovim-advisor.local.md` for:
```yaml
---
neovim_path: ~/.config/nvim
validation_rules:
  - enforce lazy-loading
  - no vimscript
---
```

Apply custom rules if present.

## Example Usage

User: `/check-config`
→ Ask what to validate
→ Run checks
→ Show results
→ Offer fixes

User: `/check-config ~/.config/nvim-test`
→ Use provided path
→ Run validation
→ Report findings

## Important

- Never modify files without user permission
- Always show what changes will be made before applying
- Provide explanations for why something is an issue
- Reference best practices documentation

Complete validation and help user maintain modern, clean Neovim configuration.
