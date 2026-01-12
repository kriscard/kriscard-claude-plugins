# Plugin Orchestration Patterns

Guide for designing effective Claude Code plugin architectures with appropriate orchestration strategies.

## Philosophy

**Not all plugins need orchestrators.** The right pattern depends on:
- User intent (explicit vs implicit)
- Component relationships (independent vs coordinated)
- Workflow complexity (single-step vs multi-step)
- User expertise (beginner vs power user)

## Pattern Decision Tree

```
Does your plugin have multiple components that must work together?
├─ No → Agent-only pattern (no orchestrator needed)
└─ Yes → Choose orchestration pattern:
    ├─ Should trigger implicitly on user intent? → Skill-based orchestration
    ├─ Should user explicitly control when? → Command-based orchestration
    ├─ Applies to ALL interactions? → Meta-orchestration
    └─ Both implicit and explicit needed? → Hybrid orchestration
```

## Pattern Reference

### 1. Skill-Based Orchestration

**When to use:**
- Workflow should start automatically based on user intent
- Multi-step process that users shouldn't need to manage
- Creative/exploratory tasks (ideation, content creation)

**Entry point:** Natural language triggers skill

**Example:** `ideation` plugin
```
User: "I want to build a feature for offline bookmarks"
       ↓
ideation skill auto-triggers
       ↓
Orchestrates: confidence scoring → questions → contract → PRDs → specs
       ↓
Output: ./docs/ideation/{project}/
```

**Implementation:**
```markdown
---
name: ideation
description: Use when transforming brain dumps into specs, discussing new features, or hearing "I want to build". Also triggers on scattered ideas, voice transcripts, or half-formed concepts.
---

# Ideation Workflow

[Orchestration logic coordinating multiple steps]
```

**Pros:**
- Seamless user experience
- No command to remember
- Feels natural and conversational

**Cons:**
- Less explicit control
- Can trigger unintentionally
- Requires strong trigger descriptions

### 2. Command-Based Orchestration

**When to use:**
- Users need explicit control over workflow
- Routine/scheduled tasks (daily standup, weekly review)
- Clear start/end boundaries
- Power users who know what they want

**Entry point:** Explicit `/command` invocation

**Example:** `obsidian-second-brain` plugin
```
User: /daily-startup
       ↓
Command orchestrates multiple components:
  - Check if daily note exists (MCP)
  - Load vault structure (skill: vault-structure)
  - Analyze inbox count (MCP)
  - Suggest OKR focus (agent: okr-tracker)
  - Create daily note from template (MCP)
       ↓
Output: Interactive workflow completion
```

**Implementation:**
```markdown
---
description: Start your day - creates daily note, checks inbox, surfaces OKRs
---

# Daily Startup Workflow

1. Load vault-structure skill to understand organization
2. Use obsidian MCP to check for today's daily note
3. If missing, create from template
4. Show inbox count and top priority items
5. Activate okr-tracker agent for goal suggestions
[...]
```

**Pros:**
- Explicit user control
- Predictable behavior
- Easy to discover (/help lists them)

**Cons:**
- Users must remember command names
- Less natural than skills
- Requires typing slash command

### 3. Meta-Orchestration

**When to use:**
- Enforcement/discipline across ALL interactions
- Quality gates that should never be bypassed
- System-level behavior changes

**Entry point:** Always active (SessionStart, every message, etc.)

**Example:** `essentials/using-superpowers` skill
```
Every user message
       ↓
using-superpowers enforces:
  "Check if ANY skill applies before responding"
       ↓
Forces discipline:
  - Must check skills before clarifying questions
  - Must check skills before exploration
  - Must check skills before any action
       ↓
Result: Skills are never accidentally bypassed
```

**Implementation:**
```markdown
---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<EXTREMELY-IMPORTANT>
If there is even a 1% chance a skill might apply, you ABSOLUTELY MUST read the skill.
[...]
</EXTREMELY-IMPORTANT>
```

**Pros:**
- Ensures consistency
- Never forgotten or bypassed
- Acts as "operating system" for plugin ecosystem

**Cons:**
- Can't be disabled by user
- Must be very well designed
- Could be intrusive if poorly done

### 4. Hybrid Orchestration

**When to use:**
- Need both implicit and explicit workflows
- Supporting both beginner and power users
- Complex plugins with multiple use cases

**Entry point:** Multiple (skills + commands + agents)

**Example:** `architecture` plugin
```
Explicit entry:
  /arch-doc → Generates architecture documentation
  /check-spec → Validates specification quality

Implicit entry:
  "How should I architect this?" → senior-architect skill
  "What's our strategy?" → cto-advisor skill

Auto-activation:
  code-reviewer agent → Triggers on PR review requests
```

**Implementation:**
- Commands for known workflows
- Skills for advisory/consultative work
- Agents for specialized tasks

**Pros:**
- Flexibility for different user types
- Best of both worlds
- Multiple entry points

**Cons:**
- More complex to maintain
- Can be confusing which to use
- Risk of overlap/redundancy

### 5. Agent-Only (No Orchestrator)

**When to use:**
- Components work independently
- No coordination needed
- Specialists that activate on context

**Entry point:** Context-based (agents auto-trigger)

**Example:** `developer-tools` plugin
```
User: "I need to refactor this TypeScript code"
       ↓
typescript-coder agent auto-activates
       ↓
Works independently (no orchestration needed)

User: "Debug this React component"
       ↓
debugger agent auto-activates
       ↓
Works independently
```

**When orchestration WOULD help:**
```
User: "Help me build a new feature"
       ↓
??? Which agent: coder, typescript-coder, frontend-developer ???
       ↓
Consider adding: code-assistant skill that selects best agent
```

**Pros:**
- Simplest pattern
- No coordination overhead
- Agents specialize deeply

**Cons:**
- User must know which agent to use
- No automatic agent selection
- Can't coordinate multi-agent workflows

**Migration path to orchestration:**
Add a skill that:
1. Analyzes user request
2. Selects appropriate agent(s)
3. Potentially coordinates multiple agents

## Implementation Patterns

### Skill Orchestrator Template

```markdown
---
name: your-workflow-skill
description: Triggers when [specific user intent]. Use for [clear use cases].
---

# Your Workflow

## Phase 1: Assessment
[Analyze user input, determine needs]

## Phase 2: Coordination
[Invoke agents, load sub-skills, use MCP tools]

## Phase 3: Execution
[Coordinate multi-step workflow]

## Phase 4: Output
[Deliver results to user]
```

### Command Orchestrator Template

```markdown
---
description: Brief description of what this command does and when to use it
allowed-tools: [Bash, Read, Write, Task]
---

# Command Name

Brief explanation for the user.

## Orchestration Steps

1. Load required skills/context
2. Invoke necessary agents
3. Coordinate MCP tools
4. Present results

## Example Usage

\`\`\`
/your-command [args]
\`\`\`
```

### Meta-Orchestrator Template

```markdown
---
name: meta-skill-name
description: Use when [always/on specific events] - enforces [specific behavior]
---

<EXTREMELY-IMPORTANT>
[Non-negotiable rules that must be followed]
</EXTREMELY-IMPORTANT>

# Enforcement Rules

## What This Enforces
[Clear description of enforced behavior]

## How It Works
[Mechanism of enforcement]

## Exceptions
[If any - be very careful here]
```

## Pattern Selection Matrix

| Plugin Type | Recommended Pattern | Example |
|-------------|---------------------|---------|
| **Content Creation** | Skill-based | blog-writer, doc-coauthoring |
| **Daily Workflows** | Command-based | daily-startup, process-inbox |
| **System Enforcement** | Meta-orchestration | using-superpowers |
| **Advisory/Consulting** | Hybrid | senior-architect, cto-advisor |
| **Specialist Tools** | Agent-only → Add orchestrator if selection needed | typescript-coder, debugger |
| **Multi-phase Workflows** | Skill-based | ideation (scoring→questions→artifacts) |
| **Scheduled Tasks** | Command-based | review-okrs, maintain-vault |

## Anti-Patterns to Avoid

### ❌ Over-Orchestration
```
Bad: Creating a command that just calls one agent
  /run-debugger → debugger agent

Better: Let agent trigger on context
  User: "debug this" → debugger agent auto-activates
```

### ❌ Under-Orchestration
```
Bad: 9 independent agents, user must choose
  "Should I use coder, typescript-coder, or frontend-developer?"

Better: Add selection skill
  code-assistant skill → analyzes context → selects best agent
```

### ❌ Wrong Entry Point
```
Bad: Command for creative workflow
  /brainstorm-ideas → Requires user to know when to invoke

Better: Skill that triggers naturally
  User: "I'm thinking about..." → ideation skill activates
```

### ❌ Conflicting Orchestrators
```
Bad: Multiple commands doing similar things
  /morning-routine
  /daily-startup
  /begin-day

Better: One clear command
  /daily-startup (canonical entry point)
```

### ❌ No Orchestrator When Needed
```
Bad: Testing plugin with 3 agents, no coordination
  unit-test-developer (alone)
  integration-test-developer (alone)
  automation-test-developer (alone)

Better: Add test-suite command
  /test-suite → Runs all test types, coordinates coverage
```

## Layered Orchestration

For complex plugins, layer orchestrators:

```
Meta-Layer (essentials/using-superpowers)
  ↓ [Always enforces skill checking]

Primary Orchestrator (ideation skill OR /daily-startup command)
  ↓ [Coordinates workflow]

Secondary Components (agents, sub-skills, MCP)
  ↓ [Execute specific tasks]

Output Layer (files, summaries, actions)
```

## Testing Orchestration

### Manual Testing Checklist

- [ ] Primary entry point works as expected
- [ ] All components properly coordinated
- [ ] Appropriate for user expertise level
- [ ] Clear error handling when components fail
- [ ] Works with partial component availability

### User Experience Questions

- [ ] Is entry point discoverable? (/help or natural language)
- [ ] Does orchestration feel natural or forced?
- [ ] Can power users access components directly if needed?
- [ ] Are there clear progress indicators?
- [ ] Can users cancel/interrupt if needed?

## Migration Strategies

### From Agent-Only to Orchestrated

**Phase 1: Add Optional Orchestrator**
```
Keep: Individual agents (backward compatible)
Add: Selection skill (new feature)
Result: Both paths work
```

**Phase 2: Promote Orchestrator**
```
Keep: Agents accessible
Update: Docs to recommend orchestrator
Result: Guided towards better UX
```

**Phase 3: Optimize**
```
Keep: Agents as building blocks
Optimize: Orchestrator based on usage
Result: Best user experience
```

### From Command to Skill

**Phase 1: Add Skill Alternative**
```
Keep: /command (explicit control)
Add: skill (implicit triggering)
Result: Multiple entry points
```

**Phase 2: Gather Feedback**
```
Monitor: Which gets used more?
Adjust: Based on user preference
Result: Data-driven design
```

## Real-World Examples

See these plugins in this marketplace for reference:

- **Skill-based:** `ideation`, `content` plugins
- **Command-based:** `obsidian-second-brain` `/daily-startup`
- **Meta-orchestration:** `essentials` `using-superpowers`
- **Hybrid:** `architecture`, `ai-development`
- **Agent-only:** `developer-tools`, `testing` (candidates for orchestration)

## Further Reading

- [Plugin Structure Guide](../CLAUDE.md#plugin-structure)
- [Skill Development Best Practices](../plugins/plugin-dev/skills/skill-development/)
- [Command Development Guide](../plugins/plugin-dev/skills/command-development/)
- [Agent Development Guide](../plugins/plugin-dev/skills/agent-development/)
