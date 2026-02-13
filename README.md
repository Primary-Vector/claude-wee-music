# Wee Music for Claude Code

A Claude Code hooks plugin that plays fun randomized background music while Claude is working. When Claude finishes, it plays a short jingle.

## Installation

First, register the Primary Vector marketplace in Claude Code:

```
/plugin marketplace add primary-vector/claude-marketplace
```

Then install the plugin:

```
/plugin install wee-music@primary-vector-marketplace
```

Finally, run setup to download the music collection:

```
/wee-music:setup
```

### Requirements

- **macOS**: Works out of the box (`afplay` is built-in)
- **Linux**: Install `ffmpeg` or `mpg123`
- **Windows** (Git Bash/WSL): Install `ffmpeg` or `mpg123`

## How it works

- Music starts as soon as you send a message to Claude
- When Claude finishes, the music stops and a short jingle plays
- Songs are picked randomly from a pool of longer tracks
- Uses an atomic lock to prevent multiple players from stacking up

## Commands

| Command | Description |
|---------|-------------|
| `/wee-music:setup` | Download the music collection |
| `/wee-music:enable` | Enable the background music hooks |
| `/wee-music:disable` | Disable hooks and stop music |

## License

MIT
