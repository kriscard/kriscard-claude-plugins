# Audit PARA — Classification Correctness Check

Audit the vault for **PARA classification correctness**: is each note in the right bucket per Tiago Forte's rules? Hybrid mode — produces a report, then offers a batched fix flow for the findings.

**Scope this command OWNS:** classification correctness only. Hard signals:
- Projects without outcome or deadline (per Tiago: both required)
- Projects marked done but not archived
- Projects stalled >30 days with no retrospective
- Projects with past `due-date` still marked Active
- Areas with deadlines (should be Projects)
- Resources with deadlines or `project` tag (actionable content in reference)
- Archives modified in last 14 days (reactivated — should it move back?)

**Scope this command does NOT cover** (delegated):
- Broken links, orphans, tag consistency → `/maintain-vault`
- Behavioral drift, avoidance patterns → `/spot-drift`
- Inbox categorization → `/process-inbox`
- Structural section completeness → `/maintain-vault`

## Obsidian Access

Use the `obsidian` CLI via Bash. If a command fails, tell the user "Obsidian CLI isn't working — update Obsidian with CLI enabled."

## Workflow

### Step 1 — Vault rules

Read `AGENTS.md` once. Any write requires explicit user approval (see Phase 2).

```bash
obsidian read path="AGENTS.md"
```

### Step 2 — Phase 1: Audit pass (READ-ONLY)

Gather data. No writes in this phase.

```bash
# Folder inventories
obsidian files folder="1 - Projects/" format=json
obsidian files folder="2 - Areas/" format=json
obsidian files folder="3 - Resources/" format=json
obsidian files folder="4 - Archives/" format=json
```

For each Project file (the highest-leverage bucket), pull frontmatter:

```bash
obsidian property:read path="1 - Projects/<file>.md" name="status"
obsidian property:read path="1 - Projects/<file>.md" name="due-date"
obsidian property:read path="1 - Projects/<file>.md" name="tags"
obsidian read path="1 - Projects/<file>.md"   # for body checks
```

Run **hard checks** (see "Check matrix" below). Cap deep reads at the active project count (currently 4 per `USER.md`) — Areas/Resources/Archives can be inventoried by frontmatter alone unless flagged.

### Step 3 — Report output

Format as a single structured block, grouped by severity:

```
PARA Audit — YYYY-MM-DD

🔴 Critical (classification violations)
  Projects/
    - "<name>": missing due-date frontmatter
    - "<name>": status ✅ Done but still in 1 - Projects/
    - "<name>": due-date 2026-01-15 is past, status 🟢 Active
  Areas/
    - "<name>": has due-date — should be a Project

🟡 Stalled (needs review)
  - "<name>": Updated 2026-04-01 (43 days), no retrospective
  - "<name>": 🔥 Hot but Modified 2026-04-20 (24 days) — demote to Cold?

🟢 Healthy
  - <count> Projects pass all checks
  - <count> Areas pass all checks

Total: X critical, Y stalled. Want to fix the criticals now?
```

### Step 4 — Phase 2: Batch fix flow (INTERACTIVE)

If 0 critical findings: stop with "PARA classification healthy. ✓"

If >0 critical: use `AskUserQuestion` to offer:

```yaml
question: "Fix the N critical findings now?"
header: "Fix"
options:
  - label: "Yes — walk through them"
    description: "Process one at a time, propose action, ask for approval per item."
  - label: "Fix only the archivable ones"
    description: "Auto-target the 'done but not archived' findings (safest batch)."
  - label: "Skip — I'll handle later"
    description: "Report stays available; come back via /audit-para."
```

### Step 5 — Per-finding action proposals

For each critical finding, propose a specific action and route to the right specialist:

| Finding | Proposed action | Delegate to |
|---|---|---|
| Project missing outcome/deadline | "Run validity gate — add fields or convert to Area" | `para-project` skill (UPDATE mode) |
| Project ✅ Done but not archived | "Move to `4 - Archives/Projects - YYYY/<name>.md`, prompt for retrospective if empty" | Direct file move + retro prompt |
| Project due-date past, status Active | "Decide: extend deadline / mark done / archive / convert to Area" | `AskUserQuestion` → branch to right path |
| Area with due-date | "Convert to Project (move to `1 - Projects/`) or remove due-date" | `para-organizer` agent + file move |
| Resource with `project` tag or due-date | "Re-categorize — fire `para-organizer` agent" | `para-organizer` agent |
| Archive modified recently | "Confirm: intentional edit, or should this reactivate to Projects/Areas?" | `AskUserQuestion` → file move |

For each: present the proposal, run `AskUserQuestion` with `{Apply / Skip / Modify}` options, apply only on approve. Per `AGENTS.md`: every vault write needs explicit approval.

### Step 6 — Retrospective gate (for archive moves)

When moving a Project → Archives, **always** check if `## 🔄 Retrospective` is empty. If empty:

```yaml
question: "Fill the retrospective before archiving '<name>'?"
header: "Retro"
options:
  - label: "Yes — quick 3-question prompt"
    description: "What went well, what didn't, what to carry forward. ~3 min."
  - label: "Skip — archive as-is"
    description: "OK, but you lose the durable artifact."
```

If yes: ask the 3 questions via `AskUserQuestion`, patch the section via `obsidian patch`, then move.

## Check matrix (hard signals only)

| Folder | Check | Signal |
|---|---|---|
| Projects | `due-date` frontmatter empty or missing | 🔴 critical |
| Projects | `## 🎯 Objective` section body empty (one line of text required) | 🔴 critical |
| Projects | `status` contains "Done" or "Complete" | 🔴 critical (should archive) |
| Projects | `due-date` < today AND `status` is Active | 🔴 critical (overdue) |
| Projects | `Updated:` marker >30 days old AND retrospective empty | 🟡 stalled |
| Areas | `due-date` is set | 🔴 critical (areas don't have deadlines) |
| Areas | tagged `project` in frontmatter | 🔴 critical |
| Resources | `due-date` is set OR tagged `project` | 🔴 critical (wrong bucket) |
| Archives | file modified time < 14 days ago | 🟡 stalled (reactivated?) |

**Updated: marker:** Found in the body under `## 📍 Current Status\n_Updated: YYYY-MM-DD_`. Parse the date from the template marker, not from filesystem mtime — filesystem mtime gets touched by metadata changes.

## Component reuse map

This command is a thin orchestrator. The heavy lifting lives elsewhere:

- **`para-project` skill** — Project create/update flow (validity gate, hot/cold). Called when audit finds a Project that needs to be re-validated.
- **`para-organizer` agent** — Single-note categorization. Called for "wrong bucket" findings (Area-with-deadline, Resource-with-project-tag).
- **`obsidian-workflows` skill** — Auto-loaded for PARA criteria.
- **`vault-structure` skill** — Auto-loaded for folder paths.
- **`okr-tracker` agent** — Optional, called only if user asks to align findings with OKRs.

## Gotchas

- **Do NOT run this every day** — Tiago recommends weekly. Daily noise dulls signal.
- **Do NOT auto-fix** — every write needs approval per `AGENTS.md`. Phase 2 batching ≠ silent batch writes.
- **Do NOT overlap with `/maintain-vault`** — if a finding is structural (broken link, missing section), tell the user to run that command instead.
- **Don't pull deep file content for Areas/Resources unless flagged** — frontmatter checks are cheap; full reads are slow at scale.
- **Filesystem mtime is unreliable** — use the `Updated:` marker in the body (project template encodes this).
- **Hot/Cold isn't audited yet** — that's a "soft" signal. If you want it later, layer it in as a 🟡 yellow check.

## Manual override

If the user disagrees with a finding ("this Area genuinely doesn't need a deadline even though it has activity"), respect it. PARA is a tool, not a law. Offer to:
- Add an exception note in the file (a comment near the relevant frontmatter)
- Skip the finding for this audit run (no persistence across runs — by design)
