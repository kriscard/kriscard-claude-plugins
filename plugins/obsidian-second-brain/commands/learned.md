# Learned — What I Learned Post Generator

Generate writing from vault thinking. Takes a topic (from argument or today's daily note), mines the vault for raw material, then produces drafts at three levels.

Usage: `/learned [topic]` or just `/learned` to pull from today's note.

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## Step 1: Find the Raw Material

**If a topic was provided as argument:** Use that as the subject. Search the vault:
```bash
obsidian search query="<topic>" format=json
```

**If no topic provided:** Read today's daily note:
```bash
YEAR=$(date +%Y)
TODAY=$(date +%Y-%m-%d)
obsidian read path="2 - Areas/Daily Ops/$YEAR/$TODAY.md"
```

If today's note is sparse, read the past 3 days. Extract:
- Insights or realizations
- Problems solved or understood
- Shifts in thinking
- Things that surprised you

Pick the most interesting insight. If multiple are strong, list them and ask which to use.

## Step 2: Pull Supporting Context

```bash
obsidian search query="<topic>" format=json
# Read relevant notes that come back
# Follow backlinks 2-3 hops deep
```

Look for:
- How long you've been thinking about this (depth of experience)
- Specific details or moments that make this personal and concrete
- The non-obvious angle (what would surprise someone)
- Connection to something universal (why anyone would care)

### Temporal Velocity Check
How fast is this topic developing?
- **Accelerating** (more recent notes): Ripe. Ready to publish.
- **Steady** (consistent over time): May need a new angle.
- **Decelerating** (mostly older notes): Needs more lived experience or a deliberate reframe.

## Step 3: Identify the Non-Obvious Angle

Before writing, force this analysis:
- **What would surprise someone?** Counterintuitive or contradicts assumptions?
- **What do conventional sources get wrong?** Where does lived experience diverge from standard advice?
- **What's the thing nobody says?** Every topic has an obvious take and an honest take.
- **Where does the vault evidence contradict itself?** Internal tension produces the most interesting writing.

## Step 4: Generate Three Versions

Output THREE versions to the terminal:

### Version 1: Short Post
A single, self-contained post. 1-3 short paragraphs.
- Opens with the sharpest version of the insight
- One concrete detail or example
- Ends clean. No call to action.

### Version 2: Personal Essay (300-600 words)
Flowing prose grounded in your specific situation.
- Open with the specific moment that triggered the insight
- Build through concrete examples
- Connect to something larger
- End with a question or open thread

### Version 3: Universal Essay (800-1500 words)
Written for anyone experiencing this problem.
- Define the reader: who is stuck on this, what stage, what assumptions
- Diagnose, then reframe
- Bring in research, metaphor, vivid examples
- Maintain narrative momentum
- End with expansion, not closure

### Rules for all versions:
- Direct, curious voice grounded in real experience
- Don't be preachy. Share what you found, not what others should do.
- First person for V1 and V2. V3 can use whatever serves the piece best.
- No headers or formatting in the prose. Just writing.

## Step 5: Ask for Direction

After presenting all three drafts:
- Which version feels closest to what you want to publish?
- Any details to add, remove, or change?
- Ready to post, or save to vault as a draft?

If saving as draft:
```bash
obsidian create path="3 - Resources/Drafts/What I Learned - [Topic] - [DATE].md" content="$DRAFT" silent
```
