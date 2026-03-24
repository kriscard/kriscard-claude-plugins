Check console errors and warnings for $ARGUMENTS using agent-browser CLI:

## Workflow

1. Navigate to page and wait for load:
   ```bash
   agent-browser open "$ARGUMENTS" && agent-browser wait --load networkidle
   ```

2. Get page errors (uncaught exceptions, console.error):
   ```bash
   agent-browser errors
   ```

3. Get all console messages for full context:
   ```bash
   agent-browser console
   ```

## Output Format

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

If user did not provide a URL, prompt them with: "Please provide a URL to check. Usage: /browser:console <url>"
