---
name: maintain-vault
description: Comprehensive vault health check - links, tags, 2-Link Rule, Related/Encounters sections
allowed-tools: [Read, Bash, AskUserQuestion, obsidian]
---

# Maintain Vault Command

Run a comprehensive vault health check to identify and report issues with links, tags, and note structure following Obsidian best practices.

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

First, check CLI availability:
```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

- If `CLI_AVAILABLE`: Use Obsidian CLI commands via Bash
- If `CLI_UNAVAILABLE`: Ask user "Obsidian CLI isn't available. May I use Obsidian MCP instead?" and wait for confirmation

## Purpose

Help user keep vault healthy and organized by identifying:

**Link Health:**
- Broken wiki links (links to non-existent notes)
- Orphaned notes (notes with no incoming links)
- 2-Link Rule violations (notes with <2 outgoing links)
- Unlinked Mentions (text matching note titles that could be linked)

**Structure Health:**
- Missing Related sections (concept notes without `## Related`)
- Missing Encounters sections (learning notes without `# Encounters`)
- TIL cross-references (TILs mentioning concepts not linked back)

**Tag Health:**
- Tag inconsistencies (tags not following Tag Taxonomy)

**Note:** This command **reports findings and suggests fixes** but does NOT auto-fix. User maintains full control.

## Workflow

### Step 1: Introduction

Inform user:
```
Running vault health check...

This will check for:

Link Health:
1. Broken wiki links
2. Orphaned notes (no incoming links)
3. 2-Link Rule violations (<2 outgoing links)
4. Unlinked Mentions (missed connection opportunities)

Structure Health:
5. Missing Related sections (concept notes)
6. Missing Encounters sections (learning notes)
7. TIL cross-references

Tag Health:
8. Tag consistency

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

### Step 4: Check 2-Link Rule

**Goal:** Find notes that violate the 2-Link Rule (every note should link to at least 2 others).

**Method:**
1. Get all notes in vault (excluding Templates, Archives, Daily Notes)
2. For each note, count outgoing wiki links `[[...]]`
3. Filter notes with <2 outgoing links
4. Prioritize concept notes in `3 - Resources/Coding/`

**Exclusions:**
- Files in `Templates/`
- Files in `4 - Archives/`
- Daily notes in `2 - Areas/Daily Ops/`
- MOCs (they link to many, but may have few outgoing)

**Report format:**
```
## 2-Link Rule Violations: X

Notes with fewer than 2 outgoing links:

1. 3 - Resources/Coding/React Hooks.md
   - Outgoing links: 1 ([[JavaScript]])
   - Suggested connections:
     - [[useState]] — if discussing state hooks
     - [[Component Composition]] — if discussing patterns
   - Action: Open note, check Outgoing Links panel for opportunities

2. 3 - Resources/Coding/CSS Grid.md
   - Outgoing links: 0
   - Suggested connections:
     - [[Flexbox]] — layout comparison
     - [[Responsive Design]] — common use case
   - Action: Add ## Related section with 2-5 links

Tip: Use Obsidian's Outgoing Links panel (right sidebar) to discover connections.
```

**For each violation:**
- Show note path
- Show current outgoing link count
- Suggest 2-3 potential connections based on topic
- Remind about Outgoing Links panel

### Step 5: Check Unlinked Mentions

**Goal:** Find text in notes that matches existing note titles but isn't linked.

**Method:**
1. Get list of all note titles (without extension)
2. For each note, search for text matching other note titles
3. Exclude text that's already inside `[[...]]` links
4. Report matches that could be linked

**Focus areas:**
- `3 - Resources/Coding/` - Concept notes often mention other concepts
- `3 - Resources/TIL/` - TILs reference concepts that should link
- `1 - Projects/` - Projects reference concepts and tools

**Report format:**
```
## Unlinked Mentions Found: X

Potential connections waiting to be linked:

1. 3 - Resources/TIL/til-2026-02-05.md
   - Mentions "closure" (5 times) → could link to [[Closure in JavaScript]]
   - Mentions "React" (3 times) → could link to [[React]]

2. 3 - Resources/Coding/Event Loop.md
   - Mentions "callback" (2 times) → could link to [[Callbacks]]
   - Mentions "Promise" (4 times) → could link to [[Promise in JavaScript]]

Tip: In Obsidian, check the Backlinks panel → "Unlinked mentions" section for each note.
```

**For each unlinked mention:**
- Show source note
- Show term and count
- Show target note that could be linked
- Remind about Unlinked Mentions panel in Obsidian

### Step 6: Check Missing Related Sections

**Goal:** Find concept notes that lack a `## Related` section for connections.

**Method:**
1. Get all notes in `3 - Resources/Coding/`
2. For each note, check if it contains `## Related`
3. Flag notes without this section

**Report format:**
```
## Missing Related Sections: X

Concept notes without ## Related section:

1. 3 - Resources/Coding/Higher-Order Functions.md
   - Has 3 outgoing links but no Related section
   - Action: Add ## Related with links + reasons

2. 3 - Resources/Coding/Array Methods.md
   - Has 0 outgoing links
   - Action: Add ## Related section:
     ```
     ## Related
     - [[Higher-Order Functions]] — map/filter/reduce are HOFs
     - [[Functional Programming]] — array methods enable FP patterns
     ```

Template for Related section:
```markdown
## Related
*Use Outgoing links panel to discover connections. Link 2-5 related notes with a reason why.*
- [[Note Name]] — brief reason for connection
```
```

### Step 7: Check Missing Encounters Sections

**Goal:** Find learning/concept notes that lack an `# Encounters` section for real-world experience.

**Method:**
1. Get all notes in `3 - Resources/Coding/`
2. Check if notes follow the Learning template (have Summary, Notes sections)
3. For each learning note, check if it contains `# Encounters`
4. Flag notes without this section

**Report format:**
```
## Missing Encounters Sections: X

Learning notes without # Encounters section:

1. 3 - Resources/Coding/Closure in JavaScript.md
   - Has Related section ✓
   - Missing Encounters section
   - Action: Add # Encounters to track real-world usage

2. 3 - Resources/Coding/useCallback.md
   - Has Related section ✓
   - Missing Encounters section
   - Tip: Next time you use useCallback, add an encounter entry

Template for Encounters section:
```markdown
# Encounters
*Real-world bugs, usage, and insights. Add entries when you encounter this concept in practice.*

## YYYY-MM-DD - [Brief title]
[What happened, what you learned]
Link: [[TIL or project note]]
```
```

### Step 8: Check TIL Cross-References

**Goal:** Find TIL notes that mention concepts but those concepts don't link back in their Encounters.

**Method:**
1. Get all TIL notes from `3 - Resources/TIL/`
2. For each TIL, extract linked concepts (wiki links)
3. For each linked concept, check if its Encounters section references the TIL
4. Report missing cross-references

**Report format:**
```
## TIL Cross-References Missing: X

TIL notes not referenced in concept Encounters:

1. til-2026-02-05.md links to [[Closure in JavaScript]]
   - Closure note has Encounters section ✓
   - But doesn't reference this TIL
   - Action: Add encounter entry to Closure note:
     ```
     ## 2026-02-05 - [Title from TIL]
     [Brief summary of the encounter]
     Link: [[til-2026-02-05]]
     ```

2. til-2026-01-20.md links to [[React Hooks]]
   - React Hooks note missing Encounters section
   - Action: Add Encounters section with this reference

This creates bidirectional connections between learning moments and concepts.
```

### Step 9: Check Tag Consistency

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

### Step 10: Summary Report

After all checks complete:

```
Vault Health Check Complete!

Summary:

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

Quick wins:
- Add Related section to X notes (template provided above)
- Link Y unlinked mentions
- Add Z encounter entries from recent TILs

Would you like help fixing any of these issues?
```

**Health assessment:**
- **Good**: <10 issues total
- **Needs attention**: 10-30 issues
- **Critical**: >30 issues or many broken links in active notes

**Priority order for fixes:**
1. Broken links (breaks navigation)
2. 2-Link Rule violations (isolated knowledge)
3. Missing Related sections (easy win)
4. Unlinked mentions (connection opportunities)
5. Missing Encounters (living documents)
6. TIL cross-references (bidirectional links)
7. Tag issues (organization)

## Tools Usage

**Obsidian CLI (preferred):**
```bash
# Search for patterns
obsidian search query="[[" format=json

# Read specific files
obsidian read path="3 - Resources/Obsidian org/Tag Taxonomy.md"

# List all notes in folder
obsidian files folder="3 - Resources/Coding/" format=json

# List entire vault
obsidian files format=json
```

**Obsidian MCP (fallback - ask user first):**
- `obsidian_simple_search` - Find wiki links and patterns
- `obsidian_get_file_contents` - Read Tag Taxonomy, check note content
- `obsidian_list_files_in_dir` - List all notes
- `obsidian_list_files_in_vault` - Get complete file list

**Read/Grep tools:**
- Additional fallback using Grep for pattern matching

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
Checking 2-Link Rule... ✓
Checking unlinked mentions... ✓
Checking Related sections... ✓
Checking Encounters sections... ✓
Checking TIL cross-references... ✓
Checking tag consistency... ✓

Vault Health Check Complete!

Summary:

Link Health:
- Broken links: 3 found
- Orphaned notes: 5 found
- 2-Link Rule violations: 12 found
- Unlinked mentions: 8 found

Structure Health:
- Missing Related sections: 15 found
- Missing Encounters sections: 20 found
- TIL cross-references missing: 4 found

Tag Health:
- Tag issues: 2 found

Overall health: Needs attention

Priority fixes:
1. [[Project Plan]] - Referenced 8 times but doesn't exist
2. 12 concept notes have <2 links (knowledge silos)
3. 15 notes missing Related section (quick win)

Quick wins:
- Add Related section to 15 notes (template: ## Related + 2-5 links with reasons)
- Link 8 unlinked mentions (check Obsidian's Unlinked Mentions panel)
- Add 4 Encounter entries from recent TILs

Would you like help fixing any of these issues?
```
