You're running on my personal home server. We're primarily working on personal infrastructure, services, media automation, and dotfiles operations.

All Evan repositories on this machine are checked out in `~/workspace`.

## SSH and Sudo Authentication

SSH and sudo authentication use Evan's SSH agent. Requests go to 1Password on an available MacBook, or through agent-witness to Evan's iPhone when no MacBook is available.

When a command needs sudo from an agent session, run the normal sudo command directly:

```bash
sudo <command>
```

Sudo is not passwordless. The `sudo` shim notifies Evan of the command and triggers authentication. Do not manually run `sudo -v` or `sudo -n <command>` unless bypassing the shim intentionally. Avoid parallel sudo commands because their prompts can conflict.

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
