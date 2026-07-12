---
name: media-management
description: Find, search, and manage files in Evan's multimedia library at ~/documents/multimedia. Use this skill when Evan asks if he has specific movies/shows/music, searches for media files, checks what's in his collection, or needs to organize media files (videos, music, photos, artwork, etc.).
---

# Media Management

This skill provides context about Evan's multimedia library organization.

## Top-Level Directory Structure

```
~/documents/multimedia/
├── artwork/         # Digital artwork and illustrations
├── djing/          # Professional DJ track library and mixes
├── photos/         # Photo library
├── videos/         # Movies, TV series, and anime
├── wallpapers/     # Desktop wallpapers
└── workouts/       # Workout-related media
```

---

## Videos Directory (`~/documents/multimedia/videos/`)

### Movies (`videos/movies/`)

**Organization:** Flat alphabetical structure

- All movie files stored directly in the movies folder (no subdirectories)
- 159 movie files total
- **Naming Convention:** `Movie Title.mkv` or `Movie Title (Year).mkv`
  - Year added when needed for disambiguation
  - Examples: `2001 A Space Odyssey.mkv`, `Beetlejuice (1988).mkv`, `Ghost in the Shell 2.0.mkv`
- **File Formats:** Primarily `.mkv`, some `.mp4` and `.avi`
- Franchises stored together alphabetically
- Mix of live-action and anime films

### TV Series (`videos/series/`)

**Organization:** Hierarchical by show > season > episode

```
series/
├── Show Name/
│   ├── Season 1/
│   │   ├── S01E01.mkv
│   │   ├── S01E02.mkv
│   │   └── ...
│   ├── Season 2/
│   └── ...
```

- 30 series total
- **Naming Convention:**
  - Show folders: Full show name
  - Season folders: `Season N/`
  - Episode files: `S##E##.mkv` (standard TV episode format)
- **File Format:** Exclusively `.mkv`
- Mix of genres: drama, comedy, animated, reality/documentary
- Examples: Better Call Saul, Succession, Arrested Development, Rick and Morty, The Expanse

### Anime (`videos/anime/`)

**Organization:** Hierarchical by series > season > episode (same as TV series)

```
anime/
├── Series Name/
│   ├── Season 1/
│   │   ├── S01E01.mkv
│   │   └── ...
│   └── ...
```

- 137 anime series total
- **Naming Convention:**
  - Series folders: Full anime title (English or romanized Japanese)
  - Some folders include database IDs in brackets: `FateStay Night [79151]/`
  - Season folders: `Season 1/`
  - Episode files: `S##E##.mkv`
- **File Format:** Primarily `.mkv`
- Alphabetically sorted, no genre subdivisions
- Wide variety: action, sci-fi, drama, comedy, supernatural
- Examples: Cowboy Bebop, Death Note, Attack on Titan, Steins;Gate

---

## DJing Directory (`~/documents/multimedia/djing/`)

Professional DJ library organized for professional DJ software use.

### Main Track Library (`djing/tracks/`)

**Organization:** By record label (industry standard)

```
tracks/
├── Label Name/
│   ├── [+singles]/  (optional - loose tracks)
│   ├── [CATALOG#] Release Name/
│   │   ├── 01. [Vinyl Side] Artist - Track Title.aif
│   │   └── ...
│   └── ...
```

- 341 record label folders
- **Naming Conventions:**
  - Label folders: `Label Name/`
  - Release folders: `[CATALOG#] Artist - Release Title/`
  - Track files: `##. [Vinyl Side] Artist - Track Title (Remix).extension`
  - Example: `01. [08A] Darwin - Push You Away (Freeform Mix).aif`
- **File Formats:**
  - `.aif` (uncompressed audio for professional DJ use)
  - `.mp3` (compressed)
- **Genre Focus:** UK Hardcore, Freeform, Hard Trance, Happy Hardcore, Trance
- Labels include: 24-7 Hardcore, Brutal Kuts, HTID, Masif, Nu Energy Records, Armada, Anjunabeats, FINRG Recordings, EXIT TUNES, Hardcore TanoC

---

## Usage Notes

- **Movies:** Simple flat structure for easy browsing
- **TV/Anime:** Standard hierarchical structure optimized for media servers (Plex/Jellyfin)
- **DJing:** Professional industry-standard organization by record label and catalog number
- All collections maintain consistent naming conventions within each category
- Use standard Linux tools (find, mv, cp, etc.) for file operations
- Be mindful of file sizes when performing bulk operations
- The djing library uses lossless `.aif` files for professional DJ work
