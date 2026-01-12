# Quickstart Guide - Assistant Plugin

Get your personal AI assistant up and running in 5 minutes.

## Installation

### Option 1: From This Repository (Recommended for Testing)

```bash
# Test locally without installing
claude --plugin-dir ./plugins/assistant

# Or add to your Claude Code config permanently
# Edit ~/.config/claude/config.json:
{
  "plugins": {
    "assistant": "/Users/kriscard/projects/kriscard-claude-plugins/plugins/assistant"
  }
}
```

### Option 2: From Marketplace (After Publication)

```bash
/plugin marketplace add kriscard/kriscard-claude-plugins
/plugin install assistant@kriscard
```

## First-Time Setup

### 1. Copy Settings Template (Optional)

The plugin works with smart defaults, but you can customize:

```bash
# For this project only
cp plugins/assistant/.claude/assistant.local.md .claude/assistant.local.md

# Or globally for all projects
cp plugins/assistant/.claude/assistant.local.md ~/.claude/assistant.local.md
```

### 2. Verify Installation

Start Claude Code and check:

```bash
/plugins

# Should show: assistant@0.1.0 ✓
```

### 3. Connect Obsidian (Optional)

If you want career tracking with your 2026 goals:

1. Ensure `obsidian-second-brain` plugin is installed
2. Verify your goal files exist:
   - `2026 goals.md`
   - `Quarterly Goals - Q1 2026.md`

The plugin will read these (never modify) to compare your progress.

## Your First Commands

### Generate Today's Standup

```
/standup
```

**What it does:**
- Analyzes yesterday's commits
- Transforms technical messages to casual accomplishments
- Infers today's plan from your work

**Example Output:**
```
Yesterday I:
- Shipped the purchase modal skeleton (GROW-2380)
- Finally got that React Query migration working
- Reviewed 3 PRs, helped Sarah with the TypeScript issue

Today I plan to:
- Start on the payment integration
- Finish those PR follow-ups
```

### Save Your Current Context

Before switching tasks:

```
/context-save payment-integration
```

**What it captures:**
- Your mental model (what you're building and why)
- Related links (PRs, tickets, docs)
- TODO list
- Git state (branch, files, recent commits)

Later, when you return:

```
/context-restore payment-integration
```

### Check Your Staff Progress

```
/staff-progress
```

**What it tracks:**
1. **Technical Writing:** ADRs, RFCs, design docs
2. **Code Reviews:** Count and quality (substantive rate)
3. **System Ownership:** Areas where you're the expert (>50% commits)
4. **Cross-Team Impact:** Projects affecting multiple teams

Compares against your Obsidian goals and provides actionable next steps.

### Validate Code Quality

Before creating a PR:

```
/quality-check
```

**What it checks:**
- TypeScript patterns and type safety
- React component design and hooks
- Test coverage (existence, not percentage)
- Advisory feedback (never blocks)

## Understanding Proactive Behavior

The assistant learns from your responses and adapts over time.

### What Triggers Suggestions

**After significant commits:**
- "Consider documenting this architectural decision"
- "This could make a good ADR topic"

**After PR creation:**
- "Run /quality-check to validate patterns and tests"

**At 5:45pm (your boundary):**
- "⏰ It's almost 6pm - consider wrapping up soon"

**At session end with work in progress:**
- "Save context with /context-save before switching"
- "Update your standup for tomorrow"

### Adjusting Proactivity

If suggestions feel too frequent:

```yaml
# .claude/assistant.local.md
---
proactivity: medium  # or "low"
learning_enabled: true  # Continues adapting
---
```

If you want minimal interruption:

```yaml
---
proactivity: low
---
```

The plugin learns your preferences automatically when `learning_enabled: true`.

## Learning Behavior

### What It Learns

1. **Your proactivity preference:**
   - Tracks how often you accept vs. dismiss suggestions
   - Adjusts frequency automatically
   - 3 levels: high → medium → low

2. **Your status writing style:**
   - Notices how you edit standup output
   - Learns your voice and phrasing
   - Applies patterns to future outputs

3. **Your priority signals:**
   - Sees which Staff signals you work on most
   - Focuses on relevant suggestions
   - Adapts career advice

### Learning Data Location

```bash
.claude/assistant/learning.json
```

**Privacy:** Stored locally, never synced or shared.

**Reset learning:** Delete the file to start fresh.

## Weekly Workflow

Here's how to use the assistant throughout your week:

### Monday Morning

```
/weekly-summary  # Review last week's accomplishments
/staff-progress  # Check career trajectory
```

**Result:** Clear view of progress, momentum for the week.

### Daily

- **Start of day:** `/standup` for team update
- **Task switches:** `/context-save` before, `/context-restore` when returning
- **Before PRs:** `/quality-check` for validation

### Friday Afternoon

```
/weekly-summary  # Prepare for next week
```

**Result:** Comprehensive report for reflection and planning.

### Anytime

```
/staff-progress  # Check career progress when curious
```

## Customization Examples

### Different Boundary Time

If you work until 5:30pm instead of 6pm:

```yaml
---
boundary_time: "17:30"
---
```

### Professional Status Style

If you prefer formal standups:

```yaml
---
status_style: professional
---
```

**Casual (default):**
```
Yesterday I:
- Shipped the modal (finally got it working!)
```

**Professional:**
```
Yesterday I:
- Completed implementation of purchase modal component
```

### Disable Quality Checks

If you don't want code quality suggestions:

```yaml
---
quality_check:
  typescript_react: false
---
```

### Custom Goal Files

If your Obsidian structure is different:

```yaml
---
staff_tracking:
  goal_files:
    - "Career/2026 Professional Goals.md"
    - "Career/Q1 2026 Objectives.md"
---
```

## Troubleshooting

### "Command not found: /standup"

**Fix:** Verify plugin is enabled:

```bash
/plugins
```

Should show `assistant@0.1.0 ✓`. If not, reinstall.

### "No git activity found"

**Cause:** No commits in last 24 hours (for `/standup`) or 7 days (for `/weekly-summary`)

**Fix:** Normal behavior - commit some work first.

### "Cannot read Obsidian goals"

**Cause:** Obsidian MCP not configured or goal files don't exist

**Fix:**
1. Install `obsidian-second-brain` plugin
2. Verify files exist in your vault:
   - `2026 goals.md`
   - `Quarterly Goals - Q1 2026.md`

**Workaround:** `/staff-progress` still works without Obsidian (shows raw signal data only).

### Suggestions Too Frequent

**Fix:** Lower proactivity level:

```yaml
---
proactivity: medium  # or "low"
---
```

Or disable learning to stop adaptation:

```yaml
---
learning_enabled: false
---
```

### "Context file not found"

**Cause:** Trying to restore context that doesn't exist

**Fix:** List available contexts:

```bash
ls .claude/assistant/contexts/
```

Use exact filename (without .json) when restoring.

## Next Steps

Once you're comfortable with basics:

1. **Try weekly workflow** for a full week
2. **Customize settings** to match your style
3. **Monitor learning** in `.claude/assistant/learning.json`
4. **Check career progress** monthly with `/staff-progress`

## Integration with Your Workflow

### With Existing Plugins

**essentials:**
- Uses `git-committer` for commit analysis
- Coordinates automatically

**developer-tools:**
- Invokes specialist agents for quality checks
- No configuration needed

**ideation:**
- Recognizes RFC/ADR opportunities
- Suggests documentation workflows

**obsidian-second-brain:**
- Reads your 2026 goals (never modifies)
- Compares actual vs. planned progress

### With Your Daily Routine

**Morning (5 min):**
1. `/standup` → copy to team chat
2. Review yesterday's accomplishments
3. Plan today's work

**During Work:**
- Let assistant suggest actions proactively
- Use `/context-save` before meetings/switches
- Run `/quality-check` before PRs

**End of Day (2 min):**
- Respond to wrap-up suggestions
- Save context if mid-task
- Respect 6pm boundary (gentle reminder)

**Weekly (10 min):**
1. `/weekly-summary` → reflection
2. `/staff-progress` → career check
3. Adjust goals if needed

## Getting Help

### Documentation

- **README.md** - Full feature documentation
- **TESTING.md** - Comprehensive testing guide
- **settings template** - `.claude/assistant.local.md` with all options

### Support

- **Issues:** https://github.com/kriscard/kriscard-claude-plugins/issues
- **Discussions:** Ask questions in GitHub Discussions

### Debugging

Enable Claude Code debug mode:

```bash
claude --debug
```

Check logs for hook execution, agent invocations, and errors.

## Tips for Success

1. **Start with defaults** - Only customize when you feel friction
2. **Let it learn** - Give it 2 weeks to adapt to your style
3. **Accept some suggestions** - Helps learning algorithm
4. **Check progress monthly** - Use `/staff-progress` regularly
5. **Protect your boundary** - Respect the 6pm reminder

## What to Expect

### First Week

- Getting used to proactive suggestions
- Finding your preferred proactivity level
- Establishing workflow patterns

### First Month

- Plugin adapts to your style
- Learning data improves suggestions
- Workflow becomes automatic

### First Quarter

- Clear career progress visibility
- Automated status generation is natural
- Quality bar consistently maintained
- Staff signals trending positively

## Philosophy

This plugin embodies **"Calm Strength & Optionality"** (your 2026 theme):

- **Calm:** Automates overhead, enforces boundaries
- **Strength:** Maintains quality bar, tracks progress
- **Optionality:** Builds Staff signals for career flexibility

Enjoy your personal AI assistant! 🚀
