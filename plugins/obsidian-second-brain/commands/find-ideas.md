# Find Ideas — Surface What the Vault Implies but Never States

Find ideas implied by the vault's contents but never explicitly articulated. These are conclusions the vault's evidence points toward, patterns its structure reveals, but that have never been written down.

Usage: `/find-ideas` (general) or `/find-ideas [domain]` (focused on a specific area)

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## What Counts as an Emergent Idea

An emergent idea IS:
- A conclusion from premises scattered across the vault, where the conclusion was never drawn
- A pattern recurring across multiple domains but never named
- A belief that behavior reveals but was never articulated
- A direction multiple threads point toward but never identified as a destination

An emergent idea is NOT:
- A connection between two existing ideas (that's `/connect-notes`)
- An evolution of existing thinking
- A restatement of something already in the vault

**The test:** if the reaction is "oh, I think that's right but I've never said it" — genuine emergence. If "I already know that" — not.

## Step 1: Structural Detection

```bash
obsidian search query="[[" format=json  # Find unresolved links
obsidian files folder="3 - Resources/" format=json
```

Look for:
- Unresolved `[[links]]` — ideas felt but never developed
- Orphaned notes that might connect to each other
- Clusters of notes in the same area that never synthesize

## Step 2: Thematic Detection

Find unnamed patterns recurring across 3+ domains.

```bash
# Read across PARA areas
obsidian files folder="1 - Projects/" format=json
obsidian files folder="2 - Areas/" format=json
obsidian files folder="3 - Resources/" format=json
```

Look for:
- Same problem-solving approach applied everywhere but never identified as "the way I think"
- Same tension appearing in work, personal, and creative domains but never named
- Same value driving decisions without being stated as a core value

A thematic emergence must appear in at least 3 separate domains. Two is coincidence. Three is a pattern.

## Step 3: Behavioral Detection

Find recurring decisions that imply unarticulated beliefs.

```bash
obsidian search query="decided" format=json
obsidian search query="chose" format=json
obsidian search query="going to" format=json
obsidian search query="not going to" format=json
```

Look for:
- Decisions consistently favoring one option type over another
- Things consistently avoided that reveal unstated beliefs
- Patterns of what gets energy vs. procrastination
- Recurring "rules" followed but never written down

The gap between a behavioral pattern and an articulated belief is the emergence.

## Step 4: Verification

### Fabrication Check (MANDATORY)
```bash
obsidian search query="<the emergence stated plainly>" format=json
```
If it's already stated somewhere — it's NOT emergent. Discard.

### Confidence Levels
- **High** (5+ data points across 2+ methods): Strong evidence
- **Medium** (3-4 data points): Suggestive but not definitive
- **Low** (1-2 data points): Speculative, hold loosely

## Step 5: Output

For each emergence:

```
Emergence [#]: [Title]
  The idea: [One sentence, plainly stated]
  Detection method: [Which method found it]
  Evidence:
    - [Specific note, date, quote] supports this because [why]
    - [Another note] supports this because [why]
  Why it's emergent: [Why it hasn't been stated despite evidence]
  Confidence: High / Medium / Low
  What to do with it:
    - New belief to articulate?
    - Question to investigate further?
    - A name for something already being lived?
    - Left alone (some things are better felt than formalized)?
```

### Synthesis
- Emergences found: [number]
- The strongest emergence
- Meta-emergence: Is there a pattern in the emergences themselves?

## Anti-Patterns

1. **The Fortune Cookie** — Vague universals like "you value authenticity." Every emergence must be specific to THIS vault.
2. **The Obvious Emergence** — Restating what the vault already says in different words.
3. **The Creativity Trap** — Generating novel ideas and attributing them to the vault. Emergences are discovered, not invented.
4. **The Over-Interpreter** — Reading too much into single data points. Require 3+ minimum.

## Output Guidelines

- Every emergence must trace back to specific vault evidence
- Prefer fewer, stronger emergences over many weak ones
- The fabrication check is mandatory
- This should feel like the vault thinking on your behalf
