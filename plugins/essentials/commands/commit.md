---
description: Create a conventional commit with all changes and push to remote
---

# Commit and Push Changes

Create a conventional commit with all current changes and push to the remote repository.

## Steps

1. Run `git status` to see all changes
2. Run `git diff` to review the changes
3. Analyze the changes and determine the appropriate conventional commit type:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `style:` for formatting changes
   - `refactor:` for code refactoring
   - `test:` for test additions/changes
   - `chore:` for maintenance tasks

4. Stage by changes similar and logic changes with `git add`
5. Create a conventional commit with a descriptive message but don't overengineer the message description stay simple
6. Push to the current branch with `git push`
