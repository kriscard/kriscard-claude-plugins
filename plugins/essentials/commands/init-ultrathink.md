---
description: "Initialize a comprehensive CLAUDE.md using ultrathink methodology: /init-ultrathink [optional-context]"
---

# Initialize CLAUDE.md with Ultrathink

## Usage

`/init-ultrathink [optional context about the project]`

## Context

- Project context: $ARGUMENTS
- This command creates a comprehensive CLAUDE.md file by analyzing the repository with multiple specialized agents

## Your Role

You are the Coordinator Agent orchestrating specialized sub-agents to create a comprehensive CLAUDE.md file that will guide Claude in understanding and working with this codebase.

## Sub-Agents

1. **Repository Analyst Agent** - Analyzes project structure, tech stack, and patterns
2. **Context Gatherer Agent** - Identifies key abstractions, workflows, and conventions
3. **Documentation Agent** - Extracts insights from existing docs and comments
4. **Testing Agent** - Analyzes test patterns and quality standards
5. **Git History Analyst Agent** - Examines repository evolution and historical patterns

## Process

### Phase 1: Repository Analysis

1. **Project Structure Analysis**
   - Identify project type (web app, CLI tool, library, etc.)
   - Map complete directory structure with annotations
   - Detect all build tools, task runners, and package managers
   - Identify entry points and initialization sequences

2. **Tech Stack Detection**
   - Programming languages and versions
   - Frameworks and libraries with version constraints
   - Development tools, linters, formatters
   - Database systems and external services

3. **Architecture Patterns**
   - Design patterns in use
   - Code organization principles
   - Data flow and state management
   - Security layers and authentication flows

### Phase 2: Context Discovery

1. **Coding Conventions**
   - Naming conventions for all entities
   - Code style guides (find .prettierrc, .eslintrc, etc.)
   - Import/export patterns
   - Error handling philosophy

2. **Development Workflows**
   - Git workflow: branch naming, commit conventions, PR process
   - Local development setup
   - Testing procedures
   - Deployment and release processes

3. **Key Abstractions**
   - Core domain models
   - Common utilities and shared code
   - Reusable components
   - Service boundaries and API contracts

### Phase 3: Documentation Mining

1. **Existing Documentation**
   - README files at every level
   - API documentation
   - Architecture decision records (ADRs)
   - Inline code comments

2. **Implicit Knowledge**
   - Complex algorithms explanations
   - Performance optimizations
   - Known issues and workarounds
   - Historical context for design decisions

### Phase 4: Quality Standards

1. **Testing Patterns**
   - Test frameworks
   - Coverage requirements
   - Mocking strategies

2. **Quality Gates**
   - Linting and type checking
   - Pre-commit hooks
   - CI/CD pipeline stages

### Phase 5: Git History Analysis

1. **Repository Evolution**
   - Major milestones and releases
   - Technology migrations
   - Refactoring patterns

2. **Commit Patterns**
   - Commit message conventions
   - Code ownership patterns
   - Hot spots (frequently changed files)

## Output Format

Generate a CLAUDE.md adapted to the project type with these core sections:

1. **Repository Overview** - What the project is and does
2. **Quick Start** - How to get up and running
3. **Essential Commands** - Most important commands
4. **Architecture/Key Concepts** - Core understanding needed
5. **Project Structure** - Directory layout
6. **Important Patterns** - Key conventions to follow
7. **Code Style** - Naming and formatting standards
8. **Hidden Context** - Non-obvious but crucial info

## Final Steps

1. Show the generated CLAUDE.md for review
2. Make any requested adjustments
3. Save the file to the repository root
4. Remind user to commit the file when satisfied

## Notes

- Be comprehensive - this document is for an AI agent
- Include ALL discovered patterns and workflows
- Make commands copy-pasteable
- Provide specific file paths whenever possible
- Document workarounds and technical debt honestly
