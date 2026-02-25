---
name: commit
description: >-
  Creates semantic git commits with conventional commit format, stages changes,
  and pushes to remote. Handles pre-commit hooks and writes meaningful commit
  messages. Use when the user says "commit", "push my changes", "save to git",
  or wants to commit their current work. Not for creating PRs or branch
  management.
---

# Git Commit Workflow

Direct execution of git commit workflow - no agent delegation, fast and simple.

## Trigger Phrases

This skill activates on:
- "commit changes", "commit this", "commit my work"
- "save to git", "save my changes", "save this to git"
- "push this", "push my changes", "push my work"
- "create a commit", "make a commit"
- "git commit", "check in my changes"

## Proactive Triggering

After completing implementation work, **proactively offer** to commit:
- "I've finished implementing the feature. Would you like me to commit these changes?"
- Use AskUserQuestion with options: "Yes, commit now" / "No, I'll review first"

## Workflow

### Step 1: Assess Changes

```bash
git status
git diff
```

**If no changes:** Report "No changes to commit" and end.

### Step 2: Stage Files

Stage logically related changes:
```bash
git add <files>
```

**Skip sensitive files:** .env, credentials, tokens - warn user if detected.

### Step 3: Create Conventional Commit

Analyze changes and determine:
- **Type:** feat, fix, docs, style, refactor, perf, test, chore
- **Scope:** Component/area affected
- **Subject:** Imperative, lowercase, max 50 chars, no period

**Commit format:**
```
<type>(<scope>): <subject>

[Narrative body explaining WHAT and WHY - 2-4 sentences, NO bullet points]
```

**Good example:**
```
feat(auth): add session timeout handling

Implements automatic session refresh when user activity is detected
within the timeout window. Sessions now persist across page reloads
using localStorage with encrypted tokens.
```

**Bad example (avoid):**
```
feat(auth): add features

- Added timeout
- Added refresh
- Added localStorage
```

### Step 4: Execute Commit

```bash
git commit -m "$(cat <<'EOF'
<commit message here>
EOF
)"
```

### Step 5: Handle Pre-commit Hooks

If hooks modify files:
1. Stage the modified files
2. Amend the commit: `git commit --amend --no-edit`

### Step 6: Ask About Push

Use AskUserQuestion:
- "Commit successful! Push to remote?"
- Options: "Yes, push now" / "No, keep local"

### Step 7: Push (if confirmed)

```bash
git push
# or if no upstream:
git push -u origin <branch>
```

## Safety Rules

- NEVER commit .env files or credentials
- NEVER force push without explicit user request
- NEVER amend commits on shared branches without warning
- Always show what will be committed before committing
