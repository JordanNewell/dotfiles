#!/usr/bin/env bash
#
# SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
# Copyright (c) 2025 Anything XYZ
#

# Note: set -euo pipefail disabled - handle errors explicitly

# Color output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Defaults
DEFAULT_COMPANY="Anything XYZ"
DEFAULT_AUTHOR=$(git config user.name 2>/dev/null || echo "dev23xyz-oss")
DEFAULT_EMAIL=$(git config user.email 2>/dev/null || echo "dev.23.xyz@gmail.com")
YEAR=$(date +%Y)

# Detect project metadata
detect_project_metadata() {
    local project_dir="${1:-.}"
    local project_name=""
    local product_name=""
    local description=""

    # Try to get project name from various sources (priority order)
    if [[ -f "$project_dir/package.json" ]]; then
        project_name=$(jq -r '.name // empty' "$project_dir/package.json" 2>/dev/null || echo "")
        description=$(jq -r '.description // empty' "$project_dir/package.json" 2>/dev/null || echo "")
    elif [[ -f "$project_dir/pyproject.toml" ]]; then
        project_name=$(grep -E '^name\s*=' "$project_dir/pyproject.toml" | sed 's/name\s*=\s*["'\'']\?//;s/["'\'']\?$//' | head -1 || echo "")
        description=$(grep -E '^description\s*=' "$project_dir/pyproject.toml" | sed 's/description\s*=\s*["'\'']\?//;s/["'\'']\?$//' | head -1 || echo "")
    elif [[ -f "$project_dir/Cargo.toml" ]]; then
        project_name=$(grep -E '^name\s*=' "$project_dir/Cargo.toml" | sed 's/name\s*=\s*["'\'']\?//;s/["'\'']\?$//' | head -1 || echo "")
        description=$(grep -E '^description\s*=' "$project_dir/Cargo.toml" | sed 's/description\s*=\s*["'\'']\?//;s/["'\'']\?$//' | head -1 || echo "")
    elif [[ -f "$project_dir/go.mod" ]]; then
        project_name=$(grep -E '^module\s+' "$project_dir/go.mod" | awk '{print $2}' || echo "")
    fi

    # Fallback to directory name
    if [[ -z "$project_name" ]]; then
        project_name=$(basename "$(cd "$project_dir" && pwd)")
        # Clean up common project name patterns
        project_name="${project_name#python-}"
        project_name="${project_name#node-}"
        project_name="${project_name%.git}"
    fi

    # Use description as product if available, else use project name
    product_name="${description:-$project_name}"

    # Load config override if exists
    local config_dir
    config_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local config_file="$config_dir/config.json"
    local dir_name=""

    if [[ -f "$config_file" ]]; then
        # Get directory name as fallback for config lookup
        dir_name=$(basename "$(cd "$project_dir" 2>/dev/null && pwd)" 2>/dev/null || echo "")

        # Try project name first, then directory name as fallback
        local override
        override=$(jq -r --arg pname "$project_name" --arg dname "$dir_name" '
            .projects[$pname].override // .projects[$dname].override // empty
        ' "$config_file" 2>/dev/null || echo "")

        local product_override
        product_override=$(jq -r --arg pname "$project_name" --arg dname "$dir_name" '
            .projects[$pname].product // .projects[$dname].product // empty
        ' "$config_file" 2>/dev/null || echo "")

        [[ -n "$override" ]] && project_name="$override"
        [[ -n "$product_override" ]] && product_name="$product_override"
    fi

    # Output as JSON for easy parsing
    cat <<EOF
{
  "company": "$DEFAULT_COMPANY",
  "author": "$DEFAULT_AUTHOR",
  "email": "$DEFAULT_EMAIL",
  "year": "$YEAR",
  "project": "$project_name",
  "product": "$product_name"
}
EOF
}

# Run detection if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    detect_project_metadata "${1:-.}"
fi
