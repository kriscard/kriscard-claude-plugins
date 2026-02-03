# Vercel React Best Practices - Complete Rules Reference

57 actionable performance rules from Vercel Engineering, organized by priority with incorrect/correct code examples.

---

## CRITICAL: Eliminating Waterfalls (5 rules)

Sequential data fetching is one of the most common performance killers in React applications.

### 1. Defer await until needed

Don't await promises immediately if the result isn't needed right away.

```tsx
// Incorrect
async function Page() {
  const data = await fetchData() // Blocks immediately
  return <Component data={data} />
}
```

```tsx
// Correct
async function Page() {
  const dataPromise = fetchData() // Start fetching, don't wait
  return <Component dataPromise={dataPromise} />
}

// In Component, use React.use() to resolve when needed
function Component({ dataPromise }) {
  const data = use(dataPromise)
  return <div>{data}</div>
}
```

### 2. Dependency-based parallelization

When operations have dependencies, await only the specific dependencies, not everything.

```tsx
// Incorrect
async function Page() {
  const user = await getUser()
  const posts = await getPosts() // Waits for user unnecessarily
  const comments = await getComments() // Waits for posts unnecessarily
  return <Content user={user} posts={posts} comments={comments} />
}
```

```tsx
// Correct
async function Page() {
  const userPromise = getUser()
  const postsPromise = getPosts() // Parallel with user

  const user = await userPromise // Only wait when needed
  const posts = await postsPromise
  const commentsPromise = getComments(posts) // Depends on posts

  return <Content user={user} posts={posts} commentsPromise={commentsPromise} />
}
```

### 3. Prevent waterfall chains in API routes

Chain operations in API routes create server-side waterfalls.

```tsx
// Incorrect - Route handler
export async function GET() {
  const user = await db.user.findFirst()
  const settings = await db.settings.findFirst({ where: { userId: user.id } })
  const preferences = await db.preferences.findFirst({ where: { userId: user.id } })
  return Response.json({ user, settings, preferences })
}
```

```tsx
// Correct - Use Promise.all for independent queries
export async function GET() {
  const user = await db.user.findFirst()

  const [settings, preferences] = await Promise.all([
    db.settings.findFirst({ where: { userId: user.id } }),
    db.preferences.findFirst({ where: { userId: user.id } })
  ])

  return Response.json({ user, settings, preferences })
}
```

### 4. Promise.all for independent operations

Always parallelize independent async operations.

```tsx
// Incorrect
async function Dashboard() {
  const analytics = await getAnalytics()
  const notifications = await getNotifications()
  const profile = await getProfile()
  return <DashboardUI {...{ analytics, notifications, profile }} />
}
```

```tsx
// Correct
async function Dashboard() {
  const [analytics, notifications, profile] = await Promise.all([
    getAnalytics(),
    getNotifications(),
    getProfile()
  ])
  return <DashboardUI {...{ analytics, notifications, profile }} />
}
```

### 5. Strategic Suspense boundaries

Place Suspense boundaries to allow parallel loading of independent sections.

```tsx
// Incorrect - One boundary blocks everything
function Page() {
  return (
    <Suspense fallback={<Loading />}>
      <Header />
      <MainContent />
      <Sidebar />
    </Suspense>
  )
}
```

```tsx
// Correct - Independent boundaries allow parallel streaming
function Page() {
  return (
    <>
      <Header /> {/* Static, no Suspense needed */}
      <Suspense fallback={<MainSkeleton />}>
        <MainContent />
      </Suspense>
      <Suspense fallback={<SidebarSkeleton />}>
        <Sidebar />
      </Suspense>
    </>
  )
}
```

---

## CRITICAL: Bundle Size Optimization (5 rules)

Large bundles directly impact Time to Interactive and First Contentful Paint.

### 6. Avoid barrel file imports

Barrel files (index.ts re-exports) can pull in entire modules.

```tsx
// Incorrect - Imports entire library through barrel
import { Button } from '@/components'
import { formatDate } from '@/utils'
```

```tsx
// Correct - Direct imports
import { Button } from '@/components/ui/Button'
import { formatDate } from '@/utils/date/formatDate'
```

### 7. Conditional module loading

Only load modules when actually needed.

```tsx
// Incorrect - Always loads chart library
import { Chart } from 'heavy-chart-library'

function Dashboard({ showChart }) {
  return showChart ? <Chart /> : <Placeholder />
}
```

```tsx
// Correct - Only loads when needed
import dynamic from 'next/dynamic'

const Chart = dynamic(() => import('heavy-chart-library').then(m => m.Chart), {
  loading: () => <ChartSkeleton />
})

function Dashboard({ showChart }) {
  return showChart ? <Chart /> : <Placeholder />
}
```

### 8. Defer non-critical third-party libs

Load analytics, chat widgets, and other non-critical scripts after page load.

```tsx
// Incorrect - Blocks initial render
import { Analytics } from '@segment/analytics'
import { ChatWidget } from 'intercom'

function App() {
  return (
    <>
      <Analytics />
      <ChatWidget />
      <MainContent />
    </>
  )
}
```

```tsx
// Correct - Defer loading
import dynamic from 'next/dynamic'

const Analytics = dynamic(() => import('@segment/analytics'), { ssr: false })
const ChatWidget = dynamic(() => import('intercom'), {
  ssr: false,
  loading: () => null
})

function App() {
  return (
    <>
      <MainContent />
      <Suspense fallback={null}>
        <Analytics />
        <ChatWidget />
      </Suspense>
    </>
  )
}
```

### 9. Dynamic imports for heavy components

Use dynamic imports for components not needed on initial render.

```tsx
// Incorrect - Always in bundle
import { MarkdownEditor } from '@/components/MarkdownEditor'
import { CodeMirror } from '@/components/CodeMirror'

function CreatePost() {
  const [mode, setMode] = useState('preview')
  return mode === 'edit' ? <MarkdownEditor /> : <Preview />
}
```

```tsx
// Correct - Loaded on demand
import dynamic from 'next/dynamic'

const MarkdownEditor = dynamic(() => import('@/components/MarkdownEditor'), {
  loading: () => <EditorSkeleton />
})

function CreatePost() {
  const [mode, setMode] = useState('preview')
  return mode === 'edit' ? <MarkdownEditor /> : <Preview />
}
```

### 10. Preload based on user intent

Preload modules when user shows intent (hover, focus).

```tsx
// Incorrect - No preloading, loads on click (delay)
function EditButton({ postId }) {
  const router = useRouter()
  return (
    <button onClick={() => router.push(`/edit/${postId}`)}>
      Edit
    </button>
  )
}
```

```tsx
// Correct - Preload on hover
import { preload } from 'react-dom'

function EditButton({ postId }) {
  const router = useRouter()

  const handleMouseEnter = () => {
    // Preload the edit page and its dependencies
    router.prefetch(`/edit/${postId}`)
    preload('/chunks/editor.js', { as: 'script' })
  }

  return (
    <button
      onMouseEnter={handleMouseEnter}
      onClick={() => router.push(`/edit/${postId}`)}
    >
      Edit
    </button>
  )
}
```

---

## HIGH: Server-Side Performance (7 rules)

Optimizing server-side rendering and data fetching in Next.js.

### 11. Authenticate Server Actions

Always validate authentication in Server Actions.

```tsx
// Incorrect - No auth check
async function updateProfile(data: FormData) {
  'use server'
  await db.profile.update({ data })
}
```

```tsx
// Correct - Auth first
async function updateProfile(data: FormData) {
  'use server'
  const session = await auth()
  if (!session) throw new Error('Unauthorized')

  await db.profile.update({
    where: { userId: session.user.id },
    data
  })
}
```

### 12. Avoid duplicate serialization

Don't pass large objects through component boundaries unnecessarily.

```tsx
// Incorrect - Entire user object serialized multiple times
async function Page() {
  const user = await getUser() // Large object
  return (
    <Layout user={user}>
      <Sidebar user={user} />
      <Content user={user} />
      <Footer user={user} />
    </Layout>
  )
}
```

```tsx
// Correct - Pass only needed data or use context
async function Page() {
  const user = await getUser()
  return (
    <UserProvider value={{ id: user.id, name: user.name, avatar: user.avatar }}>
      <Layout>
        <Sidebar />
        <Content />
        <Footer />
      </Layout>
    </UserProvider>
  )
}
```

### 13. Cross-request LRU caching

Cache expensive computations across requests.

```tsx
// Incorrect - Recomputes every request
async function getExpensiveData(id: string) {
  return await heavyComputation(id)
}
```

```tsx
// Correct - LRU cache across requests
import { LRUCache } from 'lru-cache'

const cache = new LRUCache<string, Data>({ max: 100 })

async function getExpensiveData(id: string) {
  const cached = cache.get(id)
  if (cached) return cached

  const data = await heavyComputation(id)
  cache.set(id, data)
  return data
}
```

### 14. Minimize RSC serialization

Only pass necessary data to client components.

```tsx
// Incorrect - Passes entire database record
async function Page() {
  const posts = await db.post.findMany({ include: { author: true, comments: true } })
  return <PostList posts={posts} /> // Client component receives everything
}
```

```tsx
// Correct - Map to minimal shape
async function Page() {
  const posts = await db.post.findMany({ include: { author: true } })
  const minimalPosts = posts.map(p => ({
    id: p.id,
    title: p.title,
    authorName: p.author.name,
    createdAt: p.createdAt.toISOString()
  }))
  return <PostList posts={minimalPosts} />
}
```

### 15. Parallel data fetching via composition

Compose server components to fetch data in parallel.

```tsx
// Incorrect - Sequential in parent
async function Page() {
  const user = await getUser()
  const posts = await getPosts()
  const notifications = await getNotifications()
  return <Dashboard user={user} posts={posts} notifications={notifications} />
}
```

```tsx
// Correct - Each component fetches its own data (parallel via Suspense)
async function Page() {
  return (
    <Dashboard>
      <Suspense fallback={<UserSkeleton />}>
        <UserSection /> {/* Fetches user internally */}
      </Suspense>
      <Suspense fallback={<PostsSkeleton />}>
        <PostsSection /> {/* Fetches posts internally */}
      </Suspense>
      <Suspense fallback={<NotificationsSkeleton />}>
        <NotificationsSection /> {/* Fetches notifications internally */}
      </Suspense>
    </Dashboard>
  )
}
```

### 16. React.cache() for per-request dedup

Deduplicate identical requests within the same render.

```tsx
// Incorrect - Multiple components fetch same user
async function Header() {
  const user = await getUser() // Fetches
  return <HeaderUI user={user} />
}

async function Sidebar() {
  const user = await getUser() // Fetches again!
  return <SidebarUI user={user} />
}
```

```tsx
// Correct - Cached per request
import { cache } from 'react'

const getUser = cache(async () => {
  return await db.user.findFirst()
})

async function Header() {
  const user = await getUser() // Fetches
  return <HeaderUI user={user} />
}

async function Sidebar() {
  const user = await getUser() // Returns cached result
  return <SidebarUI user={user} />
}
```

### 17. Use after() for non-blocking operations

Run analytics, logging, and other side effects after response.

```tsx
// Incorrect - Blocks response
export async function POST(request: Request) {
  const data = await request.json()
  await saveToDatabase(data)
  await logAnalytics(data) // User waits for this
  await sendEmail(data) // And this
  return Response.json({ success: true })
}
```

```tsx
// Correct - Non-blocking with after()
import { after } from 'next/server'

export async function POST(request: Request) {
  const data = await request.json()
  await saveToDatabase(data)

  after(async () => {
    await logAnalytics(data)
    await sendEmail(data)
  })

  return Response.json({ success: true }) // Returns immediately
}
```

---

## MEDIUM-HIGH: Client-Side Data Fetching (4 rules)

Optimizing how client components fetch and manage data.

### 18. Deduplicate global event listeners

Don't create multiple listeners for the same event.

```tsx
// Incorrect - Every component instance adds a listener
function ScrollTracker() {
  useEffect(() => {
    const handler = () => trackScroll()
    window.addEventListener('scroll', handler)
    return () => window.removeEventListener('scroll', handler)
  }, [])
}
```

```tsx
// Correct - Single global listener with subscribers
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

### 19. Use passive event listeners for scrolling

Passive listeners can't call preventDefault, allowing scroll optimization.

```tsx
// Incorrect - Blocks scroll optimization
useEffect(() => {
  window.addEventListener('scroll', handleScroll)
  window.addEventListener('touchmove', handleTouch)
}, [])
```

```tsx
// Correct - Passive listeners
useEffect(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('touchmove', handleTouch, { passive: true })
}, [])
```

### 20. Use SWR for automatic deduplication

SWR deduplicates identical requests automatically.

```tsx
// Incorrect - Manual fetching, no deduplication
function useUser(id: string) {
  const [user, setUser] = useState(null)
  useEffect(() => {
    fetch(`/api/users/${id}`).then(r => r.json()).then(setUser)
  }, [id])
  return user
}

// Multiple components using useUser('123') = multiple requests
```

```tsx
// Correct - SWR handles deduplication
import useSWR from 'swr'

function useUser(id: string) {
  return useSWR(`/api/users/${id}`, fetcher)
}

// Multiple components using useUser('123') = single request
```

### 21. Version and minimize localStorage data

Manage localStorage with versioning to handle schema changes.

```tsx
// Incorrect - No versioning, stores everything
function useSettings() {
  const [settings, setSettings] = useState(() => {
    return JSON.parse(localStorage.getItem('settings') || '{}')
  })

  useEffect(() => {
    localStorage.setItem('settings', JSON.stringify(settings))
  }, [settings])
}
```

```tsx
// Correct - Versioned with minimal data
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
    // Store only essential fields
    const toStore = {
      version: SETTINGS_VERSION,
      theme: settings.theme,
      locale: settings.locale
    }
    localStorage.setItem('settings', JSON.stringify(toStore))
  }, [settings.theme, settings.locale])
}
```

---

## MEDIUM: Re-render Optimization (12 rules)

Preventing unnecessary component re-renders.

### 22. Defer state reads to usage point

Read state in the component that uses it, not in parents.

```tsx
// Incorrect - Parent reads state, passes down
function Parent() {
  const count = useStore(state => state.count) // Re-renders on count change
  return <Child count={count} />
}
```

```tsx
// Correct - Child reads its own state
function Parent() {
  return <Child /> // Never re-renders due to count
}

function Child() {
  const count = useStore(state => state.count) // Only Child re-renders
  return <span>{count}</span>
}
```

### 23. Don't wrap simple expressions in useMemo

useMemo has overhead; don't use for trivial computations.

```tsx
// Incorrect - Unnecessary memoization
function Component({ items }) {
  const count = useMemo(() => items.length, [items])
  const hasItems = useMemo(() => items.length > 0, [items])
  const label = useMemo(() => `${count} items`, [count])
}
```

```tsx
// Correct - Direct computation is faster
function Component({ items }) {
  const count = items.length
  const hasItems = count > 0
  const label = `${count} items`
}
```

### 24. Extract default non-primitive params to constants

Non-primitive default values create new references each render.

```tsx
// Incorrect - New object/array reference every render
function Component({
  options = { sort: true, filter: false },
  items = []
}) {
  useEffect(() => {
    // Runs every render because options is new object
  }, [options])
}
```

```tsx
// Correct - Stable references
const DEFAULT_OPTIONS = { sort: true, filter: false }
const DEFAULT_ITEMS: Item[] = []

function Component({
  options = DEFAULT_OPTIONS,
  items = DEFAULT_ITEMS
}) {
  useEffect(() => {
    // Only runs when options actually changes
  }, [options])
}
```

### 25. Extract to memoized components

Move expensive children to memoized components.

```tsx
// Incorrect - Expensive render on every parent update
function Parent() {
  const [count, setCount] = useState(0)
  return (
    <div>
      <button onClick={() => setCount(c => c + 1)}>{count}</button>
      <ExpensiveVisualization data={staticData} />
    </div>
  )
}
```

```tsx
// Correct - Memoized to prevent unnecessary re-renders
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

### 26. Narrow effect dependencies

Use primitive values in dependencies, not objects.

```tsx
// Incorrect - Effect runs when any user property changes
function Profile({ user }) {
  useEffect(() => {
    trackPageView(user.id)
  }, [user]) // Object dependency
}
```

```tsx
// Correct - Only runs when id changes
function Profile({ user }) {
  const userId = user.id

  useEffect(() => {
    trackPageView(userId)
  }, [userId]) // Primitive dependency
}
```

### 27. Subscribe to derived state

Don't select entire state when you need derived values.

```tsx
// Incorrect - Re-renders on any cart change
function CartBadge() {
  const cart = useStore(state => state.cart)
  return <Badge count={cart.items.length} />
}
```

```tsx
// Correct - Only re-renders when count changes
function CartBadge() {
  const itemCount = useStore(state => state.cart.items.length)
  return <Badge count={itemCount} />
}
```

### 28. Use functional setState updates

Avoid stale closure issues with functional updates.

```tsx
// Incorrect - Stale closure risk
function Counter() {
  const [count, setCount] = useState(0)

  const incrementThree = () => {
    setCount(count + 1) // All three use same stale count
    setCount(count + 1)
    setCount(count + 1) // Result: count + 1, not count + 3
  }
}
```

```tsx
// Correct - Always uses latest value
function Counter() {
  const [count, setCount] = useState(0)

  const incrementThree = () => {
    setCount(c => c + 1)
    setCount(c => c + 1)
    setCount(c => c + 1) // Result: count + 3
  }
}
```

### 29. Use lazy state initialization

Initialize expensive state values lazily.

```tsx
// Incorrect - Computes every render
function Editor() {
  const [content, setContent] = useState(parseMarkdown(initialText))
}
```

```tsx
// Correct - Computes only on initial render
function Editor() {
  const [content, setContent] = useState(() => parseMarkdown(initialText))
}
```

### 30. Use transitions for non-urgent updates

Mark non-critical updates as transitions.

```tsx
// Incorrect - Search blocks input
function Search() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])

  const handleChange = (e) => {
    setQuery(e.target.value)
    setResults(expensiveSearch(e.target.value)) // Blocks typing
  }
}
```

```tsx
// Correct - Search doesn't block input
function Search() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isPending, startTransition] = useTransition()

  const handleChange = (e) => {
    setQuery(e.target.value)
    startTransition(() => {
      setResults(expensiveSearch(e.target.value))
    })
  }

  return (
    <>
      <input value={query} onChange={handleChange} />
      {isPending ? <Spinner /> : <Results data={results} />}
    </>
  )
}
```

### 31. Calculate derived state during rendering

Don't store computed values in state or sync them via effects.

```tsx
// Incorrect - Derived state in useEffect
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const [fullName, setFullName] = useState('')

  useEffect(() => {
    setFullName(firstName + ' ' + lastName)
  }, [firstName, lastName])

  return <p>{fullName}</p>
}
```

```tsx
// Correct - Calculate during render
function Form() {
  const [firstName, setFirstName] = useState('First')
  const [lastName, setLastName] = useState('Last')
  const fullName = firstName + ' ' + lastName

  return <p>{fullName}</p>
}
```

### 32. Put interaction logic in event handlers

Don't model user actions as state + effect. Run side effects directly in handlers.

```tsx
// Incorrect - State + effect for user action
function Form({ theme }) {
  const [submitted, setSubmitted] = useState(false)

  useEffect(() => {
    if (submitted) {
      sendAnalytics('form_submit')
    }
  }, [submitted, theme]) // Re-runs when theme changes!

  const handleSubmit = () => setSubmitted(true)
}
```

```tsx
// Correct - Side effect in handler
function Form({ theme }) {
  const handleSubmit = () => {
    sendAnalytics('form_submit')
    // ... rest of submit logic
  }
}
```

### 33. Use useRef for transient values

Store frequently-changing values in refs when re-renders are undesirable.

```tsx
// Incorrect - useState causes re-render on every mouse move
function Tracker() {
  const [x, setX] = useState(0)

  useEffect(() => {
    const handler = (e) => setX(e.clientX)
    window.addEventListener('mousemove', handler)
    return () => window.removeEventListener('mousemove', handler)
  }, [])

  return <div style={{ transform: `translateX(${x}px)` }} />
}
```

```tsx
// Correct - useRef avoids re-renders
function Tracker() {
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
}
```

---

## MEDIUM: Rendering Performance (9 rules)

Optimizing what and how React renders.

### 34. Animate SVG wrapper instead of SVG element

Animating SVG elements is expensive; animate a wrapper instead.

```tsx
// Incorrect - Animates SVG directly
<motion.svg animate={{ rotate: 360 }}>
  <ComplexPath />
</motion.svg>
```

```tsx
// Correct - Animates wrapper
<motion.div animate={{ rotate: 360 }}>
  <svg>
    <ComplexPath />
  </svg>
</motion.div>
```

### 35. CSS content-visibility for long lists

Use CSS content-visibility to skip rendering off-screen items.

```tsx
// Incorrect - All items rendered
function LongList({ items }) {
  return (
    <ul>
      {items.map(item => <ListItem key={item.id} item={item} />)}
    </ul>
  )
}
```

```tsx
// Correct - Off-screen items skipped
function LongList({ items }) {
  return (
    <ul className="list-container">
      {items.map(item => (
        <li key={item.id} style={{ contentVisibility: 'auto', containIntrinsicSize: '0 50px' }}>
          <ListItem item={item} />
        </li>
      ))}
    </ul>
  )
}
```

### 36. Hoist static JSX elements

Move static elements outside components.

```tsx
// Incorrect - Icon recreated every render
function Button({ onClick, children }) {
  return (
    <button onClick={onClick}>
      <svg viewBox="0 0 24 24"><path d="..." /></svg>
      {children}
    </button>
  )
}
```

```tsx
// Correct - Static JSX hoisted
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

### 37. Optimize SVG precision

Reduce SVG path precision for smaller files.

```tsx
// Incorrect - Excessive precision
<path d="M12.000000 24.000000 L36.123456 48.789012" />
```

```tsx
// Correct - Reasonable precision
<path d="M12 24 L36.12 48.79" />
```

### 38. Prevent hydration mismatch without flickering

Handle client-only values without layout shift.

```tsx
// Incorrect - Hydration mismatch
function Timestamp({ date }) {
  return <span>{date.toLocaleString()}</span> // Different on server vs client
}
```

```tsx
// Correct - Suppress hydration warning with fallback
function Timestamp({ date }) {
  const [formatted, setFormatted] = useState<string>()

  useEffect(() => {
    setFormatted(date.toLocaleString())
  }, [date])

  return <span suppressHydrationWarning>{formatted ?? date.toISOString()}</span>
}
```

### 39. Suppress expected hydration mismatches

For known server/client differences (timestamps, random IDs), suppress warnings explicitly.

```tsx
// Incorrect - Console warning noise
function Timestamp() {
  return <span>{new Date().toLocaleString()}</span>
}
```

```tsx
// Correct - Suppress known mismatch
function Timestamp() {
  return (
    <span suppressHydrationWarning>
      {new Date().toLocaleString()}
    </span>
  )
}
```

**Note:** Only use for known differences. Don't mask real bugs.

### 40. Use Activity component for show/hide

Use Activity (or similar) to preserve state when hiding.

```tsx
// Incorrect - Unmounting loses state
function Tabs({ activeTab }) {
  return (
    <div>
      {activeTab === 'settings' && <Settings />}
      {activeTab === 'profile' && <Profile />}
    </div>
  )
}
```

```tsx
// Correct - State preserved (using unstable_Activity or similar pattern)
function Tabs({ activeTab }) {
  return (
    <div>
      <div style={{ display: activeTab === 'settings' ? 'block' : 'none' }}>
        <Settings />
      </div>
      <div style={{ display: activeTab === 'profile' ? 'block' : 'none' }}>
        <Profile />
      </div>
    </div>
  )
}
```

### 41. Use explicit conditional rendering

Be explicit about render conditions.

```tsx
// Incorrect - Falsy value might render
function List({ items }) {
  return items.length && <ul>{items.map(...)}</ul>
}
// Renders "0" when items is empty!
```

```tsx
// Correct - Explicit boolean
function List({ items }) {
  return items.length > 0 ? <ul>{items.map(...)}</ul> : null
}
```

### 42. Use useTransition over manual loading states

Let React manage pending states.

```tsx
// Incorrect - Manual loading state
function Form() {
  const [loading, setLoading] = useState(false)

  const handleSubmit = async () => {
    setLoading(true)
    await submitForm()
    setLoading(false)
  }
}
```

```tsx
// Correct - useTransition handles pending
function Form() {
  const [isPending, startTransition] = useTransition()

  const handleSubmit = () => {
    startTransition(async () => {
      await submitForm()
    })
  }

  return <button disabled={isPending}>{isPending ? 'Saving...' : 'Save'}</button>
}
```

---

## LOW-MEDIUM: JavaScript Performance (12 rules)

Micro-optimizations that add up in hot paths.

### 43. Avoid layout thrashing

Batch reads and writes to DOM.

```tsx
// Incorrect - Interleaved read/write
elements.forEach(el => {
  const height = el.offsetHeight // Read (forces layout)
  el.style.height = `${height + 10}px` // Write (invalidates layout)
})
```

```tsx
// Correct - Batch reads, then writes
const heights = elements.map(el => el.offsetHeight) // All reads
elements.forEach((el, i) => {
  el.style.height = `${heights[i] + 10}px` // All writes
})
```

### 44. Build index maps for repeated lookups

Create lookup maps for repeated finds.

```tsx
// Incorrect - O(n) lookup each time
users.forEach(user => {
  const post = posts.find(p => p.userId === user.id)
})
```

```tsx
// Correct - O(1) lookup with map
const postsByUser = new Map(posts.map(p => [p.userId, p]))
users.forEach(user => {
  const post = postsByUser.get(user.id)
})
```

### 45. Cache property access in loops

Extract property access outside loops.

```tsx
// Incorrect - Property access in every iteration
for (let i = 0; i < array.length; i++) {
  process(array[i], config.settings.threshold)
}
```

```tsx
// Correct - Cached outside loop
const { length } = array
const { threshold } = config.settings
for (let i = 0; i < length; i++) {
  process(array[i], threshold)
}
```

### 46. Cache repeated function calls

Don't call same function multiple times with same args.

```tsx
// Incorrect - Called twice
if (expensiveCheck(data) && otherCondition) {
  doSomething(expensiveCheck(data))
}
```

```tsx
// Correct - Cached result
const checkResult = expensiveCheck(data)
if (checkResult && otherCondition) {
  doSomething(checkResult)
}
```

### 47. Cache storage API calls

localStorage and sessionStorage calls are synchronous and slow.

```tsx
// Incorrect - Multiple storage calls
function getSettings() {
  return {
    theme: localStorage.getItem('theme'),
    lang: localStorage.getItem('lang'),
    fontSize: localStorage.getItem('fontSize')
  }
}
```

```tsx
// Correct - Single parse
function getSettings() {
  const stored = localStorage.getItem('settings')
  return stored ? JSON.parse(stored) : defaultSettings
}
```

### 48. Combine multiple array iterations

Reduce iterations over large arrays.

```tsx
// Incorrect - Three iterations
const active = users.filter(u => u.active)
const names = active.map(u => u.name)
const sorted = names.sort()
```

```tsx
// Correct - Single iteration + sort
const names = users
  .reduce((acc, u) => {
    if (u.active) acc.push(u.name)
    return acc
  }, [])
  .sort()
```

### 49. Early length check for array comparisons

Check length before comparing arrays.

```tsx
// Incorrect - Deep comparison without length check
function arraysEqual(a, b) {
  return a.every((item, i) => item === b[i])
}
```

```tsx
// Correct - Length check first
function arraysEqual(a, b) {
  if (a.length !== b.length) return false
  return a.every((item, i) => item === b[i])
}
```

### 50. Early return from functions

Exit early to avoid unnecessary computation.

```tsx
// Incorrect - Nested conditions
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
```

```tsx
// Correct - Early returns
function process(data) {
  if (!data?.items?.length) return []
  return data.items.map(transform)
}
```

### 51. Hoist RegExp creation

Don't create RegExp in loops or hot paths.

```tsx
// Incorrect - RegExp created each call
function validate(input) {
  return /^[a-zA-Z0-9]+$/.test(input)
}
```

```tsx
// Correct - RegExp hoisted
const ALPHANUMERIC = /^[a-zA-Z0-9]+$/

function validate(input) {
  return ALPHANUMERIC.test(input)
}
```

### 52. Use loop for min/max instead of sort

Don't sort just to find min/max.

```tsx
// Incorrect - O(n log n) for single value
const max = numbers.sort((a, b) => b - a)[0]
```

```tsx
// Correct - O(n)
const max = Math.max(...numbers)
// Or for very large arrays:
const max = numbers.reduce((m, n) => n > m ? n : m, -Infinity)
```

### 53. Use Set/Map for O(1) lookups

Replace array includes/find with Set/Map.

```tsx
// Incorrect - O(n) lookup
const activeIds = users.filter(u => u.active).map(u => u.id)
posts.filter(p => activeIds.includes(p.userId)) // O(n*m)
```

```tsx
// Correct - O(1) lookup
const activeIds = new Set(users.filter(u => u.active).map(u => u.id))
posts.filter(p => activeIds.has(p.userId)) // O(n)
```

### 54. Use toSorted() instead of sort()

Prefer immutable sort to avoid mutation.

```tsx
// Incorrect - Mutates original array
const sorted = items.sort((a, b) => a.name.localeCompare(b.name))
// items is now also sorted (mutated)
```

```tsx
// Correct - Returns new array
const sorted = items.toSorted((a, b) => a.name.localeCompare(b.name))
// items unchanged
```

---

## LOW: Advanced Patterns (3 rules)

### 55. Store event handlers in refs

Avoid recreating handlers that don't need to change.

```tsx
// Incorrect - Handler recreated each render
function Scroller({ onScroll }) {
  useEffect(() => {
    window.addEventListener('scroll', onScroll)
    return () => window.removeEventListener('scroll', onScroll)
  }, [onScroll]) // Runs on every onScroll change
}
```

```tsx
// Correct - Stable ref
function Scroller({ onScroll }) {
  const onScrollRef = useRef(onScroll)
  onScrollRef.current = onScroll

  useEffect(() => {
    const handler = () => onScrollRef.current()
    window.addEventListener('scroll', handler)
    return () => window.removeEventListener('scroll', handler)
  }, []) // Never re-runs
}
```

### 56. useEffectEvent for stable callback refs

Use useEffectEvent for callbacks that shouldn't trigger effect re-runs.

```tsx
// Incorrect - Effect re-runs when onTick changes
function Timer({ onTick }) {
  useEffect(() => {
    const id = setInterval(onTick, 1000)
    return () => clearInterval(id)
  }, [onTick])
}
```

```tsx
// Correct - useEffectEvent (experimental)
function Timer({ onTick }) {
  const tick = useEffectEvent(onTick)

  useEffect(() => {
    const id = setInterval(tick, 1000)
    return () => clearInterval(id)
  }, []) // tick is stable, effect doesn't re-run
}
```

### 57. Initialize app once, not per mount

Don't place app-wide initialization in useEffect([]). Components can remount.

```tsx
// Incorrect - Runs on every mount (twice in StrictMode)
function App() {
  useEffect(() => {
    loadFromStorage()
    checkAuthToken()
  }, [])
}
```

```tsx
// Correct - Module-level guard ensures once
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

---

## Attribution

Rules sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md). This document provides practical patterns for building high-performance React and Next.js applications.
