Perform comprehensive performance analysis of $ARGUMENTS using agent-browser CLI:

## Step 1: Navigate and Wait

```bash
agent-browser open "$ARGUMENTS" && agent-browser wait --load networkidle
```

## Step 2: Extract Core Web Vitals

Use `agent-browser eval --stdin` with heredoc for each metric:

### First Contentful Paint (FCP)
```bash
cat <<'EOF' | agent-browser eval --stdin
const fcp = performance.getEntriesByType('paint')
  .find(entry => entry.name === 'first-contentful-paint');
fcp ? fcp.startTime : null;
EOF
```

### Largest Contentful Paint (LCP)
```bash
cat <<'EOF' | agent-browser eval --stdin
await new Promise((resolve) => {
  new PerformanceObserver((list) => {
    const entries = list.getEntries();
    const lastEntry = entries[entries.length - 1];
    resolve({
      lcp: lastEntry.renderTime || lastEntry.loadTime,
      element: lastEntry.element?.tagName
    });
  }).observe({type: 'largest-contentful-paint', buffered: true});
  setTimeout(() => resolve(null), 100);
});
EOF
```

### Navigation Timing
```bash
cat <<'EOF' | agent-browser eval --stdin
const navigation = performance.getEntriesByType('navigation')[0];
navigation ? {
  domContentLoaded: navigation.domContentLoadedEventEnd,
  loadComplete: navigation.loadEventEnd,
  domInteractive: navigation.domInteractive,
  responseEnd: navigation.responseEnd
} : null;
EOF
```

### Long Tasks Detection
```bash
cat <<'EOF' | agent-browser eval --stdin
await new Promise((resolve) => {
  const longTasks = [];
  const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      longTasks.push({
        duration: entry.duration,
        startTime: entry.startTime
      });
    }
  });
  try {
    observer.observe({type: 'longtask', buffered: true});
    setTimeout(() => {
      observer.disconnect();
      resolve(longTasks);
    }, 100);
  } catch(e) {
    resolve([]);
  }
});
EOF
```

## Step 3: Analyze Resources

Get network requests for resource analysis:
```bash
agent-browser network requests
```

Identify large resources (> 100KB), slow resources (> 500ms), and calculate total bundle sizes (JavaScript, CSS, images).

## Step 4: Calculate Total Blocking Time (TBT)

From long tasks detected above:
- Sum duration of all tasks > 50ms
- Each task contributes (duration - 50ms) to TBT
- Target: < 200ms

## Output Format

**Performance Analysis for:** $ARGUMENTS

**Core Web Vitals:**
- FCP (First Contentful Paint): [X]ms (Target: < 1800ms)
  - Status: [Good < 1800ms | Needs Improvement 1800-3000ms | Poor > 3000ms]
- LCP (Largest Contentful Paint): [X]ms (Target: < 2500ms)
  - Status: [Good < 2500ms | Needs Improvement 2500-4000ms | Poor > 4000ms]
  - Element: [tag name]
- TTI (Time to Interactive): ~[X]ms (estimated from domInteractive)
  - Status: [Good < 3800ms | Needs Improvement 3800-7300ms | Poor > 7300ms]
- TBT (Total Blocking Time): [X]ms (Target: < 200ms)
  - Long tasks found: [number]
  - Status: [Good < 200ms | Needs Improvement 200-600ms | Poor > 600ms]

**Resource Analysis:**
- Total JavaScript: [X]KB
- Total CSS: [X]KB
- Total Images: [X]KB
- Total Requests: [number]
- Largest resource: [name, size]
- Slowest request: [name, duration]

**Bottlenecks Identified:**
- [List resources > 100KB]
- [List requests > 1000ms]
- [List long tasks > 100ms blocking main thread]

**Optimization Recommendations:**

High Priority:
- [Recommendations for critical issues (LCP > 4s, TBT > 600ms, etc.)]

Medium Priority:
- [Recommendations for improvement areas]

Low Priority:
- [Nice-to-have optimizations]

If user did not provide a URL, prompt them with: "Please provide a URL to analyze. Usage: /browser:performance <url>"
