# ====================================
# Portable Development Environment
# jrnew's Dotfiles
# ====================================

# Prevent PSReadLine history bloat (was 97K lines / 8.4 MB, causing 80s startup)
Set-PSReadLineOption -MaximumHistoryCount 1000 -ErrorAction SilentlyContinue

# Load environment configuration
$DotfilesDir = Split-Path -Parent $PROFILE
if (Test-Path "$DotfilesDir/.env") {
    Get-Content "$DotfilesDir/.env" | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2].Replace('$HOME', $HOME), "Process")
        }
    }
}

# Environment-aware paths with sensible defaults
$ProjectsRoot = $env:PROJECTS_ROOT ?? "$HOME/projects"
$VaultsDir = $env:VAULTS_DIR ?? "$HOME/vaults"
$DocsDir = $env:DOCS_DIR ?? "$HOME/docs"
$ToolsDir = $env:TOOLS_DIR ?? "$HOME/tools"

# ============================================================================
# NAVIGATION
# ============================================================================

# Development navigation
function dev { Set-Location (Split-Path $ProjectsRoot) }
function projects { Set-Location $ProjectsRoot }
function tools { Set-Location $ToolsDir }

# Project shortcuts
function molana { Set-Location "$ProjectsRoot/molana" }
function m0lhandz { Set-Location "$ProjectsRoot/m0l-handz" }
function curtis { Set-Location "$ProjectsRoot/curtis" }

# Vault shortcuts
function vault { Set-Location $VaultsDir }
function docs { Set-Location $DocsDir }

# ============================================================================
# EDITOR LAUNCHERS
# ============================================================================

function dev-vscode {
    $extensions = if (Test-Path "$ToolsDir/extensions/vscode") { "--extensions-dir $ToolsDir/extensions/vscode" } else { "" }
    & code @extensions @args
}

function dev-cursor {
    $extensions = if (Test-Path "$ToolsDir/extensions/cursor") { "--extensions-dir $ToolsDir/extensions/cursor" } else { "" }
    & cursor @extensions @args
}

# Quick aliases
Set-Alias -Name 'vs' -Value 'dev-vscode' -ErrorAction SilentlyContinue
Set-Alias -Name 'code-dev' -Value 'dev-vscode' -ErrorAction SilentlyContinue
Set-Alias -Name 'cursor-dev' -Value 'dev-cursor' -ErrorAction SilentlyContinue

# ============================================================================
# GIT SHORTCUTS
# ============================================================================

function gst { git status }
function glg { git log --graph --oneline --decorate --all }
function gpp { git pull --rebase && git push }
function gamend { git commit --amend --no-edit }
function gsave { git stash save }
function gpop { git stash pop }

# ============================================================================
# EXTENSION MANAGEMENT
# ============================================================================

if (Test-Path "$ToolsDir/extensions/vscode") {
    function Install-VSCodeExt {
        param([string]$Extension)
        & code --extensions-dir "$ToolsDir/extensions/vscode" --install-extension $Extension
    }
    function List-VSCodeExt {
        & code --extensions-dir "$ToolsDir/extensions/vscode" --list-extensions
    }
}

if (Test-Path "$ToolsDir/extensions/cursor") {
    function Install-CursorExt {
        param([string]$Extension)
        & cursor --extensions-dir "$ToolsDir/extensions/cursor" --install-extension $Extension
    }
    function List-CursorExt {
        & cursor --extensions-dir "$ToolsDir/extensions/cursor" --list-extensions
    }
}

# ============================================================================
# WSL ALIASES
# ============================================================================

function Start-WSL { wsl -d UbuntuMain -- echo "WSL UbuntuMain started" 2>$null }
function wsl-dev { wsl -d UbuntuMain }
function wsl-molana { wsl -d UbuntuMain --cd /mnt/e/dev/projects/molana }
function wsl-handz { wsl -d UbuntuMain --cd /mnt/e/dev/projects/personal/m0l-handz }

Set-Alias -Name wsl-start -Value Start-WSL -ErrorAction SilentlyContinue

# ============================================================================
# CLAUDE CODE CONFIG
# ============================================================================

# Ensure .local\bin is in PATH for native Claude Code
if ($env:Path -notlike '*\.local\bin*') {
    $env:Path += ";$env:USERPROFILE\.local\bin"
}

# Add Go binaries to PATH (for glow, etc.)
$goBin = "$env:USERPROFILE\go\bin"
if ((Test-Path $goBin) -and $env:Path -notlike "*\go\bin*") {
    $env:Path += ";$goBin"
}

# Claude Code UI Settings
$env:CLAUDE_DO_NOT_SHOW_TIPS = "true"

# Function to load web-dev aliases on demand
function Load-WebDevAliases {
    . $env:USERPROFILE\.claude\web-dev-aliases.ps1
}

# Optional: Uncomment to load web-dev aliases automatically
# Load-WebDevAliases

# ============================================================================
# MARKDOWN VIEWER
# ============================================================================

function mdview {
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    # Find available markdown viewers
    $viewer = $null
    if (Get-Command glow -ErrorAction SilentlyContinue) {
        $viewer = "glow"
    } elseif (Get-Command bat -ErrorAction SilentlyContinue) {
        $viewer = "bat"
    } else {
        $viewer = "cat"
    }

    # If no path provided, show interactive picker
    if ([string]::IsNullOrWhiteSpace($Path)) {
        Write-Host "`n📄 Markdown File Picker`n" -ForegroundColor Cyan
        Write-Host "Common locations:`n" -ForegroundColor Gray

        # Get markdown files from common locations
        $files = @()

        $locations = @(
            "$env:USERPROFILE\Documents\GitHub",
            "$env:PROJECTS_ROOT",
            "$env:VAULTS_DIR ?? $HOME\vaults",
            $PWD.Path
        )

        foreach ($loc in $locations) {
            if (Test-Path $loc) {
                $files += Get-ChildItem -Path $loc -Filter "*.md" -Recurse -Depth 2 -ErrorAction SilentlyContinue
            }
        }

        # Remove duplicates and sort
        $files = $files | Sort-Object FullName -Unique | Select-Object -First 50

        if ($files.Count -eq 0) {
            Write-Host "No markdown files found.`n" -ForegroundColor Yellow
            $Path = Read-Host "Enter path to .md file (or press Enter to search current dir)"
            if ([string]::IsNullOrWhiteSpace($Path)) {
                $files = Get-ChildItem -Path $PWD -Filter "*.md" -Recurse
            }
        }

        # Display numbered menu
        for ($i = 0; $i -lt $files.Count; $i++) {
            $relativePath = $files[$i].FullName.Replace($HOME, "~")
            Write-Host "[$($i + 1)] " -NoNewline -ForegroundColor Green
            Write-Host $relativePath
        }

        if ($files.Count -gt 0) {
            Write-Host "`nSelect file (1-$($files.Count)) or path: " -NoNewline -ForegroundColor Cyan
            $selection = Read-Host

            if ($selection -match '^\d+$' -and [int]$selection -ge 1 -and [int]$selection -le $files.Count) {
                $Path = $files[[int]$selection - 1].FullName
            } else {
                $Path = $selection
            }
        } else {
            return
        }
    }

    # Expand ~ and resolve path
    $Path = $Path.Replace('~', $HOME)
    if (Test-Path $Path) {
        $Path = (Resolve-Path $Path).Path
    }

    # Validate file exists
    if (-not (Test-Path $Path)) {
        Write-Host "`n❌ File not found: $Path`n" -ForegroundColor Red
        return
    }

    # View the file
    $filename = Split-Path $Path -Leaf
    Write-Host "`n📖 $filename`n" -ForegroundColor Cyan

    switch ($viewer) {
        "glow" { & glow $Path }
        "bat" { & bat --language md $Path }
        default { Get-Content $Path }
    }
}

Set-Alias -Name 'md' -Value 'mdview' -ErrorAction SilentlyContinue

# ============================================================================
# MCP CONFIG SWITCHER
# ============================================================================

function mcp-config {
    param([string]$Preset)
    $mcpDir = "$env:USERPROFILE\.claude"
    $active = "$mcpDir\.mcp.json"

    if (-not $Preset) {
        # Show current state
        $size = (Get-Content $active -Raw | ConvertFrom-Json).mcpServers.PSObject.Properties.Count
        Write-Host "Current: $size servers" -ForegroundColor Cyan
        Write-Host "Usage: mcp-config minimal | full" -ForegroundColor Gray
        return
    }

    switch ($Preset) {
        'minimal' {
            Copy-Item "$mcpDir\.mcp-minimal.json" $active -Force
            Write-Host "Switched to MINIMAL (4 servers)" -ForegroundColor Green
        }
        'full' {
            Copy-Item "$mcpDir\.mcp-full.json" $active -Force
            Write-Host "Switched to FULL (12 servers)" -ForegroundColor Green
        }
        default {
            Write-Host "Unknown preset. Use: minimal | full" -ForegroundColor Red
        }
    }
    Write-Host "Restart Claude Code for changes to take effect." -ForegroundColor Yellow
}

# ============================================================================
# WELCOME MESSAGE
# ============================================================================

Write-Host "🚀 jrnew's dev environment loaded!" -ForegroundColor Green
Write-Host "   Projects: $ProjectsRoot" -ForegroundColor Cyan
Write-Host "   Type 'projects' to go there" -ForegroundColor Gray
