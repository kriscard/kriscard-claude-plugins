# TIL Plugin

Create "Today I Learned" documentation notes in Obsidian from coding session learnings.

## Features

- Auto-analyzes conversation context to extract learnings
- Creates engaging, story-like TIL notes
- Appends to existing daily TIL if one exists
- Follows structured template covering architecture, tech choices, and lessons

## Commands

### `/til`

Create a TIL note from the current session.

```bash
/til                    # Auto-detect project name from context
/til "Project Name"     # Specify project name explicitly
```

## Output Location

Notes are created at: `3 - Resources/TIL/til-YYYY-MM-DD.md`

## Prerequisites

- Obsidian MCP server must be configured
- Obsidian vault must be accessible

## Note Structure

Generated TIL notes include:

1. **The Big Picture** - What was built and why
2. **Architecture Deep Dive** - Technical design with analogies + Mermaid diagrams
3. **The Journey** - Narrative of what happened, including mistakes
4. **Key Code** - Significant code snippets from the session
5. **Key Takeaways** - Lessons learned
6. **Things That Broke** - Bugs and solutions with before/after code
7. **What I'd Do Differently** - Hindsight insights

### Visual Elements

- **Mermaid diagrams** for architecture, data flow, state machines
- **Code snippets** for key implementations, bug fixes, configurations

## Installation

Add to your Claude Code plugins or install from the marketplace.
