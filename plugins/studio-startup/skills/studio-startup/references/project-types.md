# Project Type-Specific Guidance

Detailed guidance for orchestrating workflows based on project type. Each type has unique considerations for strategy, requirements, tech selection, and implementation.

## Web Applications

### Characteristics

- User interfaces in browser
- Server-side and/or client-side rendering
- APIs for data fetching
- Responsive design considerations
- SEO often important
- Authentication/authorization common

### Strategy Phase Considerations

**Key questions for product-strategist**:
- Is SEO critical? (Marketing site vs internal tool)
- Who are the users? (B2C vs B2B vs internal)
- What's the core value proposition?
- Competitive landscape - how differentiate?
- Monetization strategy?

**Output focus**: Clear user personas, value prop, competitive advantages

### Requirements Phase Considerations

**Emphasize**:
- User flows and journeys
- Page/route structure
- Authentication requirements
- Data models and relationships
- Third-party integrations

**Common features to clarify**:
- User authentication (email/password, OAuth, magic links)
- Admin panels or dashboards
- Search functionality
- Real-time updates
- File uploads
- Email notifications
- Analytics tracking

### Tech Selection Considerations

**Factors to evaluate**:
1. **SSR vs CSR**: Does SEO matter? → SSR (Next.js, Remix)
2. **Rendering strategy**: Static, SSR, ISR, CSR?
3. **API architecture**: BFF, REST, GraphQL, tRPC?
4. **Database**: Relational vs NoSQL?
5. **Authentication**: Custom vs Auth.js vs third-party (Clerk, Auth0)?
6. **Deployment**: Serverless (Vercel) vs traditional (Railway, Fly.io)?

**Recommended stacks by scenario**:

**SaaS B2B app**:
- Next.js + TypeScript + PostgreSQL + Prisma
- Auth.js or Clerk for auth
- Vercel for deployment
- Why: Enterprise features, good performance, mature ecosystem

**Content-heavy site** (blog, docs, marketing):
- Next.js or Astro + TypeScript
- CMS (Contentful, Sanity) or MDX
- Vercel or Netlify
- Why: SEO-optimized, fast page loads, great content management

**Internal tool/admin panel**:
- Next.js or TanStack Start + TypeScript
- PostgreSQL or Supabase
- Railway or self-hosted
- Why: Rapid development, doesn't need SEO, can prioritize features over polish

**Real-time collaborative app**:
- Next.js + TypeScript + WebSockets or Supabase Realtime
- PostgreSQL
- Railway or Fly.io (for WebSocket support)
- Why: Good real-time support, can scale

### Implementation Phase Specifics

**Key components to implement**:

1. **Layout and navigation**
   - Header, footer, sidebar
   - Mobile responsive nav
   - Breadcrumbs if complex structure

2. **Authentication pages**
   - Login, signup, forgot password
   - Protected routes middleware
   - Session management

3. **Core feature pages**
   - Dashboard/home
   - Main feature pages (2-3 for MVP)
   - Settings/profile page

4. **API layer**
   - CRUD operations for main entities
   - Authentication endpoints
   - Data validation

5. **Database schema**
   - User table with auth fields
   - Main entity tables
   - Relationships and indexes

**Frontend patterns to use**:
- Server Components for data fetching (Next.js App Router)
- Client Components for interactivity
- API routes or server actions for mutations
- Optimistic updates for better UX
- Loading states and error boundaries

**Testing considerations**:
- Unit tests for utility functions
- Integration tests for API routes
- E2E tests for critical flows (Playwright)
- Don't over-test in MVP - focus on critical paths

### Finalization Specifics

**README should include**:
- Prerequisites (Node version, database)
- Environment variables (.env.example)
- Setup instructions (install, db setup, seed data)
- Running locally (dev server, tests, build)
- Deployment guide (Vercel or chosen platform)
- Folder structure explanation
- Key technologies and why chosen

**Consider including**:
- Database migrations/schema file
- Seed data script for development
- .env.example with all required vars
- Docker setup if requested

---

## Mobile Applications

### Characteristics

- Native or cross-platform
- Touch-first UI/UX
- Offline considerations
- App store deployment
- Push notifications common
- Platform-specific features (camera, GPS, etc.)

### Strategy Phase Considerations

**Key questions**:
- iOS only, Android only, or both?
- Native features required? (Camera, GPS, notifications, etc.)
- Offline functionality needed?
- Target demographics and device prevalence?
- Monetization: Free, paid, freemium, IAP?

**Output focus**: Platform strategy, core mobile-specific features, user acquisition plan

### Requirements Phase Considerations

**Emphasize**:
- Screen flows and navigation structure
- Platform-specific features (iOS vs Android)
- Offline/online modes
- Data sync strategies
- Push notification requirements
- App permissions needed

**Common features to clarify**:
- User onboarding flow
- Authentication (email, social, phone)
- Main feature screens (typically 3-5 for MVP)
- Settings and profile
- Notifications
- Offline functionality
- Camera/photo integration
- Location services

### Tech Selection Considerations

**Factors to evaluate**:
1. **Cross-platform vs Native**: Budget, timeline, team skills
2. **Performance needs**: Simple CRUD vs complex animations/graphics
3. **Native features**: Camera, AR, complex gestures?
4. **Team expertise**: JavaScript (RN) vs Dart (Flutter) vs native
5. **Backend**: BaaS (Firebase, Supabase) vs custom API?

**Recommended stacks by scenario**:

**Cross-platform MVP** (most common):
- React Native + Expo
- Supabase or Firebase for backend
- Expo EAS for builds
- Why: Fast development, shared codebase, good enough performance

**Performance-critical or complex UI**:
- Flutter
- Custom backend (Node/Python/Go)
- Platform-specific CI/CD
- Why: Native performance, beautiful customizable UI

**Native features required**:
- React Native (bare workflow) or native (Swift/Kotlin)
- Custom backend
- Platform-specific tooling
- Why: Full access to native APIs

**Simple CRUD app**:
- React Native + Expo
- Supabase (BaaS - no backend code needed)
- Expo EAS
- Why: Fastest development, managed backend

### Implementation Phase Specifics

**Key components to implement**:

1. **Navigation structure**
   - Bottom tabs or drawer navigation
   - Stack navigator for nested screens
   - Deep linking setup

2. **Authentication screens**
   - Onboarding/welcome
   - Login/signup
   - Auth persistence

3. **Main feature screens**
   - 2-4 core screens for MVP
   - List views with infinite scroll
   - Detail views
   - Create/edit forms

4. **State management**
   - Global state (Zustand/Redux/Context)
   - Server state (TanStack Query)
   - Local storage for persistence

5. **Backend integration**
   - API client setup
   - Authentication flow
   - Data fetching and caching
   - Error handling

**Mobile-specific patterns**:
- Optimistic updates for perceived performance
- Loading skeletons
- Pull-to-refresh
- Proper keyboard handling
- Platform-specific styling (iOS vs Android)
- Responsive to different screen sizes

**Testing considerations**:
- Unit tests for business logic
- Component tests with React Native Testing Library
- E2E tests with Maestro or Detox (optional for MVP)
- Manual testing on iOS and Android simulators

### Finalization Specifics

**README should include**:
- Prerequisites (Node, Expo CLI, Xcode/Android Studio)
- Environment setup for iOS/Android
- Running on simulators/emulators
- Running on physical devices
- Building for TestFlight/Google Play Beta
- Environment variables
- Troubleshooting common issues

**Mobile-specific artifacts**:
- app.json or app.config.js with proper configuration
- .env.example with API keys
- Icons and splash screen (Expo can generate)
- App store assets (screenshots, descriptions) - guidelines only

---

## APIs / Backend Services

### Characteristics

- No user interface (or minimal admin)
- Focus on data operations
- API contracts important
- Performance and scalability critical
- Documentation crucial
- Often microservices architecture

### Strategy Phase Considerations

**Key questions**:
- Who consumes this API? (Frontend, mobile, third-parties?)
- What's the core domain model?
- Performance/latency requirements?
- Security and auth requirements?
- Integration with other services?

**Output focus**: Clear API purpose, consumers, domain model, performance SLAs

### Requirements Phase Considerations

**Emphasize**:
- API endpoints and operations (CRUD, custom)
- Data models and relationships
- Authentication and authorization
- Rate limiting requirements
- Validation rules
- Error handling strategy

**Common features to clarify**:
- RESTful vs GraphQL vs gRPC
- Authentication method (JWT, API keys, OAuth)
- Pagination strategy
- Filtering and sorting
- Webhook support
- File upload/download
- Real-time features (WebSockets, SSE)

### Tech Selection Considerations

**Factors to evaluate**:
1. **Language**: JavaScript/TypeScript, Python, Go, Rust?
2. **Framework**: Express, FastAPI, Gin, Axum?
3. **Database**: PostgreSQL, MongoDB, MySQL?
4. **API style**: REST, GraphQL, gRPC?
5. **Documentation**: OpenAPI/Swagger?
6. **Deployment**: Serverless, containers, traditional servers?

**Recommended stacks by scenario**:

**Standard REST API**:
- Node.js/Bun + Express/Hono + PostgreSQL
- TypeScript for type safety
- Prisma ORM
- Deployed on Railway or Fly.io
- Why: JavaScript everywhere, rapid development, good ecosystem

**Python/ML-integrated API**:
- FastAPI + PostgreSQL
- SQLAlchemy ORM
- Deployed on Fly.io or Railway
- Why: Great for ML models, excellent docs generation, modern Python

**High-performance API**:
- Go + Gin/Echo + PostgreSQL
- Deployed on Fly.io or self-hosted
- Why: Excellent performance, low resource usage, scales well

**GraphQL API**:
- Node.js + Apollo Server + PostgreSQL
- TypeScript + Prisma
- Deployed on Railway
- Why: Flexible queries, strong typing, good tooling

### Implementation Phase Specifics

**Key components to implement**:

1. **API structure**
   - Route definitions and handlers
   - Middleware (auth, logging, error handling)
   - Request validation
   - Response formatting

2. **Database layer**
   - Schema/models definition
   - Migrations
   - Seed data for development
   - Indexes for performance

3. **Core endpoints** (MVP: 5-10 endpoints)
   - Authentication (login, register, refresh)
   - Main resource CRUD
   - List with filtering/pagination
   - Health check endpoint

4. **Authentication & Authorization**
   - JWT or session-based auth
   - Role-based access control (if needed)
   - API key authentication (if needed)

5. **Documentation**
   - OpenAPI/Swagger spec
   - Auto-generated docs
   - Example requests/responses
   - Authentication guide

**Backend patterns to use**:
- Repository pattern for data access
- Service layer for business logic
- DTOs for request/response
- Proper error handling with status codes
- Logging for debugging
- Environment-based configuration

**Testing considerations**:
- Unit tests for business logic
- Integration tests for endpoints
- Database transaction tests
- Authentication/authorization tests
- Load testing for performance (optional for MVP)

### Finalization Specifics

**README should include**:
- Prerequisites (language runtime, database)
- Environment variables
- Database setup and migrations
- Running locally
- Running tests
- API documentation link
- Deployment guide
- Common issues and debugging

**API-specific artifacts**:
- OpenAPI/Swagger spec file
- Postman collection (optional)
- Example .env file
- Database schema diagram (optional)
- API versioning strategy

---

## CLI Tools

### Characteristics

- Command-line interface
- No graphical UI
- Often for automation or developer tools
- UNIX philosophy (do one thing well)
- Scriptable and composable

### Strategy Phase Considerations

**Key questions**:
- Who uses this CLI? (Developers, ops, end users?)
- What problem does it solve?
- Will it be part of CI/CD?
- Interactive or scriptable?
- Cross-platform requirements?

**Output focus**: Clear CLI purpose, target users, key commands

### Requirements Phase Considerations

**Emphasize**:
- Command structure and subcommands
- Flags and arguments
- Configuration file format
- Output format (human-readable, JSON, etc.)
- Error handling and help text

**Common features to clarify**:
- Interactive mode vs flags
- Configuration file support
- Progress indicators for long operations
- Color output support
- Dry-run mode
- Verbose/debug modes
- Auto-completion support

### Tech Selection Considerations

**Factors to evaluate**:
1. **Language**: Node.js (JavaScript), Python, Go, Rust?
2. **Distribution**: npm, pip, cargo, standalone binary?
3. **Dependency requirements**: Runtime needed or standalone?
4. **Performance**: Startup time critical?
5. **Cross-platform**: Windows support needed?

**Recommended stacks by scenario**:

**Developer tool (JS ecosystem)**:
- Node.js + TypeScript + Commander.js
- Distributed via npm
- Why: Easy for JS developers, npm distribution simple

**System tool (performance critical)**:
- Go + Cobra
- Distributed as single binary
- Why: Fast, no runtime, easy distribution

**Data processing tool**:
- Python + Click or Typer
- Distributed via pip
- Why: Great for data operations, rich ecosystem

**Cross-platform utility**:
- Rust + clap
- Distributed as binary
- Why: Excellent performance, no runtime, safe

### Implementation Phase Specifics

**Key components to implement**:

1. **CLI structure**
   - Main command and subcommands
   - Flag/argument parsing
   - Help text and usage examples

2. **Core functionality**
   - 2-4 main commands for MVP
   - Input validation
   - Output formatting
   - Error handling

3. **Configuration**
   - Config file support (optional)
   - Environment variables
   - Defaults

4. **User experience**
   - Colored output (with disable flag)
   - Progress bars for long operations
   - Interactive prompts (if needed)
   - Clear error messages

**CLI patterns to use**:
- UNIX conventions (--help, --version, exit codes)
- Consistent flag naming
- Support for pipes and redirection
- Quiet and verbose modes
- Dry-run for destructive operations

**Testing considerations**:
- Unit tests for core logic
- Integration tests for commands
- Test output formatting
- Test error cases
- Test with different flags/arguments

### Finalization Specifics

**README should include**:
- Installation instructions
- Quick start examples
- Command reference
- Configuration options
- Examples for common use cases
- Development setup
- Contributing guide (if open source)

**CLI-specific artifacts**:
- Shell completion scripts (bash, zsh, fish)
- Man page (optional)
- Example configuration file
- Docker image (optional)

---

## Hybrid Applications

### Progressive Web Apps (PWAs)

**Characteristics**: Web apps that work offline and can install on devices

**Key considerations**:
- Service worker for offline
- Manifest for installation
- Push notification support
- Responsive design critical

**Recommended stack**:
- Next.js or standard web stack
- Workbox for service workers
- Progressive enhancement

### Desktop Applications (Electron/Tauri)

**Characteristics**: Native desktop apps using web technologies

**Key considerations**:
- Native OS integration
- File system access
- Auto-updates
- Distribution (app stores or direct)

**Recommended stack**:
- Electron (mature) or Tauri (modern, smaller)
- React/Vue for UI
- Native APIs for OS features

---

## Decision Matrix

### When to Choose Each Project Type

**Web Application** when:
- Need wide accessibility (any device with browser)
- SEO important
- Don't need native mobile features
- Prefer single codebase for all platforms

**Mobile Application** when:
- Mobile-first or mobile-only
- Need native features (camera, GPS, notifications)
- App store presence important
- Touch-optimized UX critical

**API/Backend** when:
- Multiple client types (web, mobile, third-party)
- Microservices architecture
- Separate frontend/backend teams
- Complex business logic best on server

**CLI Tool** when:
- Automation and scripting needed
- Developer tool
- Part of CI/CD pipeline
- No UI needed

---

Use this guide to tailor the orchestration workflow based on project type. Each type has unique considerations that affect strategy, requirements gathering, tech selection, and implementation approach.
