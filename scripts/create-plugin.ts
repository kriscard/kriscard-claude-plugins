#!/usr/bin/env node

import {
  mkdirSync,
  writeFileSync,
  existsSync,
  readFileSync,
} from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const projectRoot = resolve(__dirname, '..');

type OrchestrationPattern =
  | 'skill-based'
  | 'command-based'
  | 'hybrid'
  | 'meta'
  | 'agent-only';

interface PluginConfig {
  name: string;
  description: string;
  author: {
    name: string;
    email: string;
  };
  pattern: OrchestrationPattern;
  includeAgents: boolean;
  includeCommands: boolean;
  includeSkills: boolean;
  includeHooks: boolean;
}

function validatePluginName(name: string): string[] {
  const errors: string[] = [];

  if (!/^[a-z][a-z0-9-]*$/.test(name)) {
    errors.push('Plugin name must be kebab-case (lowercase with hyphens)');
  }

  if (name.length < 3) {
    errors.push('Plugin name must be at least 3 characters');
  }

  const pluginPath = resolve(projectRoot, 'plugins', name);
  if (existsSync(pluginPath)) {
    errors.push(`Plugin "${name}" already exists`);
  }

  return errors;
}

function getDefaultAuthor() {
  try {
    const marketplacePath = resolve(
      projectRoot,
      '.claude-plugin/marketplace.json'
    );
    const marketplace = JSON.parse(readFileSync(marketplacePath, 'utf-8'));
    return marketplace.owner;
  } catch {
    return {
      name: 'Your Name',
      email: 'your.email@example.com',
    };
  }
}

function createPluginStructure(config: PluginConfig) {
  const pluginPath = resolve(projectRoot, 'plugins', config.name);

  console.log(`\n📦 Creating plugin: ${config.name}`);

  // Create main directories
  mkdirSync(pluginPath, { recursive: true });
  mkdirSync(resolve(pluginPath, '.claude-plugin'), { recursive: true });

  // Create component directories if requested
  if (config.includeAgents) {
    mkdirSync(resolve(pluginPath, 'agents'), { recursive: true });
    console.log('  ✓ Created agents/');
  }

  if (config.includeCommands) {
    mkdirSync(resolve(pluginPath, 'commands'), { recursive: true });
    console.log('  ✓ Created commands/');
  }

  if (config.includeSkills) {
    mkdirSync(resolve(pluginPath, 'skills'), { recursive: true });
    console.log('  ✓ Created skills/');
  }

  if (config.includeHooks) {
    mkdirSync(resolve(pluginPath, 'hooks'), { recursive: true });
    console.log('  ✓ Created hooks/');
  }

  // Create plugin.json
  const pluginJson = {
    name: config.name,
    version: '0.1.0',
    description: config.description,
    author: config.author,
    license: 'MIT',
    keywords: [],
  };

  writeFileSync(
    resolve(pluginPath, '.claude-plugin/plugin.json'),
    JSON.stringify(pluginJson, null, 2) + '\n'
  );
  console.log('  ✓ Created .claude-plugin/plugin.json');

  // Create README.md
  const readme = `# ${toTitleCase(config.name)} Plugin

${config.description}

## Installation

\`\`\`bash
/plugin marketplace add kriscard/kriscard-claude-plugins
/plugin install ${config.name}@kriscard
\`\`\`

## What's Included

${config.includeSkills ? '### Skills\n\nTODO: Document your skills here\n' : ''}
${config.includeCommands ? '### Commands\n\nTODO: Document your commands here\n' : ''}
${config.includeAgents ? '### Agents\n\nTODO: Document your agents here\n' : ''}
${config.includeHooks ? '### Hooks\n\nTODO: Document your hooks here\n' : ''}

## Usage

TODO: Add usage examples

## License

MIT
`;

  writeFileSync(resolve(pluginPath, 'README.md'), readme);
  console.log('  ✓ Created README.md');

  // Create .gitignore if hooks are included
  if (config.includeHooks) {
    const gitignore = `# Local configuration files
.claude/*.local.md

# Development files
*.swp
*.swo
*~
.DS_Store

# IDE files
.idea/
.vscode/
*.iml
`;
    writeFileSync(resolve(pluginPath, '.gitignore'), gitignore);
    console.log('  ✓ Created .gitignore');
  }

  // Create orchestrator templates based on pattern
  createOrchestratorTemplates(pluginPath, config);

  console.log(`\n✅ Plugin created successfully at plugins/${config.name}`);
  console.log(`   Pattern: ${config.pattern}`);
  console.log('\nNext steps:');
  console.log(`  1. Implement orchestrator based on ${config.pattern} pattern`);
  console.log('  2. Add supporting components (agents, commands, skills, hooks)');
  console.log('  3. Update the README.md with documentation');
  console.log('  4. Run "pnpm run sync" to update marketplace.json');
  console.log('  5. Test with: cc --plugin-dir ./plugins/' + config.name);
  console.log('\nSee docs/ORCHESTRATION-PATTERNS.md for detailed guidance');
}

function createOrchestratorTemplates(
  pluginPath: string,
  config: PluginConfig
) {
  switch (config.pattern) {
    case 'skill-based':
      createSkillOrchestrator(pluginPath, config);
      break;
    case 'command-based':
      createCommandOrchestrator(pluginPath, config);
      break;
    case 'hybrid':
      createSkillOrchestrator(pluginPath, config);
      createCommandOrchestrator(pluginPath, config);
      break;
    case 'meta':
      createMetaOrchestrator(pluginPath, config);
      break;
    case 'agent-only':
      // No orchestrator - create agent template instead
      createAgentTemplate(pluginPath, config);
      break;
  }
}

function createSkillOrchestrator(pluginPath: string, config: PluginConfig) {
  const skillDir = resolve(pluginPath, 'skills', `${config.name}-workflow`);
  mkdirSync(skillDir, { recursive: true });

  const skillContent = `---
name: ${config.name}-workflow
description: Use when [describe when this skill should trigger]. Triggers on [specific user phrases or intents].
---

# ${toTitleCase(config.name)} Workflow

## Purpose

This skill orchestrates the complete ${config.name} workflow, coordinating multiple components to deliver a seamless user experience.

## When to Use

Triggers automatically when:
- User mentions [key trigger phrases]
- Context indicates [specific intent]
- [Other triggering conditions]

## Workflow Phases

### Phase 1: Assessment
[Analyze user input and determine needs]

### Phase 2: Coordination
[Invoke necessary agents, load sub-skills, use MCP tools]

### Phase 3: Execution
[Execute the multi-step workflow]

### Phase 4: Delivery
[Present results to user]

## Components Coordinated

- **Agents**: [List agents this skill coordinates]
- **Sub-skills**: [List any sub-skills loaded]
- **MCP Tools**: [List MCP integrations used]
- **Outputs**: [Describe what gets delivered]

## Examples

### Example 1
\`\`\`
User: [example user input]

Skill triggers and:
1. [Step 1]
2. [Step 2]
3. [Step 3]

Result: [What user receives]
\`\`\`

### Example 2
\`\`\`
User: [another example]

Skill coordinates:
- Agent X for [task]
- Skill Y for [task]
- MCP Z for [task]

Result: [Outcome]
\`\`\`

## Error Handling

- If [error condition]: [fallback strategy]
- If [component unavailable]: [degraded functionality]

## See Also

- [Related skills or commands]
- docs/ORCHESTRATION-PATTERNS.md#skill-based-orchestration
`;

  writeFileSync(resolve(skillDir, 'SKILL.md'), skillContent);
  console.log(`  ✓ Created skill orchestrator: skills/${config.name}-workflow/SKILL.md`);
}

function createCommandOrchestrator(pluginPath: string, config: PluginConfig) {
  const commandsDir = resolve(pluginPath, 'commands');
  mkdirSync(commandsDir, { recursive: true });

  const commandContent = `---
description: ${config.description}
allowed-tools: [Bash, Read, Write, Task, Skill]
---

# ${toTitleCase(config.name)} Command

Orchestrates the ${config.name} workflow with explicit user control.

## Usage

\`\`\`
/${config.name}
\`\`\`

## What This Does

This command coordinates multiple components to:

1. [Step 1 description]
2. [Step 2 description]
3. [Step 3 description]

## Orchestration Steps

### Step 1: Load Context
\`\`\`
Load required skills/configuration
Check prerequisites
\`\`\`

### Step 2: Coordinate Components
\`\`\`
Invoke agent X for [purpose]
Use skill Y for [purpose]
Call MCP tool Z for [purpose]
\`\`\`

### Step 3: Execute Workflow
\`\`\`
[Describe main workflow execution]
\`\`\`

### Step 4: Present Results
\`\`\`
[How results are shown to user]
\`\`\`

## Examples

\`\`\`bash
# Basic usage
/${config.name}

# With options (if applicable)
/${config.name} --option value
\`\`\`

## Error Handling

- Component missing: [fallback behavior]
- Workflow fails: [error recovery]

## See Also

- Related commands: [list]
- docs/ORCHESTRATION-PATTERNS.md#command-based-orchestration
`;

  writeFileSync(resolve(commandsDir, `${config.name}.md`), commandContent);
  console.log(`  ✓ Created command orchestrator: commands/${config.name}.md`);
}

function createMetaOrchestrator(pluginPath: string, config: PluginConfig) {
  const skillDir = resolve(pluginPath, 'skills', 'meta-orchestrator');
  mkdirSync(skillDir, { recursive: true });

  const metaContent = `---
name: meta-orchestrator
description: Use when starting any conversation - enforces [your rule] across all interactions
---

<EXTREMELY-IMPORTANT>
[Non-negotiable rule that must be followed]

This is not optional. This is not negotiable.
</EXTREMELY-IMPORTANT>

# Meta-Orchestrator: ${toTitleCase(config.name)}

## Purpose

This meta-orchestrator enforces system-level behavior across ALL interactions with Claude Code.

## What It Enforces

[Clear description of what behavior is enforced]

## How It Works

1. **Trigger**: [When does this activate? Always? Specific events?]
2. **Check**: [What does it check for?]
3. **Enforce**: [What action does it take?]
4. **Bypass**: [Are there ANY exceptions? Be very careful here]

## Examples

### Example 1: Enforcement in Action
\`\`\`
User message received
     ↓
Meta-orchestrator activates
     ↓
Checks: [what it checks]
     ↓
Enforces: [what it enforces]
     ↓
Result: [outcome]
\`\`\`

## Red Flags

Thoughts that indicate bypassing (must be prevented):

| Thought | Reality |
|---------|---------|
| "[Rationalization]" | [Truth] |
| "[Excuse]" | [Fact] |

## Integration

This meta-orchestrator works with:
- [Other skills it coordinates with]
- [Commands it affects]
- [Agents it influences]

## See Also

- docs/ORCHESTRATION-PATTERNS.md#meta-orchestration
`;

  writeFileSync(resolve(skillDir, 'SKILL.md'), metaContent);
  console.log(`  ✓ Created meta-orchestrator: skills/meta-orchestrator/SKILL.md`);
}

function createAgentTemplate(pluginPath: string, config: PluginConfig) {
  const agentsDir = resolve(pluginPath, 'agents');
  mkdirSync(agentsDir, { recursive: true });

  const agentContent = `---
name: ${config.name}-agent
description: [Brief description of what this agent does]
tools: [Read, Write, Bash]
model: sonnet
color: blue
---

# ${toTitleCase(config.name)} Agent

You are a specialized agent for [specific purpose].

## Expertise

- [Area of expertise 1]
- [Area of expertise 2]
- [Area of expertise 3]

## When to Activate

Trigger on:
- [Context 1]
- [Context 2]
- [User intent 3]

## Workflow

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Guidelines

- [Guideline 1]
- [Guideline 2]
- [Guideline 3]

## Examples

### Example 1
\`\`\`
User: [example request]
Agent: [how you respond]
\`\`\`
`;

  writeFileSync(resolve(agentsDir, `${config.name}-agent.md`), agentContent);
  console.log(`  ✓ Created agent template: agents/${config.name}-agent.md`);
}

function toTitleCase(str: string): string {
  return str
    .split('-')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

function main() {
  const args = process.argv.slice(2);

  if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
    console.log(`
Usage: pnpm run create-plugin <plugin-name> [options]

Create a new Claude Code plugin with proper structure and orchestration pattern.

Arguments:
  <plugin-name>        Plugin name in kebab-case (e.g., my-plugin)

Options:
  --description <desc> Plugin description (required)
  --pattern <type>     Orchestration pattern (default: agent-only)
                       Options: skill-based, command-based, hybrid, meta, agent-only
  --agents             Include agents/ directory
  --commands           Include commands/ directory
  --skills             Include skills/ directory
  --hooks              Include hooks/ directory
  --all                Include all component directories

Orchestration Patterns:
  skill-based          Implicit triggering via natural language (e.g., ideation)
  command-based        Explicit /command invocation (e.g., /daily-startup)
  hybrid               Both skills and commands (e.g., architecture)
  meta                 Always-on enforcement (e.g., using-superpowers)
  agent-only           Independent agents, no orchestrator (e.g., developer-tools)

Examples:
  # Skill-based workflow plugin
  pnpm run create-plugin workflow --description "Task workflow" --pattern skill-based

  # Command-based automation
  pnpm run create-plugin daily-tasks --description "Daily automation" --pattern command-based

  # Hybrid plugin with both
  pnpm run create-plugin advisor --description "Advisory toolkit" --pattern hybrid

  # Agent-only specialists
  pnpm run create-plugin specialists --description "Code specialists" --pattern agent-only --all

See docs/ORCHESTRATION-PATTERNS.md for detailed guidance on choosing patterns.
`);
    process.exit(0);
  }

  const pluginName = args[0];
  const errors = validatePluginName(pluginName);

  if (errors.length > 0) {
    console.error('\n❌ Invalid plugin name:');
    errors.forEach((err) => console.error(`  - ${err}`));
    process.exit(1);
  }

  // Parse options
  const descriptionIndex = args.indexOf('--description');
  const description =
    descriptionIndex !== -1 && args[descriptionIndex + 1]
      ? args[descriptionIndex + 1]
      : '';

  if (!description) {
    console.error(
      '\n❌ Missing required option: --description "Plugin description"'
    );
    process.exit(1);
  }

  // Parse pattern option
  const patternIndex = args.indexOf('--pattern');
  const pattern: OrchestrationPattern =
    patternIndex !== -1 && args[patternIndex + 1]
      ? (args[patternIndex + 1] as OrchestrationPattern)
      : 'agent-only';

  // Validate pattern
  const validPatterns = ['skill-based', 'command-based', 'hybrid', 'meta', 'agent-only'];
  if (!validPatterns.includes(pattern)) {
    console.error(
      `\n❌ Invalid pattern: ${pattern}\nValid options: ${validPatterns.join(', ')}`
    );
    process.exit(1);
  }

  const includeAll = args.includes('--all');

  // Auto-set component flags based on pattern
  let autoAgents = false;
  let autoCommands = false;
  let autoSkills = false;
  let autoHooks = false;

  switch (pattern) {
    case 'skill-based':
      autoSkills = true;
      break;
    case 'command-based':
      autoCommands = true;
      break;
    case 'hybrid':
      autoSkills = true;
      autoCommands = true;
      break;
    case 'meta':
      autoSkills = true;
      break;
    case 'agent-only':
      autoAgents = true;
      break;
  }

  const config: PluginConfig = {
    name: pluginName,
    description,
    author: getDefaultAuthor(),
    pattern,
    includeAgents: includeAll || args.includes('--agents') || autoAgents,
    includeCommands: includeAll || args.includes('--commands') || autoCommands,
    includeSkills: includeAll || args.includes('--skills') || autoSkills,
    includeHooks: includeAll || args.includes('--hooks') || autoHooks,
  };

  createPluginStructure(config);
}

main();
