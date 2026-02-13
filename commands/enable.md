---
description: Enable background music hooks
---

# Enable Wee Music

Enable the background music hooks so music plays while Claude works.

Update the project's `.claude/settings.json` to add the hooks. Use the plugin root directory path (parent of `commands` where this file lives).

The hooks config should be:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"<PLUGIN_ROOT>/wee-music.sh\" start",
            "async": true
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"<PLUGIN_ROOT>/wee-music.sh\" done",
            "async": true
          }
        ]
      }
    ]
  }
}
```

Replace `<PLUGIN_ROOT>` with the actual plugin directory path.

If `.claude/settings.json` already exists, merge the hooks into it (don't overwrite other settings). If the hooks are already present, just tell the user music is already enabled.

Tell the user music is now enabled and will play next time Claude starts working.
