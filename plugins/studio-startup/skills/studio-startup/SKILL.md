---
name: studio-startup
description: "Startup: Use for /studio-startup:new or when starting a new project/MVP from scratch. Orchestrates full workflow. NOT for existing codebases."
version: 0.1.0
---

# Studio Startup Orchestration Skill

## Overview

This skill orchestrates the complete journey from startup idea to working MVP by coordinating specialized marketplace plugins. It provides a structured workflow that ensures proper product strategy, requirements gathering, technical validation, architecture design, and implementation - preventing common startup pitfalls like building the wrong thing or making poor technical decisions.

## When to Use This Skill

This skill should be used when the user asks to "start a project", "new startup", "side project idea", "create an app", "build an MVP", "help me launch", or describes wanting to build something new. It applies to web applications, mobile apps, APIs, and CLI tools.

## Core Workflow

Execute the following phases in sequence, clearly announcing each phase transition to the user. Use the TodoWrite tool at the start to create phase tracking todos.

### Phase 0: Initial Setup

Before beginning the main workflow:

1. **Check for settings file** at `.claude/studio-startup.local.md`
   - If missing, offer to create it: "I notice you don't have settings configured. Would you like me to create a settings file with your preferences?"
   - If user accepts, guide them through key preferences (favorite stacks, experience level, team size)
   - If user declines, use sensible defaults (Next.js/TanStack Start for web, React Native for mobile, FastAPI for API)

2. **Determine starting phase**
   - Ask user: "Which phase would you like to start from?"
   - Options:
     - **Strategy** - Complete workflow from business vision
     - **Requirements** - Skip strategy, start with detailed specs
     - **Tech Selection** - Have requirements, need stack recommendations
     - **Implementation** - Have architecture, ready to code
   - Default to Strategy if user is unsure

3. **Create phase tracking**
   - Use TodoWrite to create todos for all selected phases
   - Mark first phase as in_progress

### Phase 1: Product Strategy

**Announce**: "Moving to Product Strategy phase - defining vision and market fit..."

Use the product strategy frameworks from `references/product-strategy.md`:

The product strategy phase will guide:
- Product vision and value proposition
- Target users and market analysis
- Competitive landscape assessment
- OKR setting for MVP scope

**Output from this phase**: Clear product strategy with defined goals, target users, and success metrics.

**Mark phase complete** and move to Requirements.

### Phase 2: Requirements Gathering

**Announce**: "Product strategy complete. Moving to Requirements phase - gathering detailed specifications..."

Invoke the `ideation` skill using the Skill tool:

```
Skill tool → "ideation"
```

The ideation skill will:
- Transform product strategy into structured requirements
- Define user stories and features
- Create phased implementation plan
- Generate technical specifications

**Output from this phase**: Detailed requirements documents in `docs/ideation/` directory.

**Mark phase complete** and move to Tech Selection.

### Phase 3: Tech Stack Selection

**Announce**: "Requirements gathered. Moving to Tech Selection phase - analyzing optimal stack..."

Invoke the `tech-stack-advisor` agent (defined in this plugin) using the Task tool:

```
Task tool → subagent_type: "tech-stack-advisor"
Prompt: "Based on the requirements in docs/ideation/, recommend 2-3 optimal tech stacks. Consider: [requirements summary], team experience: [from settings], scalability needs: [from strategy]"
```

The agent will:
- Analyze requirements and constraints
- Present 2-3 detailed stack options with pros/cons
- Include deployment/hosting recommendations
- Provide rationale for each option

**User interaction**: Present options and let user choose or request alternatives.

**Output from this phase**: Selected tech stack with rationale.

**Mark phase complete** and move to Technical Validation.

### Phase 4: Technical Validation

**Announce**: "Tech stack selected. Moving to Technical Validation phase - ensuring solid architecture principles..."

Use the CTO frameworks from `references/cto-frameworks.md` to validate:

The technical validation phase will:
- Validate tech stack choice against requirements
- Identify potential scalability bottlenecks
- Suggest architecture patterns
- Warn about technical debt risks
- Recommend best practices for chosen stack

**Output from this phase**: Technical validation report with architecture guidance.

**Mark phase complete** and move to System Design.

### Phase 5: System Design

**Announce**: "Technical decisions validated. Moving to System Design phase - creating detailed architecture..."

Invoke the `senior-architect` skill using the Skill tool:

```
Skill tool → "architecture:senior-architect"
Prompt: "Create detailed system design for this [project type] using [selected stack]. Requirements in docs/ideation/, CTO guidance available. Include component architecture, data flow, and key design patterns."
```

The senior-architect will:
- Design complete system architecture
- Define component boundaries and responsibilities
- Specify data models and relationships
- Create architecture diagrams (C4 or similar)
- Document key design decisions

**Output from this phase**: Architecture documentation in `docs/architecture.md` or similar.

**Mark phase complete** and prepare for Implementation.

### Phase 6: Project Setup & Path Selection

**Before implementation**, gather final details:

1. **Ask user for output path**:
   - Check settings for `default_path`
   - Prompt: "Where should I create the project? (Default: [from settings or ~/projects])"
   - Validate path exists or can be created

2. **Confirm project name**:
   - Use name from earlier in workflow or ask
   - Validate name is filesystem-safe (kebab-case recommended)

3. **Create project directory**:
   ```bash
   mkdir -p /chosen/path/project-name
   cd /chosen/path/project-name
   ```

4. **Initialize git if configured**:
   ```bash
   # If settings.output_preferences.git_init is true
   git init
   ```

### Phase 7: Implementation

**Announce**: "System design complete. Moving to Implementation phase - generating MVP code..."

**Implementation strategy depends on project type**:

#### For Web Applications

Invoke both `frontend-design` and `code-assistant` skills:

```
Skill tool → "frontend-design"
Prompt: "Design and implement the UI for this [app type]. Requirements in docs/ideation/, architecture in docs/architecture.md. Use [selected stack]. Focus on core MVP features."

Skill tool → "developer-tools:code-assistant"
Prompt: "Implement the complete web application based on frontend design and architecture. Include authentication, API routes, database setup, and core features from requirements."
```

#### For Mobile Applications

Invoke `code-assistant`:

```
Skill tool → "developer-tools:code-assistant"
Prompt: "Implement mobile app using [selected stack]. Requirements in docs/ideation/, architecture in docs/architecture.md. Include navigation, screens, state management, and API integration for core features."
```

#### For APIs/Backend

Invoke `code-assistant`:

```
Skill tool → "developer-tools:code-assistant"
Prompt: "Implement API service using [selected stack]. Requirements in docs/ideation/, architecture in docs/architecture.md. Include endpoints, data models, authentication, and database integration."
```

#### For CLI Tools

Invoke `code-assistant`:

```
Skill tool → "developer-tools:code-assistant"
Prompt: "Implement CLI tool using [selected stack]. Requirements in docs/ideation/, architecture in docs/architecture.md. Include command structure, argument parsing, and core functionality."
```

**Mark phase complete** and move to Finalization.

### Phase 8: Finalization & Handoff

**Announce**: "Implementation complete. Finalizing project artifacts..."

1. **Generate project documentation**:
   - Create comprehensive `README.md`:
     - Project overview and features
     - Setup instructions (dependencies, environment)
     - Architecture summary (link to docs/architecture.md)
     - Deployment guide (based on selected stack and hosting preferences)
     - Development workflow (how to run, test, build)

2. **Create project manifest** (`.studio-startup.json`):
   ```json
   {
     "plugin_version": "0.1.0",
     "created_at": "[timestamp]",
     "project_type": "[web|mobile|api|cli]",
     "tech_stack": {
       "frontend": "[if applicable]",
       "backend": "[stack]",
       "database": "[if applicable]",
       "deployment": "[platforms]"
     },
     "phases_completed": [
       "strategy", "requirements", "tech-selection",
       "validation", "design", "implementation"
     ],
     "documentation": {
       "product_specs": "docs/ideation/",
       "architecture": "docs/architecture.md",
       "readme": "README.md"
     }
   }
   ```

3. **Organize documentation**:
   - Ensure all docs are in proper locations
   - Create `docs/` directory structure if needed
   - Copy product specs from ideation output
   - Ensure architecture docs are present

4. **Initial git commit** (if git_init enabled):
   ```bash
   git add .
   git commit -m "feat: initial project setup from studio-startup plugin

   Complete MVP implementation with:
   - Product strategy and requirements
   - [Selected tech stack]
   - Core features: [list key features]

   Generated by studio-startup plugin v0.1.0"
   ```

5. **Mark all phase todos complete**

6. **Present final summary to user**:
   ```
   ✅ Project successfully created at: [path]

   📋 What was created:
   - Complete [project type] MVP using [stack]
   - Product specifications in docs/ideation/
   - Architecture documentation in docs/architecture.md
   - Comprehensive README with setup instructions
   - [X features] implemented and ready to use

   🚀 Next steps:
   1. Review README.md for setup instructions
   2. Install dependencies: [command]
   3. Configure environment: Copy .env.example to .env
   4. Run development server: [command]
   5. Deploy to [recommended platforms]

   💡 To iterate: Use the generated documentation as foundation
      and continue development with code-assistant or specialized agents.
   ```

## Settings Integration

Throughout the workflow, reference user settings from `.claude/studio-startup.local.md`:

### Reading Settings

If settings file exists, extract preferences:

```bash
# Check if settings exist
test -f .claude/studio-startup.local.md
```

**Key settings to use**:
- `favorite_stacks.[project_type]` - Prioritize these in tech recommendations
- `team_context.experience_level` - Influences stack complexity recommendations
- `team_context.team_size` - Affects architecture decisions (monolith vs microservices)
- `default_patterns.*` - Apply these patterns in implementation
- `output_preferences.default_path` - Default project location
- `deployment_preferences.*` - Use in hosting recommendations

### Applying Settings

**In Tech Selection phase**:
- Pass favorite stacks to tech-stack-advisor agent
- Mention experience level for appropriate complexity
- Reference team size for scalability decisions

**In Implementation phase**:
- Include testing setup if `default_patterns.testing: true`
- Add Docker config if `default_patterns.docker: true`
- Include linting if `default_patterns.eslint: true`

**In Finalization phase**:
- Initialize git if `output_preferences.git_init: true`
- Use `readme_template` level (minimal vs detailed)
- Add LICENSE if `output_preferences.include_license: true`

## Command vs Skill Entry Points

This skill can be triggered two ways:

### 1. Natural Language (Skill Activation)

User phrases like "help me start a SaaS project" trigger this skill automatically.

**Behavior**: Full interactive workflow with questions and guidance.

### 2. Explicit Command

User runs `/studio-startup:new` command (see commands/new.md).

**Behavior**: Command may pass arguments (project type, name, starting phase) that skip some interactive questions. The skill still executes the same workflow phases.

**Coordination**: When command invokes this skill, it will pass context about any arguments provided. Use this context to skip redundant questions.

## Progress Tracking

Use TodoWrite throughout:

1. **At start**: Create todos for all phases (0-8)
2. **Phase transitions**: Mark current phase complete, next phase in_progress
3. **Within phases**: If phases have sub-steps, add temporary todos
4. **At completion**: All todos should be marked completed

This gives users clear visibility into workflow progress.

## Error Handling

### Missing Dependencies

If required plugins are unavailable:
- List missing plugins explicitly
- Provide installation instructions
- Offer to continue with available plugins (degraded mode)

**Example**:
```
Required plugin 'architecture' not found.
Install with: cc plugin install architecture

Would you like to continue without architecture design phase?
(Warning: This may result in less optimal system design)
```

### Phase Failures

If a phase fails (skill throws error, user cancels, etc.):
- Save progress in `.studio-startup-state.json`
- Explain what failed and why
- Offer to resume from this phase later
- Provide manual next steps if needed

### User Interruptions

If user interrupts workflow (changes topic, asks different question):
- Note current phase in conversation
- Offer to save state: "Would you like me to save progress? You can resume later with the same workflow."
- If user returns to topic, detect and offer to continue

## Edge Cases

### User Already Has Some Artifacts

If user says "I already have requirements" or "I already did product strategy":
- Confirm they want to skip that phase
- Ask for location of existing docs
- Validate artifacts exist and are usable
- Resume workflow from next phase

### User Wants to Change Decisions

If user wants to change tech stack after selection:
- Go back to Tech Selection phase
- Re-run validation and design phases
- Don't re-implement (that would be wasteful)
- Update manifest with decision history

### Small Projects vs Large Projects

Adjust phase depth based on project scope:

**Small projects** (single developer, simple app):
- Product strategy can be brief (5-10 minutes)
- Requirements can be lightweight
- Architecture can be simple

**Large projects** (team, complex requirements):
- Invest more time in each phase
- More detailed documentation
- More thorough validation

**Detection**: Ask during Phase 0: "Is this a simple side project or a more complex startup?" Use response to calibrate phase depth.

## Integration Notes

### Calling Skills

Use Skill tool for skill invocation:

```python
# Correct
Skill(skill="product-strategist")
Skill(skill="ideation")
Skill(skill="architecture:senior-architect")

# Note: Skills from other plugins require plugin prefix
# This plugin's skills don't need prefix
```

### Calling Agents

Use Task tool for agent invocation:

```python
# For agents in this plugin
Task(subagent_type="tech-stack-advisor", prompt="...", description="...")

# For agents in other plugins (use full identifier)
Task(subagent_type="developer-tools/code-assistant", prompt="...", description="...")
```

### Plugin Availability

Before invoking external plugins:
- Assume they are available (common marketplace plugins)
- If invocation fails, catch error and handle gracefully
- Provide installation guidance

## Best Practices

1. **Clear phase announcements**: Always announce phase transitions
2. **User confirmation at key points**: Especially before implementation
3. **Save context between phases**: Pass outputs from earlier phases to later ones
4. **Respect user settings**: Don't ignore their preferences
5. **Comprehensive documentation**: Generate thorough docs, they're the foundation for iteration
6. **Explain decisions**: When orchestrating, explain why calling each plugin
7. **Handle failures gracefully**: Don't leave users stuck if something fails

## Additional Resources

For detailed orchestration patterns and advanced coordination strategies, see:
- **`references/orchestration-guide.md`** - Deep dive on skill coordination patterns
- **`references/tech-stack-catalog.md`** - Common stacks with detailed pros/cons
- **`references/project-types.md`** - Type-specific guidance and patterns
- **`references/cto-frameworks.md`** - DORA metrics, team ratios, ADR templates
- **`references/product-strategy.md`** - OKRs, RICE prioritization, product vision
