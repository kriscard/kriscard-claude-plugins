# Content Plugin

Complete content creation toolkit for technical writers and speakers.

## Orchestration

### /write-blog (Command)

Transform rough ideas or brain dumps into polished, SEO-optimized technical blog posts.

**Usage:**
```bash
# From topic
/write-blog "Migrating from npm to pnpm"

# From brain dump
/write-blog "ok so we switched from rest to graphql..."

# Interactive mode
/write-blog
```

**What it does:**
1. Loads blog-writer skill for writing guidelines and templates
2. Gathers requirements (topic, post type, audience, key points)
3. Applies Story Circle framework for narrative structure
4. Generates polished blog post with code examples
5. Applies SEO optimization checklist
6. Writes to `./blog/{slug}.md`

**Post types:**
- Tutorial (Problem → Solution → Implementation)
- Showcase (What → Why → How → Results)
- Opinion (Thesis → Arguments → Conclusion)
- TIL (Problem → Discovery → Application)
- Comparison (Options → Analysis → Recommendation)
- Case Study (Challenge → Approach → Results → Lessons)

### /create-talk (Command)

Create conference talk outlines and iA Presenter markdown slides from topic or outline.

**Usage:**
```bash
# From topic
/create-talk "Building Resilient Microservices"

# From outline
/create-talk "Present about GraphQL migration: why, how, lessons"

# Interactive mode
/create-talk
```

**What it does:**
1. Loads conference-talk-builder skill for Story Circle and iA Presenter syntax
2. Gathers talk requirements (topic, format, duration, audience)
3. Structures with Story Circle narrative (8 steps)
4. Generates iA Presenter markdown slides
5. Adds comprehensive speaker notes
6. Writes to `./talks/{slug}.md`

**Talk formats:**
- Lightning (5-10 min, 8-12 slides)
- Standard (20-30 min, 18-25 slides)
- Keynote (45-60 min, 30-40 slides)
- Workshop (90+ min, 40-60 slides)

**Benefits:**
- Both commands work standalone (no plugin dependencies)
- Consistent Story Circle narrative framework
- Automated SEO and presentation quality checks
- Production-ready output in one command

## Skills

### blog-writer
Transform brain dumps into polished technical blog posts with SEO optimization.

**Features:**
- Voice and tone guidance
- Story Circle narrative framework
- Post type templates (tutorial, showcase, opinion, TIL, comparison)
- SEO checklist

### doc-coauthoring
Structured workflow for co-authoring specs, proposals, and decision docs.

**Three-stage workflow:**
1. Context Gathering - Close knowledge gaps
2. Refinement - Build iteratively through brainstorm/curate/draft/edit
3. Reader Testing - Verify with fresh perspective

### conference-talk-builder
Create conference talk outlines and iA Presenter markdown slides using Story Circle.

**Process:**
1. Gather talk information
2. Structure using 8-step Story Circle
3. Generate iA Presenter slides
4. Refine based on feedback

## Usage

**Blog post:**
```
I want to write about switching from npm to pnpm.
Here's my brain dump: [scattered thoughts, code snippets, conclusions]
```

**Documentation:**
```
Help me write a technical spec for our new authentication system.
Audience: Backend team. Impact: Alignment on implementation approach.
```

**Conference talk:**
```
I want to create a talk about TypeScript migration.
30-minute slot, intermediate audience.
```

## References

Each skill includes reference files:
- `voice-tone.md` - Writing style guide
- `story-circle.md` - Narrative framework
- `post-templates.md` - Blog post structures
- `seo-checklist.md` - Pre-publish SEO checks
- `ia-presenter-syntax.md` - Slide formatting
