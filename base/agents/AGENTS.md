Never mention claude, codex, or gemini in commit messages.
Never mention claude code, codex, or gemini as a co-author.
When inferring commit style for a repo, also look at the history of the specific file(s) being committed (`git log --oneline -- <path>`), not just the repo's overall recent history -- subsystems often have their own conventions (prefixes, scopes, tone).

For commit, amend, push, or pull request tasks, if the `pr-workflow` skill is available, load and follow it first.

The `pr-workflow` skill is the source of truth for commit and PR workflow rules.

Shared skills for Claude and OpenCode live under `~/.config/agents/skills`.
