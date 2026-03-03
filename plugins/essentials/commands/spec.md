# Quick Spec Generator

Create a focused specification document with minimal interruption. For complex features needing thorough exploration, use `/deep-spec` instead.

## Step 1: Detect and Fetch Context

Analyze the input: **$ARGUMENTS**

### Source Detection

1. **JIRA**: Pattern `https://*.atlassian.net/browse/*` or `[A-Z]+-[0-9]+`
   - Use browser MCP to fetch ticket details
   - Extract: title, description, acceptance criteria

2. **GitHub Issue**: Pattern `https://github.com/*/issues/*` or `owner/repo#123`
   - Use `gh issue view` or GitHub MCP
   - Extract: title, body, labels

3. **Linear**: Pattern `https://linear.app/*/issue/*` or `[A-Z]+-[0-9]+` with Linear context
   - Use Linear MCP: `mcp__linear__get_issue`
   - Extract: title, description, priority, labels

4. **Text Prompt**: If no pattern matches
   - Treat $ARGUMENTS as raw requirement

Display a brief summary of fetched context before proceeding.

