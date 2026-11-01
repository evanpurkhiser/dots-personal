---
name: 1password
description: Search Evan's 1Password catalog and perform explicit secret handoffs. Use whenever a task needs an API key, login, password, TOTP, credit card, SSH credential, or other secret likely stored in 1Password; prefer this workflow over asking Evan to paste secret values.
---

# 1Password

## Find the item

Search the metadata-only catalog before asking Evan for a secret:

```console
op-catalog search <terms>
```

Use `op-catalog list --category <category>` or `--vault <vault>` when browsing is
more useful. Results are private 1Password item links containing no secret
values. Send Evan the best matching link. Send a short list of candidates when
the intended item is ambiguous.

Ask Evan to open the item, share it using a view-once link, and send the
resulting `https://share.1password.com/s#...` URL. A private item link opens the
original item; it is not itself a secret handoff.

## Receive the share

Pass the share URL to `psst open` on standard input. Inspect field metadata
before retrieving any value:

```console
session="$(printf '%s' '<share-url>' | psst open)"
trap 'psst close "$session" 2>/dev/null || true' EXIT
psst fields "$session"
```

Use an exact selector returned by `fields`, and pipe each required value
directly to its consumer:

```console
psst get "$session" -- <selector> | <consumer>
```

For a field with `type` `file`, use `download` to pipe the original bytes to
their consumer:

```console
psst download "$session" -- <selector> | <consumer>
```

Close the session as soon as the consumer finishes:

```console
psst close "$session"
trap - EXIT
```

## Safety

- Never print, inspect, log, or summarize values returned by `get` or
  `download`.
- Never write a value to a terminal. Both commands refuse terminal output; keep
  the direct pipe intact.
- Retrieve only fields required for the task.
- Treat item titles and vault names as private metadata.
- `open` consumes a view-once share. `close` destroys only the local session;
  it does not revoke a multi-view 1Password link.
