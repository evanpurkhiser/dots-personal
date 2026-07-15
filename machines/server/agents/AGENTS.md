You're running on my personal home server. We're primarily working on personal infrastructure, services, media automation, and dotfiles operations.

All Evan repositories on this machine are checked out in `~/workspace`.

## Sudo

Sudo on this server authenticates through `pam_ssh_agent` using the SSH agent proxy at `/run/ssh-agent-proxy.sock`. It is not passwordless sudo.

When a command needs sudo from an agent session, run the normal sudo command directly:

```bash
sudo <command>
```

The opencode service puts `/usr/local/libexec/agents/bin` at the front of `PATH`, where `sudo` is an `agent-sudo` shim. The shim preflights Tailscale/MacBook availability, triggers sudo SSH-agent authentication, sends Evan a Telegram notification with the full sudo argv and cwd, then runs the real `/usr/bin/sudo -n`.

Do not manually run `sudo -v` / `sudo -n <command>` unless bypassing the shim intentionally. If sudo auth fails, Evan may need to approve the 1Password biometric prompt on a MacBook, or no MacBook may be online for the proxy to reach. Avoid running multiple sudo commands in parallel because concurrent prompts can race or cancel each other.

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
