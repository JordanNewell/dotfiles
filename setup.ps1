# jrnew's Dotfiles Setup Script
# Run this script to symlink your dotfiles to the correct locations

$DotfilesDir = $PSScriptRoot
$ErrorActionPreference = "Stop"

Write-Host "🚀 Setting up jrnew's dotfiles..." -ForegroundColor Cyan
Write-Host "Dotfiles location: $DotfilesDir" -ForegroundColor Gray

# Function to create symbolic link
function Link-File {
    param(
        [string]$Source,
        [string]$Target,
        [string]$Description
    )

    # Create target directory if it doesn't exist
    $TargetDir = Split-Path $Target -Parent
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    # Remove existing target (file or link)
    if (Test-Path $Target) {
        Remove-Item $Target -Force -Recurse
    }

    # Create symbolic link
    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
    Write-Host "  ✅ $Description → $Target" -ForegroundColor Green
}

# PowerShell Profile
$PowerShellProfile = "$DotfilesDir/powershell/Microsoft.PowerShell_profile.ps1"
if (Test-Path $PowerShellProfile) {
    Link-File $PowerShellProfile $PROFILE "PowerShell profile"
}

# VSCode Settings
$VSCodeDir = "$DotfilesDir/.config/code/User"
$VSCodeTarget = "$env:APPDATA/Code/User"
if (Test-Path $VSCodeDir) {
    Link-File $VSCodeDir $VSCodeTarget "VSCode settings"
}

# Cursor Settings
$CursorDir = "$DotfilesDir/.config/cursor/User"
$CursorTarget = "$env:APPDATA/Cursor/User"
if (Test-Path $CursorDir) {
    Link-File $CursorDir $CursorTarget "Cursor settings"
}

Write-Host ""
Write-Host "✨ Dotfiles setup complete!" -ForegroundColor Green
Write-Host "   Restart PowerShell to see changes" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Quick commands:" -ForegroundColor White
Write-Host "   - projects   → Navigate to projects" -ForegroundColor Gray
Write-Host "   - molana     → Navigate to molana" -ForegroundColor Gray
Write-Host "   - m0lhandz   → Navigate to m0l-handz" -ForegroundColor Gray
Write-Host "   - vault      → Navigate to vaults" -ForegroundColor Gray
Write-Host ""
