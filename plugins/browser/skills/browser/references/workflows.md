# Browser Workflows

Common multi-step workflows using `agent-browser`.

## Page Inspection

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

## Console Debugging

Investigating JavaScript errors:

```bash
agent-browser open "$URL" && agent-browser wait --load networkidle

# Errors only (uncaught exceptions, console.error)
agent-browser errors

# All messages (log, warn, error, info)
agent-browser console
```

Use `/browser:console <url>` for automated error checking.

## Performance Analysis

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

## Screenshot Capture

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

## Network Monitoring

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

## Page Comparison

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

## Video Recording

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

## Device Emulation

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

## Form Interaction

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
