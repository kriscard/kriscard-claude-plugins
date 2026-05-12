---
description: Audit React/Next.js code against the react-check skill (universal checks + thematic deep-dives)
argument-hint: [optional file path or scope]
---

# /react-check

Run a React/Next.js audit using the `react-check` skill.

## What this does

Explicit invocation of the `react-check` skill. The skill applies:

1. **Universal checks** (always run) — 6 high-leverage pitfalls that fire on any React audit
2. **Deep-dive references** loaded selectively based on what the code suggests:
   - `useeffect-antipatterns.md` — if effects look off
   - `re-renders-and-memoization.md` — if memo/perf is the question
   - `bundle-and-perf-investigation.md` — if bundle/load slowness
   - `portals-and-stacking-context.md` — if modal/z-index issue
   - `rendering-models.md` — if SSR/CSR/RSC choice
   - `vercel-rules.md` — for comprehensive 57-rule audit

## Scope

If the user provides a path, audit that. Otherwise:
- If there are uncommitted changes → audit the changed files
- If there's a current PR → audit the PR diff
- Otherwise → ask which scope (single file, directory, whole project)

## Output format

For each issue found:

```
[PRIORITY] Rule / Pattern
File: path/to/file.tsx:line
Issue: what's wrong
Fix: code example or concrete change
```

Group issues by priority (CRITICAL → HIGH → MEDIUM → LOW). End with a 3-item highest-impact-fixes list and an overall verdict (Pass / Needs work / Critical issues).
