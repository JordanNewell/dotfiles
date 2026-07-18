# Jordan Newell's Dotfiles

> Personal development environment, version controlled.

Dotfiles are the configuration files that make your terminal, editors, and tools work the way you like them. By keeping them in a git repo, you can:

- Back up automatically — every commit is a backup
- Sync across machines — clone repo, run install, done
- Track changes — know what changed and when
- Recover quickly — new computer = 5 minutes to setup

---

## What's included

```
dotfiles/
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1    # PowerShell aliases, functions, shortcuts
├── scripts/
│   ├── load-env.sh                         # Environment loader with defaults
│   └── cleanup/
│       └── claude-backup-cleanup.sh        # Auto-cleanup for Claude Code backups
├── bin/
│   └── audit-creds.sh                      # Quarterly credential audit
├── .env.example                            # Machine-specific config template
├── .editorconfig                           # Universal editor settings
├── .gitconfig                              # Git defaults (includes ~/.gitconfig.local)
├── .bashrc                                 # Bash aliases + PATH additions
├── install.ps1                             # Windows installer
├── install.sh                              # Linux/macOS installer
└── README.md                               # This file
```

---

## Quick start

### On a new machine

```powershell
# 1. Clone
git clone https://github.com/JordanNewell/dotfiles.git ~/dotfiles

# 2. Create machine-specific environment
cp ~/dotfiles/.env.example ~/dotfiles/.env
# Edit .env with your paths (PROJECTS_ROOT, TEMPLATES_DIR, etc.)

# 3. Install (copies profile to correct location)
cd ~/dotfiles
pwsh -ExecutionPolicy Bypass -File install.ps1   # Windows
bash install.sh                                   # Linux/macOS

# 4. Restart shell
```

### Project templates (optional)

```bash
# Set TEMPLATES_DIR in .env to point at your templates location
# newproject scaffolds from templates into $PROJECTS_ROOT
newproject my-app next-fullstack
newproject my-api node-api
newproject my-service python-service
```

---

## Configuration philosophy

### Portable, not hardcoded

Every path reads from environment variables loaded by `scripts/load-env.sh` (or the PowerShell profile on Windows). The `.env` file (gitignored — copy from `.env.example`) is the only machine-specific knob.

```bash
PROJECTS_ROOT="$HOME/projects"     # Where projects are created
TEMPLATES_DIR="$HOME/templates"    # Where templates live
VAULTS_DIR="$HOME/vaults"          # Obsidian vaults (or notes root)
TOOLS_DIR="$HOME/dev/tools"        # Development tools
BACKUP_DIR="$HOME/Backups"         # Where backups go (Claude, etc.)
```

### Profile lives in the repo, gets installed

The profile script lives at `powershell/Microsoft.PowerShell_profile.ps1` in this repo. `install.ps1` copies it to `$PROFILE` on Windows. On Linux/macOS, `install.sh` symlinks `.bashrc` and `bin/` into `$HOME`. Edit the file in the repo, reinstall, commit. Same loop on every machine.

### Editor config is universal

`.editorconfig` enforces indentation, line endings, charset across VSCode, Cursor, JetBrains, Sublime, vim — anywhere the EditorConfig plugin is installed. No per-editor config needed.

---

## Maintenance

```bash
# Edit the profile in the repo
$EDITOR ~/dotfiles/powershell/Microsoft.PowerShell_profile.ps1

# Reinstall (copies to $PROFILE)
pwsh -ExecutionPolicy Bypass -File ~/dotfiles/install.ps1

# Commit
cd ~/dotfiles
git add .
git commit -m "feat: add new shortcut"
git push
```

### Adding a new navigation shortcut

```powershell
# In powershell/Microsoft.PowerShell_profile.ps1
function my-project { Set-Location "$env:PROJECTS_ROOT/my-project" }
Set-Alias -Name 'mp' -Value 'my-project'
```

Uses `$env:PROJECTS_ROOT` instead of a hardcoded path. Works on any machine where `.env` is set up.

---

## Security

### What's safe to commit

- Aliases and shell functions
- Editor settings
- Git defaults (`.gitconfig` — note: personal `user.name` / `user.email` go in `.gitconfig.local`, gitignored)
- Tool configurations
- Theme / appearance preferences

### What to never commit

- API keys, tokens, passwords
- Private SSH keys
- Machine-specific paths (use environment variables)
- Anything in `.env` (the actual file — `.env.example` only)

The `.gitignore` enforces most of this. Run `bin/audit-creds.sh` quarterly as a belt-and-suspenders check.

---

## Why dotfiles

The shape of the problem this solves: a new computer shouldn't take an afternoon to set up. A drive failure shouldn't lose your customizations. A clever alias you wrote six months ago should be findable.

Dotfiles are the standard answer. Clone the repo, run the installer, done. The git history is the documentation.

---

## Further reading

- [The Art of Dotfiles](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/) — anishathalye
- [GitHub Dotfiles](https://dotfiles.github.io/) — community guide + 100K+ examples
- [PowerShell Profiles](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles) — Microsoft Learn

---

MIT licensed. Fork, adapt, make your own.
