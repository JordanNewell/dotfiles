#!/usr/bin/env bash
#
# SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
# Copyright (c) 2026 Anything XYZ
# Author: dev23xyz-oss
# Company: Anything XYZ
# Product: Company Headers Toolkit
#
# @file: setup-hooks.sh
# @description: Install pre-commit hook for company headers validation
# @usage: bash setup-hooks.sh [--global|--local]
#

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly HOOK_SOURCE="$SCRIPT_DIR/pre-commit.sh"
readonly GIT_DIR=$(git rev-parse --git-common-dir 2>/dev/null || echo ".git")
readonly HOOK_TARGET="$GIT_DIR/hooks/pre-commit"

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

show_usage() {
    echo "Usage: $0 [--global|--local]"
    echo ""
    echo "Options:"
    echo "  --global    Install hook to global git template (affects all repos)"
    echo "  --local     Install hook to current repo only (default)"
    exit 1
}

# Parse arguments
INSTALL_MODE="local"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --global) INSTALL_MODE="global"; shift ;;
        --local) INSTALL_MODE="local"; shift ;;
        -h|--help) show_usage ;;
        *) echo "Unknown option: $1"; show_usage ;;
    esac
done

install_local_hook() {
    local repo_root
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -z "$repo_root" ]]; then
        echo "Error: Not in a git repository"
        exit 1
    fi

    echo "Installing pre-commit hook to: $repo_root"

    # Create hooks directory if it doesn't exist
    mkdir -p "$(dirname "$HOOK_TARGET")"

    # Copy hook
    cp "$HOOK_SOURCE" "$HOOK_TARGET"
    chmod +x "$HOOK_TARGET"

    echo -e "${GREEN}✓${NC} Pre-commit hook installed"
    echo ""
    echo "The hook will check for company headers before each commit."
    echo "To skip: git commit --no-verify"
}

install_global_hook() {
    local template_dir
    template_dir=$(git config --global init.templatedir 2>/dev/null || echo "~/.git-template")

    # Expand tilde
    template_dir="${template_dir/#\~/$HOME/}"

    local hook_dir="$template_dir/hooks"
    mkdir -p "$hook_dir"

    local hook_target="$hook_dir/pre-commit"

    echo "Installing global pre-commit hook to: $hook_dir"

    cp "$HOOK_SOURCE" "$hook_target"
    chmod +x "$hook_target"

    # Enable global template
    git config --global init.templatedir "$template_dir"
    git config --global hooks.path "$hook_dir"

    echo -e "${GREEN}✓${NC} Global pre-commit hook installed"
    echo ""
    echo "Run 'git init' in existing repos to use the global hook."
}

# Main
case "$INSTALL_MODE" in
    global)
        # Check if we're in a git repo for global install
        if ! git rev-parse --git-dir >/dev/null 2>&1; then
            echo "Warning: Not in a git repository, but installing global hook anyway."
        fi
        install_global_hook
        ;;
    local)
        install_local_hook
        ;;
esac
