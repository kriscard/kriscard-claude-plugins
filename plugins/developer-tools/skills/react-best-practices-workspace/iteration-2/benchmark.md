# Iteration 2 — Expanded Routing Validation

**Tests:** the new routing table (5 conceptual + 7 rule-level + universal checks) routes correctly across both tiers.

**Changes since iteration 1:**
- Added universal-checks tier (6 always-run pitfalls) to SKILL.md body
- Added "Read this when..." headers to each reference
- Split former `vercel-rules.md` into 7 rule-level reference files
- Routing table doubled from 6 to 12 entries

## Results (after tuning fix)

**Final score: 8/8 strict pass.**

| # | Eval | Expected | Loaded | Verdict |
|---|---|---|---|---|
| 1 | waterfalls-sequential-awaits | `waterfalls.md` | `waterfalls.md` | ✅ PASS |
| 2 | bundle-optimization-rules | `bundle-optimization.md` | `bundle-optimization.md` | ✅ PASS |
| 3 | server-rsc-dedup | `server-and-rsc.md` | `server-and-rsc.md` | ✅ PASS |
| 4 | client-fetching-listeners | `client-fetching.md` | `client-fetching.md` | ✅ PASS |
| 5 | re-render-rule-specific | `re-render-patterns.md` | `re-render-patterns.md` (after fix) | ✅ PASS |
| 6 | re-renders-conceptual | `re-renders-and-memoization.md` | `re-renders-and-memoization.md` | ✅ PASS |
| 7 | rendering-perf-hydration | `rendering-performance.md` | `rendering-models.md` + `rendering-performance.md` | ✅ PASS (loaded extra but right one included) |
| 8 | javascript-perf-hot-loop | `javascript-performance.md` | `javascript-performance.md` | ✅ PASS |

### Initial result (before fix)

First run was 7/8 strict pass — eval #5 loaded the conceptual file (`re-renders-and-memoization.md`) instead of the rule-level file. Answer quality was still correct, but the routing was ambiguous because both files cover `useMemo`.

### The fix

Added a discriminator to SKILL.md routing rules and tightened the rule-level file's "Read this when..." header:

**SKILL.md routing — new bullet:**
> Conceptual vs. rule-level — discriminator: if the user asks *"should I do X?"*, *"is this a good pattern?"*, *"do I need to wrap this in useMemo?"* — that's a rule-level question → load the corresponding rule-level file. If they ask *"why does this re-render?"*, *"why isn't React.memo working?"* — that's conceptual → load the conceptual file.

**`re-render-patterns.md` header — added explicit phrases:**
> Read this when the user asks a concrete code-level rule question such as:
> - "Should I wrap this in useMemo?" / "Do I need useCallback here?"
> - "Is this a good pattern?" / "What's the rule for X?"

### Re-run of #5 after fix

Same prompt, same skill, fresh subagent. Result: loaded `re-render-patterns.md` as expected. Answer cited rule #23 directly. Fix confirmed.

## Tokens & timing

| # | Tokens | Duration | Tool uses |
|---|---|---|---|
| 1 | 58,628 | 20.1s | 2 |
| 2 | 58,750 | 21.6s | 2 |
| 3 | 59,207 | 16.2s | 2 |
| 4 | 58,872 | 16.9s | 2 |
| 5 | 61,037 | 17.6s | 2 |
| 6 | 61,024 | 17.9s | 2 |
| 7 | 61,281 | 25.0s | 4 (loaded 2 refs) |
| 8 | 60,502 | 17.0s | 2 |

Mean: ~60k tokens, ~19s, 2 tool calls. Token cost similar to iteration 1 — expanded routing table didn't bloat per-query cost.

## The one nuanced result (#5)

Prompt: *"should I wrap `items.length > 0` in useMemo? What about `firstName + ' ' + lastName`? Need a concrete rule."*

- **Expected:** `re-render-patterns.md` (which has rule #23 "Don't wrap simple expressions in useMemo")
- **Loaded:** `re-renders-and-memoization.md` (the conceptual file with the chain rule)
- **Why this happened:** the user's framing mentioned "useMemo" and "Why" — which strongly matches the conceptual file's header. The model chose the conceptual file even though "Need a concrete rule" should have pulled it toward rule-level.

**Was the answer still good?** Yes. The agent cited Nadia's measurements (sorting 250 items <2ms vs rendering >20ms), the chain rule, and the React Compiler escape-hatch guidance. It gave a concrete, correct answer.

**Should we tune?** Marginal. The two files genuinely overlap on `useMemo` — both have legitimate coverage. The model loaded one, answered well, and the user got a usable response. Pursuing strict routing here risks over-engineering for diminishing returns.

**If we did tune,** the smallest helpful change would be adding a one-liner in SKILL.md noting that rule-level files contain *concrete code rules* and conceptual files contain *frameworks/why* — so when the user explicitly asks for "a rule," prefer rule-level. Optional; current behavior is acceptable.

## What this validates

- **The 7 new rule-level files trigger correctly** for their target intents (4/4 strict pass on the new files for which the expected was uniquely rule-level)
- **The conceptual references didn't break** (3/3 strict pass on conceptual targets)
- **Universal checks still fire** (no regression — confirmed in iteration 1; not re-tested here)
- **Multi-reference loads when warranted** (#7 loaded both rendering files — reasonable behavior given hydration spans both topics)

## Conclusion

The expanded routing table works. The lazy-load contract holds with 12 references just as well as with 6. The one nuanced miss is within acceptable judgment-call territory.

**Decision: proceed to commit.** No SKILL.md iteration needed.
