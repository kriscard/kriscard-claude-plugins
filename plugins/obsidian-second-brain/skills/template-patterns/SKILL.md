---
name: Template Usage & Application Patterns
description: >-
  Obsidian: Use when creating notes that need a template — project briefs,
  meeting notes, daily notes, learning notes, book reviews, or any structured
  note. Trigger this skill proactively when the user wants to create a new
  project note, start a meeting note, set up a weekly review, begin a learning
  note, or asks which template to use. Also trigger when the user mentions
  templates, note types, or structured note creation. NOT for general vault
  organization or PARA method (use obsidian-workflows).
version: 0.1.0
---

# Template Usage & Application Patterns

Quick reference for selecting and applying the right Obsidian template. Templates are in the `Templates/` folder at vault root.

## Template Selection

### Decision Tree

**Temporal tracking:**
- Daily journaling → `Daily Notes.md`
- Weekly review → `Weekly Planning.md`
- Monthly goals → `Monthly Goals.md`
- Quarterly planning → `Quarterly Goals.md`

**Meetings:**
- Regular meetings → `Meeting Notes.md`
- One-on-one → `1-on-1 Meeting Notes.md`

**Projects:**
- Starting new project → `Project Brief.md`
- Planning details → `Project Planning.md`
- Software feature → `Feature Implementation.md`
- Bug tracking → `Bug Fix.md`

**Learning:**
- General learning → `Learning.md`
- Technical tutorials → `Learning Tech Template.md`
- Book notes → `Book Reviews.md`

**Organization:**
- Creating index/hub → `MOC Template.md`
- Person notes → `People.md`
- Generic → `General Notes.md`

**Other:**
- Problem analysis → `Problem Solving.md`
- Work communication → `Communicate your work.md`
- Fitness → `Weekly Workout.md`

## Essential Sections

Every knowledge note should include these sections (enforced by templates):

### Related Section (required for concept notes)

```markdown
## Related
*Link 2-5 related notes with a reason why.*
- [[Note Name]] — brief reason for connection
- [[Another Note]] — why it relates
```

Purpose: Enforces the 2-Link Rule and builds the knowledge graph.

### Encounters Section (for evergreen/learning notes)

```markdown
# Encounters
*Real-world bugs, usage, and insights. Add entries when you encounter this concept in practice.*

## YYYY-MM-DD - [Brief title]
[What happened, what you learned]
Link: [[TIL or project note]]
```

Purpose: Makes notes living documents that grow with experience.

## How to Apply Templates

**Via command:** Run `/apply-template`, select from list, template applied to current note.

**Via daily-startup:** Daily notes auto-created using `Daily Notes.md` template.

**Manually:** Open template file, copy content, paste into new note.

## Integration with Plugin Commands

- `/daily-startup` → auto-applies `Daily Notes.md`
- `/apply-template` → interactive selection from all templates
- `/review-okrs` → uses `Quarterly Goals.md`, `Monthly Goals.md`, `Weekly Planning.md`
