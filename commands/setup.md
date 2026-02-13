---
description: Download the music collection and verify everything is ready
---

# Wee Music Setup

Run the setup script to download the music collection, verify the audio player, and install hooks.

## Step 1: Download Music

Run the setup script from the plugin root directory:

```bash
<PLUGIN_ROOT>/setup.sh
```

Replace `<PLUGIN_ROOT>` with the actual plugin directory path (the parent of the `commands` directory where this file lives).

This downloads the music collection from archive.org (~80MB) and extracts the mp3 files.

## Step 2: Verify Audio Player

Check that an audio player is available:

```bash
which afplay || which ffplay || which mpg123 || echo "NO_PLAYER_FOUND"
```

If no player is found:
- **macOS**: `afplay` should be built-in. Something is wrong if it's missing.
- **Linux**: Install ffmpeg (`sudo apt install ffmpeg`) or mpg123 (`sudo apt install mpg123`)
- **Windows** (Git Bash/WSL): Install ffmpeg

## Step 3: Install Hooks

Read the current `.claude/settings.json` (create it if it doesn't exist). Merge in the following hooks, being careful not to overwrite any existing hooks from other plugins. Replace `<PLUGIN_ROOT>` with the actual absolute path to the plugin directory.

The hooks to add:

- Under `"UserPromptSubmit"`, add a hook with:
  - `"type": "command"`
  - `"command": "\"<PLUGIN_ROOT>/wee-music.sh\" start"`
  - `"async": true`

- Under `"Stop"`, add a hook with:
  - `"type": "command"`
  - `"command": "\"<PLUGIN_ROOT>/wee-music.sh\" done"`
  - `"async": true`

## Step 4: Test

Do a quick test to make sure music plays:

```bash
<PLUGIN_ROOT>/wee-music.sh start
```

Wait 2 seconds, then stop it:

```bash
<PLUGIN_ROOT>/wee-music.sh stop
```

If the user heard music, setup is complete!

## Done!

Tell the user setup is complete. Music will play automatically when they send a message (after restarting Claude Code). Remind them of the slash commands:
- `/wee-music:disable` — stop music and remove hooks
- `/wee-music:enable` — re-enable hooks
