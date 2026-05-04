---
name: memory-recall
description: >-
  Searches the vault for prior knowledge from past Claude Code sessions and
  human-curated notes. Make sure to use this skill whenever the user asks
  recall-style questions like "what did I learn about X", "remember when we
  discussed Y", "did I decide about Z", "what's my note on Q", "have we talked
  about R before", or any "what do I know about ..." phrasing. Also fires when
  the user references prior sessions, prior decisions, or asks Claude to
  consult the vault before answering from general knowledge.
---

# Memory Recall

Surface what the user already knows from their PARA vault — both compiled
agent-written knowledge and their own human-curated notes — before answering
from general knowledge.

## When to fire

Trigger on any phrasing that implies the user expects you to consult their
vault rather than answer from training data:

- "What did I learn about X"
- "Remember when we / I"
- "Did I decide / write about / take notes on"
- "What's my note on X"
- "Have I covered X anywhere"
- "Look up X in my vault / second brain / notes"
- "What do I know about X" (when X looks personal/historical, not abstract)

## Recall flow (in order)

1. **Check the loaded MOC stub.** SessionStart already injected the top of
   `MOCs/Claude Memory MOC.md`. Scan it first — if the topic is listed, jump
   straight to the linked note.

2. **QMD semantic + hybrid search** — primary recall engine:

   ```bash
   qmd query "<topic>" --json -n 8
   ```

   QMD does BM25 + vector + LLM reranking, all local. Inspect the top results:
   - `score` ≥ 0.7 → high confidence match, definitely relevant
   - `score` 0.5–0.7 → probable match, surface as possibly-relevant
   - `score` < 0.5 → weak signal, treat as no match

3. **Read the top hits.** For each strong result, fetch the full content:

   ```bash
   qmd get "#<docid>"            # by docid from query result
   qmd get "<file-uri>"           # or by qmd:// URI
   obsidian read path="<actual vault path>"
   ```

   Note: QMD URIs use lowercase-hyphenated form (`qmd://vault/3-resources/...`).
   The actual filesystem path uses spaces and Title Case. Use
   `obsidian search:context query="<title>"` to get the canonical path if you
   need to read or link to the note.

4. **Obsidian keyword fallback** — when QMD returns nothing useful, or when
   you need exact-substring matching:

   ```bash
   obsidian search:context query="<topic>" limit=8
   ```

5. **Last resort: scan recent session logs** if neither QMD nor Obsidian has
   the answer:

   ```bash
   obsidian read path="2 - Areas/Daily Ops/<year>/Claude Sessions/<YYYY-MM-DD>.md"
   ```

## How to answer

When you find relevant content:

- **Cite the source.** Always include the wikilink or file path: `[[Note Title]]`
  or `2 - Areas/Daily Ops/2026/Claude Sessions/2026-05-04.md:14:32`.
- **Distinguish provenance.** Notes with `source: claude-memory` frontmatter
  are agent-written compilations. Everything else is human-curated.
- **Synthesize, don't dump.** If multiple notes touch the topic, summarize
  what they collectively say and link the sources — don't paste full content.
- **Be honest about gaps.** If the vault doesn't cover the topic, say so
  explicitly. Then offer to answer from general knowledge if useful.

## Example session

User: "What did I decide about TypeScript generics last month?"

```bash
qmd query "TypeScript generics decision" --json -n 5 2>/dev/null
```

→ Top result `score: 0.84`, file `qmd://vault/3-resources/coding/typescript-generics-strategy.md`,
  has `source: claude-memory` (agent compilation from prior session).

Read it:
```bash
obsidian read path="3 - Resources/Coding/typescript-generics-strategy.md"
```

Answer: "Per [[typescript-generics-strategy]] (compiled from your 2026-04-12
session), you decided to prefer constrained generics over `unknown` in
internal APIs because of [...]. The decision is in `3 - Resources/Coding/`."

## What NOT to do

- **Don't write or modify notes.** Recall is read-only. Anything that needs a
  write goes through `memory_compile.py` (with permission gate).
- **Don't hallucinate citations.** If you can't actually find a note, don't
  invent one. Say "no match found" and offer general-knowledge fallback.
- **Don't dump full notes** unless the user explicitly asks ("paste the full
  note"). Default behavior is summarize-and-link.

## Related rules

See `<vault>/AGENTS.md` for the complete schema. Key sections:
- "Recall flow for personal/historical questions" (the canonical order)
- "Search-before-write" (recall is the inverse — search-before-answer)
