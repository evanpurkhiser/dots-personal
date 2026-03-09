# OpenCode Agent Guidelines

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
