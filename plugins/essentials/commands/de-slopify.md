---
description: Remove AI-generated comments from the current branch
argument-hint: '[branch]'
---

# Remove AI-Generated Comments

The branch to diff against is $1. If no branch was provided, default to `main`.

Check the diff against the branch and remove AI-generated comments introduced in this branch.

## What to Remove

**AI-generated comments** - Comments that exhibit these patterns:
- Overly verbose explanations of obvious code
- Comments restating what the code clearly does (e.g., `// increment counter` above `counter++`)
- Excessive inline documentation a human wouldn't add
- Comments inconsistent with the file's existing comment style
- Generic placeholder comments (e.g., `// TODO: implement`, `// Handle error`)
- Comments with AI-like phrasing ("This function...", "The following code...")

## What to Keep

- **Doc comments** for public APIs (JSDoc, docstrings, etc.)
- **Meaningful comments** explaining WHY (business logic, workarounds, edge cases)
- **Comments matching** the file's existing style and density
- **License headers** and attribution comments

## Restrictions

**DO NOT modify any code.** Only remove comments. This includes:
- ❌ No removing try/catch blocks
- ❌ No removing null checks or validation
- ❌ No removing type casts
- ❌ No style/formatting changes to code
- ❌ No refactoring of any kind

If you see code slop, note it in your summary but do not change it.

## Output

Report a 1-3 sentence summary of comments removed and any code issues you noticed but left unchanged.
