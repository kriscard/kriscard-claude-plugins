# MEDIUM: Re-render Optimization Patterns

> **Read this when** the user asks a *concrete code-level rule question* such as:
> - *"Should I wrap this in `useMemo`?"* / *"Do I need `useCallback` here?"*
> - *"Is this a good pattern?"* / *"What's the rule for X?"*
> - Any request for a specific rule to follow, not the underlying theory.
>
> Also covers: functional setState, narrow deps, lazy init, transitions, derived state.
>
> **Not the right file?** For *conceptual frameworks* (chain rule, Compiler era guidance, prop reference identity, "why does this re-render?") → `re-renders-and-memoization.md`. This file has the concrete rules; the other has the mental models.

12 code-level rules for preventing unnecessary re-renders.

## 22. Defer state reads to usage point

Read state in the component that uses it, not in parents.

```tsx
// ❌ Parent reads state, passes down → parent re-renders too
function Parent() {
  const count = useStore(state => state.count)
  return <Child count={count} />
}

// ✅ Child reads its own state → parent unaffected
function Parent() {
  return <Child />
}

function Child() {
  const count = useStore(state => state.count)
  return <span>{count}</span>
}
```

## 23. Don't wrap simple expressions in useMemo

`useMemo` has overhead; don't use it for trivial computations.

```tsx
// ❌ Unnecessary memoization
const count = useMemo(() => items.length, [items])
const hasItems = useMemo(() => items.length > 0, [items])
const label = useMemo(() => `${count} items`, [count])

// ✅ Direct computation is faster
const count = items.length
const hasItems = count > 0
const label = `${count} items`
```

## 24. Extract default non-primitive params to constants

Non-primitive default values create new references each render.

```tsx
// ❌ New object/array reference every render
function Component({
  options = { sort: true, filter: false },
  items = [],
}) {
  useEffect(() => {
    // Runs every render because options is new object
  }, [options])
}

// ✅ Stable references
const DEFAULT_OPTIONS = { sort: true, filter: false }
const DEFAULT_ITEMS: Item[] = []

function Component({
  options = DEFAULT_OPTIONS,
  items = DEFAULT_ITEMS,
}) {
  useEffect(() => {
    // Only runs when options actually changes
  }, [options])
}
```

## 25. Extract to memoized components

Move expensive children to memoized components.

```tsx
const MemoizedVisualization = memo(ExpensiveVisualization)

function Parent() {
  const [count, setCount] = useState(0)
  return (
    <div>
      <button onClick={() => setCount(c => c + 1)}>{count}</button>
      <MemoizedVisualization data={staticData} />
    </div>
  )
}
```

## 26. Narrow effect dependencies

Use primitive values in dependencies, not objects.

```tsx
// ❌ Effect runs when any user property changes
useEffect(() => {
  trackPageView(user.id)
}, [user])

// ✅ Only runs when id changes
const userId = user.id
useEffect(() => {
  trackPageView(userId)
}, [userId])
```

## 27. Subscribe to derived state

Don't select entire state when you need a derived value.

```tsx
// ❌ Re-renders on any cart change
const cart = useStore(state => state.cart)
return <Badge count={cart.items.length} />

// ✅ Only re-renders when count changes
const itemCount = useStore(state => state.cart.items.length)
return <Badge count={itemCount} />
```

## 28. Use functional setState updates

Avoid stale closure issues with functional updates.

```tsx
// ❌ Stale closure — all three see same count
const incrementThree = () => {
  setCount(count + 1)
  setCount(count + 1)
  setCount(count + 1) // Result: count + 1
}

// ✅ Functional update — always latest value
const incrementThree = () => {
  setCount(c => c + 1)
  setCount(c => c + 1)
  setCount(c => c + 1) // Result: count + 3
}
```

## 29. Use lazy state initialization

Initialize expensive state values lazily.

```tsx
// ❌ Computes every render
const [content, setContent] = useState(parseMarkdown(initialText))

// ✅ Computes only on initial render
const [content, setContent] = useState(() => parseMarkdown(initialText))
```

## 30. Use transitions for non-urgent updates

Mark non-critical updates as transitions to keep input responsive.

```tsx
// ❌ Search blocks input
const handleChange = (e) => {
  setQuery(e.target.value)
  setResults(expensiveSearch(e.target.value))
}

// ✅ Search doesn't block input
const [isPending, startTransition] = useTransition()

const handleChange = (e) => {
  setQuery(e.target.value)
  startTransition(() => {
    setResults(expensiveSearch(e.target.value))
  })
}
```

## 31. Calculate derived state during rendering

Don't store computed values in state or sync them via effects.

```tsx
// ❌ Derived state in useEffect
useEffect(() => {
  setFullName(firstName + ' ' + lastName)
}, [firstName, lastName])

// ✅ Calculate during render
const fullName = firstName + ' ' + lastName
```

See `useeffect-antipatterns.md` for the broader pattern.

## 32. Put interaction logic in event handlers

Don't model user actions as state + effect.

```tsx
// ❌ State + effect for user action
const [submitted, setSubmitted] = useState(false)
useEffect(() => {
  if (submitted) sendAnalytics('form_submit')
}, [submitted, theme]) // Re-runs when theme changes!

// ✅ Side effect in handler
const handleSubmit = () => {
  sendAnalytics('form_submit')
}
```

## 33. Use useRef for transient values

Store frequently-changing values in refs when re-renders are undesirable.

```tsx
// ❌ useState causes re-render on every mouse move
const [x, setX] = useState(0)
useEffect(() => {
  const handler = (e) => setX(e.clientX)
  window.addEventListener('mousemove', handler)
  return () => window.removeEventListener('mousemove', handler)
}, [])
return <div style={{ transform: `translateX(${x}px)` }} />

// ✅ useRef avoids re-renders
const xRef = useRef(0)
const elRef = useRef<HTMLDivElement>(null)
useEffect(() => {
  const handler = (e) => {
    xRef.current = e.clientX
    if (elRef.current) {
      elRef.current.style.transform = `translateX(${xRef.current}px)`
    }
  }
  window.addEventListener('mousemove', handler)
  return () => window.removeEventListener('mousemove', handler)
}, [])
return <div ref={elRef} />
```

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
