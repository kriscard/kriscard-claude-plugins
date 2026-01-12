# Detailed Vault Structure

Comprehensive breakdown of the vault's folder hierarchy, files, and organizational patterns.

## Complete Folder Tree

```
obsidian-vault-kriscard/
├── 0 - PARA/
│   ├── 0 - Inbox/              # Unprocessed capture zone
│   ├── 1 - Projects/            # Active projects with deadlines
│   ├── 2 - Areas/               # Ongoing responsibilities
│   ├── 3 - Resources/           # Reference materials
│   ├── 4 - Archives/            # Completed/inactive items
│   ├── MOCs/                    # Maps of Content
│   ├── Templates/               # Organizational templates
│   ├── PARA Method Implementation.md
│   ├── Tag MOC.md
│   ├── Tag Taxonomy.md
│   ├── Tag Migration Script.md
│   ├── Vault Maintenance Guide.md
│   └── Vault Organization Guide.md
├── 1 - Notes/
│   ├── 0_Archives/              # Archived daily notes
│   ├── Daily Notes/             # Daily journal entries
│   ├── OKRS/                    # Goal tracking
│   ├── People/                  # Relationship notes
│   ├── Weekly Planning/         # Weekly reviews
│   └── React Composition Over Inheritance Tutorial.md
├── Canvas/                      # Visual mind maps
├── Fitness/                     # Training and health
├── Side Project/                # Personal projects
├── Templates/                   # Note templates (main location)
│   ├── Archive/
│   ├── 1-on-1 Meeting Notes.md
│   ├── Book Reviews.md
│   ├── Bug Fix.md
│   ├── Communicate your work.md
│   ├── Daily Notes.md
│   ├── Feature Implementation.md
│   ├── General Notes.md
│   ├── Learning Tech Template.md
│   ├── Learning.md
│   ├── MOC Template.md
│   ├── Meeting Notes.md
│   ├── Monthly Goals.md
│   ├── People.md
│   ├── Problem Solving.md
│   ├── Project Brief.md
│   ├── Project Planning.md
│   ├── Quarterly Goals.md
│   ├── Weekly Planning.md
│   └── Weekly Workout.md
├── temporary/                   # Scratch space
├── Hyrox Hybrid workout 2025-2026 Plan.md
├── README.md
└── tag-analysis.py
```

## Folder Purposes

### 0 - PARA/ (Primary Organization)

Main organizational structure following PARA methodology.

#### 0 - Inbox/
- **Purpose**: Capture zone for unprocessed notes
- **Workflow**: Process weekly, move to appropriate PARA category
- **Target**: Empty every week
- **Tags**: `#inbox` or `#to-process`

#### 1 - Projects/
- **Purpose**: Active work with specific outcomes and deadlines
- **Criteria**:
  - Has clear deadline or target date
  - Has specific, measurable outcome
  - Requires multiple steps
  - Will move to Archives when complete
- **Tags**: `#project` + subject tag + optional `#active`
- **Examples**: "Launch website", "Complete course", "Job search"

#### 2 - Areas/
- **Purpose**: Ongoing responsibilities without end dates
- **Criteria**:
  - Ongoing responsibility
  - Standard to maintain
  - Part of role or identity
  - Continues indefinitely
- **Tags**: `#area` + subject tag
- **Examples**: "Career development", "Health & fitness", "Personal development"

#### 3 - Resources/
- **Purpose**: Reference materials and passive information
- **Criteria**:
  - Topics of interest but not actively working on
  - Reference materials for future use
  - Learning materials and study notes
  - Best practices and methodologies
- **Tags**: `#reference` + subject tag
- **Examples**: "Coding patterns", "Technical articles", "Book notes"

#### 4 - Archives/
- **Purpose**: Completed or inactive items
- **Organization**: By year or category
  - `Projects - 2024/`
  - `Projects - 2023/`
  - `Areas - Inactive/`
  - `Resources - Deprecated/`
- **When to archive**:
  - Projects: Completed or abandoned
  - Areas: No longer responsibility
  - Resources: Outdated or irrelevant

#### MOCs/
- **Purpose**: Maps of Content for navigation
- **Use cases**:
  - Topic has 10+ related notes
  - Need overview of knowledge area
  - Connecting multiple projects/areas
- **Naming**: `[Topic] MOC.md`
- **Special MOCs**:
  - **Tag MOC.md**: Tag hierarchy browser with Dataview queries
  - **Master MOC**: Main navigation hub (if exists)

#### Templates/
- Organizational templates specific to PARA
- Supplement main Templates/ folder

#### Organizational Documents
Located directly in `0 - PARA/`:
- **PARA Method Implementation.md**: Vault-specific PARA guide
- **Tag Taxonomy.md**: Complete tagging system (3-4 tag max)
- **Tag MOC.md**: Tag hierarchy and Dataview queries
- **Tag Migration Script.md**: Tag consolidation guide
- **Vault Organization Guide.md**: Organization patterns
- **Vault Maintenance Guide.md**: Maintenance checklists

### 1 - Notes/ (Temporal & Relational)

Temporal tracking and relationship notes.

#### Daily Notes/
- **Purpose**: Daily journal and planning
- **Format**: `YYYY-MM-DD.md`
- **Template**: `Daily Notes.md`
- **Content**:
  - Links to active projects and areas
  - Task list or priorities
  - Quick capture section
  - Reflection or review
- **Tags**: `#daily`
- **Archiving**: Move to `0_Archives/` after 90+ days

#### OKRS/
- **Purpose**: Goal tracking and reviews
- **Structure**:
  - Quarterly goals (major objectives)
  - Monthly goals (progress checks)
  - Weekly planning (task-level)
- **Templates**:
  - `Quarterly Goals.md`
  - `Monthly Goals.md`
  - `Weekly Planning.md`
- **Review cadence**:
  - Quarterly: Major planning
  - Monthly: Progress checks
  - Weekly: Task reviews

#### Weekly Planning/
- **Purpose**: Weekly review notes
- **Template**: `Weekly Planning.md`
- **Content**:
  - Week review and planning
  - Inbox processing notes
  - Project updates
  - Area check-ins

#### People/
- **Purpose**: Relationship and networking notes
- **Template**: `People.md`
- **Use cases**:
  - Professional contacts
  - 1-on-1 meeting notes
  - Relationship context
- **Tags**: Often combined with `#meeting` or `#career`

#### 0_Archives/
- **Purpose**: Old daily notes and temporal notes
- **Organization**: By year or quarter
- **Cleanup**: Review annually

### Templates/ (Main Template Library)

Central location for all note templates.

#### Template Categories

**Meeting Templates:**
- `1-on-1 Meeting Notes.md`
- `Meeting Notes.md`

**Project Templates:**
- `Project Brief.md`
- `Project Planning.md`
- `Feature Implementation.md`
- `Bug Fix.md`

**Learning Templates:**
- `Learning.md`
- `Learning Tech Template.md`
- `Book Reviews.md`

**Goal Templates:**
- `Daily Notes.md`
- `Weekly Planning.md`
- `Monthly Goals.md`
- `Quarterly Goals.md`

**Other Templates:**
- `MOC Template.md`
- `People.md`
- `General Notes.md`
- `Problem Solving.md`
- `Communicate your work.md`
- `Weekly Workout.md`

#### Archive/
Old or deprecated templates.

### Other Folders

#### Canvas/
- Visual mind maps and diagrams
- Obsidian Canvas files

#### Fitness/
- Training plans
- Workout logs
- Health tracking

#### Side Project/
- Personal projects outside main PARA structure
- Experimental or informal work

#### temporary/
- Scratch space
- Temporary files
- Testing area

## File Naming Conventions

### Daily Notes
```
YYYY-MM-DD.md
```
Examples: `2025-01-11.md`, `2025-01-12.md`

### Project Notes
```
[Project Name].md
[Project Name] - [Aspect].md
```
Examples: `Launch Website.md`, `Launch Website - Design.md`

### Area Notes
```
[Area Name].md
```
Examples: `Career Development.md`, `Health & Fitness.md`

### Resource Notes
```
[Topic].md
[Topic] - [Subtopic].md
```
Examples: `React Patterns.md`, `React Patterns - Hooks.md`

### MOCs
```
[Topic] MOC.md
```
Examples: `Web Development MOC.md`, `Tag MOC.md`

### Templates
```
[Template Purpose].md
```
Examples: `Daily Notes.md`, `Meeting Notes.md`

## Metadata Patterns

### Frontmatter

**Standard fields:**
```yaml
---
created: YYYY-MM-DD
modified: YYYY-MM-DD
tags: [tag1, tag2, tag3]
status: active|completed|on-hold
---
```

**Project-specific:**
```yaml
---
created: 2025-01-11
modified: 2025-01-11
tags: [project, career, active]
status: active
deadline: 2025-03-01
area: "[[Career Development]]"
---
```

**Resource-specific:**
```yaml
---
created: 2025-01-11
tags: [reference, react]
source: https://example.com
author: Author Name
---
```

**Daily note:**
```yaml
---
date: 2025-01-11
tags: [daily]
---
```

## Linking Patterns

### Internal Links

**Standard wiki links:**
```markdown
[[Note Name]]
[[Note Name|Display Text]]
```

**Heading links:**
```markdown
[[Note Name#Heading]]
```

**Block references:**
```markdown
This is important. ^key-point

Referenced as: [[Note Name#^key-point]]
```

### Cross-PARA Linking

**Project → Area (parent):**
```markdown
# Project: Launch Website

**Parent Area:** [[Career Development]]
```

**Project → Resource (reference):**
```markdown
# Project: Launch Website

## Resources
- [[React Patterns]]
- [[Web Design Principles]]
```

**Area → Projects (active work):**
```markdown
# Area: Career Development

## Active Projects
- [[Launch Website]]
- [[Complete Online Course]]
```

### Backlinks

- Every note implicitly tracks incoming links
- Use backlinks to discover unexpected connections
- Identify orphaned notes (no backlinks) during maintenance

## Tag Hierarchy

### Simplified System (Current)

**Maximum 3-4 tags per note**

**Layer 1: Content Type (Required)**
- `flashcards`, `reference`, `project`, `area`, `meeting`, `daily`, `moc`

**Layer 2: Subject (Required)**
- `javascript`, `react`, `css`, `typescript`, `web`, `career`, `personal`, `tools`

**Layer 3: Flashcard Type (Conditional)**
- `javascript_flashcards`, `react_flashcards`, etc.

**Layer 4: Special Purpose (Optional)**
- `interview`, `active`, `meta`

### Legacy Hierarchical Tags

Being phased out but still present:
- `tech/frontend/javascript` → `javascript`
- `tech/frontend/react` → `react`
- `career/networking` → `career`

Preserved in existing notes for backward compatibility, especially flashcards.

## Dataview Query Patterns

### Active Projects
```dataview
TABLE status, deadline
FROM "0 - PARA/1 - Projects"
WHERE !contains(file.folder, "Archive")
SORT deadline ASC
```

### Unprocessed Inbox
```dataview
LIST
FROM "0 - PARA/0 - Inbox"
```

### Recent Daily Notes
```dataview
LIST
FROM "1 - Notes/Daily Notes"
SORT file.name DESC
LIMIT 7
```

### Orphaned Notes
```dataview
TABLE file.inlinks as "Backlinks"
WHERE length(file.inlinks) = 0
AND !contains(file.folder, "Archive")
```

### Notes by Tag
```dataview
LIST
FROM #react
SORT file.name ASC
```

## Maintenance Patterns

### Weekly Checklist
- [ ] Process inbox to zero
- [ ] Review active projects
- [ ] Update weekly planning
- [ ] Check OKRs

### Monthly Checklist
- [ ] Review all areas
- [ ] Archive completed projects
- [ ] Update MOCs
- [ ] Clean up tags
- [ ] Check broken links

### Quarterly Checklist
- [ ] Review quarterly OKRs
- [ ] Archive old daily notes
- [ ] Consolidate resources
- [ ] Vault structure review

## Special Patterns

### Flashcard System

**Critical for spaced repetition:**
- Always include both `flashcards` and `[topic]_flashcards` tags
- Never modify or remove flashcard tags
- Flashcard files often use legacy hierarchical tags (preserved)

### Meeting Notes

**Standard structure:**
- Use `Meeting Notes.md` or `1-on-1 Meeting Notes.md` template
- Tag with `#meeting` + subject tag
- Link to relevant project or area
- Link to people notes when relevant

### Learning Materials

**Progressive summarization:**
- Capture full source in resources
- Apply highlighting layers over time
- Extract evergreen notes to separate files
- Link to projects when applied

## Common Operations

### Moving Notes Between Categories

**When to move:**
- Project complete → Archive
- Resource becomes active → Project
- Project becomes ongoing → Area

**How to move:**
1. Use Obsidian file move (preserves links)
2. Update metadata (tags, status)
3. Update parent/child links
4. Update relevant MOCs

### Creating New Projects

1. Create note in `1 - Projects/[Project Name]/`
2. Use `Project Brief.md` template
3. Tag: `#project` + subject + `#active`
4. Link to parent area
5. Link to relevant resources
6. Add to weekly planning

### Processing Inbox

1. Read note content
2. Decide: Delete, Archive, or Elaborate
3. If elaborating:
   - Add context and links
   - Apply appropriate tags
   - Move to PARA category
4. Target: Weekly inbox zero

## Vault Statistics

Use these patterns to understand vault health:

**Total notes by category:**
```bash
find "0 - PARA/1 - Projects" -name "*.md" | wc -l
find "0 - PARA/2 - Areas" -name "*.md" | wc -l
find "0 - PARA/3 - Resources" -name "*.md" | wc -l
```

**Unprocessed inbox count:**
```bash
find "0 - PARA/0 - Inbox" -name "*.md" | wc -l
```

**Recent activity:**
```bash
find vault/ -name "*.md" -mtime -7  # Modified in last 7 days
```

**Orphaned notes:**
Use Dataview query or graph view to identify notes with no incoming links.

This detailed structure serves as a complete reference for understanding the vault's organization, patterns, and conventions.
