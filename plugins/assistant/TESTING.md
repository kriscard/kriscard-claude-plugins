# Testing Guide - Assistant Plugin

This guide provides comprehensive testing procedures for the assistant plugin.

## Pre-Testing Setup

### 1. Install Plugin Locally

```bash
# From repository root
claude --plugin-dir ./plugins/assistant
```

Or add to your Claude Code config:

```json
{
  "plugins": {
    "assistant": "./plugins/assistant"
  }
}
```

### 2. Verify Installation

```bash
# In Claude Code session
/plugins

# Should show: assistant@0.1.0
```

### 3. Configure Settings (Optional)

```bash
cp plugins/assistant/.claude/assistant.local.md .claude/assistant.local.md
```

Edit `.claude/assistant.local.md` to customize behavior.

## Component Testing

### Commands

#### Test 1: `/standup` - Daily Standup Generation

**Prerequisites:**
- At least one git commit in the last 24 hours
- Working directory is a git repository

**Test Steps:**
1. Run `/standup` in Claude Code
2. Verify output includes:
   - "Yesterday I:" section with commit summaries
   - "Today I plan to:" section with next tasks
   - Casual, conversational tone (not robotic)

**Expected Output:**
```
Yesterday I:
- [Accomplishment from commits]
- [Accomplishment from commits]

Today I plan to:
- [Inferred next task]
- [Inferred next task]
```

**Pass Criteria:**
- ✅ Output generated without errors
- ✅ Commit messages transformed to casual language
- ✅ Today's plan is reasonable based on yesterday's work

#### Test 2: `/weekly-summary` - Weekly Accomplishment Report

**Prerequisites:**
- Git activity over the last 7 days
- `gh` CLI installed and authenticated (optional for PR data)

**Test Steps:**
1. Run `/weekly-summary`
2. Verify output includes:
   - Shipped section (features/fixes)
   - Code review count and highlights
   - Learning moments
   - Collaboration wins
   - Progress toward goals (if Obsidian connected)

**Pass Criteria:**
- ✅ Comprehensive summary generated
- ✅ Multiple categories included
- ✅ Casual, authentic tone
- ✅ Staff signals noted where applicable

#### Test 3: `/quality-check` - Advisory Quality Validation

**Prerequisites:**
- TypeScript or React files in current branch
- Changes vs main branch

**Test Steps:**
1. Make changes to TypeScript/React files
2. Run `/quality-check`
3. Verify output includes:
   - TypeScript pattern feedback (if .ts/.tsx files)
   - React component feedback (if React files)
   - Test coverage check
   - Advisory language (never blocking)

**Expected Phrases:**
- "Consider...", "Suggestion:", "Opportunity to..."
- NOT: "Must...", "Required...", "You need to..."

**Pass Criteria:**
- ✅ Feedback is advisory only
- ✅ Mentions specific files and line numbers
- ✅ Coordinates with developer-tools agents
- ✅ No blocking errors

#### Test 4: `/context-save` - Save Task Context

**Prerequisites:**
- Active work in progress
- Git repository with modified files

**Test Steps:**
1. Run `/context-save purchase-modal-test`
2. Answer prompts:
   - Mental model: "Building responsive modal for purchases"
   - Related links: [Provide a Jira ticket or PR URL]
   - TODO: "Add mobile navigation, Style desktop layout, Add tests"
3. Verify file created: `.claude/assistant/contexts/purchase-modal-test.json`
4. Check JSON structure:
   ```bash
   jq . .claude/assistant/contexts/purchase-modal-test.json
   ```

**Pass Criteria:**
- ✅ JSON file created with correct structure
- ✅ Mental model captured accurately
- ✅ Links parsed with type detection
- ✅ TODO items stored as array
- ✅ Git state captured (branch, modified files, recent commits)

#### Test 5: `/context-restore` - Restore Task Context

**Prerequisites:**
- Previously saved context from Test 4

**Test Steps:**
1. Switch to different branch: `git checkout main`
2. Run `/context-restore purchase-modal-test`
3. When prompted about branch mismatch, choose option (A/B/C)
4. Verify output includes:
   - Mental model displayed clearly
   - Related links as clickable URLs
   - TODO list with checkboxes
   - Git state information

**Pass Criteria:**
- ✅ Context loaded from JSON correctly
- ✅ Branch mismatch detected and handled
- ✅ User given clear options
- ✅ All context components displayed

#### Test 6: `/staff-progress` - Career Progress Tracking

**Prerequisites:**
- Git repository with commit history
- `gh` CLI for review data (optional)
- Obsidian vault with goals (optional)

**Test Steps:**
1. Run `/staff-progress`
2. Verify output includes:
   - Technical Writing count (ADRs, RFCs, design docs)
   - Code Reviews count and substantive rate
   - System Ownership percentages by directory
   - Cross-Team Impact projects
   - Comparison to Obsidian goals (if available)
   - Trajectory analysis and next actions

**Pass Criteria:**
- ✅ All 4 Staff signals calculated
- ✅ Data sourced from git/GitHub
- ✅ Obsidian goals referenced (read-only)
- ✅ Actionable insights provided
- ✅ Encouraging but honest tone

### Agents

Agents are tested indirectly through commands, but can also be tested directly:

#### Test 7: `quality-enforcer` Agent

**Test Steps:**
1. Ask: "Can you check the quality of my TypeScript code?"
2. Verify agent is invoked (check for agent name in response)
3. Verify advisory feedback provided

**Pass Criteria:**
- ✅ Agent triggers on quality-related requests
- ✅ Uses developer-tools agents for specialized checks
- ✅ Provides specific file:line references
- ✅ Always advisory, never blocking

#### Test 8: `status-generator` Agent

**Test Steps:**
1. Ask: "Help me write my standup"
2. Verify agent transforms commits to accomplishments
3. Check for casual, conversational tone

**Pass Criteria:**
- ✅ Uses essentials/git-committer for commit analysis
- ✅ Casual language ("Shipped X" not "Completed X")
- ✅ Authenticity (acknowledges struggles, celebrates wins)

#### Test 9: `context-manager` Agent

**Test Steps:**
1. Run `/context-save` or `/context-restore`
2. Verify agent handles prompting and JSON formatting

**Pass Criteria:**
- ✅ Intelligent prompting for mental model
- ✅ Link parsing and type detection
- ✅ Git state verification on restore
- ✅ Branch mismatch handling

#### Test 10: `career-tracker` Agent

**Test Steps:**
1. Run `/staff-progress`
2. Verify comprehensive signal tracking

**Pass Criteria:**
- ✅ All 4 signals calculated with evidence
- ✅ Obsidian goals read (never modified)
- ✅ Trajectory analysis provided
- ✅ Specific next actions suggested

### Skill

#### Test 11: Main `assistant` Skill Activation

**Test Proactive Suggestions:**

The skill should proactively suggest actions. Test these scenarios:

1. **After significant commit:**
   - Make a commit with substantial changes
   - Verify suggestion appears: "Consider documenting this architectural decision"

2. **After PR creation:**
   - Create a PR with `gh pr create`
   - Verify suggestion: "Run /quality-check to validate patterns and tests"

3. **At 5:45pm (if configured):**
   - Wait until boundary time
   - Verify soft reminder appears

4. **At session end:**
   - Attempt to end session with work in progress
   - Verify suggestion: "Save context with /context-save"

**Pass Criteria:**
- ✅ Skill loads automatically (check with natural language query)
- ✅ Proactive suggestions appear after appropriate events
- ✅ Suggestions are helpful, not annoying
- ✅ Can be dismissed (not blocking)

### Hooks

Hooks run automatically - verify through their effects:

#### Test 12: PreToolUse Hook (Quality Check Suggestion)

**Test Steps:**
1. Modify significant TypeScript/React files
2. Use Write or Edit tool
3. Verify system message suggests `/quality-check`

**Expected Message:**
"Consider running /quality-check after this change (TypeScript/React feature detected)"

**Pass Criteria:**
- ✅ Hook triggers on Write/Edit of TypeScript/React files
- ✅ Suggestion is advisory (operation still allowed)
- ✅ Does not trigger for minor changes

#### Test 13: SessionStart Hook (Boundary Reminder)

**Test Steps:**
1. Start Claude Code session at 5:45pm-6:00pm
2. Verify boundary reminder appears

**Expected Message:**
"⏰ It's almost 6pm - consider wrapping up soon. Remember your boundary!"

**Pass Criteria:**
- ✅ Only appears during boundary window (5:45-6:00pm)
- ✅ Encouraging tone, not intrusive
- ✅ Outside boundary window, shows welcome message

#### Test 14: Stop Hook (Wrap-Up Suggestions)

**Test Steps:**
1. Do substantial work (commits, PR, etc.)
2. Attempt to end session
3. Verify wrap-up suggestions appear

**Expected Suggestions (if applicable):**
- "Save context with /context-save"
- "Update standup for tomorrow"
- "Document architectural decisions made"

**Pass Criteria:**
- ✅ Hook evaluates session work
- ✅ Suggests appropriate actions based on context
- ✅ Respects user's decision to just stop
- ✅ Encouraging but not pushy

#### Test 15: PostToolUse Hook (Git Activity Tracking)

**Test Steps:**
1. Run git commands: `git commit`, `gh pr create`, etc.
2. Check for tracking acknowledgment

**Expected Message:**
"Tracked: [brief description of git activity]"

**Pass Criteria:**
- ✅ Detects git commit, merge, PR operations
- ✅ Extracts meaningful information
- ✅ Feeds data to /standup and /staff-progress
- ✅ Suppresses output for non-git commands

## Integration Testing

### Test 16: Integration with essentials/git-committer

**Test Steps:**
1. Run `/standup` with git commits
2. Verify uses git-committer for analysis

**Pass Criteria:**
- ✅ Commit messages transformed accurately
- ✅ Technical language → casual language
- ✅ Proper coordination with essentials plugin

### Test 17: Integration with developer-tools

**Test Steps:**
1. Run `/quality-check` on TypeScript/React code
2. Verify delegates to specialist agents

**Pass Criteria:**
- ✅ Invokes typescript-coder for TS files
- ✅ Invokes frontend-developer for React components
- ✅ Aggregates feedback properly
- ✅ Maintains advisory tone

### Test 18: Integration with obsidian-second-brain

**Prerequisites:**
- Obsidian MCP configured
- Goal files exist in vault

**Test Steps:**
1. Run `/staff-progress`
2. Verify reads goals without modification

**Pass Criteria:**
- ✅ Reads goal files successfully
- ✅ Never modifies Obsidian notes
- ✅ Gracefully handles missing files
- ✅ Compares progress to goals accurately

## Learning Behavior Testing

### Test 19: Proactivity Adaptation

**Test Steps:**
1. Set `learning_enabled: true` in settings
2. Dismiss several suggestions consistently
3. Over time, verify suggestion frequency decreases
4. Accept several suggestions consistently
5. Verify suggestion frequency increases

**Data Location:**
`.claude/assistant/learning.json`

**Pass Criteria:**
- ✅ Learning data file created
- ✅ Accept/dismiss rates tracked
- ✅ Proactivity level adjusts over time
- ✅ Changes are gradual, not sudden

### Test 20: Style Learning

**Test Steps:**
1. Run `/standup` and edit output
2. Repeat several times with consistent style changes
3. Verify future standups reflect learned style

**Pass Criteria:**
- ✅ Learns from user's edits
- ✅ Applies learned patterns to future outputs
- ✅ Respects user's voice and preferences

## Error Handling Testing

### Test 21: Missing Dependencies

**Test Steps:**
1. Run `/staff-progress` without `gh` CLI
2. Verify graceful degradation

**Expected Behavior:**
- Progress calculated from git only
- Note about GitHub data unavailable
- No errors or failures

**Pass Criteria:**
- ✅ Works without gh CLI (degraded functionality)
- ✅ Clear message about missing data
- ✅ Suggests installing gh if needed

### Test 22: Missing Obsidian Connection

**Test Steps:**
1. Run `/staff-progress` without Obsidian MCP
2. Verify works without goal comparison

**Expected Behavior:**
- Shows raw signal data
- Notes that goal comparison unavailable
- Continues with analysis

**Pass Criteria:**
- ✅ Doesn't fail without Obsidian
- ✅ Provides useful data anyway
- ✅ Clear about what's missing

### Test 23: Invalid Context File

**Test Steps:**
1. Create malformed JSON in `.claude/assistant/contexts/test.json`
2. Run `/context-restore test`
3. Verify error handling

**Expected Behavior:**
- Clear error message
- Doesn't crash
- Suggests creating new context

**Pass Criteria:**
- ✅ Detects malformed JSON
- ✅ Provides helpful error message
- ✅ Recovers gracefully

## Performance Testing

### Test 24: Large Repository Performance

**Test Steps:**
1. Test in large repository (1000+ commits)
2. Run `/staff-progress` and `/weekly-summary`
3. Measure execution time

**Acceptance Criteria:**
- `/staff-progress`: < 30 seconds
- `/weekly-summary`: < 20 seconds
- No timeouts or crashes

### Test 25: Hook Performance

**Test Steps:**
1. Make many rapid file changes
2. Verify hooks don't slow down operations

**Pass Criteria:**
- ✅ Hooks execute in < 2 seconds each
- ✅ No noticeable delay in file operations
- ✅ Timeouts configured appropriately

## Regression Testing

After any changes to the plugin, re-run:

1. **Core Functionality:** Tests 1-6 (all commands)
2. **Agent Coordination:** Tests 7-10 (agent invocations)
3. **Hook Triggers:** Tests 12-15 (hook behaviors)
4. **Integrations:** Tests 16-18 (plugin coordination)

## Test Checklist

Use this checklist for each testing session:

**Commands:**
- [ ] `/standup` generates daily standup
- [ ] `/weekly-summary` creates comprehensive report
- [ ] `/quality-check` provides advisory feedback
- [ ] `/context-save` captures context correctly
- [ ] `/context-restore` restores context accurately
- [ ] `/staff-progress` tracks all 4 signals

**Agents:**
- [ ] `quality-enforcer` provides advisory feedback
- [ ] `status-generator` uses casual tone
- [ ] `context-manager` handles save/restore
- [ ] `career-tracker` calculates signals

**Skill:**
- [ ] Proactive suggestions appear appropriately
- [ ] Skill coordinates with other plugins
- [ ] Learning behavior adapts over time

**Hooks:**
- [ ] PreToolUse suggests quality checks
- [ ] SessionStart shows boundary reminder
- [ ] Stop hook suggests wrap-up actions
- [ ] PostToolUse tracks git activity

**Integration:**
- [ ] Works with essentials plugin
- [ ] Coordinates with developer-tools
- [ ] Reads from obsidian-second-brain

**Error Handling:**
- [ ] Graceful degradation without gh CLI
- [ ] Works without Obsidian connection
- [ ] Handles malformed context files

## Reporting Issues

When reporting issues, include:

1. **Component:** Command/Agent/Skill/Hook that failed
2. **Test Case:** Which test from this guide
3. **Expected:** What should have happened
4. **Actual:** What actually happened
5. **Environment:** OS, Claude Code version, plugin version
6. **Logs:** Relevant error messages or debug output

**Issue Template:**
```
**Component:** [Command/Agent/Skill/Hook]
**Test:** Test #X - [Name]
**Expected:** [Description]
**Actual:** [Description]
**Environment:** macOS 14.2, Claude Code 1.x, assistant@0.1.0
**Logs:**
```
[Error output]
```
```

## Next Steps After Testing

1. **Document any bugs found** in GitHub issues
2. **Update README** with real-world usage examples
3. **Refine learning behavior** based on test results
4. **Adjust default settings** if needed
5. **Create example outputs** for documentation
