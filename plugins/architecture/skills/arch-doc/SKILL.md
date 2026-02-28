---
name: arch-doc
description: "Generate architecture documentation with C4 diagrams and ADRs. Use when user says '/architecture:arch-doc', needs architecture docs, or wants to create ADRs."
disable-model-invocation: true
---

# Architecture Documentation Generator

Generate architecture documentation for: $ARGUMENTS

## Process

### 1. Discovery
- Explore project structure, configs, and existing docs
- Identify services, dependencies, and integration points
- Find existing architecture files or diagrams

### 2. Choose Output Type

Based on scope:
- **System Overview** → C4 Context + Container diagrams
- **Service Deep-Dive** → C4 Component diagram + data flow
- **Decision Documentation** → ADR

### 3. Generate Documentation

## Output Formats

### C4 Model (Mermaid)

```mermaid
C4Container
  title Container Diagram

  Person(user, "User", "Description")
  System_Boundary(b1, "System Name") {
    Container(web, "Web App", "React", "Description")
    Container(api, "API", "Node.js", "Description")
    ContainerDb(db, "Database", "PostgreSQL", "Description")
  }
  System_Ext(ext, "External System", "Description")

  Rel(user, web, "Uses")
  Rel(web, api, "Calls")
  Rel(api, db, "Reads/Writes")
```

### ADR Template

```markdown
# ADR-XXX: [Decision Title]

## Status
Proposed | Accepted | Deprecated

## Context
[Why is this decision needed?]

## Decision
[What did we decide?]

## Options Considered
1. **[Option A]**: [Pros/Cons]
2. **[Option B]**: [Pros/Cons]

## Consequences
- [What becomes easier]
- [What becomes harder]
```

### Data Flow Diagram

```mermaid
flowchart LR
  A[Source] --> B[Process]
  B --> C[Store]
  C --> D[Output]
```

## File Locations

- `docs/architecture/` - C4 diagrams, system overview
- `docs/adr/` - Architecture Decision Records
- `docs/data-flow/` - Data flow documentation

## Usage

```bash
/arch-doc system              # Full system documentation
/arch-doc auth-service        # Specific service
/arch-doc "migrate to pg"     # Document a decision
```
