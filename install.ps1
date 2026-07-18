# Jordan Newell's Dotfiles Installer
# Run: pwsh -ExecutionPolicy Bypass -File $HOME/dotfiles/install.ps1

$ErrorActionPreference = "Stop"

# Get actual PowerShell profile path
$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent
$dotfilesDir = "$HOME/dotfiles"

Write-Host "Installing Jordan Newell's dotfiles..." -ForegroundColor Cyan
Write-Host "Dotfiles: $dotfilesDir" -ForegroundColor Gray
Write-Host ""

# ============================================================================
# INSTALL POWERSHELL PROFILE
# ============================================================================

Write-Host "Installing PowerShell profile..." -ForegroundColor Cyan
Write-Host "Target: $profilePath" -ForegroundColor Gray

# Create profile directory if needed
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Host "Created directory: $profileDir" -ForegroundColor Green
}

# Copy profile
Copy-Item "$dotfilesDir/powershell/Microsoft.PowerShell_profile.ps1" $profilePath -Force
Write-Host "✅ Profile installed!" -ForegroundColor Green

# ============================================================================
# INSTALL GIT HOOKS
# ============================================================================

Write-Host ""
Write-Host "Installing git hooks..." -ForegroundColor Cyan

$hooksDir = "$dotfilesDir/.git/hooks"
$hooksDest = "$dotfilesDir/.git/hooks"

# Copy pre-commit hook if it exists
if (Test-Path "$hooksDir/pre-commit") {
    Copy-Item "$hooksDir/pre-commit" "$hooksDest/pre-commit" -Force
    Write-Host "✅ Pre-commit hook installed" -ForegroundColor Green
}

# ============================================================================
# CREATE .env IF MISSING
# ============================================================================

Write-Host ""
if (-not (Test-Path "$dotfilesDir/.env")) {
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item "$dotfilesDir/.env.example" "$dotfilesDir/.env"
    Write-Host "✅ .env created" -ForegroundColor Green
    Write-Host "⚠️  IMPORTANT: Edit .env with your machine-specific paths!" -ForegroundColor Yellow
    Write-Host "   notepad $dotfilesDir/.env" -ForegroundColor Gray
} else {
    Write-Host "✅ .env already configured" -ForegroundColor Green
}

# ============================================================================
# COMPLETE
# ============================================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Restart PowerShell to use your new profile." -ForegroundColor Yellow
Write-Host ""
Write-Host "Available commands:" -ForegroundColor Cyan
Write-Host "  projects    # Go to projects directory" -ForegroundColor Gray
Write-Host "  vault       # Go to vaults directory" -ForegroundColor Gray
Write-Host "  tools       # Go to tools directory" -ForegroundColor Gray
Write-Host "  verify-env  # Verify environment setup" -ForegroundColor Gray
Write-Host ""
