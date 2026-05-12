# HIGH: Server-Side & RSC Performance

> **Read this when:** the user mentions Server Components, Server Actions, RSC, `React.cache`, request deduplication, LRU caching, `after()`, or optimizing Next.js App Router data fetching.
>
> **Not the right file?** For choosing CSR vs SSR vs SSG vs RSC (the architectural decision) → `rendering-models.md`. For client-side data fetching (SWR, listeners) → `client-fetching.md`.

Optimizing server-side rendering and data fetching in Next.js. 7 rules.

## 11. Authenticate Server Actions

Always validate authentication in Server Actions.

```tsx
// ❌ No auth check
async function updateProfile(data: FormData) {
  'use server'
  await db.profile.update({ data })
}

// ✅ Auth first
async function updateProfile(data: FormData) {
  'use server'
  const session = await auth()
  if (!session) throw new Error('Unauthorized')

  await db.profile.update({
    where: { userId: session.user.id },
    data,
  })
}
```

## 12. Avoid duplicate serialization

Don't pass large objects through component boundaries unnecessarily.

```tsx
// ❌ Entire user object serialized multiple times
<Layout user={user}>
  <Sidebar user={user} />
  <Content user={user} />
  <Footer user={user} />
</Layout>

// ✅ Pass only needed data, or use context
<UserProvider value={{ id: user.id, name: user.name, avatar: user.avatar }}>
  <Layout>
    <Sidebar />
    <Content />
    <Footer />
  </Layout>
</UserProvider>
```

## 13. Cross-request LRU caching

Cache expensive computations across requests.

```tsx
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

## 14. Minimize RSC serialization

Only pass necessary data to client components.

```tsx
// ❌ Passes entire database record
async function Page() {
  const posts = await db.post.findMany({ include: { author: true, comments: true } })
  return <PostList posts={posts} />
}

// ✅ Map to minimal shape
async function Page() {
  const posts = await db.post.findMany({ include: { author: true } })
  const minimalPosts = posts.map(p => ({
    id: p.id,
    title: p.title,
    authorName: p.author.name,
    createdAt: p.createdAt.toISOString(),
  }))
  return <PostList posts={minimalPosts} />
}
```

## 15. Parallel data fetching via composition

Compose server components to fetch data in parallel.

```tsx
// ❌ Sequential in parent
async function Page() {
  const user = await getUser()
  const posts = await getPosts()
  const notifications = await getNotifications()
  return <Dashboard user={user} posts={posts} notifications={notifications} />
}

// ✅ Each component fetches its own data (parallel via Suspense)
async function Page() {
  return (
    <Dashboard>
      <Suspense fallback={<UserSkeleton />}>
        <UserSection />
      </Suspense>
      <Suspense fallback={<PostsSkeleton />}>
        <PostsSection />
      </Suspense>
      <Suspense fallback={<NotificationsSkeleton />}>
        <NotificationsSection />
      </Suspense>
    </Dashboard>
  )
}
```

## 16. React.cache() for per-request dedup

Deduplicate identical requests within the same render.

```tsx
import { cache } from 'react'

const getUser = cache(async () => {
  return await db.user.findFirst()
})

// Header fetches, Sidebar returns cached result — same request, one DB call
async function Header() {
  const user = await getUser()
  return <HeaderUI user={user} />
}

async function Sidebar() {
  const user = await getUser()
  return <SidebarUI user={user} />
}
```

## 17. Use after() for non-blocking operations

Run analytics, logging, and other side effects after response.

```tsx
// ❌ Blocks response
export async function POST(request: Request) {
  const data = await request.json()
  await saveToDatabase(data)
  await logAnalytics(data)
  await sendEmail(data)
  return Response.json({ success: true })
}

// ✅ Non-blocking
import { after } from 'next/server'

export async function POST(request: Request) {
  const data = await request.json()
  await saveToDatabase(data)

  after(async () => {
    await logAnalytics(data)
    await sendEmail(data)
  })

  return Response.json({ success: true })
}
```

## Reminder: Server Actions for reads is an anti-pattern

Don't use Server Actions for client-side data fetching — they serialize requests and kill parallelism. Use Server Components (for SSR reads) or REST + TanStack Query (for client reads). See `rendering-models.md`.

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
