# ====================================
# Professional Development Environment
# jrnew's Dotfiles
# ====================================

# Development navigation (updated to E: drive)
function dev { Set-Location "E:/dev" }
function projects { Set-Location "E:/dev/projects" }
function tools { Set-Location "E:/dev/tools" }

# Project shortcuts
function molana { Set-Location "E:/dev/projects/molana" }
function m0lhandz { Set-Location "E:/dev/projects/m0l-handz" }
function curtis { Set-Location "E:/dev/projects/curtis" }

# Vault shortcuts
function vault { Set-Location "E:/vaults" }
function docs { Set-Location "C:/Users/jrnew/docs" }

# Smart editor launchers
function dev-vscode {
    $extensions = if (Test-Path "E:/dev/tools/extensions/vscode") { "--extensions-dir E:/dev/tools/extensions/vscode" } else { "" }
    & code @extensions @args
}

function dev-cursor {
    $extensions = if (Test-Path "E:/dev/tools/extensions/cursor") { "--extensions-dir E:/dev/tools/extensions/cursor" } else { "" }
    & cursor @extensions @args
}

# Quick aliases
Set-Alias -Name 'vs' -Value 'dev-vscode'
Set-Alias -Name 'code-dev' -Value 'dev-vscode'
Set-Alias -Name 'cursor-dev' -Value 'dev-cursor'

# Git shortcuts (from git config)
function gst { git status }
function glg { git log --graph --oneline --decorate --all }
function gpp { git pull --rebase && git push }
function gamend { git commit --amend --no-edit }

function gsave { git stash save }
function gpop { git stash pop }

# Extension management (if paths exist)
if (Test-Path "E:/dev/tools/extensions/vscode") {
    function Install-VSCodeExt {
        param([string]$Extension)
        & code --extensions-dir "E:/dev/tools/extensions/vscode" --install-extension $Extension
    }
    function List-VSCodeExt {
        & code --extensions-dir "E:/dev/tools/extensions/vscode" --list-extensions
    }
}

if (Test-Path "E:/dev/tools/extensions/cursor") {
    function Install-CursorExt {
        param([string]$Extension)
        & cursor --extensions-dir "E:/dev/tools/extensions/cursor" --install-extension $Extension
    }
    function List-CursorExt {
        & cursor --extensions-dir "E:/dev/tools/extensions/cursor" --list-extensions
    }
}

Write-Host "🚀 jrnew's dev environment loaded!" -ForegroundColor Green
Write-Host "   Type 'projects' to go to E:/dev/projects" -ForegroundColor Cyan
