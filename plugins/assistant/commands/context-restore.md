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

