---
name: resy-booking
description: Use when asked to book a restaurant reservation, view reservations, find a reservation slot, or cancel a reservation.
---

# Skill: Resy Booking

Use `resyctl` as a playbook-driven CLI for reservation discovery, quoting,
booking, listing, and cancellation.

## Guardrails

- Always inspect policy with `quote` before booking.
- Treat cancellation fee windows as high risk.
- Do not book without clear intent.
- Prefer `--dry-run` for preview unless user asked to execute booking.
- For fee-bearing slots, require explicit allowance via `--allow-fee`.

## Core Workflow

### 1) Ensure auth is available

```bash
resyctl auth status
```

If missing/expired, log in:

```bash
resyctl auth login --email "<email>" --password-file "<path>"
```

### 2) Search restaurants

```bash
resyctl search "<restaurant name>" --limit 5 \
  | jq -r '.venues[] | "\(.id): \(.name) [\(.locality // "?")]"'
```

Pick the most likely `venue_id`.

### 3) Look up venue details (optional)

Useful for confirming the right venue (address, neighborhood) or returning
contact/links to the user:

```bash
resyctl venue <venue_id> \
  | jq '.venue | {name, neighborhood, address, phone, website, resy_url, google_maps_url}'
```

### 4) Find availability

For a specific date:

```bash
resyctl availability <venue_id> --date YYYY-MM-DD --party-size <n> \
  | jq -r '.slots[] | "\(.slot_id) | \(.start) | \(.type // "?")"'
```

For month/day scan:

```bash
resyctl availability <venue_id> --month YYYY-MM --days --party-size <n> \
  | jq -r '.days[] | "\(.date) (\(.available_slot_count) slots)"'
```

For time-window constraints (example: 5pm-7pm):

```bash
resyctl availability <venue_id> --date YYYY-MM-DD --party-size <n> \
  --time-after 17:00 --time-before 19:00 \
  | jq -r '.slots[] | "\(.slot_id) | \(.start) | \(.type // "?")"'
```

### 5) Quote a slot before booking

```bash
resyctl quote "<slot_id>" \
  | jq '{
      fee_amount: .quote.fee_amount,
      fee_cutoff: .quote.fee_cutoff,
      refund_cutoff: .quote.refund_cutoff,
      payment_type: .quote.payment_type,
      policy_text: .quote.policy_text
    }'
```

### 6) Book with policy controls

Base booking:

```bash
resyctl book "<slot_id>" --yes
```

Fee-aware booking:

```bash
resyctl book "<slot_id>" \
  --allow-fee \
  --max-fee 25 \
  --max-cutoff-hours 12 \
  --yes
```

`--max-cutoff-hours` means require at least N hours until the fee cutoff.
If the cutoff is closer than N hours (or missing), booking is blocked.
Example: `--max-cutoff-hours 12` blocks booking when the fee cutoff is within 12 hours.

"Fee cutoff" is the timestamp after which cancellation can incur a fee.
Before fee cutoff: canceling is free. After fee cutoff: fee may apply.

Preview only:

```bash
resyctl book "<slot_id>" --allow-fee --dry-run
```

### 7) List reservations

Upcoming:

```bash
resyctl reservations --upcoming \
  | jq -r '.reservations[] | "\(.reservation_id) | \(.day) \(.time_slot) | \(.venue.name // "?")"'
```

All:

```bash
resyctl reservations --all --limit 50 --offset 0
```

### 8) Cancel a reservation

By `resy_token` (required positional argument):

```bash
resyctl cancel "<resy_token>" --yes
```

Preview cancellation:

```bash
resyctl cancel "<resy_token>" --dry-run
```

## Patterns for common requests

### "Find me the first 5pm-7pm weekend reservation at XYZ"

1. `search` for venue id.
2. Check the next weekend dates (Saturday/Sunday) in order.
3. Use `availability --date ... --time-after 17:00 --time-before 19:00`.
4. Select first matching slot chronologically.
5. `quote` it and present fee/cutoff before any booking action.

### "Find me the next earliest 6:30 slot at XYZ"

1. `search` for venue id.
2. Iterate forward by date (or use month day scan first).
3. Filter slots for `start` time matching `18:30`.
4. Choose earliest date/time match.
5. `quote` and optionally `book` with guardrails.

### Multi-venue workflows

When a request involves several venues (e.g. "find a 7pm slot at any of
Cosme, Atomix, or Don Angie next Saturday"):

1. Run one `resyctl search` per venue name in parallel (single message,
   multiple Bash tool calls). Pick the right venue_id from each result
   independently — locality and ratings disambiguate.
2. Run one `resyctl availability` per resolved venue_id in parallel, with
   the same date/time-window filters across all.
3. Merge the slot lists and present the earliest matches.

## Payment methods

To inspect available payment method IDs:

```bash
resyctl payment-methods \
  | jq -r '.payment_methods[] | "\(.id): \(.card_type // "card") ****\(.last_4 // "????")"'
```
