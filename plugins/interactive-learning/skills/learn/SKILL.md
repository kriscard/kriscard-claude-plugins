---
name: learn
description: "Start an interactive learning session on any technology topic, or end a session to create Obsidian notes. Use when user says '/interactive-learning:learn', wants to learn a topic, or needs an interactive tutorial."
disable-model-invocation: true
---

# Interactive Learning Command

## Obsidian Access

**Prefer CLI, fall back to MCP with confirmation.**

When ending a session (`/learn done`), check CLI availability first:
```bash
obsidian vault &>/dev/null && echo "CLI_AVAILABLE" || echo "CLI_UNAVAILABLE"
```

- If `CLI_AVAILABLE`: Use Obsidian CLI commands via Bash
- If `CLI_UNAVAILABLE`: Ask user "Obsidian CLI isn't available. May I use Obsidian MCP instead?" and wait for confirmation

## Handling Arguments

**If argument is "done":**
1. Use the `learning-summarizer` agent to create an Obsidian note from this session
2. The agent will extract key concepts, code snippets, and takeaways from the conversation
3. Note is saved to `3 - Resources/TIL/` using the Learning Tech Template

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
- Ask ONE question at a time using **AskUserQuestion tool**, wait for response
- **Directly correct misconceptions**--accuracy matters more than comfort
- **Challenge confident but wrong answers**--de-learning is as valuable as learning
- Suggest hands-on exercises when appropriate
- Reference official documentation for deep dives

### Handling Wrong Answers

When the user answers incorrectly:
1. State clearly it's wrong: "That's not quite right" or "Actually, that's a misconception"
2. Explain what actually happens and why
3. Show evidence (code output, docs quote)
4. Re-ask or ask a follow-up to confirm new understanding

**Never leave a misconception uncorrected to avoid awkwardness.**

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
