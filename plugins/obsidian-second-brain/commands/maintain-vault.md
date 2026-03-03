# Maintain Vault Command

Run a comprehensive vault health check to identify and report issues. This is **read-only** - no changes will be made automatically.

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## Checks to Run

### 1. Broken Links
Find `[[wiki links]]` pointing to non-existent notes. For each: show link target, all referencing notes, and suggest fixes.

### 2. Orphaned Notes
Notes with zero incoming links (excluding Templates/, Archives/, daily notes < 7 days old). Suggest linking opportunities or archiving.

### 3. 2-Link Rule Violations
Notes with fewer than 2 outgoing links (excluding Templates/, Archives/, Daily Ops/). Suggest connections.

### 4. Unlinked Mentions
Text matching existing note titles that isn't linked. Focus on `3 - Resources/Coding/`, `3 - Resources/TIL/`, `1 - Projects/`.

### 5. Missing Related Sections
Concept notes in `3 - Resources/Coding/` without `## Related` section.

### 6. Missing Encounters Sections
Learning notes in `3 - Resources/Coding/` without `# Encounters` section.

### 7. TIL Cross-References
TIL notes linking to concepts whose Encounters section doesn't reference back.

### 8. Tag Consistency
Check against Tag Taxonomy (`3 - Resources/Obsidian org/Tag Taxonomy.md`):
- Max 4 tags per note
- No redundant folder-type tags (project, area, reference, daily, moc)
- TIL notes use `til/` prefix
- Only valid taxonomy tags

## Summary Report

```
Vault Health Check Complete!

Link Health:
- Broken links: X found
- Orphaned notes: Y found
- 2-Link Rule violations: Z found
- Unlinked mentions: W found

Structure Health:
- Missing Related sections: A found
- Missing Encounters sections: B found
- TIL cross-references missing: C found

Tag Health:
- Tag issues: D found

Overall health: Good / Needs attention / Critical

Priority fixes:
1. [Most impactful issue]
2. [Second priority]
3. [Third priority]
```

**Health assessment:**
- **Good**: <10 issues total
- **Needs attention**: 10-30 issues
- **Critical**: >30 issues or many broken links

**Priority order:** Broken links > 2-Link violations > Missing Related > Unlinked mentions > Missing Encounters > TIL cross-refs > Tags

## CLI Commands

```bash
obsidian search query="[[" format=json
obsidian read path="3 - Resources/Obsidian org/Tag Taxonomy.md"
obsidian files folder="3 - Resources/Coding/" format=json
obsidian files format=json
```
