---
description: Record performance trace and analyze Core Web Vitals
argument-hint: <url>
allowed-tools: mcp__plugin_chromedev-tools_cdt__navigate_page, mcp__plugin_chromedev-tools_cdt__wait_for, mcp__plugin_chromedev-tools_cdt__evaluate_script, mcp__plugin_chromedev-tools_cdt__list_network_requests
model: sonnet
---

Perform comprehensive performance analysis of $ARGUMENTS:

## Step 1: Navigate and Measure

1. Navigate to page:
   - Use `mcp__plugin_chromedev-tools_cdt__navigate_page` with url: "$ARGUMENTS"

2. Wait for page load:
   - Use `mcp__plugin_chromedev-tools_cdt__wait_for` with time: 5 (capture full page load cycle)

## Step 2: Extract Core Web Vitals

Use `mcp__plugin_chromedev-tools_cdt__evaluate_script` to measure key metrics:

### First Contentful Paint (FCP)
```javascript
() => {
  const fcp = performance.getEntriesByType('paint')
    .find(entry => entry.name === 'first-contentful-paint');
  return fcp ? fcp.startTime : null;
}
```

### Largest Contentful Paint (LCP)
```javascript
() => {
  return new Promise((resolve) => {
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
}
```

### Navigation Timing
```javascript
() => {
  const navigation = performance.getEntriesByType('navigation')[0];
  if (!navigation) return null;
  return {
    domContentLoaded: navigation.domContentLoadedEventEnd,
    loadComplete: navigation.loadEventEnd,
    domInteractive: navigation.domInteractive,
    responseEnd: navigation.responseEnd
  };
}
```

### Long Tasks Detection
```javascript
() => {
  return new Promise((resolve) => {
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
}
```

## Step 3: Analyze Resources

Get network timing for resource analysis:
- Use `mcp__plugin_chromedev-tools_cdt__list_network_requests` with includeStatic: true
- Identify large resources (> 100KB)
- Find slow resources (> 500ms duration)
- Calculate total bundle sizes (JavaScript, CSS, images)

## Step 4: Calculate Total Blocking Time (TBT)

From long tasks detected above:
- Sum duration of all tasks > 50ms
- Each task contributes (duration - 50ms) to TBT
- Target: < 200ms

## Output Format

Provide performance report:

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

Performance Issues:
- [List specific performance problems found]

High Priority:
- [Recommendations for critical issues (LCP > 4s, TBT > 600ms, etc.)]

Medium Priority:
- [Recommendations for improvement areas]

Low Priority:
- [Nice-to-have optimizations]

**Example Recommendations:**
- Optimize large images (use WebP, implement lazy loading)
- Reduce JavaScript bundle size (code splitting, tree shaking)
- Minimize render-blocking resources (inline critical CSS)
- Reduce long tasks (defer non-critical scripts)
- Implement caching strategies
- Use CDN for static assets
- Optimize font loading (font-display: swap)

If user did not provide a URL, prompt them with: "Please provide a URL to analyze. Usage: /chromedev:performance <url>"
