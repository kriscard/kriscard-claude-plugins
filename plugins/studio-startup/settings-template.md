# Studio Startup Settings Template

Copy this file to `.claude/studio-startup.local.md` in your project root and customize to your preferences.

```markdown
---
# Studio Startup Plugin Settings
favorite_stacks:
  web:
    - "Next.js + TypeScript + Tailwind CSS"
    - "TanStack Start + TypeScript"
    - "Remix + TypeScript"
    - "Astro + React"
  mobile:
    - "React Native + Expo"
    - "Flutter"
    - "React Native (bare workflow)"
  api:
    - "FastAPI + PostgreSQL"
    - "Node.js + Express + MongoDB"
    - "Go + PostgreSQL"
    - "Bun + Hono + SQLite"
  cli:
    - "Node.js + Commander"
    - "Python + Click"
    - "Go + Cobra"

default_patterns:
  testing: true          # Include test framework setup
  ci_cd: false          # Skip CI/CD configuration initially
  docker: true          # Include Dockerfile
  eslint: true          # Include linting/formatting tools
  env_example: true     # Create .env.example file

output_preferences:
  default_path: "~/projects"
  git_init: true
  readme_template: "detailed"  # minimal | detailed
  include_license: true
  license_type: "MIT"

team_context:
  experience_level: "intermediate"  # beginner | intermediate | advanced
  team_size: 1
  timezone: "America/New_York"

deployment_preferences:
  web_hosting:
    - "Vercel"
    - "Netlify"
  backend_hosting:
    - "Railway"
    - "Fly.io"
  database:
    - "Supabase"
    - "PlanetScale"
---

## Personal Notes

Add any additional context about your typical project preferences here:
- Preferred UI libraries (shadcn/ui, Material UI, etc.)
- State management preferences (Zustand, Redux, TanStack Query)
- Authentication methods (Auth.js, Clerk, Supabase Auth)
- Any specific requirements or constraints for your projects
```

## Field Descriptions

### `favorite_stacks`

Define your preferred technology stacks by project type. The tech-stack-advisor agent will prioritize these options when making recommendations, but will suggest alternatives if requirements demand it.

**Tips:**
- List stacks in priority order
- Include full stack (frontend + backend + database)
- Be specific about versions if needed (e.g., "React 19")

### `default_patterns`

Boolean flags for common project patterns:

- **testing**: Include test framework setup (Jest, Vitest, Pytest, etc.)
- **ci_cd**: Include CI/CD configuration (GitHub Actions, GitLab CI)
- **docker**: Include Dockerfile and docker-compose.yml
- **eslint**: Include linting/formatting (ESLint, Prettier, Ruff)
- **env_example**: Create .env.example with required environment variables

### `output_preferences`

Control how generated projects are structured:

- **default_path**: Where to create new projects (can be overridden)
- **git_init**: Initialize git repository with initial commit
- **readme_template**: Level of detail in generated README
  - `minimal`: Basic setup instructions only
  - `detailed`: Comprehensive docs with architecture, features, deployment
- **include_license**: Add LICENSE file to project
- **license_type**: Which license to use (MIT, Apache-2.0, GPL-3.0, etc.)

### `team_context`

Information about your team/workflow that influences recommendations:

- **experience_level**: Affects tech stack complexity
  - `beginner`: Prefer simpler, well-documented stacks
  - `intermediate`: Balance between simplicity and power
  - `advanced`: Can handle complex, cutting-edge technologies
- **team_size**: Influences architecture decisions
  - 1-2: Simpler monolithic architectures
  - 3-5: Modular monoliths or light microservices
  - 6+: Consider microservices, clear boundaries
- **timezone**: For deployment scheduling and maintenance windows

### `deployment_preferences`

Preferred hosting platforms by service type. Tech-stack-advisor considers these when making deployment recommendations.

**Common options:**
- **Web hosting**: Vercel, Netlify, Cloudflare Pages, AWS Amplify
- **Backend hosting**: Railway, Fly.io, Render, Heroku, AWS, Google Cloud
- **Database**: Supabase, PlanetScale, Neon, MongoDB Atlas

## Examples

### Solo Developer, Modern Web Focus

```yaml
favorite_stacks:
  web:
    - "Next.js + TypeScript + Tailwind CSS"
    - "TanStack Start + TypeScript"
  api:
    - "Next.js API Routes"
    - "Bun + Hono"

team_context:
  experience_level: "intermediate"
  team_size: 1

deployment_preferences:
  web_hosting: ["Vercel"]
  database: ["Supabase", "Turso"]
```

### Team of 5, Enterprise Focus

```yaml
favorite_stacks:
  web:
    - "Next.js + TypeScript + Material UI"
  api:
    - "Node.js + Express + PostgreSQL"
    - "Go + PostgreSQL"

default_patterns:
  testing: true
  ci_cd: true
  docker: true

team_context:
  experience_level: "advanced"
  team_size: 5

deployment_preferences:
  backend_hosting: ["AWS", "Google Cloud"]
  database: ["AWS RDS", "Google Cloud SQL"]
```

### Indie Hacker, Mobile + Backend

```yaml
favorite_stacks:
  mobile:
    - "React Native + Expo"
  api:
    - "FastAPI + PostgreSQL"
    - "Supabase (BaaS)"

team_context:
  experience_level: "intermediate"
  team_size: 1

deployment_preferences:
  backend_hosting: ["Railway", "Fly.io"]
  database: ["Supabase", "PlanetScale"]
```

## Best Practices

1. **Keep it updated**: Review and update settings as you learn new technologies
2. **Be realistic**: Set experience_level honestly - it affects recommendations
3. **Prioritize favorites**: List stacks you WANT to use, not just know
4. **Use notes section**: Document patterns you've learned work well
5. **Project-specific overrides**: You can always choose different options during workflow

## Troubleshooting

**Settings not being used:**
- Verify file is at `.claude/studio-startup.local.md` in project root
- Check YAML syntax is valid (use a YAML validator)
- Ensure file has proper frontmatter delimiters (`---`)

**Tech recommendations ignore favorites:**
- Agent considers requirements first - favorites are prioritized only when suitable
- Check experience_level matches stack complexity
- Add reasoning in notes section for better context
