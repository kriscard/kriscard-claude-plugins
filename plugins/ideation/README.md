# Ideation Plugin

Transform unstructured brain dumps into actionable implementation artifacts.

## Orchestration

### /validate-output (Command)

Validate ideation workflow outputs for completeness, quality, and consistency.

**Usage:**
```bash
# Validate by project name
/validate-output user-bookmarking

# Validate by path
/validate-output ./docs/ideation/user-bookmarking

# Validate specific artifact type
/validate-output user-bookmarking --type contract
/validate-output user-bookmarking --type prd
/validate-output user-bookmarking --type spec

# Auto-fix common issues
/validate-output user-bookmarking --fix
```

**What it does:**
1. Discovers artifacts (contract, PRDs, specs) in project directory
2. Validates contract against template (6 required sections)
3. Validates PRDs against template (user stories, requirements, metrics)
4. Validates specs against template (architecture, APIs, implementation)
5. Checks cross-document consistency (contract ↔ PRD ↔ spec)
6. Generates validation report with score and actionable fixes

**Validation focus:**
- Template conformance (all required sections present)
- Confidence rubric criteria (95%+ confidence reflected)
- Phased implementation structure (phase boundaries, dependencies)
- Inter-document traceability (no gaps, no orphans)

**Quality thresholds:**
- 100%: Ready for implementation
- 90-99%: Minor fixes recommended
- 75-89%: Address warnings before coding
- <75%: Significant rework needed

**Key difference from `architecture/check-spec`:**
- `ideation/validate-output`: Validates ideation-specific workflow outputs
- `architecture/check-spec`: Generic specification validation

## What It Does

Takes messy input (voice transcripts, scattered notes, half-formed ideas) and produces:

1. **Contract** - Problem statement, goals, success criteria, scope
2. **PRDs** - Phased requirements documents
3. **Specs** - Implementation specifications

## Workflow

```
Brain dump → Confidence scoring → Questions → Contract → PRDs → Specs
```

## Key Feature: Confidence Gating

The skill won't proceed until it has 95% confidence it understands your requirements:

| Score | Action |
|-------|--------|
| < 70 | Major gaps - asks 5+ questions |
| 70-84 | Moderate gaps - asks 3-5 questions |
| 85-94 | Minor gaps - asks 1-2 questions |
| >= 95 | Ready to generate artifacts |

## Usage

Explicit command:
```
/ideation "I have this idea for a feature where users can..."
```

Or just start talking:

```
"okay so i'm thinking about this feature where users can save their
favorite items, like bookmarking but with tags instead of folders,
and it should work offline somehow..."
```

The skill will:
1. Analyze what you said
2. Score confidence across 5 dimensions
3. Ask targeted questions for low-scoring areas
4. Generate structured artifacts when ready

## Output

All artifacts written to `./docs/ideation/{project-name}/`:

```
contract.md          # Lean contract
prd-phase-1.md       # Phase 1 requirements
prd-phase-2.md       # Phase 2 requirements
spec-phase-1.md      # Phase 1 implementation spec
spec-phase-2.md      # Phase 2 implementation spec
```

## When to Use

| Situation | Command |
|-----------|---------|
| Vague idea, messy thoughts | `/ideation` |
| Existing ticket needs implementation plan | `/spec` (essentials) |
| Complex ticket needs thorough exploration | `/deep-spec` (essentials) |

## Skills

- **ideation** - Main workflow for transforming ideas into specs

## References

- `confidence-rubric.md` - Scoring criteria
- `contract-template.md` - Contract structure
- `prd-template.md` - PRD structure
- `spec-template.md` - Spec structure
