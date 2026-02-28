---
name: write-blog
description: "Write a polished technical blog post from brain dump or outline. Use when user says '/content:write-blog', wants to write a blog post, or needs help drafting technical content."
disable-model-invocation: true
---

# Write Blog Post

Transform your rough ideas, brain dumps, or outlines into a polished, SEO-optimized technical blog post.

## Usage

```bash
# From topic
/write-blog "Migrating from npm to pnpm"

# From outline
/write-blog "I want to write about TypeScript migration. Key points: why we did it, challenges we faced, lessons learned"

# Interactive (no arguments)
/write-blog
```

## What This Does

This command orchestrates the complete blog writing workflow by coordinating the blog-writer skill and documentation agents.

## Orchestration Workflow

### Phase 1: Load Context

Load the `blog-writer` skill to access:
- Writing guidelines and voice/tone
- Post type templates (tutorial, showcase, opinion, TIL, comparison)
- Story Circle narrative framework
- SEO optimization checklist

### Phase 2: Gather Requirements

**If user provided topic/outline in $ARGUMENTS:**
- Use provided content as starting point

**If no arguments (interactive mode):**
- Use `AskUserQuestion` tool to ask:
  - What topic do you want to write about?
  - What type of post? (tutorial, showcase, opinion, TIL, comparison, case study)
  - Who's the target audience? (beginner, intermediate, advanced)
  - Any specific points to cover?
  - Do you have code examples or screenshots?

### Phase 3: Structure with Story Circle

Apply Story Circle framework (via blog-writer skill):

1. **You** - Reader's current situation
2. **Need** - What problem they face
3. **Go** - Decision to learn/change
4. **Search** - Exploring the solution
5. **Find** - Key insight or approach
6. **Take** - Implementation details
7. **Return** - Results and lessons
8. **Change** - How reader transforms

### Phase 4: Draft Content

Invoke `blog-writer` skill to generate:
- Compelling headline (multiple options)
- Introduction hook
- Structured body following Story Circle
- Code examples with explanations
- Conclusion with call-to-action
- SEO metadata (description, keywords)

**Writing guidelines applied:**
- Active voice, conversational tone
- Technical accuracy with accessibility
- Real-world examples and practical takeaways
- Proper code formatting and syntax highlighting

### Phase 5: SEO Optimization

Run through SEO checklist (from blog-writer skill):
- [ ] Headline includes target keyword
- [ ] Meta description compelling and < 160 chars
- [ ] Internal/external links included
- [ ] Images have alt text
- [ ] Headings use proper hierarchy (H2, H3)
- [ ] Code blocks have language tags
- [ ] Reading time estimate added

### Phase 6: Quality Review (Optional)

If requested, invoke `docs-architect` agent to:
- Review technical accuracy
- Check structure and flow
- Suggest improvements
- Verify code examples are complete

### Phase 7: Deliver

Write the blog post to:
- **Default:** `./blog/{slug}.md`
- **Custom:** Path specified by user

Include frontmatter:
```yaml
---
title: "Your Blog Title"
date: 2026-01-11
description: "SEO meta description"
tags: [tag1, tag2, tag3]
author: Your Name
readingTime: "8 min"
---
```

## Post Type Templates

### Tutorial
**Structure:** Problem → Solution → Implementation → Testing → Conclusion
**Example:** "Building a Real-Time Dashboard with Next.js"

### Showcase
**Structure:** What we built → Why we built it → How we built it → Results
**Example:** "How We Reduced API Latency by 80%"

### Opinion
**Structure:** Thesis → Context → Arguments → Counter-arguments → Conclusion
**Example:** "Why TypeScript Isn't Always the Answer"

### TIL (Today I Learned)
**Structure:** Problem encountered → Discovery → Explanation → Application
**Example:** "TIL: CSS :has() Selector Can Replace JavaScript"

### Comparison
**Structure:** Options → Criteria → Analysis → Recommendation
**Example:** "React vs Vue vs Svelte in 2026: Which to Choose?"

### Case Study
**Structure:** Challenge → Approach → Implementation → Results → Lessons
**Example:** "Scaling to 1M Users: Our Infrastructure Journey"

## Examples

### Example 1: Topic-Based

```bash
/write-blog "TypeScript migration experience"

Orchestrator:
1. Loads blog-writer skill
2. Asks clarifying questions:
   - What type? → Case Study
   - Audience? → Intermediate developers
   - Key points? → Type safety benefits, migration challenges, team buy-in
3. Structures with Story Circle
4. Generates draft → ./blog/typescript-migration-experience.md
5. Applies SEO optimization

Output:
  ✓ Blog post written to ./blog/typescript-migration-experience.md
  ✓ 2,400 words, 12 min read
  ✓ SEO score: 9/10
  ✓ Code examples: 6
```

### Example 2: Brain Dump

```bash
/write-blog "ok so we switched from rest to graphql and honestly it was harder than expected. the tooling is great but the learning curve for the team was steep. some people loved it, others missed the simplicity of rest. would i do it again? maybe, depends on the project size..."

Orchestrator:
1. Analyzes brain dump
2. Identifies: Opinion/Experience post
3. Extracts key points:
   - REST → GraphQL migration
   - Tooling vs learning curve tradeoff
   - Team divided
   - Project size matters
4. Structures as Opinion piece
5. Generates polished post

Output: Cohesive blog post with clear arguments and practical advice
```

### Example 3: Interactive Mode

```bash
/write-blog

> What topic would you like to write about?
"Building resilient microservices"

> What type of post?
Tutorial

> Target audience?
Advanced developers

> Any specific points to cover?
- Circuit breakers
- Retry strategies
- Observability
- Testing strategies

[Generates comprehensive tutorial]
```

## Output Format

```markdown
# {Compelling Headline}

{Hook paragraph - Story Circle: You}

## The Problem

{Description of what readers face - Story Circle: Need}

## Why This Matters

{Context and motivation - Story Circle: Go}

## Exploring Solutions

{Alternative approaches - Story Circle: Search}

## The Approach

{Your solution - Story Circle: Find}

## Implementation

{Step-by-step details with code - Story Circle: Take}

### Step 1: ...
### Step 2: ...

## Results

{What you achieved - Story Circle: Return}

## Lessons Learned

{Insights and takeaways - Story Circle: Change}

## Conclusion

{Summary and call-to-action}
```

## Customization Options

Ask user:
- **Output path:** Where to save the post?
- **Include images:** Should we generate image placeholders?
- **Code review:** Run docs-architect for technical review?
- **SEO focus:** Prioritize SEO or readability?
- **Length:** Short (800-1200), Medium (1500-2500), Long (3000+) words?

## Integration Tips

**After writing:**
```bash
# Review for quality
cc "Review ./blog/my-post.md for technical accuracy"

# Generate social media snippets
cc "Create Twitter thread from ./blog/my-post.md"

# Create cover image prompt
cc "Generate a Midjourney prompt for cover image based on ./blog/my-post.md"
```

**Workflow integration:**
```bash
# Write → Review → Publish pipeline
/write-blog "My topic"
# Review in editor
git add blog/my-post.md
git commit -m "feat(blog): add post about X"
git push
```

## Tips for Better Results

1. **Be specific about audience** - Changes tone and depth
2. **Provide code examples** - Include in brain dump if you have them
3. **Mention real experiences** - Authenticity resonates
4. **Include numbers** - Metrics make content concrete
5. **Reference prior art** - Link to related posts/docs

## Error Handling

| Issue | Solution |
|-------|----------|
| Topic too broad | Ask for narrower scope or specific angle |
| Missing technical depth | Request code examples or documentation |
| Unclear audience | Ask explicitly (beginner/intermediate/advanced) |
| Output path exists | Confirm overwrite or suggest new name |

## See Also

- [blog-writer skill](../skills/blog-writer/SKILL.md) - Core writing skill
- [Story Circle framework](../skills/blog-writer/references/story-circle.md)
- [SEO checklist](../skills/blog-writer/references/seo-checklist.md)
- [Post templates](../skills/blog-writer/references/post-templates.md)
