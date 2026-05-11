# useEffect Anti-Patterns

The 12 canonical anti-patterns from [react.dev — "You Might Not Need an Effect"](https://react.dev/learn/you-might-not-need-an-effect), plus two advanced patterns from Nadia Makarevich's posts.

## The decision tree

Before writing a `useEffect`, ask: *"Why does this code need to run?"*

- Because the **component was displayed** → Use `useEffect`
- Because **the user did something** → Use an event handler
- Because **it can be computed from state/props** → Compute during rendering
- Because **a calculation is expensive but stable** → `useMemo`
- Because **you measure the DOM** → Use `useLayoutEffect` (not `useEffect`) to avoid flicker

If the answer isn't "the component was displayed," the Effect is probably wrong.

---

## 1. Derived state from props or state

**Problem:** Storing computed values in state and syncing via Effect.

```jsx
// ❌ Bad
const [fullName, setFullName] = useState('');
useEffect(() => {
  setFullName(firstName + ' ' + lastName);
}, [firstName, lastName]);

// ✅ Good — compute during rendering
const fullName = firstName + ' ' + lastName;
```

## 2. Expensive calculations

**Problem:** Recomputing on every render when only some inputs changed.

```jsx
// ❌ Bad
const [visibleTodos, setVisibleTodos] = useState([]);
useEffect(() => {
  setVisibleTodos(getFilteredTodos(todos, filter));
}, [todos, filter]);

// ✅ Good
const visibleTodos = useMemo(
  () => getFilteredTodos(todos, filter),
  [todos, filter]
);
```

## 3. Resetting all state when a prop changes

**Problem:** Clearing local state in an Effect causes a stale render flash.

```jsx
// ❌ Bad
useEffect(() => { setComment(''); }, [userId]);

// ✅ Good — use `key` to reset all state automatically
<Profile userId={userId} key={userId} />
```

## 4. Adjusting partial state on a prop change

```jsx
// ❌ Bad
useEffect(() => { setSelection(null); }, [items]);

// ✅ Good — adjust during rendering
const [prevItems, setPrevItems] = useState(items);
if (items !== prevItems) {
  setPrevItems(items);
  setSelection(null);
}

// ✅ Even better — derive it
const selection = items.find(item => item.id === selectedId) ?? null;
```

## 5. Sharing logic between event handlers

```jsx
// ❌ Bad — fires every time `product` updates
useEffect(() => {
  if (product.isInCart) showNotification(`Added ${product.name}!`);
}, [product]);

// ✅ Good — share via a function
function buyProduct() {
  addToCart(product);
  showNotification(`Added ${product.name}!`);
}
```

## 6. POST requests in Effects

```jsx
// ❌ Bad
const [jsonToSubmit, setJsonToSubmit] = useState(null);
useEffect(() => {
  if (jsonToSubmit) post('/api/register', jsonToSubmit);
}, [jsonToSubmit]);

// ✅ Good — POST in the event handler
function handleSubmit(e) {
  e.preventDefault();
  post('/api/register', { firstName, lastName });
}
```

## 7. Chains of computations

**Problem:** Effects that fire other Effects via state updates create cascade re-renders.

```jsx
// ❌ Bad — each setState triggers next Effect
useEffect(() => {
  if (card?.gold) setGoldCardCount(c => c + 1);
}, [card]);

useEffect(() => {
  if (goldCardCount > 3) setRound(r => r + 1);
}, [goldCardCount]);

// ✅ Good — compute everything in one handler
function handlePlaceCard(nextCard) {
  setCard(nextCard);
  if (nextCard.gold) {
    goldCardCount < 3
      ? setGoldCardCount(goldCardCount + 1)
      : (setGoldCardCount(0), setRound(round + 1));
  }
}
```

## 8. App initialization

**Problem:** Init logic in `useEffect([])` runs twice in dev StrictMode.

```jsx
// ❌ Bad
useEffect(() => {
  loadDataFromLocalStorage();
  checkAuthToken();
}, []);

// ✅ Good — module-level if order doesn't matter
if (typeof window !== 'undefined') {
  checkAuthToken();
  loadDataFromLocalStorage();
}

// ✅ Or guard with a module flag
let didInit = false;
useEffect(() => {
  if (!didInit) {
    didInit = true;
    loadDataFromLocalStorage();
    checkAuthToken();
  }
}, []);
```

## 9. Notifying parent about state changes

```jsx
// ❌ Bad — extra render
useEffect(() => { onChange(isOn); }, [isOn, onChange]);

// ✅ Good — call onChange in the same event
function updateToggle(nextIsOn) {
  setIsOn(nextIsOn);
  onChange(nextIsOn);
}
```

## 10. Passing data up

```jsx
// ❌ Bad — child fetches, parent reads via callback
function Child({ onFetched }) {
  const data = useSomeAPI();
  useEffect(() => { if (data) onFetched(data); }, [data, onFetched]);
}

// ✅ Good — lift the fetch up
function Parent() {
  const data = useSomeAPI();
  return <Child data={data} />;
}
```

## 11. Subscribing to external stores

```jsx
// ❌ Manual — easy to get wrong
const [isOnline, setIsOnline] = useState(true);
useEffect(() => {
  const update = () => setIsOnline(navigator.onLine);
  window.addEventListener('online', update);
  window.addEventListener('offline', update);
  return () => {
    window.removeEventListener('online', update);
    window.removeEventListener('offline', update);
  };
}, []);

// ✅ Good — useSyncExternalStore
function subscribe(cb) {
  window.addEventListener('online', cb);
  window.addEventListener('offline', cb);
  return () => {
    window.removeEventListener('online', cb);
    window.removeEventListener('offline', cb);
  };
}
const isOnline = useSyncExternalStore(
  subscribe,
  () => navigator.onLine,
  () => true
);
```

## 12. Fetching data without cleanup

```jsx
// ❌ Race condition — stale request may overwrite fresh data
useEffect(() => {
  fetchResults(query, page).then(setResults);
}, [query, page]);

// ✅ Good — cleanup with ignore flag
useEffect(() => {
  let ignore = false;
  fetchResults(query, page).then(json => {
    if (!ignore) setResults(json);
  });
  return () => { ignore = true; };
}, [query, page]);

// ✅ Best — use TanStack Query or a framework data layer
// (handles cancellation, caching, retries automatically)
```

---

## Advanced: Stale closure ref-trick (from Nadia Makarevich)

When a memoized component receives a callback that needs access to the latest state, but you don't want the callback identity to change (which would break memoization):

```jsx
function Parent() {
  const [count, setCount] = useState(0);

  // Ref holds the latest closure
  const callbackRef = useRef(() => {});

  // Update ref on every render — cheap, no re-renders triggered
  useEffect(() => {
    callbackRef.current = () => {
      console.log('Latest count:', count);
    };
  });

  // Stable callback — identity never changes, so HeavyChild stays memoized
  const stableCallback = useCallback(() => {
    callbackRef.current?.();
  }, []);

  return <HeavyChild onClick={stableCallback} />;
}
```

**When to use:** memoized child components that need a callback with access to latest state. Achieves "memoized + latest data."

See [Fantastic Closures](https://www.developerway.com/posts/fantastic-closures) for the full derivation.

---

## Advanced: useLayoutEffect for DOM measurements (from "No More Flickering UI")

When you read DOM dimensions and update state based on the measurement, `useEffect` causes a paint flash because the browser paints between render and adjustment.

```jsx
// ❌ Flicker — initial render paints, then adjustment paints again
useEffect(() => {
  const rect = ref.current.getBoundingClientRect();
  if (rect.width < 200) setIsSmall(true);
}, []);

// ✅ Good — useLayoutEffect runs synchronously before paint
useLayoutEffect(() => {
  const rect = ref.current.getBoundingClientRect();
  if (rect.width < 200) setIsSmall(true);
}, []);
```

**Caveats:**
- Blocks paint — keep the work small
- SSR: `useLayoutEffect` warns server-side. Either guard with a client-only flag (`useState(false)` + `useEffect(() => setMounted(true), [])`) or use `useIsomorphicLayoutEffect` pattern

See [No More Flickering UI](https://www.developerway.com/posts/no-more-flickering-ui).

---

## Quick checklist

When you see a `useEffect`:

- [ ] Could this be computed during rendering?
- [ ] Is it derived state? (use a regular variable or `useMemo`)
- [ ] Is it event-triggered? (move to event handler)
- [ ] Is it resetting state on prop change? (use `key`)
- [ ] Is it fetching data? (use TanStack Query, RSC, or framework loader)
- [ ] Is it subscribing to an external store? (use `useSyncExternalStore`)
- [ ] Is it measuring the DOM? (use `useLayoutEffect`)
- [ ] If it's truly displayed-triggered: is the dependency array complete?
- [ ] If it's a fetch: is there a cleanup flag for race conditions?

## Static-analysis rule mapping

These patterns are catchable in CI. [react-doctor](https://github.com/millionco/react-doctor) bundles the relevant ESLint plugins and rolls them into a 0–100 health score; you can also install the ESLint plugins directly.

| Pattern (above) | Rule that catches it | Source plugin |
|---|---|---|
| #1 Derived state from props/state | `no-derived-state` | `eslint-plugin-react-you-might-not-need-an-effect` |
| #2 Expensive calculations | `no-derived-state` (when wrapped in useState + setState in effect) | same |
| #4 Adjusting partial state on prop change | `no-derived-state` | same |
| #5 Sharing logic between event handlers | `no-event-handler` | same |
| #6 POST requests in Effects | `no-event-handler` | same |
| #7 Chains of computations | `no-chain-state-updates` | same |
| #9 Notifying parent on state change | `no-pass-data-to-parent` | same |
| #10 Passing data to parent | `no-pass-data-to-parent` | same |
| #11 Subscribing to external stores | covered by `react-hooks/exhaustive-deps` + manual review | `eslint-plugin-react-hooks` |
| #12 Fetching data without cleanup | `no-async-fetch-in-effect` (via TanStack Query lint) | various |
| Stale closures (advanced) | `react-hooks/exhaustive-deps` | `eslint-plugin-react-hooks` |
| Compiler correctness | `react-hooks-js/*` rule namespace | `eslint-plugin-react-hooks` v6+ |

**Setup options:**

```bash
# Option A: react-doctor — single tool, health score, rolls up the plugins
npx react-doctor scan
# or use as a GitHub Action

# Option B: install the ESLint plugins directly
pnpm add -D eslint-plugin-react-you-might-not-need-an-effect eslint-plugin-react-hooks
```

react-doctor groups results into 6 categories (state & effects, performance, architecture, security, accessibility, dead code) and outputs a score — useful as a CI gate. Direct ESLint usage gives finer per-rule control.

## Further reading

- [React docs — You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
- [TkDodo — Simplifying useEffect](https://tkdodo.eu/blog/simplifying-use-effect)
- [TkDodo — Avoiding useEffect with callback refs](https://tkdodo.eu/blog/avoiding-use-effect-with-callback-refs)
- [Nadia — Fantastic Closures](https://www.developerway.com/posts/fantastic-closures)
- [Nadia — No More Flickering UI](https://www.developerway.com/posts/no-more-flickering-ui)
- [`eslint-plugin-react-you-might-not-need-an-effect`](https://github.com/NickvanDyke/eslint-plugin-react-you-might-not-need-an-effect)
- [react-doctor](https://github.com/millionco/react-doctor) — bundles the rules, outputs a health score
- [react-scan](https://github.com/aidenybai/react-scan) — runtime complement to these static rules
