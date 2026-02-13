---
description: Disable background music hooks and stop any playing music
---

# Disable Wee Music

Stop any currently playing music and remove the hooks from settings.

## Step 1: Stop Music

Stop any currently playing music:

```bash
<PLUGIN_ROOT>/wee-music.sh stop
```

Replace `<PLUGIN_ROOT>` with the actual plugin directory path (parent of `commands` where this file lives).

## Step 2: Remove Hooks

Edit `.claude/settings.json` and remove the `PreToolUse` and `Stop` hook entries that reference `wee-music.sh`. If removing them leaves the hooks object empty, remove the hooks key entirely. Be careful not to remove hooks from other plugins.

Tell the user music is now disabled. They can re-enable it with `/wee-music:enable`.
