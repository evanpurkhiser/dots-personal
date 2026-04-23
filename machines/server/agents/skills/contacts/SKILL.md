---
name: contacts
description: Look up contacts from Evan's address book. Use this skill when asked about a person's phone number, email, address, or other contact info, or when another skill (e.g. email-and-calendar) needs to resolve a person's name to contact details.
---

# Contacts Skill

Evan's contacts are exported from iCloud as vCards and stored at `/mnt/documents/contacts/icloud/`. They are managed read-only via `khard`.

khard config: `~/.config/khard/khard.conf`

## Searching contacts

Search terms are positional arguments (partial name, email, phone, etc.):

```bash
# List all contacts
khard list

# Search by name or any field (partial match works)
khard list John

# Show full details for a contact
khard show "John Doe"
```

## Getting specific fields

```bash
# Email addresses for matching contacts
khard email John

# Phone numbers for matching contacts
khard phone John

# Postal addresses
khard postaddress John
```

## Scripting / structured output

Use `--parsable` for tab-separated output (good for parsing):

```bash
khard list --parsable
khard email --parsable John
khard phone --parsable John
```

Use `--fields`/`-F` to select specific fields in list output:

```bash
khard list -F name,emails John
khard list -F name,phone John

# See all available fields
khard list -F help
```

Use `--format=yaml` with `show` to get full structured contact data (only works when search matches exactly one contact):

```bash
khard show --format=yaml "John Doe"
```

## Field query syntax

Search within a specific field using `fieldname:value`:

```bash
khard list emails:john@example.com
khard list name:john
```

## Notes

- Contacts are **read-only** — do not use any khard write/edit/new/remove/merge/copy/move commands.
- The address book is at `/mnt/documents/contacts/icloud/` — individual `.vcf` files (one per contact).

## Sync note

Contacts are manually synced from iCloud. If a contact can't be found, they may have been recently added in iCloud and not yet synced to the server.
