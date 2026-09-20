---
name: torrents
description: Search and download torrents using Nyaa for anime and IPTorrents for movies and TV series, with Transmission handling downloads. Use for torrent searches or requests to get movies, shows, or anime.
---

# Torrent Search and Download

Choose the source by content type, honoring an explicitly requested tracker:

- **Anime, including anime movies:** Nyaa.si via `toru`.
- **Movies and other TV series:** IPTorrents via `ipt`.

The system packages are `iptorrents-cli` from Evan's pacman repository and
`toru-bin` from the AUR.

Search-only requests stop at reporting results. Use the Nyaa workflow below for
anime; the IPTorrents workflow follows. Add selected downloads to Transmission
so the existing completion and organization workflow applies.

## Nyaa anime workflow

Search with plain text or structured output:

```bash
toru search --print "<title>"
toru search --json "<title>" | toonify
```

For example, search JoJo releases by seed count:

```bash
toru search --print --sort-by seeders --sort-order desc "JoJo"
```

Narrow by arc or batch when looking for a complete season:

```bash
toru search --print "JoJo Stone Ocean"
toru search --print "JoJo batch"
toru search --print "JoJo no Kimyou na Bouken"
```

Inspect a compact list of candidates with their magnets:

```bash
toru search --json --sort-by seeders --sort-order desc "JoJo" |
  jq '.[0:10] | map({Name, Seeders, Size, Magnet})' | toonify
```

JSON fields are case-sensitive; `Size` is in bytes. Use `--page 2` for the
next results page and `toru search --list` to discover category values.

Use `--print` or `--json` for noninteractive searches. Reserve Toru's
`--stream` and `--download` options for explicitly requested Toru transfers;
normal downloads go through Transmission.

- Try English and romanized Japanese titles when results are sparse.
- Verify the requested part, season, episode range, and batch contents. Anime
  releases may use arc names or absolute episode numbers instead of `SxxExx`.
- Check subtitle languages and audio tracks; distinguish raw Japanese releases,
  English-subtitled releases, and dual-audio releases. Honor requested languages.
- Compare source, encode, subtitles, seeders, and size. Prefer complete batches
  for whole-season requests and encodes over large remuxes. Tracker choice alone
  does not establish release quality.
- Show the chosen release, size, seeders, and relevant audio/subtitle details.
  Confirm before downloading unless Evan already authorized downloading it.

Pass the selected result's `Magnet` value to Transmission, quoted as one argument:

```bash
transmission-remote localhost --add '<selected magnet URI>'
```

Verify Transmission reports success. If Nyaa is unavailable, report the failure;
IPTorrents is a fallback source to search. If Transmission is unavailable, retain
the selected magnet for a later retry.

## IPTorrents workflow

### 1. Extract intent from the user's message

Parse out:
- **Title** (required)
- **Season + episode** if specified (e.g. S03E05) — include in search query
- **Explicit quality** request (e.g. "4K", "1080p", "720p") — only if user explicitly said it

### 2. Search

```bash
ipt search "<title> S##E##" --sort seeders
```

**Keep search strings short.** IPTorrents search is finicky — adding quality terms like "1080p" often returns fewer or no results. Use only the title and season/episode. Let the result list do the filtering.

If the first search doesn't return good matches, try variations — shorter title, drop the season/episode, or alternate title spellings. Multiple searches are fine.

Each result has: `id`, `name`, `category`, `size`, `seeders`, `leechers`, `downloads`, `added`, `freeleech`.

### 3. Filter: must match what the user asked for

**Hard filters (skip results that fail these):**
- Title must actually match — fuzzy is OK but don't accept a completely different show
- If user specified S##E## (season/episode), the result name must contain it (case-insensitive)
- If user specified a season only (e.g. "season 3"), result must contain "S03" or "Season 3"

### 4. Score and rank remaining candidates

Score each candidate (higher = better):

| Factor | Points |
|--------|--------|
| freeleech = true | +1000 |
| seeders | +seeders (raw count) |
| 4K / 2160p in name | +200 |
| HDR in name | +100 |
| 1080p in name | +50 |
| 720p in name | -50 |
| REMUX in name | -30 (large files, rarely needed) |

**Size sanity check:** If a 4K result is more than 5x the size of the best 1080p result, flag it and ask rather than auto-selecting.

**Remux note:** Evan uses a 2.1 audio system so lossless audio tracks don't add value. Encodes (x265/HEVC) are preferred over remux. Only surface a remux if there's no encode available.

**HDR note:** Evan's TV supports 4K HDR — if a release includes HDR it's a genuine upgrade worth mentioning.

**Inform the user** if a movie/show is particularly well-regarded visually (e.g. shot on IMAX, known for cinematography) — worth noting "this would look great in 4K/HDR" to help them decide.

**Exception:** If user explicitly asked for a specific quality, filter to only that quality and ignore the scoring above.

### 5. Decide: auto-select or ask?

**Auto-select silently if** the top result is clearly the best:
- freeleech AND most seeded, OR
- only one result passed the hard filters

**Ask the user to choose if:**
- Multiple results with meaningfully different qualities (720p vs 1080p vs 4K all present)
- Top two results are close in score (within 20%) and one is significantly larger

When asking, show a compact list:
```
1. The Bear S03E05 1080p WEB-DL x264 — 3.2 GB, 1200 seeders [FL]
2. The Bear S03E05 720p WEB-DL x264  — 1.8 GB, 340 seeders
3. The Bear S03E05 2160p UHD BluRay  — 18 GB, 88 seeders
Pick one (1/2/3):
```

### 6. Confirm before downloading (always)

Show the chosen torrent and ask:
```
→ The Bear S03E05 1080p WEB-DL x264 [FreeLeech]
  3.2 GB · 1200 seeders · ID 555777
Download this? (y/n)
```

Skip confirmation only if user said "just download it" or equivalent.

### 7. Download and add to Transmission

```bash
tmp=$(mktemp /tmp/ipt-XXXXXX.torrent)
ipt download --stdout <id> > "$tmp"
transmission-remote localhost --add "$tmp"
rm "$tmp"
```

Report success or failure clearly.

**Automatic Organization:** Transmission is configured with `transmission-helper` (https://github.com/evanpurkhiser/transmission-helper) which automatically:
- Detects when torrents complete via systemd socket activation
- Uses OpenAI to classify content (movie vs TV series)
- Organizes files by hard-linking them to the proper library structure:
  - Movies → `~/documents/multimedia/videos/movies/`
  - TV Series → `~/documents/multimedia/videos/series/<Show Name>/Season N/`
- Sends Telegram notifications with processing details
- Keeps torrents seeding in their original location

**No manual organization needed** — just add the torrent and transmission-helper will handle the rest when it completes.

## Error handling

| Situation | Action |
|-----------|--------|
| No results at all | Tell user, suggest trying a different search term |
| Auth expired (exit 1, "not logged in") | Tell user to grab cookies from DevTools (Network tab → any iptorrents.com request → Request Headers → Cookie) and run `ipt auth "<paste>"` |
| Transmission not running | Save .torrent to disk instead: `ipt download <id>` |
| Download fails | Report error, offer to retry or save file |

## Notes

- freeleech torrents cost no download quota — always prefer them unless quality is wrong
- `cf_clearance` cookie does not have a fixed expiry — it typically remains valid indefinitely until Cloudflare re-challenges (e.g. IP change, VPN switch, security trigger). If auth expires, requests will fail with 403 and the user needs to re-auth.
- Do NOT auto-download without at least showing the user what will be downloaded
- `ipt` supports `--json` on all commands if you need structured output for scripting or `jq` filtering
