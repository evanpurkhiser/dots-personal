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
and fixups). When ready to push, run `git sign-stack [base]` (defaults to
`origin/HEAD`) to sign your outgoing unpublished commits, then push
over SSH using the same `ssh-agent-ctx --group-id` to consolidate authorization.
The pre-push hook verifies signatures before allowing the push.

```bash
release_group_id=$(uuidgen)
ssh-agent-ctx --group-id="$release_group_id" "Sign the release" -- git sign-stack
ssh-agent-ctx --group-id="$release_group_id" "Push the release" -- git push
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
ssh-agent-ctx --route=macbook-work "Push the release" -- git push
```

Use the same `--group-id` for separate invocations that belong to one operation:

```bash
ssh-agent-ctx --group-id=deploy-123 "Push the release" -- git push
```

Sudo uses `pam-ssh-agent` and must also be wrapped with `ssh-agent-ctx`.

## Secret Handoff

Run `secret-receive` when Evan needs to provide a secret. Share its tailnet URL,
then pass the resulting file with shell redirection or `$(cat "$file")`. Never
read or print the secret. Remove the file immediately afterward.

## Token-Efficient Output

**When you run a command and expect JSON, pipe to `toonify` to get token-efficient output.**

```bash
# Instead of:
gog gmail search 'is:unread' --json

# Use:
gog gmail search 'is:unread' --json | toonify
```

`toonify` converts JSON to TOON format, which uses significantly fewer tokens while preserving all data.

**Note:** If `jq` outputs JSON, pipe to `toonify`. If using `jq -r` for raw values, keep as is:

```bash
curl -s "$API/data" | jq -r '.id'
curl -s "$API/data" | jq '.items' | toonify
```
