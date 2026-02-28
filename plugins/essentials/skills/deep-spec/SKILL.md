---
name: deep-spec
disable-model-invocation: true
description: >-
  Create thorough spec through 4 rounds of in-depth interviews. Make sure to
  use this skill whenever the user says "deep spec", "thorough spec",
  "comprehensive spec", "detailed specification", or wants an in-depth
  interview-driven specification process.
---

# Deep Specification Through Interview

Conduct comprehensive interviews (9-14 questions across 4 rounds) to create a detailed specification. For quick specs with minimal questions, use `/spec` instead.

## Step 1: Detect and Fetch Context

Analyze the input: **$ARGUMENTS**

### Source Detection

1. **JIRA**: Pattern `https://*.atlassian.net/browse/*` or `[A-Z]+-[0-9]+`
   - Use browser MCP to navigate and snapshot
   - Extract: title, description, acceptance criteria, priority, comments

2. **GitHub Issue**: Pattern `https://github.com/*/issues/*` or `owner/repo#123`
   - Use `gh issue view` or GitHub MCP
   - Extract: title, body, comments, labels

3. **Linear**: Pattern `https://linear.app/*/issue/*` or `[A-Z]+-[0-9]+` with Linear context
   - Use Linear MCP: `mcp__linear__get_issue`
   - Extract: title, description, priority, labels, comments

4. **Text Prompt**: If no pattern matches
   - Treat $ARGUMENTS as raw requirement

Display summary of fetched context before proceeding.

---

## Step 2: In-Depth Interview (4 Rounds)

Use `AskUserQuestion` tool. Goal: surface hidden requirements, challenge assumptions, explore tradeoffs.

### Interview Guidelines

- **Avoid obvious questions**: Don't ask what's already in the ticket
- **Be specific**: "Given 10k+ QPS, have you considered read replicas?" not "What database?"
- **Challenge assumptions**: "Real-time updates—have you evaluated cost vs polling every 30s?"
- **Surface hidden requirements**: "How should the system behave if payment gateway times out?"

---

### Round 1: Technical Implementation (2-4 questions)

- Architecture decisions (monolith vs microservices, sync vs async)
- Technology stack choices and rationale
- Data modeling, schema design, indexing
- External dependencies and failure modes
- Performance targets (P95 latency, concurrent users)

---

### Round 2: UI/UX Considerations (2-3 questions)

Skip if backend-only. Ask about:
- User workflows and decision points
- Responsive design requirements
- Error handling UX (inline, toast, modal)
- Loading states (skeleton, spinner, progressive)
- Empty states

---

### Round 3: Constraints and Compliance (2-3 questions)

- Security (OAuth2, JWT, RBAC/ABAC)
- Compliance (GDPR, HIPAA, SOC2)
- Browser/device support
- Backwards compatibility
- Infrastructure constraints

---

### Round 4: Tradeoffs and Alternatives (2-3 questions)

- Alternative approaches (explore 2+ options)
- Optimization target (speed to market, maintainability, performance, cost)
- Explicit out-of-scope items
- Technical debt being taken on
- Future extensibility needs

---

## Step 3: Write Comprehensive Spec

Generate `@SPEC.md` with all sections:

### Required Sections

1. **Overview**: Summary, context, success criteria
2. **Technical Approach**: Architecture, stack, patterns
3. **File Changes**: Table of new/modified files
4. **Implementation Details**: Step-by-step guide
5. **Data Model** (if applicable): Schema, relationships, indexes
6. **API Design** (if applicable): Endpoints, request/response, errors
7. **UI/UX Specifications** (if applicable): Flows, components, accessibility
8. **Testing Requirements**: Unit, integration, E2E
9. **Error Handling**: Scenarios, messages, logging
10. **Validation Commands**: Copy-paste ready
11. **Security Considerations** (if applicable)
12. **Open Questions**: Checkbox list
13. **Decisions Log**: Table of key decisions with rationale

### Frontend Features

Apply checklist from `references/frontend-spec-checklist.md`:
- Performance (waterfalls, bundle size, rendering)
- TypeScript (strict, no any, discriminated unions)
- Accessibility (semantic HTML, ARIA, keyboard nav)
- UI polish (layout shift, z-index, dark mode)

### Writing Guidelines

- Be specific: "catch StripeTimeoutError and display 'Retry in 30s'" not "add error handling"
- Include code snippets for complex logic
- Reference existing codebase patterns
- Make it actionable—enough detail to implement without guessing

---

## Step 4: Summary

```
Specification written to @SPEC.md

Key sections:
- [List major sections included]

Open questions:
- [List remaining unknowns]

Next steps:
- Review @SPEC.md
- Address open questions
- Use /plan for implementation planning
```
