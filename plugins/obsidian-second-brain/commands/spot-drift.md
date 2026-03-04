# Spot Drift — What Am I Avoiding?

Compare stated intentions against actual behavior over the past 30 days. Surface gaps between what you say matters and where time and energy actually go. Find what's being avoided.

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## Step 1: Gather Stated Intentions

### OKRs and Goals
```bash
obsidian files folder="2 - Areas/Goals/Quarterly/" format=json
obsidian files folder="2 - Areas/Goals/Monthly/" format=json
# Read the most recent quarterly and monthly goals
```

Extract:
- Stated priorities and goals
- Commitments made (to self and others)
- Things marked as important or urgent
- Open questions flagged for investigation
- Projects in "current" or "active" status

### Daily Note Intentions (past 30 days)
```bash
obsidian read path="2 - Areas/Daily Ops/YYYY/YYYY-MM-DD.md"  # for past 30 days
```

Look for:
- "I need to..." / "I should..." / "I want to..." statements
- Carry-forward items from reflections
- Things mentioned as tomorrow's priority
- Recurring items that keep appearing

## Step 2: Gather Actual Behavior

### Daily Note Patterns
Across the past 30 days:
- What topics come up repeatedly?
- What topics appear once and vanish?
- What gets energy (long writing, ideas flowing)?
- What gets avoidance (mentioned briefly, no follow-through)?

### Vault Activity
```bash
obsidian search query="<stated priority A>" format=json
obsidian search query="<stated priority B>" format=json
```

For each stated priority, measure how much actual vault activity it generated.

### Active Projects Check
```bash
obsidian files folder="1 - Projects/" format=json
```

Which projects have recent activity? Which are stale?

## Step 3: The Drift Report

### Alignment Score
For each stated priority, rate alignment between intention and action (1-10):

| Priority | Stated Importance | Actual Time/Energy | Alignment | Drift |
|----------|-------------------|-------------------|-----------|-------|
| ... | High | Low | 3/10 | Significant |

### What's Getting Attention It Wasn't Supposed To
Things consuming time that aren't in any priority list. Where is energy leaking?

### What's Being Avoided
The uncomfortable list. Things clearly important but consistently getting no action. For each:
- **What**: The thing being avoided
- **Evidence**: How many times mentioned vs. how much action taken
- **Possible why**: Fear, unclear next step, not actually important, too big, requires confrontation
- **The cost**: What happens if avoidance continues

#### Avoidance Decision Tree
For each avoided item:
- **(a) Mentioned in past 7 days?** Yes = active avoidance. No = passive.
- **(b) Related items getting done?** If yes, avoidance is specific to THIS thing. Dig into why.
- **(c) Has a clear next step?** If no, avoidance may be about ambiguity. Define one concrete action.
- **(d) Requires someone else?** If yes, the block may be relational. Identify who and what the ask is.

### Recurring Push Pattern
Tasks or intentions that appear, get pushed, appear again, get pushed again. For each:
- How many times has this cycled?
- What breaks the loop?

### The Honest Assessment
A direct, compassionate summary of where the drift is. Not judgmental. Just clear.
"Here's what you said mattered. Here's what you actually did. Here's where they don't match."

### Recommended Corrections
For each significant drift:
- **Drop it**: If it keeps getting avoided, maybe it's not actually a priority. Remove it.
- **Do it now**: If it genuinely matters, schedule it in the next 48 hours.
- **Delegate it**: If it matters but you won't do it, who else can?
- **Reframe it**: If the next step is unclear, define one concrete action.

## Output Guidelines

- Be honest but not harsh. This is a mirror, not a critic.
- Always cite specific dates, notes, and data.
- The most valuable insight is often the simplest: "You said X matters. You haven't touched it in 3 weeks."
- Don't confuse busyness with avoidance.
- Distinguish between "dropped and should stay dropped" vs. "dropped and it's costing you."
