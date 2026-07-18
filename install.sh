#!/bin/bash
# Jordan Newell's Dotfiles Installer for Git Bash
# Run: bash ~/dotfiles/install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Jordan Newell's Dotfiles Installer (Git Bash)"
echo "=========================================="
echo ""
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# ============================================================================
# CREATE .env IF MISSING
# ============================================================================

if [ ! -f "$DOTFILES_DIR/.env" ]; then
    echo "Creating .env from .env.example..."
    cp "$DOTFILES_DIR/.env.example" "$DOTFILES_DIR/.env"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env with your machine-specific paths!"
    echo "   nano $DOTFILES_DIR/.env"
    echo ""
fi

# ============================================================================
# CREATE BIN DIRECTORY IF MISSING
# ============================================================================

BIN_DIR="$HOME/bin"
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating $BIN_DIR..."
    mkdir -p "$BIN_DIR"
fi

# ============================================================================
# SYMLINK SCRIPTS TO BIN
# ============================================================================

echo "Installing scripts to $BIN_DIR..."

# newproject.sh
if [ -f "$DOTFILES_DIR/../bin/newproject.sh" ]; then
    ln -sf "$DOTFILES_DIR/../bin/newproject.sh" "$BIN_DIR/newproject.sh"
    echo "  ✓ newproject.sh"
fi

# backup-dotfiles.sh
if [ -f "$DOTFILES_DIR/../bin/backup-dotfiles.sh" ]; then
    ln -sf "$DOTFILES_DIR/../bin/backup-dotfiles.sh" "$BIN_DIR/backup-dotfiles.sh"
    echo "  ✓ backup-dotfiles.sh"
fi

echo ""

# ============================================================================
# INSTALL GIT HOOKS
# ============================================================================

echo "Installing git hooks..."

HOOKS_DIR="$DOTFILES_DIR/.git/hooks"

# Copy pre-commit hook if it exists
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    chmod +x "$HOOKS_DIR/pre-commit"
    echo "  ✓ Pre-commit hook installed"
else
    echo "  ℹ️  No pre-commit hook found (skipped)"
fi

echo ""

# ============================================================================
# UPDATE .bashrc IF NEEDED
# ============================================================================

BASHRC="$HOME/.bashrc"
SOURCE_LINE="source \"$DOTFILES_DIR/scripts/load-env.sh\""

if ! grep -q "load-env.sh" "$BASHRC" 2>/dev/null; then
    echo "Adding load-env.sh to .bashrc..."
    echo "" >> "$BASHRC"
    echo "# Load portable environment from dotfiles" >> "$BASHRC"
    echo "$SOURCE_LINE" >> "$BASHRC"
    echo "  ✓ .bashrc updated"
else
    echo "  ✓ .bashrc already configured"
fi

echo ""

# ============================================================================
# SETUP GIT CONFIG
# ============================================================================

echo "Setting up Git configuration..."

# Symlink shared .gitconfig
GITCONFIG="$DOTFILES_DIR/.gitconfig"
GITCONFIG_TARGET="$HOME/.gitconfig"

if [ -f "$GITCONFIG" ]; then
    ln -sf "$GITCONFIG" "$GITCONFIG_TARGET"
    echo "  ✓ .gitconfig symlinked"
fi

# Create .gitconfig.local from example if missing
GITCONFIG_LOCAL="$HOME/.gitconfig.local"
GITCONFIG_LOCAL_EXAMPLE="$DOTFILES_DIR/.gitconfig.local.example"

if [ ! -f "$GITCONFIG_LOCAL" ] && [ -f "$GITCONFIG_LOCAL_EXAMPLE" ]; then
    echo ""
    echo "  ⚠️  Creating ~/.gitconfig.local from example..."
    cp "$GITCONFIG_LOCAL_EXAMPLE" "$GITCONFIG_LOCAL"
    echo "  ✓ ~/.gitconfig.local created - edit with your personal details"
else
    echo "  ✓ .gitconfig.local already exists"
fi

echo ""
echo ""

# ============================================================================
# COMPLETE
# ============================================================================

echo "=========================================="
echo "✅ Installation complete!"
echo "=========================================="
echo ""
echo "Restart your shell (Git Bash) to use your new configuration."
echo ""
echo "After restart, try these commands:"
echo "  projects    # Go to your projects directory"
echo "  vault       # Go to your vaults directory"
echo "  tools       # Go to your tools directory"
echo ""
