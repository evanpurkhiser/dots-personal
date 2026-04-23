---
name: pr-workflow
description: Source of truth for Evan's commit and pull request workflow. Use this skill for any commit, amend, push, or PR task.
---

# Git Commit Workflow

- never mention claude in commit messages
- never mention claude code as a co-author
- when inferring commit style for a repo, also look at the history of the specific file(s) being committed (`git log --oneline -- <path>`), not just the repo's overall recent history -- subsystems often have their own conventions (prefixes, scopes, tone).

## Git & Pull Request Workflow

Evan has a specific git workflow optimized for speed. Understand this before making commits or PRs.

### Which workflow applies

Check `git remote get-url origin` first. Note Evan uses git URL aliases: `gh:<owner>/<repo>` expands to a GitHub repo, and `me:<repo>` is shorthand where the owner is himself (`evanpurkhiser`).

- **Owner `evanpurkhiser`** -- personal project. Commit directly to main and push to `origin main`. No branches, no PRs. You may run `git push` yourself.
- **Owner `getsentry`** -- work project. The PR workflow below applies. Do not run `git push`.
- **Any other owner** -- likely a fork. Ask before pushing: you'll probably need a new remote (e.g. `evan`) pointing at Evan's fork so commits can land there rather than on the upstream.

### Core principles

1. **No branches.** All commits are made directly on main. Branches are only created at push-time for PRs.
2. **One commit = one PR.** Each commit is a self-contained, reviewable change. No WIP commits -- the commit *is* the PR.
3. **Optimize for reviewability.** Small, focused changes with no unrelated work mixed in. The easier it is to review, the faster it lands.
4. **Parallel review.** Multiple independent PRs can be open simultaneously. Dependent changes are simply committed later on main.

Commits pile up on local `main` ahead of `origin/main`, with hunks carefully staged per commit. For agent-safe hunk-level staging use `git-surgeon` (`git-surgeon hunks` to list, `git-surgeon stage <id>` / `git-surgeon commit <id> -m "..."` to act; see the `git-surgeon` skill for full docs). Each commit becomes its own PR -- branch name is auto-derived from the commit subject as `{username}/{kebab-case-subject}`.

### Opening a PR: `pt pr-create`

To open or update a PR for a commit, use `pt pr-create` (from [`@evanpurkhiser/tooling-personal`](https://www.npmjs.com/package/@evanpurkhiser/tooling-personal), source at `~/Coding/personal/tooling-personal`). It's non-interactive -- agent-safe.

```bash
pt pr-create <sha> --title "..." [--reviewer a,b,c] [--draft] [--auto-merge] [--update-only] [--no-open] < body.md
```

- `<sha>`: commit SHA (full or prefix) from unpublished commits on local main
- `--title`: PR title, required (use the commit subject)
- body is read from stdin -- use the commit message minus the subject, or empty
- `--reviewer`: comma-separated GitHub logins / `org/team` slugs
- `--update-only`: fail if no PR exists for the generated branch (don't create)
- prints the PR URL on stdout (progress goes to stderr)

Under the hood it cherry-picks `<sha>` onto `origin/main` via `git merge-tree` + `git commit-tree` plumbing (no rebase, no working tree changes), force-pushes the new commit to the generated branch, then creates/updates the PR via GraphQL. If a PR already exists for the generated branch it just re-pushes.

### Picking reviewers: `pt suggest-assignees`

Run this before `pt pr-create` to pick reviewers based on blame ownership.

```bash
pt suggest-assignees [--commit <sha>] [--limit N] [--format slugs|json] [--hunkWeight 0..1]
```

Looks at the current diff (staged, unstaged, or `--commit <sha>`), blames each touched file at the pre-change revision, and ranks GitHub logins by a weighted combination of hunk-level and whole-file line ownership. Default format is `slugs` (comma-separated, pipeable directly into `pt pr-create --reviewer`).

Assignable users are cached at `$XDG_CACHE_HOME/pt/`; pass `--refresh` to invalidate if someone new joined the org.

### The typical agent flow

1. Make the commit locally -- stage hunks via `git-surgeon`, then `git commit`.
2. `reviewers=$(pt suggest-assignees --commit <sha> --limit 3)`
3. `pt pr-create <sha> --title "<commit subject>" --reviewer "$reviewers" < body.md`
4. Print the returned PR URL back to Evan.

### Amending an existing commit

To fold new changes into an earlier commit, always use `--fixup` immediately followed by autosquash:

```bash
git-surgeon stage <hunk-id> ...   # or git add <files>
git commit --fixup=<sha>
git rebase --autosquash origin/main   # or origin/master, whichever the repo uses
```

- `--fixup=<sha>` writes a commit with subject `fixup! <original subject>`.
- `git rebase --autosquash <base>` runs non-interactively and folds the fixup into its target.
- Run them back-to-back so the working tree never carries a stray `fixup!` commit.

If the amended commit already has a PR open, re-run `pt pr-create <new-sha>` -- it detects the existing PR by the generated branch name and just re-pushes.

**Never reword the commit subject once a PR is open.** The PR branch name is derived from the subject, so changing it orphans the existing PR and opens a new one. The commit body is safe to edit (it won't change the branch); if only the PR title needs to change, edit it on GitHub directly.

### Implications for agents

- **Do not create branches.** Commit directly to main.
- **Keep commits atomic** -- one logical change per commit, no unrelated fixups mixed in.
- Commit messages matter -- they become the PR title/body.
- Do not run `git push` or `gh pr create` directly -- use `pt pr-create`.
- There's also an interactive `pt pr` that Evan runs himself (fzf + `$EDITOR`); don't invoke it from an agent.
