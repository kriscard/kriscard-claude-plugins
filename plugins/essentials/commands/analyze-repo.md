# Repository Analysis

Perform a comprehensive analysis of this repository using specialized sub-agents, then generate documentation.

## Arguments

- `$ARGUMENTS` — optional context about the project or what to focus on

## Sub-Agents

Coordinate these specialized agents in parallel:

1. **Repository Analyst** — Project structure, tech stack, entry points, build tools
2. **Context Gatherer** — Key abstractions, conventions, coding patterns, workflows
3. **Documentation Miner** — Existing docs, inline comments, implicit knowledge
4. **Testing Analyst** — Test frameworks, coverage, mocking strategies, quality gates
5. **Git History Analyst** — Commit patterns, hot spots, migrations, code ownership

## Analysis Phases

### Phase 1: Repository Structure

- Project type (web app, CLI, library, monorepo, etc.)
- Directory organization with annotations
- Entry points and initialization sequences
- Build tools, task runners, package managers
- Configuration files and their purposes

### Phase 2: Tech Stack & Architecture

- Languages, frameworks, libraries with versions
- Architectural patterns and design principles
- Data flow and state management
- Security layers and authentication flows
- External services and dependencies
- Component diagram (Mermaid)

### Phase 3: Code Conventions

- Naming conventions for all entities
- Style guides (.prettierrc, .eslintrc, biome.json, etc.)
- Import/export patterns
- Error handling philosophy
- Git workflow: branch naming, commit conventions, PR process

### Phase 4: Module & API Analysis

For each major module:
- Core responsibility and public interfaces
- Dependencies and design patterns
- API endpoints with methods, request/response formats
- Data models, relationships, storage patterns

### Phase 5: Quality & Testing

- Test structure, frameworks, coverage areas
- Mocking strategies and test patterns
- Linting, type checking, pre-commit hooks
- CI/CD pipeline stages

### Phase 6: Git History

- Major milestones and releases
- Technology migrations and refactoring patterns
- Commit message conventions
- Hot spots (frequently changed files)
- Technical debt and areas for improvement

## Output

Generate **two documents** based on the analysis:

### 1. `CLAUDE.md` (project root)

Concise, actionable context for Claude Code:

1. **Repository Overview** — What the project is and does
2. **Quick Start** — How to get up and running
3. **Essential Commands** — Most important commands (copy-pasteable)
4. **Architecture** — Core patterns and key concepts
5. **Project Structure** — Directory layout with annotations
6. **Important Patterns** — Conventions to follow
7. **Code Style** — Naming and formatting standards
8. **Hidden Context** — Non-obvious but crucial info

### 2. `REPO_ANALYSIS.md` (project root)

Detailed technical documentation with:

- Architecture diagrams (Mermaid)
- Data flow diagrams for critical paths
- Module-by-module analysis
- API documentation
- Database/storage schema
- Technical debt inventory

## Final Steps

1. Show both documents for review
2. Make any requested adjustments
3. Save files to the repository root
4. Remind user to commit when satisfied

## Notes

- Include ALL discovered patterns and workflows
- Make commands copy-pasteable with specific file paths
- Document workarounds and technical debt honestly
- CLAUDE.md should be concise (<200 lines); detailed analysis goes in REPO_ANALYSIS.md
