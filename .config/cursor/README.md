# Cursor Editor Settings

Cursor (AI-powered fork of VSCode) is compatible with VSCode settings.

## Setup

Cursor stores settings in:
- Windows: `%APPDATA%/Cursor/User/`

## Quick Setup

Copy the VSCode settings:

```powershell
# PowerShell
Copy-Item ~/dotfiles/.config/code/settings.json $env:APPDATA/Cursor/User/settings.json
```

Or create a symlink (if your system supports it):

```bash
ln -s ~/dotfiles/.config/code/settings.json "$APPDATA/Cursor/User/settings.json"
```

## Cursor-Specific Recommendations

Since Cursor has AI built-in, you might want to add:

```json
{
  "cursor.ai.enabled": true,
  "cursor.ai.autoSuggest": true,
  "editor.inlineSuggest.enabled": true
}
```

Create `cursor/settings.json` for Cursor-specific settings that won't affect VSCode.

## Sharing Settings Between VSCode and Cursor

The `.config/code/` directory works for both editors - they're fully compatible with VSCode settings format.
