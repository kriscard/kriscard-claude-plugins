# Re-renders and Memoization

How to reason about unnecessary re-renders, and when `useMemo` / `useCallback` / `React.memo` actually do anything. Two eras to consider: pre-Compiler and post-Compiler.

## The Compiler era changes the framing

React Compiler 1.0 (October 2025) automates memoization. When the Compiler is enabled:

- **`useMemo` / `useCallback` / `React.memo` become escape hatches**, not primary tools
- The Compiler memoizes more granularly than manual code can — even conditionally, after early returns
- The mental model becomes: "a component re-renders only if its state or props change" — what React was always supposed to feel like

**Framework status (as of 2026):**
- **Expo SDK 54+**: Compiler enabled by default
- **Next.js**: opt-in via `create-next-app` compiler-enabled template; SWC support still experimental, use Next.js 15.3.1+
- **Vite**: opt-in via `create-vite` compiler-enabled template
- **React 17/18**: supported with `react-compiler-runtime` dependency

What the Compiler does **NOT** handle (per Nadia's analysis):
- Components created inside other components — still anti-pattern
- `key` attribute for identity / state reset
- Context value churn — splitting providers is still your job
- Data fetching / error handling

---

## Nadia's 4 categories of unnecessary re-renders

From [React re-renders guide](https://www.developerway.com/posts/react-re-renders-guide). Useful pre- and post-Compiler.

### 1. Parent re-renders

A component re-renders because its parent did.

**Fixes:**
- Move state down — keep state inside the component that uses it
- Pass heavy components as `children` so they don't re-render with parent state changes
- Wrap heavy children in `React.memo` (with memoized props)

```jsx
// ❌ Parent owns state; entire tree re-renders on every keystroke
function Parent() {
  const [text, setText] = useState('');
  return (
    <>
      <input value={text} onChange={e => setText(e.target.value)} />
      <ExpensiveTree />
    </>
  );
}

// ✅ State moved down — ExpensiveTree unaffected
function Parent() {
  return (
    <>
      <TextInput />
      <ExpensiveTree />
    </>
  );
}

// ✅ Or: pass ExpensiveTree as children — same effect
function Parent({ children }) {
  const [text, setText] = useState('');
  return (
    <>
      <input value={text} onChange={e => setText(e.target.value)} />
      {children}
    </>
  );
}
<Parent><ExpensiveTree /></Parent>
```

### 2. Context changes

Every consumer of a context re-renders when the provider value changes.

**Fixes:**
- Memoize the provider value (`useMemo`)
- Split data and API into separate providers (so consumers of the API don't re-render when data changes)
- Use a context selector (HOC pattern) or switch to Zustand/Jotai for fine-grained subscriptions

```jsx
// ❌ Every consumer re-renders when count or setCount changes
<MyContext.Provider value={{ count, setCount }}>

// ✅ Split — components calling setCount don't care about count
<DataContext.Provider value={count}>
  <ApiContext.Provider value={setCount}>
```

### 3. Inline component creation

Components defined inside other components are re-created on every render, losing all memoization and state.

```jsx
// ❌ TabContent is a new component each render
function Tabs() {
  function TabContent() { return <div>...</div>; }
  return <TabContent />;
}

// ✅ Define outside or extract
function TabContent() { return <div>...</div>; }
function Tabs() { return <TabContent />; }
```

### 4. Improper memoization

Manual memoization that doesn't actually prevent re-renders — covered in the chain rule section below.

---

## What react-scan catches: prop reference identity

[react-scan](https://github.com/aidenybai/react-scan) is a drop-in runtime tool that highlights re-rendering components in the browser. Install:

```bash
npx -y react-scan@latest init    # auto-detects framework
```

It also exposes APIs for programmatic control:

```jsx
import { scan, useScan } from 'react-scan';

scan({ enabled: true });           // imperative — anywhere
useScan({ enabled: true });        // hook — inside a component
```

### The teaching

react-scan exists because **prop comparison in React is reference-based, not structural**. Two values that look identical but are different references (newly allocated each render) bust memoization.

```jsx
// ❌ Each render creates a NEW function and a NEW object.
// If ExpensiveComponent is React.memo'd, these "different" props
// invalidate the memo every time.
function Parent() {
  return (
    <ExpensiveComponent
      onClick={() => alert('hi')}
      style={{ color: 'purple' }}
    />
  );
}

// ✅ Stable references — useCallback + useMemo (or move outside the component).
function Parent() {
  const handleClick = useCallback(() => alert('hi'), []);
  const style = useMemo(() => ({ color: 'purple' }), []);
  return <ExpensiveComponent onClick={handleClick} style={style} />;
}
```

The most common reference-identity culprits, in order of frequency:

1. **Inline arrow functions** — `onClick={() => ...}`
2. **Inline object literals** — `style={{...}}`, `data={{...}}`
3. **Inline array literals** — `items={[...]}`
4. **`.map`/`.filter`/`.sort` in render** — produces a new array each time
5. **Spread props** — `<Child {...props}/>` with a fresh-each-render `props` object

react-scan highlights every component that re-rendered, color-coded by frequency, so these patterns are visually obvious in the running app.

**With React Compiler enabled, the Compiler stabilizes most of these automatically** — react-scan becomes a verification tool rather than a fix-finder. Without the Compiler, react-scan is the fastest way to find the culprits.

---

## Nadia's chain rule for manual memoization

From [How to useMemo and useCallback: you can remove most of them](https://www.developerway.com/posts/how-to-use-memo-use-callback).

**The rule:** Memoization only prevents re-renders when **every single prop AND the component itself** are memoized. Miss any link and the chain breaks.

```jsx
const Child = React.memo(({ data, onClick, style }) => { /* ... */ });

// ❌ Pointless — `style` is a new object every render, breaking the chain
<Child data={memoData} onClick={memoClick} style={{ color: 'red' }} />

// ❌ Pointless — Child not wrapped in React.memo
<RegularChild data={memoData} onClick={memoClick} />

// ❌ Pointless — passed to a DOM element
<button onClick={memoClick} />

// ✅ Works — all props memoized, Child wrapped in React.memo
<Child data={memoData} onClick={memoClick} style={memoStyle} />
```

**When to remove `useMemo` / `useCallback`:**
- Passed to a DOM element
- Passed to a component not wrapped in `React.memo`
- Passed to a memoized component where **any other prop** isn't memoized

**When to keep them:**
1. **Memoizing a whole tree** — all props memoized + component in `React.memo`
2. **Expensive *render* work** — not JS calculations

Cost reality check from Nadia's testing:
- Sorting 250 items: **<2ms**
- Rendering: **>20ms**

Memoize what's slow (rendering trees), not what feels expensive (sorting).

**Important:** Excessive memoization *degrades* initial render performance. Speculative `useMemo` everywhere makes the first paint slower.

---

## Decision flowchart

```
Is React Compiler enabled?
├── Yes → Trust it. Use useMemo/useCallback only for:
│         - Effect dependencies (stability matters there)
│         - Cases where you've measured a problem
│
└── No → Apply the chain rule:
         - All props memoized AND component in React.memo? → memoize
         - Any link broken? → don't bother
         - Slow render specifically? → memoize the tree
         - Slow JS calc? → useMemo
         - Speculative? → measure first, don't memoize
```

---

## Measure first

Diagnostic tools:
- **[react-scan](https://github.com/aidenybai/react-scan)** — runtime tool. Drop in via `npx react-scan@latest init`. Highlights re-rendering components with no code changes.
- **React DevTools Profiler** — flame graph, identifies render cost and triggers. See `bundle-and-perf-investigation.md`.
- **[react-doctor](https://github.com/millionco/react-doctor)** — static analysis via AST, 0-100 health score across state/effects, performance, architecture, security, a11y, dead code.

## Further reading

- [React Compiler v1.0 — react.dev](https://react.dev/blog/2025/10/07/react-compiler-1)
- [Nadia — React re-renders guide](https://www.developerway.com/posts/react-re-renders-guide)
- [Nadia — How to useMemo and useCallback: you can remove most of them](https://www.developerway.com/posts/how-to-use-memo-use-callback)
- [Nadia — React Compiler soon](https://www.developerway.com/posts/react-compiler-soon)
