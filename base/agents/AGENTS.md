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
- PR bodies should lead with why the change is needed and include only the
  implementation context that helps reviewers understand it. Keep the structure
  proportional to the change. Omit testing and verification sections unless a
  repository template requires them or the change has a specific verification
  concern reviewers need to understand.
- Wrap commit body lines at 80 characters.
- For commit shaping tasks (split commits, hunk/line-range staging, selective unstaging, fixups), use `git-surgeon` instead of raw interactive or reset-based git flows.
- Before committing, review the complete staged diff as a unit for scope,
  cohesion, unrelated changes, and accidental artifacts.

## Working Style

- Before introducing a helper, prop, hook, component, dependency, or
  abstraction, inspect neighboring code and analogous repositories for an
  existing owner or established pattern that can be extended.
- Keep each change centered on one concern. Put worthwhile cleanup into
  separate cohesive commits or PRs when it can be reviewed and landed
  independently.
- Keep implementations proportional to present requirements. Introduce
  generalized machinery only when supported by a concrete need or evidence.
- If implementation reveals a materially larger architectural, protocol, or
  scope decision than the request implied, pause and review the design before
  proceeding.

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
- Put behavior in the layer that owns the underlying concern. Interfaces should
  express caller intent in domain terms while the owner decides how that intent
  is implemented.
- Preserve precise types end to end. Validate untrusted input at boundaries,
  and treat casts, `unknown` gaps, and repeated property checks as signs that
  type information may have been lost.
- Make invalid state combinations unrepresentable. Prefer an enum or
  discriminated union when interacting booleans encode three or more meaningful
  states.
- Prefer semantic HTML, accessibility, and native browser or CSS behavior over
  recreating platform behavior in JavaScript.

## Testing

- Bug fixes should normally include a focused regression test at the layer that
  owns the behavior.
- Tests should describe the current behavioral contract, not the history of
  removed behavior. Removing code, output, or UI normally means removing or
  updating its tests, not adding assertions that its former artifacts are
  absent.
- Assert that something does not occur only when preventing it is itself a
  durable requirement or invariant. A negative assertion should make sense to
  a reader who has no knowledge of the removed implementation.

## Prose Style (comments, markdown, etc)

- Write the corrected state, not the correction. Prose describes how things are now; it has no memory of earlier drafts, so a reader cannot see what you changed and should never have to infer it.
- State what is true. Don't state what is absent, wrong, or renamed just because a previous version said it.
- Negative and contrastive framing ("there is no X", "not just Y", "X is actually Z") earns its place only when the reader will encounter X from a live source — a tool's own description, real command output, an error message. Then it's a warning, not a changelog.
- Before saving an edit, reread only the new sentences, as someone who never saw the old ones. Anything that makes you ask "why is this mentioned?" is an edit artifact — cut it.
- Keep instructions and operational documentation concise and durable. Prefer
  stable invariants and short examples over mechanics evident from the code or
  facts likely to become stale.
