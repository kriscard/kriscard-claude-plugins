Perform comprehensive page inspection of $ARGUMENTS using agent-browser CLI:

## Step 1: Navigate to Page

Navigate and wait for full page load:
```bash
agent-browser open "$ARGUMENTS" && agent-browser wait --load networkidle
```

## Step 2: Capture Visual State

Take full-page screenshot:
```bash
agent-browser screenshot --full page-inspection.png
```

Report screenshot location to user.

## Step 3: Get DOM Structure

Capture accessibility snapshot:
```bash
agent-browser snapshot
```

Analyze page structure, semantic HTML, and interactive elements.

## Step 4: Check Console Messages

Get page errors and console output:
```bash
agent-browser errors
```

```bash
agent-browser console
```

Report any critical errors or warnings found. If no errors, confirm console is clean.

## Step 5: Analyze Network Activity

Inspect API calls and dynamic requests (excluding static resources):
```bash
agent-browser network requests --type fetch,xhr
```

Focus on API calls. Report any failed requests (4xx, 5xx) and slow requests (> 1000ms).

## Output Format

Provide a summary report with:

**Page:** $ARGUMENTS
**Screenshot:** [file location]

**Console Status:**
- Error count: [number]
- Warning count: [number]
- Critical issues: [list errors with details]

**Network Status:**
- Total API requests: [number]
- Failed requests: [number with status codes]
- Slow requests: [number > 1000ms]
- API calls: [list key endpoints]

**DOM Analysis:**
- Page structure: [heading hierarchy, landmarks]
- Interactive elements: [buttons, forms, links count]
- Accessibility: [notable roles, labels]

**Recommendations:**
- [List any issues found]
- [Suggest fixes for errors, warnings, or performance problems]

If user did not provide a URL, prompt them with: "Please provide a URL to inspect. Usage: /browser:inspect <url>"
