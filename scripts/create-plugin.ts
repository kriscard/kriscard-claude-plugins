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

interface PluginConfig {
  name: string;
  description: string;
  author: {
    name: string;
    email: string;
  };
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

  console.log(`\n✅ Plugin created successfully at plugins/${config.name}`);
  console.log('\nNext steps:');
  console.log(`  1. Add your components (agents, commands, skills, hooks)`);
  console.log('  2. Update the README.md with documentation');
  console.log('  3. Run "pnpm run sync" to update marketplace.json');
  console.log('  4. Test with: cc --plugin-dir ./plugins/' + config.name);
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

Create a new Claude Code plugin with proper structure.

Arguments:
  <plugin-name>        Plugin name in kebab-case (e.g., my-plugin)

Options:
  --description <desc> Plugin description (required)
  --agents             Include agents/ directory
  --commands           Include commands/ directory
  --skills             Include skills/ directory
  --hooks              Include hooks/ directory
  --all                Include all component directories

Examples:
  pnpm run create-plugin my-plugin --description "My awesome plugin" --all
  pnpm run create-plugin data-tools --description "Data processing tools" --agents --commands
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

  const includeAll = args.includes('--all');

  const config: PluginConfig = {
    name: pluginName,
    description,
    author: getDefaultAuthor(),
    includeAgents: includeAll || args.includes('--agents'),
    includeCommands: includeAll || args.includes('--commands'),
    includeSkills: includeAll || args.includes('--skills'),
    includeHooks: includeAll || args.includes('--hooks'),
  };

  createPluginStructure(config);
}

main();
