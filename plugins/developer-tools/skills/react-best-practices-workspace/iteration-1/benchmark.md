# Iteration 1 — react-best-practices Skill Eval

**Question being tested:** does the routing table + universal-checks tier in `SKILL.md` cause the model to load the correct reference(s) for each intent, and apply the universal checks even on ambient prompts?

## Results

All 6 evals passed.

| # | Eval name | Expected reference | Actually loaded | Result |
|---|---|---|---|---|
| 1 | useeffect-derived-state | `useeffect-antipatterns.md` | `useeffect-antipatterns.md` | ✅ PASS |
| 2 | memo-chain-broken | `re-renders-and-memoization.md` | `re-renders-and-memoization.md` | ✅ PASS |
| 3 | modal-behind-navbar | `portals-and-stacking-context.md` | `portals-and-stacking-context.md` | ✅ PASS |
| 4 | rendering-model-choice | `rendering-models.md` | `rendering-models.md` | ✅ PASS |
| 5 | bundle-size-investigation | `bundle-and-perf-investigation.md` | `bundle-and-perf-investigation.md` | ✅ PASS |
| 6 | ambient-review | universal checks fire | universal checks fired (caught all 3 issues), no reference loaded | ✅ PASS |

## Tokens & timing per eval

| # | Tokens | Duration | Tool uses |
|---|---|---|---|
| 1 | 62,526 | 24.6s | 2 |
| 2 | 60,955 | 18.5s | 2 |
| 3 | 59,586 | 16.7s | 2 |
| 4 | 59,979 | 20.2s | 2 |
| 5 | 59,927 | 18.1s | 2 |
| 6 | 57,139 | 16.0s | 1 |

Mean: ~60k tokens, ~19s, 2 tool uses (1 for ambient = SKILL.md only)

## Behavioral observations

**The routing table worked as designed:**
- Every themed prompt loaded exactly the matching reference — no over-loading (multiple files), no skip-loading (zero files when relevant)
- The "Read this when..." headers in each reference likely reinforced confidence in the routing match
- Each subagent's 2 tool uses correspond to: Read SKILL.md → Read the matching reference

**The universal-checks tier worked for ambient prompts:**
- Eval 6 ("review this component") loaded zero references but still caught all three universal issues:
  - Component defined inside another component (StatCard nested in Dashboard)
  - Array index as key (`key={i}`)
  - Fetch in useEffect without cleanup
- The subagent's explicit reasoning: "I don't need any deep-dive references; the universal checks cover all the issues."

**No iteration needed.** The current SKILL.md design is reliably routing the model. The lazy-load contract holds:
- SKILL.md body is always-loaded and catches universal pitfalls
- References load only when intent matches
- Ambient/general prompts can be answered from the body alone

## What was NOT tested

- Skill **triggering** — i.e., would the model invoke `react-best-practices` from the description alone when the user doesn't explicitly say "audit"? This is a separate concern (the description optimization loop) and could be tested via `scripts/run_loop.py` from skill-creator.
- **Without-skill baseline** — quality comparison vs no skill loaded. Could be added in a future iteration.
- **Larger eval set** — 6 prompts is enough for confidence on routing; a 20-prompt sweep with negative cases ("should NOT trigger") would harden the description.

## Conclusion

The lazy-load + universal-check architecture is working. The routing table is reliable for the tested intents. Phase 2 of the rigorous approach is complete.
