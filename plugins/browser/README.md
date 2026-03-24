# Browser Plugin

Browser automation and inspection for frontend development using the `agent-browser` CLI.

## Features

- **Page Inspection** — Screenshot, DOM snapshot, console errors, network analysis
- **Console Debugging** — JavaScript errors, warnings, uncaught exceptions
- **Performance Analysis** — Core Web Vitals (FCP, LCP, TTI, TBT, CLS), resource analysis
- **Network Monitoring** — API calls, request filtering, HAR recording, request mocking
- **Page Comparison** — Visual and structural diff between URLs or before/after changes
- **Video Recording** — Record browser interactions as WebM video
- **Device Emulation** — Mobile, tablet, custom viewports, dark mode
- **Form Automation** — Fill forms, click buttons, semantic element finding

## Prerequisites

- **agent-browser CLI** — Install via Homebrew: `brew install vercel-labs/tap/agent-browser`
- **Chrome** — Required for browser automation (Chrome, Chromium, or Chrome for Testing)

## Commands

| Command | Description |
|---------|-------------|
| `/browser:inspect <url>` | Full page inspection (screenshot + DOM + console + network) |
| `/browser:screenshot <url>` | Quick full-page screenshot |
| `/browser:console <url>` | Check console errors and warnings |
| `/browser:performance <url>` | Core Web Vitals analysis with optimization recommendations |
| `/browser:diff <url1> <url2>` | Compare two pages visually and structurally |
| `/browser:record <url>` | Record video of browser interactions |

## Skill Activation

The browser skill activates automatically when you mention:
- "Inspect the page", "check this page"
- "Check console errors", "debug JavaScript"
- "Analyze performance", "why is this page slow"
- "Take a screenshot", "capture the page"
- "Compare pages", "diff these URLs"
- "Record the interaction"

## How It Works

All operations use the `agent-browser` CLI via shell commands — no MCP server or Node.js required. The CLI controls Chrome via the Chrome DevTools Protocol through a native Rust binary for fast startup and low overhead.

## Examples

```bash
# Quick inspection
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser screenshot --full page.png
agent-browser errors

# Performance check
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
cat <<'EOF' | agent-browser eval --stdin
const fcp = performance.getEntriesByType('paint')
  .find(e => e.name === 'first-contentful-paint');
fcp ? Math.round(fcp.startTime) + 'ms' : null;
EOF

# Compare two pages
agent-browser diff url "http://localhost:3000" "https://staging.example.com"
```

## Troubleshooting

- **Browser won't start** — `agent-browser close` to reset, then retry
- **`wait --load networkidle` hangs** — Use `agent-browser wait 5000` for WebSocket-heavy pages
- **Commands timeout** — Verify URL is accessible with `curl <url>`
