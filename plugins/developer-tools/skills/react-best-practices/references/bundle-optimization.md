# CRITICAL: Bundle Size Optimization

> **Read this when:** the user mentions large bundles, slow Time-to-Interactive, barrel files, dynamic imports, code splitting, or third-party script weight.
>
> **Not the right file?** For the *workflow* of investigating bundle issues (analyzer tools, culprit checklist, flame graphs) → `bundle-and-perf-investigation.md`. This file has concrete rules; the other has diagnostic workflow.

Large bundles directly impact Time to Interactive and First Contentful Paint. 5 rules.

## 6. Avoid barrel file imports

Barrel files (index.ts re-exports) can pull in entire modules.

```tsx
// ❌ Imports entire library through barrel
import { Button } from '@/components'
import { formatDate } from '@/utils'

// ✅ Direct imports
import { Button } from '@/components/ui/Button'
import { formatDate } from '@/utils/date/formatDate'
```

## 7. Conditional module loading

Only load modules when actually needed.

```tsx
// ❌ Always loads chart library
import { Chart } from 'heavy-chart-library'

function Dashboard({ showChart }) {
  return showChart ? <Chart /> : <Placeholder />
}

// ✅ Loads only when needed
import dynamic from 'next/dynamic'

const Chart = dynamic(() => import('heavy-chart-library').then(m => m.Chart), {
  loading: () => <ChartSkeleton />,
})
```

## 8. Defer non-critical third-party libs

Load analytics, chat widgets, and other non-critical scripts after page load.

```tsx
// ❌ Blocks initial render
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

// ✅ Deferred
import dynamic from 'next/dynamic'

const Analytics = dynamic(() => import('@segment/analytics'), { ssr: false })
const ChatWidget = dynamic(() => import('intercom'), {
  ssr: false,
  loading: () => null,
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

## 9. Dynamic imports for heavy components

Use dynamic imports for components not needed on initial render.

```tsx
// ❌ Always in bundle
import { MarkdownEditor } from '@/components/MarkdownEditor'

function CreatePost() {
  const [mode, setMode] = useState('preview')
  return mode === 'edit' ? <MarkdownEditor /> : <Preview />
}

// ✅ Loaded on demand
import dynamic from 'next/dynamic'

const MarkdownEditor = dynamic(() => import('@/components/MarkdownEditor'), {
  loading: () => <EditorSkeleton />,
})
```

## 10. Preload based on user intent

Preload modules when user shows intent (hover, focus).

```tsx
// ❌ No preloading — loads on click (perceived delay)
function EditButton({ postId }) {
  const router = useRouter()
  return (
    <button onClick={() => router.push(`/edit/${postId}`)}>Edit</button>
  )
}

// ✅ Preload on hover
import { preload } from 'react-dom'

function EditButton({ postId }) {
  const router = useRouter()

  const handleMouseEnter = () => {
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

## Attribution

Sourced from [Vercel Engineering's React Best Practices](https://github.com/vercel/next.js/blob/canary/contributing/ai/AGENTS.md).
