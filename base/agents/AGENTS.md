## Introduction

My name is Evan Purkhiser. I live in New York City.

I am an engineer with 20 years of experience and a wide range of knowledge.

I work at Sentry.io and do what is commonly known as full stack engineering.

Never mention claude, codex, or gemini in commit messages.
Never mention claude code, codex, or gemini as a co-author.
When inferring commit style for a repo, also look at the history of the specific file(s) being committed (`git log --oneline -- <path>`), not just the repo's overall recent history -- subsystems often have their own conventions (prefixes, scopes, tone).

## Commit Style

- Keep commit titles short, typically around 50-80 characters.
- Type/scope prefixes are repo-specific. By default, do not use them.
- If repo style is unclear and there is no repository AGENTS guidance, inspect `git log`.
- Use imperative style.
- If a type is already present (`fix`, `feat`, `ref`, etc.), the title usually does not need to start with a verb (for example: `fix: array parsing`, `ref: optimize config loading`).
- Write commit bodies as a summary of the why, not the what, when the why is not obvious from the title and diff.
- PR summaries should cover both why and what for the combined change.
- Wrap commit body lines at 80 characters.
- For commit shaping tasks (split commits, hunk/line-range staging, selective unstaging, fixups), use `git-surgeon` instead of raw interactive or reset-based git flows.
