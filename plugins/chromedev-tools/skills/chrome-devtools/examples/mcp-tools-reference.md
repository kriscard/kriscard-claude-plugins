# Chrome DevTools MCP Tools Reference

Complete reference for all 26 tools provided by the chrome-devtools-mcp server.

## Navigation Tools (6 tools)

### mcp__plugin_chromedev-tools_cdt__navigate_page
Navigate to a URL.

**Parameters:**
- `url` (string, required) - The URL to navigate to

**Example:**
```json
{
  "url": "https://localhost:3000"
}
```

### mcp__plugin_chromedev-tools_cdt__navigate_page_back
Go back to the previous page in history.

**Parameters:** None

### mcp__plugin_chromedev-tools_cdt__browser_tabs
Manage browser tabs - list, create, close, or select.

**Parameters:**
- `action` (string, required) - Operation: "list", "new", "close", "select"
- `index` (number, optional) - Tab index for close/select operations

**Examples:**
```json
{"action": "list"}
{"action": "new"}
{"action": "select", "index": 0}
{"action": "close", "index": 1}
```

### mcp__plugin_chromedev-tools_cdt__wait_for
Wait for text to appear/disappear or for a specified time.

**Parameters:**
- `text` (string, optional) - Text to wait for
- `textGone` (string, optional) - Text to wait to disappear
- `time` (number, optional) - Time to wait in seconds

**Examples:**
```json
{"time": 2}
{"text": "Loading complete"}
{"textGone": "Loading..."}
```

### mcp__plugin_chromedev-tools_cdt__browser_close
Close the current browser page.

**Parameters:** None

### mcp__plugin_chromedev-tools_cdt__browser_resize
Resize the browser window.

**Parameters:**
- `width` (number, required) - Width in pixels
- `height` (number, required) - Height in pixels

**Example:**
```json
{
  "width": 1920,
  "height": 1080
}
```

## Input Automation Tools (8 tools)

### mcp__plugin_chromedev-tools_cdt__browser_click
Perform click on a web page element.

**Parameters:**
- `element` (string, required) - Human-readable element description
- `ref` (string, required) - Exact element reference from snapshot
- `button` (string, optional) - Button: "left", "right", "middle"
- `doubleClick` (boolean, optional) - Whether to double-click
- `modifiers` (array, optional) - Modifier keys: "Alt", "Control", "Meta", "Shift"

**Example:**
```json
{
  "element": "Submit button",
  "ref": "button[type='submit']",
  "button": "left"
}
```

### mcp__plugin_chromedev-tools_cdt__browser_type
Type text into an editable element.

**Parameters:**
- `element` (string, required) - Human-readable element description
- `ref` (string, required) - Exact element reference from snapshot
- `text` (string, required) - Text to type
- `slowly` (boolean, optional) - Type one character at a time
- `submit` (boolean, optional) - Press Enter after typing

**Example:**
```json
{
  "element": "Search input",
  "ref": "input[name='search']",
  "text": "Chrome DevTools",
  "submit": true
}
```

### mcp__plugin_chromedev-tools_cdt__browser_fill_form
Fill multiple form fields at once.

**Parameters:**
- `fields` (array, required) - Array of field objects with:
  - `name` (string) - Human-readable field name
  - `ref` (string) - Exact field reference
  - `type` (string) - Field type: "textbox", "checkbox", "radio", "combobox", "slider"
  - `value` (string) - Value to fill

**Example:**
```json
{
  "fields": [
    {
      "name": "Username",
      "ref": "input[name='username']",
      "type": "textbox",
      "value": "testuser"
    },
    {
      "name": "Remember me",
      "ref": "input[name='remember']",
      "type": "checkbox",
      "value": "true"
    }
  ]
}
```

### mcp__plugin_chromedev-tools_cdt__browser_hover
Hover over an element.

**Parameters:**
- `element` (string, required) - Human-readable element description
- `ref` (string, required) - Exact element reference from snapshot

**Example:**
```json
{
  "element": "Dropdown menu",
  "ref": "button.dropdown-toggle"
}
```

### mcp__plugin_chromedev-tools_cdt__browser_press_key
Press a key on the keyboard.

**Parameters:**
- `key` (string, required) - Key name or character: "ArrowLeft", "Enter", "a", etc.

**Examples:**
```json
{"key": "Enter"}
{"key": "ArrowDown"}
{"key": "Escape"}
```

### mcp__plugin_chromedev-tools_cdt__browser_select_option
Select an option in a dropdown.

**Parameters:**
- `element` (string, required) - Human-readable element description
- `ref` (string, required) - Exact element reference from snapshot
- `values` (array, required) - Values to select (can be multiple for multi-select)

**Example:**
```json
{
  "element": "Country selector",
  "ref": "select[name='country']",
  "values": ["US"]
}
```

### mcp__plugin_chromedev-tools_cdt__browser_drag
Perform drag and drop between two elements.

**Parameters:**
- `startElement` (string, required) - Source element description
- `startRef` (string, required) - Source element reference
- `endElement` (string, required) - Target element description
- `endRef` (string, required) - Target element reference

**Example:**
```json
{
  "startElement": "Draggable item",
  "startRef": ".draggable-item",
  "endElement": "Drop zone",
  "endRef": ".drop-zone"
}
```

### mcp__plugin_chromedev-tools_cdt__browser_file_upload
Upload one or multiple files.

**Parameters:**
- `paths` (array, optional) - Absolute file paths to upload. If omitted, cancels file chooser.

**Example:**
```json
{
  "paths": [
    "/Users/username/Documents/file.pdf"
  ]
}
```

## Performance Tools (3 tools)

### mcp__plugin_chromedev-tools_cdt__browser_run_code
Run Playwright code snippet for advanced automation.

**Parameters:**
- `code` (string, required) - JavaScript function with Playwright code

**Example:**
```json
{
  "code": "async (page) => { await page.getByRole('button', { name: 'Submit' }).click(); return await page.title(); }"
}
```

### mcp__plugin_chromedev-tools_cdt__evaluate_script
Evaluate JavaScript in the page context.

**Parameters:**
- `function` (string, required) - JavaScript function to execute
- `element` (string, optional) - Element description if evaluating on element
- `ref` (string, optional) - Element reference if evaluating on element

**Examples:**
```json
{"function": "() => document.title"}
{"function": "() => window.location.href"}
{"function": "(element) => element.textContent", "element": "Heading", "ref": "h1"}
```

### mcp__plugin_chromedev-tools_cdt__browser_handle_dialog
Handle a browser dialog (alert, confirm, prompt).

**Parameters:**
- `accept` (boolean, required) - Whether to accept the dialog
- `promptText` (string, optional) - Text for prompt dialogs

**Examples:**
```json
{"accept": true}
{"accept": true, "promptText": "My input"}
{"accept": false}
```

## Debugging Tools (5 tools)

### mcp__plugin_chromedev-tools_cdt__take_screenshot
Take a screenshot of the current page.

**Parameters:**
- `element` (string, optional) - Element description for element screenshot
- `ref` (string, optional) - Element reference for element screenshot
- `fullPage` (boolean, optional) - Capture full scrollable page
- `filename` (string, optional) - File name to save screenshot
- `type` (string, optional) - Image format: "png" or "jpeg"

**Examples:**
```json
{"fullPage": true, "filename": "full-page.png"}
{"element": "Header", "ref": "header", "filename": "header.png"}
{"type": "jpeg", "filename": "page.jpg"}
```

### mcp__plugin_chromedev-tools_cdt__take_snapshot
Capture accessibility snapshot of the page.

**Parameters:**
- `filename` (string, optional) - Save snapshot to file instead of returning

**Examples:**
```json
{}
{"filename": "snapshot.md"}
```

### mcp__plugin_chromedev-tools_cdt__list_console_messages
Get console messages from the browser.

**Parameters:**
- `level` (string, optional) - Filter level: "error", "warning", "info", "debug". Default: "info"

**Examples:**
```json
{}
{"level": "error"}
{"level": "warning"}
```

**Returns:**
Array of console messages with type, text, timestamp, and source location.

### mcp__plugin_chromedev-tools_cdt__list_network_requests
Get network requests since loading the page.

**Parameters:**
- `includeStatic` (boolean, optional) - Include successful static resources (images, fonts, scripts). Default: false

**Examples:**
```json
{}
{"includeStatic": true}
{"includeStatic": false}
```

**Returns:**
Array of network requests with URL, method, status, headers, timings, and size.

### mcp__plugin_chromedev-tools_cdt__browser_get_console_logs
Alternative method to get console logs.

**Parameters:** None

**Returns:**
Array of all console log entries.

## Emulation Tools (2 tools)

### mcp__plugin_chromedev-tools_cdt__browser_resize
Resize the browser viewport (also listed in Navigation).

**Parameters:**
- `width` (number, required) - Width in pixels
- `height` (number, required) - Height in pixels

**Example:**
```json
{
  "width": 375,
  "height": 667
}
```

### Device Emulation
Note: Device emulation is available through viewport resizing and user agent configuration. Common device dimensions:

- iPhone 12/13: 390 x 844
- iPhone 12/13 Pro Max: 428 x 926
- iPad Pro 12.9": 1024 x 1366
- Desktop HD: 1920 x 1080
- Desktop 4K: 3840 x 2160

## Tool Categories Summary

| Category | Tool Count | Primary Use |
|----------|------------|-------------|
| Navigation | 6 | Page management, URL navigation |
| Input Automation | 8 | Form filling, clicking, typing |
| Performance | 3 | Code execution, advanced automation |
| Debugging | 5 | Screenshots, console, network, snapshots |
| Emulation | 2 | Viewport resizing, device emulation |

**Total: 24 unique tools** (some tools appear in multiple categories)

## Common Tool Combinations

**Full page inspection:**
```
1. navigate_page(url)
2. wait_for(time: 2)
3. take_screenshot(fullPage: true)
4. take_snapshot()
5. list_console_messages(level: "warning")
6. list_network_requests(includeStatic: false)
```

**Form testing:**
```
1. navigate_page(url)
2. take_snapshot() # Get form structure
3. browser_fill_form(fields)
4. browser_click(element: "Submit button")
5. wait_for(text: "Success")
6. take_screenshot()
```

**Performance analysis:**
```
1. navigate_page(url)
2. browser_run_code("async (page) => { await page.evaluate(() => performance.mark('start')); }")
3. [Perform user interactions]
4. browser_run_code("async (page) => { const metrics = await page.evaluate(() => performance.getEntriesByType('navigation')[0]); return metrics; }")
```

**Console debugging:**
```
1. navigate_page(url)
2. wait_for(time: 3)
3. list_console_messages(level: "error")
4. evaluate_script(function: "() => console.log('Debug checkpoint')")
5. list_console_messages(level: "info")
```

**Network monitoring:**
```
1. navigate_page(url)
2. wait_for(time: 5)
3. list_network_requests(includeStatic: false)
4. [Filter and analyze API calls]
```

## Notes

- All tools with `element` and `ref` parameters require getting a snapshot first to obtain element references
- Element references come from the accessibility snapshot structure
- Tools are namespaced with `mcp__plugin_chromedev-tools_cdt__` prefix when used through MCP
- Most tools work in headless mode (no browser UI needed)
- Screenshots and snapshots are fully functional in headless mode
