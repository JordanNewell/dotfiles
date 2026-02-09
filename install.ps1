# jrnew's Dotfiles Installer
# Run: pwsh -ExecutionPolicy Bypass -File E:/dev/projects/dotfiles/install.ps1

$ErrorActionPreference = "Stop"

# Get actual PowerShell profile path
$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent

Write-Host "Installing PowerShell profile..." -ForegroundColor Cyan
Write-Host "Target: $profilePath" -ForegroundColor Gray

# Create profile directory if needed
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Host "Created directory: $profileDir" -ForegroundColor Green
}

# Copy profile
Copy-Item "E:/dev/projects/dotfiles/powershell/Microsoft.PowerShell_profile.ps1" $profilePath -Force
Write-Host "✅ Profile installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Restart PowerShell to use your new profile." -ForegroundColor Yellow
Write-Host "After restart, try: projects, molana, m0lhandz, vault" -ForegroundColor Cyan
