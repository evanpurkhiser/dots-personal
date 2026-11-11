You're running on my personal home server. We're primarily working on personal infrastructure, services, media automation, and dotfiles operations.

All Evan repositories on this machine are checked out in `~/workspace`.

## Development services

`prk.network` is Evan's internal tailnet domain.

Bind HTTP development servers to `127.0.0.1` on ports 3000–19999. They are
available within the tailnet at `https://<port>.prk.network`, with TLS terminated
by nginx; for example, port 5173 is `https://5173.prk.network`.

## Long-running processes

Run any process expected to outlive the current command as a transient systemd
user service:

```bash
systemd-run --user --collect --unit="codex-<purpose>-<unique-id>" \
  --description="Codex: <purpose>" --working-directory="$PWD" \
  --property=LogExtraFields=CODEX_ORIGIN=codex \
  --property=RuntimeMaxSec=<duration> <command> <args...>
```

Use a finite runtime when practical and stop the unit when finished. Processes
intended to run indefinitely belong in managed persistent units instead.

## Committing and Pushing

Create local commits with `git -c commit.gpgSign=false commit` (including amendments
and fixups). Only pushes to a branch named `main` require signed commits. Other
pushes, including branches intended for PRs, leave commits unsigned.

Git automatically rewrites GitHub remotes to HTTPS and authenticates with
`gh auth git-credential`. Run fetches and pushes directly; do not wrap them
with `ssh-agent-ctx`.

Before pushing directly to `main`, run `git sign-stack [base]` (defaults to
`origin/HEAD`) through `ssh-agent-ctx` to sign your outgoing unpublished commits.
The pre-push hook verifies signatures for updates to `main`, matching the GitHub
ruleset.

```bash
ssh-agent-ctx "Sign the main update" -- git sign-stack
git push
```

## SSH and Sudo Authentication

Commands expected to use Evan's SSH agent must run through `ssh-agent-ctx` with
a concise reason:

```bash
ssh-agent-ctx "Deploy the nginx configuration" -- \
  ansible-playbook -i inventory play-server.yml --tags nginx
```

Unwrapped SSH-agent access fails signing because `agent-auth` requires context.
When possible, it writes this diagnostic to the command's controlling TTY:

```text
[agent-auth] Run this command with ssh-agent-ctx to use the SSH agent
```

Signing requests are routed to the MacBook Evan is using, or to the web-based
`agent-witness` on his phone, which receives a push notification. Only when
specifically asked, select a backend explicitly with
`--route=[macbook-air, macbook-work, agent-witness]`:

```bash
ssh-agent-ctx --route=macbook-work "Sign the main update" -- git sign-stack
```

Sudo uses `pam-ssh-agent` and must also be wrapped with `ssh-agent-ctx`.

## Secret Handoff

Run `secret-receive` when Evan needs to provide a secret. Share its tailnet URL,
then pass the resulting file with shell redirection or `$(cat "$file")`. Use
`--preset login`, `--preset login-2fa`, `--preset credit-card`, or repeated
`--field` arguments when structured values are needed; structured forms write a
JSON object, while the default form writes plaintext. The full field syntax is
available from `secret-receive --help`. Never read or print the resulting file.
Remove it immediately afterward.
