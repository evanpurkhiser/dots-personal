---
name: solidcore
description: Search Solidcore studios and classes, inspect bookings, and book or cancel classes through the API-first solidcore command. Use for Solidcore schedules, locations, class types, reservations, waitlists, or account authentication.
---

# Solidcore

Use the `solidcore` command.
It handles HTTP requests, JSON shaping, authentication state, token refresh,
pagination, and write verification.
All command output is JSON.
Purchasing and adding credits are out of scope.

## Safety

- Listing, searching, authentication, and write previews are read-only.
- Before booking or canceling, show the exact class, local date/time, studio,
  action, and credit or waitlist consequence.
  Ask for explicit confirmation immediately
  before rerunning the command with `--confirm`.
- Never purchase a package or membership.
  If no eligible existing credit is returned,
  stop and explain that booking needs a credit.
- Cancellation less than 10 hours
  before class may consume the credit and/or incur a fee.
  Show the command's warning before every cancellation.
- Never print bearer or refresh tokens.
  The command keeps the email
  and tokens in `${XDG_DATA_HOME:-$HOME/.local/share}/solidcore/auth.json` with
  mode `0600`.
- Treat a write as successful only
  when the confirmed command's verification fields show the expected booking
  state.

## Evan's defaults

- When Evan does not specify a studio, search **NY, Nolita**
  (`siteId=847299`, `locationId=8`).
- When Evan does not specify a class type, filter for **Off-Peak Signature50**
  (`classTypeId=164`, `programId=22`).
- Explicit locations and class types always override these defaults.

For known NYC location and class-type IDs,
read [reference-nyc.md](reference-nyc.md).
Use the live listing commands when an entry is missing or may have changed.

## Authenticate

Start with `solidcore auth status`.
It reuses the stored bearer and silently refreshes it when needed.
Request another OTP only when auth state is missing or refresh fails.

```bash
solidcore auth request
printf '%s\n' "$otp" | solidcore auth verify "$hash_code"
```

Both commands use the email in `auth.json` by default.
Pass the email explicitly when auth state does not contain one.
The request result contains `hashCode` and `expiresInMin`.
Ask Evan for the received six-digit code; never save it.
`auth verify` writes the email, bearer, and refresh token,
then returns the authenticated profile summary.

## List locations

```bash
solidcore locations
solidcore locations --query 'greenwich'
solidcore locations --city 'New York' --state NY
```

Always retain the `(siteId, locationId)` pair
because location IDs repeat between sites.
Present `Studio — City, ST (siteId/locationId)`.

## Search classes

`solidcore classes` defaults to Nolita, Off-Peak Signature50,
today through seven days from today.
Relevant filters are:

```text
--start DATE             --end DATE
--site-id ID             --location-id ID (repeatable)
--class-id ID            --class-type-id ID
--class-type TEXT        --all-types
--coach TEXT             --after HH:MM
--before HH:MM           --available
--include-canceled
```

Examples:

```bash
solidcore classes --available
solidcore classes --start 2026-11-16 --end 2026-11-23 --after 17:00
solidcore classes --all-types --coach 'Laura'
```

Present classes in local time, grouped by date, with name/type, studio, coach,
openings or waitlist status, and `classId`.

## List class types

```bash
solidcore class-types --start "$start" --end "$end"
```

Class types are derived from the live schedule for the requested studios
and dates.
The command deliberately does not apply Evan's class-type default.

## List bookings

```bash
solidcore bookings
solidcore bookings --history
solidcore bookings --history --start 2026-01-01
```

Upcoming defaults to the next 40 days.
History defaults to the last 90 days.
Present local date/time, class, studio, coach,
confirmed/waitlisted/canceled status, and `classId`.

## Book a class

1. Search and select an exact class.
2. Run a read-only preview.
   Pass site, location, or date when the selection differs from the defaults:

```bash
solidcore book --class-id "$class_id"
solidcore book --class-id "$class_id" --site-id "$site_id" --location-id "$location_id" --date "$date"
```

The command re-fetches the class and eligible existing credits.
If several credits qualify, rerun with `--service-id`.
Add `--waitlist` only when Evan explicitly chooses the waitlist.

3. Show the preview's action, class, local time, studio, coach, selected credit,
   remaining count, and expiration.
   Ask for explicit confirmation.
4. Repeat the same command with `--confirm`.
   Report `verifiedBooking`; if it is `null`, say verification failed.

## Cancel a booking

1. List upcoming bookings and select the exact `classId`.
2. Run the read-only preview:

```bash
solidcore cancel --class-id "$class_id"
```

3. Show the booking, whether the action cancels a reservation
   or leaves a waitlist, and the late-cancel warning.
   Ask for explicit confirmation.
4. Repeat with `--confirm`.
   Report success only when `verifiedRemoved` is `true`.
