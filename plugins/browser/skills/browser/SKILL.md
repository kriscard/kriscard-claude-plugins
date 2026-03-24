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

Uses the `agent-browser` CLI — a native Rust binary controlling Chrome via DevTools Protocol — to inspect, debug, and profile web pages. All operations run via Bash tool calls. No MCP server or Node.js required.

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

**CLI basics** — Binary at `/opt/homebrew/bin/agent-browser`. Runs a persistent daemon; browser stays open between commands for multi-step workflows.

**Command chaining** — Use `&&` to chain: `agent-browser open "$URL" && agent-browser wait --load networkidle`. Browser also persists across separate Bash calls.

**Structured output** — All commands support `--json` for structured JSON output.

**Element references** — `agent-browser snapshot` returns an a11y tree with refs like `@e1`, `@e2`. Use them in follow-up commands: `agent-browser click @e1`, `agent-browser fill @e2 "value"`.

**Annotated screenshots** — `--annotate` overlays numbered labels on interactive elements. Designed for AI consumption, not human sharing.

## Commands

| Command | Purpose |
|---------|---------|
| `/browser:inspect <url>` | Full page inspection (screenshot + DOM + console + network) |
| `/browser:screenshot <url>` | Quick screenshot capture |
| `/browser:console <url>` | Console error checking |
| `/browser:performance <url>` | Core Web Vitals analysis with recommendations |
| `/browser:diff <url1> <url2>` | Visual and structural page comparison |
| `/browser:record <url>` | Video recording of browser interactions |

## Smart Waiting

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

## Gotchas

- `agent-browser` must be installed at `/opt/homebrew/bin/agent-browser`
- First command after `agent-browser close` starts a fresh daemon — previous page state is lost
- HAR recording must be started BEFORE navigation to capture all requests
- `--annotate` screenshots are designed for AI consumption, not human sharing

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

## Reference Files

| File | Contents |
|------|----------|
| [`references/cli-reference.md`](references/cli-reference.md) | Full command syntax: element refs, annotated screenshots, JS eval, network filtering, sessions, device emulation, form interaction |
| [`references/workflows.md`](references/workflows.md) | Step-by-step workflows: page inspection, console debugging, performance analysis, screenshots, network monitoring, page comparison, video recording, device emulation, form interaction |
