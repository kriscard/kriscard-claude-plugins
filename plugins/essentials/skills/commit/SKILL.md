---
name: commit
description: This skill should be used when the user says "commit changes", "commit this", "commit my work", "save to git", "save my changes", "push this", "push my work", "create a commit", or wants to save their work to version control. Handles the full git workflow including staging, committing, and pushing.
---

# Git Commit Workflow

Orchestrates the complete git workflow from staging changes through committing to optionally pushing to remote.

## Trigger Phrases

This skill activates on:
- "commit changes", "commit this", "commit my work"
- "save to git", "save my changes", "save this to git"
- "push this", "push my changes", "push my work"
- "create a commit", "make a commit"
- "git commit", "check in my changes"

## Workflow

### Phase 1: Assessment

First, understand what has changed:

1. Run `git status` to see all modified, staged, and untracked files
2. Run `git diff` to see the actual changes
3. Determine if there are changes worth committing

**If no changes exist:**
- Inform the user: "No changes to commit. Your working directory is clean."
- End workflow

### Phase 2: Staging

If there are unstaged changes:

1. Analyze which files should be staged together (logical grouping)
2. Stage relevant files with `git add`
3. Avoid staging sensitive files (.env, credentials, tokens)

**Staging Strategy:**
- Group related changes together
- Warn about potentially sensitive files
- Skip files in .gitignore

### Phase 3: Commit

Spawn the `git-committer` agent to handle the commit:

```
Use Task tool with:
- subagent_type: "essentials:git-committer"
- prompt: "Create a conventional commit for the staged changes.
          Follow the commit message guidelines with narrative prose body."
```

The git-committer agent will:
- Analyze staged changes
- Determine appropriate commit type (feat, fix, refactor, etc.)
- Write a clear subject line (max 50 chars)
- Write narrative prose body explaining WHAT and WHY
- Execute the commit

### Phase 4: Push Confirmation

After successful commit, use AskUserQuestion to ask about pushing:

```
Use AskUserQuestion tool with:
- question: "Commit successful! Would you like to push to the remote?"
- options:
  - "Yes, push now" - Push immediately
  - "No, just commit" - Keep changes local
```

### Phase 5: Push (if confirmed)

If user confirms push:

1. Determine current branch: `git branch --show-current`
2. Check if branch has upstream: `git rev-parse --abbrev-ref @{upstream}`
3. If no upstream, push with `-u`: `git push -u origin <branch>`
4. If upstream exists: `git push`
5. Confirm success to user

## Error Handling

### Pre-commit Hook Failures

If pre-commit hooks modify files:
1. The git-committer agent will detect this
2. It will amend the commit to include hook changes
3. Workflow continues normally

### Push Failures

If push fails:
- Check for authentication issues
- Check for remote rejection (force push needed?)
- Report clear error to user
- Suggest resolution steps

### Merge Conflicts

If conflicts exist:
- Do NOT attempt to auto-resolve
- Inform user about conflicts
- Suggest: "Please resolve conflicts manually, then ask me to commit again"

## Examples

### Example 1: Simple Commit
```
User: "commit my changes"

Workflow:
1. git status → 2 files modified
2. git add . → stage all
3. git-committer agent → creates commit
4. AskUserQuestion → "Push to remote?"
5. User selects "Yes" → git push
6. "Changes committed and pushed successfully!"
```

### Example 2: Selective Staging
```
User: "save my work to git"

Workflow:
1. git status → 5 files modified, 1 is .env
2. Stage 4 files (skip .env, warn user)
3. git-committer agent → creates commit
4. AskUserQuestion → "Push to remote?"
5. User selects "No" → skip push
6. "Changes committed locally. Run 'git push' when ready."
```

### Example 3: No Changes
```
User: "commit this"

Workflow:
1. git status → clean working directory
2. "No changes to commit. Your working directory is clean."
```

## Integration with Existing Components

This skill orchestrates:
- **git-committer agent**: Handles commit message creation and execution
- **AskUserQuestion tool**: User confirmation for push
- **Bash tool**: Git commands for status, staging, pushing

## Safety Rules

- NEVER commit .env files or credentials
- NEVER force push without explicit user request
- NEVER amend commits on shared branches without warning
- Always show what will be committed before committing
