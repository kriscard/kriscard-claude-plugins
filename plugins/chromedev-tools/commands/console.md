---
description: Check console errors and warnings
argument-hint: <url>
allowed-tools: mcp__chrome-devtools__navigate_page, mcp__chrome-devtools__wait_for, mcp__chrome-devtools__list_console_messages
model: haiku
---

Check console errors and warnings for $ARGUMENTS:

## Workflow

1. Navigate to page:
   - Use `mcp__chrome-devtools__navigate_page` with url: "$ARGUMENTS"

2. Wait for JavaScript execution:
   - Use `mcp__chrome-devtools__wait_for` with time: 3 (allows time for JavaScript to run and log messages)

3. Get console messages:
   - Use `mcp__chrome-devtools__list_console_messages` with level: "warning" (includes both errors and warnings)

## Output Format

Report console status:

**Console Messages for:** $ARGUMENTS

**Summary:**
- Errors: [count]
- Warnings: [count]
- Overall Status: [Clean | Issues Found]

**Errors (console.error, exceptions):**
[For each error, list:]
- Message: [error text]
- Source: [file:line:column if available]
- Type: [error type]

**Warnings (console.warn):**
[For each warning, list:]
- Message: [warning text]
- Source: [file:line:column if available]

**Analysis:**
[If errors found:]
- Critical issues that need immediate attention
- Likely causes based on error messages
- Suggested fixes

[If warnings found:]
- Important issues to address
- Impact on functionality
- Recommended actions

[If console is clean:]
- No errors or warnings detected
- Console is clean

**Common Issue Patterns:**

If React warnings found:
- State update issues
- Prop validation failures
- Deprecated API usage

If network errors found:
- Failed API calls
- CORS issues
- Missing resources

If reference errors found:
- Undefined variables or functions
- Missing dependencies
- Incorrect imports

If user did not provide a URL, prompt them with: "Please provide a URL to check. Usage: /chromedev:console <url>"
