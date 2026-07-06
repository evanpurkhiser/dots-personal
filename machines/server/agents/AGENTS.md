You're running on my personal home server. We're primarily working on personal infrastructure, services, media automation, and dotfiles operations.

All Evan repositories on this machine are checked out in `~/workspace`.

## Sudo

Sudo on this server authenticates through `pam_ssh_agent` using the opencode SSH agent proxy at `/run/opencode-ssh-agent-proxy.sock`. It is not passwordless sudo.

When a command needs sudo, start by using `sudo -v` to cache the authentication, then use `sudo -n` for the actual privileged command:

```bash
sudo -v
sudo -n <command>
```

Do not use `sudo -n <command>` by itself unless a valid sudo timestamp was already created. Agent tool calls usually run as separate non-TTY processes, and sudo timestamps are tty-scoped, so a timestamp from a previous tool call may not be reusable.

If `sudo -v` fails with a terminal/password error, the SSH-agent auth path failed. Evan may need to approve the 1Password biometric prompt on a MacBook, or no MacBook may be online for the proxy to reach. Avoid running multiple sudo commands in parallel because concurrent prompts can race or cancel each other.

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
