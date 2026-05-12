---
name: react-patterns
description: >-
  Audits React and Next.js code for useEffect anti-patterns, unnecessary
  re-renders, memoization issues, bundle size, modal/portal positioning and
  stacking context bugs, rendering model choice (SSR/CSR/SSG/RSC), Server
  Actions misuse, hydration mismatches, and 57 prioritized performance rules.
  Make sure to use this skill whenever the user asks to review React or Next.js
  code, audit performance, check useEffect smells, reduce bundle size, debug
  re-renders, fix modal/dialog z-index issues, choose a rendering strategy, or
  asks about Server Components and Server Actions — even if they just say "is
  my React code good?"
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/page.tsx"
  - "**/layout.tsx"
  - "**/use*.ts"
---

# React Best Practices Audit

Comprehensive React/Next.js audit guide. Combines Vercel Engineering's 57 prioritized rules with thematic deep-dives on effects, re-renders, perf investigation, portals, and rendering models.

## Universal Checks (always run these)

For **any** React audit, regardless of size or specific intent, check these six universal pitfalls. These are the highest-leverage bugs and they reliably appear across codebases. Don't skip them even on a short review — they take seconds to scan for and catch the most common mistakes.

1. **Components defined inside other components** — they're re-created every render, lose all memoization and state. Extract them.
2. **Array index as `key` in dynamic lists** — breaks identity tracking on insert/delete/reorder. Use stable IDs. (Acceptable only for genuinely static lists.)
3. **Derived state via `useState` + `useEffect`** — compute during render instead. See `useeffect-antipatterns.md` for the full pattern.
4. **Fetching data inside `useEffect` without cleanup** — race conditions corrupt state. Prefer TanStack Query, framework loaders, or RSC. If you must keep the effect, use an `ignore` flag for cleanup.
5. **Unmemoized Context provider value** — every consumer re-renders on every parent render. Wrap in `useMemo`, or split data/API into separate providers.
6. **Server Actions for client-side data reads** — they serialize requests and kill parallelism. Use REST + TanStack Query for reads; reserve Server Actions for mutations.

These six should fire on every audit. Anything more specific routes to a deep-dive reference below.

## When to Use

This skill triggers when you need to:
- Check if code follows React best practices
- Audit a component for performance issues
- Review React/Next.js code quality
- Find optimization opportunities
- Validate patterns before shipping

## Trigger Phrases

- "check react best practices"
- "audit this component"
- "review for performance"
- "does this follow best practices"
- "optimize this React code"
- "check for waterfalls"
- "bundle size issues"
- "why does this re-render"
- "this modal appears behind"
- "should I use SSR or CSR"
- "is this useEffect right"

## Audit Process

### 1. Identify Code Scope

Determine what's being audited:
- Single component, page, or feature
- React (client) vs Next.js (RSC, Server Actions)
- Critical path vs non-critical code

### 2. Check by Priority

**CRITICAL - Eliminating Waterfalls:**
- [ ] No sequential awaits that could be parallel
- [ ] Dependencies used for parallelization
- [ ] API routes don't chain awaits unnecessarily
- [ ] Promise.all for independent operations
- [ ] Strategic Suspense boundaries

**CRITICAL - Bundle Size:**
- [ ] Direct imports (no barrel files)
- [ ] Dynamic imports for heavy components
- [ ] Conditional module loading
- [ ] Non-critical libs deferred
- [ ] Preload based on user intent

**HIGH - Server-Side Performance:**
- [ ] Server Actions have authentication
- [ ] RSC props minimized (only needed data)
- [ ] Parallel data fetching via composition
- [ ] React.cache() for per-request dedup
- [ ] Cross-request caching where appropriate
- [ ] after() for non-blocking operations
- [ ] No duplicate serialization

**MEDIUM-HIGH - Client Data Fetching:**
- [ ] SWR for automatic deduplication
- [ ] Passive event listeners for scroll
- [ ] Global event listeners deduplicated
- [ ] localStorage versioned and minimal

**MEDIUM - Re-render Optimization:**
- [ ] Functional setState updates (no stale closures)
- [ ] Lazy state initialization for expensive values
- [ ] Narrow effect dependencies (primitives > objects)
- [ ] useTransition for non-urgent updates
- [ ] Defer state reads to usage point
- [ ] Subscribe to derived state only
- [ ] Extract to memoized components
- [ ] No unnecessary useMemo wrapping
- [ ] Default params extracted to constants
- [ ] Derived state calculated during render (not useEffect)
- [ ] Interaction logic in event handlers (not state + effect)
- [ ] useRef for transient values (mouse trackers, intervals)

**MEDIUM - Rendering Performance:**
- [ ] content-visibility for long lists
- [ ] Hoist static JSX elements
- [ ] useTransition over manual loading states
- [ ] Activity component for show/hide
- [ ] Explicit conditional rendering
- [ ] Prevent hydration mismatch without flickering
- [ ] suppressHydrationWarning for known server/client differences
- [ ] Animate SVG wrapper (not element itself)
- [ ] SVG precision optimized

**LOW-MEDIUM - JavaScript Performance:**
- [ ] Set/Map for O(1) lookups
- [ ] Early returns in functions
- [ ] Cached repeated function calls
- [ ] toSorted() over sort() for immutability
- [ ] Index maps for repeated lookups
- [ ] Cache property access in loops
- [ ] Combine multiple array iterations
- [ ] Early length check for array comparisons
- [ ] Avoid layout thrashing
- [ ] Hoist RegExp creation
- [ ] Cache storage API calls
- [ ] Loop for min/max (not sort)

**LOW - Advanced Patterns:**
- [ ] Event handlers in refs for stable references
- [ ] useEffectEvent for stable callback refs
- [ ] App initialization with module-level guards (not useEffect)

### 3. Report Format

For each violation found:

```
[PRIORITY] Rule Name
File: path/to/file.tsx:line
Issue: [description of the problem]
Fix: [code example showing correct pattern]
```

### 4. Summary Output

After checking all rules, provide:

1. **Violation Count by Priority**
   - CRITICAL: X violations
   - HIGH: X violations
   - MEDIUM: X violations
   - LOW: X violations

2. **Top 3 Highest-Impact Fixes**
   - Brief description of each fix
   - Expected improvement

3. **Overall Assessment**
   - Pass/Needs Work/Critical Issues
   - Estimated performance improvement if all fixes applied

## Deep-Dive References

The audit checklist above is the always-check baseline. For deeper analysis, **load only the reference(s) that match the user's intent** — don't load all of them, and don't load any unless the intent matches.

### Conceptual / framework references

| User mentions / intent | Load this reference |
|---|---|
| `useEffect`, side effects, "do I need an effect", stale closures, flicker after measurement | `references/useeffect-antipatterns.md` |
| Re-renders, `useMemo`/`useCallback`/`React.memo`, React Compiler, "why does this re-render", prop reference identity | `references/re-renders-and-memoization.md` |
| Bundle size investigation, "slow initial load", flame graph, profiling workflow, Web Vitals | `references/bundle-and-perf-investigation.md` |
| Modal, dialog, tooltip, popover, dropdown, z-index, "appears behind the header", portal | `references/portals-and-stacking-context.md` |
| SSR, CSR, SSG, ISR, RSC choice, hydration mismatch, rendering model decision | `references/rendering-models.md` |

### Rule-level references (sourced from Vercel Engineering's 57 rules)

| User mentions / intent | Load this reference |
|---|---|
| Sequential awaits, parallel data fetching, Suspense streaming, waterfall chains | `references/waterfalls.md` (5 rules) |
| Barrel imports, dynamic imports, third-party script weight, preload on intent | `references/bundle-optimization.md` (5 rules) |
| Server Actions, RSC serialization, `React.cache`, LRU caching, `after()` | `references/server-and-rsc.md` (7 rules) |
| SWR / TanStack Query deduplication, scroll/touch listeners, `localStorage` versioning | `references/client-fetching.md` (4 rules) |
| Concrete re-render rules (functional setState, narrow deps, transitions, lazy init, derived state) | `references/re-render-patterns.md` (12 rules) |
| Hydration handling, `content-visibility`, SVG perf, `useTransition` for UI pending states | `references/rendering-performance.md` (9 rules) |
| JS micro-optimizations (layout thrashing, Set/Map, `toSorted`, RegExp hoisting, `useEffectEvent`) | `references/javascript-performance.md` (15 rules) |

### Routing rules

- If multiple intents match, load them in **order of specificity** (most-specific first)
- The conceptual references contain frameworks/why; the rule references contain concrete code patterns — they complement each other
- **Conceptual vs. rule-level — discriminator:** if the user asks *"should I do X?"*, *"is this a good pattern?"*, *"do I need to wrap this in useMemo?"* — that's a **rule-level** question → load the corresponding rule-level file. If they ask *"why does this re-render?"*, *"why isn't React.memo working?"*, *"how does the Compiler change this?"* — that's **conceptual** → load the conceptual file. When in doubt, load both.
- The audit checklist above remains the always-check baseline regardless of which references load

## Attribution

Priority checklist + rule-level references sourced from Vercel Engineering's React performance guidelines. Conceptual references additionally draw on react.dev, Nadia Makarevich (developerway), TkDodo, Kent C. Dodds (Epic Web), and patterns.dev.
