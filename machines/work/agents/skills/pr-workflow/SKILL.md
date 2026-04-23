---
name: pr-workflow
description: Source of truth for Evan's commit and pull request workflow. Use this skill for any commit, amend, push, or PR task.
---

# Git Commit Workflow

## Git & Pull Request Workflow

Evan has a specific git workflow optimized for speed. Understand this before making commits or PRs.

### Which workflow applies

Check `git remote get-url origin` first. Note Evan uses git URL aliases: `gh:<owner>/<repo>` expands to a GitHub repo, and `me:<repo>` is shorthand where the owner is himself (`evanpurkhiser`).

- **Owner `evanpurkhiser`** -- personal project. Commit directly to main and push to `origin main`. No branches, no PRs. You may run `git push` yourself.
- **Owner `getsentry`** -- work project. The PR workflow below applies. Do not run `git push` directly; `pt pr-create` handles pushing.
- **Any other owner** -- likely a fork. Ask before pushing: you'll probably need a new remote (e.g. `evan`) pointing at Evan's fork so commits can land there rather than on the upstream.

### Core principles

1. **No branches.** All commits are made directly on main. Branches are only created at push-time for PRs.
2. **One commit = one PR.** Each commit is a self-contained, reviewable change. No WIP commits -- the commit *is* the PR.
3. **Optimize for reviewability.** Small, focused changes with no unrelated work mixed in. The easier it is to review, the faster it lands.
4. **Parallel review.** Multiple independent PRs can be open simultaneously. Dependent changes are simply committed later on main.

Commits pile up on local `main` ahead of `origin/main`, with hunks carefully staged per commit. Use regular `git add` when changes are already cleanly separated. Use `git-surgeon` when unstaged changes are intermixed and you need hunk/line-level selection (`git-surgeon hunks` to list, `git-surgeon show <id>` to inspect, `git-surgeon stage <id>` / `git-surgeon commit <id> -m "..."` to act; see the `git-surgeon` skill for full docs). Each commit becomes its own PR.

### Opening a PR: `pt pr-create`

To open or update a PR for a commit, use `pt pr-create` (from [`@evanpurkhiser/tooling-personal`](https://www.npmjs.com/package/@evanpurkhiser/tooling-personal), source at `~/Coding/personal/tooling-personal`). It's non-interactive -- agent-safe. The tool auto-derives the PR branch name from the commit subject, which is how it identifies the PR on subsequent updates.

```bash
pt pr-create <sha> --title "..." [--reviewer a,b,c] [--draft] [--auto-merge] [--update-only] [--no-open] < body.md
```

- `<sha>`: commit SHA (full or prefix); must already exist on local `main` ahead of `origin/main`
- `--title`: PR title, required (use the commit subject)
- body is read from stdin. Use a heredoc; for an empty body pass `< /dev/null`:
  ```bash
  pt pr-create <sha> --title "..." --reviewer a,b <<'EOF'
  Motivation for this change.

  Details about the approach.
  EOF

  pt pr-create <sha> --title "..." < /dev/null
  ```
- `--reviewer`: comma-separated GitHub logins / `org/team` slugs. **Unknown slug = hard fail** (exits before pushing). Get candidates with `pt suggest-assignees` rather than guessing.
- `--update-only`: fail if no PR exists for the generated branch (don't create)
- prints the PR URL on stdout (progress goes to stderr)

Under the hood it cherry-picks `<sha>` onto `origin/main` via `git merge-tree` + `git commit-tree` plumbing (no rebase, no working tree changes), force-pushes the new commit to the generated branch, then creates/updates the PR via GraphQL. If a PR already exists for the generated branch it just re-pushes -- **`--reviewer` and `--draft` are ignored on update**; to change reviewers on an existing PR, edit it on GitHub.

### Picking reviewers: `pt suggest-assignees`

Run this before `pt pr-create` to pick reviewers based on blame ownership.

```bash
pt suggest-assignees [--commit <sha>] [--limit N] [--format slugs|json] [--hunkWeight 0..1]
```

Looks at the current diff (staged, unstaged, or `--commit <sha>`), blames each touched file at the pre-change revision, and ranks GitHub logins by a weighted combination of hunk-level and whole-file line ownership. Default format is `slugs` (comma-separated, pipeable directly into `pt pr-create --reviewer`).

Assignable users are cached at `$XDG_CACHE_HOME/pt/`; pass `--refresh` to invalidate if someone new joined the org.

### The typical agent flow

1. Make the commit locally -- use regular `git add` + `git commit` when changes are already separated; use `git-surgeon` only when unstaged changes are intermixed.
2. `reviewers=$(pt suggest-assignees --commit <sha> --limit 3)`
3. Run `pt pr-create` with the body via heredoc (or `< /dev/null` if there's no body):
   ```bash
   pt pr-create <sha> --title "<commit subject>" --reviewer "$reviewers" <<'EOF'
   <commit body>
   EOF
   ```
4. Print the returned PR URL back to Evan.

### Amending or fixing up an existing commit

To fold new changes into an earlier commit, use `git-surgeon` first:

```bash
# If changes are still unstaged, stage only what belongs to the fix
git-surgeon stage <hunk-id>...

# Fold staged changes into target commit (uses amend for HEAD, autosquash rebase for older commits)
git-surgeon amend <sha>

# Or fold one or more commits into a target commit
git-surgeon fixup <target-sha> --from <sha>
```

- `git-surgeon amend <sha>` is preferred when you've already staged the exact hunks for the fix and needed hunk-level staging.
- `git-surgeon fixup <target-sha> --from <sha>` is preferred when the fix already exists as a separate commit.
- If you use raw git instead, keep the same rule: run `git commit --fixup=<sha>` immediately followed by `git rebase --autosquash <base>`.

If the amended commit already has a PR open, re-run `pt pr-create <new-sha>` -- it detects the existing PR by the generated branch name and just re-pushes.

**Never change the commit subject once a PR is open** -- not via rebase-reword, not via `git commit --amend -m`, not any other way. The PR branch name is derived from the subject, so any change orphans the existing PR and the next `pt pr-create` opens a new one. The commit *body* is safe to edit (it doesn't affect the branch name); if only the PR title needs to change, edit it on GitHub directly.

### Implications for agents

- **Do not create branches.** Commit directly to main.
- **Keep commits atomic** -- one logical change per commit, no unrelated fixups mixed in. Use `git-surgeon` only when necessary to split intermixed unstaged changes by hunk or line range.
- Commit messages matter -- they become the PR title/body.
- Do not run `git push` or `gh pr create` directly -- use `pt pr-create`.
- There's also an interactive `pt pr` that Evan runs himself (fzf + `$EDITOR`); don't invoke it from an agent.
