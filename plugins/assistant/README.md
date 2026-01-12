# Assistant Plugin

Your personal AI assistant for Staff Engineer growth. Automates standups, tracks career progress, manages context, and keeps you on track—without getting in your way.

## Quick Start

```bash
# Install
/plugin marketplace add kriscard/kriscard-claude-plugins
/plugin install assistant@kriscard

# Try it
/standup           # Generate today's standup
/staff-progress    # Check your career trajectory
```

## What It Does

**Proactive Assistant** - Suggests actions after commits/PRs, learns from your responses
**Status Automation** - Generates standups and weekly summaries from git activity
**Career Tracking** - Monitors 4 Staff Engineer signals vs. your Obsidian goals
**Context Manager** - Saves mental state before task switches
**Quality Checks** - Advisory code validation (never blocks)
**Boundary Keeper** - Gentle 6pm reminder to wrap up

## Commands

| Command | What It Does |
|---------|-------------|
| `/standup` | Daily standup from yesterday's commits |
| `/weekly-summary` | Weekly accomplishment report with career signals |
| `/quality-check` | Advisory code validation (TypeScript/React/tests) |
| `/context-save` | Save mental model before switching tasks |
| `/context-restore` | Restore saved context |
| `/staff-progress` | Track 4 Staff Engineer signals vs. goals |

## How It Works

**Proactive Suggestions** - Triggers automatically after commits, PRs, at 6pm, etc.
**Learning System** - Adapts to your accept/dismiss patterns over 2-4 weeks
**Plugin Integration** - Works with essentials, developer-tools, ideation, obsidian-second-brain
**Privacy First** - All data stored locally in `.claude/assistant/`

## Configuration (Optional)

Works great with defaults. To customize:

```bash
# Copy template
cp plugins/assistant/.claude/assistant.local.md .claude/assistant.local.md

# Edit key settings
proactivity: high           # high/medium/low
boundary_time: "18:00"      # Work boundary reminder
status_style: casual        # casual/professional
learning_enabled: true      # Adapts automatically
```

**What it learns:** Proactivity level, status style, priority signals
**Learning data:** `.claude/assistant/learning.json` (local only)

## Example Output

**Daily Standup** (`/standup`)
```
Yesterday I:
- Shipped the purchase modal skeleton (GROW-2380)
- Finally got React Query migration working
- Reviewed 3 PRs, unblocked Sarah on TypeScript issue

Today I plan to:
- Start payment integration
- Finish code review follow-ups
```

**Staff Progress** (`/staff-progress`)
```
Technical Writing: 2 docs (Goal: 2+/quarter) [On track]
Code Reviews: 47 reviews, 12 substantive (26%) [Improving]
System Ownership: 67% of Subscriptions commits [Strong]
Cross-Team Impact: Payment integration (active) [On track]
```

## Staff Engineer Signals Tracked

1. **Technical Writing** - ADRs, RFCs, design docs
2. **Code Reviews** - Volume + substantive rate (>3 comments with reasoning)
3. **System Ownership** - Areas with >50% commits for 3+ months
4. **Cross-Team Impact** - Projects affecting multiple teams

## Plugin Integration

**Required:**
- None - works standalone

**Enhanced with:**
- `essentials` - Uses git-committer for commit analysis
- `developer-tools` - Delegates TypeScript/React quality checks
- `ideation` - Recognizes RFC/ADR opportunities
- `obsidian-second-brain` - Syncs with 2026 goals (read-only)

## Resources

- **QUICKSTART.md** - Get started in 5 minutes
- **TESTING.md** - 25 test cases for validation
- **Settings template** - `.claude/assistant.local.md`
