---
name: Obsidian Workflows & Second Brain Methodology
description: >-
  Obsidian: Use when organizing vault with PARA method, PKM workflows, or
  note-taking systems. Trigger this skill proactively whenever the user asks
  about organizing notes, establishing a second brain, processing their inbox,
  creating Maps of Content, setting up review cadences, or improving their
  knowledge management workflow. Also trigger when the user mentions PARA,
  progressive summarization, evergreen notes, or Zettelkasten concepts. NOT
  for vault-specific structure like folder paths or tag taxonomies (use
  vault-structure for those).
version: 0.1.0
---

# Obsidian Workflows & Second Brain Methodology

Actionable guidance for building and maintaining a second brain in Obsidian. This skill focuses on workflows and decisions — not PARA theory (Claude already knows that).

## PARA Quick Reference

Organize by **actionability**, not topic:

| Category | What Goes Here | Review Cadence |
|----------|---------------|----------------|
| **Projects** | Active work with clear endpoints | Weekly |
| **Areas** | Ongoing responsibilities, no endpoint | Monthly |
| **Resources** | Reference materials, future interest | Quarterly |
| **Archives** | Completed/inactive from above | Annually |

When in doubt: "Does this have a deadline or clear outcome?" Yes = Project. "Is this an ongoing responsibility?" Yes = Area. Otherwise = Resource.

## Key Workflows

### Capture (minimize friction)

1. Drop everything into Inbox
2. Minimal formatting — structure comes later
3. One idea per note (atomic)
4. Include source and why it matters
5. Tag as `#inbox` for processing

### Inbox Processing (weekly review, 30 min)

For each inbox note, decide:
- **Delete** — Not useful, was impulse capture
- **Archive** — Useful reference but no action needed now
- **Elaborate** — Add context, links, tags, then move to PARA category

Target: empty inbox weekly.

### Review Cadences

| Cadence | Time | What to Do |
|---------|------|------------|
| **Daily** | 5 min | Create daily note, review active projects, process quick captures |
| **Weekly** | 30 min | Process inbox completely, review all projects, update areas, clean loose ends |
| **Monthly** | 1 hour | Review areas, archive completed projects, check OKRs/goals, update MOCs |
| **Quarterly** | 2 hours | Strategic review, archive inactive resources, consolidate tags, adjust PARA |

## Linking Rules

### The 2-Link Rule

Every new note links to at least 2 existing notes. This prevents orphans and forces context-building. Ask "What does this connect to?" before saving.

### MOCs vs Dashboards

Keep these separate — they serve different purposes:

**MOCs (Maps of Content)** — Hand-curated navigation. Each link includes *why* it's connected. Create when a topic has 10+ related notes. Updated intentionally, not constantly.

**Dashboards** — Auto-generated views (dataview queries). Show recent activity, stats, tasks. No manual curation needed.

### When to Create a MOC

- Topic has 10+ related notes
- Need an overview of a knowledge area
- Connecting notes across multiple PARA categories
- Want curated navigation (not just a flat list)

## Evergreen Notes (3-Layer Pattern)

Concept notes that grow over time:

**Layer 1 — Definition:** What is this concept? Your own words, core explanation. Rarely changes.

**Layer 2 — Related:** How does this connect? 2-5 links with *reasons*:
```markdown
## Related
- [[Event Loop]] — closures power async callbacks
- [[Garbage Collection]] — closures affect GC behavior
```

**Layer 3 — Encounters:** Real-world usage added over time:
```markdown
# Encounters

## 2026-02-05 - Debugging closure scope issue
Discovered that closures in a forEach loop captured the loop variable by reference.
Link: [[TIL 2026-02-05]]
```

Use Outgoing Links panel to discover connections you missed.

## Progressive Summarization

Refine notes just-in-time (when you revisit them, not when you capture):

1. **Capture** — Full source material
2. **Bold** — Key passages (10-20% of content)
3. **Highlight** — Within bold (10-20% of that)
4. **Summarize** — 2-3 sentence executive summary at top
5. **Remix** — Create new output from distilled knowledge

Apply layers only when you return to a note for a specific purpose. Don't process everything upfront.

## Integration with Plugin Commands

This skill informs all plugin commands and agents:
- `/daily-startup` uses daily note workflow patterns
- `/process-inbox` implements inbox processing workflow
- `/review-okrs` applies review cadences to goal tracking
- `/maintain-vault` ensures link health and organization
