---
name: places
description: Search and manage Evan's saved places with the Places CLI, including tags and imports.
---

# Places CLI

## Search saved places

Adjacent filters mean AND. Use `OR`, `!`, and parentheses to combine them. Exact tag names must exist; `*` matches tag name patterns. Name, address, and notes match substrings. Quote values containing spaces or query punctuation.

```sh
# List every saved place.
places list

# Find places within one mile of a named point or explicit coordinates.
places list --query 'location[radius("East Village, NYC", 1mi)]'
places list --query 'location[radius(point(-73.985, 40.726), 800m)]'

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

Named locations resolve to the first Google result; include a city or region. Radius is straight-line distance. `open` uses saved weekly hours; missing hours match neither `open[@now]` nor `!open[@now]`. Run `places docs filter` for more syntax.

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
