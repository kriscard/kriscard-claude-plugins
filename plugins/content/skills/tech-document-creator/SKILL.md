---
name: tech-document-creator
description: >-
  Co-authors technical documents — RFCs, product design docs, architecture
  proposals, and decision records — built to be shared with developer teams
  for discussion. Asks first which document type to create, then drafts section
  by section. Make sure to use this skill whenever the user wants to draft an
  RFC, write a design doc, propose an architecture change, write up a pattern
  for the team to review, or share a technical proposal with developers — even
  if they just say "help me write this proposal", "draft a design doc", "I
  want to write something up to discuss with the team", or "propose this to
  engineering".
---

# Technical Document Creator

Co-author technical documents that developer teams will read and discuss. The workflow is the same regardless of document type, but each type has distinct section conventions — the skill picks the right template based on what the user is writing.

## Stage 0: Pick the Document Type

Before anything else, ask the user which document type to create using `AskUserQuestion`. The type drives which template the rest of the workflow uses.

**Question to ask:**
> What type of document are we creating?

**Options to offer:**
1. **RFC** — Request for Comments. Proposes a change, gathers feedback before commitment. Best when the decision isn't made yet.
2. **Product design doc** — Defines what to build and why. Goals, non-goals, user stories, success metrics. Best when scoping new product work.
3. **Architecture proposal** — Proposes a system design or pattern change. Current state, proposed design, trade-offs, migration. Best when changing how systems are built.
4. **Decision record (ADR)** — Captures a decision already made. Context, decision, consequences. Best for archiving "why we chose X".

If the user has something else in mind (e.g., postmortem, tech spec, migration plan), let them pick "Other" and gather what sections they want.

Once the type is chosen, read the matching template from `references/`:
- `references/rfc-template.md`
- `references/design-doc-template.md`
- `references/architecture-proposal-template.md`
- `references/adr-template.md`

The template gives the section structure. The workflow below drives how to fill it in.

## Stage 1: Context Gathering

**Goal**: Understand enough to ask smart questions about edge cases.

**Initial questions** (in addition to doc type from Stage 0):
1. Who's the primary audience? (specific team, eng leads, whole org)
2. What impact should it have when read? (decision made, feedback gathered, alignment)
3. Any template or format the team already uses? (override the reference template if so)
4. Key constraints or context? (timeline, politics, existing systems)

**Then encourage info dumping**:
- Background on problem/project
- Why alternatives aren't used
- Org context, timeline pressures
- Technical dependencies
- Stakeholder concerns

Ask 5-10 clarifying questions after the initial dump. The goal isn't completeness — it's enough context to recognize when something the user says doesn't fit, and ask why.

**Exit when**: Questions show understanding of edge cases without needing basics explained.

## Stage 2: Refinement & Structure

**Goal**: Build section by section through brainstorm, curate, draft, refine.

**For each section** (from the template):

1. **Clarify**: Ask 5-10 questions about what to include
2. **Brainstorm**: Generate 5-20 numbered options
3. **Curate**: User picks what to keep/remove/combine
4. **Draft**: Write the section
5. **Refine**: Make surgical edits based on feedback

**Section order**: Start with the section that has most unknowns. Save the summary/TL;DR for last — it summarizes what's been decided, so it can't be written until the rest is solid.

**After 3 iterations with no changes**: Ask what can be removed without losing value. Docs grow indefinitely without pruning pressure.

## Stage 3: Reader Testing

**Goal**: Verify the doc works for someone with no context — because team review readers usually have none.

**Process**:
1. Predict 5-10 questions readers would ask
2. Test with fresh perspective
3. Check: Does the doc answer correctly? Any ambiguity?
4. Fix gaps found, loop back if needed

**Exit when**: Fresh reader consistently answers questions correctly.

## Output Standards

- Section-by-section drafts with placeholder structure first
- Surgical edits (never reprint whole doc)
- Document works for readers with no prior context
- Final review checklist before completion
- For docs going into team chat: include a TL;DR at the top suitable for pasting into Slack with a link to the full doc

## Quick Reference

```markdown
# Document Brief
Type: [RFC / design doc / architecture proposal / ADR / other]
Audience: [primary readers]
Impact: [what should reader do/feel/understand]
Constraints: [timeline, format, politics]
```

```markdown
# Section Workflow
1. "What should [section] cover?" → 5-10 questions
2. "Here are 15 options for [section]" → numbered list
3. "Which to keep/remove/combine?" → user curates
4. Draft → user feedback → surgical edits
5. Repeat until satisfied
```

## Gotchas

- Don't skip Stage 0 — different doc types have different section conventions, and starting with the wrong template wastes a lot of iteration
- Don't skip Stage 1 (Context Gathering) — jumping straight to writing produces documents that miss critical context
- Info dumping without curating creates bloated docs — always brainstorm THEN let the user curate before drafting
- After 3 iterations with no changes, ask what can be REMOVED — docs grow indefinitely without pruning pressure
- Surgical edits means changing specific sentences, not reprinting the whole section — saves tokens and shows the user exactly what changed
- Reader Testing (Stage 3) is easy to skip but catches the biggest blind spots — the author always thinks the doc is clearer than it is
- For docs meant to spark team discussion: explicitly include an "Open Questions" section and call out decision points — silence in chat usually means readers didn't know what to react to
