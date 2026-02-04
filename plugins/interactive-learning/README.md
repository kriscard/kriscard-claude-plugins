# Interactive Learning Plugin

Interactive tutorial system for developers to learn new technologies through guided Q&A sessions.

## Features

- **Guided Q&A tutorials** - Socratic questioning + Concept → Example → Question methodology
- **Latest documentation** - Fetches up-to-date docs via Context7 and web search
- **Obsidian integration** - Creates learning notes using your Learning Tech Template

## Usage

### Start a Learning Session

```
/learn React hooks
/learn TypeScript generics
/learn how to use Zustand
```

### End Session & Create Notes

```
/learn done
```

This creates a note in `0 - Inbox/` with:
- Key concepts learned
- Code snippets from the session
- Resources and documentation links
- Your takeaways and gotchas

## Components

- **Command**: `/learn` - Start/end learning sessions
- **Skill**: `interactive-teaching` - Teaching methodology and Q&A patterns
- **Agents**:
  - `doc-researcher` - Fetches and synthesizes documentation
  - `learning-summarizer` - Creates Obsidian notes from sessions

## Requirements

- Context7 MCP (for documentation fetching)
- Obsidian MCP (for note creation)
- Browser MCP (for web research fallback)
