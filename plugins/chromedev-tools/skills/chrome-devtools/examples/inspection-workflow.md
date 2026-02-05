# Page Inspection Workflows

Detailed patterns for inspecting frontend applications using Chrome DevTools MCP.

## Basic Inspection Pattern

The standard inspection workflow provides comprehensive visibility into page state:

### Step 1: Navigate and Wait

```
mcp__plugin_chromedev-tools_cdt__navigate_page
Parameters: {url: "https://localhost:3000"}

mcp__plugin_chromedev-tools_cdt__wait_for
Parameters: {time: 2}
```

**Why wait:** Allows JavaScript initialization, API calls, and dynamic content loading.

**Wait time guidelines:**
- Static HTML: 1-2 seconds
- React/Vue apps: 2-3 seconds
- Heavy data loading: 3-5 seconds

### Step 2: Capture Visual State

```
mcp__plugin_chromedev-tools_cdt__take_screenshot
Parameters: {
  fullPage: true,
  filename: "inspection-screenshot.png",
  type: "png"
}
```

**Full page vs viewport:**
- `fullPage: true` - Entire scrollable content (recommended)
- `fullPage: false` - Only visible area

**Output:** Screenshot saved to current directory

### Step 3: Get DOM Structure

```
mcp__plugin_chromedev-tools_cdt__take_snapshot
```

**Returns:**
- Accessibility tree with element roles
- Page hierarchy and structure
- Interactive element states
- Text content

**Use for:**
- Understanding page layout
- Finding element references for interaction
- Verifying semantic HTML structure

### Step 4: Check Console Messages

```
mcp__plugin_chromedev-tools_cdt__list_console_messages
Parameters: {level: "warning"}
```

**Level options:**
- `"error"` - Only errors (console.error, exceptions)
- `"warning"` - Errors + warnings
- `"info"` - Warnings + info/log messages
- `"debug"` - Everything including verbose debug

**Returns:**
Array of messages with:
- Type (error, warning, info, debug)
- Text content
- Timestamp
- Source location (file:line:column)

### Step 5: Analyze Network Activity

```
mcp__plugin_chromedev-tools_cdt__list_network_requests
Parameters: {includeStatic: false}
```

**includeStatic: false** - Filters out images, fonts, CSS, JS files
**includeStatic: true** - Shows all requests including static resources

**Returns:**
Array of requests with:
- URL and HTTP method
- Status code and status text
- Request/response headers
- Timing information
- Response size

**Use for:**
- Verifying API calls
- Checking authentication headers
- Debugging failed requests
- Analyzing load performance

## Automated Inspection Command

For quick access, use the built-in command:

```
/chromedev:inspect https://localhost:3000
```

This automates the entire 5-step workflow above.

## Targeted Inspection Workflows

### React App Inspection

For React applications with client-side rendering:

```
1. navigate_page(url: "https://localhost:3000")
2. wait_for(time: 3)  # Longer wait for React hydration
3. evaluate_script(function: "() => window.__REACT_DEVTOOLS_GLOBAL_HOOK__ ? 'React detected' : 'No React'")
4. list_console_messages(level: "warning")  # Check for React warnings
5. take_snapshot()  # Verify component rendering
6. take_screenshot(fullPage: true)
```

**React-specific checks:**
- Console for "Warning: Can't perform a React state update"
- Network requests for API data
- Hydration errors or mismatches

### API Integration Inspection

For pages that make API calls:

```
1. navigate_page(url: "https://localhost:3000/dashboard")
2. wait_for(time: 5)  # Allow API calls to complete
3. list_network_requests(includeStatic: false)  # Focus on API calls
4. [Filter requests for API endpoints]
5. list_console_messages(level: "error")  # Check for fetch errors
6. take_snapshot()  # Verify data rendering
```

**API debugging checklist:**
- Check request method (GET, POST, etc.)
- Verify authentication headers (Authorization, cookies)
- Inspect request payload for POST/PUT
- Check response status codes (200, 401, 500, etc.)
- Verify response data structure

### Form Validation Inspection

For testing form behavior:

```
1. navigate_page(url: "https://localhost:3000/signup")
2. take_snapshot()  # Get form structure
3. browser_fill_form(fields: [
     {name: "Email", ref: "input[name='email']", type: "textbox", value: "invalid-email"},
     {name: "Password", ref: "input[name='password']", type: "textbox", value: "123"}
   ])
4. browser_click(element: "Submit", ref: "button[type='submit']")
5. wait_for(time: 1)
6. list_console_messages(level: "warning")
7. take_snapshot()  # Check for validation errors
8. take_screenshot()  # Capture error state
```

**Form testing checks:**
- Validation messages appear
- Console errors for invalid input
- Form submission prevented/allowed correctly
- Error styling applied

### Responsive Design Inspection

For checking mobile/tablet layouts:

```
# Mobile viewport
1. browser_resize(width: 375, height: 667)  # iPhone size
2. navigate_page(url: "https://localhost:3000")
3. wait_for(time: 2)
4. take_screenshot(fullPage: true, filename: "mobile.png")

# Tablet viewport
5. browser_resize(width: 768, height: 1024)  # iPad size
6. navigate_page(url: "https://localhost:3000")
7. wait_for(time: 2)
8. take_screenshot(fullPage: true, filename: "tablet.png")

# Desktop viewport
9. browser_resize(width: 1920, height: 1080)  # HD desktop
10. navigate_page(url: "https://localhost:3000")
11. wait_for(time: 2)
12. take_screenshot(fullPage: true, filename: "desktop.png")
```

**Common viewport sizes:**
- Mobile: 375x667 (iPhone), 360x640 (Android)
- Tablet: 768x1024 (iPad), 1024x600 (Android tablet)
- Desktop: 1920x1080 (HD), 1366x768 (common laptop)

## Advanced Inspection Patterns

### Multi-Page Inspection

For inspecting multiple pages in sequence:

```
pages = [
  "https://localhost:3000/",
  "https://localhost:3000/about",
  "https://localhost:3000/contact"
]

For each page:
  1. navigate_page(url: page)
  2. wait_for(time: 2)
  3. take_screenshot(fullPage: true, filename: f"{page-name}.png")
  4. list_console_messages(level: "error")
  5. [Store results for comparison]
```

### Interactive Flow Inspection

For inspecting user workflows:

```
1. navigate_page(url: "https://localhost:3000/login")
2. take_screenshot(filename: "01-login-page.png")
3. browser_fill_form(fields: [...login credentials...])
4. browser_click(element: "Login", ref: "button[type='submit']")
5. wait_for(text: "Dashboard")
6. take_screenshot(filename: "02-logged-in.png")
7. list_console_messages(level: "warning")
8. list_network_requests(includeStatic: false)
```

**Use for:**
- Testing authentication flows
- Verifying navigation
- Checking state persistence
- Debugging multi-step processes

### Error State Inspection

For debugging error conditions:

```
1. navigate_page(url: "https://localhost:3000/app")
2. wait_for(time: 2)
3. evaluate_script(function: "() => { throw new Error('Test error'); }")
4. wait_for(time: 1)
5. list_console_messages(level: "error")
6. take_snapshot()  # Check error boundary rendering
7. take_screenshot(filename: "error-state.png")
```

**Trigger errors intentionally:**
- Call error-throwing JavaScript
- Navigate to broken URLs
- Disconnect network (if supported)
- Invalid API responses

## Inspection Output Analysis

### Screenshot Analysis

When reviewing screenshots:

- **Layout issues** - Overlapping elements, incorrect positioning
- **Styling problems** - Wrong colors, fonts, spacing
- **Responsive issues** - Elements too large/small for viewport
- **Visual regressions** - Compare with previous screenshots
- **Content rendering** - Missing text, images, or components

### DOM Snapshot Analysis

When reviewing accessibility snapshots:

- **Semantic structure** - Proper heading hierarchy (h1→h2→h3)
- **Interactive elements** - Buttons, links, form fields present
- **Labels and descriptions** - Form inputs have labels
- **Roles** - Correct ARIA roles for custom components
- **Navigation** - Landmarks (header, nav, main, footer)

### Console Messages Analysis

When reviewing console logs:

**Errors (critical):**
- Uncaught exceptions - JavaScript runtime errors
- Failed API calls - Network or server errors
- Reference errors - Undefined variables or functions

**Warnings (important):**
- React/Vue warnings - State update issues, prop validation
- Deprecated API usage - Browser or framework warnings
- Performance warnings - Slow operations, memory leaks

**Info (optional):**
- Debug logs - Application logging
- Navigation events - Route changes
- Component lifecycle - Mount/unmount events

### Network Request Analysis

When reviewing network activity:

**Failed requests (status 4xx, 5xx):**
- 401/403 - Authentication/authorization issues
- 404 - Missing API endpoints or resources
- 500/502 - Server errors
- CORS errors - Cross-origin policy violations

**Slow requests (>1000ms):**
- API performance problems
- Large payload transfers
- Server-side processing delays

**Unexpected requests:**
- Duplicate API calls
- Requests to wrong endpoints
- Missing authentication headers

## Inspection Best Practices

### Before Inspection

1. **Start fresh** - Clear browser cache/storage if testing clean state
2. **Verify server running** - Check localhost is accessible
3. **Know what to expect** - Understand normal page behavior
4. **Plan wait times** - Estimate page load and API call duration

### During Inspection

1. **Wait sufficiently** - Don't rush, allow content to load
2. **Capture everything** - Screenshots, snapshots, console, network
3. **Document findings** - Note issues as you discover them
4. **Use full URLs** - Always include protocol (http://, https://)

### After Inspection

1. **Review all artifacts** - Check screenshots, console, network
2. **Prioritize issues** - Errors > warnings > info
3. **Reproduce problems** - Verify issues in regular browser
4. **Share evidence** - Screenshots and logs for debugging

## Troubleshooting Inspection

**Page doesn't load:**
- Increase wait time
- Check if server is running (`curl <url>`)
- Verify URL is correct and accessible
- Check for connection errors in network requests

**Screenshots are blank:**
- Wait longer for rendering
- Check console for JavaScript errors
- Verify page actually loads content
- Try in regular browser first

**Console messages missing:**
- Increase wait time for JavaScript execution
- Check if page actually logs to console
- Verify log level filter is appropriate
- Test with `level: "debug"` to see everything

**Network requests incomplete:**
- Wait longer for async operations
- Check if requests happen after initial load
- Try `includeStatic: true` to see all activity
- Verify page makes network calls

**Snapshots don't show content:**
- Page may be empty or loading slowly
- Check for client-side rendering delays
- Verify JavaScript executed successfully
- Review console for errors blocking render

## Summary

Use the basic 5-step inspection pattern for most cases:
1. Navigate and wait
2. Screenshot
3. DOM snapshot
4. Console messages
5. Network requests

For comprehensive inspection, use `/chromedev:inspect <url>` command.

Adapt the workflow for specific scenarios:
- React apps - longer wait, check React warnings
- API integration - focus on network tab
- Forms - test validation and submission
- Responsive - test multiple viewport sizes
- Errors - intentionally trigger and inspect

Always review all artifacts (screenshot, snapshot, console, network) for complete understanding of page state.
