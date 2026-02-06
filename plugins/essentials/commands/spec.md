---
description: Create a lightweight spec from a ticket or prompt with minimal questions
argument-hint: '<jira|github|linear|prompt>'
---

# Quick Spec Generator

Create a focused specification document with minimal interruption. For complex features needing thorough exploration, use `/deep-spec` instead.

## Step 1: Detect and Fetch Context

Analyze the input: **$ARGUMENTS**

### Source Detection

1. **JIRA**: Pattern `https://*.atlassian.net/browse/*` or `[A-Z]+-[0-9]+`
   - Use browser MCP to fetch ticket details
   - Extract: title, description, acceptance criteria

2. **GitHub Issue**: Pattern `https://github.com/*/issues/*` or `owner/repo#123`
   - Use `gh issue view` or GitHub MCP
   - Extract: title, body, labels

3. **Linear**: Pattern `https://linear.app/*/issue/*` or `[A-Z]+-[0-9]+` with Linear context
   - Use Linear MCP: `mcp__linear__get_issue`
   - Extract: title, description, priority, labels

4. **Text Prompt**: If no pattern matches
   - Treat $ARGUMENTS as raw requirement

Display a brief summary of fetched context before proceeding.

---

## Step 2: Focused Clarification (1-2 questions max)

**Use `AskUserQuestion` tool** for all clarifying questions. Skip if the ticket is well-defined.

**Ask about**:
- **Unclear scope**: "The ticket mentions 'improve performance' - is there a specific target (e.g., < 200ms P95)?"
- **Missing tech decision**: "Should this use the existing REST API or the new GraphQL endpoint?"
- **Ambiguous behavior**: "On validation failure, should we show inline errors or a toast notification?"

**Do NOT ask**:
- Questions already answered in the ticket
- Obvious implementation details
- UI/UX preferences when following existing patterns

---

## Step 3: Write Spec

Generate `@SPEC.md` with these sections:

### Template

```markdown
# Spec: [Feature Name]

## Overview
[1-2 paragraph summary from ticket + clarifications]

## Technical Approach
- Architecture: [component/service affected]
- Key patterns: [reference existing codebase patterns]

## File Changes
| File | Action | Purpose |
|------|--------|---------|
| path/to/file.ts | Create/Modify | Description |

## Implementation Details
[Step-by-step implementation guide]

## Testing
- [ ] Unit tests for [specific functionality]
- [ ] Integration test for [specific flow]

## Validation Commands
\`\`\`bash
npm run typecheck
npm run lint
npm run test
\`\`\`

## Open Questions
- [ ] [Any remaining unknowns]
```

### Frontend Features

For frontend work, apply checklist from `references/frontend-spec-checklist.md`:
- Performance (no waterfalls, lazy loading)
- Accessibility (semantic HTML, keyboard nav, 44px targets)
- TypeScript (strict, no any)
- UI polish (no layout shift, tabular-nums)

---

## Step 4: Summary

```
Spec written to @SPEC.md

Ready to implement. Run:
- /plan to create implementation plan
- /commit when done
```
