# Testing Plugin

Unit, integration, and E2E testing specialists with comprehensive test suite orchestration.

## Orchestration

### /test-suite (Command)

**NEW!** Run comprehensive testing workflow that coordinates all three test specialist agents for full coverage.

**Usage:**
```bash
# Full test suite (all layers)
/test-suite

# Specific test layers
/test-suite --unit
/test-suite --integration
/test-suite --e2e

# Multiple layers
/test-suite --unit --integration
```

**What it does:**
1. **Unit Tests** - Component and function testing (80%+ coverage)
2. **Integration Tests** - API endpoints, database operations, service boundaries
3. **E2E Tests** - Critical user workflows, cross-browser validation

**Example output:**
```
🧪 Test Suite Orchestrator
═══════════════════════════

Phase 1: Unit Testing
  ✓ 15 tests added, 90% coverage

Phase 2: Integration Testing
  ✓ 8 API tests added

Phase 3: E2E Testing
  ✓ 3 workflow tests added

Summary: 26 total tests, 88% coverage, all passing ✓
```

**Benefits:**
- Maintains proper test pyramid (many unit, some integration, few E2E)
- Coordinates all three test specialists automatically
- Provides unified coverage reports
- Faster than running layers manually

## Agents

### unit-test-developer
Expert unit test generation and TDD specialist.

**Specialties:**
- Component-level testing
- Test-driven development workflows
- Comprehensive coverage strategies
- Function and class testing

### integration-test-developer
Expert integration and API testing specialist.

**Specialties:**
- Service boundary testing
- Data layer validation
- API endpoint testing
- Database integration
- Contract testing

### automation-test-developer
Expert E2E and automation testing specialist.

**Specialties:**
- User workflow testing
- Performance testing
- Cross-platform validation
- CI/CD integration
- Playwright/Selenium automation
- Visual regression testing

## Usage

These agents are automatically available when you install the plugin. Use them when:

- Writing unit tests for functions and components
- Testing API endpoints and service integrations
- Setting up E2E test automation
- Implementing TDD practices
- Building CI/CD test pipelines
- Cross-browser testing automation
