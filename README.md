# jrnew's Dotfiles

Personal development environment configuration.

## What's Included

- **PowerShell Profile** - Custom aliases, functions, and dev shortcuts
- **Editor Configs** - VSCode, Cursor, Windsurf settings
- **Git Config** - Aliases, templates, hooks

## Quick Setup

```powershell
# Clone the repo
git clone https://github.com/0xshash/dotfiles.git E:/dev/projects/dotfiles

# Run setup
E:/dev/projects/dotfiles/setup.ps1
```

## Structure

```
dotfiles/
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1    # Main PowerShell profile
├── .config/
│   ├── code/                               # VSCode settings
│   ├── cursor/                             # Cursor settings
│   └── windsurf/                           # Windsurf settings
├── setup.ps1                               # Bootstrap script
└── README.md
```

## Features

### PowerShell Aliases
- `projects` → Navigate to `E:/dev/projects`
- `molana` → Navigate to molana project
- `m0lhandz` → Navigate to m0l-handz project
- `vault` → Navigate to vaults directory

### Editor Launchers
- `vs`, `code-dev` → Launch VSCode with custom extensions
- `cursor-dev` → Launch Cursor with custom extensions

## Maintenance

```powershell
# After making changes:
cd E:/dev/projects/dotfiles
git add .
git commit -m "update: description of changes"
git push
```

## Notes

- Configurations are symlinked to their system locations
- Edit files in `E:/dev/projects/dotfiles/`, changes take effect immediately
- This repo is machine-agnostic — works on any Windows machine
