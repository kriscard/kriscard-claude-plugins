# CRITICAL: Eliminating Waterfalls

> **Read this when:** the user mentions sequential awaits, slow data loading, "waterfall", parallelization, `Promise.all`, Suspense boundaries, or RSC streaming.
>
> **Not the right file?** For bundle-size-driven slow loads → `bundle-optimization.md`. For client-side data fetching (SWR, listeners) → `client-fetching.md`.

Sequential data fetching is one of the most common performance killers in React applications. 5 rules.

## 1. Defer await until needed

Don't await promises immediately if the result isn't needed right away.

```tsx
// ❌ Incorrect — blocks immediately
async function Page() {
  const data = await fetchData()
  return <Component data={data} />
}

// ✅ Correct — start fetching, resolve where used
async function Page() {
  const dataPromise = fetchData()
  return <Component dataPromise={dataPromise} />
}

function Component({ dataPromise }) {
  const data = use(dataPromise)
  return <div>{data}</div>
}
```

## 2. Dependency-based parallelization

When operations have dependencies, await only the specific dependencies, not everything.

```tsx
// ❌ Each await blocks the next
const user = await getUser()
const posts = await getPosts()       // unnecessarily serial
const comments = await getComments() // unnecessarily serial

// ✅ Start parallel, await where used
const userPromise = getUser()
const postsPromise = getPosts()
const user = await userPromise
const posts = await postsPromise
const commentsPromise = getComments(posts) // genuine dependency
```

## 3. Prevent waterfall chains in API routes

Chain operations in API routes create server-side waterfalls.

```tsx
// ❌ Serial
export async function GET() {
  const user = await db.user.findFirst()
  const settings = await db.settings.findFirst({ where: { userId: user.id } })
  const preferences = await db.preferences.findFirst({ where: { userId: user.id } })
  return Response.json({ user, settings, preferences })
}

// ✅ Parallel where independent
export async function GET() {
  const user = await db.user.findFirst()
  const [settings, preferences] = await Promise.all([
    db.settings.findFirst({ where: { userId: user.id } }),
    db.preferences.findFirst({ where: { userId: user.id } }),
  ])
  return Response.json({ user, settings, preferences })
}
```

## 4. Promise.all for independent operations

Always parallelize independent async operations.

```tsx
// ❌ Serial
const analytics = await getAnalytics()
const notifications = await getNotifications()
const profile = await getProfile()

// ✅ Parallel
const [analytics, notifications, profile] = await Promise.all([
  getAnalytics(),
  getNotifications(),
  getProfile(),
])
```

## 5. Strategic Suspense boundaries

Place Suspense boundaries to allow parallel streaming of independent sections.

```tsx
// ❌ One boundary blocks everything
<Suspense fallback={<Loading />}>
  <Header />
  <MainContent />
  <Sidebar />
</Suspense>

// ✅ Independent boundaries stream in parallel
<>
  <Header /> {/* No Suspense needed if static */}
  <Suspense fallback={<MainSkeleton />}>
    <MainContent />
  </Suspense>
  <Suspense fallback={<SidebarSkeleton />}>
    <Sidebar />
  </Suspense>
</>
```

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
