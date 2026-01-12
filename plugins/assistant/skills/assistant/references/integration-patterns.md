# Plugin Integration Patterns

This document details how the assistant plugin integrates with existing plugins in the user's marketplace.

## Integration Philosophy

The assistant plugin acts as an **orchestrator**, not a duplicate. It coordinates existing specialist plugins rather than reimplementing their functionality.

**Key principle:** When suggesting an action that another plugin handles, reference that plugin explicitly and let it do the work.

## Integration Map

```
assistant (orchestrator)
├── essentials (git workflow, commits, PRs, deep thinking)
├── developer-tools (code quality, TypeScript, React, debugging)
├── ideation (brain dump → specs, RFC/ADR generation)
└── obsidian-second-brain (goal tracking, notes)
```

## Essentials Plugin Integration

**Location:** `plugins/essentials/`

**Components used:**
- **git-committer agent** - Analyze commits for status generation
- **/commit command** - When suggesting user commit work
- **/ultrathink command** - When complex architectural decision needed
- **/pr command** - When creating pull requests
- **/de-slopify command** - When code quality cleanup needed

### Pattern: Commit Analysis

**When:** Generating daily standup or weekly summary

**How:**
```
Use essentials/git-committer agent to analyze commit messages.
Extract meaningful accomplishments, not just raw commit text.

Example:
git log --since="24 hours ago" --author="user@email.com" --oneline

Pass to git-committer agent:
"Analyze these commits and extract key accomplishments in casual language"

Output:
- Shipped the purchase modal skeleton (GROW-2380)
- Finally got that React Query migration working
- Fixed the pagination bug that was blocking the team
```

### Pattern: Suggesting Commits

**When:** At session end, user has uncommitted changes

**How:**
```
Assistant: "You have uncommitted changes. Save your work?"

If user agrees:
  "Use /commit to create semantic commit message"

Do NOT create commit directly - let essentials/git-committer handle it.
```

### Pattern: Suggesting Deep Thinking

**When:** User is working on complex architectural decision

**How:**
```
Detect pattern:
- Multiple approaches being considered
- Trade-offs mentioned
- Uncertainty expressed

Suggest:
"This seems like a complex decision. Consider using /ultrathink to think it through systematically."

Do NOT invoke ultrathink directly - suggest it to user.
```

### Pattern: PR Creation

**When:** User mentions "ready to create PR" or similar

**How:**
```
Suggest: "Use /pr to create pull request with structured summary"

Before PR creation, suggest:
"Run /quality-check first to validate code quality?"

Let essentials/pr command handle PR creation.
```

## Developer-Tools Plugin Integration

**Location:** `plugins/developer-tools/`

**Components used:**
- **typescript-coder agent** - TypeScript pattern validation
- **frontend-developer agent** - React pattern validation
- **code-assistant skill** - Auto-selects appropriate specialist
- **debugger agent** - Debugging support
- **frontend-security-coder agent** - Security validation

### Pattern: Quality Validation

**When:** `/quality-check` command invoked or significant code changes detected

**How:**
```
1. Identify changed files:
   git diff --name-only main...HEAD

2. Filter for TypeScript/React files:
   *.ts, *.tsx files

3. For TypeScript files:
   Invoke developer-tools/typescript-coder agent:
   "Review these TypeScript files for pattern adherence and best practices:
   [file list]"

4. For React files:
   Invoke developer-tools/frontend-developer agent:
   "Review these React components for pattern adherence and best practices:
   [file list]"

5. Aggregate feedback:
   ✅ Issues fixed
   ⚠️ Suggestions (advisory, not blocking)
   💡 Opportunities for improvement
```

### Pattern: Smart Agent Selection

**When:** User asks coding question without specifying agent

**How:**
```
Use developer-tools/code-assistant skill to auto-select specialist:

User: "Help me debug this React component"
→ code-assistant selects: debugger agent

User: "Write TypeScript for this API"
→ code-assistant selects: typescript-coder agent

User: "Build a secure form"
→ code-assistant coordinates: frontend-developer + frontend-security-coder

Let code-assistant handle routing - don't duplicate its logic.
```

### Pattern: Advisory Feedback Only

**When:** Providing quality feedback

**How:**
```
NEVER block user actions based on quality checks.
Always use advisory language:

✅ Good: "Consider adding tests for this utility"
❌ Bad: "You must add tests before committing"

✅ Good: "This pattern could be simplified using X"
❌ Bad: "This code violates our standards"

Quality checks inform, they don't enforce.
User always has final say on shipping code.
```

## Ideation Plugin Integration

**Location:** `plugins/ideation/`

**Components used:**
- **ideation skill** - Brain dump → contract → PRD → spec workflow
- **/validate-output command** - Validate generated artifacts

### Pattern: Suggesting RFC/ADR Creation

**When:** Architectural changes detected in commits

**How:**
```
Detect patterns:
- Commit messages with "architecture", "design", "pattern"
- Multiple files changed in architectural layers
- New abstractions created
- Significant refactoring

Suggest:
"This architectural change might warrant documentation.
Consider using the ideation workflow to create an RFC:

1. Describe your design decision in your own words
2. Let ideation generate structured RFC
3. Review and refine

This will help with Staff visibility - technical writing is a key signal."

Do NOT generate RFC directly - guide user to ideation workflow.
```

### Pattern: Design Doc Suggestion

**When:** User creates new feature or significant change

**How:**
```
After PR creation for significant feature:

"Nice work on [feature]! This looks like a good candidate for a design doc.

Would you like to:
A) Use ideation workflow to document the design
B) Skip for now (you can document later)

Benefits:
- Helps team understand design decisions
- Counts toward Staff technical writing signal
- Future engineers will thank you"

If user chooses A, guide to ideation workflow.
If user chooses B, note for later (don't nag).
```

### Pattern: Contract → PRD → Spec Flow

**When:** User mentions building something new and complex

**How:**
```
"This sounds like a multi-phase project. Want to use ideation workflow?

It will:
1. Ask clarifying questions (confidence scoring)
2. Generate contract (problem, goals, scope)
3. Create phased PRDs (requirements per phase)
4. Write specs (implementation details)

Output: ./docs/ideation/{project-name}/
- contract.md
- prd-phase-1.md, prd-phase-2.md
- spec-phase-1.md, spec-phase-2.md

Use /validate-output afterward to check quality."

Reference ideation, don't duplicate it.
```

## Obsidian-Second-Brain Plugin Integration

**Location:** `plugins/obsidian-second-brain/`

**Integration method:** MCP (Model Context Protocol)

### Pattern: Goal Reading (Read-Only)

**When:** Generating `/staff-progress` or career tracking needed

**How:**
```
Query Obsidian via MCP (read-only access):

1. Read annual goals:
   obsidian_get_file_contents("0 - PARA/1 - Projects/2026 goals.md")

2. Read quarterly goals:
   obsidian_get_file_contents("1 - Notes/OKRS/Quarterly Goals/Quarterly Goals - Q1 2026.md")

3. Read current monthly goals:
   obsidian_get_file_contents("1 - Notes/OKRS/Monthly Goals/1 - January 2026.md")

4. Extract relevant sections:
   - Career objectives (Staff track)
   - System ownership goals
   - Quality standards
   - Timeline expectations

5. Compare actual progress against stated goals:
   Actual: "2 technical documents, 47 code reviews"
   Goal: "2+ docs/quarter after Q1, 20+ reviews/month"
   Assessment: "On track"

NEVER MODIFY OBSIDIAN NOTES.
Only read to understand context and track progress.
```

### Pattern: Context-Aware Suggestions

**When:** Proactive suggestions throughout the day

**How:**
```
Before suggesting actions, check Obsidian context:

Example:
User commits architectural change.

Assistant checks Obsidian:
- User's Q1 goal: "Document & propose (M5-6)"
- Currently M1: Too early for aggressive documentation push

Suggestion (contextual):
"Nice architectural work. This could be a good ADR topic.
Note: Your Q1 goals focus on shipping reliably first,
documentation push comes in M5-6. Save this for later?"

vs.

If currently M5:
"Nice architectural work. This is prime ADR material!
Your Q1 goals emphasize documentation now.
Want to use ideation workflow to document this decision?"

Context changes suggestion timing and emphasis.
```

### Pattern: Weekly Summary with Goal Alignment

**When:** Generating `/weekly-summary`

**How:**
```
1. Generate standard weekly summary (commits, reviews, learning)

2. Query Obsidian for current quarterly goals

3. Add goal alignment section:
   ```
   Progress Toward Quarterly Goals:

   Goal: "Ship 1 feature with quality code"
   Status: ✅ Shipped purchase modal skeleton

   Goal: "Complete 20+ meaningful code reviews"
   Status: 📈 On track (15 this week, 47 total this month)

   Goal: "Schedule 3 coffee chats"
   Status: 🔄 1 completed, 2 scheduled

   Next Week Focus (from goals):
   - Continue code review velocity
   - Complete remaining coffee chats
   - Start documenting onboarding friction points
   ```

4. Show progress toward Staff signals:
   ```
   Staff Engineer Progress:
   - Technical writing: On pace (2 docs in Q1)
   - Code reviews: Above target (20+/month goal exceeded)
   - System ownership: Emerging (Subscriptions 72% ownership)
   - Cross-team impact: In progress (Platform collaboration started)
   ```

This ties weekly work directly to career progression.
```

## Cross-Plugin Coordination

### Pattern: Suggesting the Right Tool

**When:** User request could be handled by multiple plugins

**How:**
```
Analyze request and route to appropriate plugin:

"I need to refactor this component"
→ developer-tools/code-simplifier agent

"I want to commit my changes"
→ essentials/git-committer agent

"I need to think through this architecture"
→ essentials/ultrathink command

"I want to document this design"
→ ideation workflow

"How am I tracking against my goals?"
→ assistant/staff-progress command (queries Obsidian)

Always explicit: "Use [plugin]/[command] for this"
Never silently route without telling user what's happening.
```

### Pattern: Multi-Plugin Workflows

**When:** Task requires multiple plugins

**How:**
```
Example: Shipping a major feature

1. Code complete → developer-tools quality check
   "Your feature looks ready. Run /quality-check?"

2. Quality verified → essentials commit
   "Quality looks good. Commit your changes using /commit"

3. Committed → essentials PR
   "Changes committed. Create PR using /pr?"

4. PR created → ideation documentation
   "PR is up! This feature might warrant a design doc.
   Use ideation workflow to document your decisions?"

5. Documented → obsidian tracking
   "Design doc created! This counts toward your Staff
   technical writing goal."

Orchestrate workflow, but each plugin does its job.
```

## Integration Testing

### Verification Checklist

When implementing integrations, verify:

**Essentials:**
- [ ] git-committer agent successfully analyzes commits
- [ ] /commit suggestion works correctly
- [ ] /ultrathink suggestion appears for complex decisions
- [ ] /pr command integrates with PR creation flow

**Developer-Tools:**
- [ ] typescript-coder validates TypeScript patterns
- [ ] frontend-developer validates React patterns
- [ ] code-assistant skill routes requests correctly
- [ ] Quality feedback is advisory only (never blocks)

**Ideation:**
- [ ] RFC/ADR suggestions appear for architectural changes
- [ ] Design doc suggestions appear for significant features
- [ ] Workflow references are clear and actionable

**Obsidian:**
- [ ] Can read 2026 goals, quarterly goals, monthly goals
- [ ] Never modifies Obsidian notes (read-only strictly enforced)
- [ ] Goal alignment appears in progress reports
- [ ] Context-aware suggestions use goal information

## Error Handling

### When Plugin Not Available

**If essentials not installed:**
```
"I usually coordinate with the essentials plugin for git operations,
but it's not installed. Let me help directly this time."

[Provide basic assistance without essentials]

"Consider installing essentials plugin:
/plugin install essentials@kriscard"
```

**If developer-tools not installed:**
```
"I'd normally use developer-tools agents for code quality checks,
but they're not available. I can provide basic validation."

[Provide basic code review]

"For comprehensive quality checks, install developer-tools:
/plugin install developer-tools@kriscard"
```

### When Integration Fails

**If MCP connection fails:**
```
"Couldn't connect to Obsidian to check your goals.
I'll proceed without goal context this time.

Make sure obsidian-second-brain MCP is configured:
Check .claude/mcp.json"
```

**If agent invocation fails:**
```
"Tried to use [plugin]/[agent] but got an error.
Let me try an alternative approach."

[Fallback to basic assistance]
```

## Best Practices

**DO:**
- Reference other plugins explicitly ("Use essentials/commit")
- Explain why you're suggesting a plugin ("This counts toward Staff signals")
- Let specialists do their job (don't duplicate functionality)
- Provide fallbacks when plugins unavailable
- Respect plugin boundaries (read-only for Obsidian)

**DON'T:**
- Silently invoke plugins without telling user
- Duplicate functionality that exists in other plugins
- Modify data owned by other plugins (especially Obsidian)
- Assume all plugins are installed (check availability)
- Create hard dependencies (gracefully degrade if plugin missing)

## Integration Evolution

As new plugins are added to the marketplace:
1. Evaluate if assistant should integrate
2. Define clear integration pattern
3. Document in this file
4. Update SKILL.md if core behavior changes
5. Test integration thoroughly

The assistant is an orchestrator - it gets more powerful as the ecosystem grows.
