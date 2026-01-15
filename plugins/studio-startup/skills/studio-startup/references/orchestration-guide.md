# Orchestration Guide for Studio Startup

Deep dive on coordinating multiple specialized plugins to deliver cohesive startup workflows.

## Orchestration Philosophy

Studio Startup follows the **conductor pattern** - the skill acts as a conductor coordinating specialized musicians (plugins) rather than implementing functionality directly. Each phase leverages existing expertise:

- **product-strategist**: Business and market strategy
- **ideation**: Requirements and specifications
- **tech-stack-advisor** (our agent): Technology recommendations
- **cto-advisor**: Technical validation
- **senior-architect**: System design
- **frontend-design**: UI/UX implementation
- **code-assistant**: Code generation

### Why Orchestrate vs. Implement?

**Orchestration benefits**:
- Leverage specialized expertise (plugins are domain experts)
- Maintain separation of concerns
- Automatic improvements as plugins update
- Users can jump to specific plugins if needed
- Reduces code duplication

**When to implement directly**:
- Coordination logic unique to this workflow
- Simple utility functions
- Workflow state management
- User preference handling

## Skill Invocation Patterns

### Using the Skill Tool

The Skill tool loads another skill's knowledge and activates it:

```python
# Invoke product-strategist
Skill(skill="product-strategist")

# Plugin-namespaced skill
Skill(skill="architecture:senior-architect")
```

**After invocation**: The called skill takes over and guides the conversation according to its instructions. Control returns to studio-startup when the skill completes.

**Context passing**: Skills see the full conversation history, so prior context (requirements, decisions) is available. Explicitly summarize key context before invocation for clarity:

```
Before calling product-strategist:
"Let me pass this to our product strategy specialist. Context: User wants to build a [type] for [purpose], targeting [users]."

Then: Skill(skill="product-strategist")
```

### Using the Task Tool for Agents

The Task tool launches specialized agents:

```python
# Invoke tech-stack-advisor agent
Task(
    subagent_type="tech-stack-advisor",
    prompt="Based on requirements in docs/ideation/, recommend 2-3 optimal tech stacks...",
    description="Recommend tech stacks"
)
```

**Key differences from Skill**:
- Agents run autonomously with their own tools
- Agents return results when done (don't take over conversation)
- Need explicit prompt (skills infer from conversation)
- Better for discrete tasks with clear outputs

### Choosing Skill vs Agent vs Direct Implementation

**Use Skill when**:
- Need conversational, multi-turn interaction
- Task requires asking user questions
- Workflow is exploratory (product strategy, requirements gathering)
- Output is a conversation artifact, not a file

**Use Agent (Task) when**:
- Task is well-defined with clear output
- Can execute autonomously without user input
- Need access to tools (Read, Write, Bash, etc.)
- Want result returned (not conversation takeover)

**Implement directly when**:
- Simple coordination logic
- Formatting/presentation
- State management
- User preference reading

## Phase Coordination Patterns

### Linear Phase Flow

Most common pattern - each phase builds on previous:

```
Strategy → Requirements → Tech → Validation → Design → Implementation
```

**Implementation**:
1. Complete phase N
2. Announce phase N+1
3. Pass phase N outputs to phase N+1
4. Execute phase N+1
5. Repeat

**Example**:
```markdown
Phase 1 (Strategy) complete.
Output: Product vision in memory, target users defined.

Announce: "Moving to Requirements phase..."

Phase 2 (Requirements):
- Context: "Based on product strategy (vision: X, users: Y)..."
- Invoke: Skill(skill="ideation")
- Output: docs/ideation/ with detailed specs
```

### Conditional Branching

Some phases may skip or vary based on project type:

```python
if project_type == "web":
    # Invoke frontend-design + code-assistant
    Skill(skill="frontend-design")
    Skill(skill="code-assistant")
elif project_type == "mobile":
    # Invoke code-assistant only
    Skill(skill="code-assistant")
elif project_type == "api":
    # Different prompting for code-assistant
    Skill(skill="code-assistant")  # Backend-focused prompt
```

**Implementation**:
- Detect project type early (Phase 0 or 1)
- Store in workflow state
- Branch in Implementation phase

### Parallel Execution

Some phases could theoretically run in parallel, but we execute sequentially for simplicity and conversation flow. If you need true parallelism:

```python
# Launch multiple agents simultaneously
# (Not recommended for this workflow - better to sequence for user understanding)
```

### Phase Skipping

User can skip phases if they have artifacts:

**Detection**:
```markdown
Phase 0: Ask "Which phase to start from?"
- If "Implementation", check for required inputs:
  - docs/ideation/ or similar (requirements)
  - docs/architecture.md or similar (design)
- If missing, warn and guide user
```

**Safe skipping**:
```markdown
User wants to skip to Phase 6 (Implementation).

Check prerequisites:
✅ Requirements exist (docs/ideation/)
✅ Architecture exists (docs/architecture.md)
✅ Tech stack decided (in architecture doc)

Safe to skip. Start from Implementation phase.
```

**Unsafe skipping**:
```markdown
User wants to skip to Phase 6 (Implementation).

Missing prerequisites:
❌ No requirements found
❌ No architecture documentation

Cannot skip safely. Options:
1. Start from Requirements phase
2. Provide existing requirements and we'll continue
3. Skip at your own risk (not recommended)
```

## Context Management Between Phases

### What to Pass Forward

Each phase should capture and pass forward:

**Phase 1 (Strategy) outputs**:
- Product vision statement
- Target user personas
- Key differentiators
- Success metrics (OKRs)

**Phase 2 (Requirements) outputs**:
- Location of requirements docs (docs/ideation/)
- Key features list
- User stories
- Technical constraints

**Phase 3 (Tech Selection) outputs**:
- Selected tech stack (full details)
- Rationale for choice
- Deployment platform preferences
- Scalability requirements

**Phase 4 (Validation) outputs**:
- Architecture pattern recommendations
- Risk assessments
- Best practices to follow
- Technical debt warnings

**Phase 5 (Design) outputs**:
- Architecture documentation location
- Component breakdown
- Data models
- Integration points

### Passing Context Effectively

**Method 1: Summarize before invocation** (Recommended)

```markdown
Calling product-strategist with context:
- User idea: "[brief description]"
- Target users: "[if known]"
- Constraints: "[if any]"

Skill(skill="product-strategist")
```

**Method 2: Reference artifacts**

```markdown
Calling senior-architect with context:
- Requirements: See docs/ideation/
- Tech stack: Next.js + TypeScript + PostgreSQL
- Team size: 1 developer
- Scale: 1000 users initially

Skill(skill="architecture:senior-architect")
```

**Method 3: State object** (For complex workflows)

Maintain a workflow state object:

```json
{
  "current_phase": 3,
  "project_name": "my-app",
  "project_type": "web",
  "tech_stack": {
    "frontend": "Next.js",
    "backend": "Next.js API Routes",
    "database": "PostgreSQL"
  },
  "artifacts": {
    "strategy": "In conversation history",
    "requirements": "docs/ideation/",
    "architecture": "docs/architecture.md"
  }
}
```

## Error Recovery Strategies

### Plugin Not Available

When invoking a plugin that's not installed:

```markdown
Try: Skill(skill="product-strategist")

If error: "Skill 'product-strategist' not found"

Recovery:
1. Inform user clearly:
   "The 'product-strategist' plugin is required but not installed."

2. Provide installation:
   "Install with: cc plugin install architecture"
   (Note: Check plugin name - might be in 'architecture' plugin)

3. Offer alternatives:
   "Alternatively, I can:"
   - "Guide product strategy discussion directly (less comprehensive)"
   - "Skip to requirements gathering"
   - "Pause workflow and resume after installation"

4. User chooses path forward
```

### Skill Invocation Failure

If skill invokes but fails mid-execution:

```markdown
Error during ideation skill execution

Recovery:
1. Check conversation for partial outputs
2. Summarize what was completed:
   "We completed user stories but not technical specs"

3. Offer options:
   - "Continue manually with my guidance"
   - "Retry the ideation skill"
   - "Skip to next phase with what we have"

4. Save state to .studio-startup-state.json
```

### User Abandons Workflow

If user changes topic mid-workflow:

```markdown
User was in Phase 3 (Tech Selection), now asks about unrelated topic

Actions:
1. Note current phase
2. After answering unrelated question, offer:
   "We were in the middle of setting up [project name]. Would you like to:"
   - "Continue from Tech Selection phase"
   - "Start over"
   - "Abandon this workflow"

3. If user wants to continue, resume from saved state
```

### State Persistence

Save workflow state at phase boundaries:

```json
// .studio-startup-state.json
{
  "version": "0.1.0",
  "timestamp": "2026-01-14T19:45:00Z",
  "current_phase": 3,
  "phases_completed": ["strategy", "requirements"],
  "project_name": "my-app",
  "project_type": "web",
  "artifacts": {
    "strategy": "Product vision: [...], Target users: [...]",
    "requirements": "docs/ideation/",
    "tech_stack_selected": null,
    "architecture": null
  },
  "user_settings": {
    "favorite_stacks": ["Next.js", "TanStack Start"],
    "experience_level": "intermediate"
  }
}
```

**When to save**:
- After each phase completion
- Before user interruption
- On errors

**When to load**:
- User explicitly says "resume"
- Detect incomplete .studio-startup-state.json in directory
- User mentions previous project by name

## Advanced Coordination Techniques

### Feedback Loops

Some phases may need to loop back:

```markdown
Phase 3 (Tech Selection):
- tech-stack-advisor recommends options
- User: "None of these work for me"

Loop back:
- Ask user why options don't work
- Gather additional constraints
- Re-invoke tech-stack-advisor with new context
- Present revised options
```

**Implementation**:
```python
max_attempts = 3
attempt = 0

while attempt < max_attempts:
    # Invoke tech-stack-advisor
    options = get_tech_recommendations()

    # Present to user
    user_choice = present_options(options)

    if user_choice == "none":
        if attempt < max_attempts - 1:
            additional_constraints = ask_user_why()
            attempt += 1
            continue
        else:
            # Fallback: User provides their own stack
            user_stack = ask_user_for_stack()
            break
    else:
        selected_stack = user_choice
        break
```

### Conditional Plugin Selection

Choose which plugins to invoke based on context:

```markdown
Implementation Phase:

If project_type == "web":
    If has_ui_requirements:
        Invoke: frontend-design
    Invoke: code-assistant (full-stack mode)

Elif project_type == "mobile":
    If ui_complexity == "high":
        Consider: ui-ux-designer for wireframes first
    Invoke: code-assistant (mobile mode)

Elif project_type == "api":
    If needs_documentation:
        Invoke: api-documentation-generator (if available)
    Invoke: code-assistant (backend mode)
```

### Progressive Detailing

Start with high-level and progressively add detail:

```markdown
Phase 2 (Requirements):
1. Gather high-level features (5-10 items)
2. For each feature, expand to user stories
3. For complex features, create detailed acceptance criteria
4. Identify technical constraints

Rather than:
1. Gather all details for Feature 1
2. Gather all details for Feature 2
...

The progressive approach prevents analysis paralysis.
```

### User Confirmation Checkpoints

Strategic points to ask user confirmation:

**Checkpoint 1**: After Strategy, before Requirements
```markdown
"Based on our product strategy:
- Vision: [X]
- Target users: [Y]
- Key differentiators: [Z]

Does this align with your vision? Any adjustments before we dive into detailed requirements?"
```

**Checkpoint 2**: After Tech Selection, before Validation
```markdown
"I recommend: [Stack]

Pros: [...]
Cons: [...]

Proceed with this stack? (This is a significant decision that affects implementation)"
```

**Checkpoint 3**: Before Implementation
```markdown
"Ready to implement. This will create:
- [Project structure]
- [X features]
- ~[Y] files

Estimated: [time estimate based on complexity]

Proceed with implementation?"
```

## Performance Optimization

### Minimize Context Switching

**Anti-pattern** (too much switching):
```markdown
1. Call product-strategist (Phase 1)
2. Return to orchestrator, ask question
3. Call ideation (Phase 2)
4. Return to orchestrator, format output
5. Call tech-stack-advisor
6. Return to orchestrator, ask question
...
```

**Better pattern** (batch related work):
```markdown
1. Call product-strategist (Phase 1)
   - Let it fully complete
   - Capture all outputs
2. Transition once to Phase 2
3. Call ideation (Phase 2)
   - Let it fully complete
4. Transition once to Phase 3
...
```

### Efficient Prompting

When invoking agents, provide complete context in one prompt:

**Anti-pattern** (vague prompts):
```python
Task(subagent_type="tech-stack-advisor", prompt="Recommend a stack")
# Agent has to infer requirements, may ask follow-ups
```

**Better pattern** (complete prompts):
```python
Task(
    subagent_type="tech-stack-advisor",
    prompt="""
    Recommend 2-3 optimal tech stacks for:

    Project type: Web application (SaaS)
    Key requirements:
    - Real-time collaboration features
    - Expected 10k users within 6 months
    - Team: 1 developer (intermediate experience)
    - Must deploy easily (prefer serverless/edge)

    Constraints:
    - Prefer TypeScript
    - Need good documentation/community
    - Fast development iteration

    User's favorite stacks: Next.js, TanStack Start

    Provide detailed pros/cons for each option.
    """
)
```

## Testing Orchestration

### Manual Testing Workflow

1. **Test full workflow**: Start to finish without shortcuts
2. **Test phase skipping**: Start from each phase
3. **Test with/without settings**: Verify defaults work
4. **Test each project type**: Web, mobile, API, CLI
5. **Test error handling**: Plugin missing, user cancellation, invalid input
6. **Test settings integration**: Verify preferences are respected

### Validation Checklist

After orchestration implementation:

- [ ] All phase transitions are announced clearly
- [ ] TodoWrite tracks all phases
- [ ] Context passes correctly between phases
- [ ] Settings are read and applied
- [ ] Error handling is graceful
- [ ] User can skip phases safely
- [ ] All project types work
- [ ] Final outputs are complete
- [ ] Documentation is generated
- [ ] Git commit happens if configured

## Common Pitfalls

### Pitfall 1: Over-orchestration

**Problem**: Orchestrator tries to control every detail
**Symptom**: Phases don't feel autonomous, lots of interruptions
**Solution**: Let plugins/agents work autonomously, intervene only for coordination

### Pitfall 2: Under-orchestration

**Problem**: Just calling plugins in sequence without glue logic
**Symptom**: Feels disjointed, outputs don't connect, user confused
**Solution**: Add transition announcements, context passing, validation

### Pitfall 3: Not Handling Failures

**Problem**: When a plugin fails, workflow breaks completely
**Symptom**: User stuck, can't recover, loses all progress
**Solution**: Implement error handling, save state, offer alternatives

### Pitfall 4: Ignoring User Preferences

**Problem**: Settings exist but are never read or applied
**Symptom**: User gets generic experience despite configuring preferences
**Solution**: Read settings in Phase 0, apply throughout workflow

### Pitfall 5: Poor Context Passing

**Problem**: Each phase starts from scratch, re-asking same questions
**Symptom**: User frustrated by repetition, workflow feels inefficient
**Solution**: Explicitly pass context, reference previous decisions

## Real-World Examples

### Example 1: Simple Web App

```markdown
User: "Help me build a to-do app"

Orchestration:
1. Phase 0: Check settings (none found, offer to create)
   User declines, use defaults
2. Phase 1: product-strategist
   Output: Simple todo app, target personal users
3. Phase 2: ideation
   Output: Basic CRUD features, lists, items
4. Phase 3: tech-stack-advisor
   Recommended: Next.js (simple, fast to deploy)
5. Phase 4: cto-advisor
   Output: Monolithic architecture fine for personal app
6. Phase 5: senior-architect
   Output: Simple component structure, local state
7. Phase 6: Ask output path: ~/projects/todo-app
8. Phase 7: frontend-design + code-assistant
   Implement full app with components, API routes
9. Phase 8: Generate README, commit, done

Result: Working todo app in ~/projects/todo-app
```

### Example 2: Complex SaaS with Team

```markdown
User: "Build a customer feedback management platform for teams"

Orchestration:
1. Phase 0: Load settings (found, has preferences)
2. Phase 1: product-strategist (extensive - 30 min)
   Output: Vision, target B2B market, pricing strategy
3. Phase 2: ideation (detailed requirements)
   Output: User auth, workspaces, feedback widgets, analytics
4. Phase 3: tech-stack-advisor
   Input: Needs scale, team of 5, complex requirements
   Recommended: Next.js + tRPC + PostgreSQL + Vercel
5. Phase 4: cto-advisor (thorough validation)
   Output: Recommend modular monolith, clear boundaries, testing strategy
6. Phase 5: senior-architect (detailed design)
   Output: Component architecture, database schema, API design
7. Phase 6: Create in ~/projects/feedback-platform
8. Phase 7: Extensive implementation
   - frontend-design for UI/UX
   - code-assistant for full implementation
   - Include testing setup (from settings)
9. Phase 8: Comprehensive docs, git init, initial commit

Result: Production-ready SaaS foundation with architecture
```

### Example 3: User Skips to Implementation

```markdown
User: "I have requirements and architecture, just implement it"

Orchestration:
1. Phase 0: Detect skip request
   Ask: "Where are requirements and architecture docs?"
   User: "In ./docs/"
2. Validate: Check ./docs/ contains needed files
   ✅ requirements.md exists
   ✅ architecture.md exists
3. Extract tech stack from architecture.md
   Found: React Native + Expo + Supabase
4. Confirm with user: "I see you chose React Native + Expo. Proceed?"
   User: Yes
5. Skip to Phase 7 (Implementation)
   - code-assistant for mobile app
   - Use docs/ as context
6. Phase 8: Finalization (README, manifest, etc.)

Result: Implementation without redundant strategy/requirements phases
```

## Summary

Orchestration is about coordination, not control. Let specialized plugins do their work, focus on transitions, context passing, error handling, and user experience. The studio-startup orchestrator's value is in creating a cohesive journey, not reimplementing functionality that already exists elsewhere.
