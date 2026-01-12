---
description: Save current task context before switching
allowed-tools: Write, Bash(git:*)
argument-hint: [task-name]
model: sonnet
---

Save current task context (mental model, related links, TODO list) before switching to a different task.

## Purpose

Preserve your mental state when context switching so you can quickly resume later without rebuilding understanding.

## Task Name Determination

If task name provided:
```
Task: $ARGUMENTS
```

If no task name, infer from current git branch:
```bash
git branch --show-current
```

## Information Collection

### 1. Mental Model

Ask user:
```
What problem are you solving right now?
What approach are you taking and why?

(2-3 sentences capturing your current thinking)
```

### 2. Related Links

Ask user:
```
Any related PRs, issues, or tickets?

Examples:
- GitHub PR: https://github.com/org/repo/pull/123
- Jira: https://jira.com/browse/GROW-2380
- Stack Overflow: https://stackoverflow.com/questions/...
- Docs: https://docs.example.com/...

(List all relevant links, one per line)
```

### 3. TODO List

Ask user:
```
What still needs to be done on this task?

(Bullet list of remaining work)
```

### 4. Current Files

Automatically capture:
```bash
# Files with uncommitted changes
git status --short

# Recently viewed/edited files (if available)
```

## Storage Format

Save to `.claude/assistant/contexts/{task-name}.json`:

```json
{
  "task_name": "purchase-modal-skeleton",
  "timestamp": "2026-01-12T10:30:00Z",
  "git_branch": "feat/purchase-modal",
  "mental_model": {
    "problem": "Building purchase modal skeleton with responsive design",
    "approach": "Using ModalDrawer component for responsive behavior, separating mobile/desktop layouts",
    "reasoning": "Need 2-step navigation on mobile, 3-column layout on desktop"
  },
  "related_links": [
    {
      "type": "jira",
      "url": "https://roofrapp.atlassian.net/browse/GROW-2380",
      "title": "Purchase Modal Skeleton"
    },
    {
      "type": "pr",
      "url": "https://github.com/org/repo/pull/234",
      "title": "WIP: Purchase Modal Skeleton"
    },
    {
      "type": "figma",
      "url": "https://figma.com/...",
      "title": "Purchase Flow Design"
    }
  ],
  "todo": [
    "Add mobile navigation state management",
    "Implement scroll tracking for step completion",
    "Add accessibility labels to navigation",
    "Write tests for mobile navigation",
    "Update README with component usage"
  ],
  "files_modified": [
    "src/components/PurchaseModal/PurchaseModal.tsx",
    "src/components/PurchaseModal/types.ts",
    "src/components/PurchaseModal/README.md"
  ]
}
```

## Context Save Process

1. **Collect information** from user via prompts
2. **Capture git state** automatically
3. **Format as JSON** with timestamps
4. **Save to file** in `.claude/assistant/contexts/`
5. **Confirm** to user

## Output Confirmation

```
Context Saved: purchase-modal-skeleton

Mental Model: Building purchase modal skeleton with responsive design
Related Links: 3 links saved
TODO: 5 items remaining
Files: 3 modified files captured

Saved to: .claude/assistant/contexts/purchase-modal-skeleton.json

Resume later with: /context-restore purchase-modal-skeleton
```

## Directory Management

Ensure `.claude/assistant/contexts/` directory exists:
```bash
mkdir -p .claude/assistant/contexts
```

## File Naming

Convert task names to safe filenames:
- Lowercase
- Replace spaces with hyphens
- Remove special characters
- Add `.json` extension

Examples:
- "Purchase Modal" → `purchase-modal.json`
- "GROW-2380" → `grow-2380.json`
- "Fix pagination bug" → `fix-pagination-bug.json`

## Use Cases

**Before switching tasks:**
```
> /context-save purchase-modal

[Answers prompts]

Context saved! Switch to your next task.
```

**Before end of day:**
```
> /context-save

[Uses current branch name]
[Captures state for tomorrow]

Context saved for tomorrow!
```

**Before taking PTO:**
```
> /context-save complex-feature

Document current state before vacation.
Teammate can use /context-restore to understand where you left off.
```

## Notes

- Contexts stored locally in `.claude/assistant/contexts/`
- Not committed to git (in `.gitignore`)
- Can be shared with teammates by copying JSON file
- Contexts do not expire (manual cleanup needed)
- Use descriptive task names for easy retrieval

## Integration

This command coordinates with:
- **context-manager agent** for intelligent prompting and formatting
- **git** for branch and file state capture
- **Write tool** for JSON persistence
