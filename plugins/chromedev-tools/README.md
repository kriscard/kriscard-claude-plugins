# Chrome DevTools Plugin

Chrome DevTools integration for Claude Code - inspect pages, debug console, analyze performance, and monitor network activity during frontend development.

## Features

- 🔍 **Page Inspection** - Screenshot, DOM snapshot, console logs, network requests
- 📸 **Screenshots** - Capture full-page visual state
- ⚡ **Performance Analysis** - Record traces, extract metrics (LCP, FCP, TTI, TBT), identify bottlenecks
- 🐛 **Console Debugging** - Monitor errors and warnings
- 🌐 **Network Monitoring** - Inspect HTTP requests and responses

## Prerequisites

- Node.js v20.19 or newer LTS version
- Current stable Chrome or newer
- npm package manager

## Installation

1. Install the plugin:
   ```bash
   cd ~/.claude/plugins
   git clone <repo-url> chromedev-tools
   ```

2. Enable in Claude Code:
   ```bash
   claude --plugin chromedev-tools
   ```

3. The Chrome DevTools MCP server will install automatically on first use via npx.

## Usage

### Skill-based (Implicit Triggering)

The `chrome-devtools` skill activates when you mention browser inspection:

- "Inspect the page at localhost:3000"
- "Check console errors on the homepage"
- "Analyze performance of the app"
- "Take a screenshot of the dashboard"

### Commands (Explicit Control)

#### `/chromedev:inspect <url>`

Comprehensive page inspection - screenshot, DOM snapshot, console logs, and network requests.

```bash
/chromedev:inspect https://localhost:3000
```

#### `/chromedev:screenshot <url>`

Capture full-page screenshot.

```bash
/chromedev:screenshot https://example.com
```

#### `/chromedev:performance <url>`

Record performance trace and analyze metrics (LCP, FCP, TTI, TBT). Identifies bottlenecks and provides optimization recommendations.

```bash
/chromedev:performance https://localhost:3000/dashboard
```

#### `/chromedev:console <url>`

Check console errors and warnings.

```bash
/chromedev:console https://localhost:3000
```

## MCP Tools

The plugin integrates with the official [chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) server, providing 26 tools across:

- **Navigation** (6 tools) - Page creation, selection, closure, navigation, waiting
- **Input Automation** (8 tools) - Click, drag, fill, form filling, dialog handling, hover, key pressing, file upload
- **Performance** (3 tools) - Trace recording and analysis
- **Network** (2 tools) - Request inspection
- **Debugging** (5 tools) - Script evaluation, console monitoring, screenshots, snapshots
- **Emulation** (2 tools) - Device emulation, viewport resizing

## Configuration

The plugin uses sensible defaults:
- **Browser mode**: Headless (no UI, faster, less resource usage)
- **Screenshot scope**: Full page (entire scrollable content)
- **Console filter**: Errors and warnings only
- **Performance metrics**: LCP, FCP, TTI, TBT

Future versions may support user configuration via `.claude/chromedev-tools.local.md`.

## Examples

**Debug a React app:**
```
Claude: "Check console errors at localhost:3000"
→ Skill activates, runs console inspection, reports errors
```

**Analyze performance:**
```
User: "/chromedev:performance https://myapp.com"
→ Records trace, extracts metrics, identifies long tasks, suggests optimizations
```

**Full inspection workflow:**
```
User: "/chromedev:inspect https://localhost:3000/dashboard"
→ Screenshot + DOM snapshot + console logs + network requests
```

## Troubleshooting

**Chrome not found:**
- Ensure Chrome is installed and in PATH
- Or install Chromium: `npx -y @puppeteer/browsers install chrome@stable`

**MCP server won't start:**
- Check Node.js version: `node --version` (requires v20.19+)
- Try manual install: `npm install -g chrome-devtools-mcp@latest`

**Commands timeout:**
- Check if localhost server is running
- Verify URL is accessible from terminal: `curl <url>`
- Increase timeout if page is slow to load

## License

MIT
