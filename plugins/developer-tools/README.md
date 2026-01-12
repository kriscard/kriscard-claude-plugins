# Developer Tools Plugin

Development agents for coding, frontend, and debugging with intelligent orchestration.

## Orchestration

### code-assistant (Skill)

**NEW!** Intelligent orchestrator that automatically selects the best specialist agent based on your request.

**How it works:**
- Analyzes your coding request (language, framework, task type)
- Automatically selects the optimal agent
- Coordinates multi-agent workflows for complex tasks
- Provides fallback options when ambiguous

**Example:**
```
You: "I need to debug this React component"
  → Automatically invokes: debugger agent

You: "Create a secure Next.js form with TypeScript"
  → Coordinates: nextjs-developer + typescript-coder + frontend-security-coder
```

**Manual override:** You can still directly request specific agents:
- "Use typescript-coder for this"
- "Let the nextjs-developer handle it"

## Agents

### coder
General implementation agent for translating specifications into production code.

### typescript-coder
Expert TypeScript developer focused on writing "inevitable code" - TypeScript that feels natural and effortless to understand.

### frontend-developer
Expert modern frontend developer specializing in React 19+, Vue 3, and cutting-edge web development.

**Specialties:**
- Component composition
- Performance optimization
- Modern tooling (Vite, Vitest, Biome)
- Accessible, type-safe applications

### nextjs-developer
Expert Next.js 14+ developer specializing in App Router architecture.

**Specialties:**
- React Server Components
- Server Actions
- Streaming SSR
- Core Web Vitals optimization

### frontend-security-coder
Expert in secure frontend coding practices.

**Specialties:**
- XSS prevention
- Output sanitization
- Client-side security patterns

### debugger
Debugging specialist for errors, test failures, and unexpected behavior.

## Usage

These agents are automatically available when you install the plugin. Use them when:

- Implementing features from specs
- Writing TypeScript code
- Building frontend applications
- Working with Next.js
- Debugging issues
- Security-focused frontend work
