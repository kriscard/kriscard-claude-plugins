---
name: Vault Structure & Configuration
description: This skill should be used when needing to understand the user's specific Obsidian vault structure, folder organization, tagging system, or when working with "Tag Taxonomy", "Tag MOC", "PARA Method Implementation", or vault-specific organizational patterns. Load when discussing vault organization, note placement, or referencing vault configuration files.
version: 0.1.0
---

# Vault Structure & Configuration

## Overview

This skill provides detailed knowledge of the user's specific Obsidian vault structure, including folder organization, tagging taxonomy, templates, and organizational conventions. Use this knowledge when suggesting where to place notes, how to tag them, or when referencing vault-specific files and patterns.

**Vault Path:** `/Users/kriscard/obsidian-vault-kriscard`

## Core Folder Structure

The vault implements a modified PARA method with additional organizational folders:

### Primary Organization (0 - PARA/)

```
0 - PARA/
├── 0 - Inbox/              # Unprocessed notes, process weekly
├── 1 - Projects/           # Active work with deadlines
├── 2 - Areas/              # Ongoing responsibilities
├── 3 - Resources/          # Reference materials
├── 4 - Archives/           # Completed/inactive items
├── MOCs/                   # Maps of Content (navigation)
├── Templates/              # Vault-wide templates
└── [Organization Docs]/    # PARA guides, taxonomies
```

### Secondary Folders (1 - Notes/)

```
1 - Notes/
├── Daily Notes/            # Daily journal and planning
├── OKRS/                   # Goal tracking (quarterly, monthly, weekly)
├── Weekly Planning/        # Weekly reviews and plans
├── People/                 # Relationship notes
└── 0_Archives/             # Archived daily notes
```

### Additional Folders

```
Canvas/                     # Visual mind maps
Fitness/                    # Training plans and logs
Side Project/               # Personal projects
Templates/                  # Note templates
temporary/                  # Scratch space
```

### Key Organizational Documents

Located in `0 - PARA/`:
- **Tag Taxonomy.md** - Simplified 3-4 tag system, tagging guidelines
- **Tag MOC.md** - Tag hierarchy browser with Dataview queries
- **PARA Method Implementation.md** - Vault-specific PARA guide
- **Vault Organization Guide.md** - Maintenance and organization patterns
- **Vault Maintenance Guide.md** - Regular maintenance checklists

## Tagging System

The vault uses a **simplified tag system with maximum 3-4 tags per note**.

### Tag Categories

**1. Content Type (Required - Pick One):**
- `flashcards` - Spaced repetition materials
- `reference` - Documentation and guides
- `project` - Active work with deadlines
- `area` - Ongoing responsibilities
- `meeting` - Meeting notes
- `daily` - Daily notes and planning
- `moc` - Maps of Content

**2. Subject (Required - Pick One):**
- `javascript` - JavaScript ecosystem
- `react` - React framework
- `css` - Styling and design
- `typescript` - TypeScript features
- `web` - General web dev (APIs, GraphQL, performance)
- `career` - Professional development
- `personal` - Health, goals, life
- `tools` - Dev tools and workflows

**3. Flashcard Type (Only if content type = flashcards):**
- `javascript_flashcards`
- `react_flashcards`
- `css_flashcards`
- `typescript_flashcards`
- `web_flashcards`

**4. Special Purpose (Optional):**
- `interview` - Job interview prep
- `active` - Currently working on
- `meta` - System organization

### Tagging Best Practices

Reference **Tag Taxonomy.md** for complete guidelines:

- Maximum 4 tags per note
- Always include content type + subject
- Preserve flashcard tags (critical for spaced repetition)
- Use descriptive titles over micro-tags
- Search first, browse second
- Clean up unused tags monthly

**Tagging Examples:**
```yaml
# Flashcards
tags: [flashcards, react, react_flashcards, interview]

# Projects
tags: [project, career, active]

# Resources
tags: [reference, javascript]

# Daily notes
tags: [daily]
```

## Templates

Templates are located in two places:

### 1. Root-Level Templates/ Folder

Contains all note type templates:
- `1-on-1 Meeting Notes.md`
- `Book Reviews.md`
- `Bug Fix.md`
- `Communicate your work.md`
- `Daily Notes.md`
- `Feature Implementation.md`
- `General Notes.md`
- `Learning Tech Template.md`
- `Learning.md`
- `MOC Template.md`
- `Meeting Notes.md`
- `Monthly Goals.md`
- `People.md`
- `Problem Solving.md`
- `Project Brief.md`
- `Project Planning.md`
- `Quarterly Goals.md`
- `Weekly Planning.md`
- `Weekly Workout.md`

### 2. PARA Templates (0 - PARA/Templates/)

Additional organizational templates.

### Default Templates by Use Case

**Daily workflow:** `Daily Notes.md`
**OKR reviews:** `Quarterly Goals.md`, `Monthly Goals.md`, `Weekly Planning.md`
**Meetings:** `Meeting Notes.md`, `1-on-1 Meeting Notes.md`
**Learning:** `Learning.md`, `Learning Tech Template.md`
**Projects:** `Project Brief.md`, `Project Planning.md`

## PARA Decision Making

### Where Should This Note Go?

**Decision tree for placement:**

1. **Is this for an active project with a deadline?**
   → `0 - PARA/1 - Projects/[Project Name]/`

2. **Is this an ongoing responsibility?**
   → `0 - PARA/2 - Areas/[Area Name]/`

3. **Is this reference material for future use?**
   → `0 - PARA/3 - Resources/`

4. **Is this daily/temporal tracking?**
   → `1 - Notes/Daily Notes/` or `1 - Notes/OKRS/`

5. **Is this unprocessed or uncertain?**
   → `0 - PARA/0 - Inbox/` (process later)

6. **Is this completed or inactive?**
   → `0 - PARA/4 - Archives/`

**Key PARA Principles:**
- **Projects** - Time-bound, specific outcome, will move to Archives
- **Areas** - Ongoing, no end date, standard to maintain
- **Resources** - Passive reference, no immediate action required
- **Archives** - Completed projects, inactive areas, outdated resources

For complete PARA guidance, reference **PARA Method Implementation.md**.

## Inbox Processing Workflow

**Inbox location:** `0 - PARA/0 - Inbox/`

**Processing steps:**
1. Read note content
2. Apply decision tree above
3. Add appropriate tags (content type + subject)
4. Link to related notes or MOCs
5. Move to proper PARA category
6. Target: Empty inbox weekly

## Daily Notes Pattern

**Location:** `1 - Notes/Daily Notes/`
**Template:** `Daily Notes.md`
**Format:** `YYYY-MM-DD.md`

**Daily note workflow:**
1. Auto-create from template on startup
2. Link to active projects and areas
3. Capture tasks and quick notes
4. Evening reflection
5. Archive old daily notes quarterly to `1 - Notes/0_Archives/`

## OKR Structure

**Location:** `1 - Notes/OKRS/`

**Folder structure:**
```
1 - Notes/OKRS/
├── Quaterly Goals/              # Note: typo in folder name (preserve)
│   └── Quaterly Goals - Q1 2026.md
├── Monthly Goals/
│   ├── 1 - January 2026.md
│   └── 2 - February 2026.md
├── Yearly Goals/
└── 0_Archives/
```

**Weekly planning is separate:**
```
1 - Notes/Weekly Planning/
├── 1 - January 2026/
│   └── 2026-W01.md
└── 2 - February 2026/
    └── 2026-W06.md
```

**OKR hierarchy:**
- **Quarterly Goals** - `1 - Notes/OKRS/Quaterly Goals/Quaterly Goals - QN YYYY.md`
- **Monthly Goals** - `1 - Notes/OKRS/Monthly Goals/M - Month YYYY.md`
- **Weekly Planning** - `1 - Notes/Weekly Planning/M - Month YYYY/YYYY-Www.md`

**Templates:**
- Use `Quarterly Goals.md` for quarterly reviews
- Use `Monthly Goals.md` for monthly check-ins
- Use `Weekly Planning.md` for weekly reviews

**OKR workflow:**
- Link OKRs to relevant area notes in `2 - Areas/`
- Reference OKRs in daily notes when working on related tasks
- Track progress through note links and checkboxes

## Maps of Content (MOCs)

**Location:** `0 - PARA/MOCs/`

**Purpose:** Navigation hubs for related content

**When to create MOC:**
- Topic has 10+ related notes
- Need overview of knowledge area
- Connecting multiple projects/areas
- Want to explain concept structure

**MOC template:** `MOC Template.md`

**MOC best practices:**
- Use Dataview queries for dynamic content
- Link across PARA categories
- Update during monthly reviews
- Reference from **Tag MOC.md** for tag-based browsing

## Linking Conventions

### Internal Links

**Standard wiki links:**
```markdown
[[Note Name]]
[[Note Name|Display Text]]
[[Note Name#Heading]]
```

**Block references:**
```markdown
[[Note Name#^block-id]]
```

### Cross-Category Linking

Link freely across PARA boundaries:
- Projects can link to Areas (parent area)
- Projects can link to Resources (reference materials)
- Areas can link to Projects (active work in this area)
- Everything can link to MOCs (navigation)

### Backlinks

- Check backlinks regularly to discover connections
- Identify orphaned notes (no incoming links) during maintenance
- Use backlinks to understand note's role in knowledge graph

## Vault Maintenance

### Weekly Tasks
- [ ] Process inbox to zero (`0 - Inbox/`)
- [ ] Review all active projects (`1 - Projects/`)
- [ ] Check OKRs and update weekly planning

### Monthly Tasks
- [ ] Review all areas (`2 - Areas/`)
- [ ] Archive completed projects
- [ ] Update MOCs with new notes
- [ ] Clean up unused tags
- [ ] Check for broken links

### Quarterly Tasks
- [ ] Review OKRs and set new quarterly goals
- [ ] Archive old daily notes
- [ ] Consolidate resources
- [ ] Review vault structure

For complete maintenance procedures, reference **Vault Maintenance Guide.md**.

## Plugin Configuration

When working with this vault:

**Required configuration:**
```yaml
vault_path: /Users/kriscard/obsidian-vault-kriscard
```

**Key paths for commands:**
- Daily notes: `1 - Notes/Daily Notes/`
- Inbox: `0 - PARA/0 - Inbox/`
- Templates: `Templates/` (root) and `0 - PARA/Templates/`
- Quarterly OKRs: `1 - Notes/OKRS/Quaterly Goals/`
- Monthly Goals: `1 - Notes/OKRS/Monthly Goals/`
- Weekly Planning: `1 - Notes/Weekly Planning/M - Month YYYY/`

## Common Vault Operations

### Creating Notes

**Daily note:**
- Location: `1 - Notes/Daily Notes/`
- Template: `Daily Notes.md`
- Name: `YYYY-MM-DD.md`
- Tags: `#daily`

**Project note:**
- Location: `0 - PARA/1 - Projects/[Project Name]/`
- Template: `Project Brief.md` or `Project Planning.md`
- Tags: `#project` + subject tag

**Meeting note:**
- Location: Varies (often in project or area folder)
- Template: `Meeting Notes.md` or `1-on-1 Meeting Notes.md`
- Tags: `#meeting` + subject tag

**Learning note:**
- Location: `0 - PARA/3 - Resources/`
- Template: `Learning.md` or `Learning Tech Template.md`
- Tags: `#reference` + subject tag

### Moving Notes

When PARA category changes:
1. Identify current and target folders
2. Update internal links if needed
3. Update backlinks in other notes
4. Update MOCs that reference this note
5. Use Obsidian's file move (preserves links)

### Archiving

**When to archive:**
- Projects: When completed or abandoned
- Areas: When no longer your responsibility
- Resources: When outdated or no longer relevant
- Daily notes: After 90+ days

**Archive locations:**
- Projects: `0 - PARA/4 - Archives/Projects - YYYY/`
- Daily notes: `1 - Notes/0_Archives/`

## Reading Vault Files

Use the provided helper script to read vault configuration files:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/read-vault-file.sh "Tag Taxonomy.md"
bash ${CLAUDE_PLUGIN_ROOT}/scripts/read-vault-file.sh "PARA Method Implementation.md"
```

Or use Obsidian MCP directly:
```
mcp__mcp-obsidian__obsidian_get_file_contents("0 - PARA/Tag Taxonomy.md")
```

## Additional Resources

### Reference Files

For complete vault structure documentation:
- **`references/detailed-structure.md`** - Comprehensive folder breakdown, file inventories, and structural patterns

### Scripts

- **`scripts/read-vault-file.sh`** - Helper to read vault configuration files

### Vault Documentation

Always reference these files when available:
- **Tag Taxonomy.md** (`0 - PARA/Tag Taxonomy.md`)
- **Tag MOC.md** (`0 - PARA/Tag MOC.md`)
- **PARA Method Implementation.md** (`0 - PARA/PARA Method Implementation.md`)
- **Vault Organization Guide.md** (`0 - PARA/Vault Organization Guide.md`)
- **Vault Maintenance Guide.md** (`0 - PARA/Vault Maintenance Guide.md`)

Use this vault structure knowledge when guiding note placement, organization decisions, and vault maintenance tasks.
