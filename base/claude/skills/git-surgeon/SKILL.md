---
name: git-surgeon
description: Use git-surgeon for hunk-level staging, atomic commits, and history surgery in Evan's commit and PR workflow.
---

# Git Surgeon

Use `git-surgeon` whenever you need precise, non-interactive commit shaping.

## When to use

- Commit only part of a file
- Split mixed changes into separate commits
- Stage or unstage exact line ranges
- Fold a follow-up change into an earlier commit
- Reorder or split existing commits

## Core workflow

1. Inspect hunks: `git-surgeon hunks`
2. Inspect one hunk with line numbers: `git-surgeon show <hunk-id>`
3. Commit selected hunks directly: `git-surgeon commit <hunk-id>... -m "<subject>"`
4. Use line ranges when needed: `git-surgeon commit <hunk-id>:1-12 -m "<subject>"`

Prefer `git-surgeon commit` over `git add` + `git commit` when changes are mixed.

## Common commands

```bash
# List unstaged hunks
git-surgeon hunks

# Stage specific hunks
git-surgeon stage <hunk-id>...

# Stage only specific lines from a hunk
git-surgeon stage <hunk-id> --lines 5-20

# Commit selected hunks in one step
git-surgeon commit <hunk-id>... -m "add pagination"

# Fold fix commit(s) into an earlier commit
git-surgeon fixup <target-sha> [--from <sha>...]

# Amend staged changes into an earlier commit
git-surgeon amend <target-sha>

# Split one commit into focused commits
git-surgeon split <sha> --pick <hunk-id>... -m "subject" --rest-message "subject"
```

## Guardrails

- Keep commits atomic: one logical change per commit
- Do not create branches for normal commit flow; commit on `main`
- Do not use interactive staging (`git add -p`) from agents
- Do not discard hunks (`git-surgeon discard`) unless explicitly requested
- If this repo also uses `pr-workflow`, follow that skill as the source of truth for PR creation and push behavior
