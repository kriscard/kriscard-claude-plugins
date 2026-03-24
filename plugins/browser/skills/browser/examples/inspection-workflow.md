# Inspection Workflows

Patterns for inspecting web pages using agent-browser CLI.

## Basic Inspection Pattern

The standard 5-step inspection sequence:

```bash
# 1. Navigate and wait
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle

# 2. Visual capture
agent-browser screenshot --full inspection.png

# 3. DOM structure
agent-browser snapshot

# 4. Console check
agent-browser errors
agent-browser console

# 5. Network analysis
agent-browser network requests --type fetch,xhr
```

## React App Inspection

For React/Next.js applications with client-side rendering:

```bash
# Navigate and wait for hydration
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle

# Check for React-specific errors (hydration mismatches, key warnings)
agent-browser errors

# Get component structure via accessibility tree
agent-browser snapshot

# Check for hydration issues via JS eval
cat <<'EOF' | agent-browser eval --stdin
const root = document.getElementById('__next') || document.getElementById('root');
root ? { found: true, childCount: root.children.length } : { found: false };
EOF

# Monitor API calls
agent-browser network requests --type fetch,xhr

# Screenshot for visual verification
agent-browser screenshot --full react-app.png
```

## API Integration Inspection

For pages heavy on API calls:

```bash
# Navigate
agent-browser open "http://localhost:3000/dashboard" && agent-browser wait --load networkidle

# Check all network requests with details
agent-browser network requests --type fetch,xhr --json

# Filter for failed requests
agent-browser network requests --status 4xx
agent-browser network requests --status 5xx

# Check specific request detail (use reqId from requests list)
agent-browser network request <requestId>

# Check for CORS or auth errors in console
agent-browser errors

# Verify data rendered correctly
agent-browser get text "#data-container"
```

## Form Validation Inspection

For testing form behavior:

```bash
# Navigate to form page
agent-browser open "http://localhost:3000/signup" && agent-browser wait --load networkidle

# Get form structure
agent-browser snapshot -i  # Interactive elements only

# Test empty submission
agent-browser click "#submit-button"
agent-browser wait 500
agent-browser screenshot --full form-errors.png
agent-browser errors

# Fill with invalid data
agent-browser fill "#email" "not-an-email"
agent-browser fill "#password" "123"
agent-browser click "#submit-button"
agent-browser wait 500
agent-browser screenshot --full form-validation.png

# Fill with valid data
agent-browser fill "#email" "user@example.com"
agent-browser fill "#password" "SecurePassword123!"
agent-browser click "#submit-button"
agent-browser wait --url "/welcome"
agent-browser screenshot --full form-success.png
```

## Responsive Design Inspection

Testing across device sizes:

```bash
# Desktop (1920x1080)
agent-browser set viewport 1920 1080
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser screenshot --full desktop.png

# Tablet (iPad)
agent-browser set device "iPad Pro"
agent-browser reload && agent-browser wait --load networkidle
agent-browser screenshot --full tablet.png

# Mobile (iPhone)
agent-browser set device "iPhone 14"
agent-browser reload && agent-browser wait --load networkidle
agent-browser screenshot --full mobile.png

# Check for layout issues at each size
agent-browser snapshot --compact
```

## Multi-Page Flow Inspection

Testing navigation flows (e.g., checkout):

```bash
# Step 1: Landing page
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser screenshot --full step1-landing.png

# Step 2: Navigate to product
agent-browser click "a[href='/products/1']"
agent-browser wait --load networkidle
agent-browser screenshot --full step2-product.png

# Step 3: Add to cart
agent-browser click "#add-to-cart"
agent-browser wait --text "Added to cart"
agent-browser screenshot --full step3-cart.png

# Step 4: Checkout
agent-browser click "#checkout-button"
agent-browser wait --load networkidle
agent-browser screenshot --full step4-checkout.png

# Check for errors throughout
agent-browser errors
```

## Diff-Based Regression Testing

Compare pages before and after changes:

### Two-URL comparison (staging vs production)
```bash
agent-browser diff url "http://localhost:3000" "https://production.example.com"
```

### Before/After on same page
```bash
# Take baseline
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser screenshot --full baseline.png

# ... make code changes, restart dev server ...

# Compare
agent-browser reload && agent-browser wait --load networkidle
agent-browser diff screenshot --baseline baseline.png
agent-browser diff snapshot
```

## Recording User Flows

Capture video of interactions for documentation or bug reports:

```bash
# Start recording
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser record start user-flow.webm

# Perform interactions
agent-browser click "#login-button"
agent-browser fill "#email" "user@example.com"
agent-browser fill "#password" "password123"
agent-browser click "#submit"
agent-browser wait --url "/dashboard"
agent-browser wait 2000  # Pause for visual context

# Stop recording
agent-browser record stop
```

## Error State Inspection

Testing error handling:

```bash
# Test 404 page
agent-browser open "http://localhost:3000/nonexistent" && agent-browser wait --load networkidle
agent-browser screenshot --full error-404.png
agent-browser errors

# Test with network errors (simulate offline)
agent-browser set offline on
agent-browser reload
agent-browser wait 2000
agent-browser screenshot --full error-offline.png
agent-browser errors
agent-browser set offline off

# Test with blocked API
agent-browser network route "**/api/data" --abort
agent-browser reload && agent-browser wait --load networkidle
agent-browser screenshot --full error-api-blocked.png
agent-browser errors
agent-browser network unroute
```

## Dark Mode Inspection

```bash
# Light mode baseline
agent-browser set media light
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser screenshot --full light-mode.png

# Dark mode
agent-browser set media dark
agent-browser reload && agent-browser wait --load networkidle
agent-browser screenshot --full dark-mode.png

# Compare
agent-browser diff screenshot --baseline light-mode.png
```

## Best Practices

1. **Always use `wait --load networkidle`** instead of arbitrary time delays — it waits for actual network quiescence
2. **Use `--json` flag** when you need to parse structured output programmatically
3. **Use `snapshot -i`** when you only care about interactive elements (forms, buttons, links)
4. **Use `--annotate` screenshots** when you need to reference specific elements by number
5. **Use `agent-browser close`** to reset browser state if something gets stuck
6. **Use `errors` for error checking**, `console` for the full picture
7. **Filter network with `--type fetch,xhr`** to focus on API calls, skip static resources
