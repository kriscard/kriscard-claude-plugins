---
description: Check progress toward Staff Engineer goals
allowed-tools: Bash(git:*, gh:*), Read
model: sonnet
---

Check progress toward Staff Engineer goals by tracking technical writing, code reviews, system ownership, and cross-team impact. Compares actual progress against quarterly goals from Obsidian.

## Purpose

Provide visibility into career progression toward Staff Engineer by measuring the four core signals:
1. Technical Writing (ADRs, RFCs, design docs)
2. Code Review Quality/Quantity
3. System Ownership (areas of expertise)
4. Cross-Team Impact (scope beyond immediate team)

## Tracking Period

If argument provided, use custom period:
```
Track since: $ARGUMENTS
Examples: "30 days ago", "Q1 2026", "January 1"
```

If no argument, use current quarter:
```
Track since: Q1 2026 start date (from Obsidian)
```

## Signal Tracking

### 1. Technical Writing

Search for technical documents in git:

```bash
# ADRs
git log --all --grep="ADR" --grep="adr-" --oneline

# RFCs
git log --all --grep="RFC" --grep="rfc-" --oneline

# Design docs
git log --all --grep="design doc" --grep="architecture" --oneline

# Find by filename
find . -name "*adr*" -o -name "*rfc*" -o -name "*design*" | grep -v node_modules
```

Extract:
- Document titles
- Creation dates
- Topics covered

### 2. Code Review Quality/Quantity

Query GitHub for reviews:

```bash
# Total reviews
gh search prs --reviewed-by @me --limit 100 --json number,title,createdAt

# Detailed review comments
gh pr view [number] --json comments
```

Calculate:
- Total review count for period
- Substantive reviews (>3 comments with reasoning)
- Reviews that unblocked others (check for "unblock" in comments)
- Reviews that caught bugs (check for "bug", "issue", "problem")

### 3. System Ownership

Analyze commit distribution by directory:

```bash
# List all directories with commits
git log --format="" --name-only | cut -d/ -f1-2 | sort | uniq

# For each directory, calculate ownership percentage
for dir in [directories]; do
  total=$(git log --oneline -- "$dir/" | wc -l)
  yours=$(git log --author="$(git config user.email)" --oneline -- "$dir/" | wc -l)
  percentage=$((yours * 100 / total))
  echo "$dir: $percentage%"
done
```

Identify areas with >50% ownership as "owned systems".

### 4. Cross-Team Impact

Detect cross-team work:

```bash
# PRs affecting multiple team directories
gh pr list --author @me --json files | \
  jq '.[] | select(.files | map(.path | split("/")[0]) | unique | length > 1)'

# Search for cross-team mentions in commits
git log --all --grep="platform" --grep="backend" --grep="cross-team" \
  --author="$(git config user.email)" --oneline
```

Extract:
- Cross-functional projects
- Multi-team collaborations
- PRs reviewed by multiple teams

## Obsidian Goals Integration

Query obsidian-second-brain MCP for:

1. Annual goals (`2026 goals.md`):
   - System ownership targets
   - Technical writing goals
   - Code review expectations

2. Quarterly goals (`Quarterly Goals - Q1 2026.md`):
   - Current quarter objectives
   - Expected milestones

3. Monthly goals (`1 - January 2026.md`):
   - Month-specific targets

Extract relevant sections:
- Career objectives
- Staff Engineer signals to track
- Timeline expectations

## Analysis

Use career-tracker agent to:
- Calculate progress for each signal
- Compare against goals from Obsidian
- Identify gaps and opportunities
- Generate actionable insights

## Output Format

```
Staff Engineer Progress (Q1 2026)
Period: January 1 - January 12, 2026

═══════════════════════════════════════════

Technical Writing: 2 docs (Goal: 2+/quarter after Q1)
✅ Architecture Improvement Proposal - Subscriptions Feature (Jan 6)
   → Impact: Influenced team direction on state management
✅ Purchase Modal Design Doc - GROW-2380 (Jan 7)
   → Impact: Used as reference by 3 team members

📝 Opportunities:
- Document new state management pattern (mentioned in code reviews)
- Write RFC for payment integration approach

═══════════════════════════════════════════

Code Reviews: 47 reviews, 12 substantive (Goal: 20+/month)
📈 Trending: 3.2 reviews/day (above target)

Substantive Rate: 26% (Target: 30%+)
↗️ Improving (was 20% last month)

🎯 Recent Highlights:
- PR #234: Caught critical bug in payment flow validation
  → Staff signal: Quality review
- PR #245: Unblocked Sarah on TypeScript generics issue
  → Staff signal: Collaboration + technical depth
- PR #256: Suggested React Server Component pattern
  → Staff signal: Architecture guidance

💡 Opportunities:
- Focus on providing more detailed feedback (increase substantive rate)
- Document common patterns you suggest in reviews (turns into ADRs)

═══════════════════════════════════════════

System Ownership: 2 areas emerging

🎯 Subscriptions Feature: 67% of commits (3 months maintained)
   - Primary contributor since October 2025
   - Authored documentation
   - First point of contact for questions

🎯 Purchase Flow: 45% of commits (1 month)
   - Emerging ownership
   - Could reach >50% by month-end

📊 Trending Analysis:
- Subscriptions: Stable ownership, good documentation
- Purchase flow: Building expertise, document soon

💡 Opportunities:
- Subscriptions: Measure impact (performance, conversion)
- Purchase flow: Write design doc to establish ownership

═══════════════════════════════════════════

Cross-Team Impact: 1 project active

✅ Subscriptions Feature (Completed)
   - Teams: Growth + Platform
   - Your role: Lead frontend, coordinated with backend
   - Impact: Enabled platform team to build payment processor

🔄 Payment Integration (In Progress)
   - Teams: Growth + Platform + Backend
   - Your role: Frontend lead, integration planning
   - Expected impact: Unifies payment flow across products

💡 Opportunities:
- Document payment integration decisions (RFC)
- Present learnings at engineering all-hands

═══════════════════════════════════════════

Quarterly Goal Alignment (from Obsidian):

"Ship 1 feature with quality code" (M1-2)
Status: ✅ Completed ahead of schedule
Evidence: Purchase modal shipped with tests and docs

"Complete 20+ meaningful code reviews" (monthly target)
Status: 📈 Exceeding - 47 total, 12 substantive this month
Trajectory: On pace for 60+ reviews this month

"Schedule 3 coffee chats" (relationship building)
Status: 🔄 In progress - 1 completed, 2 scheduled
Action: Complete remaining chats by end of month

═══════════════════════════════════════════

Overall Staff Readiness: Strong Progress ↗️

Strengths:
- Code review volume and quality above target
- System ownership emerging in 2 clear areas
- Cross-team collaboration demonstrated
- Technical writing started (2 docs in 12 days)

Growth Areas:
- Increase substantive review rate (26% → 30%+)
- Measure impact of owned systems quantitatively
- Complete relationship building (coffee chats)
- Document emerging patterns (turn reviews into ADRs)

Next 30 Days Focus:
1. Maintain code review pace (20+/month)
2. Complete coffee chats (build relationships)
3. Document 1-2 additional patterns/decisions
4. Measure Subscriptions system impact (performance/conversion)
5. Continue cross-team payment integration

═══════════════════════════════════════════

Strategy Timeline (from your 2026 goals):
M1-2 (Jan-Feb): Ship reliably ✅ On track
M3-4 (Mar-Apr): Build relationships 🔄 In progress (coffee chats)
M5-6 (May-Jun): Document & propose 📅 Upcoming
M7-12 (Jul-Dec): Own & lead 📅 Future

You're on track for Staff promotion in 12-18 months!
```

## Interpretation Notes

**Strong progress indicators:**
- Technical writing: >2 docs/quarter after Q1
- Code reviews: 20+/month with 30%+ substantive
- System ownership: >50% commits in 1-2 areas for 3+ months
- Cross-team: Active project affecting multiple teams

**Warning signs:**
- No technical writing in 60+ days
- Code review substantive rate <20%
- No clear system ownership (all <30%)
- All work confined to one team/feature

## Actionable Insights

Based on progress, provide specific next actions:

**If technical writing low:**
- "Convert recent code review feedback into ADR"
- "Document architectural decision from last PR"
- "Write RFC for upcoming cross-team project"

**If code review quality low:**
- "Provide more detailed reasoning in next 3 reviews"
- "Ask clarifying questions instead of quick approvals"
- "Reference docs/patterns in reviews"

**If no clear ownership:**
- "Focus commits on Subscriptions for next 2 weeks"
- "Write documentation for area you work in most"
- "Volunteer as primary reviewer for one system"

**If cross-team impact low:**
- "Propose cross-team improvement at next planning"
- "Collaborate with Platform team on shared concern"
- "Present learnings to broader engineering team"

## Notes

- Progress tracked using git and GitHub data
- Goals read from Obsidian (read-only, no modifications)
- Tracking is cumulative for the quarter
- Can run weekly/monthly to track trends
- Shows trajectory (improving/stable/declining)

## Integration

This command coordinates:
- **career-tracker agent** for signal calculation and analysis
- **Bash/git** for commit and file analysis
- **gh CLI** for PR and review data
- **obsidian-second-brain MCP** for goal context (read-only)
