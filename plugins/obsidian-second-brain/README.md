# Obsidian Second Brain Manager

Comprehensive Obsidian vault manager that helps maintain your second brain through intelligent organization, daily workflows, OKR tracking, and proactive knowledge maintenance.

## Overview

This plugin transforms Claude Code into your Obsidian vault assistant, providing:

- **Daily Workflow Automation** - Interactive startup sessions with daily notes, inbox checks, and task surfacing
- **PARA Organization** - Intelligent note categorization following Projects/Areas/Resources/Archives methodology
- **OKR Management** - Quarterly, monthly, and weekly goal tracking with progress dashboards
- **Vault Maintenance** - Automatic link health checks, orphaned note detection, and tag consistency
- **Template System** - Easy template application and management
- **Proactive Agents** - AI assistants that automatically help when context is relevant

## Features

### Commands

- `/daily-startup` - Interactive daily workflow session
- `/process-inbox` - Guided inbox processing with PARA suggestions
- `/review-okrs` - Multi-level OKR reviews (quarterly/monthly/weekly)
- `/maintain-vault` - Comprehensive vault health check
- `/apply-template` - Apply templates to notes interactively

### Autonomous Agents

- **para-organizer** - Suggests Projects/Areas/Resources/Archives placement for notes
- **link-maintainer** - Finds broken links, orphaned notes, suggests connections
- **tag-optimizer** - Ensures tag consistency based on your taxonomy
- **okr-tracker** - Tracks OKR progress across your vault

### Knowledge Skills

- **obsidian-workflows** - Second brain methodology and PARA principles
- **vault-structure** - Understanding of your specific vault organization
- **template-patterns** - Template usage and application patterns

## Prerequisites

**Required**: Obsidian MCP server must be configured in Claude Code.

The Obsidian MCP server provides the tools needed to interact with your vault. Ensure it's configured and pointing to your Obsidian vault path.

## Installation

### From Marketplace (Recommended)

```bash
claude plugin install obsidian-second-brain
```

### Local Development

```bash
cd /path/to/kriscard-claude-plugins
cc --plugin-dir ./plugins/obsidian-second-brain
```

## Configuration

Create `.claude/obsidian-second-brain.local.md` in your project:

```yaml
---
vault_path: /Users/yourusername/your-obsidian-vault
---

# Obsidian Second Brain - Configuration

**Vault Path**: {{vault_path}}

## Optional Settings

You can customize behavior by editing the YAML frontmatter above.
Future versions will support:
- Custom template paths
- Review frequency settings
- Agent activation toggles
```

## Usage

### Daily Workflow

Start your day with:

```
/daily-startup
```

This will interactively:
1. Create today's daily note from template
2. Show inbox status and count
3. Surface relevant OKRs and tasks
4. Open daily note for immediate work

### Inbox Processing

Process notes in your Inbox folder:

```
/process-inbox
```

The plugin will:
- Show each note's content
- Suggest PARA placement (Projects/Areas/Resources/Archives)
- Ask: Move, Skip, or handle manually
- Track processing progress

### OKR Reviews

Review your goals at any cadence:

```
/review-okrs
```

Choose from:
- **Quarterly** - Major goal reviews and planning
- **Monthly** - Progress checks and adjustments
- **Weekly** - Task-level reviews and priorities

### Vault Maintenance

Check vault health:

```
/maintain-vault
```

Checks for:
- Broken links to non-existent notes
- Orphaned notes with no incoming links
- Tag inconsistencies based on your taxonomy

### Template Application

Apply templates to existing notes:

```
/apply-template
```

Select from all templates in your Templates/ folder and apply to the current note.

## Vault Structure Assumptions

This plugin works best with the following structure (fully configurable):

```
vault/
├── 0 - PARA/
│   ├── 0 - Inbox/          # Unprocessed notes
│   ├── 1 - Projects/       # Active projects
│   ├── 2 - Areas/          # Ongoing responsibilities
│   ├── 3 - Resources/      # Reference materials
│   ├── 4 - Archives/       # Completed/inactive items
│   └── MOCs/               # Maps of Content
├── 1 - Notes/
│   ├── Daily Notes/        # Daily journal entries
│   ├── OKRs/               # Goal tracking
│   ├── Weekly Planning/    # Weekly reviews
│   └── People/             # Relationship notes
└── Templates/              # Note templates
```

## Proactive Agent Behavior

Agents automatically activate based on context:

- **para-organizer** - Triggers when discussing inbox notes or organization
- **link-maintainer** - Triggers when vault issues or broken links mentioned
- **tag-optimizer** - Triggers when discussing tags or categorization
- **okr-tracker** - Triggers when OKRs or goals are mentioned

You don't need to explicitly invoke them—they assist automatically when relevant.

## Best Practices

1. **Start your day with `/daily-startup`** - Establishes consistent routine
2. **Process inbox regularly** - Use `/process-inbox` at least weekly
3. **Review OKRs on schedule** - Quarterly for major planning, weekly for tactics
4. **Run maintenance monthly** - `/maintain-vault` keeps links and tags healthy
5. **Use templates consistently** - Reduces friction, improves organization

## Troubleshooting

**"Cannot access vault"**
- Check Obsidian MCP is configured and running
- Verify vault path in `.claude/obsidian-second-brain.local.md`

**"Templates not found"**
- Ensure Templates/ folder exists in your vault
- Check template references in configuration

**"Agents not triggering"**
- Agents activate based on conversation context
- Try explicitly mentioning inbox, links, tags, or OKRs

## Roadmap

Future enhancements planned:
- [ ] Batch PARA placement with preview
- [ ] Automated link suggestions based on content similarity
- [ ] Habit tracking integration with daily notes
- [ ] Customizable review schedules
- [ ] Export/import configurations for different vaults
- [ ] Advanced tag taxonomy validation
- [ ] Meeting notes integration with People notes

## Contributing

Found a bug or have a feature idea? Open an issue in the [kriscard-claude-plugins](https://github.com/yourusername/kriscard-claude-plugins) repository.

## License

MIT
