---
description: Create conference talk outline and iA Presenter slides from topic or outline
argument-hint: '<topic or outline>'
allowed-tools: [Skill, Read, Write, Task, Glob, Grep, AskUserQuestion]
---

# Create Talk

Transform your talk ideas or outlines into a structured conference presentation with iA Presenter markdown slides.

## Usage

```bash
# From topic
/create-talk "Building Resilient Microservices"

# From outline
/create-talk "I want to present about our GraphQL migration. Cover: why we switched, implementation challenges, lessons learned, team impact"

# Interactive (no arguments)
/create-talk
```

## What This Does

This command orchestrates the complete conference talk creation workflow by coordinating the conference-talk-builder skill.

## Orchestration Workflow

### Phase 1: Load Context

Load the `conference-talk-builder` skill to access:
- Story Circle narrative framework for presentations
- iA Presenter markdown syntax
- Slide structure templates
- Speaker notes guidelines
- Visual storytelling patterns

### Phase 2: Gather Requirements

**If user provided topic/outline in $ARGUMENTS:**
- Use provided content as starting point

**If no arguments (interactive mode):**
- Ask user:
  - What's your talk topic?
  - What's the talk format? (lightning, standard, keynote, workshop)
  - How long is the talk? (5min, 20min, 45min, 90min)
  - Who's the audience? (beginner, intermediate, advanced, mixed)
  - What's the key takeaway?
  - Do you have code examples or demos?

### Phase 3: Structure with Story Circle

Apply Story Circle framework (via conference-talk-builder skill):

1. **You** - Opening slide: Audience's current reality
2. **Need** - Problem introduction
3. **Go** - Why this matters (decision to act)
4. **Search** - Exploring solutions
5. **Find** - The breakthrough/approach
6. **Take** - Implementation details
7. **Return** - Results and impact
8. **Change** - Call to action

### Phase 4: Generate Talk Structure

Invoke `conference-talk-builder` skill to create:
- Opening hook slide
- Problem/context slides
- Solution exploration
- Live demo or code walkthrough slides
- Results and lessons learned
- Closing call-to-action
- Speaker notes for each slide

**Story Circle mapping:**
```
Slide 1-2:   You (Hook + Context)
Slide 3-4:   Need (Problem)
Slide 5:     Go (Why it matters)
Slide 6-8:   Search (Exploration)
Slide 9-10:  Find (Solution)
Slide 11-15: Take (Implementation)
Slide 16-17: Return (Results)
Slide 18:    Change (CTA)
```

### Phase 5: Format for iA Presenter

Generate markdown in iA Presenter format:

```markdown
# Slide Title

Content here

^ Speaker notes (invisible to audience)

---

# Next Slide Title

More content

^ More speaker notes
```

**Slide types:**
- Title slides: Large heading
- Content slides: Bullet points or short paragraphs
- Code slides: Syntax-highlighted code blocks
- Quote slides: Centered blockquotes
- Image slides: Image with caption

### Phase 6: Add Speaker Notes

For each slide, add comprehensive speaker notes:
- What to say (key talking points)
- Timing guidance (e.g., "Spend 2 minutes here")
- Transition cues
- Demo instructions (if applicable)
- Audience interaction prompts

### Phase 7: Deliver

Write the presentation to:
- **Default:** `./talks/{slug}.md`
- **Custom:** Path specified by user

Include metadata at top:
```markdown
---
title: "Your Talk Title"
event: "ConferenceName 2026"
date: 2026-01-11
duration: "45 min"
audience: "Intermediate developers"
tags: [tag1, tag2, tag3]
---
```

## Talk Formats

### Lightning Talk (5-10 min)
**Structure:** Hook → Problem → Solution → Demo → CTA
**Slides:** 8-12 slides
**Example:** "Hot Reloading Secrets You Didn't Know"

### Standard Talk (20-30 min)
**Structure:** Story Circle (full 8 steps)
**Slides:** 18-25 slides
**Example:** "From Monolith to Microservices: Our Journey"

### Keynote (45-60 min)
**Structure:** Extended Story Circle with multiple sub-arcs
**Slides:** 30-40 slides
**Example:** "The Future of Web Development"

### Workshop (90+ min)
**Structure:** Intro → Multiple Story Circle loops (one per module) → Wrap-up
**Slides:** 40-60 slides
**Example:** "Building Production-Ready APIs"

## Examples

### Example 1: From Topic

```bash
/create-talk "TypeScript Migration at Scale"

Orchestrator:
1. Loads conference-talk-builder skill
2. Asks clarifying questions:
   - Format? → Standard talk (30 min)
   - Audience? → Intermediate developers
   - Key takeaway? → Incremental migration strategies
   - Demos? → Yes, live refactoring demo
3. Structures with Story Circle
4. Generates 22 slides with speaker notes
5. Formats for iA Presenter

Output: ./talks/typescript-migration-at-scale.md
```

### Example 2: From Outline

```bash
/create-talk "I want to talk about our move to serverless. Cover: why we did it (cost + scale), how we migrated (incremental approach), what broke (lots), what we learned (monitoring is critical), results (60% cost reduction)"

Orchestrator:
1. Analyzes outline
2. Identifies talk type: Experience Report / Case Study
3. Extracts Story Circle elements:
   - You: Traditional server costs
   - Need: Scaling problems
   - Go: Decision to go serverless
   - Search: Incremental migration
   - Find: Monitoring approach
   - Take: Implementation
   - Return: Cost reduction results
   - Change: Recommendations
4. Generates structured presentation

Output: 20 slides with detailed speaker notes
```

### Example 3: Interactive Mode

```bash
/create-talk

> What's your talk topic?
"Building accessible React components"

> What format?
Standard talk (30 min)

> Target audience?
Frontend developers (mixed experience)

> Key takeaway?
Accessibility should be built in from the start

> Code examples or demos?
Yes, live coding accessible forms

[Generates comprehensive 25-slide presentation with demo sections]
```

## iA Presenter Features Used

### Slide Types

**Title Slide:**
```markdown
# Talk Title
## Subtitle
### Your Name | @handle
```

**Content Slide:**
```markdown
# Point to Make

- Key idea 1
- Key idea 2
- Key idea 3

^ Explain each point with examples
```

**Code Slide:**
```markdown
# Implementation

\`\`\`typescript
function accessibleButton() {
  return <button aria-label="Submit">Submit</button>
}
\`\`\`

^ Walk through the aria-label attribute
```

**Quote Slide:**
```markdown
#

> "Accessibility is not a feature, it's a fundamental"
>
> — Ethan Marcotte

^ Pause here for impact
```

**Image Slide:**
```markdown
# Architecture Overview

![System diagram](./images/architecture.png)

^ Describe each component
```

### Speaker Notes Syntax

```markdown
# Slide Title

Visible content

^ These are speaker notes
^ They appear in presenter view only
^ Use them for:
^   - Talking points
^   - Timing reminders
^   - Demo instructions
^   - Transition cues
```

## Customization Options

Ask user:
- **Output path:** Where to save the presentation?
- **Include demos:** Should we add live coding sections?
- **Image placeholders:** Generate image suggestions?
- **Handout mode:** Create printer-friendly version?
- **Slide count:** Prefer fewer/more slides?

## Integration Tips

**After creating:**
```bash
# Open in iA Presenter
open ./talks/my-talk.md

# Export to PDF (via iA Presenter)
# File → Export → PDF

# Create speaker handout
cc "Create handout from ./talks/my-talk.md"

# Generate social media promo
cc "Create Twitter thread announcing ./talks/my-talk.md"
```

**Workflow integration:**
```bash
# Create → Practice → Refine
/create-talk "My topic"
# Practice with iA Presenter
cc "Update slides 5-7 in ./talks/my-talk.md based on: [feedback]"
```

## Tips for Better Talks

1. **Start with story** - Use Story Circle to create narrative arc
2. **One idea per slide** - Don't overcrowd
3. **Visual over text** - Images, diagrams, code > paragraphs
4. **Practice out loud** - Use speaker notes
5. **Time your demos** - Leave buffer for issues
6. **End with action** - Clear call-to-action

## Talk Preparation Checklist

Generated in speaker notes:

```
^ PREPARATION CHECKLIST:
^ [ ] Test all code examples in fresh environment
^ [ ] Verify demo works (and have backup screenshots)
^ [ ] Check slides on projector (colors, font size)
^ [ ] Time the full presentation
^ [ ] Prepare for Q&A (anticipate questions)
^ [ ] Have short/long versions ready
^ [ ] Test microphone and screen sharing
^ [ ] Bring adapters and backup laptop
```

## Error Handling

| Issue | Solution |
|-------|----------|
| Topic too broad | Ask for narrower focus or key message |
| Unclear format | Suggest format based on content depth |
| Too many slides | Recommend consolidation or extended format |
| Missing demos | Offer to add code examples or suggest static alternatives |

## Output Format Example

```markdown
---
title: "Building Resilient Microservices"
event: "DevConf 2026"
date: 2026-03-15
duration: "45 min"
audience: "Advanced developers"
tags: [microservices, resilience, distributed-systems]
---

# Building Resilient Microservices
## Lessons from Production Failures
### Chris Cardoso | @yourhandle

^ INTRO (2 min)
^ - Introduce yourself
^ - Set context: "Who here runs microservices in production?"
^ - Hook: "Let me tell you about our 3am incident..."

---

# You've Built Microservices

- Services are deployed
- APIs are documented
- Tests are green
- Everything works... until it doesn't

^ STORY CIRCLE: YOU (1 min)
^ - Describe the "happy path" state
^ - This is where most teams stop
^ - Audience should recognize this state

---

# Then This Happens

![Cascade failure diagram](./images/cascade-failure.png)

^ STORY CIRCLE: NEED (2 min)
^ - Walk through cascade failure scenario
^ - One service goes down → all services fail
^ - This is the problem we need to solve

---

[... more slides following Story Circle ...]

---

# Your Next Steps

1. Start with circuit breakers
2. Add proper timeouts
3. Implement observability
4. Test failure scenarios

^ STORY CIRCLE: CHANGE (3 min)
^ - Give concrete next actions
^ - Point to resources (GitHub repo)
^ - Invite questions
^ - Thank audience

---

# Questions?

## github.com/yourhandle/resilient-services
### @yourhandle

^ Q&A (10 min)
^ - Common questions to expect:
^   - "How do you test circuit breakers?"
^   - "What timeout values do you use?"
^   - "Which library do you recommend?"
```

## Future Enhancements

- [ ] Export to PowerPoint/Keynote
- [ ] Generate speaker bio slide
- [ ] Create animated transitions
- [ ] Add slide timing estimates
- [ ] Generate rehearsal schedule

## See Also

- [conference-talk-builder skill](../skills/conference-talk-builder/SKILL.md)
- [Story Circle framework](../skills/conference-talk-builder/references/story-circle.md)
- [iA Presenter syntax guide](https://ia.net/presenter/support/general/markdown-guide)
- [Speaker tips](../skills/conference-talk-builder/references/speaker-tips.md)
