---
description: Run comprehensive test suite - coordinates unit, integration, and E2E testing for full coverage
allowed-tools: [Task, Read, Write, Bash, Glob, Grep]
---

# Test Suite Command

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

## What This Does

This command coordinates three specialist agents to provide comprehensive test coverage:

1. **Unit Tests** (`unit-test-developer`) - Component-level testing
2. **Integration Tests** (`integration-test-developer`) - Service boundary testing
3. **E2E Tests** (`automation-test-developer`) - User workflow testing

## Orchestration Workflow

### Phase 1: Analysis
```
1. Scan project structure to identify:
   - Test framework (Jest, Vitest, Playwright, etc.)
   - Existing test files
   - Coverage gaps
   - Testing needs

2. Determine which test layers are needed:
   - Unit: Always recommended for functions/components
   - Integration: For API endpoints, database operations
   - E2E: For critical user workflows
```

### Phase 2: Layer-by-Layer Testing

#### Step 1: Unit Testing
```
Invoke: unit-test-developer agent

Tasks:
  - Generate/update unit tests for functions, classes, components
  - Focus on edge cases and business logic
  - Aim for high code coverage (80%+)
  - Use TDD practices when appropriate

Output:
  - Test files in __tests__/ or *.test.ts
  - Coverage reports
  - Summary of tests added
```

#### Step 2: Integration Testing
```
Invoke: integration-test-developer agent

Tasks:
  - Test API endpoints and request/response handling
  - Validate database operations and transactions
  - Test service-to-service communication
  - Contract testing for external services

Output:
  - Integration test files
  - API test reports
  - Database validation results
```

#### Step 3: E2E Testing
```
Invoke: automation-test-developer agent

Tasks:
  - Test critical user workflows end-to-end
  - Cross-browser/platform validation
  - Performance testing
  - Visual regression checks
  - Accessibility validation

Output:
  - E2E test files (Playwright, Cypress, etc.)
  - Test execution reports
  - Screenshots/videos of failures
```

### Phase 3: Aggregation & Reporting

```
Collect results from all layers:
  - Total tests added/updated
  - Coverage metrics by layer
  - Failed tests (if any)
  - Recommendations for improvement

Present unified summary to user
```

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

**Unit Tests:**
- Pure functions and utilities
- Component rendering and props
- Business logic and calculations
- Edge cases and error handling

**Integration Tests:**
- API route handlers
- Database CRUD operations
- External service integration
- Authentication flows
- File uploads/downloads

**E2E Tests:**
- User login/registration
- Checkout/payment flows
- Form submissions
- Multi-page workflows
- Critical business processes

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

This command helps maintain the proper test pyramid balance.

## Examples

### Example 1: Full Test Suite for New Feature

```
/test-suite

Orchestrator executes:
  1. unit-test-developer
     ✓ Added 12 unit tests for new utility functions
     ✓ Coverage: 95% for new code

  2. integration-test-developer
     ✓ Added 5 API integration tests
     ✓ Database operations validated

  3. automation-test-developer
     ✓ Added 2 E2E workflow tests
     ✓ Cross-browser testing passed

Summary:
  Total: 19 tests added
  Coverage: 92% overall
  All tests passing ✓
```

### Example 2: Unit Tests Only

```
/test-suite --unit

Orchestrator executes:
  unit-test-developer only

  ✓ Generated tests for 8 components
  ✓ Coverage: 88%
  ✓ All 24 tests passing

Recommendation:
  Consider adding integration tests for API endpoints
```

### Example 3: Fix Failing Tests

```
/test-suite --fix

Orchestrator executes:
  1. Runs existing tests
  2. Identifies 3 failures
  3. Coordinates debugger + appropriate test agent
  4. Fixes failing tests
  5. Re-runs to verify

Result:
  ✓ 3 tests fixed
  ✓ All tests now passing
```

## Integration with CI/CD

This command can be used in CI pipelines:

```yaml
# GitHub Actions example
- name: Run Test Suite
  run: cc /test-suite --coverage
```

## Best Practices

1. **Run full suite before PRs**: Ensure comprehensive coverage
2. **Use specific layers during development**: Faster feedback
3. **Maintain test pyramid**: More unit, fewer E2E
4. **Review coverage reports**: Identify gaps
5. **Update tests with code changes**: Keep tests in sync

## Error Handling

| Error | Recovery Strategy |
|-------|-------------------|
| Test framework not found | Prompt to install (Jest, Vitest, etc.) |
| Agent unavailable | Skip that layer, warn user |
| Tests fail | Provide failure details, offer --fix option |
| Coverage below threshold | Recommend additional tests |

## Performance Notes

- **Unit tests**: ~30-60 seconds
- **Integration tests**: ~1-3 minutes
- **E2E tests**: ~3-10 minutes
- **Full suite**: ~5-15 minutes (depends on project size)

Use `--unit` during development for faster feedback.

## Output Format

```
🧪 Test Suite Orchestrator
═══════════════════════════

Phase 1: Unit Testing
  ├─ Running unit-test-developer...
  ├─ ✓ 15 tests added
  ├─ ✓ Coverage: 90%
  └─ Duration: 45s

Phase 2: Integration Testing
  ├─ Running integration-test-developer...
  ├─ ✓ 8 API tests added
  ├─ ✓ Database validation passed
  └─ Duration: 2m 15s

Phase 3: E2E Testing
  ├─ Running automation-test-developer...
  ├─ ✓ 3 workflow tests added
  ├─ ✓ Cross-browser: Chrome, Firefox, Safari
  └─ Duration: 5m 30s

═══════════════════════════
Summary
  Total Tests: 26
  Coverage: 88%
  Status: ✓ All Passing
  Duration: 8m 30s

Recommendations:
  • Add integration test for payment API
  • Consider E2E test for admin dashboard
```

## Future Enhancements

- [ ] Parallel test execution
- [ ] Incremental testing (only changed files)
- [ ] Test generation from specs
- [ ] Mutation testing integration
- [ ] Performance regression detection

## See Also

- [Unit Test Developer](../agents/unit-test-developer.md)
- [Integration Test Developer](../agents/integration-test-developer.md)
- [Automation Test Developer](../agents/automation-test-developer.md)
- [Testing Best Practices](../../../docs/ORCHESTRATION-PATTERNS.md#testing-patterns)
