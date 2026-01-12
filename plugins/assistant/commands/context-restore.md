---
description: Restore previously saved task context
allowed-tools: Read, Bash(ls:*, git:*)
argument-hint: [task-name]
model: sonnet
---

Restore a previously saved task context to quickly resume work without rebuilding understanding.

## Task Selection

If task name provided:
```
Restore: $ARGUMENTS
```

If no task name, list available contexts and ask user to choose:
```bash
ls -1 .claude/assistant/contexts/*.json | sed 's/.*\///' | sed 's/.json$//'
```

Present list:
```
Available contexts:
1. purchase-modal-skeleton (saved 2 hours ago)
2. payment-integration (saved yesterday)
3. fix-pagination-bug (saved 3 days ago)

Which context would you like to restore? (Enter number or name)
```

## Context Loading

Read context file:
```
.claude/assistant/contexts/{task-name}.json
```

Parse JSON and extract:
- Task name
- Timestamp (when saved)
- Git branch
- Mental model (problem, approach, reasoning)
- Related links
- TODO list
- Modified files

## Context Display

Present restored context in readable format:

```
Context Restored: purchase-modal-skeleton

Saved: 2 hours ago (2026-01-12 10:30 AM)
Branch: feat/purchase-modal

Mental Model:
Problem: Building purchase modal skeleton with responsive design
Approach: Using ModalDrawer component for responsive behavior, separating mobile/desktop layouts
Reasoning: Need 2-step navigation on mobile, 3-column layout on desktop

Related Links:
1. Jira: GROW-2380 - Purchase Modal Skeleton
   https://roofrapp.atlassian.net/browse/GROW-2380

2. PR #234: WIP: Purchase Modal Skeleton
   https://github.com/org/repo/pull/234

3. Figma: Purchase Flow Design
   https://figma.com/...

TODO (5 items remaining):
- [ ] Add mobile navigation state management
- [ ] Implement scroll tracking for step completion
- [ ] Add accessibility labels to navigation
- [ ] Write tests for mobile navigation
- [ ] Update README with component usage

Files Modified:
- src/components/PurchaseModal/PurchaseModal.tsx
- src/components/PurchaseModal/types.ts
- src/components/PurchaseModal/README.md

---

You're ready to continue where you left off!
```

## Git Branch Verification

Check if saved branch matches current branch:

```bash
current_branch=$(git branch --show-current)
saved_branch="feat/purchase-modal"  # from context
```

If mismatch:
```
⚠️  Context was saved on branch: feat/purchase-modal
    You're currently on: main

Would you like to:
A) Switch to feat/purchase-modal
B) Continue on current branch (context still useful)
C) Cancel restore

Choose: [A/B/C]
```

If user chooses A:
```bash
git checkout feat/purchase-modal
```

## File Status Check

Check if saved files still have uncommitted changes:

```bash
for file in [saved files]:
  git status --short "$file"
done
```

If files have new changes since context saved:
```
ℹ️  Some files have changed since context was saved:
- PurchaseModal.tsx: modified (new changes)
- types.ts: unmodified (as saved)

Context is still valid, but be aware of new changes.
```

## Context Not Found

If context file doesn't exist:
```
Context not found: purchase-modal-skeleton

Available contexts:
- payment-integration (saved yesterday)
- fix-pagination-bug (saved 3 days ago)

Use /context-save to create new contexts.
```

## Empty Context Directory

If no contexts exist:
```
No saved contexts found.

Use /context-save to save your current task context before switching tasks.
```

## Use Cases

**Resume after task switch:**
```
> /context-restore purchase-modal

[Displays context]

You're back in purchase-modal work!
```

**Start of day:**
```
> /context-restore

[Shows list of available contexts]
[User selects yesterday's work]

Ready to continue from yesterday!
```

**Teammate handoff:**
```
Teammate shares purchase-modal.json file
Copy to .claude/assistant/contexts/

> /context-restore purchase-modal

[Teammate's context restored]

Now you understand where they left off!
```

## Context Management

**List all contexts:**
```bash
ls -lht .claude/assistant/contexts/*.json
```

Shows contexts sorted by modification time (most recent first).

**Delete old context:**
```bash
rm .claude/assistant/contexts/old-task.json
```

## Integration

This command coordinates with:
- **context-manager agent** for intelligent context presentation
- **Read tool** for JSON parsing
- **git** for branch verification and status checking

## Notes

- Contexts are local to your machine
- No automatic expiration (manual cleanup recommended)
- Can be shared by copying JSON files
- Branch switching is optional (context useful even on different branch)
- Multiple contexts can exist simultaneously

## Tips

**Name contexts clearly:**
- Use ticket numbers: `grow-2380`
- Use descriptive names: `purchase-modal-skeleton`
- Avoid generic names: `feature`, `bug-fix`

**Regular cleanup:**
- Delete contexts for completed tasks
- Archive old contexts monthly
- Keep only active work contexts

**Team sharing:**
- Export context JSON for handoffs
- Include in PR description if helpful
- Document in team wiki for complex features
