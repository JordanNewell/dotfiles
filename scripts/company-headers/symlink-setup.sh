#!/usr/bin/env bash
#
# SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
# Copyright (c) 2025 Anything XYZ
# Author: dev23xyz-oss
# Company: Anything XYZ
# Product: Company Headers Toolkit
#
# @file: symlink-setup.sh
# @description: Add symlink to company-headers toolkit in any project
# @usage: bash symlink-setup.sh [/path/to/project]
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"
SCRIPTS_DIR="$TARGET_DIR/scripts"

# Create scripts directory if needed
mkdir -p "$SCRIPTS_DIR"

# Create symlink
LINK="$SCRIPTS_DIR/company-headers"

if [[ -L "$LINK" ]]; then
    echo "✓ Symlink already exists: $LINK"
    echo "  → $(readlink "$LINK")"
    exit 0
fi

if [[ -e "$LINK" ]]; then
    echo "⚠️  File exists at $LINK (not a symlink). Remove it first."
    exit 1
fi

ln -s "$SCRIPT_DIR" "$LINK"
echo "✓ Created symlink: $LINK → $SCRIPT_DIR"
echo ""
echo "Now you can run from anywhere in the project:"
echo "  bash scripts/company-headers/apply-headers.sh"
