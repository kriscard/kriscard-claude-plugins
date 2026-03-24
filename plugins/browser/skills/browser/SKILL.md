---
name: browser
description: >-
  Automates and inspects live web pages using agent-browser CLI — navigate, screenshot,
  check console errors, analyze network, measure performance, diff pages, and record sessions.
  Use this skill whenever the user wants to debug a webpage, inspect a page, check console errors,
  analyze network traffic, profile page performance, capture screenshots, compare pages, or
  record interactions — even if they just say "check this page" or "why is this page slow."
version: 0.1.0
---

# Browser Skill

## Overview

The browser skill uses the `agent-browser` CLI — a native Rust binary for browser automation — to inspect, debug, and profile web pages. All operations run via the Bash tool calling `agent-browser` commands. No MCP server or Node.js required.

Use this skill when working on frontend applications to inspect live pages, debug JavaScript errors, analyze performance bottlenecks, monitor network requests, capture visual state, compare pages, or record interactions.

## When to Use This Skill

Activate this skill when:

- **Visual inspection needed** — screenshots, page layout verification, responsive testing
- **Console debugging required** — JavaScript errors, warnings, uncaught exceptions
- **Performance analysis requested** — Core Web Vitals, long tasks, resource bottlenecks
- **Network monitoring desired** — API calls, failed requests, slow resources, HAR recording
- **Page comparison needed** — before/after diff, staging vs production comparison
- **Interaction recording** — capturing video of user flows for documentation or bug reports
- **Localhost development** — testing local frontend applications during development

## Core Concepts

### agent-browser CLI

The `agent-browser` binary (at `/opt/homebrew/bin/agent-browser`) controls Chrome via the Chrome DevTools Protocol. It runs a persistent daemon — the browser stays open between commands, enabling multi-step workflows.

All commands are executed via the Bash tool:
```bash
agent-browser <command> [args] [--flags]
```

### Command Chaining

Chain commands with `&&` for multi-step workflows:
```bash
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
```

The browser persists between separate Bash calls too — you can run commands sequentially:
```bash
# Call 1
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
# Call 2
agent-browser screenshot --full page.png
# Call 3
agent-browser errors
```

### Structured Output

All commands support `--json` for structured JSON output:
```bash
agent-browser errors --json
agent-browser network requests --type fetch,xhr --json
agent-browser snapshot --json
```

### Element References

`agent-browser snapshot` returns an accessibility tree with element references like `@e1`, `@e2`. Use these refs in subsequent commands:
```bash
agent-browser snapshot       # Shows @e1: button "Submit", @e2: textbox "Email", etc.
agent-browser click @e1      # Click the Submit button
agent-browser fill @e2 "user@example.com"  # Fill the Email field
```

### Annotated Screenshots

`--annotate` overlays numbered labels on interactive elements — designed for AI:
```bash
agent-browser screenshot --full --annotate page.png
# Shows [1] Submit button, [2] Email field, etc.
```

## Common Workflows

### Page Inspection

Full page inspection (screenshot + DOM + console + network):

```bash
# Navigate and wait for page load
agent-browser open "$URL" && agent-browser wait --load networkidle

# Visual capture
agent-browser screenshot --full inspection.png

# DOM structure
agent-browser snapshot

# Console errors
agent-browser errors

# API calls
agent-browser network requests --type fetch,xhr
```

Use `/browser:inspect <url>` to run this automatically.

### Console Debugging

Investigating JavaScript errors:

```bash
agent-browser open "$URL" && agent-browser wait --load networkidle

# Errors only (uncaught exceptions, console.error)
agent-browser errors

# All messages (log, warn, error, info)
agent-browser console
```

Use `/browser:console <url>` for automated error checking.

### Performance Analysis

Measuring Core Web Vitals:

```bash
agent-browser open "$URL" && agent-browser wait --load networkidle

# Extract metrics via JavaScript eval
cat <<'EOF' | agent-browser eval --stdin
const fcp = performance.getEntriesByType('paint')
  .find(entry => entry.name === 'first-contentful-paint');
fcp ? { fcp_ms: Math.round(fcp.startTime) } : null;
EOF

# Resource analysis
agent-browser network requests --json

# Optional: record a trace for flame chart analysis
agent-browser trace start
agent-browser reload && agent-browser wait --load networkidle
agent-browser trace stop trace.json
```

Use `/browser:performance <url>` for automated Web Vitals extraction with recommendations.

### Screenshot Capture

```bash
agent-browser open "$URL" && agent-browser wait --load networkidle

# Full page
agent-browser screenshot --full page.png

# Annotated (with element labels)
agent-browser screenshot --full --annotate annotated.png

# Save as PDF
agent-browser pdf page.pdf
```

Use `/browser:screenshot <url>` for quick captures.

### Network Monitoring

```bash
agent-browser open "$URL" && agent-browser wait --load networkidle

# API calls only
agent-browser network requests --type fetch,xhr

# Failed requests
agent-browser network requests --status 4xx
agent-browser network requests --status 5xx

# Full request/response detail
agent-browser network request <requestId>

# HAR recording for waterfall analysis
agent-browser network har start
agent-browser reload && agent-browser wait --load networkidle
agent-browser network har stop waterfall.har
```

### Page Comparison

```bash
# Compare two URLs
agent-browser diff url "http://localhost:3000" "https://staging.example.com"

# Snapshot diff (before/after on same page)
agent-browser open "$URL" && agent-browser wait --load networkidle
agent-browser screenshot --full baseline.png
# ... make changes ...
agent-browser reload && agent-browser wait --load networkidle
agent-browser diff screenshot --baseline baseline.png
agent-browser diff snapshot
```

Use `/browser:diff <url1> <url2>` for automated comparison.

### Video Recording

```bash
agent-browser open "$URL" && agent-browser wait --load networkidle
agent-browser record start recording.webm

# Perform interactions...
agent-browser click "#login-button"
agent-browser fill "#email" "user@example.com"
agent-browser wait 1000

agent-browser record stop
```

Use `/browser:record <url>` for guided recording sessions.

### Device Emulation

```bash
# Mobile
agent-browser set device "iPhone 14"
agent-browser open "$URL" && agent-browser wait --load networkidle
agent-browser screenshot --full mobile.png

# Tablet
agent-browser set device "iPad Pro"
agent-browser reload && agent-browser wait --load networkidle
agent-browser screenshot --full tablet.png

# Custom viewport
agent-browser set viewport 1440 900
agent-browser reload && agent-browser wait --load networkidle

# Dark mode
agent-browser set media dark
agent-browser reload && agent-browser wait --load networkidle
```

### Form Interaction

```bash
# Get form structure
agent-browser snapshot -i  # Interactive elements only

# Fill using CSS selectors
agent-browser fill "#email" "user@example.com"
agent-browser fill "#password" "secret123"
agent-browser click "#submit"

# Or use semantic locators
agent-browser find label "Email" fill "user@example.com"
agent-browser find role button click --name "Submit"

# Wait for navigation after submit
agent-browser wait --url "/dashboard"
```

## Commands

| Command | Purpose |
|---------|---------|
| `/browser:inspect <url>` | Full page inspection (screenshot + DOM + console + network) |
| `/browser:screenshot <url>` | Quick screenshot capture |
| `/browser:console <url>` | Console error checking |
| `/browser:performance <url>` | Core Web Vitals analysis with recommendations |
| `/browser:diff <url1> <url2>` | Visual and structural page comparison |
| `/browser:record <url>` | Video recording of browser interactions |

## Tips and Best Practices

### Smart Waiting

Prefer event-based waiting over arbitrary delays:

```bash
# Best: wait for network idle
agent-browser wait --load networkidle

# Good: wait for specific content
agent-browser wait --text "Dashboard loaded"

# Good: wait for URL change
agent-browser wait --url "/dashboard"

# Good: wait for element
agent-browser wait "#main-content"

# Fallback: fixed delay (for WebSocket-heavy pages where networkidle hangs)
agent-browser wait 3000
```

### JavaScript Evaluation

For simple expressions, use inline:
```bash
agent-browser eval "document.title"
```

For multi-line scripts, use heredoc with `--stdin`:
```bash
cat <<'EOF' | agent-browser eval --stdin
const links = document.querySelectorAll('a');
Array.from(links).map(l => ({ href: l.href, text: l.textContent.trim() }));
EOF
```

Note: single quotes around `'EOF'` prevent shell variable expansion inside the JS.

### Network Filtering

```bash
# API calls only (most common)
agent-browser network requests --type fetch,xhr

# Filter by URL pattern
agent-browser network requests --filter "api"

# Filter by HTTP method
agent-browser network requests --method POST

# Filter by status
agent-browser network requests --status 4xx
```

### Session Management

Use `--session` for isolated browser contexts:
```bash
agent-browser open "http://localhost:3000" --session testing
agent-browser screenshot --full test.png --session testing
```

### Resetting State

If the browser gets stuck or you need a fresh state:
```bash
agent-browser close
```

This kills the daemon. The next command will start a fresh browser.

## Troubleshooting

**Browser won't start:**
- Ensure Chrome is installed
- Try `agent-browser close` then retry
- Check: `which agent-browser` should show `/opt/homebrew/bin/agent-browser`

**`wait --load networkidle` hangs:**
- Page may have persistent connections (WebSocket, SSE, long-polling)
- Use `agent-browser wait 5000` as fallback
- Or `agent-browser wait --load domcontentloaded` for faster but less complete wait

**Commands timeout:**
- Verify target URL is accessible: `curl <url>`
- Check if localhost server is running
- Try URL in regular browser first

**Screenshots blank or incomplete:**
- Page may need more time to render — increase wait
- Check console errors: `agent-browser errors`
- Try `wait --load networkidle` instead of fixed delay

**Console/errors empty:**
- Errors may have occurred before connection — use `agent-browser open` first, then navigate
- Some errors only appear on interaction
- Try `agent-browser console` for all message levels, not just `errors`

**Network requests missing:**
- Requests that completed before `open` won't be captured
- Use HAR recording for comprehensive capture: `agent-browser network har start` before navigation

## Additional Resources

### Example Files

Working examples in `examples/`:
- **`cli-reference.md`** — Complete agent-browser command reference
- **`inspection-workflow.md`** — Detailed inspection workflow patterns
- **`performance-analysis.md`** — Performance analysis techniques

### Related Commands

- `/browser:inspect` — Full page inspection
- `/browser:screenshot` — Screenshot capture
- `/browser:console` — Console debugging
- `/browser:performance` — Performance analysis
- `/browser:diff` — Page comparison
- `/browser:record` — Video recording

### agent-browser Resources

- [agent-browser GitHub](https://github.com/vercel-labs/agent-browser)
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)
- [Web Performance Metrics](https://web.dev/metrics/)
