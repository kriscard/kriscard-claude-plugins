# Rendering Models: CSR vs SSR vs SSG vs RSC

The decision framework for *where* React renders. Built from [react.dev](https://react.dev), [patterns.dev](https://www.patterns.dev/react/react-2026), and Nadia Makarevich's [SSR deep dive](https://www.developerway.com/posts/ssr-deep-dive-for-react-developers).

## The models

| Model | Where rendered | When |
|---|---|---|
| **CSR** (Client-Side Rendering) | Browser, after JS loads | Default React; SPAs without SEO needs |
| **Server Pre-rendering** | Server, meta-tags only | Cheap path for crawler discoverability |
| **SSR** (full Server-Side Rendering) | Server, every request | Dynamic content + SEO, with strong eng support |
| **SSG** (Static Site Generation) | Build time | Static content that changes rarely |
| **ISR** (Incremental Static Regeneration) | Build + on-demand revalidation | Static-mostly content with periodic updates |
| **RSC** (React Server Components) | Server, streamed to client | Mix of static and dynamic; reduce client JS |
| **Streaming SSR** | Server, sent in chunks | Reduce TTFB; show shell while data loads |
| **PPR** (Partial Pre-rendering, Next.js) | Build + runtime per region | Static shell + dynamic holes |

## Decision questions

Use these to choose, in priority order:

1. **Does the content need to be discoverable by search engines or social previews?**
   - Yes → not CSR alone. Pre-render at minimum.
2. **Is the content the same for every user?**
   - Yes → SSG (or ISR if it changes periodically).
3. **Does the content change per request (user, locale, geo)?**
   - Yes → SSR or RSC.
4. **Do you have strong infra/operational support?**
   - SSR costs more (server, latency, library compatibility). Don't take it on without budget.
5. **Where does your latency budget go — TTFB or interactivity?**
   - Slow data + fast clients → CSR can beat SSR.
   - Fast data + slow clients → SSR shines.

## Nadia's SSR performance paradox

> "The combination of a slow network + huge latency + fast laptop happens quite often for business travelers... trying to introduce SSR to it might make it *worse*."

In her testing, **SSR increased LCP by ~500ms versus CSR** under slow-network conditions. The reason: SSR forces a server round-trip before the user sees anything. CSR can ship a thin shell + cached JS instantly and fetch only what's needed.

**Lesson:** SSR isn't universally faster. It's faster *under specific conditions* (fast network, slow client, dynamic SEO needs). Measure on your actual user network distribution before defaulting to it.

## SSR cost reality

Choosing SSR forces:
- **Deployment decisions**: serverless (cold starts) vs self-managed (geographic limitations)
- **Mandatory server round-trip**: every request hits the server, even cached pages
- **Library incompatibility**: many client-only libs break server-side. "It's always a gamble with the libraries."
- **Frontend complexity**: hydration mismatches, `typeof window` guards, SSR-safe wrappers

Per Nadia: SSR is "justified only with a very valid business reason and a lot of support in terms of time, resources, and expertise."

## Hydration pitfalls

The three mistakes Nadia calls out:

### 1. Skipping hydration entirely

```jsx
// ❌ React clears and rebuilds the entire DOM
ReactDOM.createRoot(domNode).render(<App />);

// ✅ Hydrate the server-rendered HTML
ReactDOM.hydrateRoot(domNode, <App />);
```

### 2. Conditional rendering based on `typeof window`

```jsx
// ❌ React falls back to CSR, layouting bugs ensue
return typeof window !== 'undefined'
  ? <ClientOnlyThing />
  : <Placeholder />;

// ✅ Use a mounted state flag
const [mounted, setMounted] = useState(false);
useEffect(() => setMounted(true), []);
return mounted ? <ClientOnlyThing /> : <Placeholder />;
```

### 3. Calling browser APIs in render path

```jsx
// ❌ Crashes on server
const width = window.innerWidth;

// ✅ Guard
const width = typeof window !== 'undefined' ? window.innerWidth : 0;

// ✅ Or move to useEffect
const [width, setWidth] = useState(0);
useEffect(() => setWidth(window.innerWidth), []);
```

## React Server Components (RSC)

RSC isn't a rendering model in the same way as CSR/SSR — it's a different *component category*. Server Components:
- Run on the server, never ship to the client bundle
- Can directly `await` data (no `useEffect` + fetch dance)
- Are interleaved with Client Components (`'use client'` directive)
- Stream to the client as a serialized tree, not HTML strings

**Performance reality:** RSC enables bundle reductions of 20%+ in real applications (per patterns.dev). The cost: framework lock-in (Next.js App Router is the dominant implementation), and a learning curve around the server/client boundary.

**Not a free lunch.** Nadia's [server-actions-for-data-fetching](https://www.developerway.com/posts/server-actions-for-data-fetching) testing showed:

> "For the love of all that is holy to you, don't [use Server Actions for client-side data fetching]. You'll regret it the second you'd need to send a few requests in parallel."

Server Actions process sequentially — her test went from 1.7s (parallel REST + TanStack Query) to **8 seconds** (Server Actions) for the same data.

**Rule:** Use Server Actions for *mutations* (form submissions, write operations) where they're a great fit. For reads, use:
- Server Components fetching directly (server-side)
- REST + TanStack Query (client-side)

## Recommended defaults (2026)

| Project shape | Default |
|---|---|
| Marketing site, blog, docs | SSG (Next.js / Astro / TanStack Start) |
| Product app, SEO matters, dynamic data | RSC + Streaming SSR (Next.js App Router) |
| Internal dashboard, auth-gated, no SEO | CSR (Vite + React Router or TanStack Router) |
| E-commerce | RSC + ISR (Next.js App Router) for product pages; CSR for cart/checkout |
| Highly interactive (canvas, editor, game) | CSR with a thin server shell |

## Further reading

- [Patterns.dev — React Rendering Patterns](https://www.patterns.dev/react/react-server-components)
- [Nadia — SSR Deep Dive for React Developers](https://www.developerway.com/posts/ssr-deep-dive-for-react-developers)
- [Nadia — Server Actions for Data Fetching](https://www.developerway.com/posts/server-actions-for-data-fetching)
- [Nadia — React Server Components: Do They Really Improve Performance?](https://www.developerway.com/posts/react-server-components-performance)
- [Kent C. Dodds — The Web's Next Transition](https://epicweb.dev/the-webs-next-transition)
- [Kent C. Dodds — Full Stack Components](https://epicweb.dev/full-stack-components)
