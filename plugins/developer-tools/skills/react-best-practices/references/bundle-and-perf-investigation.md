# Bundle Size & Performance Investigation

Concrete diagnostic workflows from Nadia Makarevich's [bundle investigation](https://www.developerway.com/posts/bundle-size-investigation) and [flame graph](https://www.developerway.com/posts/client-side-rendering-flame-graph) posts.

## Bundle size investigation

### Tools

| Bundler | Analyzer |
|---|---|
| Vite | [Rollup Plugin Visualizer](https://github.com/btd/rollup-plugin-visualizer) |
| Next.js | [`@next/bundle-analyzer`](https://www.npmjs.com/package/@next/bundle-analyzer) |
| Webpack | `webpack-bundle-analyzer` |
| Rspack | Built-in via `rsdoctor` |

Generate the treemap. The visualization is the starting point — everything else is detective work.

### Workflow

```
1. Open the analyzer → find a suspicious large rectangle
2. Identify what the package does (npm search, the source repo)
3. Search the codebase for actual usage (grep imports)
4. Confirm it's the culprit by temporarily removing imports + rebuilding
5. Replace, tree-shake, or lazy-load
```

### Common culprits

| Culprit | Diagnosis | Fix |
|---|---|---|
| **Wildcard imports** breaking tree-shaking | `import * as MUI from '@mui/material'` bundles the whole library | Named imports: `import { Button } from '@mui/material'` |
| **Non-ESM libraries** | Check with `npx is-esm <pkgname>` — CommonJS can't be tree-shaken cleanly | Look for an ESM-compatible alternative or use dynamic import |
| **Duplicate libs** | `moment` + `luxon` + `date-fns` all bundled. Or Emotion + Tailwind. | Pick one. Migrate the legacy usages. |
| **Transitive dependencies** | A peer dep pulls in something unwanted. Trace with `npx npm-why <pkgname>` | Lock to a version that excludes it, or replace the dependent |
| **Unused exports** | Entire component library bundled for a few pieces | Use cherry-picked imports or `babel-plugin-import` / Vite-equivalent |
| **Polyfills for old browsers** | Old `@babel/preset-env` config or autoprefixer settings | Update target browser config (`browserslist`) |
| **Source maps in production** | Visible in browser even if not "loaded" — but they ship | Disable in prod build or use hidden-source-maps |
| **Locale data** (date-fns, intl libs) | Every locale bundled when you only use one | Cherry-pick locales |

### Useful CLI checks

```bash
# Is this package ESM?
npx is-esm <packagename>

# Why is this package in my dependency tree?
npx npm-why <packagename>

# How big is this package + its deps?
npx bundle-phobia <packagename>

# Find duplicate packages
pnpm dedupe   # or npm dedupe
```

### Code-splitting levers

- **Route-based**: framework default (Next.js, TanStack Router, React Router data routers)
- **Component-based**: `React.lazy()` + `Suspense`
- **Visibility-based** (Intersection Observer): load when scrolled into view
- **Interaction-based**: load on hover/focus before click

```jsx
// Lazy load a heavy component
const HeavyChart = lazy(() => import('./HeavyChart'));

<Suspense fallback={<Skeleton />}>
  <HeavyChart data={data} />
</Suspense>
```

---

## Flame graph investigation (React DevTools Profiler)

For runtime perf — figuring out *why* a render is slow.

### Setup

1. **Open DevTools in an incognito window** — browser extensions add huge amounts of noise. A clean incognito profile produces dramatically clearer flame graphs.
2. **Enable CPU throttling** in the Performance panel (4x or 6x slowdown). Bars become wide enough to read.
3. **Use the React Profiler** (separate from the browser Performance panel) for React-specific signal: which components rendered, why, and how long each took.

### What to look for

- **Total time vs self time**:
  - *Total*: this component + everything it rendered
  - *Self*: just this component's work
  - A high total / low self means a child is slow — drill in
  - A high self means this component itself is doing too much

- **Render triggers**: in the Profiler, the "Why did this render?" panel tells you (state change, prop change, parent re-render, context, hooks). This is what react-scan visualizes live on the page.

- **Cascade renders**: many narrow bars in sequence usually means a chain of `setState` in effects — see `useeffect-antipatterns.md`.

- **Wide bars at the top**: hydration or initial JS execution — bundle size problem, not a render problem.

### Workflow

```
1. Record a profile during the slow interaction
2. Find the longest bar in the React Profiler
3. Click → "Why did this render?" → understand the trigger
4. Drill into total vs self time
5. Decide: split the component, memoize, move state down, or skip the render entirely
```

### Decision: what to fix

| Symptom | Likely cause | Reference |
|---|---|---|
| Many components re-render on every keystroke | State too high; everything below reads it | `re-renders-and-memoization.md` (§Parent re-renders) |
| Re-renders on Context change | Provider value not memoized, or single context too broad | `re-renders-and-memoization.md` (§Context) |
| Component re-renders despite same props | Not wrapped in `React.memo`, or some prop unmemoized | `re-renders-and-memoization.md` (§Chain rule) |
| Slow on initial load, fine after | Bundle size or hydration | This file (§Bundle investigation) |
| Slow only on a specific interaction | Render cost on that path | Profile, then memoize the render tree |
| Flicker before adjustment | DOM measurement in `useEffect` | `useeffect-antipatterns.md` (§useLayoutEffect) |

---

## Web Vitals targets (2026)

- **LCP** (Largest Contentful Paint): **< 2.5s**
- **INP** (Interaction to Next Paint): **< 200ms**
- **CLS** (Cumulative Layout Shift): **< 0.1**
- **TTFB** (Time to First Byte): **< 800ms**

Measure in production with real users — synthetic Lighthouse runs miss long-tail issues.

## Further reading

- [Nadia — Bundle size investigation](https://www.developerway.com/posts/bundle-size-investigation)
- [Nadia — Client-side rendering flame graph](https://www.developerway.com/posts/client-side-rendering-flame-graph)
- [Nadia — How to write performant React code](https://www.developerway.com/posts/how-to-write-performant-react-code)
- [web.dev — Core Web Vitals](https://web.dev/vitals)
- [react-scan](https://github.com/aidenybai/react-scan) — runtime re-render detection
- [react-doctor](https://github.com/millionco/react-doctor) — static analysis with health score
