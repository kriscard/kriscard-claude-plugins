# LOW: JavaScript Performance & Advanced Patterns

> **Read this when:** the user is optimizing tight inner loops, hot paths, RegExp, array iteration, lookup performance, or wants advanced callback-ref / `useEffectEvent` patterns. These are micro-optimizations — measure first.
>
> **Not the right file?** For React-specific re-render concerns → `re-render-patterns.md`. For diagnosing where the slowness actually lives → `bundle-and-perf-investigation.md`.

15 rules: JavaScript micro-optimizations that add up in hot paths, plus 3 advanced patterns. Don't apply speculatively — measure first.

## 43. Avoid layout thrashing

Batch reads and writes to DOM.

```tsx
// ❌ Interleaved read/write — forces layout each iteration
elements.forEach(el => {
  const height = el.offsetHeight
  el.style.height = `${height + 10}px`
})

// ✅ Batch reads, then writes
const heights = elements.map(el => el.offsetHeight)
elements.forEach((el, i) => {
  el.style.height = `${heights[i] + 10}px`
})
```

## 44. Build index maps for repeated lookups

Create lookup maps for repeated finds.

```tsx
// ❌ O(n) lookup each time
users.forEach(user => {
  const post = posts.find(p => p.userId === user.id)
})

// ✅ O(1) lookup with map
const postsByUser = new Map(posts.map(p => [p.userId, p]))
users.forEach(user => {
  const post = postsByUser.get(user.id)
})
```

## 45. Cache property access in loops

Extract property access outside loops.

```tsx
// ❌
for (let i = 0; i < array.length; i++) {
  process(array[i], config.settings.threshold)
}

// ✅
const { length } = array
const { threshold } = config.settings
for (let i = 0; i < length; i++) {
  process(array[i], threshold)
}
```

## 46. Cache repeated function calls

Don't call same function multiple times with same args.

```tsx
// ❌
if (expensiveCheck(data) && otherCondition) {
  doSomething(expensiveCheck(data))
}

// ✅
const checkResult = expensiveCheck(data)
if (checkResult && otherCondition) {
  doSomething(checkResult)
}
```

## 47. Cache storage API calls

localStorage / sessionStorage calls are synchronous and slow.

```tsx
// ❌ Multiple storage calls
function getSettings() {
  return {
    theme: localStorage.getItem('theme'),
    lang: localStorage.getItem('lang'),
    fontSize: localStorage.getItem('fontSize'),
  }
}

// ✅ Single parse
function getSettings() {
  const stored = localStorage.getItem('settings')
  return stored ? JSON.parse(stored) : defaultSettings
}
```

## 48. Combine multiple array iterations

Reduce iterations over large arrays.

```tsx
// ❌ Three iterations
const active = users.filter(u => u.active)
const names = active.map(u => u.name)
const sorted = names.sort()

// ✅ Single iteration + sort
const names = users
  .reduce((acc, u) => {
    if (u.active) acc.push(u.name)
    return acc
  }, [])
  .sort()
```

## 49. Early length check for array comparisons

```tsx
// ❌ Deep compare without length guard
function arraysEqual(a, b) {
  return a.every((item, i) => item === b[i])
}

// ✅ Length check first
function arraysEqual(a, b) {
  if (a.length !== b.length) return false
  return a.every((item, i) => item === b[i])
}
```

## 50. Early return from functions

Exit early to avoid unnecessary computation.

```tsx
// ❌ Nested conditions
function process(data) {
  if (data) {
    if (data.items) {
      if (data.items.length > 0) {
        return data.items.map(transform)
      }
    }
  }
  return []
}

// ✅ Early returns
function process(data) {
  if (!data?.items?.length) return []
  return data.items.map(transform)
}
```

## 51. Hoist RegExp creation

Don't create RegExp in loops or hot paths.

```tsx
// ❌
function validate(input) {
  return /^[a-zA-Z0-9]+$/.test(input)
}

// ✅
const ALPHANUMERIC = /^[a-zA-Z0-9]+$/

function validate(input) {
  return ALPHANUMERIC.test(input)
}
```

## 52. Use loop for min/max instead of sort

Don't sort just to find min/max.

```tsx
// ❌ O(n log n)
const max = numbers.sort((a, b) => b - a)[0]

// ✅ O(n)
const max = Math.max(...numbers)
// Or for very large arrays:
const max = numbers.reduce((m, n) => n > m ? n : m, -Infinity)
```

## 53. Use Set/Map for O(1) lookups

```tsx
// ❌ O(n*m)
const activeIds = users.filter(u => u.active).map(u => u.id)
posts.filter(p => activeIds.includes(p.userId))

// ✅ O(n)
const activeIds = new Set(users.filter(u => u.active).map(u => u.id))
posts.filter(p => activeIds.has(p.userId))
```

## 54. Use toSorted() instead of sort()

Prefer immutable sort to avoid mutation.

```tsx
// ❌ Mutates original array
const sorted = items.sort((a, b) => a.name.localeCompare(b.name))

// ✅ Returns new array
const sorted = items.toSorted((a, b) => a.name.localeCompare(b.name))
```

---

## Advanced Patterns (3 rules)

## 55. Store event handlers in refs

Avoid recreating handlers that don't need to change.

```tsx
// ❌ Effect re-runs when onScroll identity changes
function Scroller({ onScroll }) {
  useEffect(() => {
    window.addEventListener('scroll', onScroll)
    return () => window.removeEventListener('scroll', onScroll)
  }, [onScroll])
}

// ✅ Stable ref
function Scroller({ onScroll }) {
  const onScrollRef = useRef(onScroll)
  onScrollRef.current = onScroll

  useEffect(() => {
    const handler = () => onScrollRef.current()
    window.addEventListener('scroll', handler)
    return () => window.removeEventListener('scroll', handler)
  }, [])
}
```

See `useeffect-antipatterns.md` (§Stale closure ref-trick) for the full derivation.

## 56. useEffectEvent for stable callback refs

For experimental React API — use `useEffectEvent` for callbacks that shouldn't trigger effect re-runs.

```tsx
// ❌ Effect re-runs when onTick changes
function Timer({ onTick }) {
  useEffect(() => {
    const id = setInterval(onTick, 1000)
    return () => clearInterval(id)
  }, [onTick])
}

// ✅ useEffectEvent (experimental)
function Timer({ onTick }) {
  const tick = useEffectEvent(onTick)

  useEffect(() => {
    const id = setInterval(tick, 1000)
    return () => clearInterval(id)
  }, [])
}
```

## 57. Initialize app once, not per mount

Don't place app-wide initialization in `useEffect([])` — components can remount.

```tsx
// ❌ Runs on every mount (twice in StrictMode)
function App() {
  useEffect(() => {
    loadFromStorage()
    checkAuthToken()
  }, [])
}

// ✅ Module-level guard
let didInit = false

function App() {
  useEffect(() => {
    if (didInit) return
    didInit = true
    loadFromStorage()
    checkAuthToken()
  }, [])
}
```

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
