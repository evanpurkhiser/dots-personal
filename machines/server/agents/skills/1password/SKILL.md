---
name: 1password
description: Search Evan's 1Password catalog and perform explicit secret or passkey handoffs. Use whenever a task needs an API key, login, password, TOTP, passkey, credit card, SSH credential, or other secret likely stored in 1Password; prefer this workflow over asking Evan to paste secret values.
---

# 1Password

## Find the item

Search the metadata-only catalog by item name or website/domain
before asking Evan for a secret:

```console
op-catalog search <terms>
```

Use `op-catalog list --category <category>` or `--vault <vault>`
when browsing is more useful.
Results are private 1Password item links containing no secret values.
Send Evan the best matching link.
Send a short list of candidates when the intended item is ambiguous.

Ask Evan to open the item and share it once: “Share it with me.”
A private item link opens the original item; it is not itself a secret handoff.

## Use the share

After Evan provides the share URL,
load the operational guide that matches the installed psst version:

```console
psst skill
```

Follow that guide for field retrieval, file downloads, passkey authentication,
session cleanup, and browser setup.
Load it before the first `psst` handoff command
so its instructions stay aligned with the installed binary.

### Share links sent in chat

Evan can send a short-lived 1Password share link directly in chat.
When he sends one for the current task,
use it as the handoff without asking him to share it again.
This is an exception to the `psst skill` guidance about including a literal link
in a tool call.
Use the link only as input to `psst open`.

For example, if Evan sends a `https://share.1password.com/s#…` link
and asks you to use it to sign in to Fastmail,
run the following with the URL he sent in place of `<share-url>`:

```bash
printf '%s' '<share-url>' | psst open
```

Use the session ID returned by `psst open` to continue the task.
Omit the URL from replies.

### Fill a browser control

Fill an identified browser control directly from an exact psst field selector:

```console
agent-browser --session <name> fill @field "$(psst get <session> -- <selector>)"
```

Use a fresh TOTP immediately before submitting it.

## Safety

- Treat item titles and vault names as private metadata.
