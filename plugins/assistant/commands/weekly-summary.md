---
description: Generate comprehensive weekly accomplishment report
allowed-tools: Bash(git:*, gh:*), Read
model: sonnet
---

Generate a comprehensive weekly summary including commits, PRs, code reviews, learning moments, collaboration wins, and progress toward quarterly goals.

## Data Collection

### 1. Git Activity (Last 7 Days)

```bash
git log --since="7 days ago" --author="$(git config user.email)" --oneline
```

Extract:
- All commits made
- Features completed
- Bugs fixed
- Refactoring work

### 2. Pull Requests

```bash
gh pr list --author @me --state all --limit 50 --json number,title,state,createdAt,closedAt
```

Filter for last 7 days and categorize:
- Created
- Merged
- Closed

### 3. Code Reviews

```bash
gh search prs --reviewed-by @me --sort updated --limit 50 --json number,title,url
```

Analyze for:
- Total review count
- Substantive reviews (>3 comments with reasoning)
- Reviews that unblocked others
- Reviews that caught bugs

### 4. Obsidian Goals

Query obsidian-second-brain MCP for:
- Current quarterly goals
- Monthly objectives
- Staff Engineer progress targets

## Analysis

Use essentials/git-committer agent to extract meaningful accomplishments from commits.

Use status-generator agent to compile and format the summary in casual, conversational style.

## Output Format

```
Week of [start date] - [end date]

Shipped:
- [Feature 1 with ticket number if available]
- [Feature 2]
- [Bug fixes]

Code Reviews: X total, Y substantive
Highlights:
- [PR #]: [What made this review impactful] → Staff signal: quality reviews
- [PR #]: [How you unblocked someone] → Staff signal: collaboration
- [PR #]: [Bug you caught or pattern you suggested]

Learning:
- [Technical insight gained] → potential ADR topic
- [Pattern discovered or problem solved] → potential RFC topic
- [Tool or technique learned]

Collaboration:
- Cross-team: [Project or discussion with other team] → Staff signal
- Mentoring: [How you helped a teammate]
- Unblocking: [Who you helped and how]

Progress Toward Quarterly Goals:
[Query Obsidian for current quarter goals and assess]

Goal: "[Goal text from Obsidian]"
Status: [✅ On track | 📈 Progressing | 🔄 In progress | ⚠️ Behind]

Staff Engineer Progress This Week:
+X technical documents (ADR/RFC/design docs)
+Y code reviews (Z substantive)
[System ownership area]: X% commits (trend: up/down/stable)
Cross-team: [Project or collaboration]

Next Week Focus:
- [Based on current branches and context]
- [Quarterly goal priorities]
- [Technical debt or improvements identified]
```

## Style Guidelines

- **Casual tone**: "Shipped X", "Finally got Y working", not corporate-speak
- **Celebrate wins**: Acknowledge completed features positively
- **Highlight learning**: Technical insights count toward Staff visibility
- **Emphasize collaboration**: Cross-team work and helping others are Staff signals
- **Connect to goals**: Explicitly link work to quarterly objectives
- **Be honest**: If behind on goals, acknowledge it and plan to course-correct

## Staff Signal Categories

Tag accomplishments with relevant Staff signals:

**Technical Writing:**
- ADRs, RFCs, design docs created
- Major documentation updates

**Code Review Quality:**
- Substantive reviews (>3 comments with reasoning)
- Reviews that unblocked teammates
- Reviews that caught bugs or suggested improvements

**System Ownership:**
- Commits in owned systems (>50% in specific area)
- Documentation of owned systems
- Improvements to owned systems

**Cross-Team Impact:**
- Work affecting multiple teams
- Cross-functional projects
- Collaboration beyond Growth team

## Integration

This command coordinates:
- **essentials/git-committer** for commit analysis
- **status-generator agent** for summary formatting
- **career-tracker agent** for Staff progress calculation
- **obsidian-second-brain MCP** for goal tracking

## Example Output

```
Week of January 6-12, 2026

Shipped:
- Purchase modal skeleton (GROW-2380) - full mobile + desktop responsive UI
- React Query migration for subscriptions data fetching
- Fixed pagination bug that was blocking the team for 3 days

Code Reviews: 15 total, 4 substantive
Highlights:
- PR #234: Caught critical bug in payment flow validation → Staff signal: quality
- PR #

245: Unblocked Sarah on TypeScript generics issue → Staff signal: collaboration
- PR #256: Suggested React Server Component pattern for better performance

Learning:
- Deep dive into React Query optimistic updates - could be an ADR topic
- Discovered pattern for handling form state in purchase flows
- Learned about intersection observer for scroll tracking

Collaboration:
- Cross-team: Payment integration discussion with Platform team → Staff signal
- Mentoring: Helped intern understand React component lifecycle
- Unblocking: Pair programmed with Alex on TypeScript issue

Progress Toward Quarterly Goals (Q1 2026):

Goal: "Ship 1 feature with quality code"
Status: ✅ Completed - Purchase modal shipped with tests and docs

Goal: "Complete 20+ meaningful code reviews"
Status: 📈 On track - 47 total this month, 12 substantive

Goal: "Schedule 3 coffee chats"
Status: 🔄 In progress - 1 completed, 2 scheduled for next week

Staff Engineer Progress This Week:
+1 technical document (Purchase Modal Design Doc)
+15 code reviews (4 substantive - 27% substantive rate)
Subscriptions ownership: 72% commits (up from 67% last week)
Cross-team: Payment integration kickoff with Platform team

Next Week Focus:
- Continue payment integration (cross-team project)
- Document new state management pattern (ADR)
- Maintain code review velocity
- Complete remaining coffee chats
```
