---
description: Remove AI-generated code slop from the current branch
argument-hint: '[branch]'
---

# Remove AI Code Slop

The branch to diff against is $1. If no branch was provided, default to `main`.

Check the diff against the branch, and remove all AI generated slop introduced in this branch.

## What to Look For

1. **Useless comments** - Extra comments that a human wouldn't add or are inconsistent with the rest of the file (useful doc comments are good to keep)
2. **Extra defensive code** - Unnecessary try/catch blocks, null checks, or validation that are abnormal for that area of the codebase (especially if called by trusted/validated codepaths)
3. **Type workarounds** - Casts to `any` to get around type issues
4. **Style inconsistencies** - Any other style that is inconsistent with the file

## Removal Process

### Comments: Remove automatically
Remove useless comments without asking. These are low-risk changes that improve readability.

### Code changes: Ask permission first
For any code removal (defensive checks, type casts, style fixes), you MUST:
1. Explain what you found and why it's considered slop
2. Show the specific code you want to remove
3. Explain the risk if any (usually none for AI slop)
4. Wait for user approval before removing

Example:
```
Found: try/catch block in `processUser()` at line 42
Why slop: This function is only called from validated internal paths. The outer `handleRequest()` already catches errors.
Risk: None - error handling is already present at the boundary.
Remove? [y/n]
```

## Output

Report at the end with only a 1-3 sentence summary of what you changed.
