---
description: Transform messy brain dumps into structured artifacts (contract → PRDs → specs)
argument-hint: '<brain dump or paste messy idea>'
---

# Ideation

Transform unstructured ideas into actionable implementation artifacts.

## Input

**$ARGUMENTS**

If empty, ask user to share their idea using `AskUserQuestion`.

## Process

Load and follow the `ideation` skill workflow:

1. **Intake** - Accept the mess as-is (voice transcripts, scattered thoughts, contradictions)
2. **Confidence scoring** - Score understanding across 5 dimensions
3. **Clarifying questions** - Ask until 95% confidence (use `AskUserQuestion`)
4. **Generate artifacts** - Contract → PRDs → Specs

## Output

Write to `./docs/ideation/{project-name}/`:
- `contract.md` - Problem, goals, success criteria, scope
- `prd-phase-N.md` - Phased requirements
- `spec-phase-N.md` - Implementation specs

## When to Use

| Situation | Use |
|-----------|-----|
| Vague idea, unclear thoughts | `/ideation` |
| Existing ticket needs spec | `/spec` or `/deep-spec` |
