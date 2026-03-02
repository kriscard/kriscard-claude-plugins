---
name: check-communication
description: >-
  Check if a message communicates at staff-engineer level. Make sure to use this
  skill whenever the user says "/check-communication", "check this message",
  "how does this sound", "review my message", "improve this communication",
  or pastes a message they want evaluated for staff-level communication quality.
---

# Staff Communication Review

Analyze the following message against staff-level communication frameworks. Be direct and concise — flag what's weak, acknowledge what's strong.

## Message to Review

$ARGUMENTS

## Step 1: Auto-Detect Message Type

Before evaluating, identify the message type from context and content:

| Type | Signals |
|---|---|
| **Status update** | Progress language, timeline mentions, blockers |
| **Standup** | Short, daily cadence, what I did / will do |
| **Proposal / RFC** | Suggests a change, asks for approval, presents options |
| **PR review comment** | Code references, review language, suggestions |
| **Disagreement / Pushback** | Countering a position, expressing concern |
| **Slack message** | Casual tone, async communication, thread context |
| **Email / formal** | Recipients, subject-like structure, formal tone |
| **General** | Doesn't fit above categories |

State the detected type before proceeding. This determines which frameworks apply.

## Step 2: Core Evaluation (Always Apply)

Score each as **Strong / Acceptable / Needs Work / Missing**. Skip dimensions that don't apply to the detected message type.

### BLUF (Bottom Line Up Front)
Does it lead with conclusion/need, then context, then ask?
- Anti-pattern: burying the point in paragraph 3

### Problem Level Clarity
Is it clear WHAT level the message operates at?
- Level 1: Goal → Level 2: Problem → Level 3: Approach → Level 4: Solution
- Anti-pattern: jumping to solution without stating the problem

### Trade-offs & Alternatives
Does it name downsides of its own proposal? Mention rejected alternatives?
- Anti-pattern: presenting only upsides (signals inexperience or bias)

### Ask Clarity
Is there a clear action requested? From whom? By when?
- Anti-pattern: vague "thoughts?" endings with no specific ask

### Tone & Framing
- Steel Man: Does it strengthen others' positions before countering?
- "Us vs the problem" framing, not "me vs you"
- Anti-pattern: "As I already explained...", defensive language, talking down

### Signal-to-Noise Ratio
Could it be shorter without losing meaning?
- Anti-pattern: over-detailing, burying signal in noise

### Audience Awareness
Right level of detail for the audience?
- Anti-pattern: explaining basics to experts, jargon to non-technical stakeholders

## Step 3: Type-Specific Evaluation

Apply ONLY the section matching the detected type.

### If Status Update → STATUS Framework
- **S**tate — On track / At risk / Blocked
- **T**arget — Deliverable and deadline
- **A**chieved — Impact, not activity ("reduced latency 40%" not "worked on caching")
- **T**hreats — What could go wrong
- **US** — Unblocks needed from others

### If Standup → 30-Second Formula
- **Signal** (5s) — What moved + impact
- **Need** (5s) — What you need from the team
- **Radar** (10s) — Something you noticed affecting others
- Staff standups coordinate, they don't report accountability

### If Proposal / RFC → Proposal Structure
- Problem (1 paragraph with real data)
- Proposed Solution (scoped, not "change everything")
- Why Now? (what triggered this)
- Trade-offs (pros AND cons — naming downsides builds trust)
- Alternatives Considered (what you rejected and why)
- Rollback Plan (makes skeptics comfortable)

### If PR Review Comment → Prefix System
- Uses prefixes: `nit:` / `suggestion:` / `question:` / `issue:` / `thought:`
- Explains WHY for blockers, not just what
- Makes people feel smart, not dumb

### If Disagreement → Conflict Resolution
- Steel Man technique (make their argument stronger, then compare)
- Goes down one level to find agreement
- Disagree and commit readiness ("I can commit — but want to flag [risk]")
- Unlock questions when someone repeats themselves

### If Slack Message → Async Communication
- Thread Rule awareness (3 exchanges max → call → summarize)
- 2:1 ratio (questions vs statements)
- Appropriate length for the medium

## Output Format

```
## Detected Type: [type]

## Rating: [Senior / Staff / Principal]

### What's Working
- [specific strengths with quotes from the message]

### Needs Improvement
- [specific issues with concrete rewrites]

### Rewritten Version
[Provide a staff-level rewrite preserving the author's voice]
```

## Rules

- Be blunt. Sugarcoating defeats the purpose.
- Always provide concrete rewrites for weak areas, not just labels.
- The rewritten version should preserve the author's voice — improve structure, not personality.
- If the message is already strong, say so briefly. Still note 1 minor improvement if possible.
- Apply the 2:1 ratio insight: staff communicators ask ~2 questions per statement.
- The "No surprises" rule — flag if the message would surprise stakeholders in a group setting.
