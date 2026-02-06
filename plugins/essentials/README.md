# Essentials Plugin

Core workflow tools for daily development - commits, research, deep thinking, PRs, and discipline enforcement.

## Installation

```bash
/plugin marketplace add kriscard/kriscard-claude-plugins
/plugin install essentials@kriscard
```

## What's Included

### Skills

#### using-superpowers

Discipline enforcement skill that ensures you check for applicable skills before any action.

**Key principle:** If there's even a 1% chance a skill applies, you must use it.

### Commands

| Command | Description |
|---------|-------------|
| `/commit` | Create semantic git commits with conventional format |
| `/spec` | Quick spec from ticket/prompt (1-2 questions) |
| `/deep-spec` | Thorough spec with 4 rounds of interviews |
| `/issue` | Analyze ticket, implement fix on dedicated branch |
| `/pr` | Quick PR creation with structured template |
| `/init-ultrathink` | Generate comprehensive CLAUDE.md for a project |
| `/ultrathink` | Deep thinking mode for complex problems |
| `/de-slopify` | Remove AI-generated code slop from your branch |
| `/search-web` | Web search integration |

### Agents

| Agent | Description |
|-------|-------------|
| `git-committer` | Semantic commits with pre-commit hook handling |
| `researcher` | Research docs, APIs, frameworks, best practices |
| `context-manager` | Manage context across agents and long-running tasks |
| `code-simplifier` | Refactor code without changing behavior |

## Usage Examples

### Semantic Commits
```
/commit
```
Analyzes changes, creates semantic commit message following conventional commits.

### Deep Thinking
```
/ultrathink Design a plugin architecture for this application
```
Engages deep thinking mode for complex problems requiring excellence.

### Remove AI Slop
```
/de-slopify main
```
Compares your branch against main and removes AI-generated code patterns.

### Quick PR
```
/pr
```
Creates a pull request with structured summary, motivation, and notes.

## Philosophy

- **Proactive Intelligence** - Agents activate automatically when needed
- **Discipline First** - using-superpowers ensures skills are always checked
- **Excellence-Driven** - ultrathink mode encourages craftsmanship
- **Context Preservation** - context-manager maintains coherence across sessions
