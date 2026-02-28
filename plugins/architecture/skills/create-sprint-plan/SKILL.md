---
name: create-sprint-plan
disable-model-invocation: true
description: >-
  Decompose a project spec into sprints and atomic tasks. Make sure to use this
  skill whenever the user says "sprint plan", "create sprints", "break down
  into tasks", "decompose spec", or wants to turn a specification into an
  actionable sprint plan.
---

# Create Sprint Plan

Break down a project specification into implementable sprints and atomic tasks.

**Input**: $ARGUMENTS

---

## Step 1: Analyze the Specification

Read the provided spec file or parse the project description.

Extract:
- Core functionality and goals
- Technical constraints and dependencies
- Definition of "done" for the project

Summarize understanding before proceeding.

---

## Step 2: Identify Vertical Slices

Break the project into **vertical slices**—end-to-end features delivering user value.

Principles:
- Each slice is demonstrable to stakeholders
- Includes all necessary layers (UI, API, data)
- Has clear acceptance criteria
- Minimizes dependencies between slices

Output: List 3-8 vertical slices with descriptions.

---

## Step 3: Organize into Sprints

Group slices into sprints where each sprint:

1. **Builds on previous work** - later sprints extend earlier functionality
2. **Produces demoable software** - can be run, tested, and shown
3. **Has a clear goal** - one sentence describing achievement

Format:
```
Sprint N: [Goal Statement]
Delivers: [What users can see/do]
Builds on: [Previous sprint(s)]
```

Output: Ordered list of 2-6 sprints.

---

## Step 4: Decompose into Atomic Tasks

For each sprint, create atomic tasks meeting these requirements:

| Requirement | Criteria |
|-------------|----------|
| **Atomic** | Single concern, small scope |
| **Committable** | Results in valid commit (tests pass, builds work) |
| **Testable** | Has tests OR alternative validation |
| **Specific** | No ambiguity about "done" |

### Task Format

```markdown
### Task N.M: [Title]

**What**: [Specific implementation]

**Files**:
- Create: `path/to/new/file.ts`
- Modify: `path/to/existing/file.ts`

**Validation**:
- [ ] Tests pass: `pnpm test path/to/test`
- [ ] Type check: `pnpm typecheck`
- [ ] Manual: [specific steps]

**Commit**: `feat(scope): description`
```

### Alternative Validation

If tests don't make sense, use:
- Manual verification steps
- Build/compile success
- Linter passes
- Screenshot/demo proof

---

## Step 5: Review with Subagent

Use the Task tool to spawn a Plan agent for review:

```
Review this sprint plan:

[Full sprint/task breakdown]

Evaluate:
1. Are tasks truly atomic (single commit)?
2. Does each sprint produce demoable software?
3. Are task dependencies clear?
4. Are validation criteria specific?
5. Missing tasks or functionality gaps?
6. Optimal ordering for incremental delivery?

Provide:
- Issues (critical/major/minor)
- Suggested improvements
- Missing considerations
- Risk areas
```

---

## Step 6: Incorporate Feedback

Based on review:
1. Fix critical issues
2. Document accepted limitations
3. Note risk areas for attention

---

## Step 7: Write Output

Write to `docs/sprint-plan.md`:

```markdown
# Sprint Plan: [Project Name]

> Source: [spec file or description]

## Overview

[2-3 sentence summary]

## Sprints

### Sprint 1: [Goal]

**Delivers**: [Outcome]
**Validates**: [Proof of completion]

#### Tasks

- [ ] **1.1**: [Title] — `feat(scope): msg`
- [ ] **1.2**: [Title] — `fix(scope): msg`

### Sprint 2: [Goal]
...

## Task Details

### 1.1: [Title]

**What**: [Details]

**Files**:
- Create: `path/to/file`
- Modify: `path/to/file`

**Validation**:
- [ ] [Step]
- [ ] [Step]

**Commit**: `feat(scope): description`

---

## Review Notes

### Addressed
- [Fixed issues]

### Accepted Limitations
- [Minor issues accepted]

### Risk Areas
- [Areas needing attention]
```

---

## Step 8: Summary

```
Sprint plan written to: docs/sprint-plan.md

Sprints: N
Tasks: M total

- Sprint 1: [goal] (X tasks)
- Sprint 2: [goal] (Y tasks)
...

Next: Review plan, then start Sprint 1 Task 1.1
```
