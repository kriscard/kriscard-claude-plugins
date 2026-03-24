# Performance Analysis

Techniques for measuring and optimizing web performance using agent-browser CLI.

## Core Web Vitals Extraction

### First Contentful Paint (FCP)

```bash
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
cat <<'EOF' | agent-browser eval --stdin
const fcp = performance.getEntriesByType('paint')
  .find(entry => entry.name === 'first-contentful-paint');
fcp ? { fcp_ms: Math.round(fcp.startTime) } : null;
EOF
```

**Thresholds:** Good < 1800ms | Needs Improvement 1800-3000ms | Poor > 3000ms

### Largest Contentful Paint (LCP)

```bash
cat <<'EOF' | agent-browser eval --stdin
await new Promise((resolve) => {
  new PerformanceObserver((list) => {
    const entries = list.getEntries();
    const lastEntry = entries[entries.length - 1];
    resolve({
      lcp_ms: Math.round(lastEntry.renderTime || lastEntry.loadTime),
      element: lastEntry.element?.tagName,
      url: lastEntry.url || null
    });
  }).observe({type: 'largest-contentful-paint', buffered: true});
  setTimeout(() => resolve(null), 200);
});
EOF
```

**Thresholds:** Good < 2500ms | Needs Improvement 2500-4000ms | Poor > 4000ms

### Cumulative Layout Shift (CLS)

```bash
cat <<'EOF' | agent-browser eval --stdin
await new Promise((resolve) => {
  let clsValue = 0;
  const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      if (!entry.hadRecentInput) {
        clsValue += entry.value;
      }
    }
  });
  observer.observe({type: 'layout-shift', buffered: true});
  setTimeout(() => {
    observer.disconnect();
    resolve({ cls: Math.round(clsValue * 1000) / 1000 });
  }, 200);
});
EOF
```

**Thresholds:** Good < 0.1 | Needs Improvement 0.1-0.25 | Poor > 0.25

### Navigation Timing

```bash
cat <<'EOF' | agent-browser eval --stdin
const nav = performance.getEntriesByType('navigation')[0];
nav ? {
  dns: Math.round(nav.domainLookupEnd - nav.domainLookupStart),
  tcp: Math.round(nav.connectEnd - nav.connectStart),
  ttfb: Math.round(nav.responseStart - nav.requestStart),
  download: Math.round(nav.responseEnd - nav.responseStart),
  domInteractive: Math.round(nav.domInteractive),
  domContentLoaded: Math.round(nav.domContentLoadedEventEnd),
  loadComplete: Math.round(nav.loadEventEnd),
  transferSize: nav.transferSize
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
        duration_ms: Math.round(entry.duration),
        start_ms: Math.round(entry.startTime),
        blocking_ms: Math.round(Math.max(0, entry.duration - 50))
      });
    }
  });
  try {
    observer.observe({type: 'longtask', buffered: true});
    setTimeout(() => {
      observer.disconnect();
      const tbt = longTasks.reduce((sum, t) => sum + t.blocking_ms, 0);
      resolve({ longTasks, totalBlockingTime_ms: tbt, count: longTasks.length });
    }, 200);
  } catch(e) {
    resolve({ longTasks: [], totalBlockingTime_ms: 0, count: 0 });
  }
});
EOF
```

**TBT Thresholds:** Good < 200ms | Needs Improvement 200-600ms | Poor > 600ms

## Resource Analysis

### Bundle Size Analysis

```bash
# Get all network requests with timing
agent-browser network requests --json

# Filter to JavaScript bundles
agent-browser network requests --type script --json

# Filter to CSS
agent-browser network requests --type stylesheet --json

# Filter to images
agent-browser network requests --type image --json
```

### Resource Timing via JS

```bash
cat <<'EOF' | agent-browser eval --stdin
const resources = performance.getEntriesByType('resource');
const summary = {
  total: resources.length,
  byType: {},
  largest: null,
  slowest: null
};

resources.forEach(r => {
  const type = r.initiatorType;
  if (!summary.byType[type]) summary.byType[type] = { count: 0, totalSize: 0, totalDuration: 0 };
  summary.byType[type].count++;
  summary.byType[type].totalSize += r.transferSize || 0;
  summary.byType[type].totalDuration += r.duration;

  if (!summary.largest || (r.transferSize || 0) > summary.largest.size) {
    summary.largest = { name: r.name.split('/').pop(), size: r.transferSize, type };
  }
  if (!summary.slowest || r.duration > summary.slowest.duration) {
    summary.slowest = { name: r.name.split('/').pop(), duration: Math.round(r.duration), type };
  }
});

// Convert sizes to KB
Object.values(summary.byType).forEach(t => { t.totalSize = Math.round(t.totalSize / 1024); });
if (summary.largest) summary.largest.size = Math.round(summary.largest.size / 1024);

summary;
EOF
```

## Chrome DevTools Trace Recording

For detailed flame chart analysis:

```bash
# Navigate first
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle

# Record trace during page reload
agent-browser trace start
agent-browser reload && agent-browser wait --load networkidle
agent-browser wait 2000  # Capture post-load activity
agent-browser trace stop trace.json
```

The trace.json file can be loaded into Chrome DevTools (Performance tab) or analyzed programmatically.

## CPU Profiling

```bash
agent-browser profiler start
# ... perform interactions or wait for activity ...
agent-browser profiler stop profile.json
```

Profile can be loaded into Chrome DevTools for flame chart analysis.

## HAR Recording

For detailed network waterfall analysis:

```bash
agent-browser network har start
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle
agent-browser network har stop waterfall.har
```

HAR files can be imported into Chrome DevTools Network tab or analyzed with HAR viewers.

## Real-World Scenarios

### React App Performance

```bash
agent-browser open "http://localhost:3000" && agent-browser wait --load networkidle

# Check bundle sizes
agent-browser network requests --type script --json

# Check for unnecessary re-renders via long tasks
cat <<'EOF' | agent-browser eval --stdin
await new Promise((resolve) => {
  const tasks = [];
  const observer = new PerformanceObserver((list) => {
    list.getEntries().forEach(e => tasks.push({ duration: e.duration, start: e.startTime }));
  });
  observer.observe({type: 'longtask', buffered: true});
  setTimeout(() => { observer.disconnect(); resolve(tasks); }, 200);
});
EOF

# Check hydration time for SSR apps
cat <<'EOF' | agent-browser eval --stdin
const nav = performance.getEntriesByType('navigation')[0];
nav ? {
  ttfb: Math.round(nav.responseStart - nav.requestStart),
  domInteractive: Math.round(nav.domInteractive),
  hydrationEstimate: Math.round(nav.domInteractive - nav.responseEnd)
} : null;
EOF
```

### API-Heavy Dashboard

```bash
agent-browser open "http://localhost:3000/dashboard" && agent-browser wait --load networkidle

# Time API calls
agent-browser network requests --type fetch,xhr --json

# Check for waterfall (sequential) API calls vs parallel
cat <<'EOF' | agent-browser eval --stdin
const fetches = performance.getEntriesByType('resource')
  .filter(r => r.initiatorType === 'fetch' || r.initiatorType === 'xmlhttprequest')
  .map(r => ({
    url: r.name.split('/').pop(),
    start: Math.round(r.startTime),
    duration: Math.round(r.duration),
    end: Math.round(r.startTime + r.duration)
  }))
  .sort((a, b) => a.start - b.start);

const isWaterfall = fetches.length > 1 &&
  fetches.every((f, i) => i === 0 || f.start >= fetches[i-1].end - 10);

{ fetches, isWaterfall, totalDuration: fetches.length ? fetches[fetches.length-1].end - fetches[0].start : 0 };
EOF
```

### Image-Heavy Page

```bash
agent-browser open "http://localhost:3000/gallery" && agent-browser wait --load networkidle

# Analyze image loading
cat <<'EOF' | agent-browser eval --stdin
const images = performance.getEntriesByType('resource')
  .filter(r => r.initiatorType === 'img' || r.name.match(/\.(jpg|jpeg|png|gif|webp|avif|svg)/i))
  .map(r => ({
    name: r.name.split('/').pop(),
    size_kb: Math.round((r.transferSize || 0) / 1024),
    duration_ms: Math.round(r.duration),
    format: r.name.split('.').pop().split('?')[0]
  }))
  .sort((a, b) => b.size_kb - a.size_kb);

const totalSize = images.reduce((sum, img) => sum + img.size_kb, 0);
const nonWebP = images.filter(img => !['webp', 'avif'].includes(img.format));

{ images: images.slice(0, 10), totalSize_kb: totalSize, count: images.length, nonOptimized: nonWebP.length };
EOF
```

## Performance Budgets

Recommended thresholds for automated checks:

| Metric | Good | Warning | Poor |
|--------|------|---------|------|
| FCP | < 1800ms | 1800-3000ms | > 3000ms |
| LCP | < 2500ms | 2500-4000ms | > 4000ms |
| TTI | < 3800ms | 3800-7300ms | > 7300ms |
| TBT | < 200ms | 200-600ms | > 600ms |
| CLS | < 0.1 | 0.1-0.25 | > 0.25 |
| JS Bundle | < 200KB | 200-500KB | > 500KB |
| Total Page | < 1MB | 1-3MB | > 3MB |
| Requests | < 50 | 50-100 | > 100 |

## Optimization Patterns

Common fixes organized by metric:

**LCP too high:**
- Optimize hero images (WebP/AVIF, proper sizing, preload)
- Reduce server response time (TTFB)
- Remove render-blocking resources
- Preload critical fonts

**TBT/TTI too high:**
- Code-split large JavaScript bundles
- Defer non-critical scripts
- Use web workers for heavy computation
- Reduce third-party script impact

**CLS too high:**
- Set explicit dimensions on images/videos
- Reserve space for dynamic content
- Avoid inserting content above existing content
- Use `font-display: swap` with size-adjusted fallback

**Large bundles:**
- Enable tree shaking
- Implement route-based code splitting
- Analyze with bundle analyzer
- Remove unused dependencies
