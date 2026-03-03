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

**Fixed Issues:**
- Previously problematic patterns that are now correct
- Issues addressed since last check

**Suggestions:**
- Advisory improvements (not required)
- Pattern opportunities
- Potential optimizations

**Opportunities:**
- Larger refactoring possibilities
- Documentation needs
- Test additions that would be valuable

## Output Format

```
Quality Check Results

Files Checked: X TypeScript, Y React

TypeScript Patterns: [pass | suggestions | issues]
[Details from typescript-coder agent]

React Patterns: [pass | suggestions | opportunities]
[Details from frontend-developer agent]

Test Coverage:
✓ src/utils/formatDate.ts (test exists)
⚠ src/hooks/usePayment.ts (no test found)
✓ src/components/PurchaseModal.tsx (test exists)

Overall Assessment:
[Summary with emphasis on advisory nature]

