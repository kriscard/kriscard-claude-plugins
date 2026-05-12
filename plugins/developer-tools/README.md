# Developer Tools Plugin

Specialist agents and skills for coding, debugging, and frontend audit work.

## Components

### Slash commands

| Command | What it does |
|---|---|
| `/react-patterns` | Explicit invocation of the React audit skill (universal checks + thematic references) |
| `/pr-review` | Comprehensive PR audit: code-reviewer agent + react-patterns skill for React/TSX files |

### Skills

| Skill | Triggers on | Purpose |
|---|---|---|
| `react-patterns` | React/Next.js audit intent, performance, useEffect, modals, SSR/CSR, bundle size | Audits React code — universal checks always; deep-dive references lazy-loaded per intent |

### Agents

| Agent | Lens | When to use |
|---|---|---|
| `coder` | Spec-driven, methodical | "Implement this exact PRD/ADR/brief" |
| `frontend-developer` | Opinionated React patterns | "Build a React feature with modern defaults" |
| `typescript-coder` | Type system specialist | Complex types, generics, "inevitable code" |
| `nextjs-developer` | Next.js / App Router / RSC | Next.js-specific work |
| `frontend-security-coder` | XSS / CSP / sanitization | Client-side security |
| `debugger` | Bug diagnosis | "Why is this broken?" |
| `code-reviewer` | Code quality, security | PR review, quality assurance |
| `code-refactoring-specialist` | Clean code patterns | Reduce complexity, improve naming |
| `ui-ux-designer` | Interface design | Design systems, accessibility |

## How the pieces compose (workflows)

The marketplace doesn't ship a mega-orchestrator. The model picks the right specialist when you describe what you want. For multi-step work, use the slash commands or invoke agents directly.

**Build a React feature**
- Direct: ask Claude → it routes to `frontend-developer` (or `nextjs-developer` for App Router work)
- With a spec: use `coder` agent for strict spec-following

**Audit existing code**
- React/Next.js: `/react-patterns` (or the skill auto-triggers from "is this good?")
- Mixed: `/pr-review` for comprehensive coverage

**Debug an issue**
- Direct: `debugger` agent
- For React perf specifically: `react-patterns` skill loads diagnostic references (bundle, flame graph, re-renders)

**Refactor**
- Direct: `code-refactoring-specialist` agent
- For React patterns specifically: pair with `react-patterns` for opinion

## Philosophy

- **Single-purpose components** — each agent and skill has one clear job
- **No orchestrator skills** — the model picks the right specialist when intent is clear
- **Slash commands for explicit chains** — when you want a specific multi-step workflow, type the command
- **Lazy-loaded references** — react-patterns skill loads only the deep-dive file that matches the user's intent (see `skills/react-patterns/SKILL.md`)

## Installation

These components are auto-available when you install the plugin. Use them by describing the task or invoking commands/agents directly.
