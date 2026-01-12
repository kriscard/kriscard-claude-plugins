# Advanced Obsidian Workflows

Advanced techniques, automation patterns, and optimization strategies for power users.

## Advanced Linking Strategies

### Block References for Precision

Link specific paragraphs, not entire notes:

```markdown
## In Source Note
This is an important insight. ^key-insight

## In Referencing Note
As noted: ![[Source Note#^key-insight]]
```

**Use cases:**
- Quote specific claims in arguments
- Reference exact specifications in projects
- Build composite documents from multiple sources
- Track evolution of ideas across notes

### Inline Links vs Reference Links

**Inline links** (immediate context):
```markdown
The [[PARA Method]] organizes notes by actionability.
```

**Reference-style links** (cleaner reading):
```markdown
The PARA Method[^1] organizes notes by actionability.

[^1]: [[PARA Method]]
```

**When to use reference-style:**
- Multiple references to same note
- Academic or formal writing
- Long-form content where inline links disrupt flow
- Publishing or sharing outside Obsidian

### Contextual Backlinks

When reviewing backlinks, add context:

```markdown
# In Current Note

## Mentioned In

[[Other Note]] - Discusses related concept X
[[Project Note]] - Application in [Project Name]
[[Resource Note]] - Historical background
```

**Benefits:**
- Understand why connection exists
- Faster navigation between related ideas
- Clearer knowledge graph

## Progressive Summarization Advanced

### Five-Layer System

**Layer 0: Source capture**
- Full article, book excerpt, meeting transcript
- Preserve original formatting and structure

**Layer 1: Initial highlighting (20%)**
- Bold key passages on first read
- What would you want if reviewing in 3 months?

**Layer 2: Refined highlighting (4%)**
- Highlight within bold when revisiting
- Most essential 20% of Layer 1

**Layer 3: Summary (1 paragraph)**
- 3-5 sentences in your words
- Placed at top of note
- Captures core message

**Layer 4: Synthesis (1 sentence)**
- Single insight or takeaway
- Links to related concepts
- Actionable if possible

**Layer 5: Original creation**
- Blog post, presentation, decision document
- Uses distilled knowledge from Layers 0-4
- Knowledge transformed into value

### When to Stop Summarizing

Not every note needs all layers:

**Stop at Layer 1** if:
- Note is reference-only
- Content is self-evident
- Unlikely to use again soon

**Stop at Layer 2** if:
- Good enough for current needs
- Not critical to current work
- Time better spent elsewhere

**Push to Layer 4+** if:
- Central to important project
- Frequently referenced
- Teaching or sharing with others
- Creating original work

### Progressive Summarization for Code

Adapt for technical notes:

**Layer 1:** Comment key functions/sections
**Layer 2:** Extract core algorithms or patterns
**Layer 3:** Write "how it works" summary
**Layer 4:** Document "when to use" guidance
**Layer 5:** Create tutorial or implementation guide

## Advanced Templating

### Dynamic Template Fields

Use template variables:

```markdown
---
created: {{date}}
modified: {{date}}
tags: [meeting-notes]
attendees: {{ATTENDEES}}
---

# Meeting: {{MEETING_TITLE}}

## Date
{{date:YYYY-MM-DD}}

## Attendees
{{ATTENDEES}}

## Agenda
1. {{TOPIC_1}}
2. {{TOPIC_2}}
3. {{TOPIC_3}}

## Notes


## Action Items
- [ ] {{ACTION_1}} - @{{OWNER_1}} - {{DUE_1}}

## Follow-up
Next meeting: {{NEXT_MEETING_DATE}}
```

### Template Chaining

Templates that reference other templates:

```markdown
# Project Brief Template

## Overview
{{PROJECT_OVERVIEW}}

## Timeline
Start: {{START_DATE}}
End: {{END_DATE}}

## Related Templates
- Use [[Meeting Notes]] for project meetings
- Use [[Task Template]] for project tasks
- Use [[Decision Log]] for key decisions

## Weekly Status Template
![[Project Status Template]]
```

### Conditional Template Sections

Include sections based on note type:

```markdown
# Note: {{TITLE}}

## Core Content

{{CONTENT}}

<!-- If Learning Note -->
## Source
{{SOURCE}}

## Key Takeaways
- {{TAKEAWAY_1}}

<!-- If Project Note -->
## Outcome
{{OUTCOME}}

## Next Actions
- [ ] {{ACTION_1}}

<!-- If Meeting Note -->
## Attendees
{{ATTENDEES}}

## Decisions
- {{DECISION_1}}
```

## Automation Patterns

### Auto-linking Strategies

**Alias system for common terms:**

```markdown
---
aliases: [ML, machine learning, ML models]
---

# Machine Learning
```

Now typing `[[ML]]` links to this note automatically.

**Use for:**
- Acronyms and abbreviations
- Alternative names for concepts
- Common misspellings

### Dataview Queries for Organization

**Active projects dashboard:**

````markdown
# Active Projects

```dataview
TABLE status, due-date as "Due"
FROM "1 - Projects"
WHERE !contains(file.folder, "Archive")
SORT due-date ASC
```
````

**Unprocessed inbox count:**

````markdown
# Inbox Status

```dataview
LIST
FROM "0 - Inbox"
```

Currently: {{INBOX_COUNT}} notes to process
````

**Orphaned notes finder:**

````markdown
# Orphaned Notes

```dataview
TABLE file.inlinks as "Backlinks"
WHERE length(file.inlinks) = 0
AND !contains(file.folder, "Archive")
```
````

### Daily Note Automation

**Auto-create from template:**
- Use Templater or Daily Notes core plugin
- Generate on first access each day
- Auto-link to yesterday's note
- Pull in tasks from project notes

**Dynamic daily sections:**

```markdown
# {{date:dddd, MMMM DD, YYYY}}

## Quick Links
- [[{{date-1d:YYYY-MM-DD}}|Yesterday]]
- [[{{date+1d:YYYY-MM-DD}}|Tomorrow]]

## Active Projects
```dataview
LIST
FROM "1 - Projects"
WHERE !completed
```

## Today's Focus
1.
2.
3.

## Notes


## Reflection
What went well:
What to improve:
```

## Advanced Graph Analysis

### Using Graph View Strategically

**Local graph for note context:**
- Open local graph for current note
- Identify unexpected connections
- Find missing links to related concepts
- Spot clustering patterns

**Global graph for structure analysis:**
- Identify isolated clusters (potential MOC targets)
- Find over-connected hub notes (may need splitting)
- Locate orphaned notes (no connections)
- Visualize PARA separation

**Graph view filters:**

```
# Show only project notes
path:"1 - Projects"

# Show notes with specific tag
tag:#review

# Show notes modified recently
file.mtime > date(today) - dur(7 days)

# Exclude archives
-path:"4 - Archives"
```

### Graph-Based Discovery

**Find related notes:**
1. Open note's local graph
2. Explore 2-3 degrees of connection
3. Identify relevant but unlinked notes
4. Create explicit links with context

**Identify knowledge gaps:**
1. Find nodes with few connections
2. Search for related concepts
3. Create bridging notes or MOCs
4. Build missing infrastructure

## Collaborative Workflows

### Team Vault Patterns

**Shared vs personal vaults:**

**Shared vault structure:**
```
team-vault/
├── 0 - Inbox/
├── Projects/            # Team projects
├── Team Knowledge/      # Shared resources
├── Meeting Notes/       # All team meetings
└── Templates/           # Shared templates
```

**Personal vault structure:**
```
personal-vault/
├── 0 - Inbox/
├── 1 - Projects/        # Personal projects
│   └── Work/            # Links to team vault
├── 2 - Areas/
└── 3 - Resources/
```

**Link between vaults:**
```markdown
# Personal Note
Related team project: [[../team-vault/Projects/Project X]]
```

### Review and Feedback Workflows

**Peer review process:**
1. Create review copy of note
2. Use comments or new color for feedback
3. Link review note to original
4. Incorporate feedback, archive review

**Version control integration:**
- Commit notes to git regularly
- Use branches for major revisions
- Tag releases or milestones
- Review diffs for change tracking

## Mobile Workflows

### Mobile-First Capture

**Quick capture template:**

```markdown
---
created: {{date}}
type: mobile-capture
status: to-process
---

# Quick Capture - {{date:HH:mm}}

{{CONTENT}}

#inbox #mobile
```

**Voice-to-text patterns:**
- Use punctuation commands
- Keep sentences short
- Review and clean up later
- Tag for cleanup: #voice-note

### Sync Optimization

**Minimize sync conflicts:**
- Use different working files on different devices
- Avoid editing same note on multiple devices simultaneously
- Process inbox on single device
- Use git for team vaults (not Obsidian Sync for collaboration)

**Device-specific workflows:**
- Desktop: Long-form writing, complex linking, graph exploration
- Tablet: Reading, review, moderate editing
- Phone: Quick capture, task checking, reference lookup

## Performance Optimization

### Large Vault Management

**Over 1,000 notes:**
- Aggressive archiving (move old projects/resources)
- Split vault if necessary (personal vs work)
- Use search instead of browsing
- Limit graph view complexity

**Over 10,000 notes:**
- Consider multiple vaults by domain
- Use external search tools (ripgrep, The Silver Searcher)
- Cache-heavy plugins may slow down
- Regular maintenance becomes critical

### Reduce Plugin Overhead

**Essential plugins only:**
- Core plugins: Templates, Daily Notes, Graph View, Search
- Community: Maximum 10-15 active plugins
- Disable experimental features
- Test startup time regularly

**Heavy plugins to watch:**
- Dataview (complex queries)
- Calendar (many daily notes)
- Database plugins
- Real-time sync plugins

### Search Optimization

**Fast search techniques:**

```
# Exact phrase
"exact phrase here"

# Multiple terms (AND)
term1 term2 term3

# Either term (OR)
term1 OR term2

# Exclude term
term1 -term2

# In specific folder
path:"1 - Projects" search term

# With specific tag
tag:#important search term

# File name only
file:keyword
```

**Saved searches:**
Create MOC for common searches:

```markdown
# Common Searches

## Unprocessed Inbox
path:"0 - Inbox" -tag:#processed

## Active Tasks
[ ] -path:"4 - Archives"

## Recent Updates
file.mtime > date(today) - dur(7 days)
```

## Integration Patterns

### External Tools Integration

**PDF annotations → Obsidian:**
- Extract highlights from PDF readers
- Create note per PDF with annotations
- Link to original PDF location
- Tag with #pdf-notes, #source

**Web clippings → Obsidian:**
- Use web clipper tools
- Create note from article
- Apply progressive summarization
- Link to related permanent notes

**Task managers → Obsidian:**
- Use Obsidian for project-level tasks
- Use task manager for day-to-day execution
- Weekly sync between systems
- Link task manager items in project notes

**Calendars → Daily Notes:**
- Pull meeting info into daily notes
- Create meeting notes automatically
- Link calendar events to project notes

### Export and Publishing

**From Obsidian to blog:**
1. Write in Obsidian (perfect draft)
2. Apply Layer 4-5 summarization
3. Convert wiki links to standard markdown
4. Export to blog platform
5. Keep Obsidian version as source

**From Obsidian to presentation:**
1. Create outline note
2. Expand sections in individual notes
3. Use Marp, Slidev, or Reveal.js
4. Link slides back to source notes

**From Obsidian to PDF:**
1. Use Pandoc for conversion
2. Apply custom CSS for styling
3. Include linked notes if needed
4. Preserve backlinks as footnotes

## Maintenance Automation

### Weekly Maintenance Script

```bash
#!/bin/bash
# Weekly Obsidian maintenance

VAULT_PATH="$HOME/obsidian-vault"

echo "Running weekly maintenance..."

# Find orphaned notes
echo "\nOrphaned notes (no backlinks):"
# Logic to find notes with no incoming links

# Find broken links
echo "\nBroken links:"
# Logic to find [[links]] to non-existent notes

# Count inbox notes
echo "\nInbox status:"
find "$VAULT_PATH/0 - Inbox" -name "*.md" | wc -l
echo "notes to process"

# List overdue projects
echo "\nOverdue projects:"
# Logic to find projects past due date

# Tag analysis
echo "\nMost used tags:"
# Logic to count tag usage
```

### Monthly Cleanup Tasks

**Automated cleanup checklist:**
- [ ] Archive completed projects
- [ ] Consolidate duplicate tags
- [ ] Update MOCs with new notes
- [ ] Remove broken links
- [ ] Compress old images
- [ ] Backup vault

**Semi-automated:**
```bash
# Find notes not modified in 90+ days
find vault/ -name "*.md" -mtime +90

# Find large files (>1MB)
find vault/ -size +1M

# Find duplicate file names
find vault/ -name "*.md" -type f -exec basename {} \; | sort | uniq -d
```

## Advanced MOC Patterns

### Hierarchical MOCs

**Level 1: Domain MOC**
- Top-level overview
- Links to sub-MOCs
- 10-30 notes total

**Level 2: Topic MOCs**
- Focused on specific topic
- Links to individual notes
- 5-20 notes each

**Level 3: Project/Concept Notes**
- Atomic concepts
- Actual content
- Densely linked

**Example:**
```
Web Development (Domain MOC)
├── Frontend Frameworks (Topic MOC)
│   ├── React Patterns
│   ├── Vue Composition API
│   └── Svelte Reactivity
├── Backend Architecture (Topic MOC)
└── DevOps Practices (Topic MOC)
```

### Dynamic MOCs with Dataview

````markdown
# AI & Machine Learning MOC

## Recent Notes
```dataview
TABLE file.ctime as "Created"
FROM #ai OR #machine-learning
SORT file.ctime DESC
LIMIT 10
```

## By Topic

### Fundamentals
```dataview
LIST
FROM #ai-fundamentals
SORT file.name ASC
```

### Applications
```dataview
LIST
FROM #ai-applications
SORT file.name ASC
```
````

**Benefits:**
- Auto-updates as notes added
- No manual maintenance
- Shows freshest content
- Filters by metadata

## Specialized Workflows

### Research Workflows

**Literature review process:**
1. **Capture:** Import papers/articles to vault
2. **Annotate:** Progressive summarization (Layers 1-2)
3. **Synthesize:** Create concept notes from multiple sources
4. **Connect:** Link concepts across papers
5. **Organize:** Create research MOC
6. **Write:** Draft paper/thesis referencing notes

**Research vault structure:**
```
research-vault/
├── 0 - Papers/              # Original sources
├── 1 - Concepts/            # Atomic ideas
├── 2 - Synthesis/           # Connected insights
├── 3 - Writing/             # Drafts and outputs
└── Research MOCs/           # Topic indexes
```

### Learning Workflows

**Course/book processing:**
1. **Preview:** Create overview note before starting
2. **Capture:** Take notes as you learn (in course's project folder)
3. **Consolidate:** After each section, review and link
4. **Extract:** Move evergreen concepts to Resources
5. **Apply:** Create project using knowledge
6. **Archive:** Move course notes when complete

**Spaced repetition integration:**
- Extract key concepts as questions
- Use flashcard plugins or external SRS
- Link flashcards back to source notes
- Review and update as understanding deepens

### Writing Workflows

**Long-form writing process:**
1. **Brainstorm:** Capture ideas in separate notes
2. **Outline:** Create structure note with links
3. **Draft:** Write sections in individual notes
4. **Compile:** Combine using transclusion
5. **Edit:** Refine in linear document
6. **Publish:** Export final version

**Manuscript vault organization:**
```
book-project/
├── _Outline.md              # Structure
├── Chapters/
│   ├── 01 - Introduction/
│   ├── 02 - Chapter Two/
│   └── ...
├── Research/                # Source notes
└── _Master Manuscript.md    # Compiled version
```

## Conclusion

Advanced workflows emerge from consistent practice with basics. Start simple, add complexity only when basic system proves insufficient. The most advanced workflow is one that you actually maintain.

Key principles:
- Automate repetitive tasks
- Optimize only when necessary
- Maintain simplicity where possible
- Regular review prevents entropy
- Tools serve workflow, not vice versa

Remember: The goal is actionable knowledge, not organizational perfection.
