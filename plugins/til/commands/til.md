---
description: Create TIL note from session learnings
argument-hint: "[project-name]"
allowed-tools: [Bash, AskUserQuestion, obsidian]
---

# TIL Note Creation

Create a "Today I Learned" documentation note capturing the learnings from this coding session.

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

First, check CLI availability:
```bash
obsidian vault &>/dev/null && echo "CLI_AVAILABLE" || echo "CLI_UNAVAILABLE"
```

- If `CLI_AVAILABLE`: Use Obsidian CLI commands via Bash
- If `CLI_UNAVAILABLE`: Ask user "Obsidian CLI isn't available. May I use Obsidian MCP instead?" and wait for confirmation

## Step 1: Determine Project Name

If `$ARGUMENTS` is provided, use it as the project name.
Otherwise, infer the project name from:
- The working directory name
- The main topic discussed in conversation
- Repository name if in a git project

## Step 2: Check for Existing TIL

**Using CLI:**
```bash
obsidian read path="3 - Resources/TIL/til-$(date +%Y-%m-%d).md"
```

**Using MCP (if CLI unavailable):**
Use `mcp__mcp-obsidian__obsidian_get_file_contents` to check if a TIL note already exists at:
`3 - Resources/TIL/til-YYYY-MM-DD.md` (where YYYY-MM-DD is today's date)

## Step 3: Analyze Conversation Context

Review the full conversation to identify:

**Technical Architecture:**
- What system or feature was designed/built
- Key architectural decisions and trade-offs
- How components connect and communicate

**Codebase Structure:**
- Files created or modified
- Directory organization patterns
- Data flow through the system

**Technology Choices:**
- Languages, frameworks, libraries used
- Why these were selected
- Integration patterns

**Lessons Learned:**
- Bugs encountered and how they were fixed
- Pitfalls discovered and how to avoid them
- New patterns or techniques learned
- "Aha moments" and key insights
- What would be done differently next time

## Step 4: Write the TIL Note

### Writing Style Requirements

- **Engaging, not boring** - Write like telling a story to a friend
- **Use analogies** - Compare technical concepts to everyday things
- **Include anecdotes** - "We tried X, it broke spectacularly because..."
- **Be specific** - Real file names, real error messages, real solutions
- **Teach the reader** - Explain WHY, not just WHAT
- **No AI attribution** - Never mention Claude or AI assistance

### Visual Elements

**Mermaid Diagrams** - Include when helpful for:
- System architecture (flowchart or C4-style)
- Data flow between components
- State machines or decision flows
- File/directory structure (graph)

Keep diagrams simple and focused. Use Obsidian-compatible Mermaid syntax.

**Code Snippets** - Include for:
- Key implementations discussed (functions, patterns)
- Bug fixes with before/after comparison
- Configuration examples
- Commands that were useful

Use appropriate language tags for syntax highlighting. Keep snippets focused - show the relevant part, not entire files.

### Frontmatter Tags (REQUIRED)

**Every TIL MUST include frontmatter with topic tags.** Analyze the session to determine 3-5 relevant tags using the `til/` prefix.

Common tag categories:
- **Technology**: `til/react`, `til/typescript`, `til/nextjs`, `til/nodejs`, `til/css`
- **Patterns**: `til/architecture`, `til/testing`, `til/hooks`, `til/composition`
- **Concepts**: `til/performance`, `til/accessibility`, `til/security`, `til/debugging`
- **Libraries**: `til/tanstack-query`, `til/zustand`, `til/motion`, `til/wavesurfer`

### Template Structure

```markdown
---
date: "YYYY-MM-DD"
tags:
  - til/[primary-technology]
  - til/[pattern-or-concept]
  - til/[specific-library-if-relevant]
---

# TIL: Building [Project Name]

## The Big Picture
[One paragraph explaining what was built and why it matters]

## Architecture Deep Dive
[Technical architecture explained with analogies. How components connect, why this design was chosen over alternatives.]

[Include a Mermaid diagram if architecture was discussed:]
` ` `mermaid
flowchart TD
    A[Component A] --> B[Component B]
    B --> C[Component C]
` ` `

## The Journey
[Narrative of what happened during the session. Include mistakes, pivots, and discoveries. Make it engaging.]

## Key Code
[Include 1-3 significant code snippets from the session:]
` ` `language
// Key implementation or pattern
` ` `

## Key Takeaways
- [Concrete lesson 1]
- [Concrete lesson 2]
- [Additional lessons as relevant]

## Things That Broke (And How We Fixed Them)
[Specific bugs, error messages, and solutions. Include file paths and line numbers where relevant.]

[If there was a bug fix, show before/after:]
` ` `language
// Before (broken)
` ` `
` ` `language
// After (fixed)
` ` `

## What I'd Do Differently
[Hindsight insights - what would make this easier next time]
```

**Note:** Only include diagrams and code snippets that were actually relevant to the session. Don't force them if the session was purely conceptual or discussion-based.

## Step 5: Create or Append

**If TIL does NOT exist for today:**

**Using CLI:**
```bash
obsidian create path="3 - Resources/TIL/til-$(date +%Y-%m-%d).md" content="$TIL_CONTENT" silent
```

**Using MCP (if CLI unavailable):**
Use `mcp__mcp-obsidian__obsidian_append_content` to create a new file at:
`3 - Resources/TIL/til-YYYY-MM-DD.md`

Write the full TIL note with frontmatter (including date and tags) following the template.

**If TIL ALREADY exists for today:**

**Using CLI:**
```bash
# Append session content
obsidian append path="3 - Resources/TIL/til-$(date +%Y-%m-%d).md" content="$SESSION_CONTENT" silent
```

**Using MCP (if CLI unavailable):**
Use `mcp__mcp-obsidian__obsidian_patch_content` to add new tags to the existing frontmatter, then use `mcp__mcp-obsidian__obsidian_append_content` to append the session content.

1. First, add any NEW topic tags to the existing frontmatter (don't duplicate existing tags)
2. Then append the session content with a separator:

```markdown

---

# Session 2: Building [Project Name]

## The Big Picture
[Session content WITHOUT frontmatter - tags were added above]
```

## Step 6: Confirm Completion

After writing the note, confirm to the user:
- What was documented
- Where the note was saved
- Whether it was a new note or appended to existing

Provide a brief summary of the key takeaways captured.
