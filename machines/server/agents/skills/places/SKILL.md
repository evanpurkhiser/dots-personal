---
name: places
description: Search and manage Evan's saved places with the Places CLI, including tags and imports.
---

# Places CLI

## Search saved places

Adjacent filters mean AND. Use `OR`, `!`, and parentheses to combine them. Exact tag names must exist; `*` matches tag name patterns. Name, address, and notes match substrings. Within a query expression, quote literal values containing spaces or query punctuation.

When presenting places, link each name to its `googleMapsUrl` when available,
then add a parenthetical `Places` link using its saved-place UUID:
`https://places.prk.network/?q=id%5B%22<place-id>%22%5D&zoom=true`. For example:
`[Place name](<googleMapsUrl>) ([Places](<places-url>))`.

For location-sensitive requests, use Evan's current Home Assistant location as
the reference point when he does not specify one. Read the latitude and
longitude from `person.evan_purkhiser` with the Home Assistant MCP server, then
pass them to the CLI as `--reference-location 'point(<longitude>, <latitude>)'`.
An explicit location always takes precedence. If Home Assistant does not return
both coordinates or the reading is clearly stale, ask for a reference location
instead. Do not fetch a location for queries where proximity is irrelevant.

```sh
# List every saved place.
places list

# Find places within one mile of a named point or explicit coordinates.
places list --query 'location[radius("East Village, NYC", 1mi)]'
places list --query 'location[radius(point(-73.985, 40.726), 800m)]'

# Reuse one reference location in a filter or sort by distance from it.
places list --reference-location 'Union Square, NYC' --query 'location[radius(@ref, 5mi)]'
places list --reference-location 'Union Square, NYC' --sort distance

# Find a place by name; use = for a complete name match.
places list --query 'name[coffee]'
places list --query 'name[="La Cabra"]'

# Require both tags, or accept either tag.
places list --query 'tag[type.cafe] tag[attr.laptop-friendly]'
places list --query '(tag[type.cafe] OR tag[type.bakery])'

# Match any tag in a namespace; exclude places already visited.
places list --query 'tag[type.*] !tag[status.visited]'

# Search place notes or a note on a specific tag assignment.
places list --query 'notes[espresso]'
places list --query 'tag[attr.laptop-friendly, notes:outlet]'

# Search discovery context attached to an Instagram source.
places list --query 'source[instagram, text:coffee]'

# Find places open now, or continuously open for the next two hours.
places list --query 'open[@now]'
places list --query 'open[@now, for:2h]'

# Combine location, type, and opening hours.
places list --query 'tag[type.restaurant] location[radius("Union Square, NYC", 2mi)] open["fri 7pm"]'
```

Named locations resolve to the first Google result; include a city or region. `--reference-location` accepts the same place names, addresses, Maps links, `gmaps:` IDs, and explicit coordinates as geographic filters. Use `@ref` wherever a geographic point is accepted. Distance sorting requires a reference location; `distance` sorts nearest first and `distance-desc` sorts farthest first. Radius and sorting use straight-line distance.

The shell quotes in these examples group spaces and punctuation into one argument; they are not part of the location value. `open` uses saved weekly hours; missing hours match neither `open[@now]` nor `!open[@now]`. Run `places docs filter` for more syntax.

## Discover and manage tags

List tags for current descriptions and IDs. Archived tags are omitted from `tags list` but available by ID. Create a namespace before creating a qualified tag.

```sh
# Read available tags and their descriptions; inspect one tag by UUID.
places tags list
places tags get <tag-id>

# Browse and create namespaces.
places namespace list
places namespace create cuisine --description 'Food and drink categories'

# Create or edit a tag definition.
places tags create cuisine.tea-house --icon '🍵' --description 'Tea-focused shop'
places tags update <tag-id> --description 'Tea shop with seating'
places tags update <tag-id> cuisine.tea-shop
places tags update <tag-id> --icon '' --description ''

# Hide or restore a tag without losing its assignments.
places tags update <tag-id> --archive
places tags update <tag-id> --unarchive

# Delete a tag definition and its place assignments.
places tags delete <tag-id>
```

## Update a saved place's tags

Use place UUIDs from `list` or `import-status`. Tags accept names or UUIDs. Omitted `--notes` preserves an assignment note; `--notes ''` clears it.

```sh
# Apply an existing tag, with or without an assignment note.
places tag <place-id> attr.laptop-friendly
places tag <place-id> attr.laptop-friendly --notes 'Outlets near the back'

# Clear the assignment note or remove the assignment.
places tag <place-id> attr.laptop-friendly --notes ''
places untag <place-id> attr.laptop-friendly
```

## Find and import places

`search-gmaps` finds candidates. `import` queues Google Maps or Instagram imports. `--wait` returns saved place IDs; `import-status` checks later.

```sh
# Find a Google Maps place to add.
places search-gmaps 'coffee shops in East Village, NYC'

# Import from a Google Maps link or Place ID and wait for the result.
places import '<google-maps-url>' --wait
places import 'gmaps:PLACE_ID' --wait --tag type.cafe --notes 'Try the espresso'

# Attach tags and an assignment note during import.
places import 'gmaps:PLACE_ID' --wait --tag type.cafe --tag-note attr.laptop-friendly 'Outlets near the back'

# Check a queued import.
places import-status <job-id>
```

## Command behavior

The installed `places` command reads `~/.config/places/config.yaml` when present and defaults to `http://127.0.0.1:5188` otherwise. Data commands return JSON. Place and tag IDs are UUIDs. Run `places --help` for arguments and `places docs filter` for query syntax.
