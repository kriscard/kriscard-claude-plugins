---
description: Intelligently fetch and refine specs through in-depth interviews
argument-hint: '<jira-link|github-issue|prompt>'
---

# Refine Specification Through Interview

This command intelligently fetches requirements from multiple sources and conducts an in-depth interview to refine them into a comprehensive specification document.

## Step 1: Detect and Fetch Context

Analyze the input: **$ARGUMENTS**

### Context Detection Logic

1. **JIRA Detection**: If matches pattern `https://*.atlassian.net/browse/*` or `[A-Z]+-[0-9]+`
   - Extract the ticket key (e.g., `PROJ-123`)
   - Use browser MCP to navigate to the JIRA ticket URL
   - Take a snapshot and extract:
     - Title
     - Description
     - Acceptance criteria
     - Priority, severity, components
     - Relevant comments and discussion

2. **GitHub Issue Detection**: If matches pattern `https://github.com/*/issues/*` or `owner/repo#123`
   - Extract owner, repo, and issue number
   - Use `mcp__github__issue_read` tool with `method='get'`
   - Extract:
     - Title
     - Body content
     - Comments (use `method='get_comments'` if needed)
     - Labels

3. **Text Prompt**: If neither pattern matches
   - Treat $ARGUMENTS as raw requirement description
   - Use this as the initial spec context

**Output**: Display a summary of the fetched context to confirm understanding before proceeding.

---

## Step 2: Conduct In-Depth Interview

Using the `AskUserQuestionTool`, conduct a comprehensive interview across multiple rounds. The goal is to surface non-obvious details, challenge assumptions, and explore tradeoffs.

### Interview Guidelines

- **Avoid obvious questions**: Don't ask "Do you need authentication?" if the JIRA ticket mentions login flows
- **Be specific**: Instead of "What database?", ask "Given your read-heavy workload with 10k+ QPS, have you considered read replicas or a caching layer like Redis?"
- **Challenge assumptions**: "You mentioned real-time updates—have you evaluated the infrastructure cost vs polling every 30s?"
- **Surface hidden requirements**: "How should the system behave if the payment gateway times out after 10s?"
- **Adapt to context**: Don't ask about UI/UX if the spec is for a backend API or CLI tool
- **Continue until complete**: After each round, assess if critical areas remain unexplored

---

### Round 1: Technical Implementation (2-4 questions)

Ask about:
- **Architecture decisions**: Monolith vs microservices? Sync vs async processing? Event-driven patterns?
- **Technology stack**: Specific framework versions and rationale (e.g., "Why Next.js 14 vs Remix?")
- **Data modeling**: Schema design, relationships, indexing strategy
- **External dependencies**: Third-party APIs, services, SDKs, and their failure modes
- **Performance targets**: Specific metrics (e.g., "P95 latency < 200ms", "Support 1000 concurrent users")
- **Scalability requirements**: Expected growth, horizontal vs vertical scaling approach

**Example questions**:
- "Given that users will upload images, have you considered S3 direct uploads vs proxying through your backend? What's the tradeoff in terms of security vs complexity?"
- "You mentioned using PostgreSQL—have you evaluated whether JSONB columns or a separate NoSQL store would be better for your flexible metadata requirements?"

---

### Round 2: UI/UX Considerations (2-3 questions)

Ask about (if applicable to the project type):
- **User workflows**: Step-by-step interaction patterns, decision points
- **Responsive design**: Mobile-first? Tablet support? Desktop-specific features?
- **Accessibility**: WCAG compliance level (A, AA, AAA)? Screen reader support?
- **Error handling**: How to surface errors to users? Inline validation? Toast notifications?
- **Loading states**: Skeleton screens? Progress indicators? Optimistic updates?
- **Empty states**: What does the UI show when there's no data?

**Example questions**:
- "When a user submits the form, should validation happen on blur, on submit, or both? What's the tradeoff in terms of user experience vs server load?"
- "If the dashboard takes 3+ seconds to load, would you prefer a skeleton screen, a spinner, or progressive loading where charts appear as data arrives?"

---

### Round 3: Concerns and Constraints (2-3 questions)

Ask about:
- **Security requirements**: Authentication mechanism (OAuth2, JWT, session cookies)? Authorization model (RBAC, ABAC)? Data encryption at rest/transit?
- **Compliance needs**: GDPR (right to deletion, data export)? HIPAA? SOC2?
- **Browser/device support**: Which browsers and versions? IE11? Safari on iOS?
- **Backwards compatibility**: Will this break existing features? Migration path for existing users?
- **Infrastructure constraints**: Budget limits? Preferred cloud provider? Region requirements for data residency?

**Example questions**:
- "Given GDPR requirements, how will you handle user data deletion requests? Hard delete vs soft delete? What about backups?"
- "You mentioned supporting mobile devices—does that include mobile web only, or do you plan native iOS/Android apps in the future? Should the API be designed with that in mind?"

---

### Round 4: Tradeoffs and Alternatives (2-3 questions)

Ask about:
- **Alternative approaches**: Explore at least 2 other ways to solve the problem
- **Optimization target**: Speed to market? Code maintainability? Performance? Cost?
- **Acceptable limitations**: What features or edge cases are explicitly out of scope?
- **Technical debt**: Where are you taking shortcuts now that need to be revisited later?
- **Future extensibility**: How might requirements evolve? Should the design be more flexible or more focused?

**Example questions**:
- "You've chosen to build a custom dashboard. Have you evaluated off-the-shelf solutions like Retool or Metabase? What specific customization needs justify the build-over-buy decision?"
- "For real-time notifications, you could use WebSockets, Server-Sent Events, or polling. What are the tradeoffs in terms of server cost, browser compatibility, and code complexity?"

---

## Step 3: Write Comprehensive Spec

Based on the interview responses, generate a detailed specification document and write it to `@SPEC.md`.

### Template Structure

Use `plugins/ideation/skills/ideation/references/spec-template.md` as a base, but adapt it based on project type:

- **Frontend feature** → Emphasize UI/UX, component structure, state management
- **Backend API** → Emphasize data model, endpoints, error handling, security
- **Full-stack** → Comprehensive coverage of all layers

### Required Sections

1. **Overview**
   - Brief summary (1-2 paragraphs)
   - Context from JIRA/GitHub/prompt
   - Key goals and success criteria

2. **Technical Approach**
   - High-level architecture (components, data flow)
   - Technology stack choices with rationale
   - Key design patterns to follow

3. **File Changes**
   - New files to create
   - Existing files to modify
   - Purpose and scope of each change

4. **Implementation Details**
   - Detailed implementation steps for each component/feature
   - Code patterns to follow (reference similar files in the codebase)
   - Key interfaces, types, or schemas

5. **Data Model** (if applicable)
   - Schema definitions (SQL, TypeScript interfaces, etc.)
   - Relationships and constraints
   - Indexing strategy

6. **API Design** (if applicable)
   - Endpoint definitions (method, path, description)
   - Request/response examples
   - Error codes and handling

7. **UI/UX Specifications** (if applicable)
   - User flows with decision points
   - Component behaviors and interactions
   - Responsive design breakpoints
   - Accessibility requirements

8. **Testing Requirements**
   - Unit test coverage areas
   - Integration test scenarios
   - E2E test critical user journeys

9. **Error Handling**
   - Error scenarios and handling strategy
   - User-facing error messages
   - Logging and monitoring

10. **Validation Commands**
    - Commands to run (typecheck, lint, test, build)
    - Copy-paste ready

11. **Security Considerations** (if applicable)
    - Authentication/authorization approach
    - Data protection strategy
    - Compliance requirements

12. **Open Questions**
    - Checkbox list of any remaining unknowns

13. **Decisions Log**
    - Table of key decisions, rationale, and alternatives considered

---

### Writing Guidelines

- **Be specific**: Instead of "add error handling", write "catch StripeTimeoutError and display 'Payment processing delayed. Retry in 30s.'"
- **Include code snippets**: For complex logic, provide TypeScript/SQL/etc. examples
- **Reference existing patterns**: Point to similar implementations in the codebase
- **Be exhaustive on file changes**: Missing files = surprise work during implementation
- **Make it actionable**: The spec should have enough detail to implement without guessing

---

## Step 4: Confirm Completion

After writing the spec to `@SPEC.md`, display a summary:

```
Specification written to @SPEC.md

Key sections:
- [List the major sections included]

Open questions:
- [List any remaining unknowns, if any]

Next steps:
- Review @SPEC.md
- Address open questions if needed
- Use /ideation or Plan agents to create phased implementation plan
```
