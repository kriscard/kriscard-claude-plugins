# Weekly Learnings — Writing Prep

Surface patterns, insights, and candidate topics from the week's daily notes. Output everything to terminal. Do NOT create any files.

## Obsidian Access

Use Obsidian CLI commands directly via Bash. If a CLI command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Step 1: Read Previous Weekly Learnings (Continuity)

```bash
obsidian search query="Weekly Learnings" format=json
# Read the most recent one found
```

Extract:
- What was written about last time (avoid repeating without development)
- Threads opened but not resolved
- Things promised ("I'll write more about this soon")
- The tone and style

## Step 2: Read Daily Notes (Past 7 Days)

```bash
# Read each day of the past 7 days
obsidian read path="2 - Areas/Daily Ops/YYYY/YYYY-MM-DD.md"
```

Extract:
- What was actually worked on (not planned, what happened)
- Conversations and meetings that shifted thinking
- Ideas that emerged (especially ones with energy)
- Decisions made or direction changes
- Problems encountered and how they were handled
- Frustrations, breakthroughs, and realizations
- Anything surprising

## Step 3: Load Context

Read OKRs and active project context:
```bash
obsidian files folder="1 - Projects/" format=json
obsidian read path="2 - Areas/Goals/Monthly/[current month].md"
obsidian read path="2 - Areas/Daily Ops/Weekly/[current month folder]/[current week].md"
```

Use these to understand which events connect to bigger strategic questions.

## Step 4: Trace Idea Evolution

```bash
# For recurring themes from daily notes
obsidian search query="<recurring theme>" format=json
```

Look for:
- Ideas that appeared on multiple days (evolving thinking worth highlighting)
- Themes from daily notes that connect to OKR open questions
- Notes from previous weeks that this week builds on or contradicts

## Step 5: Synthesize — Output to Terminal

Print everything directly to terminal. Do NOT create any files.

### Output Format:

```
WEEKLY LEARNINGS PREP -- Week [number], [year]

FROM LAST EDITION (threads to continue or resolve):
- [Thread from previous that developed further this week]
- [Promise made that can now be addressed]

CANDIDATE TOPICS (ranked by depth of thinking + relevance):

[#]. [Topic name] -- [Project/Area]
    What happened: [Specific events, conversations, or decisions]
    The insight: [The non-obvious thing worth sharing]
    Source: [Which daily notes contain the raw thinking]

List 5-8 candidates.

CONNECTING THREAD:
If there's a theme that ties multiple things together this week, name it.

OPERATIONAL UPDATES (not learnings, but worth noting):
- [Decisions, schedule changes, milestones hit, etc.]

SUGGESTED STRUCTURE:
Recommend 3-4 sections based on what has the most depth.
```

## Output Guidelines

- Print everything to terminal. No file creation.
- Be specific: cite which daily note, which meeting, which event.
- Prioritize insights over updates.
- Match existing tone: first person, reflective, connects specific events to broader ideas.
