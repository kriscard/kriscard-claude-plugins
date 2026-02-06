---
name: senior-architect
description: "Architecture: Use when designing system architecture, creating C4 diagrams, evaluating tech trade-offs, or writing ADRs. NOT for implementation details or coding."
---

# Senior Architect

Complete toolkit for system design and architecture decisions.

## Tech Stack

**Languages:** TypeScript, JavaScript, Python, Go, Swift, Kotlin
**Frontend:** React, Next.js, React Native, Flutter
**Backend:** Node.js, Express, GraphQL, REST APIs
**Database:** PostgreSQL, Prisma, Supabase
**DevOps:** Docker, Kubernetes, Terraform, GitHub Actions
**Cloud:** AWS, GCP, Azure

## Architecture Patterns

### Monolith vs Microservices

| Aspect | Monolith | Microservices |
|--------|----------|---------------|
| Complexity | Lower initially | Higher, but scales better |
| Deployment | Single unit | Independent services |
| Team scaling | Harder beyond 10 devs | Enables team autonomy |
| Debugging | Easier | Requires distributed tracing |

**Decision**: Start monolith, extract when team/scale demands.

### API Design

**REST:**
- Resource-based URLs (`/users`, `/orders`)
- HTTP methods for operations
- Use for CRUD-heavy applications

**GraphQL:**
- Single endpoint
- Client-specified queries
- Use for complex data requirements

### Database Patterns

- **Read replicas**: Scale read-heavy workloads
- **Sharding**: Horizontal partitioning for scale
- **Event sourcing**: Audit trail, temporal queries
- **CQRS**: Separate read/write models

## System Design Process

### 1. Requirements
- Functional requirements (what it does)
- Non-functional requirements (performance, scale, security)
- Constraints (budget, timeline, team size)

### 2. High-Level Design
- Component identification
- Data flow mapping
- Integration points

### 3. Detailed Design
- API contracts
- Database schema
- Error handling
- Caching strategy

### 4. Trade-offs
- Document decisions with rationale
- Acknowledge what you're giving up
- Plan for future evolution

## Diagram Types

### C4 Model
1. **Context**: System and external actors
2. **Container**: Applications and data stores
3. **Component**: Internal modules
4. **Code**: Class-level (rarely needed)

### Other Diagrams
- **Sequence**: Time-ordered interactions
- **Data Flow**: How data moves through system
- **Entity Relationship**: Database schema

## Best Practices

### Code Quality
- Follow established patterns
- Write comprehensive tests
- Document decisions

### Performance
- Measure before optimizing
- Use appropriate caching
- Optimize critical paths

### Security
- Validate all inputs
- Use parameterized queries
- Implement proper authentication

### Maintainability
- Write clear code
- Use consistent naming
- Keep it simple

## Output Standards

- Architecture Decision Records (ADRs)
- C4 diagrams in Mermaid format
- System design documents
- API specifications
- Database schema documentation
