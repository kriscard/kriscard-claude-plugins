---
name: standup
description: Generates daily standup from yesterday's git activity. Use when user says "/standup", asks for a standup update, wants a daily status, or needs yesterday's work summary.
model: sonnet
disable-model-invocation: true
---

Generate a daily standup summary based on yesterday's work.

## Data Collection

Query git activity for the last 24 hours:
```
git log --since="24 hours ago" --author="$(git config user.email)" --oneline
```

Extract:
- Commits made
- PRs created or merged (check for PR references in commits)
- Code reviews conducted (check git log for review activity)

## Analysis

Use the essentials/git-committer agent to analyze commit messages and extract meaningful accomplishments (not just raw commit text).

Transform technical commits into casual, conversational language:
- "feat(modal): add purchase modal skeleton" → "Shipped the purchase modal skeleton"
- "fix: resolve pagination bug" → "Finally got that pagination bug fixed"
- "refactor: migrate to React Query" → "Finally got that React Query migration working"

## Output Format

Generate standup in this format:

```
Yesterday I:
- [Accomplishment 1 in casual language]
- [Accomplishment 2 in casual language]
- [Accomplishment 3 in casual language]

Today I plan to:
- [Infer from current branch or ask user]
- [Continue work on incomplete tasks]
```

**Style guidelines:**
- Casual, conversational tone ("Shipped X", "Finally got Y working")
- Focus on accomplishments, not commit messages
- Highlight unblocking others if code reviews helped teammates
- Keep it brief (3-5 bullets for yesterday)
- "Today I plan to" should be realistic based on current work

## Context Integration

If user has active branches or saved context via `/context-save`, reference those for "Today I plan to" section.

## No Activity Handling

If no commits in last 24 hours:
```
Yesterday I:
- Focused on code reviews and helping the team
- Planning and design work (no commits yet)

Today I plan to:
- [Check current branch for active work]
```

## Example Output

```
Yesterday I:
- Shipped the purchase modal skeleton (GROW-2380)
- Finally got that React Query migration working
- Reviewed 3 PRs, unblocked Sarah on the TypeScript issue

Today I plan to:
- Start on the payment integration
- Finish up those code review follow-ups
```
