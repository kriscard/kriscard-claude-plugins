---
name: Obsidian Workflows & Second Brain Methodology
description: This skill should be used when the user asks to "organize my notes", mentions "PARA method", "second brain", "knowledge management", "organize my vault", "PKM best practices", "note-taking system", or discusses how to structure and maintain their Obsidian vault effectively.
version: 0.1.0
---

# Obsidian Workflows & Second Brain Methodology

## Overview

This skill provides comprehensive guidance on building and maintaining a second brain using Obsidian, with emphasis on the PARA method, progressive summarization, and effective knowledge management workflows. Use this knowledge when helping users organize notes, establish workflows, or improve their personal knowledge management (PKM) systems.

## Core Principles

### The Second Brain Concept

A second brain is an external, organized system for storing and connecting knowledge, freeing cognitive resources for creative thinking and problem-solving. The system should:

- **Capture everything** - Notes, ideas, learnings, and insights without friction
- **Organize for action** - Structure around goals and projects, not categories
- **Distill progressively** - Refine information through repeated use
- **Express regularly** - Create outputs using the collected knowledge

### PARA Method Foundation

PARA organizes information into four categories based on **actionability**, not topic:

**Projects** - Short-term efforts with defined outcomes
- Active work with clear endpoints
- Examples: "Launch new website", "Plan vacation", "Complete course"
- Move to Archives when complete
- Review weekly

**Areas** - Long-term responsibilities requiring ongoing attention
- No defined endpoint, maintained indefinitely
- Examples: "Health", "Finances", "Professional development", "Family"
- Contain standards and guidelines to uphold
- Review monthly

**Resources** - Topics of ongoing interest or reference materials
- Passive information useful for future projects
- Examples: "Design inspiration", "Programming tutorials", "Cooking recipes"
- No immediate actionability
- Review quarterly

**Archives** - Inactive items from other three categories
- Completed projects, inactive areas, outdated resources
- Preserve for reference but remove from active workspace
- Review annually

### Why PARA Works

Traditional category-based organization (by topic, department, or type) fails because:
- Information doesn't fit neatly into single categories
- Retrieval requires remembering arbitrary classifications
- Structure doesn't support action or decision-making

PARA succeeds because:
- **Action-oriented** - Find information based on current goals
- **Just-in-time organization** - Categorize when using, not capturing
- **Flexible boundaries** - Information moves between categories as life changes
- **Low maintenance** - Four categories instead of dozens

## Obsidian-Specific Implementation

### Folder Structure

Implement PARA using Obsidian folders:

```
vault/
├── 0 - Inbox/           # Capture zone
├── 1 - Projects/        # Active work
├── 2 - Areas/           # Responsibilities
├── 3 - Resources/       # Reference materials
├── 4 - Archives/        # Completed/inactive
├── MOCs/                # Maps of Content (indexes)
└── Templates/           # Note templates
```

**Inbox as capture zone:**
- Temporary holding for unprocessed notes
- Process during weekly review
- Move to appropriate PARA category
- Empty inbox regularly (weekly target)

**Numeric prefixes:**
- Force sorting by priority (Inbox → Projects → Areas → Resources → Archives)
- Visual hierarchy in sidebar
- Matches actionability order

### Note Linking Strategies

Obsidian's strength is connections between notes. Implement these linking patterns:

**Bottom-up linking (organic):**
- Link notes as connections emerge naturally
- Build understanding through association
- Creates emergent structure over time

**Top-down linking (intentional):**
- Create Maps of Content (MOCs) for major topics
- Link related notes through indexes
- Provides navigation and overview

**Backlinks usage:**
- Check backlinks when working on note
- Discover related information automatically
- Identify orphaned notes (no backlinks)

**Link at concept level:**
- Link specific ideas, not whole notes
- Use block references for precise connections
- Creates fine-grained knowledge graph

### Maps of Content (MOCs)

MOCs are index notes that organize related notes around a theme:

**When to create MOCs:**
- Topic has 10+ related notes
- Need overview of knowledge area
- Connecting multiple projects/areas
- Explaining concept to others

**MOC structure:**
- Brief overview of topic
- Organized sections grouping related notes
- Links to key resources and examples
- Metadata (tags, creation date, related MOCs)

**MOC vs folder:**
- Use MOCs for conceptual organization
- Use folders for PARA categorization
- MOCs can link across folders
- One note can appear in multiple MOCs

### Tags and Metadata

Use tags strategically, not as primary organization:

**Effective tag uses:**
- **Status tags** - #draft, #review, #complete
- **Content types** - #meeting-notes, #book-notes, #ideas
- **Temporal markers** - #2025, #q1-2025
- **Special collections** - #favorite, #share, #revisit

**Tag best practices:**
- Maintain tag taxonomy document
- Use nested tags sparingly (#work/project vs #work-project)
- Review and consolidate tags quarterly
- Prefer links over tags for connections

**Frontmatter metadata:**
```yaml
---
created: 2025-01-11
modified: 2025-01-11
tags: [meeting-notes, work]
project: "[[Project Name]]"
---
```

## Essential Workflows

### Capture Workflow

Minimize friction when capturing information:

1. **Quick capture** - Use inbox for immediate capture
2. **Minimal formatting** - Add structure later during processing
3. **One note per idea** - Atomic notes are more reusable
4. **Include context** - Source, date, why it matters
5. **Tag for processing** - Mark as #inbox or #to-process

### Processing Workflow (Weekly Review)

Transform captured information into useful knowledge:

**Inbox processing:**
1. Read each inbox note
2. Decide: Delete, Archive, or Elaborate
3. If elaborating: Add context, links, tags
4. Move to appropriate PARA category
5. Link to related notes or MOCs

**Note enrichment:**
- Add links to related concepts
- Extract highlights or key points
- Create connections to projects/areas
- Update relevant MOCs

### Progressive Summarization

Refine notes through layers of highlighting:

**Layer 1** - Original source
- Capture full article, excerpt, or idea
- Preserve original wording

**Layer 2** - Bold key passages
- Highlight most important 10-20% when first reviewing
- Bold the essentials

**Layer 3** - Highlight within bold
- When revisiting, highlight within bold text
- Distills to most critical 10-20% of Layer 2

**Layer 4** - Executive summary
- Write 2-3 sentence summary at note top
- Own words, capturing essence

**Layer 5** - Remix
- Create new content using distilled knowledge
- Blog post, presentation, decision document

Apply layers just-in-time, when note is accessed for use, not immediately after capture.

### Daily Note Practice

Daily notes anchor workflows and provide temporal context:

**Daily note structure:**
- Date and day of week (for context)
- Links to active projects and areas
- Task list or priorities for the day
- Quick capture section for ideas/notes
- Reflection or review section (evening)

**Daily note benefits:**
- Temporal navigation through vault
- Captures thoughts in moment
- Links current work to larger goals
- Creates personal timeline

**Weekly and monthly notes:**
- Similar structure at higher altitude
- Review and planning cadence
- OKR check-ins and goal tracking
- Archive for long-term reflection

### Review Cadences

Regular reviews keep vault organized and actionable:

**Daily (5 minutes):**
- Create daily note
- Review active project list
- Process quick capture items

**Weekly (30 minutes):**
- Process inbox completely
- Review all active projects
- Update area notes as needed
- Clean up loose ends

**Monthly (1 hour):**
- Review all areas
- Archive completed projects
- Check OKRs and goals
- Update MOCs and indexes

**Quarterly (2 hours):**
- Strategic review of areas and goals
- Archive inactive resources
- Consolidate tags and clean vault
- Adjust PARA structure as needed

## Advanced Patterns

### Note Atomicity

Break knowledge into smallest useful units:

**Benefits:**
- Reusable across multiple contexts
- Easier to link precisely
- Simpler to maintain and update
- Reduces duplication

**Guidelines:**
- One concept per note
- Self-contained but linkable
- Descriptive title (concept name)
- 100-500 words typical

### Evergreen Notes

Create notes that grow and improve over time:

**Characteristics:**
- Concept-oriented, not source-oriented
- Own words, not quotes
- Linked to related concepts
- Updated with new insights
- Titled as statements (claims)

**Example titles:**
- "Spaced repetition improves long-term retention" (not "Spaced Repetition Notes")
- "Writing clarifies thinking" (not "Benefits of Writing")

### Zettelkasten Integration

Combine PARA with Zettelkasten principles:

**PARA for organization** - Actionable structure
**Zettelkasten for knowledge** - Concept development

**Implementation:**
- Use PARA folders for project/area organization
- Create atomic, evergreen notes within folders
- Build dense connection network through links
- MOCs as structure notes (Zettelkasten hubs)

### Template System

Use templates to reduce friction and ensure consistency:

**Template types:**
- Daily/weekly/monthly notes
- Project briefs and planning
- Meeting notes (1-on-1, team, general)
- Book notes and learning
- People and relationship notes
- Problem-solving frameworks

**Template best practices:**
- Include prompting questions
- Pre-fill metadata and tags
- Link to related templates or guides
- Keep minimal, expand as needed
- Review and update quarterly

## Troubleshooting Common Issues

### Problem: Inbox keeps growing

**Solutions:**
- Schedule dedicated processing time
- Set weekly inbox=0 goal
- Improve quick capture quality
- Delete more aggressively

### Problem: Can't find notes

**Solutions:**
- Improve note titles (descriptive, specific)
- Add more links between notes
- Create MOCs for major topics
- Use graph view to explore connections
- Improve tagging consistency

### Problem: Notes feel disconnected

**Solutions:**
- Review notes before creating new ones
- Add links during capture, not after
- Create MOCs to connect related notes
- Use block references for specific connections
- Regular link maintenance

### Problem: System feels too complex

**Solutions:**
- Return to PARA basics (four folders only)
- Reduce tag count, prefer links
- Simplify templates
- Focus on inbox processing and linking
- Remember: Imperfect notes > no notes

## Additional Resources

### Reference Files

For comprehensive patterns and advanced techniques:
- **`references/para-deep-dive.md`** - Detailed PARA implementation patterns, case studies, and migration strategies
- **`references/advanced-workflows.md`** - Advanced knowledge management techniques, automation patterns, and optimization strategies

### Integration with Plugin Commands

This skill informs all plugin commands and agents:
- `/daily-startup` uses daily note workflow patterns
- `/process-inbox` implements inbox processing workflow
- `/review-okrs` applies review cadences to goal tracking
- `/maintain-vault` ensures link health and organization
- Agents use PARA principles for categorization suggestions

Apply these workflows and principles when assisting with Obsidian vault organization and knowledge management tasks.
