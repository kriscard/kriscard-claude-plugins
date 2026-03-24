# agent-browser CLI Reference

Complete reference for the `agent-browser` CLI used by the browser plugin. All commands support `--json` for structured output and `--session <name>` for session isolation.

## Navigation

```bash
# Open a URL
agent-browser open "http://localhost:3000"

# Wait for page load (preferred over arbitrary delays)
agent-browser wait --load networkidle

# Wait for specific text to appear
agent-browser wait --text "Welcome"

# Wait for URL pattern
agent-browser wait --url "/dashboard"

# Wait for element visibility
agent-browser wait "#main-content"

# Wait fixed duration (ms) — fallback for WebSocket-heavy pages
agent-browser wait 3000

# Back, forward, reload
agent-browser back
agent-browser forward
agent-browser reload
```

## Screenshots & Snapshots

```bash
# Full-page screenshot
agent-browser screenshot --full screenshot.png

# Viewport-only screenshot
agent-browser screenshot viewport.png

# Annotated screenshot (numbered element labels for AI)
agent-browser screenshot --full --annotate annotated.png

# JPEG with quality setting
agent-browser screenshot --screenshot-format jpeg --screenshot-quality 80 photo.jpg

# Element screenshot
agent-browser screenshot "#hero-section" hero.png

# Accessibility tree snapshot (DOM structure)
agent-browser snapshot

# Interactive elements only
agent-browser snapshot -i

# Compact snapshot with depth limit
agent-browser snapshot --compact --depth 5

# Scoped to specific container
agent-browser snapshot -s "#main-content"

# Save as PDF
agent-browser pdf page.pdf
```

## Console & Errors

```bash
# View all console messages (log, warn, error, info)
agent-browser console

# View only errors and uncaught exceptions
agent-browser errors

# Clear console buffer
agent-browser console --clear

# JSON output for structured parsing
agent-browser errors --json
```

## Network

```bash
# List all captured requests
agent-browser network requests

# Filter to API calls only
agent-browser network requests --type fetch,xhr

# Filter by URL pattern
agent-browser network requests --filter "api"

# Filter by HTTP method
agent-browser network requests --method POST

# Filter by status code range
agent-browser network requests --status 4xx

# View full request/response detail
agent-browser network request <requestId>

# Start/stop HAR recording
agent-browser network har start
agent-browser network har stop capture.har

# Mock/intercept requests
agent-browser network route "**/api/users" --body '{"users": []}'

# Block requests
agent-browser network route "**/analytics/*" --abort

# Remove routes
agent-browser network unroute
```

## Interaction

```bash
# Click element (CSS selector or @ref from snapshot)
agent-browser click "#submit-button"
agent-browser click @e5

# Double-click
agent-browser dblclick "#editable-cell"

# Fill input (clears first)
agent-browser fill "#email" "user@example.com"

# Type into element (appends)
agent-browser type "#search" "query text"

# Type with real keystrokes (no selector, types into focused element)
agent-browser keyboard type "Hello world"

# Press key
agent-browser press Enter
agent-browser press "Control+a"
agent-browser press Tab

# Hover
agent-browser hover "#menu-item"

# Select dropdown option
agent-browser select "#country" "Canada"

# Check/uncheck checkbox
agent-browser check "#agree-terms"
agent-browser uncheck "#newsletter"

# Drag and drop
agent-browser drag "#item-1" "#drop-zone"

# Upload file
agent-browser upload "#file-input" ./document.pdf

# Scroll
agent-browser scroll down 500
agent-browser scroll up 200

# Scroll element into view
agent-browser scrollintoview "#footer"
```

## Semantic Finding (ARIA-based)

```bash
# Find by ARIA role and click
agent-browser find role button click --name "Submit"

# Find by text and click
agent-browser find text "Sign In" click

# Find by label and fill
agent-browser find label "Email" fill "user@example.com"

# Find by placeholder and fill
agent-browser find placeholder "Search..." fill "query"

# Find by alt text and click
agent-browser find alt "Profile picture" click

# Find by test ID and click
agent-browser find testid "submit-btn" click

# Find nth match
agent-browser find nth 2 "li.item" click
```

## JavaScript Evaluation

```bash
# Simple eval
agent-browser eval "document.title"

# Multi-line via heredoc (preferred for complex JS)
cat <<'EOF' | agent-browser eval --stdin
const links = document.querySelectorAll('a');
Array.from(links).map(l => l.href);
EOF

# Base64 encoded (alternative to avoid shell escaping)
agent-browser eval -b "ZG9jdW1lbnQudGl0bGU="
```

## Get Information

```bash
# Get element text
agent-browser get text "#heading"

# Get innerHTML
agent-browser get html "#container"

# Get input value
agent-browser get value "#email-input"

# Get attribute
agent-browser get attr "#link" href

# Get page title
agent-browser get title

# Get current URL
agent-browser get url

# Count matching elements
agent-browser get count ".list-item"

# Get element bounding box
agent-browser get box "#hero"

# Get computed styles
agent-browser get styles "#element"
```

## Check State

```bash
agent-browser is visible "#modal"
agent-browser is enabled "#submit"
agent-browser is checked "#checkbox"
```

## Emulation & Settings

```bash
# Set viewport
agent-browser set viewport 1280 720

# Emulate device
agent-browser set device "iPhone 14"

# Dark/light mode
agent-browser set media dark
agent-browser set media light

# Geolocation
agent-browser set geo 40.7128 -74.0060

# Offline mode
agent-browser set offline on
agent-browser set offline off

# Set HTTP headers
agent-browser set headers '{"X-Custom": "value"}'

# Set HTTP basic auth credentials
agent-browser set credentials admin password123
```

## Performance & Tracing

```bash
# Record Chrome DevTools trace
agent-browser trace start
# ... interact with page ...
agent-browser trace stop trace.json

# Record Chrome DevTools profile
agent-browser profiler start
# ... interact with page ...
agent-browser profiler stop profile.json
```

## Diff & Comparison

```bash
# Compare two URLs
agent-browser diff url "http://localhost:3000" "http://localhost:3001"

# Compare current snapshot vs last saved
agent-browser diff snapshot

# Compare current screenshot vs baseline
agent-browser diff screenshot --baseline baseline.png
```

## Video Recording

```bash
# Start recording
agent-browser record start recording.webm

# Stop recording
agent-browser record stop
```

## Tabs

```bash
# List open tabs
agent-browser tab list

# Open new tab
agent-browser tab new

# Switch to tab by index
agent-browser tab 2

# Close current tab
agent-browser tab close
```

## Cookies & Storage

```bash
# List all cookies
agent-browser cookies

# Set cookie
agent-browser cookies set session_id abc123

# Clear cookies
agent-browser cookies clear

# Get localStorage
agent-browser storage local

# Get specific key
agent-browser storage local authToken

# Set localStorage value
agent-browser storage local set theme dark

# Clear localStorage
agent-browser storage local clear

# SessionStorage (same API)
agent-browser storage session
```

## Debugging Helpers

```bash
# Highlight element on page
agent-browser highlight "#target-element"

# Close browser
agent-browser close

# Connect to existing browser
agent-browser connect 9222
```

## Common Patterns

### Navigate and wait (standard pattern)
```bash
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
```

### Full inspection sequence
```bash
agent-browser open "$URL" && agent-browser wait --load networkidle
agent-browser screenshot --full inspection.png
agent-browser snapshot
agent-browser errors
agent-browser network requests --type fetch,xhr
```

### Form fill and submit
```bash
agent-browser fill "#username" "admin"
agent-browser fill "#password" "secret"
agent-browser click "#login-button"
agent-browser wait --url "/dashboard"
```

### Mobile testing
```bash
agent-browser set device "iPhone 14"
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser screenshot --full mobile.png
```
