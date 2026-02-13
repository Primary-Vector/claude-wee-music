# Wee Music for Claude Code

A Claude Code hooks plugin that plays fun randomized background music while Claude is working. When Claude finishes, it plays a short jingle.

## Setup

```bash
# Download the music collection
./setup.sh

# That's it. The hooks in .claude/settings.json handle the rest.
```

### Requirements

- **macOS**: Works out of the box (`afplay` is built-in)
- **Linux**: Install `ffmpeg` or `mpg123`
- **Windows** (Git Bash/WSL): Install `ffmpeg` or `mpg123`

## How it works

- **`PreToolUse` hook** starts randomized background music when Claude begins working
- **`Stop` hook** stops the music and plays a short jingle when Claude finishes
- Songs are picked randomly from a pool of longer tracks
- State is tracked via PID files so multiple tool calls don't stack up players

## Manual usage

```bash
./wee-music.sh start   # Start background music
./wee-music.sh stop    # Stop music
./wee-music.sh done    # Stop music + play the done jingle
```

## License

MIT
