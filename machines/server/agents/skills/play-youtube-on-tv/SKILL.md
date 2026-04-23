---
name: play-youtube-on-tv
description: Play a YouTube video or URL on Evan's Apple TV via Home Assistant. Use this skill when asked to play, cast, or put a YouTube video on the TV.
---

# Play YouTube on TV Skill

Play YouTube videos on Evan's Apple TV using the `script.play_youtube_on_apple_tv` Home Assistant script.

## Script Details

- **Script ID**: `play_youtube_on_apple_tv`
- **What it does**:
  1. Turns on the Apple TV if it's in standby (waits 6 seconds for it to wake)
  2. Plays the YouTube URL via `media_player.apple_tv`
  3. Sets the Living Room Sonos speaker volume

## Fields

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `youtube_url` | Yes | — | Full YouTube URL to play |
| `volume` | No | 20 | Sonos speaker volume (1–100) |

## Usage

Call the script via the `script` domain:

```
ha_call_service(
    domain="script",
    service="play_youtube_on_apple_tv",
    data={
        "youtube_url": "<url>",
        "volume": 20
    }
)
```

## Notes

- If the user doesn't specify a volume, use the default of **20**.
- The `youtube_url` should be passed exactly as given by the user — full URL including any playlist or start_radio params is fine.
- No need to ask which media player — this always targets the Apple TV + Living Room Sonos.
