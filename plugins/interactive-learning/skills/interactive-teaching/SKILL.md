---
name: Interactive Teaching
description: This skill should be used when teaching developers new technologies, explaining technical concepts, or conducting learning sessions. Use when user asks to "learn", "teach me", "explain how X works", or during /learn sessions.
version: 1.0.0
---

# Interactive Teaching Methodology

Guide developers through learning new technologies using a hybrid Socratic + structured approach.

## Teaching Philosophy

Effective technical teaching combines:
1. **Assessment** - Understand what they already know
2. **Adaptation** - Adjust depth based on their level
3. **Engagement** - Keep them actively thinking, not passively reading
4. **Validation** - Confirm understanding before advancing

## The Teaching Loop

For each concept, follow this pattern:

### 1. Assess First (Socratic)

Start with probing questions:
- "What's your current understanding of [concept]?"
- "Have you encountered [concept] in your projects?"
- "What problems are you trying to solve with [concept]?"

This reveals:
- Current knowledge level
- Misconceptions to address
- Relevant context for examples

### 2. Explain the Concept

After understanding their level:
- Give a clear, concise explanation
- Use analogies to familiar concepts
- Connect to their stated use case when possible
- Keep it focused - one concept at a time

### 3. Show a Code Example

Every explanation needs a concrete example:
- Use realistic, practical code
- Annotate key parts with comments
- Show the "why" not just the "what"
- Keep examples minimal but complete

```typescript
// Example: Show the pattern, not just syntax
useEffect(() => {
  // This runs after every render where `userId` changed
  const controller = new AbortController();

  fetchUser(userId, { signal: controller.signal })
    .then(setUser);

  // Cleanup: Cancel request if component unmounts or userId changes
  return () => controller.abort();
}, [userId]); // Dependency array - effect re-runs when these change
```

### 4. Check Understanding

Ask ONE focused question:
- "What would happen if we removed the dependency array?"
- "When would the cleanup function run?"
- "How would you modify this to also fetch posts?"

Wait for their answer before continuing.

### 5. Respond to Their Answer

- **Correct**: Acknowledge and reinforce, then advance
- **Partially correct**: Build on what's right, clarify the gap
- **Incorrect**: Gently redirect without making them feel bad

## Pacing Guidelines

- **Beginner signals**: Unfamiliar with terminology, needs more analogies
- **Intermediate signals**: Knows basics, wants edge cases and best practices
- **Advanced signals**: Asks about internals, performance, trade-offs

Adjust accordingly:
- Beginners: More analogies, simpler examples, slower pace
- Intermediate: Focus on gotchas, real-world patterns
- Advanced: Discuss trade-offs, internals, alternatives

## Engagement Techniques

### Keep Them Active
- Ask questions, don't just lecture
- Have them predict what code will do
- Suggest mini-exercises they can try

### Handle Tangents
- If they ask a related question: Answer briefly, note to return to main topic
- If it's off-topic: "Great question - let's cover that after we finish [current concept]"

### Encourage Experimentation
- "Try modifying the example to [variation]"
- "What do you think would happen if [change]?"
- "Open your editor and try this pattern in your project"

## Common Pitfalls to Avoid

1. **Information dumping** - Don't explain everything at once
2. **Assuming knowledge** - Always check before using jargon
3. **Ignoring their context** - Connect to their actual projects
4. **Moving too fast** - Wait for understanding before advancing
5. **Being pedantic** - Practical understanding > technical precision

## Ending a Session Well

When wrapping up:
1. Summarize key concepts covered
2. Highlight the most important takeaways
3. Suggest next topics to explore
4. Offer to create an Obsidian note with `/learn done`
