---
description: Comprehensive page inspection (screenshot + DOM + console + network)
argument-hint: <url>
allowed-tools: mcp__plugin_chromedev-tools_cdt__navigate_page, mcp__plugin_chromedev-tools_cdt__wait_for, mcp__plugin_chromedev-tools_cdt__take_screenshot, mcp__plugin_chromedev-tools_cdt__take_snapshot, mcp__plugin_chromedev-tools_cdt__list_console_messages, mcp__plugin_chromedev-tools_cdt__list_network_requests
model: sonnet
---

Perform comprehensive page inspection of $ARGUMENTS following this workflow:

## Step 1: Navigate to Page

Navigate to $ARGUMENTS and wait for page load:
1. Use `mcp__plugin_chromedev-tools_cdt__navigate_page` with url: "$ARGUMENTS"
2. Use `mcp__plugin_chromedev-tools_cdt__wait_for` with time: 3 (allows JavaScript execution and API calls)

## Step 2: Capture Visual State

Take full-page screenshot:
- Use `mcp__plugin_chromedev-tools_cdt__take_screenshot` with fullPage: true and filename: "page-inspection.png"
- Report screenshot location to user

## Step 3: Get DOM Structure

Capture accessibility snapshot:
- Use `mcp__plugin_chromedev-tools_cdt__take_snapshot`
- Analyze page structure, semantic HTML, and interactive elements

## Step 4: Check Console Messages

Get console errors and warnings:
- Use `mcp__plugin_chromedev-tools_cdt__list_console_messages` with level: "warning" (includes errors + warnings)
- Report any critical errors or warnings found
- If no errors, confirm console is clean

## Step 5: Analyze Network Activity

Inspect HTTP requests (excluding static resources):
- Use `mcp__plugin_chromedev-tools_cdt__list_network_requests` with includeStatic: false
- Focus on API calls and dynamic requests
- Report any failed requests (4xx, 5xx status codes)
- Note slow requests (> 1000ms)

## Output Format

Provide a summary report with:

**Page:** $ARGUMENTS
**Screenshot:** [file location]

**Console Status:**
- Error count: [number]
- Warning count: [number]
- Critical issues: [list errors with details]

**Network Status:**
- Total requests: [number]
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

If user did not provide a URL, prompt them with: "Please provide a URL to inspect. Usage: /chromedev:inspect <url>"
