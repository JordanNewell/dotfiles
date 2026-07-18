#!/bin/bash
# Portable environment loader for Jordan Newell's dotfiles
# Loads .env file with fallback to sensible defaults

# Find dotfiles directory (works even if this script is symlinked)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load .env if it exists
ENV_FILE="$DOTFILES_DIR/.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# Export with defaults (can be overridden by .env)
export PROJECTS_ROOT="${PROJECTS_ROOT:-$HOME/projects}"
export TEMPLATES_DIR="${TEMPLATES_DIR:-$HOME/templates}"
export VAULTS_DIR="${VAULTS_DIR:-$HOME/vaults}"
export DOCS_DIR="${DOCS_DIR:-$HOME/docs}"
export TOOLS_DIR="${TOOLS_DIR:-$HOME/tools}"

# Debug: uncomment to see what's being loaded
# echo "Loaded environment from dotfiles:"
# echo "  PROJECTS_ROOT: $PROJECTS_ROOT"
# echo "  TEMPLATES_DIR: $TEMPLATES_DIR"
# echo "  VAULTS_DIR: $VAULTS_DIR"
# echo "  DOCS_DIR: $DOCS_DIR"
# echo "  TOOLS_DIR: $TOOLS_DIR"
