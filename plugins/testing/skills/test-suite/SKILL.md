---
name: test-suite
disable-model-invocation: true
description: >-
  Run comprehensive test suite - coordinates unit, integration, and E2E testing
  for full coverage. Make sure to use this skill whenever the user says "run
  tests", "test suite", "run all tests", "full test coverage", or wants to
  coordinate multiple testing layers.
---

# Test Suite Orchestrator

Orchestrates a complete testing workflow, coordinating all three test specialist agents to ensure comprehensive coverage across unit, integration, and end-to-end layers.

## Usage

```bash
# Run full test suite
/test-suite

# Run specific test layer
/test-suite --unit
/test-suite --integration
/test-suite --e2e

# Run multiple layers
/test-suite --unit --integration
```

## Orchestration Workflow

### Phase 1: Analysis

1. Scan project structure to identify:
   - Test framework (Jest, Vitest, Playwright, etc.)
   - Existing test files and coverage gaps
   - Testing needs per layer

2. Determine which test layers are needed:
   - Unit: Always recommended for functions/components
   - Integration: For API endpoints, database operations
   - E2E: For critical user workflows

### Phase 2: Layer-by-Layer Testing

#### Unit Testing
```
Invoke: unit-test-developer agent

Tasks:
  - Generate/update unit tests for functions, classes, components
  - Focus on edge cases and business logic
  - Aim for high code coverage (80%+)
  - Use TDD practices when appropriate
```

#### Integration Testing
```
Invoke: integration-test-developer agent

Tasks:
  - Test API endpoints and request/response handling
  - Validate database operations and transactions
  - Test service-to-service communication
  - Contract testing for external services
```

#### E2E Testing
```
Invoke: automation-test-developer agent

Tasks:
  - Test critical user workflows end-to-end
  - Cross-browser/platform validation
  - Performance and accessibility validation
```

### Phase 3: Aggregation & Reporting

Collect results from all layers:
- Total tests added/updated
- Coverage metrics by layer
- Failed tests (if any)
- Recommendations for improvement

Present unified summary to user.

## Command Options

| Option | Description |
|--------|-------------|
| `--unit` | Run only unit tests |
| `--integration` | Run only integration tests |
| `--e2e` | Run only E2E/automation tests |
| `--coverage` | Generate detailed coverage reports |
| `--watch` | Run tests in watch mode |
| `--fix` | Attempt to fix failing tests |

## Testing Strategy

### When to Use Each Layer

**Unit Tests:** Pure functions, component rendering, business logic, edge cases

**Integration Tests:** API route handlers, database CRUD, external service integration, auth flows

**E2E Tests:** User login/registration, checkout flows, form submissions, multi-page workflows

### Test Pyramid

```
      /\
     /E2E\      ← Few (critical paths only)
    /------\
   /  Int   \   ← Some (service boundaries)
  /----------\
 /    Unit    \ ← Many (functions, components)
/--------------\
```

## Error Handling

| Error | Recovery Strategy |
|-------|-------------------|
| Test framework not found | Prompt to install (Jest, Vitest, etc.) |
| Agent unavailable | Skip that layer, warn user |
| Tests fail | Provide failure details, offer --fix option |
| Coverage below threshold | Recommend additional tests |

## Best Practices

1. **Run full suite before PRs**: Ensure comprehensive coverage
2. **Use specific layers during development**: Faster feedback
3. **Maintain test pyramid**: More unit, fewer E2E
4. **Review coverage reports**: Identify gaps
5. **Update tests with code changes**: Keep tests in sync
