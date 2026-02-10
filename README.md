# jrnew's Dotfiles

> **Personal development environment, version controlled.**

Your dotfiles are the configuration files that make your terminal, editors, and tools work the way you like them. By keeping them in a git repo, you can:

- ✅ **Back up automatically** — Every commit is a backup
- ✅ **Sync across machines** — Clone repo, run install, done
- ✅ **Track changes** — Know what changed and when
- ✅ **Share selectively** — Make public or keep private
- ✅ **Recover quickly** — New computer = 5 minutes to setup

---

## 📁 What's Included

```
dotfiles/
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1    # PowerShell aliases, functions, shortcuts
├── scripts/
│   ├── load-env.sh                         # Environment loader with defaults
│   └── cleanup/
│       └── claude-backup-cleanup.sh        # Auto-cleanup for Claude Code backups
├── .env.example                            # Machine-specific config template
├── .editorconfig                           # Universal editor settings
├── install.ps1                             # One-command installer
├── .gitignore                              # What NOT to track
└── README.md                               # This file
```

---

## 🚀 Quick Start

### On a NEW Machine:

```powershell
# 1. Clone the repo
git clone https://github.com/0xshash/dotfiles.git ~/dotfiles

# 2. Create machine-specific environment
cp ~/dotfiles/.env.example ~/dotfiles/.env
# Edit .env with your paths (PROJECTS_ROOT, TEMPLATES_DIR, etc.)

# 3. Install (copies profile to correct location)
cd ~/dotfiles
pwsh -ExecutionPolicy Bypass -File install.ps1

# 4. Restart PowerShell
exit
# Then open new terminal
```

### Setup Project Templates (Optional):

```bash
# Clone templates to your preferred location
git clone https://github.com/0xshash/templates.git ~/templates
# Or set TEMPLATES_DIR in .env to your templates location
```

### On THIS Machine (Already Set Up):

```powershell
# Profile is already installed
# Just edit the file in the dotfiles repo:
code E:/dev/projects/dotfiles/powershell/Microsoft.PowerShell_profile.ps1

# Changes apply after restarting PowerShell
```

---

## 🎯 Available Commands

After installing, restart PowerShell and you'll have:

### Navigation Shortcuts

| Command | Goes To |
|---------|---------|
| `projects` | `E:/dev/projects` |
| `molana` | `E:/dev/projects/molana` |
| `m0lhandz` | `E:/dev/projects/m0l-handz` |
| `curtis` | `E:/dev/projects/curtis` |
| `vault` | `E:/vaults` |
| `docs` | `C:/Users/jrnew/docs` |
| `dev` | `E:/dev` |
| `tools` | `E:/dev/tools` |

### Git Shortcuts (from your git config)

| Command | Equivalent To |
|---------|---------------|
| `gst` | `git status` |
| `glg` | `git log --graph --oneline --decorate --all` |
| `gpp` | `git pull --rebase && git push` |
| `gamend` | `git commit --amend --no-edit` |
| `gsave` | `git stash save` |
| `gpop` | `git stash pop` |

### Editor Launchers

| Command | Action |
|---------|--------|
| `vs` or `code-dev` | Launch VSCode with custom extensions |
| `cursor-dev` | Launch Cursor with custom extensions |

### Maintenance Commands

| Command | Action |
|---------|--------|
| `clean-temp` | Remove temp files (*.tmp, *.log) from home |
| `clean-cache` | Show cache directories to clean |
| `clean-claude-backups` | Move Claude Code backup files to backup dir |

**Auto-cleanup:** Claude backups are automatically cleaned when you open a new terminal (runs silently in background).

---

## 📦 Project Templates

Use the `newproject` command to scaffold new projects from templates:

```bash
newproject my-app next-fullstack    # Next.js full-stack app
newproject my-api node-api          # Node.js API service
newproject my-service python-service # Python service
```

### Available Templates

| Template | Description |
|----------|-------------|
| `next-fullstack` | Next.js 15 + Prisma + Radix UI + TypeScript |
| `node-api` | Hono + TypeScript API service |
| `python-service` | Poetry + Python service |

### Creating Projects

Projects are created at `$PROJECTS_ROOT` (configured in `.env`):
- Defaults to `~/projects`
- Override in `~/.dotfiles/.env`

---

## 🔧 Portable Configuration

### Environment Variables

The `.env` file in your dotfiles directory controls machine-specific paths:

```bash
PROJECTS_ROOT="~/projects"      # Where projects are created
TEMPLATES_DIR="~/templates"     # Where templates live
VAULTS_DIR="~/vaults"           # Your Obsidian vaults
TOOLS_DIR="~/tools"             # Development tools
BACKUP_DIR="~/Backups"          # Where backups are stored (Claude, etc.)
```

These variables are used by:
- PowerShell navigation functions (`projects`, `vault`, `tools`)
- `newproject` script
- All portable scripts

### Benefits of Portable Configuration

| Before | After |
|--------|-------|
| Hardcoded paths everywhere | Works on any machine |
| Breaks when reorganizing | Change one `.env` file |
| Different scripts per machine | Same scripts everywhere |

---

## 🛠️ How It Works

### The Problem This Solves

**Without dotfiles:**
```
❌ New computer → manually install everything
❌ Drive fails → lose all your customizations
❌ Forgot that cool alias → can't find it
❌ Settings scattered across system → hard to backup
```

**With dotfiles:**
```
✅ New computer → clone repo, run install, done
✅ Drive fails → clone repo from GitHub, restore in minutes
✅ All configs in one place → easy to find
✅ Git history → see every change ever made
```

### How Profiles Work

Your PowerShell profile is a script that runs **every time you start PowerShell**. It's located at:

```
C:/Users/jrnew/Documents/PowerShell/Microsoft.PowerShell_profile.ps1
```

Instead of editing that file directly, we:

1. **Edit the version in the dotfiles repo**
2. **Copy it to the profile location** (via `install.ps1`)
3. **Commit changes to git** (backup + version control)

```
┌─────────────────────────────────────────────────────────────┐
│  You edit:                                                  │
│  E:/dev/projects/dotfiles/powershell/Microsoft.PowerShell_  │
│                           profile.ps1                        │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │  Run: install.ps1
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  PowerShell uses:                                           │
│  C:/Users/jrnew/Documents/PowerShell/Microsoft.PowerShell_  │
│                           profile.ps1                       │
└─────────────────────────────────────────────────────────────┘
```

### Portable Environment with .env

Instead of hardcoding paths, your setup uses environment variables:

```
┌─────────────────────────────────────────────────────────────┐
│  You configure:                                             │
│  ~/dotfiles/.env                                            │
│                                                             │
│  PROJECTS_ROOT="~/projects"                                 │
│  VAULTS_DIR="~/vaults"                                      │
│  TOOLS_DIR="~/tools"                                        │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │  Load on startup
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  PowerShell profile uses:                                   │
│  $env:PROJECTS_ROOT → navigate anywhere                    │
│  $env:VAULTS_DIR   → vaults on any machine                  │
└─────────────────────────────────────────────────────────────┘
```

### Universal Editor Config

The `.editorconfig` file ensures consistent coding style across all editors:
- VSCode, Cursor, JetBrains, Sublime, etc.
- Automatic indentation, line endings, charset
- No need for per-editor configuration

---

## 📝 Maintenance

### Making Changes:

```powershell
# 1. Edit the profile in the dotfiles repo
code E:/dev/projects/dotfiles/powershell/Microsoft.PowerShell_profile.ps1

# 2. Test changes (restart PowerShell)

# 3. Reinstall to copy to profile location
pwsh -ExecutionPolicy Bypass -File E:/dev/projects/dotfiles/install.ps1

# 4. Commit to git
cd E:/dev/projects/dotfiles
git add .
git commit -m "feat: add new shortcut"
git push
```

### Adding a New Shortcut:

Edit `powershell/Microsoft.PowerShell_profile.ps1`:

```powershell
# Add your function
function myproject { Set-Location "E:/dev/projects/myproject" }

# Add alias (optional)
Set-Alias -Name 'mp' -Value 'myproject'
```

Then reinstall and commit.

---

## 🔐 Security Notes

### What to NEVER Commit:

- API keys or tokens
- Passwords
- Private SSH keys
- Machine-specific paths (use environment variables)
- Personal data

### What's Safe to Commit:

- Aliases and functions
- Editor settings
- Git configuration
- Appearance preferences
- Tool configurations

---

## 📚 Concepts

### What Are "Dotfiles"?

Historically, Unix configuration files started with a dot (`.bashrc`, `.vimrc`, `.gitconfig`) to be hidden in directory listings. The term "dotfiles" now refers to **all personal configuration files**, regardless of whether they start with a dot.

On Windows, we don't use dots for hiding, but the name stuck.

### Why Not Just Copy-Paste?

| Method | Pros | Cons |
|--------|------|------|
| **Copy-paste to new machine** | Quick manual transfer | No version history, manual each time |
| **Drive backup** | Automatic | Not versioned, hard to restore specific files |
| **Dotfiles repo** | Versioned, shareable, restorable, documented | Requires git knowledge (worth it!) |

---

## 🌐 Community

Many developers share their dotfiles publicly. It's a great way to:

- Discover new tools and configurations
- Learn best practices
- Get inspiration for your own setup

**Famous examples:**
- [GitHub's dotfiles](https://dotfiles.github.io/)
- Search "dotfiles" on GitHub for 100K+ examples

---

## 🆘 Troubleshooting

### Profile not loading?

```powershell
# Check profile location
echo $PROFILE

# Verify file exists
Test-Path $PROFILE

# Check for syntax errors
pwsh -NoProfile -File $PROFILE
```

### Changes not showing?

Restart PowerShell. The profile only loads when you start a new session.

### Need to start without profile?

```powershell
pwsh -NoProfile
```

---

## 📖 Further Reading

- [The Art of Dotfiles](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/)
- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [PowerShell Profiles](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles)

---

**Created:** 2026-02-09
**Maintained by:** jrnew (0xshash)
**License:** MIT (feel free to use and adapt)
