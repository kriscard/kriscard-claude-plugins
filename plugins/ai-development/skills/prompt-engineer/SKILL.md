---
name: prompt-engineer
description: "AI/LLM: Use when crafting system prompts, optimizing LLM outputs, or improving agent instructions. NOT for general coding."
---

# Prompt Engineer

Expert in crafting effective prompts for LLMs.

## Core Techniques

### Chain-of-Thought
Guide the model through reasoning steps.

```
Let's solve this step by step:
1. First, identify...
2. Then, analyze...
3. Finally, conclude...
```

### Few-Shot Learning
Provide examples to establish patterns.

```
Example 1:
Input: [example input]
Output: [example output]

Example 2:
Input: [example input]
Output: [example output]

Now process:
Input: [actual input]
```

### Role Prompting
Establish expertise and perspective.

```
You are an expert [role] with deep experience in [domain].
Your task is to [specific objective].
```

### Structured Output
Request specific formats.

```
Respond in the following JSON format:
{
  "field1": "description",
  "field2": ["array", "items"]
}
```

## Prompt Structure

### System Prompt Components

1. **Role**: Who the AI is
2. **Context**: Background information
3. **Task**: What to do
4. **Constraints**: Limitations and rules
5. **Output format**: Expected structure

### Effective Patterns

```
[Role and expertise]

[Context and background]

[Specific task instructions]

[Output format requirements]

[Examples if needed]

[Edge case handling]
```

## Optimization Strategies

### Clarity
- Use precise language
- Avoid ambiguity
- Define terms

### Specificity
- Explicit instructions
- Concrete examples
- Clear boundaries

### Structure
- Logical flow
- Consistent formatting
- Clear sections

## Common Issues

| Issue | Solution |
|-------|----------|
| Hallucinations | Add "If unsure, say so" |
| Wrong format | Provide explicit schema |
| Off-topic | Add "Stay focused on X" |
| Too verbose | Request concise responses |
| Missing context | Add relevant background |

## Testing Prompts

1. Test with edge cases
2. Measure consistency
3. Check output format
4. Validate accuracy
5. Monitor in production

## Production Considerations

- Version control prompts
- A/B test changes
- Log inputs/outputs
- Monitor quality metrics
- Handle failures gracefully
