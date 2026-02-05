---
name: Template Usage & Application Patterns
description: This skill should be used when discussing "templates", "apply template", "which template to use", "template selection", "note structure", or when helping users choose appropriate templates for different note types.
version: 0.1.0
---

# Template Usage & Application Patterns

## Overview

This skill provides guidance on when and how to use Obsidian templates effectively. Use this knowledge when helping users select appropriate templates, apply them to notes, or understand template structure and conventions.

## Template Library

Templates are located in: `Templates/` (vault root)

### Available Templates

**Daily & Planning:**
- `Daily Notes.md` - Daily journal and task tracking
- `Weekly Planning.md` - Weekly reviews and planning
- `Monthly Goals.md` - Monthly goal check-ins
- `Quarterly Goals.md` - Quarterly OKR reviews

**Meetings:**
- `Meeting Notes.md` - General meeting notes
- `1-on-1 Meeting Notes.md` - One-on-one meetings

**Projects & Work:**
- `Project Brief.md` - Project initialization
- `Project Planning.md` - Detailed project planning
- `Feature Implementation.md` - Software feature development
- `Bug Fix.md` - Bug tracking and resolution
- `Problem Solving.md` - Problem analysis framework

**Learning & Knowledge:**
- `Learning.md` - General learning notes
- `Learning Tech Template.md` - Technical learning materials
- `Book Reviews.md` - Book notes and reviews

**Organization:**
- `MOC Template.md` - Maps of Content creation
- `General Notes.md` - Catch-all template
- `People.md` - Relationship and contact notes

**Communication:**
- `Communicate your work.md` - Work communication framework

**Other:**
- `Weekly Workout.md` - Fitness tracking

## Template Selection Guide

### Decision Tree

**For temporal tracking:**
- Daily journaling → `Daily Notes.md`
- Weekly review → `Weekly Planning.md`
- Monthly goals → `Monthly Goals.md`
- Quarterly planning → `Quarterly Goals.md`

**For meetings:**
- Regular meetings → `Meeting Notes.md`
- One-on-one → `1-on-1 Meeting Notes.md`

**For projects:**
- Starting new project → `Project Brief.md`
- Planning project details → `Project Planning.md`
- Software feature → `Feature Implementation.md`
- Bug tracking → `Bug Fix.md`

**For learning:**
- General learning → `Learning.md`
- Technical tutorials → `Learning Tech Template.md`
- Book notes → `Book Reviews.md`

**For organization:**
- Creating index/hub → `MOC Template.md`
- Person notes → `People.md`
- Generic notes → `General Notes.md`

**For problem-solving:**
- Analyzing problems → `Problem Solving.md`

## Template Application Workflows

### Manual Application

**Steps:**
1. Open template file from Templates/
2. Copy template content
3. Create or open target note
4. Paste template content
5. Fill in template fields
6. Update metadata (tags, created date)

### Plugin-Assisted Application

Use `/apply-template` command:
1. Open or create target note
2. Run `/apply-template`
3. Select template from list
4. Template applied to note
5. Fill in fields

### Auto-Application

**Daily notes:**
- Automatically created using `Daily Notes.md`
- Triggered by `/daily-startup` or manual creation

**New project notes:**
- Suggested to use `Project Brief.md` or `Project Planning.md`
- Applied during project creation workflow

## Template Structure Patterns

### Frontmatter Section

**Standard metadata:**
```yaml
---
created: {{date}}
modified: {{date}}
tags: [appropriate, tags, here]
---
```

**Project-specific:**
```yaml
---
created: {{date}}
tags: [project, subject, active]
status: active
deadline: {{deadline}}
area: "[[Parent Area]]"
---
```

**Meeting-specific:**
```yaml
---
created: {{date}}
tags: [meeting, subject]
attendees: [person1, person2]
---
```

### Content Sections

**Common sections across templates:**
- **Title/Header** - Note name and context
- **Overview/Summary** - Brief description
- **Details** - Main content area
- **Actions/Next Steps** - Actionable items
- **Related** - Connected notes with reasons (see below)

**Essential sections for knowledge notes:**

**Related Section (required for concept notes):**
```markdown
## Related
*Use Outgoing links panel to discover connections. Link 2-5 related notes with a reason why.*
- [[Note Name]] — brief reason for connection
- [[Another Note]] — why it relates
```
Purpose: Enforces 2-Link Rule, builds knowledge graph

**Encounters Section (for evergreen/learning notes):**
```markdown
# Encounters
*Real-world bugs, usage, and insights. Add entries when you encounter this concept in practice.*

## YYYY-MM-DD - [Brief title]
[What happened, what you learned]
Link: [[TIL or project note]]
```
Purpose: Makes notes living documents that grow with experience

**Project template sections:**
- Overview
- Outcome/Goals
- Timeline
- Key Tasks
- Resources
- Notes
- Review

**Meeting template sections:**
- Date and Attendees
- Agenda
- Notes
- Decisions
- Action Items
- Follow-up

**Learning template sections:**
- Summary (Layer 1: Definition)
- Notes (detailed explanation)
- Schema/Code snippets (optional)
- Flashcards (optional)
- Related (Layer 2: Connections with reasons)
- Encounters (Layer 3: Real-world usage over time)

### Prompting Questions

Templates include prompting questions to guide thinking:

**Example from Project Brief:**
- "What problem does this solve?"
- "What does success look like?"
- "What are the key milestones?"

**Example from Learning:**
- "What are the main concepts?"
- "How does this relate to existing knowledge?"
- "Where can I apply this?"

**Purpose:** Reduce blank page syndrome, prompt complete thinking

## Template Customization

### When to Customize

**Add sections when:**
- Consistently need additional information
- Template missing key prompts
- Specific workflow needs support

**Remove sections when:**
- Consistently leaving sections empty
- Sections not relevant to use case
- Template too verbose for needs

**Modify prompts when:**
- Questions don't fit thinking style
- Need more/less detail
- Want different framing

### Customization Process

1. Copy template to personal templates folder (optional)
2. Modify sections, prompts, metadata
3. Test with real notes
4. Iterate based on usage
5. Update regularly (quarterly)

### Version Control

**Track template changes:**
- Keep changelog in template comments
- Note major version changes
- Document why changes made

**Example:**
```markdown
<!--
Template Version: 2.0
Last Updated: 2025-01-11
Changes: Added "Related Areas" section, removed "Status" field
-->
```

## Template Integration with PARA

### Projects (1 - Projects/)

**Primary templates:**
- `Project Brief.md` - Initial project creation
- `Project Planning.md` - Detailed planning
- `Feature Implementation.md` / `Bug Fix.md` - For software projects

**When creating project:**
1. Use template to structure thinking
2. Link to parent area
3. Link to relevant resources
4. Add to weekly planning

### Areas (2 - Areas/)

**Templates:**
- Less structured, more flexible
- Often custom per area
- Use `General Notes.md` as starting point

**Area note structure:**
- Purpose of area
- Standards to maintain
- Active projects in area
- Resources and references
- Regular reviews

### Resources (3 - Resources/)

**Primary templates:**
- `Learning.md` - General learning
- `Learning Tech Template.md` - Technical materials
- `Book Reviews.md` - Book notes

**Application:**
- Use template for initial capture
- Apply progressive summarization over time
- Extract evergreen notes as they emerge

## Template Best Practices

### Keep Templates Lean

**Principles:**
- Include only essential sections
- Prefer prompts over prescribed structure
- Allow flexibility in usage
- Remove unused sections

**Anti-patterns:**
- Overly detailed templates (too prescriptive)
- Too many optional sections (decision fatigue)
- Complex conditional logic (hard to use)

### Use Consistent Metadata

**Standard across all templates:**
- `created` - Creation date
- `modified` - Last modified
- `tags` - Consistent tagging

**Template-specific metadata:**
- Projects: `status`, `deadline`, `area`
- Meetings: `attendees`, `date`
- Learning: `source`, `author`

### Include Helpful Prompts

**Good prompts:**
- Open-ended questions
- Specific and actionable
- Relevant to template purpose
- Not too numerous (3-5 per section)

**Example good prompts:**
```markdown
## Outcome
What does success look like for this project?

## Key Tasks
What are the 3-5 most important tasks?

## Resources
What existing knowledge or materials will help?
```

### Link Template to Workflow

Templates should support existing workflows:
- Daily notes support morning routine
- Project templates align with project lifecycle
- Meeting templates match meeting structure
- Learning templates support progressive summarization

## Common Template Use Cases

### Daily Startup Workflow

**Template:** `Daily Notes.md`

**Workflow:**
1. Run `/daily-startup` command
2. Daily note created automatically
3. Template includes:
   - Links to yesterday/tomorrow
   - Active projects section
   - Today's focus
   - Quick capture area
   - Reflection section

**Customization:**
- Add/remove sections based on routine
- Include or exclude task lists
- Link or don't link to weekly planning

### Project Initiation

**Template:** `Project Brief.md`

**Workflow:**
1. Identify new project
2. Create note in `1 - Projects/[Project Name]/`
3. Apply `Project Brief.md` template
4. Fill in:
   - Project outcome
   - Timeline
   - Key tasks
   - Linked resources
5. Link to parent area
6. Add to weekly planning

### Weekly Reviews

**Template:** `Weekly Planning.md`

**Workflow:**
1. End of week (Sunday/Friday)
2. Create weekly planning note
3. Apply template
4. Review:
   - Past week accomplishments
   - Active projects status
   - Inbox processing
   - Next week priorities
5. Link to quarterly/monthly goals

### Meeting Notes

**Template:** `Meeting Notes.md` or `1-on-1 Meeting Notes.md`

**Workflow:**
1. Before meeting: Create note, apply template
2. During meeting: Fill in agenda, take notes
3. After meeting: Add action items, decisions
4. Link to relevant project/area
5. Link to people notes

### Learning Material Processing

**Template:** `Learning.md` or `Learning Tech Template.md`

**Workflow:**
1. Encounter learning material
2. Create note in Resources
3. Apply learning template
4. Layer 1: Capture key points
5. Over time: Apply progressive summarization
6. Extract evergreen notes
7. Link to relevant projects/areas

## Template Maintenance

### Regular Review

**Quarterly template audit:**
- Which templates used frequently?
- Which templates never used?
- What sections consistently skipped?
- What missing sections needed?

**Actions:**
- Update frequently-used templates
- Archive unused templates
- Create new templates for emerging needs
- Simplify overly complex templates

### Template Versioning

**When to version:**
- Major structural changes
- Significant section additions/removals
- Changing prompting approach

**Version notes:**
```markdown
<!--
Version: 2.1
Date: 2025-01-11
Changes:
- Added "Related Projects" section
- Removed redundant "Status" field
- Updated prompting questions
-->
```

### Deprecation Strategy

**When template no longer useful:**
1. Move to `Templates/Archive/`
2. Document why deprecated
3. Suggest replacement template
4. Keep for reference (don't delete)

## Integration with Plugin Commands

### /daily-startup Command

Uses `Daily Notes.md` template automatically:
- Creates note in `2 - Areas/Daily Ops/`
- Names as `YYYY-MM-DD.md`
- Applies template
- Opens for editing

### /apply-template Command

Interactive template selection:
1. Shows list of all templates
2. User selects template
3. Applies to current note
4. Preserves existing content (appends or prepends)

### /review-okrs Command

Uses goal templates:
- Quarterly: `Quarterly Goals.md`
- Monthly: `Monthly Goals.md`
- Weekly: `Weekly Planning.md`

Prompts for which review level, applies appropriate template.

## Conclusion

Templates reduce friction and ensure consistency. Use them as starting points, not rigid structures. Customize to fit workflows, review regularly, and keep lean. The best template is one that's actually used.

**Key principles:**
- Choose template based on note purpose
- Apply early in note creation
- Customize to fit needs
- Review and update quarterly
- Keep simple and flexible

Use this knowledge when guiding template selection and application in vault organization tasks.
