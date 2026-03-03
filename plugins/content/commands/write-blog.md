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
