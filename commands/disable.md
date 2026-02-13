---
description: Disable background music hooks and stop any playing music
---

# Disable Wee Music

Stop any currently playing music and disable the plugin.

## Step 1: Stop Music

Stop any currently playing music:

```bash
<PLUGIN_ROOT>/wee-music.sh stop
```

Replace `<PLUGIN_ROOT>` with the actual plugin directory path (parent of `commands` where this file lives).

## Step 2: Disable Plugin

Edit `~/.claude/settings.json` and set `"wee-music@primary-vector-marketplace"` to `false` in the `enabledPlugins` object.

Tell the user music is now disabled. They'll need to restart Claude Code for it to take effect. They can re-enable it with `/wee-music:enable`.
