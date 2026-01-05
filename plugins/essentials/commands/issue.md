---
description: Analyze a Jira ticket, implement the fix in small steps on a dedicated branch, and validate with tests and linting.
---

Please analyze and fix the **Jira** ticket: **$ARGUMENTS**.

Follow these steps:

# PLAN

1. Open the ticket in Jira (UI or API) and capture the essentials:
   - Title, description, acceptance criteria
   - Priority, severity, components, environment(s)
   - Links (related tickets, PRs, incident/postmortem, design specs)

2. Understand the problem described in the ticket:
   - Expected vs actual behavior
   - Repro steps (or infer them from context/logs)
   - Scope: who is affected, where, since when

3. Reproduce locally or in the target environment (as applicable):
   - Confirm the bug/behavior
   - Capture logs/screenshots/trace IDs if useful

4. Search the codebase for relevant files:
   - Locate the area(s) responsible
   - Identify the “owner” modules, feature flags, configs, etc.

5. Understand prior art / history:
   - Search existing branches/PRs referencing the ticket key (e.g. `ABC-123`)
   - Search commit history for related changes
   - Search internal scratchpads/notes/docs for previous investigation (if your repo has them)
   - Look for similar tickets and how they were resolved

6. Break the work into small, manageable tasks:
   - Minimal fix first, then hardening (edge cases, telemetry, refactor if needed)
   - Identify risks, rollout plan, and any needed stakeholder reviews

7. Document the plan in a new scratchpad:
   - Filename includes the Jira key + short title (e.g. `ABC-123-fix-sharing-metadata.md`)
   - Include a link to the Jira ticket at the top
   - Include repro notes, root cause hypothesis, step-by-step tasks, and test plan

8. Ensure code passes linting and type checking

# CREATE

- Create a new branch for the ticket:
  - If you are in roofr-dev, use Roofr convention: GROW-1234 (just the Jira key), e.g. GROW-1234
  - Otherwise, use your standard convention (e.g. chore/ABC-123-short-title or fix/ABC-123-short-title)
- Solve the ticket in small, manageable steps following your plan
- Commit after each step with the Jira key in the message (e.g. `ABC-123: Fix …`)

# TEST

- Run the relevant test suite(s) (unit/integration/e2e as applicable)
- If tests are failing, fix them
- Ensure all tests pass before moving to the next step
- Add/adjust tests to prevent regressions for the reported behavior

**Reminder:** Use Jira conventions for references (ticket key in branch/commits/PR title). Use your repo’s standard tooling for PR workflows (GitHub/GitLab/etc.), but Jira is the source of truth for the issue/ticket context.
