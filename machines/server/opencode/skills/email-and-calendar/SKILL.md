---
name: email-and-calendar
description: Manage Evan's Gmail and Google Calendar via gogcli. Use this skill to read, search, send, and draft emails, and to list, create, or update calendar events.
---

# Email and Calendar Skill

Evan's Gmail and Google Calendar are accessible via `gog` (gogcli), installed at `/usr/bin/gog`.

## Environment

Always set this before running any `gog` command:

```bash
export GOG_KEYRING_PASSWORD="$(cat ~/.config/gogcli/keyring-password)"
```

Or prefix commands inline:

```bash
GOG_KEYRING_PASSWORD="$(cat ~/.config/gogcli/keyring-password)" gog ...
```

Use `--json` for machine-readable output. Use `--plain` for TSV.

---

## Gmail

### Search emails

Gmail query syntax (same as the Gmail search box):

```bash
gog gmail search 'newer_than:7d' --json
gog gmail search 'from:someone@example.com is:unread' --json
gog gmail search 'subject:"meeting" newer_than:3d' --json
gog gmail search 'is:unread in:inbox' --max 20 --json
```

### Read a thread

```bash
gog gmail thread get <threadId> --json
```

### Read a single message

```bash
gog gmail get <messageId> --json
```

### Send an email

```bash
gog gmail send --to recipient@example.com --subject "Subject" --body "Body text"

# With HTML body
gog gmail send --to recipient@example.com --subject "Subject" --body "Plain fallback" --body-html "<p>HTML body</p>"

# Reply to a message
gog gmail send --reply-to-message-id <messageId> --to recipient@example.com --subject "Re: Subject" --body "Reply text"
```

### Draft emails

```bash
# Create a draft
gog gmail drafts create --to recipient@example.com --subject "Subject" --body "Body"

# List drafts
gog gmail drafts list --json

# Send a draft
gog gmail drafts send <draftId>
```

### Labels

```bash
gog gmail labels list --json

# Add/remove labels on a thread
gog gmail thread modify <threadId> --add STARRED --remove INBOX
```

### Batch operations

```bash
# Mark multiple messages
gog gmail batch modify <messageId1> <messageId2> --add READ --remove UNREAD

# Delete multiple messages
gog gmail batch delete <messageId1> <messageId2>
```

---

## Calendar

Evan's primary calendar ID is `primary`.

### List calendars

```bash
gog calendar calendars --json
```

### List events

```bash
# Today
gog calendar events primary --today --json

# This week
gog calendar events primary --week --json

# Next N days
gog calendar events primary --days 7 --json

# Date range
gog calendar events primary --from 2026-03-01 --to 2026-03-31 --json

# All calendars
gog calendar events --all --today --json
```

### Search events

```bash
gog calendar search "meeting" --days 30 --json
gog calendar search "dentist" --from 2026-01-01 --to 2026-12-31 --json
```

### Get a specific event

```bash
gog calendar event primary <eventId> --json
```

### Create an event

```bash
gog calendar create primary \
  --summary "Meeting" \
  --from 2026-03-10T10:00:00-05:00 \
  --to 2026-03-10T11:00:00-05:00

# With attendees
gog calendar create primary \
  --summary "Team Sync" \
  --from 2026-03-10T14:00:00-05:00 \
  --to 2026-03-10T15:00:00-05:00 \
  --attendees "alice@example.com,bob@example.com" \
  --location "Zoom"
```

### Update an event

```bash
gog calendar update primary <eventId> \
  --summary "Updated Title" \
  --from 2026-03-10T11:00:00-05:00 \
  --to 2026-03-10T12:00:00-05:00
```

### Delete an event

```bash
gog calendar delete primary <eventId> --force
```

### RSVP to an invitation

```bash
gog calendar respond primary <eventId> --status accepted
gog calendar respond primary <eventId> --status declined
gog calendar respond primary <eventId> --status tentative
```

### Check availability

```bash
gog calendar freebusy primary \
  --from 2026-03-10T00:00:00-05:00 \
  --to 2026-03-10T23:59:59-05:00 \
  --json
```

### Find conflicts

```bash
gog calendar conflicts --today --json
gog calendar conflicts --days 7 --json
```

---

## Notes

- Evan's timezone is **America/New_York (ET)**. Use `-05:00` (EST) or `-04:00` (EDT) offsets for event times, or pass `--timezone America/New_York`.
- Always confirm destructive actions (sending emails, deleting events) with Evan before executing.
- When searching emails, prefer `--json` and summarize results rather than dumping raw output.
- The `primary` calendar ID can be used for all personal calendar operations.
