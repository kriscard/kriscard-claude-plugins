---
name: react-best-practices
description: "React: Use when auditing React components for performance, re-renders, or bundle size. NOT for Vue, Angular, or general TypeScript."
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

## Quick Reference

For detailed rule explanations with code examples, see:
- `references/vercel-rules.md` - All 57 rules with incorrect/correct patterns

## Attribution

Rules sourced from Vercel Engineering's React performance guidelines.
