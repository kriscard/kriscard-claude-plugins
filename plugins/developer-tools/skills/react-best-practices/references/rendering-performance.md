# MEDIUM: Rendering Performance

> **Read this when:** the user mentions hydration mismatch, layout shift, slow lists, SVG animation, content-visibility, `useTransition` for pending states, or hiding/showing UI without losing state.
>
> **Not the right file?** For choosing CSR vs SSR vs RSC (architectural rendering models) → `rendering-models.md`. For re-render specifically → `re-render-patterns.md`.

9 rules for optimizing what and how React renders.

## 34. Animate SVG wrapper instead of SVG element

Animating SVG elements is expensive; animate a wrapper instead.

```tsx
// ❌
<motion.svg animate={{ rotate: 360 }}>
  <ComplexPath />
</motion.svg>

// ✅
<motion.div animate={{ rotate: 360 }}>
  <svg>
    <ComplexPath />
  </svg>
</motion.div>
```

## 35. CSS content-visibility for long lists

Use CSS `content-visibility` to skip rendering off-screen items.

```tsx
// ✅ Off-screen items skipped
<ul className="list-container">
  {items.map(item => (
    <li
      key={item.id}
      style={{ contentVisibility: 'auto', containIntrinsicSize: '0 50px' }}
    >
      <ListItem item={item} />
    </li>
  ))}
</ul>
```

For very large lists, prefer virtualization (`react-window`, `tanstack-virtual`).

## 36. Hoist static JSX elements

Move static elements outside components.

```tsx
// ❌ Icon recreated every render
function Button({ onClick, children }) {
  return (
    <button onClick={onClick}>
      <svg viewBox="0 0 24 24"><path d="..." /></svg>
      {children}
    </button>
  )
}

// ✅ Static JSX hoisted
const Icon = <svg viewBox="0 0 24 24"><path d="..." /></svg>

function Button({ onClick, children }) {
  return (
    <button onClick={onClick}>
      {Icon}
      {children}
    </button>
  )
}
```

## 37. Optimize SVG precision

Reduce SVG path precision for smaller files.

```tsx
// ❌ Excessive precision
<path d="M12.000000 24.000000 L36.123456 48.789012" />

// ✅ Reasonable precision
<path d="M12 24 L36.12 48.79" />
```

## 38. Prevent hydration mismatch without flickering

Handle client-only values without layout shift.

```tsx
// ❌ Hydration mismatch
function Timestamp({ date }) {
  return <span>{date.toLocaleString()}</span>
}

// ✅ Fallback + suppress warning for known difference
function Timestamp({ date }) {
  const [formatted, setFormatted] = useState<string>()

  useEffect(() => {
    setFormatted(date.toLocaleString())
  }, [date])

  return (
    <span suppressHydrationWarning>
      {formatted ?? date.toISOString()}
    </span>
  )
}
```

## 39. Suppress expected hydration mismatches

For known server/client differences (timestamps, random IDs), suppress warnings explicitly.

```tsx
<span suppressHydrationWarning>
  {new Date().toLocaleString()}
</span>
```

**Note:** Only use for known differences. Don't mask real bugs.

## 40. Use show/hide pattern to preserve state

```tsx
// ❌ Unmounting loses state
{activeTab === 'settings' && <Settings />}
{activeTab === 'profile' && <Profile />}

// ✅ State preserved via display toggle
<div style={{ display: activeTab === 'settings' ? 'block' : 'none' }}>
  <Settings />
</div>
<div style={{ display: activeTab === 'profile' ? 'block' : 'none' }}>
  <Profile />
</div>
```

(React's experimental `<Activity>` component formalizes this pattern.)

## 41. Use explicit conditional rendering

Be explicit about render conditions.

```tsx
// ❌ Falsy value might render
return items.length && <ul>{items.map(...)}</ul>
// Renders "0" when items is empty!

// ✅ Explicit boolean
return items.length > 0 ? <ul>{items.map(...)}</ul> : null
```

## 42. Use useTransition over manual loading states

Let React manage pending states.

```tsx
// ❌ Manual loading state
const [loading, setLoading] = useState(false)
const handleSubmit = async () => {
  setLoading(true)
  await submitForm()
  setLoading(false)
}

// ✅ useTransition
const [isPending, startTransition] = useTransition()

const handleSubmit = () => {
  startTransition(async () => {
    await submitForm()
  })
}

return <button disabled={isPending}>{isPending ? 'Saving...' : 'Save'}</button>
```

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
