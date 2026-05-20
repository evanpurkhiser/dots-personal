---
name: fork-claude
description: Fork off a new Claude Code instance in a tmux pane or window, pre-seeded with a self-contained task description so it starts working immediately. Use when Evan says things like "fork off a new claude to work on X", "fork a claude in a new pane to do Y", "spin up another claude to handle Z", or "new claude in a new window for ...".
---

## What this skill does

Spawns a fresh `claude` interactive session in a new tmux pane or window with
its first user message already populated from a seed prompt you compose
inline. The new Claude has zero memory of this conversation -- everything it
needs must be in the seed.

This is for handing off independent work to run in parallel, not for
delegating a sub-task you need the answer to. (For that, use the `Agent` tool.)

## Preflight: must be inside tmux

Check `$TMUX` is set. If not, stop and tell Evan -- this skill is tmux-only.

## Step 1: pick the destination from Evan's wording

| Evan says | tmux command |
|---|---|
| "new window" | `tmux new-window -c "<cwd>"` |
| "new pane below" / "pane below" / "horizontal split" / "split down" | `tmux split-window -v -c "<cwd>"` |
| "new pane to the right" / "split right" / "new pane" (unqualified) / unclear | `tmux split-window -h -c "<cwd>"` |

Default to a vertical split on the right (`split-window -h`) when wording is
ambiguous. Don't ask -- auto-mode.

`<cwd>` should be the directory the new Claude should start in -- usually the
current working directory of the invoking agent.

## Step 2: compose the seed prompt

**Brief the new Claude like a smart colleague who just walked in.** It has no
memory of this conversation, doesn't know what you've tried, doesn't know
which files matter. Terse command-style prompts produce shallow, generic work
-- give it enough context to make judgment calls, not just follow narrow
instructions.

Sections the seed should usually include:

1. **What and why** -- one or two sentences stating the task and motivation.
   Lead with this so the new Claude knows the goal before the details.
2. **Evidence / context** -- file paths with line numbers, Datadog metrics,
   prior PR links, log excerpts, command output. Anything that would have
   informed your own approach if you were doing the work.
3. **What to do vs. what to keep** -- for removals/refactors, name what
   stays. For features, name the surrounding code to integrate with.
4. **Workflow steering** -- which skills to use (`commit`, `pr-workflow`,
   `dotfile-management`, `git-surgeon`, etc.), repo conventions, whether to
   open a PR.
5. **Don'ts** -- scope discipline. "Don't bundle unrelated cleanup."
   "Don't touch X, it's load-bearing." "Don't add AI co-author lines."

## Step 3: launch claude with the seed inline

No temp files. Build the prompt in a single bash command using a heredoc into
a variable, then shell-quote it with `printf '%q'` so tmux can pass it safely
to the new pane's shell:

```bash
PROMPT=$(cat <<'PROMPT_EOF'
... full seed content goes here ...
... multi-line markdown is fine ...
PROMPT_EOF
)
tmux split-window -h -c "<cwd>" "claude $(printf '%q' "$PROMPT")"
```

The `<<'PROMPT_EOF'` (quoted heredoc) prevents the parent shell from expanding
`$variables` or `$(commands)` inside the prompt -- the content goes in
verbatim. `printf '%q'` then shell-escapes it into one safe argument, which
tmux forwards to the new pane where `claude` receives it as its first user
message.

For the other destinations, swap the first line:

```bash
# new window
tmux new-window -c "<cwd>" "claude $(printf '%q' "$PROMPT")"

# pane below
tmux split-window -v -c "<cwd>" "claude $(printf '%q' "$PROMPT")"
```

Run the whole thing as one Bash tool call -- variables don't persist across
calls.

## Full worked example

Evan: "fork off a new claude in a pane below to remove the dead
`OrganizationConfigRepositoriesEndpoint` -- Datadog shows no traffic."

```bash
PROMPT=$(cat <<'PROMPT_EOF'
Remove the `OrganizationConfigRepositoriesEndpoint` from Sentry. Dead code
from the pre-auto-sync era.

## Why it's safe
Datadog `sentry.view.response{url_name:sentry-api-0-organization-config-repositories}`
over 30d: 3 total requests, 2 rejected. No real traffic. Frontend uses
`OrganizationConfigIntegrationsEndpoint` instead.

## Remove
- `src/sentry/api/endpoints/organization_config_repositories.py`
- URL registration in `src/sentry/api/urls.py`
- `tests/sentry/api/endpoints/test_organization_config_repositories*`
- Anything else `rg -n OrganizationConfigRepositoriesEndpoint` turns up

## Workflow
Sentry repo -- use the `pr-workflow` skill. Commit directly to master, open
PR with `pt pr-create`. Use the `commit` skill for the message.

## Don't
- Don't remove `OrganizationRepositoriesEndpoint` (no `Config`) -- still used.
- Don't bundle other cleanups.
- No AI co-author lines.
PROMPT_EOF
)
tmux split-window -v -c "/Users/evan/Coding/sentry" \
  "claude $(printf '%q' "$PROMPT")"
```

## After launching

Tell Evan briefly which destination you used, e.g.:

> Forked a new Claude in a pane below.

## Don'ts

- **Don't write the seed to a tempfile.** Heredoc + `printf '%q'` keeps it
  inline -- nothing to clean up, nothing to stale.
- **Don't try to capture the parent conversation transcript** into the seed.
  Curate the relevant facts yourself; a smart hand-off beats a context dump.
- **Don't `exec` claude in the current pane** -- this skill is for *forking*,
  not switching. The invoking Claude keeps running.
- **Don't use `tmux send-keys`** to type the prompt into a new shell. The
  `claude "<prompt>"` argument form is the contract; send-keys has timing
  issues and races with claude's startup.
- **Don't use an unquoted heredoc** (`<<PROMPT_EOF` instead of
  `<<'PROMPT_EOF'`). An unquoted heredoc lets the parent shell expand `$vars`
  and `$(cmds)` in the seed content -- you'll silently lose `$ARGUMENTS`,
  shell vars, command substitutions, etc.
