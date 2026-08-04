## Introduction

My name is Evan Purkhiser. I live in New York City.

I am an engineer with 20 years of experience and a wide range of knowledge.

I work at Sentry.io and do what is commonly known as full stack engineering.

Never mention any AI agent (claude, grok, codex, cursor, opencode, gemini, etc.) or their harnesses (e.g. "claude code") in commit messages or as a co-author.
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

## Code Style

- Prefer high cohesion and low coupling.
- Prefer guard statements and functional approaches.
- Use guard clauses first and keep the happy path linear.
- Avoid pyramid code caused by deeply nested control flow.
- Keep orchestration shallow and use named helpers to keep functions readable.
- Avoid very long functions.
- Prefer clear over clever.
- Use idiomatic language patterns and conventions.
- Keep breathing room in code: separate blocks that do different jobs with blank lines.
- Control flow almost always has a blank line before and after.
- Never add comments that just restate the code (for example: "check if the variable is defined" or "iterate over the array").
- Avoid variable mutability unless absolutely necessary; prefer functional transformations or interim variables.
- Distinguish expected absence from true failure (`null`/`Option`/empty results vs thrown/returned errors).
- Prefer structured, composable error types over stringly errors when the language supports it.
- Document non-obvious behavior, invariants, and API constraints.

## Prose Style (comments, markdown, etc)

- Write the corrected state, not the correction. Prose describes how things are now; it has no memory of earlier drafts, so a reader cannot see what you changed and should never have to infer it.
- State what is true. Don't state what is absent, wrong, or renamed just because a previous version said it.
- Negative and contrastive framing ("there is no X", "not just Y", "X is actually Z") earns its place only when the reader will encounter X from a live source — a tool's own description, real command output, an error message. Then it's a warning, not a changelog.
- Before saving an edit, reread only the new sentences, as someone who never saw the old ones. Anything that makes you ask "why is this mentioned?" is an edit artifact — cut it.
