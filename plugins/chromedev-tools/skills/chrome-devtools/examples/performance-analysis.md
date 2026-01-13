# Performance Analysis Techniques

Comprehensive guide for analyzing frontend performance using Chrome DevTools MCP.

## Core Web Vitals

The four critical metrics for user experience:

### 1. LCP (Largest Contentful Paint)

**What it measures:** Time until the largest content element is visible
**Target:** < 2.5 seconds
**Common elements:** Hero images, large text blocks, video thumbnails

**What causes slow LCP:**
- Large unoptimized images
- Slow server response time
- Render-blocking JavaScript/CSS
- Client-side rendering delays

### 2. FCP (First Contentful Paint)

**What it measures:** Time until the first DOM element is painted
**Target:** < 1.8 seconds
**Common elements:** Any text, image, or canvas

**What causes slow FCP:**
- Render-blocking resources (CSS, fonts)
- Large HTML document
- Slow server response
- No content prerendering

### 3. TTI (Time to Interactive)

**What it measures:** Time until page is fully interactive
**Target:** < 3.8 seconds
**Criteria:** Main thread quiet for 5 seconds, event handlers registered

**What causes slow TTI:**
- Heavy JavaScript execution
- Long tasks blocking main thread
- Third-party scripts
- Large bundle sizes

### 4. TBT (Total Blocking Time)

**What it measures:** Sum of all long task durations (>50ms) blocking input
**Target:** < 200 milliseconds
**Impact:** Delays user interactions (clicks, typing, scrolling)

**What causes high TBT:**
- Synchronous JavaScript execution
- Heavy computation on main thread
- Large framework overhead
- Unoptimized third-party code

## Performance Analysis Workflow

### Basic Performance Trace

```
1. navigate_page(url: "https://localhost:3000")
2. wait_for(time: 5)  # Allow page load to complete
3. browser_run_code(code: `
     async (page) => {
       const metrics = await page.evaluate(() => {
         const navigation = performance.getEntriesByType('navigation')[0];
         const paint = performance.getEntriesByType('paint');
         return {
           navigationStart: navigation.startTime,
           domContentLoaded: navigation.domContentLoadedEventEnd,
           loadComplete: navigation.loadEventEnd,
           firstPaint: paint.find(p => p.name === 'first-paint')?.startTime,
           firstContentfulPaint: paint.find(p => p.name === 'first-contentful-paint')?.startTime
         };
       });
       return metrics;
     }
   `)
```

**Returns:**
```json
{
  "navigationStart": 0,
  "domContentLoaded": 450.2,
  "loadComplete": 1234.5,
  "firstPaint": 230.1,
  "firstContentfulPaint": 240.3
}
```

### Automated Performance Command

For quick performance analysis:

```
/chromedev:performance https://localhost:3000
```

This command:
1. Navigates to URL
2. Records performance trace
3. Extracts Core Web Vitals (LCP, FCP, TTI, TBT)
4. Identifies bottlenecks (long tasks, layout shifts)
5. Provides optimization recommendations

## Measuring Core Web Vitals

### LCP Measurement

```
evaluate_script(function: `
  () => {
    return new Promise((resolve) => {
      new PerformanceObserver((list) => {
        const entries = list.getEntries();
        const lastEntry = entries[entries.length - 1];
        resolve({
          lcp: lastEntry.renderTime || lastEntry.loadTime,
          element: lastEntry.element?.tagName,
          url: lastEntry.url
        });
      }).observe({type: 'largest-contentful-paint', buffered: true});
    });
  }
`)
```

**Optimization targets:**
- < 2.5s: Good
- 2.5s - 4s: Needs improvement
- \> 4s: Poor

### FCP Measurement

```
evaluate_script(function: `
  () => {
    const fcp = performance.getEntriesByType('paint')
      .find(entry => entry.name === 'first-contentful-paint');
    return {
      fcp: fcp?.startTime,
      name: fcp?.name
    };
  }
`)
```

**Optimization targets:**
- < 1.8s: Good
- 1.8s - 3s: Needs improvement
- \> 3s: Poor

### TTI Estimation

```
evaluate_script(function: `
  () => {
    const navigation = performance.getEntriesByType('navigation')[0];
    // TTI approximation: when main thread becomes idle after load
    return {
      domInteractive: navigation.domInteractive,
      loadEventEnd: navigation.loadEventEnd,
      estimatedTTI: navigation.loadEventEnd  // Simplified estimate
    };
  }
`)
```

**Optimization targets:**
- < 3.8s: Good
- 3.8s - 7.3s: Needs improvement
- \> 7.3s: Poor

### Long Tasks Detection

```
evaluate_script(function: `
  () => {
    return new Promise((resolve) => {
      const longTasks = [];
      new PerformanceObserver((list) => {
        for (const entry of list.getEntries()) {
          longTasks.push({
            duration: entry.duration,
            startTime: entry.startTime,
            name: entry.name
          });
        }
        // Resolve after 5 seconds of observation
        setTimeout(() => resolve(longTasks), 5000);
      }).observe({type: 'longtask', buffered: true});
    });
  }
`)
```

**Long task threshold:** > 50ms blocks user interaction

## Performance Bottleneck Identification

### Resource Loading Analysis

Check network timing for slow resources:

```
1. navigate_page(url: "https://localhost:3000")
2. wait_for(time: 5)
3. list_network_requests(includeStatic: true)
4. [Filter for slow requests]
```

**Analyze:**
- **Large files** - Images > 100KB, scripts > 200KB
- **Slow responses** - Server time > 200ms
- **Many requests** - > 100 requests indicates over-fetching
- **Blocking resources** - Synchronous scripts, unoptimized CSS

### JavaScript Execution Analysis

Measure script evaluation time:

```
evaluate_script(function: `
  () => {
    const scripts = performance.getEntriesByType('resource')
      .filter(r => r.initiatorType === 'script');
    return scripts.map(s => ({
      name: s.name,
      duration: s.duration,
      transferSize: s.transferSize,
      startTime: s.startTime
    })).sort((a, b) => b.duration - a.duration);
  }
`)
```

**Red flags:**
- Single script > 100ms evaluation
- Total script time > 500ms
- Large bundle sizes > 500KB

### Rendering Performance

Check layout and paint timing:

```
evaluate_script(function: `
  () => {
    const paints = performance.getEntriesByType('paint');
    const navigation = performance.getEntriesByType('navigation')[0];
    return {
      paints: paints.map(p => ({name: p.name, startTime: p.startTime})),
      domContentLoaded: navigation.domContentLoadedEventEnd,
      renderBlocking: navigation.domInteractive - navigation.domLoading
    };
  }
`)
```

**Optimization opportunities:**
- Reduce render-blocking resources
- Minimize critical CSS
- Defer non-critical JavaScript
- Optimize web fonts loading

### Layout Shift Detection

Detect cumulative layout shift (CLS):

```
evaluate_script(function: `
  () => {
    return new Promise((resolve) => {
      let cls = 0;
      new PerformanceObserver((list) => {
        for (const entry of list.getEntries()) {
          if (!entry.hadRecentInput) {
            cls += entry.value;
          }
        }
        setTimeout(() => resolve({cls, count: list.getEntries().length}), 5000);
      }).observe({type: 'layout-shift', buffered: true});
    });
  }
`)
```

**CLS targets:**
- < 0.1: Good
- 0.1 - 0.25: Needs improvement
- \> 0.25: Poor

**Common causes:**
- Images without dimensions
- Dynamic content injection
- Web fonts causing FOUT/FOIT
- Ads/embeds without reserved space

## Performance Optimization Patterns

### Image Optimization

Identify large unoptimized images:

```
evaluate_script(function: `
  () => {
    const images = performance.getEntriesByType('resource')
      .filter(r => r.initiatorType === 'img');
    return images
      .filter(img => img.transferSize > 100000)  // > 100KB
      .map(img => ({
        url: img.name,
        size: img.transferSize,
        duration: img.duration
      }));
  }
`)
```

**Recommendations:**
- Use WebP/AVIF formats
- Implement responsive images (srcset)
- Lazy load off-screen images
- Compress images (80-85% quality)
- Use CDN for image delivery

### JavaScript Bundle Analysis

Analyze script loading:

```
evaluate_script(function: `
  () => {
    const scripts = performance.getEntriesByType('resource')
      .filter(r => r.initiatorType === 'script');
    const totalSize = scripts.reduce((sum, s) => sum + s.transferSize, 0);
    const totalDuration = scripts.reduce((sum, s) => sum + s.duration, 0);
    return {
      scriptCount: scripts.length,
      totalSize,
      totalDuration,
      largest: scripts.sort((a, b) => b.transferSize - a.transferSize)[0]
    };
  }
`)
```

**Recommendations:**
- Code splitting for route-based loading
- Tree shaking to remove unused code
- Minification and compression (gzip/brotli)
- Defer non-critical scripts
- Use dynamic imports for heavy libraries

### CSS Optimization

Check CSS loading performance:

```
evaluate_script(function: `
  () => {
    const stylesheets = performance.getEntriesByType('resource')
      .filter(r => r.initiatorType === 'link' && r.name.includes('.css'));
    return {
      count: stylesheets.length,
      totalSize: stylesheets.reduce((sum, s) => sum + s.transferSize, 0),
      renderBlocking: stylesheets.some(s => s.startTime < 100)
    };
  }
`)
```

**Recommendations:**
- Inline critical CSS
- Defer non-critical stylesheets
- Remove unused CSS
- Minify and compress CSS
- Use CSS containment for large pages

### Font Loading Optimization

Analyze web font loading:

```
evaluate_script(function: `
  () => {
    const fonts = performance.getEntriesByType('resource')
      .filter(r => r.initiatorType === 'css' && r.name.match(/\.(woff2?|ttf|otf)$/));
    return fonts.map(f => ({
      url: f.name,
      size: f.transferSize,
      duration: f.duration,
      startTime: f.startTime
    }));
  }
`)
```

**Recommendations:**
- Use font-display: swap or optional
- Preload critical fonts
- Subset fonts to needed characters
- Use modern formats (WOFF2)
- Consider system fonts for body text

## Real-World Performance Scenarios

### React App Performance

```
1. navigate_page(url: "https://localhost:3000")
2. wait_for(time: 3)
3. # Measure React hydration time
4. evaluate_script(function: `
     () => {
       const hydrationStart = performance.getEntriesByName('React hydration')[0];
       return {
         hydrationTime: hydrationStart?.duration,
         bundleSize: performance.getEntriesByType('resource')
           .filter(r => r.name.includes('react'))
           .reduce((sum, r) => sum + r.transferSize, 0)
       };
     }
   `)
```

**React-specific optimizations:**
- Use React.lazy() for code splitting
- Implement useMemo/useCallback for expensive calculations
- Avoid unnecessary re-renders with React.memo
- Use production build (minified, no dev warnings)
- Consider server-side rendering (SSR) or static generation

### API-Heavy Dashboard

```
1. navigate_page(url: "https://localhost:3000/dashboard")
2. wait_for(time: 5)
3. list_network_requests(includeStatic: false)
4. evaluate_script(function: `
     () => {
       const apiCalls = performance.getEntriesByType('resource')
         .filter(r => r.name.includes('/api/'));
       return {
         apiCallCount: apiCalls.length,
         totalApiTime: apiCalls.reduce((sum, r) => sum + r.duration, 0),
         slowestApi: apiCalls.sort((a, b) => b.duration - a.duration)[0]
       };
     }
   `)
```

**API optimization strategies:**
- Batch related API calls
- Implement request caching
- Use GraphQL for selective field fetching
- Parallelize independent requests
- Add loading states to prevent layout shift

### Image-Heavy Gallery

```
1. navigate_page(url: "https://localhost:3000/gallery")
2. wait_for(time: 5)
3. evaluate_script(function: `
     () => {
       const images = performance.getEntriesByType('resource')
         .filter(r => r.initiatorType === 'img');
       return {
         imageCount: images.length,
         totalImageSize: images.reduce((sum, img) => sum + img.transferSize, 0),
         largestImage: images.sort((a, b) => b.transferSize - a.transferSize)[0],
         averageImageSize: images.reduce((sum, img) => sum + img.transferSize, 0) / images.length
       };
     }
   `)
```

**Image gallery optimizations:**
- Lazy load images below fold
- Use progressive JPEG or modern formats
- Implement virtual scrolling for large galleries
- Add blur-up placeholders
- Optimize thumbnail sizes

## Performance Budgets

### Establishing Budgets

Set performance budgets based on metrics:

**Time-based budgets:**
- FCP < 1.8s
- LCP < 2.5s
- TTI < 3.8s
- TBT < 200ms

**Size-based budgets:**
- Total JavaScript < 300KB (gzipped)
- Total CSS < 50KB (gzipped)
- Total images < 500KB (per page)
- Total page weight < 1MB

**Request-based budgets:**
- Total requests < 50
- JavaScript files < 10
- CSS files < 5
- Font files < 5

### Monitoring Budgets

Check if page meets budgets:

```
evaluate_script(function: `
  () => {
    const resources = performance.getEntriesByType('resource');
    const jsSize = resources
      .filter(r => r.initiatorType === 'script')
      .reduce((sum, r) => sum + r.transferSize, 0);
    const cssSize = resources
      .filter(r => r.initiatorType === 'link' && r.name.includes('.css'))
      .reduce((sum, r) => sum + r.transferSize, 0);
    const imgSize = resources
      .filter(r => r.initiatorType === 'img')
      .reduce((sum, r) => sum + r.transferSize, 0);

    return {
      javascript: {size: jsSize, budget: 300000, overBudget: jsSize > 300000},
      css: {size: cssSize, budget: 50000, overBudget: cssSize > 50000},
      images: {size: imgSize, budget: 500000, overBudget: imgSize > 500000},
      totalRequests: {count: resources.length, budget: 50, overBudget: resources.length > 50}
    };
  }
`)
```

## Performance Testing Checklist

**Before testing:**
- [ ] Clear browser cache for fresh load
- [ ] Test on realistic network conditions
- [ ] Use production build (not development)
- [ ] Test with browser extensions disabled

**Metrics to measure:**
- [ ] FCP (First Contentful Paint) < 1.8s
- [ ] LCP (Largest Contentful Paint) < 2.5s
- [ ] TTI (Time to Interactive) < 3.8s
- [ ] TBT (Total Blocking Time) < 200ms
- [ ] CLS (Cumulative Layout Shift) < 0.1

**Resources to analyze:**
- [ ] JavaScript bundle sizes and loading time
- [ ] CSS file sizes and render blocking
- [ ] Image sizes and loading strategy
- [ ] Font loading performance
- [ ] API call counts and timing

**Bottlenecks to identify:**
- [ ] Long tasks blocking main thread (> 50ms)
- [ ] Slow network requests (> 1000ms)
- [ ] Large resources (> 100KB uncompressed)
- [ ] Many requests (> 50 total)
- [ ] Layout shifts (CLS > 0.1)

## Summary

Use the `/chromedev:performance <url>` command for automated performance analysis with Core Web Vitals and optimization recommendations.

For custom analysis:
1. Measure Core Web Vitals (LCP, FCP, TTI, TBT, CLS)
2. Identify bottlenecks (resources, JavaScript, rendering)
3. Analyze specific areas (images, bundles, fonts, APIs)
4. Compare against performance budgets
5. Implement optimizations based on findings

Focus on user-centric metrics (Core Web Vitals) rather than just page load time. Optimize for perceived performance and actual interactivity.

Test performance in realistic conditions:
- Production builds
- Typical network speeds
- Representative devices
- Real user patterns

Monitor performance continuously and catch regressions early through automated performance testing.
