# Connect Notes — Find Unexpected Bridges Between Domains

Takes two separate topics or domains and uses the vault's graph to find non-obvious connections between them.

Usage: `/connect-notes [domain A] [domain B]` — e.g., `/connect-notes design engineering`

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## Step 1: Map Each Domain

For each domain provided, build a picture of what exists in the vault:

```bash
obsidian search query="<domain A>" format=json
obsidian search query="<domain B>" format=json
```

Read the key notes that come back. Follow backlinks 2-3 hops from each domain's hub notes. Build a list of all notes, concepts, and themes in each domain's neighborhood.

### Depth Asymmetry
If one domain has significantly more notes than the other, pay extra attention to bridges from the smaller domain. The less-explored territory is where the surprises are. Go 3-4 hops deep on sparse domains.

## Step 2: Find the Overlaps

Compare the two neighborhoods:

### Shared References
Notes that appear in both domains' backlink chains — natural bridges.

### Shared Themes
Concepts or questions that appear in both domains even if notes aren't linked:
```bash
obsidian search query="<theme from domain A>" format=json  # search within domain B's neighborhood
```

### Shared Patterns
Structural similarities: both domains facing the same problem, evolving in the same direction, stuck on the same question.

## Step 3: Trace the Bridges

For each connection found, go deeper:
- How deep does the connection go? Surface-level (same word) or structural (same underlying pattern)?

### Path-Finding
For the strongest bridges, trace the shortest path between domains through the vault graph. Intermediary notes sitting at the intersection of two worlds are often the most interesting.

### Temporal Analysis
Are the domains converging, diverging, or stable?
- **Converging**: Integration happening naturally. Push it further.
- **Diverging**: Used to share more. What changed?
- **Stable**: Consistent connection. Deep structural link.

## Step 4: Synthesize

### Connection Map
For each bridge:
```
Bridge [#]: [Title]
  In Domain A: [How this appears]
  In Domain B: [How it appears differently]
  The connection: [What links them and why it's interesting]
  Depth: Surface / Structural / Foundational
  Implication: [What this suggests for either domain]
```

### The Strongest Bridge
The single most interesting connection. The one that reframes how you think about both domains.

### Missing Links
Connections that SHOULD exist based on evidence but haven't been made. Suggest specific notes to link or create.

### The Question This Raises
What new question emerges from seeing these two domains connected that wasn't visible when they were separate?

## Output Format

```
CONNECT: [Domain A] <-> [Domain B]
Notes in A's neighborhood: [number]
Notes in B's neighborhood: [number]
Bridges found: [number]
Trend: [Converging / Diverging / Stable]

[Connection map]
[Strongest bridge]
[Missing links]
[The question]
```

## Output Guidelines

- The value is in non-obvious connections. If obvious, dig deeper.
- Always cite specific notes and dates.
- The best output makes you see both domains differently.
- Don't force connections that aren't there. If domains genuinely don't connect, say so.
