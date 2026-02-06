---
name: Chrome DevTools
description: "Browser: Use when inspecting pages, checking console errors, analyzing network requests, or running performance traces. NOT for writing frontend code."
version: 0.1.0
---

# Chrome DevTools Skill

## Overview

The Chrome DevTools skill integrates the official Chrome DevTools Protocol (CDP) MCP server to enable comprehensive browser inspection, debugging, and performance analysis during frontend development. This skill provides access to 26 Chrome DevTools tools across navigation, automation, performance profiling, network monitoring, console debugging, and visual inspection.

Use this skill when working on frontend applications to inspect live pages, debug JavaScript errors, analyze performance bottlenecks, monitor network requests, or capture visual state.

## When to Use This Skill

Activate this skill when:

- **Visual inspection needed** - Checking page layout, taking screenshots, verifying UI rendering
- **Console debugging required** - Investigating JavaScript errors, warnings, or log messages
- **Performance analysis requested** - Identifying slow page loads, long tasks, or resource bottlenecks
- **Network monitoring desired** - Inspecting HTTP requests, API calls, or loading issues
- **Localhost development** - Testing local frontend applications during development

Typical scenarios include debugging a React app, optimizing page load speed, verifying API integration, checking responsive design, or validating frontend changes.

## Core Concepts

### Chrome DevTools MCP Server

The chrome-devtools-mcp server provides programmatic access to Chrome DevTools features through the Model Context Protocol. It launches Chrome in headless mode (no UI) and exposes 26 tools organized into 6 categories:

**1. Navigation Tools (6 tools)**
- Create, select, and close browser tabs
- Navigate to URLs and wait for page load
- Manage multiple pages within a session

**2. Input Automation Tools (8 tools)**
- Click elements and press keys
- Fill form fields and handle dialogs
- Drag elements and upload files
- Hover over elements

**3. Performance Tools (3 tools)**
- Record performance traces
- Analyze traces for metrics (LCP, FCP, TTI, TBT)
- Identify performance bottlenecks

**4. Network Tools (2 tools)**
- Inspect HTTP requests and responses
- Monitor network activity and timings

**5. Debugging Tools (5 tools)**
- Capture screenshots (viewport or full page)
- Get accessibility snapshots
- Monitor console messages
- Evaluate JavaScript in page context

**6. Emulation Tools (2 tools)**
- Emulate mobile devices
- Resize viewport dimensions

### MCP Tool Naming Convention

All Chrome DevTools MCP tools use the prefix `mcp__plugin_chromedev-tools_cdt__browser_` followed by the action:

- `mcp__plugin_chromedev-tools_cdt__navigate_page` - Navigate to URL
- `mcp__plugin_chromedev-tools_cdt__take_screenshot` - Capture screenshot
- `mcp__plugin_chromedev-tools_cdt__list_console_messages` - Get console logs
- `mcp__plugin_chromedev-tools_cdt__take_snapshot` - Get accessibility snapshot
- `mcp__plugin_chromedev-tools_cdt__list_network_requests` - Get network requests
- `mcp__plugin_chromedev-tools_cdt__evaluate_script` - Run JavaScript

See `examples/mcp-tools-reference.md` for the complete list of 26 tools.

## Common Workflows

### Page Inspection Workflow

For comprehensive page inspection (screenshot + DOM + console + network):

1. Navigate to the target URL
2. Wait for page load completion
3. Capture screenshot (full page recommended)
4. Get accessibility snapshot for DOM structure
5. Check console messages for errors/warnings
6. Inspect network requests

Example sequence:
```
1. mcp__plugin_chromedev-tools_cdt__navigate_page(url)
2. mcp__plugin_chromedev-tools_cdt__wait_for(time: 2)
3. mcp__plugin_chromedev-tools_cdt__take_screenshot(fullPage: true)
4. mcp__plugin_chromedev-tools_cdt__take_snapshot()
5. mcp__plugin_chromedev-tools_cdt__list_console_messages(level: "warning")
6. mcp__plugin_chromedev-tools_cdt__list_network_requests(includeStatic: false)
```

For quick access, use the `/chromedev:inspect <url>` command which automates this entire workflow.

### Console Debugging Workflow

For investigating JavaScript errors:

1. Navigate to the page
2. Wait for initialization
3. Get console messages (errors and warnings)
4. Analyze error stack traces and messages

Filter console messages by level:
- `error` - Only console.error() and uncaught exceptions
- `warning` - Errors + console.warn()
- `info` - Warnings + console.info() and console.log()
- `debug` - Everything including verbose debug messages

For focused error checking, use `/chromedev:console <url>` which filters to errors and warnings only.

### Performance Analysis Workflow

For identifying performance bottlenecks:

1. Navigate to the page
2. Start performance trace recording
3. Perform user interactions (if testing interactive performance)
4. Stop trace recording
5. Analyze trace for Core Web Vitals
6. Identify long tasks and layout shifts

Key metrics to extract:
- **LCP (Largest Contentful Paint)** - Main content load time
- **FCP (First Contentful Paint)** - Initial render time
- **TTI (Time to Interactive)** - When page becomes interactive
- **TBT (Total Blocking Time)** - Main thread blocking

Use `/chromedev:performance <url>` for automated trace recording and analysis with optimization recommendations.

### Screenshot Capture Workflow

For visual inspection:

1. Navigate to the target URL
2. Wait for page rendering
3. Optionally resize viewport for specific dimensions
4. Capture screenshot (full page or viewport)

Screenshot options:
- **Full page** - Captures entire scrollable content (recommended for comprehensive review)
- **Viewport only** - Captures visible area only (faster, smaller file size)

For quick screenshots, use `/chromedev:screenshot <url>` which automatically captures full-page screenshots.

### Network Monitoring Workflow

For debugging API calls and resource loading:

1. Navigate to the page
2. Allow network requests to complete
3. Get network requests list
4. Filter out static resources if focusing on API calls
5. Inspect request/response details, status codes, timings

Network inspection is useful for:
- Verifying API endpoint responses
- Checking request headers and payloads
- Identifying slow resource loads
- Debugging CORS or authentication issues

## Working with MCP Tools

### Navigation Example

Navigate to a localhost development server:

```
Use: mcp__plugin_chromedev-tools_cdt__navigate_page
Parameters:
  url: "http://localhost:3000"
```

Wait for page load after navigation:

```
Use: mcp__plugin_chromedev-tools_cdt__wait_for
Parameters:
  time: 2  # seconds
```

### Screenshot Example

Capture full-page screenshot:

```
Use: mcp__plugin_chromedev-tools_cdt__take_screenshot
Parameters:
  fullPage: true
  filename: "screenshot.png"
```

The screenshot saves to the current working directory.

### Console Messages Example

Get console errors and warnings:

```
Use: mcp__plugin_chromedev-tools_cdt__list_console_messages
Parameters:
  level: "warning"  # Returns errors + warnings
```

Returns array of console messages with:
- Type (error, warning, info, debug)
- Message text
- Timestamp
- Source location (file:line:column)

### Accessibility Snapshot Example

Get DOM structure for inspection:

```
Use: mcp__plugin_chromedev-tools_cdt__take_snapshot
```

Returns accessibility tree showing:
- Element roles and labels
- Page structure and hierarchy
- Interactive element states
- Text content

### Network Requests Example

Inspect HTTP requests (excluding static resources):

```
Use: mcp__plugin_chromedev-tools_cdt__list_network_requests
Parameters:
  includeStatic: false  # Filter out images, fonts, scripts
```

Returns array of requests with:
- URL and method
- Status code
- Request/response headers
- Timing information
- Size

### JavaScript Evaluation Example

Execute JavaScript in page context:

```
Use: mcp__plugin_chromedev-tools_cdt__evaluate_script
Parameters:
  function: "() => document.title"
```

Returns the result of executing the JavaScript. Useful for:
- Extracting page data
- Testing JavaScript functionality
- Querying DOM state

## Commands for Common Tasks

The plugin provides four commands that automate common DevTools workflows:

### `/chromedev:inspect <url>`

Comprehensive page inspection - runs the full inspection workflow automatically:
- Navigates to URL
- Captures screenshot
- Gets DOM snapshot
- Checks console logs
- Analyzes network requests

Use when you need complete visibility into page state.

### `/chromedev:screenshot <url>`

Quick screenshot capture:
- Navigates to URL
- Waits for rendering
- Captures full-page screenshot

Use when you only need visual verification.

### `/chromedev:performance <url>`

Performance analysis:
- Navigates to URL
- Records performance trace
- Extracts Core Web Vitals (LCP, FCP, TTI, TBT)
- Identifies long tasks and bottlenecks
- Provides optimization recommendations

Use when investigating slow page loads or runtime performance.

### `/chromedev:console <url>`

Console error checking:
- Navigates to URL
- Waits for JavaScript execution
- Gets console errors and warnings

Use when debugging JavaScript issues.

## Tips and Best Practices

### URL Format

Always provide fully-qualified URLs including protocol:

✅ **Correct:**
- `http://localhost:3000`
- `https://example.com/dashboard`
- `http://127.0.0.1:8080/app`

❌ **Incorrect:**
- `localhost:3000` - Missing protocol
- `example.com` - Will be treated as relative path
- `/dashboard` - Relative path, not full URL

### Wait Times

Allow sufficient time for page rendering and JavaScript execution:

- Simple static pages: 1-2 seconds
- React/Vue/Angular apps: 2-3 seconds
- Heavy JavaScript apps: 3-5 seconds
- Complex data loading: 5-10 seconds

Use `mcp__plugin_chromedev-tools_cdt__wait_for` after navigation for dynamic content.

### Console Message Filtering

Choose appropriate filter level based on needs:

- **Debugging JavaScript errors** → level: "error"
- **General debugging** → level: "warning" (errors + warnings)
- **Comprehensive logging** → level: "info" (includes console.log)
- **Verbose debugging** → level: "debug" (everything)

### Network Request Filtering

Filter static resources when focusing on API calls:

```
includeStatic: false  # Excludes images, fonts, CSS, JS files
```

Leave as `true` when debugging resource loading issues.

### Screenshot Scope

Use full-page screenshots for comprehensive review:

```
fullPage: true  # Captures entire scrollable page
```

Use viewport screenshots for quick visual checks or when page is very long.

### Performance Tracing

Record traces long enough to capture key events:

- Initial page load: 5-10 seconds
- User interaction flows: 10-20 seconds
- Complex workflows: 20-30 seconds

Longer traces capture more data but increase analysis time.

## Troubleshooting

**Chrome not found:**
- Ensure Chrome installed and in PATH
- Install Chromium: `npx -y @puppeteer/browsers install chrome@stable`
- Verify: `which google-chrome` or `which chromium`

**MCP server won't start:**
- Check Node.js version: `node --version` (requires v20.19+)
- Try manual install: `npm install -g chrome-devtools-mcp@latest`
- Check for port conflicts

**Commands timeout:**
- Verify target URL is accessible: `curl <url>`
- Increase wait time for slow pages
- Check if localhost server is running
- Try URL in regular browser first

**Screenshots not saving:**
- Check write permissions in current directory
- Verify filename doesn't contain invalid characters
- Check disk space

**Console messages empty:**
- Wait longer for JavaScript execution
- Check if page actually logs to console
- Try opening page in regular browser to verify messages

**Network requests missing:**
- Ensure page makes network requests
- Try `includeStatic: true` to see all requests
- Check if requests happen after page load (may need longer wait)

## Additional Resources

### Example Files

Working examples in `examples/`:
- **`mcp-tools-reference.md`** - Complete list of all 26 MCP tools
- **`inspection-workflow.md`** - Detailed inspection workflow patterns
- **`performance-analysis.md`** - Performance analysis techniques

### Related Commands

Quick-access commands for common operations:
- `/chromedev:inspect` - Full page inspection
- `/chromedev:screenshot` - Screenshot capture
- `/chromedev:performance` - Performance analysis
- `/chromedev:console` - Console debugging

### Chrome DevTools Resources

Official documentation:
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)
- [chrome-devtools-mcp GitHub](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- [Performance metrics](https://web.dev/metrics/)

## Implementation Notes

The Chrome DevTools MCP server runs in headless mode by default (no browser UI). This provides:
- Faster execution (no rendering overhead)
- Lower resource usage (no GPU acceleration)
- Better for CI/CD and automated workflows

Screenshots and traces are fully functional in headless mode. The server automatically manages Chrome instances and cleans up on exit.

All MCP tools are available immediately when the skill activates. No additional setup or configuration required beyond the plugin installation.
