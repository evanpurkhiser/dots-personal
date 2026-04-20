- never mention claude in commit messages
- never mention claude code as a co-author

## Git & Pull Request Workflow

Evan has a specific git workflow optimized for speed. Understand this before making commits or PRs.

### Which workflow applies

Check `git remote get-url origin` first. Note Evan uses git URL aliases: `gh:<owner>/<repo>` expands to a GitHub repo, and `me:<repo>` is shorthand where the owner is himself (`evanpurkhiser`).

- **Owner `evanpurkhiser`** — personal project. Commit directly to main and push to `origin main`. No branches, no PRs, no `pt pr`. You may run `git push` yourself.
- **Owner `getsentry`** — work project. The `pt pr` workflow below applies. Do not push.
- **Any other owner** — likely a fork. Ask before pushing: you'll probably need a new remote (e.g. `evan`) pointing at Evan's fork so commits can land there rather than on the upstream.

### Core principles

1. **No branches.** All commits are made directly on main. Branches are only created at push-time for PRs.
2. **One commit = one PR.** Each commit is a self-contained, reviewable change. No WIP commits — the commit *is* the PR.
3. **Optimize for reviewability.** Small, focused changes with no unrelated work mixed in. The easier it is to review, the faster it lands.
4. **Parallel review.** Multiple independent PRs can be open simultaneously. Dependent changes are simply committed later on main.

### How it works

- `git add -p` to carefully stage exactly the right hunks for each commit.
- Commits pile up on local main, ahead of `origin/main`.
- To open a PR: rebase the target commit to sit just ahead of `origin/main`, then push that single commit to a remote branch.
- The branch name is auto-generated from the commit message: `{username}/{kebab-case-message}`.
- PR is created via GitHub GraphQL API, reviewers are assigned, and it opens in the browser.

### The tooling: `pt pr`

Evan uses [`@evanpurkhiser/tooling-personal`](https://www.npmjs.com/package/@evanpurkhiser/tooling-personal) (invoked as `pt pr`, aliased to `git pr`). Source lives at `~/Coding/personal/tooling-personal`.

What `pt pr` does:

1. Fetches repo info and lists unpublished commits (ahead of origin)
2. Presents commits in `fzf` for selection (shows existing PR labels)
3. Rebases selected commits to the front if needed
4. Force-pushes each to a generated branch (`git push --force origin <hash>:refs/heads/<branch>`)
5. Opens `$EDITOR` for PR title/body
6. Creates or updates the PR via GitHub GraphQL API
7. Prompts for reviewer selection via `fzf`
8. Opens the new PR in the browser

Flags: `--draft` / `-d`, `--autoMerge` / `-m` (enables squash auto-merge).

If a PR already exists for the branch, it skips creation and just updates (rebase + force push).

### Implications for agents

- **Do not create branches.** Commit directly to main.
- **Keep commits atomic** — one logical change per commit, no unrelated fixups mixed in.
- **Do NOT push commits or open PRs.** The `pt pr` tool is interactive (uses fzf, $EDITOR) and cannot be run by an agent. Evan will push and open PRs himself. Do not run `git push`, `gh pr create`, or `pt pr`.
- Commit messages matter more than usual since they become the PR title/description template.
