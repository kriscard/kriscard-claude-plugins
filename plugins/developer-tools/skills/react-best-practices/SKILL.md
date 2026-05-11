---
name: react-best-practices
description: >-
  Audits React and Next.js components for performance issues, unnecessary
  re-renders, bundle size problems, and waterfall patterns using 57 rules organized
  by priority. Make sure to use this skill whenever the user asks to review React or
  Next.js code, check performance, optimize rendering, reduce bundle size, or
  mentions re-renders — even if they just say "is my React code good?"
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/page.tsx"
  - "**/layout.tsx"
  - "**/use*.ts"
---

# React Best Practices Audit

Performance optimization guide for React and Next.js, maintained by Vercel Engineering. 57 actionable rules organized by priority.

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

| User mentions / intent | Load this reference | What it covers |
|---|---|---|
| `useEffect`, side effects, "do I need an effect", stale closures, flicker after measurement | `references/useeffect-antipatterns.md` | 12 canonical anti-patterns from react.dev, the stale-closure ref-trick, `useLayoutEffect` for DOM measurements, ESLint rule mapping |
| Re-renders, `useMemo`, `useCallback`, `React.memo`, React Compiler, "why does this re-render", prop reference identity | `references/re-renders-and-memoization.md` | Nadia's 4-category taxonomy, the chain rule, prop-identity teaching (`<Child onClick={() => ...} />`), Compiler era guidance |
| Bundle size, lazy loading, code splitting, "slow initial load", flame graph, profiling, Web Vitals | `references/bundle-and-perf-investigation.md` | Bundle investigation workflow, common culprits checklist (wildcard imports, non-ESM, duplicates), DevTools flame graph workflow |
| Modal, dialog, tooltip, popover, dropdown, z-index, "appears behind the header", portal | `references/portals-and-stacking-context.md` | Stacking context trap, properties that create new contexts, the form-submission gotcha, native `<dialog>` vs portal |
| SSR, CSR, SSG, ISR, RSC, Server Components, Server Actions, hydration mismatch, rendering choice | `references/rendering-models.md` | CSR/SSR/SSG/RSC decision framework, Nadia's SSR perf paradox, hydration pitfalls, Server Actions for mutations only |
| Full audit, comprehensive review, "check every rule" | `references/vercel-rules.md` | All 57 rules with incorrect/correct code examples (Vercel Engineering) |

If multiple intents match, load them in order of specificity (most-specific first). The audit checklist above remains the always-check baseline regardless of which references load.

## Attribution

Priority checklist sourced from Vercel Engineering's React performance guidelines. Deep-dive references additionally draw on react.dev, Nadia Makarevich (developerway), TkDodo, Kent C. Dodds (Epic Web), and patterns.dev.
