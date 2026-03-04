# Money — Revenue Advisor

Go beyond what the vault contains to figure out how to make more money. The vault is the starting point, not the ceiling. Surface opportunities the user cannot see from inside their own perspective.

Usage: `/money` (full analysis) or `/money [domain]` (focused on a specific area)

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/obsidian-utils.sh" status
```

## Step 1: Deep Vault Scan

### Context Discovery
```bash
obsidian search query="project" format=json
obsidian search query="business" format=json
obsidian search query="client" format=json
obsidian search query="revenue" format=json
obsidian search query="pricing" format=json
obsidian files folder="1 - Projects/" format=json
```

Read whatever comes back that looks like structured notes about work, companies, or active projects.

### Daily Notes (Past 30 Days)
```bash
obsidian read path="2 - Areas/Daily Ops/YYYY/YYYY-MM-DD.md"  # for recent days
```

Extract:
- Client work mentioned (past and current)
- Revenue discussions, pricing conversations
- Skills demonstrated (things actually done, not claimed)
- Tools built or systems created
- Frustrations that might signal market gaps
- Ideas for products, services, or offerings

## Step 2: Asset Inventory

Map what you actually have. Be specific and evidence-based.

### Skills (Demonstrated, Not Claimed)
Only list skills with vault evidence of execution.

### Relationships
- Professional network
- Client relationships (current and past)
- Community / audience

### IP & Infrastructure
- Content libraries, templates, frameworks
- Custom tooling or workflows documented in vault
- Production or service capabilities

### Audience & Distribution
- Social media following and engagement
- Any distribution channels

### Credibility Signals
- Notable clients, collaborators, or affiliations
- Public proof (viral content, appearances, testimonials)
- Are these signals being used in pitches? If not, flag it.

## Step 3: Revenue Diagnostics

Diagnose the revenue system FIRST. The problem is usually not "what to sell" but "why isn't what exists converting?"

### Attention-to-Revenue Conversion
- Total impressions/attention generated
- Total revenue generated
- If conversion is low, diagnose what's missing: no product, no CTA, no funnel, no offer

### Revenue Type Audit
Categorize all revenue:
- **One-time payments** (client work, contracts)
- **Recurring revenue** (retainers, subscriptions)
- **Passive income** (products, licensing)
- **Equity positions** (advisory, investments)

If everything is one-time payments, flag as structural problem.

### Sales System Audit
Does a sales system exist? Check for:
- Active outbound process (or purely inbound/luck?)
- Pipeline tracking
- Follow-up system
- Rate card or pricing
- Pitch materials

No sales system = no predictable revenue.

### Pricing Structure
- Time-based (hourly): Linear, capped by hours
- Project-based (flat fee): Better, still one-time
- Value-based (outcomes): Best, requires confidence

If time-based, calculate the ceiling: rate x available hours = max annual income. Acceptable?

## Step 4: Beyond the Vault

### Blind Spots
- Aversion to selling? To pricing aggressively?
- Pattern of undervaluing work?
- Building without monetization plans?

### Market Context
- What are comparable people charging?
- What adjacent markets exist?
- What macro trends create opportunities?

### The Packaging Gap
- Skills with no associated price or offering
- Work done for one client that could be repeatable
- Internal tools with external value
- Attention/audience with no conversion mechanism

## Step 5: Revenue Opportunities

For each category, cite vault evidence. Also include opportunities that extrapolate BEYOND the vault.

- **Services to Sell** — Based on proven work
- **Products to Build** — Revenue without active work
- **Low-Hanging Fruit (This Week)** — Minimal effort, asset already exists
- **Medium-Term Plays (1-3 Months)** — Require setup, clear path
- **Long-Term Bets (6-12 Months)** — Bigger plays aligned with trajectory
- **Undermonetized Assets** — Already built, not generating revenue
- **Pricing Corrections** — Evidence of undercharging

## Step 6: Prioritization

### Top 5 by Effort-to-Revenue Ratio
```
[Opportunity]: Effort [Low/Medium/High]. Revenue potential [$/timeframe]. Why it ranks here.
```

### The Immediate Play
One thing to do this week. Specific first step.

### The Biggest Upside
Highest ceiling opportunity. Why evidence supports it.

### The Surprising One
Non-obvious opportunity most people would miss.

### The Structural Fix
The one change to HOW revenue works (not what to sell) that would have the biggest impact.

## Step 7: Actionable Builds

End every `/money` run with a list of specific documents or materials the agent can create RIGHT NOW:
- Service offerings document
- Cold outreach email template
- Pricing page or rate card
- Pitch document for a specific opportunity
- Product landing page draft

Format:
```
[Document]: What it is. What it unblocks. Estimated revenue impact. "I can build this now."
```

Ask which ones to build. Then build them.

## Anti-Patterns

1. **The Newsletter Fallacy** — No generic "start a newsletter" unless there's specific evidence of demand.
2. **The Scale Fantasy** — Don't jump to "$X million." Start with first month, current resources.
3. **The Vague Opportunity** — "Consulting" is not an opportunity. Be specific about who, what, and how much.
4. **The Cheerleader** — Don't sugarcoat. If the revenue system is broken, say so plainly.
5. **The Vault Ceiling** — Don't limit analysis to what's in the vault. The most valuable insights come from seeing what you're NOT thinking about.

## Output Guidelines

- Cite vault evidence, but don't let the vault be the ceiling.
- Be specific about numbers. "$5K-10K/month" not "significant revenue."
- Account for actual constraints found in the vault.
- Diagnose the revenue SYSTEM first, then suggest opportunities.
- Be direct. If something is broken, say it plainly.
- Always end with things you can build immediately.
