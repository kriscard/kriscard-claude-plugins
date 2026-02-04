---
name: maintain-vault
description: Comprehensive vault health check - broken links, orphaned notes, tag consistency
allowed-tools: [Read, Bash, obsidian]
---

# Maintain Vault Command

Run a comprehensive vault health check to identify and report issues with links, orphaned notes, and tag consistency.

## Purpose

Help user keep vault healthy and organized by identifying:
- Broken wiki links (links to non-existent notes)
- Orphaned notes (notes with no incoming links)
- Tag inconsistencies (tags not following Tag Taxonomy)

**Note:** This command **reports findings and suggests fixes** but does NOT auto-fix. User maintains full control.

## Workflow

### Step 1: Introduction

Inform user:
```
Running vault health check...

This will check for:
1. Broken wiki links
2. Orphaned notes
3. Tag consistency

This is read-only - no changes will be made automatically.
```

### Step 2: Check Broken Links

**Goal:** Find `[[wiki links]]` that point to non-existent notes.

**Method:**
1. Use Obsidian MCP `obsidian_simple_search` to find all `[[` patterns
2. Extract link targets
3. For each link target, check if note exists
4. Build list of broken links

**Report format:**
```
## Broken Links Found: X

1. [[Non-existent Note]] - Referenced in:
   - Projects/Project A.md (line 15)
   - Areas/Career.md (line 23)

2. [[Missing Resource]] - Referenced in:
   - Daily Notes/2025-01-10.md (line 8)

Suggestions:
- Create missing notes
- Update links to correct note names
- Remove links if no longer relevant
```

**For each broken link:**
- Show link target
- Show all notes that reference it
- Suggest actions:
  - "Create '[[Missing Note]]' in appropriate PARA folder"
  - "Did you mean '[[Similar Existing Note]]'?"
  - "Remove link if no longer needed"

### Step 3: Find Orphaned Notes

**Goal:** Identify notes with zero incoming links (potentially lost knowledge).

**Method:**
1. Get all notes in vault
2. For each note, count backlinks
3. Filter notes with 0 backlinks
4. Exclude intentionally standalone notes (Templates, Archives, Meta docs)

**Exclusions:**
- Files in `Templates/`
- Files in `Templates/`
- Tag Taxonomy, Tag MOC, organizational docs
- Daily notes less than 7 days old
- Files in `temporary/`

**Report format:**
```
## Orphaned Notes Found: X

Notes with no incoming links:

1. Resources/React Patterns.md
   - Created: 2024-12-15
   - Tags: [reference, react]
   - Suggest linking from: [[React MOC]], [[Web Development MOC]]

2. Projects/Old Project Idea.md
   - Created: 2024-06-20
   - Tags: [project]
   - Consider: Archive or delete if no longer relevant

Suggestions:
- Link from relevant MOCs
- Link from related project/area notes
- Archive if outdated
- Delete if truly orphaned
```

**For each orphaned note:**
- Show note name and path
- Show metadata (created date, tags)
- Suggest potential linking opportunities:
  - "Link from [[Related MOC]]"
  - "Link from [[Related Project]]"
  - "Archive to 4 - Archives/ if outdated"
  - "Delete if no longer useful"

### Step 4: Check Tag Consistency

**Goal:** Ensure tags follow PARA-aligned Tag Taxonomy rules.

**Method:**
1. Read Tag Taxonomy from `3 - Resources/Obsidian org/Tag Taxonomy.md`
2. Get all notes with tags
3. For each note:
   - Count total tags (should be ≤4)
   - Check for redundant folder-type tags (project, area, reference, daily, moc - these should be removed)
   - Check for subject tags present
   - Check for invalid tags (not in taxonomy)
   - Check TIL notes have `til/` prefix

**Report format:**
```
## Tag Inconsistencies Found: X

1. Projects/Website Launch.md
   - Issue: Redundant folder-type tag
   - Current tags: [project, career, active, web, react]
   - Suggested: Remove `project` (folder handles this) → [career, react, active]

2. Resources/Old Tutorial.md
   - Issue: Redundant folder-type tag
   - Current tags: [reference, react]
   - Suggested: Remove `reference` → [react]

3. TIL/til-2026-01-15.md
   - Issue: Missing til/ prefix on topic tags
   - Current tags: [react, architecture]
   - Suggested: Add til/ prefix → [til/react, til/architecture]

4. Areas/Career.md
   - Issue: Too many tags (5)
   - Current tags: [area, career, active, interview, personal]
   - Suggested: Remove `area`, keep max 4 → [career, active, interview]

Tag Usage Summary:
- Redundant tags to remove: project (32), reference (28), daily (15)
- Valid subjects: career (45), react (28)
- Rarely used: old-tag (2) - Consider removing
```

**For each inconsistency:**
- Show note name
- Describe issue
- Show current tags
- Suggest corrections (remove folder-type tags, keep subject/status tags)
- Explain reasoning

### Step 5: Summary Report

After all checks complete:

```
Vault Health Check Complete!

Summary:
- Broken links: X found
- Orphaned notes: Y found
- Tag issues: Z found

Overall health: Good / Needs attention / Critical

Next steps:
1. Review broken links - create or fix most critical ones
2. Link orphaned notes or archive outdated content
3. Update tags following Tag Taxonomy
4. Run this check monthly for maintenance

Would you like help fixing any of these issues?
```

**Health assessment:**
- **Good**: <5 issues total
- **Needs attention**: 5-20 issues
- **Critical**: >20 issues or many broken links in active notes

## Tools Usage

**Obsidian MCP:**
- `obsidian_simple_search` - Find wiki links and patterns
- `obsidian_get_file_contents` - Read Tag Taxonomy, check note content
- `obsidian_list_files_in_dir` - List all notes
- `obsidian_list_files_in_vault` - Get complete file list

**Read tool:**
- Fallback for reading files if Obsidian MCP unavailable

## Configuration

Read from `.claude/obsidian-second-brain.local.md`:
- `vault_path`

## Best Practices

- **Report only, don't fix**: User maintains control
- **Prioritize findings**: Most critical issues first
- **Provide context**: Explain why something is an issue
- **Suggest solutions**: Give specific, actionable recommendations
- **Be encouraging**: Frame as "opportunities to improve" not "problems"
- **Offer help**: "Would you like help fixing X?"

## Error Handling

- **Obsidian MCP unavailable**: Use Grep tool with regex patterns
- **Large vault (>1000 notes)**: Process in batches, show progress
- **Tag Taxonomy not found**: Use default tag rules
- **Vault access issues**: Report what can be checked, skip inaccessible areas

## Related Skills

- **obsidian-workflows** - Link maintenance and vault health principles
- **vault-structure** - Understanding folder structure and special files
- **template-patterns** - No direct relevance but may reference

## Related Agents

- **link-maintainer** - May activate proactively when issues mentioned
- **tag-optimizer** - May activate proactively for tag suggestions

## Follow-up Commands

After maintenance check, suggest:
- `/process-inbox` - If inbox has many notes
- `/apply-template` - If notes need structure
- Manual fixes with user-guided edits

## Performance Considerations

**For large vaults (>500 notes):**
- Show progress: "Checking links... 50/500 notes"
- Batch processing: Process 100 notes at a time
- Time estimates: "This may take 2-3 minutes"
- Allow cancellation: "Press Ctrl+C to stop"

## Example Interaction

```
Assistant: Running vault health check...

Checking broken links... ✓
Checking orphaned notes... ✓
Checking tag consistency... ✓

Vault Health Check Complete!

Summary:
- Broken links: 3 found
- Orphaned notes: 5 found
- Tag issues: 2 found

Overall health: Needs attention

Most critical:
1. [[Project Plan]] - Referenced 8 times but doesn't exist
   Suggested: Create in 1 - Projects/

2. Resources/Important Article.md - No backlinks
   Suggested: Link from [[Web Development MOC]]

Would you like help fixing these issues?
```
