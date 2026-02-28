---
name: dotfiles-audit
description: "Read-only dotfiles health check and analysis - comprehensive reporting without modifications. Use when user says '/dotfiles-optimizer:dotfiles-audit', wants a dotfiles audit, or needs configuration health check."
disable-model-invocation: true
---

# Audit Dotfiles Command

Perform read-only health check and analysis of dotfiles configurations. Generates comprehensive report without offering to apply changes.

## Purpose

Use this command when:
- Want detailed analysis without risk of modifications
- Need documentation of current state
- Performing regular health checks
- Preparing for manual optimization
- Generating reports for review

Difference from `/optimize`:
- `/audit` - Read-only, no modifications, detailed report
- `/optimize` - Analyzes and offers to apply fixes

## Arguments

**Component Scope** (optional, positional):
- `zsh` - Audit shell configuration only
- `tmux` - Audit tmux configuration only
- `nvim` - Audit Neovim configuration only
- `git` - Audit git configuration only
- `terminal` - Audit terminal configs (Kitty/Ghostty) only
- `all` or omitted - Audit entire dotfiles structure

**Flags** (optional):
- `--verbose` - Include detailed explanations and examples in report
- `--security` - Focus audit on security issues only
- `--performance` - Focus audit on performance metrics only
- `--modern-tools` - Focus on modern tool adoption only

**Examples**:
```bash
/audit                      # Complete health check of all components
/audit zsh                  # Shell configuration audit only
/audit --security           # Security-focused audit
/audit --verbose            # Detailed report with explanations
/audit zsh --performance    # Shell performance analysis
```

## Workflow

Execute this read-only analysis workflow:

### 1. Parse Arguments and Load Configuration

Parse command arguments to determine:
- **Component scope**: Which components to audit
- **Focus area**: Security, performance, modern-tools, or comprehensive
- **Verbosity level**: Whether `--verbose` flag is present

Load user configuration from `.claude/dotfiles-optimizer.local.md`:
- Read file if exists
- Extract `dotfiles_path` from frontmatter (default: `/Users/kriscard/.dotfiles`)
- Note any user-specific settings

### 2. Invoke Analysis

Use the `dotfiles-optimizer` skill via Skill tool:
- Specify read-only mode (audit, not optimize)
- Pass component scope and focus area
- Request analysis without fix recommendations

The skill orchestrates:
- Calling dotfiles-analyzer agent for deep analysis
- Referencing dotfiles-best-practices for context
- Generating comprehensive findings

### 3. Generate Audit Report

Produce detailed, structured report:

```markdown
# Dotfiles Audit Report
Generated: [timestamp]
Scope: [Components audited]
Path: [Dotfiles path]

## Executive Summary

**Overall Health**: [Excellent/Good/Fair/Needs Attention/Critical Issues]

**Key Metrics**:
- Security Score: [X/10]
- Performance Score: [X/10]
- Modern Tool Adoption: [X/10]
- Configuration Quality: [X/10]

**Critical Findings**: [N]
**Recommendations**: [N]
**Enhancements**: [N]

## Security Audit

### Critical Issues 🔴 ([N] found)

[For each critical issue:]
**[Issue ID]**: [Issue Title]
- **Location**: `file/path:line`
- **Severity**: Critical
- **Description**: [What was found]
- **Risk**: [Security implications]
- **Recommendation**: [How to fix]
[If --verbose: Include detailed explanation and example]

### Security Best Practices 🟢 ([N] implemented)

[List security practices already in place]
- ✅ [Practice implemented well]
- ✅ [Another good practice]

## Performance Audit

### Current Metrics

**Shell Startup Time**: [X]ms
- Target: <500ms
- Status: [On Target/Above Target]
- Percentile: [vs benchmark]

**Component Load Times** (if --verbose):
- env.zsh: [X]ms
- plugins.zsh: [X]ms
- completions.zsh: [X]ms
[...]

### Performance Opportunities 🟡 ([N] identified)

[For each opportunity:]
**[Opportunity ID]**: [Optimization Title]
- **Current Impact**: ~[X]ms overhead
- **Component**: [Which file/setting]
- **Description**: [What causes slowness]
- **Potential Improvement**: Saves ~[X]ms
[If --verbose: Include implementation details]

### Performance Strengths 🟢

[List optimizations already in place]
- ✅ [What's done well]
- ✅ [Another optimization]

## Modern Tool Adoption

### Installed Modern Tools

| Tool | Status | Purpose | Configuration |
|------|--------|---------|---------------|
| eza | ✅ Installed | ls replacement | [Status] |
| bat | ✅ Installed | cat replacement | [Status] |
| fd | ✅ Installed | find replacement | [Status] |
| ripgrep | ✅ Installed | grep replacement | [Status] |
| zoxide | ✅ Installed | cd replacement | [Status] |

### Configuration Status

[For each tool:]
**[Tool Name]**:
- Installation: ✅/❌
- Aliasing: ✅/❌/⚠️ (partial)
- Configuration: ✅/❌/⚠️ (needs update)
- Theme Integration: ✅/❌/N/A

### Recommended Additions 🟢 ([N] suggested)

[For each suggested tool:]
**[Tool Name]** (replaces [traditional tool])
- **Benefit**: [Why it helps]
- **Installation**: `brew install [tool]`
- **Configuration**: [What to add]
[If --verbose: Include complete setup instructions]

## Configuration Quality

### Structure and Organization

**Modularity**: [Excellent/Good/Fair/Poor]
- Modular structure: ✅/❌
- Load order clear: ✅/❌
- Separation of concerns: ✅/❌
- Local overrides pattern: ✅/❌

**Version Control**:
- Secrets excluded: ✅/❌
- .env.example pattern: ✅/❌
- .gitignore comprehensive: ✅/❌
- No sensitive files tracked: ✅/❌

**Documentation**:
- README present: ✅/❌
- Comments in configs: [Good/Fair/Sparse]
- Usage examples: ✅/❌

### Component-Specific Findings

[For each component audited:]

#### [Component Name] (e.g., Zsh Configuration)

**Health**: [Status]

**Findings**:
- [Finding 1 with details]
- [Finding 2 with details]
[...]

**Strengths**:
- [What's done well]
- [Another strength]

[If --verbose: Include detailed analysis of each file]

## Comparison to Best Practices

**Alignment Score**: [X]/10

**Matches Best Practices**:
- ✅ [Practice followed]
- ✅ [Another match]

**Opportunities for Improvement**:
- ⚠️ [Practice not yet adopted]
- ⚠️ [Another opportunity]

[If --verbose: Include detailed best practice explanations]

## Recommendations

### Immediate Actions (Priority 1) 🔴

[Critical fixes needed immediately]
1. [Action with rationale]
2. [Action with rationale]

### Short-term Improvements (Priority 2) 🟡

[Recommended changes for near-term]
1. [Improvement with benefit]
2. [Improvement with benefit]

### Long-term Enhancements (Priority 3) 🟢

[Nice-to-have improvements]
1. [Enhancement with description]
2. [Enhancement with description]

## Appendix

### Audit Methodology

- Components analyzed: [List]
- Analysis depth: [Comprehensive/Focused]
- Focus areas: [Security/Performance/Modern Tools/All]
- Tools used: dotfiles-analyzer agent, dotfiles-best-practices skill
- Duration: [Approximate time]

### File Inventory

[List of all files analyzed with status]
- `file/path` - [Status/Issues found]
- `file/path` - [Status/Issues found]
[...]

### Change History

[If user runs audits regularly, compare to previous]
- Last audit: [Date]
- Issues resolved since last audit: [N]
- New issues detected: [N]
- Performance change: [+/-X ms]

---

**End of Audit Report**
```

### 4. Score Calculations

Calculate health scores for executive summary:

**Security Score** (0-10):
- 10: No issues, all best practices
- 7-9: Minor concerns, mostly good
- 4-6: Several issues, needs attention
- 1-3: Major vulnerabilities, critical
- 0: Severe security problems

**Performance Score** (0-10):
- Based on shell startup time and optimization level
- 10: <200ms, fully optimized
- 7-9: <500ms, well optimized
- 4-6: <1000ms, room for improvement
- 1-3: >1000ms, significant issues
- 0: >2000ms, critical performance problems

**Modern Tool Adoption** (0-10):
- Count modern tools installed and properly configured
- 10: All recommended tools optimally configured
- 7-9: Most tools with good configuration
- 4-6: Some tools, partial configuration
- 1-3: Few tools, minimal configuration
- 0: No modern tools adopted

**Configuration Quality** (0-10):
- Based on organization, documentation, best practices
- 10: Exemplary structure and practices
- 7-9: Well organized, good practices
- 4-6: Acceptable organization, some practices
- 1-3: Poor organization, few practices
- 0: Chaotic, no best practices

**Overall Health**:
- Average of all scores
- Excellent: 9-10
- Good: 7-8
- Fair: 5-6
- Needs Attention: 3-4
- Critical Issues: 0-2

## Verbosity Levels

**Standard (default)**:
- Executive summary
- Issue lists with locations
- Metric summaries
- Concise recommendations

**Verbose (`--verbose`)**:
- All standard content plus:
- Detailed explanations for each finding
- Code examples and comparisons
- Implementation instructions
- Best practice context
- Historical comparisons (if available)

## Output Destinations

**Display Report**:
Present complete report in terminal for immediate review.

**Optional: Save Report**:
Ask user if they want to save report to file:
```bash
Would you like to save this audit report?
[Yes] → Save to ~/.dotfiles/.audit-reports/audit-YYYYMMDD-HHMMSS.md
[No] → Just display
```

If saved, provide path to saved report.

## Use Cases

**Regular Health Checks**:
```bash
/audit          # Monthly or quarterly check
```
Track configuration health over time.

**Pre-Modification Baseline**:
```bash
/audit --verbose > before-changes.md
# Make manual changes
/audit --verbose > after-changes.md
# Compare reports
```

**Security Compliance**:
```bash
/audit --security
```
Verify no exposed credentials or vulnerabilities.

**Performance Troubleshooting**:
```bash
/audit zsh --performance --verbose
```
Detailed analysis of what's slowing startup.

**Tool Adoption Review**:
```bash
/audit --modern-tools
```
Check which modern tools are used and configured.

## Integration with /optimize

After reviewing audit report:
```bash
# If issues found and want to fix them
/optimize              # Interactive fixes
/optimize --apply      # Auto-apply fixes
```

Audit provides information, optimize provides action.

## Notes

- Read-only command - never modifies files
- Safe to run frequently
- Generates detailed documentation
- Complements `/optimize` command
- Can save reports for historical tracking
- Useful for understanding dotfiles health
- Educational - shows what best practices look like
- No interaction required (pure report)

## Tips

**For Regular Maintenance**:
- Run monthly or when changing configurations
- Save reports to track improvements over time
- Use `--verbose` for learning best practices
- Compare reports to measure progress

**For Troubleshooting**:
- Use focused audits (`--security`, `--performance`)
- Scope to specific component having issues
- Verbose mode provides implementation details
- Cross-reference with `/optimize` for fixes

**For Documentation**:
- Generate audit before major changes
- Include in project documentation
- Share with team for collaborative improvements
- Use as baseline for optimization efforts
