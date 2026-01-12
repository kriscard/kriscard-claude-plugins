# Staff Engineer Signals - Detailed Tracking Guide

This document provides comprehensive details on how to track and measure Staff Engineer signals for career progression.

## The Four Core Signals

Based on industry research and the user's 2026 goals, Staff Engineer promotions are earned through demonstrable impact in four areas:

### 1. Technical Writing

**What it measures:** Ability to think through complex problems and communicate technical decisions effectively.

**Tracked artifacts:**
- Architecture Decision Records (ADRs)
- Request for Comments (RFCs)
- Design documents
- Technical specifications
- System documentation

**Detection patterns:**
```bash
# In git commits
git log --all --grep="ADR" --grep="RFC" --grep="design doc"

# In file names
find . -name "*adr*" -o -name "*rfc*" -o -name "*design*"

# In commit messages
git log --all --oneline | grep -iE "(architecture|design|rfc|adr|technical doc)"
```

**Quality indicators:**
- Document influences team decisions (referenced in PRs)
- Contains trade-off analysis (not just "what" but "why")
- Shows systems thinking (considers multiple components)
- Clear recommendations with reasoning

**Goal tracking:**
- Q1: Learning mode (no specific target)
- Q2-Q4: 2+ docs per quarter
- Annual: 6+ technical design documents

**Examples from user's work:**
- "Architecture Improvement Proposal - Subscriptions Feature"
- "Purchase Modal Design Doc (GROW-2380)"

### 2. Code Review Quality/Quantity

**What it measures:** Ability to provide thoughtful feedback, unblock others, and improve code quality across the team.

**Tracked metrics:**
- Total reviews per period
- Substantive reviews (>3 comments with reasoning)
- Reviews that unblock others
- Reviews that catch bugs or suggest improvements

**Detection patterns:**
```bash
# GitHub CLI
gh pr list --author @me --state all --limit 100 --json reviews

# Git log (authored reviews)
git log --all --author="user@email.com" --grep="Reviewed-by"

# Count comments in PRs
gh pr view <number> --json comments | jq '.comments | length'
```

**Quality indicators:**
- Explains "why" not just "what" to change
- Suggests alternatives with trade-offs
- Asks clarifying questions
- Points to relevant documentation
- Praises good decisions
- Focuses on architecture and patterns, not just style

**Goal tracking:**
- M1-2: Building baseline (20+ reviews/month)
- M3+: Maintain 20+ reviews/month
- Focus: Increase substantive reviews (>3 comments) to 30%+

**Substantive review definition:**
- More than "LGTM" or "Looks good"
- Contains specific technical feedback
- Questions assumptions or approach
- Suggests patterns or improvements
- References documentation or previous decisions

### 3. System Ownership

**What it measures:** Areas where you're the go-to person, showing deep expertise and responsibility.

**Tracked metrics:**
- Percentage of commits in specific directories/modules
- Ownership signals (most changes, most reviews, documentation author)
- Time as primary contributor
- Complexity of owned systems

**Detection patterns:**
```bash
# Commits by directory
git log --all --format="%an %h %s" -- src/subscriptions/ | grep "user@email" | wc -l

# Ownership percentage
total=$(git log --all --oneline -- src/subscriptions/ | wc -l)
yours=$(git log --all --author="user@email.com" --oneline -- src/subscriptions/ | wc -l)
percentage=$((yours * 100 / total))

# Reviews for area
gh pr list --search "path:src/subscriptions/" --json reviews
```

**Ownership indicators:**
- >50% of commits in an area
- Primary reviewer for changes in that area
- Author of documentation for that system
- Referenced in Slack/tickets as expert
- Maintained for 3+ months

**Goal tracking:**
- Q1-Q2: Identify and claim 1-2 systems (DX/Tooling or Frontend Architecture)
- Q3-Q4: Demonstrate measurable improvement in owned systems
- Example metrics: "Reduced build time 40%", "Improved test stability 30%"

**Candidate systems (from user's context):**
- **DX/Tooling**: Build pipeline, dev environment, CI/CD
- **Frontend Architecture**: React patterns, state management, component library
- **Testing Strategy**: Test infrastructure, coverage tooling, E2E framework
- **Subscriptions Feature**: Already showing ownership signals (67% of commits)

### 4. Cross-Team Impact

**What it measures:** Scope of influence beyond immediate team, ability to coordinate and deliver complex initiatives.

**Tracked metrics:**
- PRs affecting multiple team directories
- Cross-functional projects
- Initiatives spanning multiple repositories
- Collaboration with other teams

**Detection patterns:**
```bash
# PRs touching multiple team directories
gh pr list --author @me --json files | \
  jq '.[] | select(.files | map(.path | split("/")[0]) | unique | length > 1)'

# Multiple repo involvement
gh repo list --json name | \
  jq -r '.[].name' | \
  xargs -I {} gh pr list --repo {} --author @me

# Cross-team mentions
git log --all --grep="@platform-team" --grep="@backend-team" --author="user@email.com"
```

**Impact indicators:**
- PRs reviewed by multiple teams
- Design docs shared across teams
- Projects requiring coordination meetings
- Initiatives mentioned in team-wide updates
- Code used by multiple teams

**Goal tracking:**
- Q1-Q2: Identify opportunities for cross-team work
- Q3-Q4: Lead or contribute significantly to 1-2 cross-team initiatives
- Annual: Demonstrate impact beyond Growth team

**Examples from user's work:**
- Subscriptions work affected Growth + Platform teams
- Purchase flow integration with Backend team

## Tracking Dashboard Format

When generating `/staff-progress` output, use this format:

```
Staff Engineer Progress (Q1 2026)

Technical Writing: X docs (Goal: Y/quarter)
✅ [Document 1 title] (date)
✅ [Document 2 title] (date)
📝 In progress: [Document 3 title]

Code Reviews: X reviews, Y substantive (Goal: Z/month)
📈 Trending: [trend description]
🎯 Recent highlights:
  - [PR] Unblocked team on [issue]
  - [PR] Caught critical bug in [feature]
  - [PR] Suggested [pattern] improvement

System Ownership: X areas
🎯 [System 1]: Z% of commits, [months] maintained
🎯 [System 2]: Z% of commits, [months] maintained
💡 Emerging areas: [Systems showing ownership signals]

Cross-Team Impact: X projects
✅ [Project 1]: [Teams involved, impact]
🔄 In progress: [Project 2]

Quarterly Goal Alignment (from Obsidian):
- [Goal 1]: [Status emoji] [Assessment]
- [Goal 2]: [Status emoji] [Assessment]
- [Goal 3]: [Status emoji] [Assessment]
```

## Measurement Frequency

**Daily tracking:**
- Git commits (automatic via hooks)
- Code reviews (automatic via hooks)

**Weekly aggregation:**
- Substantive review count
- Learning moments
- Collaboration wins

**Monthly analysis:**
- System ownership percentages
- Cross-team project progress
- Technical writing output

**Quarterly assessment:**
- Compare against Obsidian goals
- Identify gaps and opportunities
- Adjust focus areas for next quarter

## Obsidian Integration

**Read these notes (read-only access):**
- `2026 goals.md` - Annual objectives and Staff strategy
- `Quarterly Goals - Q1 2026.md` - Current quarter focus
- `1 - January 2026.md` - Monthly objectives

**Never modify Obsidian notes** - only read to understand goals and compare progress.

**Query pattern:**
```
Use obsidian-second-brain MCP to:
1. Read user's 2026 goals
2. Extract Staff Engineer objectives
3. Read current quarterly goals
4. Compare actual progress against stated goals
5. Present alignment in /staff-progress output
```

## What "Good" Looks Like

**By end of Q1 (learning phase):**
- Shipped features reliably
- 60+ code reviews (20/month)
- Built relationships across team
- 1-2 technical documents
- Identified potential system to own

**By end of Q2 (documenting phase):**
- 4+ technical documents total
- 120+ code reviews, 30%+ substantive
- Clear ownership emerging (>50% commits in 1-2 areas)
- 1+ cross-team initiative started

**By end of Q3-Q4 (leading phase):**
- 6+ technical documents total
- System ownership established with measurable improvements
- Active cross-team projects
- Recognized as go-to person for owned systems
- Ready for Staff promotion discussion

## Red Flags to Watch For

**Insufficient visibility:**
- Writing code but not documenting decisions
- Reviewing PRs but only "LGTM" comments
- Working on features but no system ownership emerging

**Narrow scope:**
- All work confined to one feature/component
- No cross-team collaboration
- No influence beyond immediate tickets

**Low leverage:**
- Lots of commits but no meaningful improvements
- Busy but no impact on team velocity or quality
- Solving same problems repeatedly without systematic fixes

**Action when red flags detected:**
- Alert user during `/staff-progress`
- Suggest specific actions to address gaps
- Reference relevant goals from Obsidian

## Automation Strategy

**Fully automated:**
- Commit tracking (via hooks)
- PR creation tracking (via hooks)
- Code review counting (via git/gh analysis)

**Semi-automated (requires validation):**
- Substantive review detection (comment count + keywords)
- System ownership calculation (commit percentage)
- Cross-team impact detection (directory analysis)

**Manual (user input needed):**
- Learning moments (user documents in weekly summary)
- Collaboration wins (user highlights in weekly summary)
- Technical writing classification (detect ADR/RFC by filename/content)

## Integration with Weekly Summary

When generating `/weekly-summary`, incorporate Staff signals:

```
Week of [date]

Shipped:
- [Feature 1] (links to Staff signal: system ownership)
- [Feature 2]

Code Reviews: X total, Y substantive
- [PR]: Caught [bug] → Staff signal: quality reviews
- [PR]: Unblocked [person] → Staff signal: collaboration

Learning:
- [Technical insight] → potential ADR topic
- [Pattern discovered] → potential RFC topic

Collaboration:
- Cross-team: [Project] with Platform team → Staff signal
- Mentoring: [Helped person with issue]

Staff Progress This Week:
+1 technical document (ADR on [topic])
+15 code reviews (4 substantive)
Subscriptions ownership: 72% commits (up from 67%)
Cross-team: Payment integration discussion started

Next Week Focus:
- Continue payment integration (cross-team project)
- Document new state management pattern (ADR)
- Maintain code review velocity
```

This creates a narrative connecting daily work to career progression.
