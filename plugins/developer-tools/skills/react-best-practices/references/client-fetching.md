# MEDIUM-HIGH: Client-Side Data Fetching

> **Read this when:** the user mentions client-side fetching, SWR, TanStack Query deduplication, scroll/event listener perf, passive listeners, or `localStorage` patterns.
>
> **Not the right file?** For server-side fetching, RSC, Server Actions → `server-and-rsc.md`. For useEffect-driven fetch with race conditions → `useeffect-antipatterns.md` (#12).

Optimizing how client components fetch and manage data. 4 rules.

## 18. Deduplicate global event listeners

Don't create multiple listeners for the same event.

```tsx
// ❌ Every component instance adds a listener
function ScrollTracker() {
  useEffect(() => {
    const handler = () => trackScroll()
    window.addEventListener('scroll', handler)
    return () => window.removeEventListener('scroll', handler)
  }, [])
}

// ✅ Single global listener with subscribers
const scrollSubscribers = new Set<() => void>()
let scrollListenerActive = false

function setupScrollListener() {
  if (scrollListenerActive) return
  scrollListenerActive = true
  window.addEventListener('scroll', () => {
    scrollSubscribers.forEach(fn => fn())
  }, { passive: true })
}

function useScrollTracker(callback: () => void) {
  useEffect(() => {
    setupScrollListener()
    scrollSubscribers.add(callback)
    return () => { scrollSubscribers.delete(callback) }
  }, [callback])
}
```

## 19. Use passive event listeners for scrolling

Passive listeners can't call `preventDefault`, allowing scroll optimization.

```tsx
// ❌ Blocks scroll optimization
useEffect(() => {
  window.addEventListener('scroll', handleScroll)
  window.addEventListener('touchmove', handleTouch)
}, [])

// ✅ Passive
useEffect(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('touchmove', handleTouch, { passive: true })
}, [])
```

## 20. Use SWR (or TanStack Query) for automatic deduplication

Manual `useEffect` fetches don't deduplicate.

```tsx
// ❌ Manual fetching — every component instance hits the network
function useUser(id: string) {
  const [user, setUser] = useState(null)
  useEffect(() => {
    fetch(`/api/users/${id}`).then(r => r.json()).then(setUser)
  }, [id])
  return user
}

// ✅ SWR — single request shared across consumers
import useSWR from 'swr'

function useUser(id: string) {
  return useSWR(`/api/users/${id}`, fetcher)
}
```

TanStack Query gives the same deduplication plus richer mutation/cache semantics — preferred for most apps in 2026.

## 21. Version and minimize localStorage data

Manage localStorage with versioning to handle schema changes.

```tsx
// ❌ No versioning, stores everything
function useSettings() {
  const [settings, setSettings] = useState(() => {
    return JSON.parse(localStorage.getItem('settings') || '{}')
  })

  useEffect(() => {
    localStorage.setItem('settings', JSON.stringify(settings))
  }, [settings])
}

// ✅ Versioned with minimal data
const SETTINGS_VERSION = 2

function useSettings() {
  const [settings, setSettings] = useState(() => {
    const stored = localStorage.getItem('settings')
    if (!stored) return defaultSettings

    const parsed = JSON.parse(stored)
    if (parsed.version !== SETTINGS_VERSION) {
      return migrateSettings(parsed, SETTINGS_VERSION)
    }
    return parsed
  })

  useEffect(() => {
    const toStore = {
      version: SETTINGS_VERSION,
      theme: settings.theme,
      locale: settings.locale,
    }
    localStorage.setItem('settings', JSON.stringify(toStore))
  }, [settings.theme, settings.locale])
}
```

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
