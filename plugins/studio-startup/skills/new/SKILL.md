---
name: new
description: "Start a new project, startup, or side project with guided workflow from idea to MVP. Use when user says '/studio-startup:new', wants to start a new project, or needs to kick off a startup workflow."
disable-model-invocation: true
---

# Studio Startup: New Project Command

## Purpose

This command starts the studio-startup orchestration workflow explicitly. It's an alternative to natural language triggering of the studio-startup skill.

## How This Command Works

When user runs `/studio-startup:new`, invoke the `studio-startup` skill using the Skill tool. If arguments are provided, pass them as context to the skill.

## Implementation Instructions

### Step 1: Check for Settings

Before invoking skill, check if user has settings:

```bash
test -f .claude/studio-startup.local.md
```

### Step 2: Parse and Validate Arguments

Extract arguments if provided:
- `--type` - Project type (web, mobile, api, cli)
- `--name` - Project name
- `--phase` - Starting phase

Validate values if provided.

### Step 3: Invoke Skill

Simply state the context and invoke the studio-startup skill:

```
User invoked /studio-startup:new command.
[Include any provided arguments]

Skill(skill="studio-startup")
```

The skill will handle everything from here - orchestration, phase execution, user interaction, and completion.

## Examples

### Interactive Mode
```
User: /studio-startup:new

Response:
"Starting studio-startup workflow...

Skill(skill="studio-startup")
```

### With Arguments
```
User: /studio-startup:new --type=web --name="My SaaS App"

Response:
"Starting studio-startup workflow for web application 'My SaaS App'...

Skill(skill="studio-startup")
```

### Starting from Specific Phase
```
User: /studio-startup:new --phase=tech

Response:
"Starting studio-startup workflow from tech selection phase...

Skill(skill="studio-startup")
```

## Tips

- Keep command implementation minimal - the skill does the heavy lifting
- Just pass context and invoke skill
- Let skill handle validation, orchestration, and execution
- Don't duplicate skill logic in command
