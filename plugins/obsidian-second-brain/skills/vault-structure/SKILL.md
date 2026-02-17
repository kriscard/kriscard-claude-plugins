---
name: Vault Structure & Configuration
description: "Obsidian: Reference for user's vault folders, tags, and templates. Load when needing vault layout context for note operations."
version: 0.1.0
---

# Vault Structure & Configuration

## Overview

This skill provides detailed knowledge of the user's specific Obsidian vault structure, including folder organization, tagging taxonomy, templates, and organizational conventions. Use this knowledge when suggesting where to place notes, how to tag them, or when referencing vault-specific files and patterns.

**Vault Path:** `/Users/kriscard/obsidian-vault-kriscard`

## Core Folder Structure

The vault implements a modified PARA method with additional organizational folders:

### Primary Organization ()

```

├── 0 - Inbox/              # Unprocessed notes, process weekly
├── 1 - Projects/           # Active work with deadlines
├── 2 - Areas/              # Ongoing responsibilities
│   ├── Daily Ops/          # Daily notes, weekly planning
│   │   ├── [Daily notes]   # YYYY-MM-DD.md files
│   │   └── Weekly/         # Weekly planning by month
│   ├── Goals/              # OKR tracking
│   │   ├── Quarterly/      # Quarterly goals
│   │   └── Monthly/        # Monthly goals
│   └── Relationships/      # People notes
├── 3 - Resources/          # Reference materials
│   └── TIL/                # Today I Learned notes
├── 4 - Archives/           # Completed/inactive items
└── MOCs/                   # Maps of Content (navigation)
```

### Additional Folders

```
Templates/                  # Note templates
```

Note: Canvas files, Fitness content, and Side Projects have been consolidated into PARA folders.

### Key Organizational Documents

Located in `3 - Resources/Obsidian org/`:
- **Tag Taxonomy.md** - PARA-aligned tagging (subject tags, not content type)
- **Tag MOC.md** - Tag hierarchy browser with Dataview queries
- **PARA Method Implementation.md** - Vault-specific PARA guide
- **Vault Organization Guide.md** - Maintenance and organization patterns
- **Vault Maintenance Guide.md** - Regular maintenance checklists

## Tagging System

Tags complement PARA folders—they cut **across** folder structure for cross-category discovery.

> **Folders = "What type"** (project, area, resource)
> **Tags = "What about"** (React, career, interview)

Don't tag what the folder already tells you.

### Tag Categories

**1. Subject Tags (Pick 1-2):**
- `javascript` - JavaScript ecosystem
- `react` - React framework
- `css` - Styling and design
- `typescript` - TypeScript features
- `web` - General web dev (APIs, GraphQL, performance)
- `career` - Professional development
- `personal` - Health, goals, life
- `tools` - Dev tools and workflows

**2. Status Tags (Optional):**
- `interview` - Job interview prep
- `active` - Currently working on

**3. Flashcard Tags (For spaced repetition):**
- `flashcards` - Any spaced repetition content
- `javascript_flashcards`, `react_flashcards`, `css_flashcards`, `typescript_flashcards`, `web_flashcards`

**4. TIL Tags (For Today I Learned notes):**
- Use `til/` prefix: `til/react`, `til/architecture`, `til/testing`, `til/debugging`, `til/performance`

### Tags NOT to Use

These duplicate folder structure—let PARA handle them:
- ~~`project`~~ → `1 - Projects/` folder
- ~~`area`~~ → `2 - Areas/` folder
- ~~`reference`~~ → `3 - Resources/` folder
- ~~`daily`~~ → `2 - Areas/Daily Ops/` folder
- ~~`moc`~~ → `MOCs/` folder
- ~~`meeting`~~ → File location handles this
- ~~`meta`~~ → Vault organization files are obvious

### Tagging Best Practices

- Maximum 3-4 tags per note
- Subject tags only—don't duplicate folder info
- Preserve flashcard tags (critical for spaced repetition)
- Use `til/` prefix for TIL discoverability
- Search first, browse second

**Tagging Examples:**
```yaml
# Flashcards
tags: [flashcards, react, react_flashcards, interview]

# Project notes (in 1 - Projects/)
tags: [react, active]  # NOT [project, react, active]

# Resource files (in 3 - Resources/)
tags: [javascript]  # NOT [reference, javascript]

# TIL notes
tags: [til/react, til/hooks, til/architecture]

# Career meetings (in 2 - Areas/Careers/)
tags: [career]  # NOT [meeting, career]
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

### 2. PARA Templates (Templates/)

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
   → `1 - Projects/[Project Name]/`

2. **Is this an ongoing responsibility?**
   → `2 - Areas/[Area Name]/`

3. **Is this reference material for future use?**
   → `3 - Resources/`

4. **Is this daily/temporal tracking?**
   → `2 - Areas/Daily Ops/` or `2 - Areas/Goals/`

5. **Is this unprocessed or uncertain?**
   → `0 - Inbox/` (process later)

6. **Is this completed or inactive?**
   → `4 - Archives/`

**Key PARA Principles:**
- **Projects** - Time-bound, specific outcome, will move to Archives
- **Areas** - Ongoing, no end date, standard to maintain
- **Resources** - Passive reference, no immediate action required
- **Archives** - Completed projects, inactive areas, outdated resources

For complete PARA guidance, reference **PARA Method Implementation.md**.

## Inbox Processing Workflow

**Inbox location:** `0 - Inbox/`

**Processing steps:**
1. Read note content
2. Apply decision tree above
3. Add subject tag(s) only (folder handles content type)
4. Link to related notes or MOCs
5. Move to proper PARA category
6. Target: Empty inbox weekly

## Daily Notes Pattern

**Location:** `2 - Areas/Daily Ops/`
**Template:** `Daily Notes.md`
**Format:** `YYYY-MM-DD.md`

**Daily note workflow:**
1. Auto-create from template on startup
2. Link to active projects and areas
3. Capture tasks and quick notes
4. Evening reflection
5. Archive old daily notes quarterly to `4 - Archives/Daily Notes/`

## OKR Structure

**Location:** `2 - Areas/Goals/`

**Folder structure:**
```
2 - Areas/
├── Goals/
│   ├── Quarterly/
│   │   └── Quarterly Goals - Q1 2026.md
│   ├── Monthly/
│   │   ├── 1 - January 2026.md
│   │   └── 2 - February 2026.md
│   └── Yearly/
└── Daily Ops/
    └── Weekly/
        ├── 1 - January 2026/
        │   └── 2026-W01.md
        └── 2 - February 2026/
            └── 2026-W06.md
```

**OKR hierarchy:**
- **Quarterly Goals** - `2 - Areas/Goals/Quarterly/Quarterly Goals - QN YYYY.md`
- **Monthly Goals** - `2 - Areas/Goals/Monthly/M - Month YYYY.md`
- **Weekly Planning** - `2 - Areas/Daily Ops/Weekly/M - Month YYYY/YYYY-Www.md`

**Templates:**
- Use `Quarterly Goals.md` for quarterly reviews
- Use `Monthly Goals.md` for monthly check-ins
- Use `Weekly Planning.md` for weekly reviews

**OKR workflow:**
- Link OKRs to relevant area notes in `2 - Areas/`
- Reference OKRs in daily notes when working on related tasks
- Track progress through note links and checkboxes

## Maps of Content (MOCs)

**Location:** `MOCs/`

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
- Daily notes: `2 - Areas/Daily Ops/`
- Inbox: `0 - Inbox/`
- Templates: `Templates/` (root)
- TIL notes: `3 - Resources/TIL/`
- Quarterly OKRs: `2 - Areas/Goals/Quarterly/`
- Monthly Goals: `2 - Areas/Goals/Monthly/`
- Weekly Planning: `2 - Areas/Daily Ops/Weekly/M - Month YYYY/`

## Common Vault Operations

### Creating Notes

**Daily note:**
- Location: `2 - Areas/Daily Ops/`
- Template: `Daily Notes.md`
- Name: `YYYY-MM-DD.md`
- Tags: None needed (folder provides context)

**Project note:**
- Location: `1 - Projects/[Project Name]/`
- Template: `Project Brief.md` or `Project Planning.md`
- Tags: Subject tag + `#active` if currently working

**Meeting note:**
- Location: Varies (often in project or area folder)
- Template: `Meeting Notes.md` or `1-on-1 Meeting Notes.md`
- Tags: Subject tag only (e.g., `#career`)

**Learning note:**
- Location: `3 - Resources/`
- Template: `Learning.md` or `Learning Tech Template.md`
- Tags: Subject tag only (e.g., `#react`)

**TIL note:**
- Location: `3 - Resources/TIL/`
- Template: None (created by /til command)
- Tags: `til/` prefixed topic tags (e.g., `#til/react`, `#til/architecture`)

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
- Projects: `4 - Archives/Projects - YYYY/`
- Daily notes: `4 - Archives/Daily Notes/`

## Reading Vault Files

**Prefer Obsidian CLI when available:**

```bash
# Check CLI availability (try PATH, then macOS app location)
OBSIDIAN_CLI="${OBSIDIAN_CLI:-$(command -v obsidian 2>/dev/null || echo '/Applications/Obsidian.app/Contents/MacOS/Obsidian')}"
"$OBSIDIAN_CLI" vault &>/dev/null && echo "CLI_AVAILABLE" || echo "CLI_UNAVAILABLE"

# Read files with CLI
obsidian read path="3 - Resources/Obsidian org/Tag Taxonomy.md"
obsidian read path="3 - Resources/Obsidian org/PARA Method Implementation.md"

# List files
obsidian files folder="0 - Inbox/" format=json
```

**Or use helper script:**

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/read-vault-file.sh "Tag Taxonomy.md"
bash ${CLAUDE_PLUGIN_ROOT}/scripts/read-vault-file.sh "PARA Method Implementation.md"
```

**MCP fallback (ask user first):**
```
mcp__mcp-obsidian__obsidian_get_file_contents("Tag Taxonomy.md")
```

Note: Always prefer CLI over MCP. If CLI unavailable, ask user for confirmation before using MCP.

## Additional Resources

### Reference Files

For complete vault structure documentation:
- **`references/detailed-structure.md`** - Comprehensive folder breakdown, file inventories, and structural patterns

### Scripts

- **`scripts/read-vault-file.sh`** - Helper to read vault configuration files

### Vault Documentation

Always reference these files when available:
- **Tag Taxonomy.md** (`3 - Resources/Obsidian org/Tag Taxonomy.md`)
- **Tag MOC.md** (`3 - Resources/Obsidian org/Tag MOC.md`)
- **PARA Method Implementation.md** (`3 - Resources/Obsidian org/PARA Method Implementation.md`)
- **Vault Organization Guide.md** (`3 - Resources/Obsidian org/Vault Organization Guide.md`)
- **Vault Maintenance Guide.md** (`3 - Resources/Obsidian org/Vault Maintenance Guide.md`)

Use this vault structure knowledge when guiding note placement, organization decisions, and vault maintenance tasks.
