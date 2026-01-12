# Ideation Plugin

Transform unstructured brain dumps into actionable implementation artifacts.

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

Just start talking or typing your idea:

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

## Skills

- **ideation** - Main workflow for transforming ideas into specs

## References

- `confidence-rubric.md` - Scoring criteria
- `contract-template.md` - Contract structure
- `prd-template.md` - PRD structure
- `spec-template.md` - Spec structure
