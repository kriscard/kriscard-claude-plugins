# Tech Stack Catalog

Comprehensive reference of common technology stacks with detailed pros/cons, use cases, and recommendations. Use this to inform tech-stack-advisor agent recommendations and validate user choices.

## Web Application Stacks

### Next.js + TypeScript + Tailwind CSS

**Stack composition**:
- Frontend: Next.js 15+ (React 19, App Router, Server Components)
- Language: TypeScript
- Styling: Tailwind CSS
- Deployment: Vercel, Netlify, or self-hosted

**Best for**:
- SEO-critical applications (marketing sites, blogs, e-commerce)
- Full-stack web apps with server-side rendering
- Teams already familiar with React
- Projects needing fast initial page loads

**Pros**:
- ✅ Excellent DX with hot reload, TypeScript support
- ✅ Best-in-class performance (automatic optimization)
- ✅ Built-in API routes (no separate backend needed)
- ✅ Zero-config deployment on Vercel
- ✅ Massive ecosystem and community
- ✅ Great documentation and learning resources
- ✅ Server Components reduce client JS bundle

**Cons**:
- ❌ Opinionated framework (less flexibility)
- ❌ Vercel vendor lock-in concerns (though can self-host)
- ❌ Learning curve for App Router paradigm
- ❌ Can be overkill for simple static sites
- ❌ Edge runtime limitations for some use cases

**When to recommend**:
- Default choice for most web applications
- Team experience: Beginner to Advanced
- When SEO and performance are priorities
- When using Vercel for deployment

**When NOT to recommend**:
- Need maximum framework flexibility
- Building pure SPA without SSR
- Team strongly prefers different framework

**Typical project structure**:
```
app/
├── (routes)/
│   ├── page.tsx
│   └── api/
components/
lib/
public/
```

---

### TanStack Start + TypeScript

**Stack composition**:
- Frontend: TanStack Start (React Server Components)
- Language: TypeScript
- Router: TanStack Router
- State: TanStack Query
- Deployment: Vercel, Netlify, Node.js

**Best for**:
- Modern full-stack apps prioritizing DX
- Teams wanting better TypeScript inference
- Projects needing type-safe routing and data fetching
- Applications with complex client state

**Pros**:
- ✅ Best-in-class TypeScript experience
- ✅ Framework-agnostic TanStack ecosystem
- ✅ Type-safe routing and data fetching
- ✅ Excellent state management with TanStack Query
- ✅ Less opinionated than Next.js
- ✅ Modern RSC support
- ✅ Great for complex data requirements

**Cons**:
- ❌ Newer framework (smaller community)
- ❌ Fewer learning resources than Next.js
- ❌ Less ecosystem of plugins/extensions
- ❌ May require more configuration
- ❌ Deployment less turnkey than Next.js

**When to recommend**:
- Team values TypeScript DX above all
- Need advanced client-side state management
- Want framework-agnostic patterns
- Intermediate to Advanced developers

**When NOT to recommend**:
- Team needs extensive tutorials/community
- Prefer zero-config solutions
- Beginners to React

---

### Remix + TypeScript

**Stack composition**:
- Frontend: Remix
- Language: TypeScript
- Styling: Tailwind or CSS Modules
- Deployment: Fly.io, Railway, Vercel, self-hosted

**Best for**:
- Server-first applications
- Progressive enhancement patterns
- Projects prioritizing web fundamentals
- Applications with complex forms

**Pros**:
- ✅ Excellent forms and mutations handling
- ✅ Nested routing with data loading
- ✅ Progressive enhancement by default
- ✅ Great for standard web apps
- ✅ Less magical than Next.js
- ✅ Works great without JavaScript

**Cons**:
- ❌ Smaller ecosystem than Next.js
- ❌ More manual configuration needed
- ❌ Deployment less turnkey
- ❌ Learning curve for loader/action pattern

**When to recommend**:
- Building forms-heavy applications
- Team values web standards
- Need progressive enhancement
- Intermediate to Advanced developers

---

### Astro + React/Vue/Svelte

**Stack composition**:
- Frontend: Astro
- UI Framework: React, Vue, Svelte (or mix)
- Language: TypeScript
- Deployment: Vercel, Netlify, Cloudflare Pages

**Best for**:
- Content-focused sites (blogs, docs, marketing)
- Static site generation
- Multi-framework projects
- Performance-critical sites

**Pros**:
- ✅ Zero JS by default (ship only what's needed)
- ✅ Use any UI framework (or multiple)
- ✅ Excellent for content sites
- ✅ Very fast page loads
- ✅ Great for SEO
- ✅ Simple mental model

**Cons**:
- ❌ Less suitable for highly dynamic apps
- ❌ Smaller community than major frameworks
- ❌ Limited built-in state management
- ❌ May need additional tools for complex apps

**When to recommend**:
- Building content sites or blogs
- Performance is top priority
- Want to use multiple frameworks
- Static-first approach works

**When NOT to recommend**:
- Building highly interactive SaaS
- Need complex client state
- Team prefers full framework

---

### Vue 3 + Nuxt 3 + TypeScript

**Stack composition**:
- Frontend: Vue 3 (Composition API)
- Framework: Nuxt 3
- Language: TypeScript
- Styling: Tailwind or UnoCSS
- Deployment: Vercel, Netlify, Cloudflare

**Best for**:
- Teams preferring Vue over React
- Full-stack applications
- Projects wanting progressive framework
- Applications needing SSR or SSG

**Pros**:
- ✅ Simpler than React for many developers
- ✅ Excellent documentation
- ✅ Great TypeScript support in Vue 3
- ✅ Nuxt provides full-stack capabilities
- ✅ Growing ecosystem
- ✅ Server-side rendering built-in

**Cons**:
- ❌ Smaller ecosystem than React
- ❌ Fewer jobs/developers in market
- ❌ Some enterprise tools prefer React
- ❌ Less third-party component libraries

**When to recommend**:
- Team prefers Vue's developer experience
- Building for European/Asian markets (Vue popular there)
- Want simpler alternative to React
- Beginners to web development

---

## Mobile Application Stacks

### React Native + Expo

**Stack composition**:
- Framework: React Native
- Tooling: Expo SDK
- Language: TypeScript
- State: Redux/Zustand/TanStack Query
- Navigation: React Navigation

**Best for**:
- Cross-platform apps (iOS + Android)
- Teams with React/web experience
- Rapid prototyping and MVPs
- Apps using standard mobile features

**Pros**:
- ✅ Write once, deploy iOS + Android
- ✅ Leverage React knowledge
- ✅ Expo simplifies development significantly
- ✅ Hot reload and fast iteration
- ✅ Large ecosystem of libraries
- ✅ OTA updates with Expo
- ✅ Web deployment possible

**Cons**:
- ❌ Performance not quite native
- ❌ Some native features need custom modules
- ❌ Larger app bundle size
- ❌ Expo limitations (can eject if needed)
- ❌ Complex animations can be challenging

**When to recommend**:
- Default choice for most cross-platform apps
- Team has React experience
- Need iOS + Android with one codebase
- MVP or rapid development
- Budget constraints (one codebase vs two)

**When NOT to recommend**:
- Need absolute best performance
- Heavy graphics/gaming
- Very complex native features
- Team strongly prefers native development

---

### React Native (Bare Workflow)

**Stack composition**:
- Framework: React Native (without Expo)
- Language: TypeScript
- Build: Native tooling (Xcode, Android Studio)
- State: Redux/MobX/Zustand

**Best for**:
- Apps needing custom native modules
- Teams with native development expertise
- Performance-critical applications
- When Expo limitations are blocking

**Pros**:
- ✅ Full control over native code
- ✅ Can integrate any native library
- ✅ Better performance tuning possible
- ✅ No Expo limitations

**Cons**:
- ❌ More complex setup and maintenance
- ❌ Need native development knowledge
- ❌ Slower iteration (no Expo tools)
- ❌ Manual configuration for many features

**When to recommend**:
- Need custom native modules
- Have native developers on team
- Hit Expo limitations
- Advanced team

**When NOT to recommend**:
- MVP or rapid development
- Small team without native expertise
- Standard mobile app features

---

### Flutter

**Stack composition**:
- Framework: Flutter
- Language: Dart
- State: Riverpod/Bloc/Provider
- Platform: iOS, Android, Web, Desktop

**Best for**:
- Cross-platform including desktop
- Beautiful, custom UIs
- Apps needing consistent look across platforms
- Teams willing to learn Dart

**Pros**:
- ✅ Truly native performance
- ✅ Beautiful, customizable UI
- ✅ Single codebase for many platforms
- ✅ Excellent tooling and hot reload
- ✅ Backed by Google
- ✅ Great for complex animations

**Cons**:
- ❌ Need to learn Dart
- ❌ Smaller ecosystem than React Native
- ❌ Larger app size
- ❌ Fewer developers in market
- ❌ Platform-specific features can be tricky

**When to recommend**:
- Team willing to learn new language
- Need desktop apps too
- Want consistent UI across platforms
- Complex UI/animation requirements

**When NOT to recommend**:
- Team only knows JavaScript
- Small ecosystem is concern
- Need quick hiring

---

## Backend/API Stacks

### Node.js + Express + PostgreSQL

**Stack composition**:
- Runtime: Node.js
- Framework: Express
- Language: TypeScript
- Database: PostgreSQL
- ORM: Prisma or TypeORM

**Best for**:
- RESTful APIs
- Microservices
- Real-time applications (with Socket.io)
- JavaScript/TypeScript teams

**Pros**:
- ✅ JavaScript everywhere (frontend + backend)
- ✅ Huge ecosystem (npm packages)
- ✅ Good for real-time features
- ✅ Async I/O performs well
- ✅ Easy to scale horizontally

**Cons**:
- ❌ Not ideal for CPU-intensive tasks
- ❌ Callback/async complexity
- ❌ Less structured than opinionated frameworks
- ❌ Type safety requires extra tooling

**When to recommend**:
- Full JavaScript team
- Need real-time features
- Building microservices
- Standard CRUD APIs

---

### FastAPI + PostgreSQL

**Stack composition**:
- Framework: FastAPI
- Language: Python 3.10+
- Database: PostgreSQL
- ORM: SQLAlchemy or Tortoise ORM

**Best for**:
- Modern Python APIs
- Data science/ML integration
- Type-safe APIs
- Projects needing automatic documentation

**Pros**:
- ✅ Extremely fast (async Python)
- ✅ Automatic OpenAPI docs
- ✅ Excellent type hints support
- ✅ Great for ML/data science integration
- ✅ Modern Python async/await
- ✅ Easy to learn and use

**Cons**:
- ❌ Python ecosystem not as vast as Node for web
- ❌ Smaller community than Django
- ❌ Relatively newer framework
- ❌ Fewer deployment options than Node

**When to recommend**:
- Python team or data science integration
- Want automatic API documentation
- Building ML-powered APIs
- Modern Python stack preferred

---

### Go + PostgreSQL

**Stack composition**:
- Language: Go
- Framework: Gin or Echo
- Database: PostgreSQL
- ORM: GORM or sqlx

**Best for**:
- High-performance APIs
- Microservices architecture
- Cloud-native applications
- Systems programming

**Pros**:
- ✅ Excellent performance
- ✅ Great concurrency model
- ✅ Single binary deployment
- ✅ Strong typing
- ✅ Fast compilation
- ✅ Low resource usage

**Cons**:
- ❌ More verbose than Python/Node
- ❌ Steeper learning curve
- ❌ Smaller web framework ecosystem
- ❌ Less rapid prototyping

**When to recommend**:
- Performance is critical
- Building cloud-native services
- Team has Go experience
- Want compiled, type-safe backend

---

### Bun + Hono + SQLite/PostgreSQL

**Stack composition**:
- Runtime: Bun
- Framework: Hono
- Language: TypeScript
- Database: SQLite or PostgreSQL

**Best for**:
- Modern, fast APIs
- Edge deployment
- Lightweight microservices
- TypeScript-first projects

**Pros**:
- ✅ Extremely fast runtime (faster than Node)
- ✅ Built-in TypeScript, bundler, test runner
- ✅ Hono is very lightweight and fast
- ✅ Great for edge functions
- ✅ Simple deployment
- ✅ SQLite support built-in

**Cons**:
- ❌ Very new ecosystem
- ❌ Less stable than Node
- ❌ Fewer packages compatible
- ❌ Limited production use cases so far
- ❌ Smaller community

**When to recommend**:
- Cutting-edge team
- Performance is priority
- Simple API requirements
- Edge deployment (Cloudflare Workers, etc.)

**When NOT to recommend**:
- Production-critical applications
- Need battle-tested ecosystem
- Team prefers stability

---

## CLI Tool Stacks

### Node.js + Commander

**Stack composition**:
- Runtime: Node.js
- CLI Framework: Commander.js
- Language: TypeScript
- Packaging: npm or standalone binary (pkg)

**Best for**:
- JavaScript team building CLI
- Developer tools
- Quick scripts and utilities

**Pros**:
- ✅ Leverage JavaScript knowledge
- ✅ Large npm ecosystem
- ✅ Easy to distribute (npm)
- ✅ Cross-platform

**Cons**:
- ❌ Requires Node runtime
- ❌ Slower startup than compiled languages
- ❌ Larger distribution size

---

### Python + Click/Typer

**Stack composition**:
- Language: Python 3
- CLI Framework: Click or Typer
- Packaging: pip or PyInstaller

**Best for**:
- Data processing CLIs
- Python team tools
- Scripts with complex logic

**Pros**:
- ✅ Excellent for data processing
- ✅ Rich standard library
- ✅ Easy to write and maintain
- ✅ Great for scientific computing

**Cons**:
- ❌ Requires Python runtime
- ❌ Slower than compiled languages
- ❌ Packaging can be complex

---

### Go + Cobra

**Stack composition**:
- Language: Go
- CLI Framework: Cobra
- Packaging: Single binary

**Best for**:
- Professional CLI tools
- Performance-critical tools
- Cloud-native tools

**Pros**:
- ✅ Single binary distribution
- ✅ Fast execution
- ✅ Cross-compilation easy
- ✅ No runtime dependencies

**Cons**:
- ❌ More verbose code
- ❌ Steeper learning curve
- ❌ Slower development

---

## Database Choices

### PostgreSQL

**Best for**: Relational data, complex queries, ACID compliance

**Pros**:
- ✅ Battle-tested and reliable
- ✅ Rich feature set (JSON, full-text search, etc.)
- ✅ Excellent performance
- ✅ Strong consistency guarantees
- ✅ Great tooling and ecosystem

**Cons**:
- ❌ Requires server setup/maintenance
- ❌ Scaling can be complex
- ❌ Higher resource usage than SQLite

**Recommend when**: Default choice for most applications with relational data

---

### SQLite

**Best for**: Embedded databases, mobile apps, small projects, edge

**Pros**:
- ✅ Zero configuration
- ✅ Serverless (file-based)
- ✅ Very fast for reads
- ✅ Perfect for edge/mobile
- ✅ Excellent for development

**Cons**:
- ❌ Limited concurrency (one writer)
- ❌ Not for high-write workloads
- ❌ No network access

**Recommend when**: Single user, edge deployment, mobile apps, simple projects

---

### MongoDB

**Best for**: Document-oriented data, flexible schemas, rapid iteration

**Pros**:
- ✅ Flexible schema
- ✅ Great for unstructured data
- ✅ Horizontal scaling easier
- ✅ JSON-like documents

**Cons**:
- ❌ Less suited for relational data
- ❌ No ACID guarantees by default
- ❌ Can lead to data duplication

**Recommend when**: Highly variable data structures, need flexible schema

---

### Supabase (PostgreSQL + BaaS)

**Best for**: Rapid development, startups, MVPs

**Pros**:
- ✅ Managed PostgreSQL
- ✅ Built-in auth, storage, real-time
- ✅ Auto-generated APIs
- ✅ Generous free tier
- ✅ Great developer experience

**Cons**:
- ❌ Vendor lock-in
- ❌ Less control than self-hosted
- ❌ Costs can scale up

**Recommend when**: Rapid MVP development, small teams, don't want to manage infrastructure

---

## Deployment Platforms

### Vercel

**Best for**: Next.js, frontend applications, edge functions

**Pros**:
- ✅ Zero-config for Next.js
- ✅ Excellent DX
- ✅ Global CDN
- ✅ Preview deployments
- ✅ Generous free tier

**Cons**:
- ❌ Can get expensive at scale
- ❌ Vendor lock-in concerns
- ❌ Limited backend capabilities

---

### Railway

**Best for**: Full-stack apps, databases, backend services

**Pros**:
- ✅ Simple deployment
- ✅ Built-in PostgreSQL
- ✅ Great for full-stack apps
- ✅ Good DX

**Cons**:
- ❌ More expensive than some alternatives
- ❌ Smaller than major cloud providers

---

### Fly.io

**Best for**: Global deployment, edge computing, low latency

**Pros**:
- ✅ Deploy anywhere globally
- ✅ Excellent for low latency
- ✅ Generous free tier
- ✅ Full control (Docker)

**Cons**:
- ❌ More configuration than Vercel
- ❌ Steeper learning curve

---

## Selection Decision Trees

### For Web Applications

```
Need SSR/SEO?
├─ Yes → Next.js or TanStack Start or Remix
│  ├─ Team loves TypeScript DX → TanStack Start
│  ├─ Want zero-config, massive ecosystem → Next.js
│  └─ Love web fundamentals, forms → Remix
└─ No (SPA) → Vite + React/Vue
   └─ Content-focused → Astro
```

### For Mobile Applications

```
Cross-platform?
├─ Yes → React Native + Expo or Flutter
│  ├─ Team knows JavaScript → React Native
│  ├─ Need desktop too → Flutter
│  └─ Want beautiful custom UI → Flutter
└─ No (native) → Swift (iOS) / Kotlin (Android)
```

### For Backend/APIs

```
Team language?
├─ JavaScript/TypeScript → Node.js/Bun + Express/Hono
├─ Python → FastAPI
├─ Go → Gin/Echo
└─ Performance critical → Go

Need ML/Data Science? → FastAPI
Need real-time? → Node.js + Socket.io
Need highest performance? → Go or Rust
```

## Common Combinations

### Full-Stack JavaScript (Most Common)
- Frontend: Next.js
- Backend: Next.js API Routes or separate Node.js
- Database: PostgreSQL + Prisma
- Deployment: Vercel + Railway

### Python Data/ML Stack
- Frontend: Next.js or React
- Backend: FastAPI
- Database: PostgreSQL
- Deployment: Vercel + Fly.io

### Modern Edge Stack
- Frontend: Next.js or TanStack Start
- Backend: Edge Functions (Vercel, Cloudflare)
- Database: Turso (SQLite on edge) or Supabase
- Deployment: Vercel or Cloudflare

### Performance-Critical Stack
- Frontend: Astro + minimal JS
- Backend: Go
- Database: PostgreSQL
- Deployment: Fly.io

---

Use this catalog to inform tech-stack-advisor recommendations. Consider project requirements, team experience, scalability needs, and deployment preferences when recommending stacks.
