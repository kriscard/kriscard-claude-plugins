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

