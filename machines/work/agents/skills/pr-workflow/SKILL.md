---
name: pr-workflow
description: Source of truth for Evan's commit and pull request workflow. Use this skill for any commit, amend, push, PR task, or fast-tracking a change for quick review.
---

## Git & Pull Request Workflow

Evan has a specific git workflow optimized for speed. Understand this before making commits or PRs.

### Which workflow applies

Check `git remote get-url origin` first. Note Evan uses git URL aliases: `gh:<owner>/<repo>` expands to a GitHub repo, and `me:<repo>` is shorthand where the owner is himself (`evanpurkhiser`).

- **Owner `evanpurkhiser`** -- personal project. Commit directly to main and push to `origin main`. No branches, no PRs. You may run `git push` yourself.
- **Owner `getsentry`** -- work project. The PR workflow below applies. Do not run `git push` directly; `pt pr-create` and `pt pr-update` handle pushing.
- **Any other owner** -- likely a fork. Ask before pushing: you'll probably need a new remote (e.g. `evan`) pointing at Evan's fork so commits can land there rather than on the upstream.

### Core principles

1. **No branches.** All commits are made directly on main. Branches are only created at push-time for PRs.
2. **One commit = one PR.** Each commit is a self-contained, reviewable change. No WIP commits -- the commit *is* the PR.
3. **Optimize for reviewability.** Small, focused changes with no unrelated work mixed in. The easier it is to review, the faster it lands.
4. **Parallel review.** Multiple independent PRs can be open simultaneously. Dependent changes are simply committed later on main.

Commits pile up on local `main` ahead of `origin/main`, with hunks carefully staged per commit. Use regular `git add` when changes are already cleanly separated. Use `git-surgeon` when unstaged changes are intermixed and you need hunk/line-level selection (`git-surgeon hunks` to list, `git-surgeon show <id>` to inspect, `git-surgeon stage <id>` / `git-surgeon commit <id> -m "..."` to act; see the `git-surgeon` skill for full docs). Each commit becomes its own PR.

### Opening a PR: `pt pr-create`

To open a PR for a commit, use `pt pr-create` (from [`@evanpurkhiser/tooling-personal`](https://www.npmjs.com/package/@evanpurkhiser/tooling-personal), source at `~/Coding/personal/tooling-personal`). It's non-interactive -- agent-safe. The tool auto-derives the PR branch name from the commit subject; that branch name is how `pt pr-update` later finds the existing PR.

```bash
pt pr-create <sha> --title "..." [--reviewer a,b,c] [--draft] [--auto-merge] [--no-open] < body.md
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
  **Do not hard-wrap paragraphs in the body.** PR bodies render as GitHub Markdown -- a hard wrap mid-paragraph turns the prose into ragged lines on the rendered page. Write each paragraph as one long line and let GitHub wrap it. Hard line breaks are only appropriate inside fenced code blocks (where wrapping would change the code) and between separate paragraphs / list items. This differs from commit bodies, which *should* be wrapped at 80.
- `--reviewer`: comma-separated GitHub logins / `org/team` slugs. **Unknown slug = hard fail** (exits before pushing). Get candidates with `pt suggest-assignees` rather than guessing.
- prints the PR URL on stdout (progress goes to stderr)

Under the hood it cherry-picks `<sha>` onto `origin/main` via `git merge-tree` + `git commit-tree` plumbing (no rebase, no working tree changes), force-pushes the new commit to the generated branch, then creates the PR via GraphQL. If a PR already exists for the generated branch, `pr-create` errors -- use `pt pr-update` instead.

### Updating an existing PR: `pt pr-update`

Once a PR is open, use `pt pr-update <sha>` to push an amended commit to its existing branch. It takes only the SHA -- no title, body, reviewer, or draft flags. To change any of those on an open PR, use `gh pr edit` (see the metadata section below).

```bash
pt pr-update <sha>
```

Errors if no PR exists for the generated branch (use `pt pr-create` to open one). Otherwise cherry-picks, force-pushes to the branch, and prints the PR URL.

#### Folding new changes into the commit

To fold new changes into the commit before re-pushing, use `git-surgeon`:

```bash
# Stage only the hunks that belong to the fix (skip if changes are already separated)
git-surgeon stage <hunk-id>...

# Fold staged changes into the target commit (amend for HEAD, autosquash rebase for older commits)
git-surgeon amend <sha>

# Or fold one or more existing commits into a target commit
git-surgeon fixup <target-sha> --from <sha>
```

- `git-surgeon amend <sha>` is preferred when the fix lives as staged hunks.
- `git-surgeon fixup <target-sha> --from <sha>` is preferred when the fix already exists as a separate commit.
- If using raw git, keep the same rule: `git commit --fixup=<sha>` immediately followed by `git rebase --autosquash <base>`.

**Never change the commit subject once a PR is open** -- not via rebase-reword, not via `git commit --amend -m`, not any other way. The PR branch name is derived from the subject, so any change orphans the existing PR and the next `pt pr-create` opens a new one. The commit *body* is safe to edit (it doesn't affect the branch name); if only the PR title needs to change, edit it on GitHub directly.

#### Worked example: amend then `pr-update`

```bash
# 1. List unstaged hunks, pick the one(s) that belong to the fix
git-surgeon hunks

# 2. Capture the subject before amending -- it's preserved across the rewrite
#    and is what we'll use to find the new sha.
subject=$(git log -1 --format=%s abc1234)

# 3. Fold the staged hunks into the original commit (autosquash under the hood)
git-surgeon amend abc1234

# 4. Look the rewritten commit up by its (unchanged) subject. Don't use
#    `git log -1 --format=%H` -- if the amended commit isn't HEAD, that
#    gives you the tip of your stack rather than the rewritten commit.
new_sha=$(git log origin/main..HEAD --format='%H %s' \
  | grep -F "$subject" | head -1 | cut -d' ' -f1)

# 5. Push the amended commit to the existing PR. The PR branch name is
#    derived from the unchanged subject, so pr-update finds the existing PR.
pt pr-update "$new_sha"
```

### Picking reviewers: `pt suggest-assignees`

Run this before `pt pr-create` to pick reviewers based on blame ownership.

```bash
pt suggest-assignees [--commit <sha>] [--limit N] [--format slugs|json] [--hunkWeight 0..1]
```

Looks at the current diff (staged, unstaged, or `--commit <sha>`), blames each touched file at the pre-change revision, and ranks GitHub logins by a weighted combination of hunk-level and whole-file line ownership. Default format is `slugs` (comma-separated, pipeable directly into `pt pr-create --reviewer`).

Assignable users are cached at `$XDG_CACHE_HOME/pt/`; pass `--refresh` to invalidate if someone new joined the org.

### Resolving a full name to a GitHub login

When you have a person's full name but need their GitHub login (for `--reviewer`, `--assignee`, etc.):

```bash
gh api graphql --paginate -f query='query($endCursor: String) {
  organization(login: "getsentry") {
    membersWithRole(first: 100, after: $endCursor) {
      nodes { login name }
      pageInfo { hasNextPage endCursor }
    }
  }
}' --jq '.data.organization.membersWithRole.nodes[] | select(.name != null) | "\(.name) -> \(.login)"' \
  | grep -i "<name>"
```

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

### Examples

**Title only, no body, no reviewers:**

```bash
pt pr-create abc1234 --title "Fix off-by-one in pagination cursor" < /dev/null
```

**Title and body via heredoc:**

```bash
pt pr-create abc1234 --title "Fix off-by-one in pagination cursor" <<'EOF'
The cursor was advancing by `limit` instead of `limit + 1`, causing the last item of each page to be returned again as the first item of the next page.
EOF
```

**Title, body, and the top-3 suggested reviewers:**

```bash
reviewers=$(pt suggest-assignees --commit abc1234 --limit 3)
pt pr-create abc1234 --title "Fix off-by-one in pagination cursor" --reviewer "$reviewers" <<'EOF'
The cursor was advancing by `limit` instead of `limit + 1`, causing the last item of each page to be returned again as the first item of the next page.
EOF
```

### Editing PR metadata: `gh pr edit`

`pt pr-create` pushes the commit, which re-triggers CI. For changes that don't touch the code, prefer `gh` directly -- it hits the GitHub API without disturbing the branch.

Use `gh` for:

- **Editing PR title or body**: `gh pr edit <num> --title "..." --body "..."` (or `--body-file -` with a heredoc). Use this to fix up a Linear link or typo in the description without a force-push.
- **Enabling auto-merge**: `gh pr merge <num> --auto --squash`.
- **Adding/removing reviewers on an existing PR**: `gh pr edit <num> --add-reviewer foo --remove-reviewer bar` (recall that `pt pr-create` ignores `--reviewer` on updates).
- **Labels, milestones, assignees, projects**: all available via `gh pr edit` subflags.
- **Marking ready-for-review / draft**: `gh pr ready <num>` / `gh pr ready <num> --undo`.
- **Reading PR state**: `gh pr view <num>`, `gh pr checks <num>`, `gh api repos/OWNER/REPO/pulls/<num>/comments`.

The only things you should *not* do with `gh` on a Sentry PR: create the PR (`gh pr create`) and push the branch (`gh pr sync`, `git push`). Those go through `pt pr-create` / `pt pr-update` so the branch-naming and cherry-pick plumbing stay consistent.

### Implications for agents

- **Do not create branches.** Commit directly to main.
- **Keep commits atomic** -- one logical change per commit, no unrelated fixups mixed in. Use `git-surgeon` only when necessary to split intermixed unstaged changes by hunk or line range.
- Commit messages matter -- they become the PR title/body.
- Do not run `git push` or `gh pr create` directly -- use `pt pr-create` to open and `pt pr-update` to re-push. But `gh pr edit`, `gh pr merge --auto`, etc. are fine (and preferred) for metadata-only changes that shouldn't re-push the branch.
- There's also an interactive `pt pr` that Evan runs himself (fzf + `$EDITOR`); don't invoke it from an agent.

## After opening the PR: watch CI

As soon as `pt pr-create` (or the fast-track flow) returns a PR URL, start a background watch on its CI checks. Don't block on it -- background it so you can keep working, and Evan doesn't have to chase failures himself.

Use the Bash tool with `run_in_background: true`:

```bash
gh pr checks <num> --watch --fail-fast
```

`--watch` polls until all checks finish; `--fail-fast` exits non-zero the moment one fails. The completion notification arrives back as a tool result.

### Verifying CI state -- don't trust the watch exit code alone

**`gh pr checks --watch --fail-fast` exit-0 is NOT a green signal.** The watch can exit before all checks register: if it polls during a quiet window between batches, or if a new check enters the queue after the initial set completes, the watch will exit 0 while real failures are still landing. This has burned us repeatedly. Never tell Evan a PR is green based on the exit code alone.

The authoritative ground truth is the status check rollup:

```bash
# Quick one-line state: counts of each conclusion bucket
gh pr view <num> --json statusCheckRollup \
  -q '[.statusCheckRollup[] | .conclusion // "PENDING"] | group_by(.) | map({(.[0]): length}) | add'

# Names of any failing checks
gh pr view <num> --json statusCheckRollup \
  -q '.statusCheckRollup[] | select(.conclusion == "FAILURE") | {name, detailsUrl}'
```

If `FAILURE` shows up in the rollup, CI is not green -- full stop. `PENDING` means still running; re-check later. `SUCCESS` / `NEUTRAL` / `SKIPPED` are the only acceptable terminal states.

When the watch notification arrives, do *both* of these before reporting status to Evan:

1. **Grep the watch output for `fail`** (the textual rows include a `fail` column for failed checks). If you see it, CI is red.
2. **Re-query the rollup** with the command above. This catches the case where checks landed after the watch exited.

Only say "green" when the rollup has zero `FAILURE` entries *and* no `PENDING` rows remain. If anything is still `PENDING`, say so explicitly ("X checks still running") rather than calling it done.

### When CI is failing

Diagnose first, then decide whether to fix unattended or wait:

1. Identify the failing job: `gh pr checks <num>` shows status; `gh run view <run-id> --log-failed` pulls just the failed step output. For job ID inside a multi-job workflow, use the `detailsUrl` from the rollup query above.
2. Reproduce locally if practical, then form a fix.
3. **Gate on complexity.** Trivial fixes (typo, missing import, obvious lint, clearly-flaky retry) -- proceed. Anything non-trivial -- a logic change, a refactor to satisfy types, a fix that touches code beyond the failing area, or any case where you're not confident the fix is right -- stop and surface the diagnosis to Evan with a proposed fix, and wait for approval before pushing.
4. Fold the fix into the original commit with `git-surgeon amend <sha>` (see the worked example under `pt pr-update` above -- subject must stay unchanged so the PR branch name matches).
5. Re-push with `pt pr-update <new-sha>`.
6. Re-arm the watch on the new run (same `gh pr checks <num> --watch --fail-fast`, backgrounded again).

If a failure is clearly infrastructure flake (timeout, runner died, unrelated service 500), it's fine to retry the job via `gh run rerun <run-id> --failed` instead of pushing a fix -- but only when the failure is unambiguously not the PR's fault. Some checks (notably `Snapshot Testing`) are review-gated and may show `FAILURE` until a human approves them -- those are not real CI failures; call them out separately rather than counting them against the PR.

## Fast-Track Workflow

Fast-tracking is for small, high-confidence changes that need quick eyes and a fast merge. It combines PR creation with auto-merge, an explicit assignee, and a Slack notification in one flow.

### When to use

Evan will say something like:
- "fast track this to scott cooper, DM him"
- "fast track this to design engineering, post in their channel"

### Required inputs

You must have both of these before starting:
- **Assignee**: the specific person to assign and notify -- Evan will always name them explicitly. Only use `pt suggest-assignees` if Evan explicitly says to figure out who's most appropriate.
- **Notification target**: either a DM to that person, or a named Slack channel

If either is missing, ask before proceeding.

### Steps

1. **Commit** if one hasn't been made yet -- follow the standard commit flow from above.

2. **Resolve the GitHub login** from the person's full name using the GraphQL query in "Resolving a full name to a GitHub login" above. If you have the ability to run background tasks or sub-agents, kick this off before committing so the lookup runs while you prepare everything else.

3. **Create the PR** with the resolved login as reviewer and auto-merge enabled:
   ```bash
   pt pr-create <sha> --title "..." --reviewer <login> -m < body.md
   ```

4. **Post to Slack** using the Slack MCP tools:
   - **DM**: use `slack_search_users` to find the user's ID, then `slack_send_message` with that ID as the channel.
   - **Channel**: use `slack_search_channels` to find the channel ID, then `slack_send_message`.

### Slack message format

One line -- the PR link followed by a brief description. No @mentions, no preamble, no sign-off:

```
<PR URL> fixes <brief description — one clause, lowercase>
```

The description should come from the PR title or commit subject. If a Linear issue is linked, prefer its title as it tends to read more naturally.

Example:
```
https://github.com/getsentry/sentry/pull/12345 fixes null pointer when loading empty dashboards
```

For a DM, a brief lead-in is fine ("hey, mind taking a look?") but keep it short.
