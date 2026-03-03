# Deep Specification Through Interview

Conduct comprehensive interviews (9-14 questions across 4 rounds) to create a detailed specification. For quick specs with minimal questions, use `/spec` instead.

## Step 1: Detect and Fetch Context

Analyze the input: **$ARGUMENTS**

### Source Detection

1. **JIRA**: Pattern `https://*.atlassian.net/browse/*` or `[A-Z]+-[0-9]+`
   - Use browser MCP to navigate and snapshot
   - Extract: title, description, acceptance criteria, priority, comments

2. **GitHub Issue**: Pattern `https://github.com/*/issues/*` or `owner/repo#123`
   - Use `gh issue view` or GitHub MCP
   - Extract: title, body, comments, labels

3. **Linear**: Pattern `https://linear.app/*/issue/*` or `[A-Z]+-[0-9]+` with Linear context
   - Use Linear MCP: `mcp__linear__get_issue`
   - Extract: title, description, priority, labels, comments

4. **Text Prompt**: If no pattern matches
   - Treat $ARGUMENTS as raw requirement

Display summary of fetched context before proceeding.

