---
description: Run advisory quality validation for code patterns and tests
allowed-tools: Bash(git:*), Read, Grep
argument-hint: [optional-file-pattern]
model: sonnet
---

Run comprehensive but advisory quality validation on code changes. This check provides suggestions but NEVER blocks - the user always has final say on shipping code.

## Scope Determination

If file pattern provided:
```
Check specified files: $ARGUMENTS
```

If no pattern provided, check current branch changes:
```bash
git diff --name-only main...HEAD
```

Filter for TypeScript/React files:
- `*.ts`
- `*.tsx`
- Exclude: `*.test.ts`, `*.test.tsx`, `*.spec.ts` (test files themselves)

## Quality Checks

### 1. Code Patterns (TypeScript)

For TypeScript files, invoke developer-tools/typescript-coder agent:

```
Review these TypeScript files for pattern adherence and best practices:
[file list]

Focus on:
- Type safety and inference
- Proper use of generics
- Avoiding any types
- Consistent naming conventions
- Proper error handling patterns
```

### 2. Code Patterns (React)

For React files, invoke developer-tools/frontend-developer agent:

```
Review these React components for pattern adherence and best practices:
[file list]

Focus on:
- Component composition
- Hook usage patterns
- State management
- Props typing
- Performance considerations (memo, useMemo, useCallback)
- Accessibility
```

### 3. Test Coverage

Check if tests exist for new code:

```bash
# For each new/changed file, check if test file exists
for file in [changed files]; do
  test_file="${file%.tsx}.test.tsx"
  test -f "$test_file" && echo "✓ $file" || echo "⚠ $file"
done
```

Note: This checks existence only, not coverage percentage.

## Analysis & Aggregation

Collect feedback from all checks and categorize:

**Fixed Issues (✅):**
- Previously problematic patterns that are now correct
- Issues addressed since last check

**Suggestions (⚠️):**
- Advisory improvements (not required)
- Pattern opportunities
- Potential optimizations

**Opportunities (💡):**
- Larger refactoring possibilities
- Documentation needs
- Test additions that would be valuable

## Output Format

```
Quality Check Results

Files Checked: X TypeScript, Y React

TypeScript Patterns: [✅ | ⚠️ | ❌]
[Details from typescript-coder agent]

React Patterns: [✅ | ⚠️ | 💡]
[Details from frontend-developer agent]

Test Coverage:
✓ src/utils/formatDate.ts (test exists)
⚠️ src/hooks/usePayment.ts (no test found)
✓ src/components/PurchaseModal.tsx (test exists)

Overall Assessment:
[Summary with emphasis on advisory nature]

---

Remember: This check is advisory only. You have final say on all changes.
All suggestions are optional and context-dependent.
```

## Advisory Language

**Always use advisory tone:**

✅ **Good:**
- "Consider adding tests for usePayment hook"
- "This pattern could be simplified using X"
- "Opportunity to extract common logic into utility"
- "Suggestion: Add accessibility labels to form inputs"

❌ **Bad:**
- "You must add tests"
- "This code violates our standards"
- "Fix this before committing"
- "This is wrong, change it to X"

## Integration

This command coordinates:
- **developer-tools/typescript-coder** for TypeScript validation
- **developer-tools/frontend-developer** for React validation
- **git** for determining scope of changes

## Special Cases

### No Changes Detected

```
Quality Check Results

No TypeScript or React changes detected in current branch.

Checked against: main
Current branch: [branch-name]

Nothing to validate at this time.
```

### All Clear

```
Quality Check Results

Files Checked: 3 TypeScript, 2 React

✅ TypeScript patterns look good
✅ React patterns follow best practices
✅ All files have corresponding tests

Overall: Excellent! Your code is ready to ship.

Minor suggestions:
💡 Consider documenting the new usePayment hook in README
💡 The PurchaseModal could benefit from Storybook stories
```

### Issues Found

```
Quality Check Results

Files Checked: 2 TypeScript, 1 React

✅ TypeScript patterns look good
⚠️  React patterns have suggestions
⚠️  Some test gaps

React Patterns:
- PurchaseModal.tsx: Consider using useCallback for event handlers to prevent re-renders
- PurchaseModal.tsx: Form inputs could benefit from aria-label attributes

Test Coverage:
✓ src/utils/formatDate.ts
⚠️ src/hooks/usePayment.ts (no test found)

Overall: Good work! A few suggestions above.

These are advisory - ship if you're confident.
Consider addressing test gap for usePayment if time permits.
```

## Configuration

Quality priorities are learned from user behavior and stored in `.claude/assistant/learning.json`.

User can configure explicitly in `.claude/assistant.local.md`:
```yaml
quality_checks:
  - patterns  # TypeScript/React patterns
  - tests     # Test existence
```

## Notes

- This check is ALWAYS advisory, never blocking
- Suggestions are context-dependent
- User has final say on all decisions
- Goal is to provide helpful feedback, not enforce rigid rules
- Learning system tracks which suggestions user acts on
