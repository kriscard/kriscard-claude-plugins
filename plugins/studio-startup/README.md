# Studio Startup Plugin

Complete workflow orchestration for starting new projects, side projects, and startups - from initial idea to working MVP.

## Overview

The Studio Startup plugin guides you through the entire journey of creating a new project by coordinating multiple specialized skills and agents. It ensures you build the RIGHT thing (product-market fit) in the RIGHT way (solid technical foundation).

### Workflow Phases

1. **Product Strategy** - Vision, market analysis, competitive landscape, OKRs
2. **Requirements** - Detailed specs, user stories, feature breakdown
3. **Tech Selection** - Stack recommendations with rationale and trade-offs
4. **Technical Validation** - Architecture principles, scalability, best practices
5. **System Design** - Detailed architecture, component design, patterns
6. **Implementation** - Full MVP code generation with best practices

## Features

- 🎯 **Guided workflow** from idea to working code
- 🧠 **Smart orchestration** of product-strategist, ideation, cto-advisor, and architecture skills
- 💡 **Intelligent tech recommendations** based on requirements, team, and scale
- 🚀 **Full MVP implementation** with proper structure and documentation
- 📋 **Complete documentation** including product specs, architecture, and setup guides
- ⚙️ **Flexible entry points** - start from any phase based on your needs
- 🎨 **Project type support** - Web apps, mobile apps, APIs, CLI tools

## Installation

### From Marketplace

```bash
# Install from Claude Code plugin marketplace
cc plugin install studio-startup
```

### Local Development

```bash
# Clone or copy this plugin directory
cd path/to/plugins/studio-startup

# Test locally
cc --plugin-dir .
```

## Usage

### Natural Language (Recommended)

Simply describe your project idea in conversation:

```
"Help me start a SaaS project for managing customer feedback"
"I want to build a mobile app for habit tracking"
"Create an API for real-time analytics"
```

The plugin will automatically activate and guide you through the workflow.

### Explicit Command

Use the command for more control:

```bash
# Interactive workflow
/studio-startup:new

# With arguments
/studio-startup:new --type=web --name="My Awesome App"

# Start from specific phase
/studio-startup:new --phase=tech

# All options
/studio-startup:new --type=web --name="Project Name" --phase=strategy
```

#### Command Arguments

- `--type`: Project type (`web`, `mobile`, `api`, `cli`)
- `--name`: Project name (quoted if contains spaces)
- `--phase`: Starting phase (`strategy`, `requirements`, `tech`, `implementation`)

## Configuration

On first run, the plugin will offer to create a settings file with your preferences.

### Settings File

Create `.claude/studio-startup.local.md` in your project root:

```yaml
---
# Studio Startup Plugin Settings
favorite_stacks:
  web:
    - "Next.js + TypeScript + Tailwind CSS"
    - "TanStack Start + TypeScript"
  mobile:
    - "React Native + Expo"
  api:
    - "FastAPI + PostgreSQL"
    - "Node.js + Express + MongoDB"

default_patterns:
  testing: true          # Include test setup
  ci_cd: false          # Skip CI/CD configuration
  docker: true          # Include Dockerfile
  eslint: true          # Include linting

output_preferences:
  default_path: "~/projects"
  git_init: true
  readme_template: "detailed"

team_context:
  experience_level: "intermediate"  # beginner|intermediate|advanced
  team_size: 1
---

Optional notes about your typical project preferences...
```

### Settings Fields

#### `favorite_stacks`
Tech stacks you prefer by project type. The tech-stack-advisor will prioritize these.

#### `default_patterns`
- `testing`: Include test framework setup
- `ci_cd`: Include GitHub Actions or similar
- `docker`: Include Docker configuration
- `eslint`: Include linting/formatting tools

#### `output_preferences`
- `default_path`: Default location for new projects
- `git_init`: Initialize git repository
- `readme_template`: Level of detail in README (`minimal`, `detailed`)

#### `team_context`
- `experience_level`: Influences tech recommendations
- `team_size`: Affects architecture decisions

## Components

### Main Skill: `studio-startup`

The orchestrator skill that coordinates the entire workflow.

**Trigger phrases:**
- "start a project"
- "new startup"
- "side project idea"
- "create an app"
- "build an MVP"
- "help me launch"

### Agent: `tech-stack-advisor`

Analyzes requirements and recommends optimal tech stacks with detailed rationale.

**Considerations:**
- Team experience and familiarity
- Development timeline and budget
- Scalability requirements
- Deployment platforms

### Commands

- `/studio-startup:new` - Start new project workflow

## Output

When the workflow completes, you'll have:

### Generated Files

```
your-project/
├── src/                    # Project source code
├── docs/
│   ├── product-specs.md    # Product strategy & requirements
│   └── architecture.md     # Technical decisions & design
├── README.md               # Setup instructions & overview
├── .studio-startup.json    # Project manifest
├── .gitignore
└── package.json (or equivalent)
```

### Documentation

- **README.md**: Setup instructions, architecture overview, feature list
- **docs/product-specs.md**: Product vision, strategy, detailed requirements
- **docs/architecture.md**: System design, technical decisions, patterns
- **.studio-startup.json**: Project metadata (stack, creation date, plugins used)

### Git Repository

If `git_init: true` in settings, repository is initialized with initial commit.

## Examples

### Web Application

```
User: "Help me build a SaaS app for project management"

Plugin:
1. Gathers product strategy (target users, key features, market)
2. Collects detailed requirements (user stories, workflows)
3. Recommends tech stacks (e.g., Next.js vs TanStack Start)
4. Validates architecture decisions with CTO-level guidance
5. Creates system design with component architecture
6. Implements full MVP with authentication, dashboard, API
7. Generates documentation and deployment guide
```

### Mobile Application

```
User: "Create a React Native app for fitness tracking"

Plugin:
1-2. Product strategy and requirements gathering
3. Recommends mobile stacks (React Native + Expo, state management)
4-5. Architecture validation and design
6. Implements app with navigation, screens, local storage
7. Provides iOS/Android build instructions
```

### API Service

```
User: "Build an API for real-time notifications"

Plugin:
1-2. API requirements and endpoints definition
3. Recommends backend stacks (FastAPI, Node.js, Go)
4-5. API design patterns, WebSocket strategy
6. Implements REST + WebSocket endpoints
7. Generates API documentation and deployment guide
```

## Integration with Other Plugins

Studio Startup coordinates these marketplace plugins:

- **product-strategist** - Product vision and market analysis
- **ideation** - Requirements gathering and specification
- **cto-advisor** - Technical validation and architecture guidance
- **architecture:senior-architect** - Detailed system design
- **frontend-design** - UI/UX implementation (web/mobile)
- **developer-tools/code-assistant** - Code generation and implementation

These plugins must be available in your marketplace for full functionality.

## Troubleshooting

### "Settings file not found"

Create `.claude/studio-startup.local.md` with your preferences, or allow the plugin to create one on first run.

### "Required plugin not available"

Ensure you have the following plugins installed:
- `architecture`
- `developer-tools`
- `ideation`

### "Tech recommendations seem generic"

Update your settings file with:
- More specific `favorite_stacks`
- Accurate `team_context` (experience level, size)
- Project-specific notes in the settings markdown section

## Best Practices

1. **Be detailed in initial idea**: More context = better recommendations
2. **Review each phase**: Don't rush through strategy and requirements
3. **Customize settings**: Update favorite stacks based on experience
4. **Save documentation**: Keep generated docs for reference and iteration
5. **Iterate incrementally**: Use MVP as foundation, enhance over time

## Roadmap

Future enhancements:
- [ ] Persist workflow state for multi-session projects
- [ ] Template library for common project types
- [ ] Integration with deployment platforms (Vercel, Railway, Fly.io)
- [ ] Cost estimation based on tech stack and scale
- [ ] Team collaboration features

## Contributing

Improvements and suggestions welcome! This plugin follows the patterns from the plugin-dev marketplace plugin.

## License

MIT License - see LICENSE file for details
