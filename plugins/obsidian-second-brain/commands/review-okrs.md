---
name: review-okrs
description: Multi-level OKR reviews (quarterly, monthly, weekly) with progress tracking
allowed-tools: [Read, Write, Bash, obsidian]
---

# Review OKRs Command

Facilitate quarterly, monthly, or weekly OKR reviews with progress tracking and goal alignment.

## Purpose

Help user maintain regular review cadence for goals and objectives. Create review notes from templates, track progress, and ensure alignment between different time horizons.

## Workflow

### Step 1: Select Review Level

Ask user which review they want to perform:

```
Which OKR review would you like to do?
1. Quarterly Review - Major goals and planning (every 3 months)
2. Monthly Check-in - Progress and adjustments (monthly)
3. Weekly Review - Task-level priorities (weekly)
```

Based on selection, proceed with appropriate workflow.

---

## Quarterly Review Workflow

**Template:** `Quarterly Goals.md`
**Location:** `1 - Notes/OKRS/Quaterly Goals/`
**Naming:** `Quaterly Goals - QN YYYY.md` (e.g., "Quaterly Goals - Q1 2026.md")
**Note:** Folder uses "Quaterly" spelling - preserve existing vault structure

### Steps:

1. **Check for existing note**
   - Look for current quarter note in `1 - Notes/OKRS/Quaterly Goals/`
   - If exists: Ask "Review note already exists. Open it or create new?"

2. **Create review note**
   - Read template: `Templates/Quarterly Goals.md`
   - Create note: `1 - Notes/OKRS/Quaterly Goals/Quaterly Goals - QN YYYY.md`
   - Apply template

3. **Review previous quarter** (if applicable)
   - Find previous quarter note
   - Summarize: What was accomplished?
   - Extract lessons learned

4. **Set quarterly objectives**
   - Ask: "What are your 3-5 major objectives for this quarter?"
   - For each objective:
     - Define key results (measurable outcomes)
     - Link to relevant areas (`2 - Areas/`)
     - Identify required resources

5. **Break down into monthly goals**
   - For each objective, suggest monthly milestones
   - Create or link to monthly goal notes

6. **Summary and next steps**
   - Review all quarterly OKRs
   - Suggest: "Schedule monthly check-in"
   - Add to calendar or weekly planning

---

## Monthly Check-in Workflow

**Template:** `Monthly Goals.md`
**Location:** `1 - Notes/OKRS/Monthly Goals/`
**Naming:** `M - Month YYYY.md` (e.g., "1 - January 2026.md", "2 - February 2026.md")

### Steps:

1. **Check for existing note**
   - Look for current month note in `1 - Notes/OKRS/Monthly Goals/`
   - If exists: Open for review

2. **Create monthly note**
   - Read template: `Templates/Monthly Goals.md`
   - Create note: `1 - Notes/OKRS/Monthly Goals/M - Month YYYY.md`
   - Apply template

3. **Review quarterly progress**
   - Find current quarter OKRs
   - For each objective:
     - Assess progress (on track / behind / ahead)
     - Identify blockers or challenges
     - Celebrate wins

4. **Set monthly priorities**
   - Ask: "What are your priorities for this month?"
   - Link priorities to quarterly objectives
   - Break into weekly tasks

5. **Adjust if needed**
   - If behind on quarterly goals: Suggest adjustments
   - If ahead: Consider stretch goals
   - Update quarterly note if objectives changed

6. **Link to areas and projects**
   - Connect monthly goals to relevant areas
   - Identify projects that support goals
   - Create new projects if needed

---

## Weekly Review Workflow

**Template:** `Weekly Planning.md`
**Location:** `1 - Notes/Weekly Planning/M - Month YYYY/`
**Naming:** `YYYY-Www.md` (e.g., "2026-W06.md" in folder "2 - February 2026")

### Steps:

1. **Check for existing note**
   - Determine current month subfolder: `1 - Notes/Weekly Planning/M - Month YYYY/`
   - Example: `1 - Notes/Weekly Planning/2 - February 2026/`
   - Look for current week note: `YYYY-Www.md`
   - If exists: Open for review

2. **Create weekly note**
   - Read template: `Templates/Weekly Planning.md`
   - Create month subfolder if it doesn't exist
   - Create note: `1 - Notes/Weekly Planning/M - Month YYYY/YYYY-Www.md`
   - Apply template

3. **Review last week** (if applicable)
   - Find previous week note
   - What got done?
   - What didn't get done? (Move to this week or backlog)

4. **Check monthly goals**
   - Find current month goals
   - Which goals need attention this week?
   - Break into specific tasks

5. **Review active projects**
   - List notes from `0 - PARA/1 - Projects/`
   - For each project: What's the next action?
   - Prioritize top 3-5 projects for the week

6. **Set weekly priorities**
   - Ask: "What are your top priorities for this week?"
   - For each priority:
     - Link to project or area
     - Define success criteria
     - Estimate time needed

7. **Process inbox** (optional)
   - Ask: "Process inbox as part of weekly review?"
   - If yes: Suggest running `/process-inbox`

8. **Plan daily focus**
   - Suggest distributing weekly tasks across days
   - Link to daily notes for the week

---

## Progress Tracking

During any review level, use **okr-tracker agent** to:
- Search for OKR mentions across vault
- Show progress indicators
- Identify notes related to current goals
- Generate progress dashboard

Example dashboard:
```
Quarterly OKRs Progress:

1. Launch personal website - 60% complete
   - Recent notes: [[Website Design]], [[Content Strategy]]
   - Blocker: Hosting decision
   - Next action: Compare hosting options

2. Complete online course - 80% complete
   - Recent notes: [[Course Module 5]], [[Final Project]]
   - On track for completion by month-end

3. Network with 10 people - 40% complete
   - Recent notes: [[1-on-1 with Sarah]], [[LinkedIn outreach]]
   - Behind schedule: Need to accelerate
```

## Tools Usage

**Obsidian MCP:**
- `obsidian_get_file_contents` - Read templates and previous reviews
- `obsidian_append_content` - Create review notes
- `obsidian_simple_search` - Find OKR mentions, track progress
- `obsidian_list_files_in_dir` - List OKRs, projects

## Configuration

Read from `.claude/obsidian-second-brain.local.md`:
- `vault_path`
- Optional: `review_frequency` (how often to prompt for reviews)

## Best Practices

- **Regular cadence**: Encourage consistent review schedule
- **Link everything**: Connect reviews across time horizons
- **Track progress**: Don't just set goals, measure them
- **Celebrate wins**: Acknowledge accomplishments
- **Adjust expectations**: Be realistic about what's achievable
- **Learn from misses**: Understand why goals weren't met

## Error Handling

- **Missing template**: Use basic structure if template not found
- **No previous reviews**: Start fresh, no problem
- **Empty OKRs**: Help user set first goals
- **Vault access issues**: Fall back to read-only mode

## Related Skills

- **obsidian-workflows** - Review cadences and OKR principles
- **vault-structure** - OKRs folder structure
- **template-patterns** - Goal template usage

## Related Agents

- **okr-tracker** - Proactively tracks OKR progress during reviews
- **para-organizer** - Suggests linking goals to areas/projects

## Example Interaction (Weekly Review)

```
Assistant: Let's do your weekly review!

Creating note: Week 2025-W02.md

Last week's accomplishments:
- Completed course module 4
- Published 1 blog post
- Processed inbox to zero

This week's monthly goals:
- Complete course (80% done)
- Launch website (60% done)

Active projects needing attention:
1. Personal website
2. Online course completion
3. Job applications

What are your top 3 priorities for this week?
```
