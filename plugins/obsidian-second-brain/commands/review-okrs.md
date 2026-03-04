# Review OKRs Command

Facilitate quarterly, monthly, or weekly OKR reviews with progress tracking and goal alignment.

## Obsidian Access

Use Obsidian CLI commands directly via Bash. If a CLI command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

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
**Location:** `2 - Areas/Goals/Quarterly/`
**Naming:** `Quaterly Goals - QN YYYY.md` (e.g., "Quaterly Goals - Q1 2026.md")
**Note:** Folder uses "Quaterly" spelling - preserve existing vault structure

### Steps:

1. **Check for existing note** in `2 - Areas/Goals/Quarterly/`
2. **Create review note** from template
3. **Review previous quarter** - summarize accomplishments, extract lessons
4. **Set quarterly objectives** - 3-5 major objectives with key results
5. **Break down into monthly goals** - suggest monthly milestones
6. **Summary and next steps**

---

## Monthly Check-in Workflow

**Template:** `Monthly Goals.md`
**Location:** `2 - Areas/Goals/Monthly/`
**Naming:** `M - Month YYYY.md` (e.g., "1 - January 2026.md")

### Steps:

1. **Check for existing note** in `2 - Areas/Goals/Monthly/`
2. **Create monthly note** from template
3. **Review quarterly progress** - assess each objective (on track / behind / ahead)
4. **Set monthly priorities** - link to quarterly objectives
5. **Adjust if needed** - suggest corrections if behind
6. **Link to areas and projects**

---

## Weekly Review Workflow

**Template:** `Weekly Planning.md`
**Location:** `2 - Areas/Daily Ops/Weekly/M - Month YYYY/`
**Naming:** `YYYY-Www.md` (e.g., "2026-W06.md" in folder "2 - February 2026")

### Steps:

1. **Check for existing note** with month subfolder
2. **Create weekly note** from template
3. **Review last week** - what got done, what didn't
4. **Check monthly goals** - which need attention this week
5. **Review active projects** from `1 - Projects/`
6. **Set weekly priorities** - top 3-5 with success criteria
7. **Process inbox** (optional) - suggest `/process-inbox`
8. **Plan daily focus** - distribute tasks across days

---

## Progress Tracking

Use **okr-tracker agent** to search for OKR mentions across vault and generate progress dashboards.

## CLI Commands

```bash
obsidian read path="Templates/Quarterly Goals.md"
obsidian read path="2 - Areas/Goals/Quarterly/Quaterly Goals - Q1 2026.md"
obsidian create path="2 - Areas/Goals/Quarterly/Quaterly Goals - Q1 2026.md" content="$TEMPLATE" silent
obsidian search query="Q1 2026" format=json
obsidian files folder="2 - Areas/Goals/Quarterly/" format=json
obsidian files folder="1 - Projects/" format=json
```
