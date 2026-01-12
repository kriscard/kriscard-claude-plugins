# Learning Behavior - Adaptive Proactivity

This document explains how the assistant plugin learns from user behavior and adapts its proactivity over time.

## Philosophy

The plugin starts with **high proactivity** (suggests after every significant action) but learns to calibrate based on user responses. The goal is **high signal, low noise** - helpful suggestions without overwhelming.

**Key principle:** Respect user preferences discovered through behavior, not just stated configuration.

## Learning State

### Storage Location

Learning state stored in `.claude/assistant/learning.json`:

```json
{
  "version": "1.0",
  "last_updated": "2026-01-12T10:30:00Z",
  "proactivity_level": "high",
  "metrics": {
    "suggestions_made": 150,
    "suggestions_accepted": 42,
    "suggestions_dismissed": 18,
    "acceptance_rate": 0.28
  },
  "patterns": {
    "typical_work_hours": {
      "start": "09:00",
      "end": "18:00",
      "timezone": "America/Toronto"
    },
    "boundary_compliance": {
      "days_tracked": 15,
      "on_time_finishes": 12,
      "late_finishes": 3,
      "compliance_rate": 0.80
    },
    "quality_priorities": ["patterns", "tests"],
    "documentation_timing": "later",
    "status_update_frequency": "weekly"
  },
  "recent_activity": {
    "last_7_days": {
      "suggestions_made": 35,
      "suggestions_accepted": 12,
      "suggestions_dismissed": 4
    }
  }
}
```

### State vs Settings

**Settings (`.claude/assistant.local.md`):**
- User-configured preferences
- Explicit choices (work end time, quality checks)
- Rarely changes

**Learning state (`.claude/assistant/learning.json`):**
- Runtime behavior tracking
- Discovered preferences through usage
- Updates frequently

**Rule:** Settings override learning state. If user explicitly configures something in settings, respect it regardless of learned behavior.

## Proactivity Levels

### High (Default)

**Behavior:**
- Suggests after every commit
- Suggests after every PR
- Suggests after every code review
- Suggests quality check for file changes
- Provides documentation reminders
- Active boundary enforcement

**Triggers adjustment:**
- Acceptance rate >25%
- Dismissal rate <20%
- User engagement with suggestions

### Medium

**Behavior:**
- Suggests at key milestones (feature completion, PR creation)
- Suggests quality check for significant changes only
- Documentation reminders for architectural decisions only
- Boundary reminders maintained
- Less frequent status suggestions

**Triggers adjustment:**
- Acceptance rate 15-25%
- Dismissal rate 20-40%
- Mixed engagement signals

### Low

**Behavior:**
- Suggests only at critical moments (boundary, session end)
- Quality suggestions only on explicit changes to critical files
- Documentation reminders rare (only major architectural changes)
- Boundary enforcement maintained (always)
- Minimal status suggestions

**Triggers adjustment:**
- Acceptance rate <15%
- Dismissal rate >40%
- Consistent dismissal patterns

### Adaptive Algorithm

```
Every 7 days, recalculate proactivity level:

recent_acceptance_rate = accepted / (accepted + dismissed)
overall_acceptance_rate = total_accepted / (total_accepted + total_dismissed)

if recent_acceptance_rate > 0.30:
    maintain or increase proactivity
elif recent_acceptance_rate > 0.20:
    maintain current level
elif recent_acceptance_rate > 0.10:
    decrease one level
else:
    decrease to low

Special cases:
- If dismissal_streak >= 10: immediately drop to low
- If acceptance_streak >= 10: immediately raise to high
- Boundary reminders NEVER reduced (always enforced)
```

## Learning Patterns

### 1. Work Hours Detection

**What to learn:**
- Typical start time
- Typical end time
- Days worked (weekdays vs weekends)
- Session duration patterns

**How to detect:**
```
Track first tool use each day → start time
Track last tool use each day → end time
Track tool use by day of week → work days

After 10 days of data:
Calculate median start/end times
Adjust boundary reminders if needed

Example:
User consistently starts at 8:30am, ends at 5:45pm
→ Move boundary reminder from 5:45pm to 5:30pm (15min earlier)
```

**Application:**
- Adjust boundary reminder timing
- Suggest wrap-up actions earlier for early finishers
- Don't suggest morning tasks in afternoon

### 2. Quality Check Preferences

**What to learn:**
- Which quality checks user cares about
- When user runs quality checks (before commit? before PR?)
- Which suggestions user acts on

**How to detect:**
```
Track quality check invocations:
- Frequency: How often does user run /quality-check?
- Timing: Before commit? Before PR? After changes?
- Actions: Which suggestions does user act on?

Track quality-related commits:
- "Add tests" commits → user values test coverage
- "Fix TypeScript error" commits → user values type safety
- "Update docs" commits → user values documentation

After 20 quality checks:
Rank priorities by action rate:
- tests: 80% acted on → high priority
- patterns: 60% acted on → medium priority
- documentation: 30% acted on → lower priority
```

**Application:**
- Emphasize high-priority checks in suggestions
- De-emphasize low-priority checks
- Adjust quality-check output order

### 3. Documentation Timing

**What to learn:**
- Does user document immediately or later?
- Does user prefer structured (RFC) or informal (commit messages)?
- Which documentation suggestions get acted on?

**How to detect:**
```
Track documentation patterns:

Immediate documenters:
- Create ADR/RFC within 24h of architectural decision
- Update docs in same PR as code change
→ Suggest documentation immediately

Later documenters:
- Create docs days/weeks after implementation
- Batch documentation updates
→ Note for later, suggest in weekly summary

Never documenters:
- Consistently dismiss documentation suggestions
- Rely on commit messages and PR descriptions
→ Stop suggesting documentation, focus on code quality
```

**Application:**
- Timing of documentation suggestions
- Format of documentation suggestions
- Frequency of documentation reminders

### 4. Status Update Style

**What to learn:**
- Preferred tone (casual vs professional)
- Preferred frequency (daily vs weekly)
- Content preferences (detailed vs brief)

**How to detect:**
```
Track status generation:

After each /standup or /weekly-summary:
- Note any user edits to generated text
- Track if user shortens or lengthens output
- Observe tone adjustments

Pattern detection:
- User always removes emoji → reduce emoji usage
- User always expands bullet points → provide more detail
- User changes "shipped" to "completed" → adjust terminology
- User adds context not in commits → prompt for more context

After 5 status generations:
Adapt style based on user edits
```

**Application:**
- Adjust status generation tone
- Modify output length
- Change terminology to match user preferences
- Pre-prompt for additional context user typically adds

### 5. Boundary Compliance

**What to learn:**
- How strictly does user follow 6pm boundary?
- Are overruns for emergencies or habitual?
- Does reminder help or annoy?

**How to detect:**
```
Track boundary behavior:

Each day:
- Did user finish by boundary time?
- If not, how much overtime?
- Was it acknowledged or ignored?

Pattern detection:
- 90%+ compliance → reminder working well, maintain
- 70-90% compliance → reminder helpful but not sufficient
- <70% compliance → reminder not effective or boundary unrealistic

Overtime analysis:
- Emergency overtime (rare, acknowledged) → OK
- Habitual overtime (daily, unacknowledged) → boundary needs adjustment
```

**Application:**
- Adjust reminder timing (earlier warning for habitual overtime)
- Adjust reminder tone (firmer for habitual overtime)
- Suggest boundary time adjustment if consistently missed
- Acknowledge good compliance positively

### 6. Tool Usage Patterns

**What to learn:**
- Which commands does user invoke frequently?
- Which agents does user rely on?
- Which workflows does user follow?

**How to detect:**
```
Track command invocations:
- /standup: 15 times/month → daily standup user
- /weekly-summary: 4 times/month → weekly summary user
- /quality-check: 30 times/month → quality-conscious user
- /context-save: 2 times/month → rare context switcher

Track agent usage:
- quality-enforcer: frequent → emphasize quality suggestions
- status-generator: frequent → proactive status reminders helpful
- career-tracker: rare → reduce career progress mentions
```

**Application:**
- Prioritize suggestions for frequently-used features
- De-emphasize suggestions for rarely-used features
- Adjust proactive reminders based on actual usage

## Adaptation Speed

### Fast Adaptation (1-3 days)

**Applies to:**
- Boundary compliance (safety-critical)
- Dismissal streaks (user clearly annoyed)
- Emergency patterns (urgent issues)

**How:**
```
If user dismisses 3 consecutive suggestions:
Immediately reduce proactivity one level

If user consistently works past boundary 3 days straight:
Immediately suggest adjusting boundary time

If user accepts every suggestion for 3 days:
Verify it's not honeymoon period, then consider increasing proactivity
```

### Medium Adaptation (1-2 weeks)

**Applies to:**
- Proactivity level adjustments
- Quality check priorities
- Status update style

**How:**
```
After 7-14 days:
Calculate metrics
Compare to thresholds
Adjust behavior gradually
```

### Slow Adaptation (1-3 months)

**Applies to:**
- Documentation patterns
- Work hour patterns
- Career focus areas

**How:**
```
After 30-90 days:
Identify long-term trends
Make strategic adjustments
Validate with user if major changes planned
```

## Learning Safeguards

### Never Learn Away Core Features

**Always maintain:**
- Boundary reminders (6pm enforcement)
- Safety suggestions (quality checks before shipping)
- Career progress tracking (Staff signals)

**Even if user dismisses:**
These are core value propositions - don't disable them entirely.
Instead, adjust timing, frequency, or tone.

### Avoid False Patterns

**Watch for:**
- Honeymoon period (first week of high engagement)
- Sprint periods (temporary high activity)
- Crunch periods (temporary boundary violations)

**How to avoid:**
```
Require minimum sample size:
- 10+ interactions before pattern recognition
- 2+ weeks of data for behavioral changes
- 30+ days for work hour patterns

Weight recent behavior more heavily:
- Last 7 days: 50% weight
- Last 30 days: 30% weight
- Historical: 20% weight
```

### Respect Explicit Configuration

**Priority order:**
1. Explicit settings (`.claude/assistant.local.md`)
2. Recent behavior (last 7 days)
3. Medium-term patterns (last 30 days)
4. Long-term patterns (historical)
5. Default behavior

**Example:**
```
If user sets work_end_time: "17:00" in settings:
→ Use 5pm boundary regardless of learned patterns

If user doesn't set explicit time but consistently finishes at 5:30pm:
→ Learn and adapt reminder timing
```

## Feedback Mechanisms

### Explicit Feedback

**Commands for user control:**
```
/assistant-settings
Shows current learning state and allows adjustments:

Current Proactivity: High
Acceptance Rate: 28%
Boundary Compliance: 80%

Adjust:
- Proactivity level (high/medium/low)
- Reset learning state
- View detailed patterns
```

### Implicit Feedback

**Actions that signal preferences:**
- Dismissing suggestion → reduce similar suggestions
- Acting on suggestion → increase similar suggestions
- Editing generated text → learn preferred style
- Ignoring reminder → reminder not effective
- Acknowledging reminder → reminder helpful

### Learning Reports

**Weekly in /weekly-summary:**
```
Learning Update:
- Your proactivity preference seems to be: High
  (You've acted on 32% of suggestions this week)
- You typically finish by 6pm (80% compliance)
- Quality checks you care most about: patterns, tests
- Documentation timing: You prefer to document later

Want to adjust? Use /assistant-settings
```

## Privacy & Data

### What's Stored

**Stored locally in `.claude/assistant/learning.json`:**
- Aggregated metrics (counts, rates)
- Behavioral patterns (timing, preferences)
- No personal information
- No code content
- No commit messages
- No file contents

**Not stored:**
- Actual code
- Commit messages (only analyzed, not stored)
- File contents
- Personal information
- Credentials
- API keys

### Data Retention

**Active learning data:**
- Last 90 days of detailed metrics
- Lifetime aggregated statistics
- Recent patterns weighted more heavily

**Cleanup policy:**
```
Every 90 days:
- Archive detailed metrics older than 90 days
- Keep only aggregated statistics
- Maintain recent behavior patterns
```

## Debugging Learning

### Viewing Current State

**Command:** `/assistant-debug-learning`

**Output:**
```
Learning State Debug:

Proactivity: High (based on 28% acceptance rate)
Last adjusted: 5 days ago
Trend: Stable

Patterns detected:
- Work hours: 8:30am - 5:45pm (15 days data)
- Boundary compliance: 80% (12/15 days)
- Quality priorities: patterns (80%), tests (75%), docs (30%)
- Documentation timing: Later (batched updates)
- Status style: Casual, detailed

Recent activity (7 days):
- Suggestions made: 35
- Accepted: 12 (34%)
- Dismissed: 4 (11%)
- Ignored: 19 (54%)

Next adjustment check: 2 days
```

### Resetting Learning

**When to reset:**
- User behavior changes significantly
- New role or responsibilities
- Learning produced bad patterns
- User requests it

**Command:** `/assistant-reset-learning`

**Effect:**
```
Resets to default:
- Proactivity: High
- No learned patterns
- Fresh slate

Keeps user settings intact:
- Boundary time from .local.md
- Quality check preferences from .local.md
```

## Best Practices

**DO:**
- Start with high proactivity (better to be helpful than invisible)
- Learn gradually (require sufficient data before changing)
- Respect explicit settings (user configuration overrides learning)
- Maintain core features (never disable boundary reminders entirely)
- Provide transparency (show learning state in reports)

**DON'T:**
- Change behavior too quickly (avoid whiplash)
- Learn away safety features (boundary, quality)
- Store sensitive data (code, credentials)
- Make assumptions from small samples (<10 interactions)
- Hide learning process (user should understand what's happening)

## Future Enhancements

**Potential learning expansions:**
- Project-specific patterns (different behavior per repo)
- Context-aware suggestions (different suggestions based on current task)
- Collaborative learning (opt-in sharing of anonymized patterns)
- Predictive suggestions (anticipate next action based on workflow)
- Goal-aware adaptation (adjust based on career progress)

These would require additional user consent and careful privacy considerations.
