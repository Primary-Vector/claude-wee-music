---
description: Enable background music hooks
---

# Enable Wee Music

Enable the background music hooks so music plays while Claude works.

Read the user's global `~/.claude/settings.json` (create it if it doesn't exist). Merge in the wee-music hooks, being careful not to overwrite any existing hooks from other plugins.

The plugin root directory is the parent of the `commands` directory where this file lives. Use its absolute path in the hook commands.

The hooks to add:

- Under `"UserPromptSubmit"`, add a hook with:
  - `"type": "command"`
  - `"command": "\"<PLUGIN_ROOT>/wee-music.sh\" start"`
  - `"async": true`

- Under `"Stop"`, add a hook with:
  - `"type": "command"`
  - `"command": "\"<PLUGIN_ROOT>/wee-music.sh\" done"`
  - `"async": true`

Replace `<PLUGIN_ROOT>` with the actual absolute path to the plugin directory.

If the hooks are already present, just tell the user music is already enabled.

Tell the user music is now enabled and will play next time they send a message (after restarting Claude Code).
