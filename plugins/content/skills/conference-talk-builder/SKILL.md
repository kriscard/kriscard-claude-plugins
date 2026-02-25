---
name: conference-talk-builder
disable-model-invocation: true
description: >-
  Structures conference talks and creates iA Presenter slide decks using the Story
  Circle narrative framework. Make sure to use this skill whenever the user mentions
  giving a talk, submitting a CFP, preparing for a conference, creating slides, or
  turning a topic into a presentation — even if they just say "I need to prepare a
  talk."
---

# Conference Talk Builder

Create compelling conference talk outlines and iA Presenter markdown slides using the Story Circle narrative framework.

## Process

### 1. Gather Information

Ask the user for:
- Talk title and topic
- Target audience and knowledge level
- Main points to cover
- Brain dump of everything they know
- Problem they're solving or story they're telling
- Constraints (time limit, specific technologies)

### 2. Read the Story Circle Framework

Load `references/story-circle.md` for the eight-step narrative structure.

The framework maps tech talks to:
- Top half: Established practices and order
- Bottom half: Disruption and experimentation

### 3. Create the Outline

Structure the talk using eight Story Circle steps:

1. **Introduction** - Current status quo
2. **Problem Statement** - What needs solving
3. **Exploration** - Initial attempts
4. **Experimentation** - Deep investigation
5. **Solution** - The breakthrough
6. **Challenges** - Implementation difficulties
7. **Apply Knowledge** - Integration into project
8. **Results & Insights** - Lessons learned

Map user's content to these steps. Show outline and refine based on feedback.

### 4. Generate iA Presenter Slides

Read `references/ia-presenter-syntax.md` for markdown formatting rules.

Create slides that:
- Use `---` to separate slides
- Add tabs before content visible on slides
- Leave speaker notes without tabs
- Include comments with `//` for reminders
- Format code blocks with syntax highlighting

Structure the slide deck:
- Title slide
- Introduction with speaker bio
- One or more slides per Story Circle step
- Code examples broken across multiple slides
- Closing slide with contact info and resources

### 5. Refine and Iterate

After showing slides:
- Ask if sections need expansion or compression
- Check if code examples need better formatting
- Verify story flow makes sense
- Adjust based on feedback

## Key Principles

**Tell a Story**: Focus on how you approached a problem and solved it.

**Keep It Readable**: Break code across slides. Test on bad projectors.

**Engage the Audience**: Use humor where appropriate. Ask questions.

**Make Follow-up Easy**: Include memorable URL or QR code linking to resources.

## Example Workflow

**Topic**: Migrating from JavaScript to TypeScript

1. Gather experience, main points, target audience
2. Map content to Story Circle:
   - Introduction: Current JS codebase
   - Problem: Type safety issues
   - Exploration: Research into TypeScript
   - Experimentation: Pilot conversion
   - Solution: Incremental migration strategy
   - Challenges: Third-party library types
   - Apply: Full codebase migration
   - Results: 40% reduction in runtime errors
3. Generate markdown slides with proper formatting
4. Iterate based on feedback
