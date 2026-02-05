---
description: Capture full-page screenshot
argument-hint: <url>
allowed-tools: mcp__plugin_chromedev-tools_cdt__navigate_page, mcp__plugin_chromedev-tools_cdt__wait_for, mcp__plugin_chromedev-tools_cdt__take_screenshot
model: haiku
---

Capture full-page screenshot of $ARGUMENTS:

## Workflow

1. Navigate to page:
   - Use `mcp__plugin_chromedev-tools_cdt__navigate_page` with url: "$ARGUMENTS"

2. Wait for rendering:
   - Use `mcp__plugin_chromedev-tools_cdt__wait_for` with time: 2 (allows page rendering and image loading)

3. Capture screenshot:
   - Use `mcp__plugin_chromedev-tools_cdt__take_screenshot` with:
     - fullPage: true (capture entire scrollable page)
     - filename: "screenshot.png"
     - type: "png"

## Output

Report to user:
- Screenshot saved to: [file location]
- Page URL: $ARGUMENTS
- Dimensions: [if available from snapshot]

If user did not provide a URL, prompt them with: "Please provide a URL to screenshot. Usage: /chromedev:screenshot <url>"
