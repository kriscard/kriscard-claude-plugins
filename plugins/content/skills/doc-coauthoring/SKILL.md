---
name: doc-coauthoring
description: >-
  Co-authors technical documents like RFCs, proposals, ADRs, and decision
  documents through a structured gather-refine-test workflow. Use when the user
  needs help writing or improving a formal document, structuring an RFC, or
  drafting a technical proposal. Not for blog posts or implementation specs.
---

# Document Co-authoring

Guide users through collaborative document creation. Close the context gap first, build iteratively, then verify the document works for readers who have no context.

## Three-Stage Workflow

```
1. Context Gathering  → Close the gap between what you know and what I know
2. Refinement         → Build each section through brainstorm → curate → draft → edit
3. Reader Testing     → Test with fresh perspective to catch blind spots
```

## Stage 1: Context Gathering

**Goal**: Understand enough to ask smart questions about edge cases.

**Initial questions**:
1. What type of document? (spec, proposal, decision doc, RFC)
2. Who's the primary audience?
3. What impact should it have when read?
4. Any template or format to follow?
5. Key constraints or context?

**Then encourage info dumping**:
- Background on problem/project
- Why alternatives aren't used
- Org context, timeline pressures
- Technical dependencies
- Stakeholder concerns

Ask 5-10 clarifying questions after initial dump.

**Exit when**: Questions show understanding of edge cases without needing basics explained.

## Stage 2: Refinement & Structure

**Goal**: Build section by section through brainstorm, curate, draft, refine.

**For each section**:

1. **Clarify**: Ask 5-10 questions about what to include
2. **Brainstorm**: Generate 5-20 numbered options
3. **Curate**: User picks what to keep/remove/combine
4. **Draft**: Write the section
5. **Refine**: Make surgical edits based on feedback

**Section order**: Start with the section that has most unknowns. Save summary for last.

**After 3 iterations with no changes**: Ask what can be removed without losing value.

## Stage 3: Reader Testing

**Goal**: Verify the doc works for someone with no context.

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

## Quick Reference

```markdown
# Document Brief
Type: [spec/proposal/decision doc/RFC]
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
