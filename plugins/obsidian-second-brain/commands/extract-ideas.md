# Extract Ideas — Daily Note Idea Promoter

Scan recent daily notes, surface ideas worth promoting to standalone permanent notes, and help you decide what to graduate into your PARA system.

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## Step 1: Scan Recent Daily Notes

Read the past 14 days of daily notes:

```bash
# Read each day individually
obsidian read path="2 - Areas/Daily Ops/YYYY/YYYY-MM-DD.md"  # for each of the past 14 days
```

For each daily note, extract candidates for graduation.

### Explicit Signals
- `#idea` or `#expand` tags
- Language like "I should write about", "worth investigating", "need to explore"
- Named concepts (capitalized or in quotes)
- Unresolved `[[links]]` to notes that don't exist yet

### Implicit Signals
- Paragraphs with high energy (longer passages, strong language)
- Original claims or frameworks (positions, not just events)
- Recurring themes across 3+ days
- Questions that keep appearing but never get their own note

### What NOT to Extract
- Tasks and to-dos
- Meeting logistics
- Things that already have their own standalone note

## Step 2: Cross-reference with Existing Vault

For each candidate:

```bash
obsidian search query="<candidate concept>" format=json
```

Categorize:
- **New concept** - No note exists. Best candidate for graduation.
- **Underdeveloped** - A note exists but it's thin. Candidate for enrichment.
- **Already covered** - Substantial note exists. Skip unless daily note adds something new.
- **Recurring unresolved** - Referenced as `[[unresolved link]]` multiple times. High priority.

## Step 3: Present Candidates

Table ordered by priority (recurring/high-energy ideas first):

| # | Idea / Concept | Source | Days Mentioned | Status | Recommendation |
|---|----------------|--------|----------------|--------|----------------|
| 1 | ... | Feb 17, Feb 18 | 2 | Unresolved link | Create standalone note |
| 2 | ... | Feb 14 | 1 | New concept | Create standalone note |
| 3 | ... | Feb 6, Feb 12 | 2 | Thin note exists | Enrich existing note |

For each candidate include:
- 1-2 sentence summary of the idea
- Exact quote(s) from the daily notes
- What it connects to in the vault

## Step 4: Graduate Selected Ideas

Ask which ideas to graduate, then for each:

### Creating a new standalone note:
- Place in appropriate PARA folder:
  - Active idea with deadline -> `1 - Projects/`
  - Ongoing area of interest -> `2 - Areas/`
  - Reference/concept -> `3 - Resources/Coding/` or `3 - Resources/`
- Write as mini-essay (3-8 paragraphs):
  - Core claim or question
  - Context from source daily notes
  - Connections to other vault notes as `[[backlinks]]`
  - Open questions or next steps
- Preserve original voice from daily notes
- Go back to source daily notes and add `[[links]]` to the new note

### Enriching an existing note:
- Read the existing note
- Add new content with date header
- Add any new backlinks
- Update source daily notes with proper links

**ALWAYS ask before creating or modifying files.**

## Step 5: Summary

### Graduated Today
List of notes created or enriched, with links

### Still in the Queue
Ideas surfaced but not graduated (flag if they reappear next run)

### Vault Health
- Total ideas found in scan period
- Number graduated vs. skipped
- Recurring themes not yet graduated

## Guidelines

- Keep graduated notes concise (3-8 paragraphs)
- Preserve original voice and energy from daily notes
- When in doubt, present and let user decide
- Target 5-10 minutes per run
- Always ask before creating or modifying files
