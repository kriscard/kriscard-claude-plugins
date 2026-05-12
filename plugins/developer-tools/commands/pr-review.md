---
description: Comprehensive PR review combining code-reviewer agent + react-patterns skill
argument-hint: [PR number, branch name, or omit for current branch]
---

# /pr-review

Run a thorough PR audit covering both general code quality and React-specific concerns.

## Workflow

1. **Get the diff:**
   - If a PR number is given: `gh pr diff <number>`
   - If a branch is given: `git diff main..<branch>`
   - Otherwise: current branch vs main (`git diff main..HEAD`), or staged + unstaged if no diverging commits

2. **Audit in parallel:**
   - **For all changed files** → spawn the `code-reviewer` agent for security, correctness, and quality concerns
   - **For React/TypeScript files** (`.tsx`, `.jsx`, hooks) → invoke the `react-patterns` skill

3. **Synthesize findings** grouped by priority:
   - **CRITICAL** — security holes, correctness bugs, data loss risks
   - **HIGH** — React anti-patterns (universal checks), performance regressions, breaking changes
   - **MEDIUM** — quality issues, missing tests, style inconsistencies
   - **LOW** — suggestions, refactoring opportunities

4. **Output:** report grouped by priority with `file:line` references and concrete fixes. End with a verdict (Approve / Request changes / Critical issues to discuss).

## When to skip

- For trivial diffs (typo, single-line config change), just answer directly — running both audits adds latency without value.
- For non-React diffs (pure backend, infra), call only the `code-reviewer` agent.
