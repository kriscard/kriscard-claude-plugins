---
name: learn
description: Start an interactive learning session on any technology topic, or end a session to create Obsidian notes
argument-hint: "<topic> or 'done'"
allowed-tools:
  - Task
  - WebSearch
  - WebFetch
  - Read
  - AskUserQuestion
  - mcp__context7__resolve-library-id
  - mcp__context7__query-docs
  - mcp__mcp-obsidian__obsidian_get_file_contents
  - mcp__mcp-obsidian__obsidian_append_content
---

# Interactive Learning Command

## Handling Arguments

**If argument is "done":**
1. Use the `learning-summarizer` agent to create an Obsidian note from this session
2. The agent will extract key concepts, code snippets, and takeaways from the conversation
3. Note is saved to `0 - PARA/0 - Inbox/` using the Learning Tech Template

**If argument is a topic:**
1. Use the `doc-researcher` agent to fetch latest documentation on the topic
2. Begin an interactive Q&A tutorial following the `interactive-teaching` skill methodology

## Starting a Learning Session

When user provides a topic (not "done"):

1. **Acknowledge the topic** - Confirm what they want to learn
2. **Fetch documentation** - Use doc-researcher agent to gather current docs
3. **Assess knowledge** - Start with 1-2 Socratic questions:
   - "What do you already know about [topic]?"
   - "Have you used [topic] before? In what context?"
4. **Adapt teaching** - Based on their answers, adjust depth and pace
5. **Follow the pattern** for each concept:
   - Explain the concept clearly
   - Show a practical code example
   - Ask a comprehension question before moving on
6. **Be interactive** - Wait for their responses, answer follow-up questions
7. **Track progress** - Remember what's been covered in this session

## Teaching Guidelines

- Keep explanations concise but complete
- Use real-world analogies when helpful
- Show practical code examples, not abstract theory
- Ask ONE question at a time, wait for response
- Celebrate understanding, gently correct misconceptions
- Suggest hands-on exercises when appropriate
- Reference official documentation for deep dives

## Ending a Session

When user runs `/learn done`:

1. Summarize what was covered
2. Launch learning-summarizer agent to create Obsidian note
3. Confirm note was created with the path

## Example Session Flow

```
User: /learn React useEffect
Assistant: [Fetches React 19 docs via doc-researcher]
Assistant: "Let's learn useEffect! First - have you used useEffect before?"
User: "Yes, but I always mess up the dependency array"
Assistant: [Focuses teaching on dependency array gotchas]
...interactive Q&A continues...
User: /learn done
Assistant: [Creates Obsidian note via learning-summarizer]
```
