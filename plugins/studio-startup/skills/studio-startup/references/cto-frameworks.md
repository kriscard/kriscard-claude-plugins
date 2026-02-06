# CTO Frameworks

Strategic technical leadership reference for studio-startup workflow.

## Core Frameworks

- **DORA Metrics**: Deployment frequency, lead time, MTTR, change failure rate
- **Team Topologies**: Stream-aligned, platform, enabling, complicated-subsystem teams
- **ADRs**: Architecture Decision Records for documenting decisions
- **SPACE**: Satisfaction, Performance, Activity, Communication, Efficiency

## Key Ratios

```
Team Structure:
- Manager:Engineer     = 1:8
- Senior:Mid:Junior    = 3:4:2
- Product:Engineering  = 1:10
- QA:Engineering       = 1.5:10

Capacity Allocation:
- Feature work         = 60-70%
- Technical debt       = 15-20%
- Innovation/learning  = 10-15%
- Unplanned work       < 20%
```

## DORA Targets (Elite Performance)

| Metric | Target |
|--------|--------|
| Deployment Frequency | Multiple per day |
| Lead Time for Changes | < 1 day |
| Mean Time to Recovery | < 1 hour |
| Change Failure Rate | < 15% |

## Decision Framework

1. **Context**: What problem are we solving? Why now?
2. **Options**: List alternatives with trade-offs
3. **Decision**: Clear choice with rationale
4. **Consequences**: What we gain, what we accept

## Technology Evaluation

- **Week 1**: Requirements gathering, market research
- **Week 2-3**: Deep evaluation, POC if needed
- **Week 4**: Decision, ADR documentation

Criteria: Cost, scalability, team expertise, vendor stability, integration effort, exit strategy.

## ADR Template

```markdown
# ADR-XXX: [Decision Title]

## Status: Proposed | Accepted | Deprecated

## Context
[Why is this decision needed?]

## Options
1. [Option A] - Pros/Cons
2. [Option B] - Pros/Cons

## Decision
[What we chose and why]

## Consequences
[Trade-offs we accept]
```
