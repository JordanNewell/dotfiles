# Editor Configuration

This directory contains editor-specific settings that can be synced across machines.

## Structure

```
.config/
├── code/           # VSCode settings
├── cursor/         # Cursor settings
└── README.md       # This file
```

## Adding Editor Settings

### VSCode (Cursor compatible)

Settings are stored in `settings.json`:

```json
{
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "files.exclude": {
    "**/.git": true,
    "**/node_modules": true
  }
}
```

To use these settings, symlink to your VSCode directory:

```bash
# On Windows
ln -s ~/dotfiles/.config/code/settings.json "$APPDATA/Code/User/settings.json"

# Or for Cursor
ln -s ~/dotfiles/.config/code/settings.json "$APPDATA/Cursor/User/settings.json"
```

### Recommended Settings to Add

- `settings.json` - Editor preferences
- `keybindings.json` - Custom keyboard shortcuts
- `snippets/` - Code snippets
- `.editorconfig` - Universal editor settings (already in dotfiles root)

## Notes

- Settings stored here are portable and version-controlled
- Don't add secrets or machine-specific paths
- Use environment variables for paths when needed
