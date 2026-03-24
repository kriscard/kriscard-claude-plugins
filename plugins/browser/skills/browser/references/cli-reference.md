# agent-browser CLI Reference

Detailed command syntax and usage patterns for the `agent-browser` CLI.

## Element References

`agent-browser snapshot` returns an accessibility tree with element references like `@e1`, `@e2`. Use these refs in subsequent commands:

```bash
agent-browser snapshot       # Shows @e1: button "Submit", @e2: textbox "Email", etc.
agent-browser click @e1      # Click the Submit button
agent-browser fill @e2 "user@example.com"  # Fill the Email field
```

## Annotated Screenshots

`--annotate` overlays numbered labels on interactive elements — designed for AI consumption:

```bash
agent-browser screenshot --full --annotate page.png
# Shows [1] Submit button, [2] Email field, etc.
```

## JavaScript Evaluation

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

## Network Filtering

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

## Session Management

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

## Device Emulation Commands

```bash
# Mobile
agent-browser set device "iPhone 14"

# Tablet
agent-browser set device "iPad Pro"

# Custom viewport
agent-browser set viewport 1440 900

# Dark mode
agent-browser set media dark
```

After changing device/viewport, reload the page to apply:

```bash
agent-browser reload && agent-browser wait --load networkidle
```

## Form Interaction Commands

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
