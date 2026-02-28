---
name: pr
description: Creates a pull request with a structured template. Use when user says "/pr", wants to create a PR, needs to open a pull request, or asks to submit changes for review.
disable-model-invocation: true
---

# Create Pull Request

**Note**: If we're on `main`, then create a new feature branch following this pattern: `kriscard/${feature}`.

Create a PR for the current branch following this template:

## Title

Concise description of the change. Keep under 72 characters.

## Body Template

```
## Summary
<!-- 1-3 bullet points describing WHAT changed -->

## Why
<!-- Brief context on WHY this change was needed -->

## Notes
<!-- Optional: anything reviewers should know -->
```

## Process

1. Check `git status` and `git log` to understand changes on this branch
2. Draft title and body following the template
3. Create PR using `gh pr create`
4. Return the PR URL
