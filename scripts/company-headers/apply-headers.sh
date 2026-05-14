#!/usr/bin/env bash
#
# SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
# Copyright (c) 2025 Anything XYZ
# Author: Anything XYZ Development Team
# Company: Anything XYZ
# Product: Company Headers Toolkit
#
# @file: apply-headers.sh
# @description: Apply company headers to source files across the project
# @usage: bash apply-headers.sh [--dry-run] [--check] [--verbose] [path]
#

# Note: No set -e because ((var++)) returns 1 when result is 0
# We handle errors explicitly with || true where needed

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

# Options
DRY_RUN=false
CHECK_ONLY=false
VERBOSE=false
TARGET_PATH="${1:-.}"

# Parse arguments
TARGET_PATH="."
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true; shift ;;
        --check) CHECK_ONLY=true; shift ;;
        --verbose|-v) VERBOSE=true; shift ;;
        --path|-p) TARGET_PATH="$2"; shift 2 ;;
        *)
            if [[ -d "$1" ]]; then
                TARGET_PATH="$1"
            fi
            shift
            ;;
    esac
done

log() { echo -e "${BLUE}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }

# Detect project metadata
log "Detecting project metadata..."
METADATA=$("$SCRIPT_DIR/detect-metadata.sh" "$TARGET_PATH")

COMPANY=$(echo "$METADATA" | jq -r '.company')
AUTHOR=$(echo "$METADATA" | jq -r '.author')
YEAR=$(echo "$METADATA" | jq -r '.year')
PROJECT=$(echo "$METADATA" | jq -r '.project')
PRODUCT=$(echo "$METADATA" | jq -r '.product')

[[ "$VERBOSE" == true ]] && cat <<EOF
─────────────────────────────────────
📋 Project Metadata
─────────────────────────────────────
Company:    $COMPANY
Author:     $AUTHOR
Year:       $YEAR
Project:    $PROJECT
Product:    $PRODUCT
─────────────────────────────────────
EOF

# File type mappings
declare -A TEMPLATE_MAP=(
    ["py"]="python"
    ["pyi"]="python"
    ["js"]="javascript"
    ["jsx"]="javascript"
    ["ts"]="javascript"
    ["tsx"]="javascript"
    ["mjs"]="javascript"
    ["cjs"]="javascript"
    ["sh"]="shell"
    ["bash"]="shell"
    ["zsh"]="shell"
    ["go"]="go"
    ["mod"]="go"
    ["rs"]="rust"
    ["sql"]="sql"
    ["yml"]="yaml"
    ["yaml"]="yaml"
)

# Get template for file extension
get_template() {
    local ext="$1"
    local template="${TEMPLATE_MAP[$ext]:-}"

    if [[ -z "$template" ]]; then
        return 1
    fi

    local template_file="$TEMPLATE_DIR/$template.txt"
    if [[ ! -f "$template_file" ]]; then
        warn "No template found for extension: $ext"
        return 1
    fi

    cat "$template_file"
}

# Generate header with variables substituted
generate_header() {
    local template="$1"
    echo "$template" | sed \
        -e "s/{{YEAR}}/$YEAR/g" \
        -e "s/{{COMPANY}}/$COMPANY/g" \
        -e "s/{{AUTHOR}}/$AUTHOR/g" \
        -e "s/{{PRODUCT}}/$PRODUCT/g" \
        -e "s/{{PROJECT}}/$PROJECT/g"
}

# Check if file already has header
has_header() {
    local file="$1"
    local first_line
    first_line=$(head -1 "$file")

    # Check for SPDX identifier or copyright in first 10 lines
    head -10 "$file" | grep -q "SPDX-License-Identifier\|Copyright.*$COMPANY"
}

# Apply header to file
apply_header() {
    local file="$1"
    local basename="${file##*/}"
    local ext="${file##*.}"
    local template

    # Special handling for Dockerfile
    if [[ "$basename" == Dockerfile* ]]; then
        template="dockerfile"
    else
        template=$(get_template "$ext") || return 0
    fi

    if has_header "$file"; then
        [[ "$VERBOSE" == true ]] && echo "  ✓ Already has header: $file"
        return 0
    fi

    local header
    header=$(generate_header "$template")

    if [[ "$CHECK_ONLY" == true ]]; then
        error "Missing header: $file"
        return 1
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "  → Would add header to: $file"
        return 0
    fi

    # Create backup
    local backup="${file}.bak"
    cp "$file" "$backup"

    # Add header (handle shebangs)
    if head -1 "$file" | grep -q "^#!"; then
        # File has shebang - insert after first line
        {
            head -1 "$file"
            echo ""
            echo "$header"
            echo ""
            tail -n +2 "$file"
        } > "${file}.tmp"
    else
        # No shebang - insert at beginning
        {
            echo "$header"
            echo ""
            cat "$file"
        } > "${file}.tmp"
    fi

    mv "${file}.tmp" "$file"
    success "Added header to: $file"
    rm -f "$backup"
}

# Find and process files
process_files() {
    local base_path="$1"
    local files_processed=0
    local files_updated=0
    local files_missing=0

    # Find source files
    while IFS= read -r -d '' file; do
        ((files_processed++)) || true

        if ! apply_header "$file"; then
            ((files_missing++)) || true
        else
            ((files_updated++)) || true
        fi
    done < <(find "$base_path" \
        -type f \
        \( -name "*.py" -o -name "*.pyi" \
        -o -name "*.js" -o -name "*.jsx" \
        -o -name "*.ts" -o -name "*.tsx" \
        -o -name "*.mjs" -o -name "*.cjs" \
        -o -name "*.sh" -o -name "*.bash" \
        -o -name "*.go" -o -name "*.mod" \
        -o -name "*.rs" \
        -o -name "*.sql" \
        -o -name "*.yml" -o -name "*.yaml" \
        -o -name "Dockerfile" \
        -o -name "Dockerfile.*" \
        \) \
        ! -path "*/node_modules/*" \
        ! -path "*/.venv/*" \
        ! -path "*/venv/*" \
        ! -path "*/build/*" \
        ! -path "*/dist/*" \
        ! -path "*/.next/*" \
        ! -path "*/.output/*" \
        ! -path "*/.turbo/*" \
        ! -path "*/.cache/*" \
        ! -path "*/vendor/*" \
        ! -path "*/.git/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/.pytest_cache/*" \
        ! -path "*/.ruff_cache/*" \
        ! -path "*/.mypy_cache/*" \
        -print0)

    echo ""
    echo "─────────────────────────────────────"
    echo "📊 Summary"
    echo "─────────────────────────────────────"
    echo "Files scanned:   $files_processed"
    if [[ "$CHECK_ONLY" == true ]]; then
        echo "Missing headers: $files_missing"
        [[ $files_missing -gt 0 ]] && return 1 || return 0
    else
        echo "Files updated:   $files_updated"
        echo "Already compliant: $((files_processed - files_updated))"
    fi
    echo "─────────────────────────────────────"
}

# Main
main() {
    if [[ "$DRY_RUN" == true ]]; then
        log "Dry run mode - no files will be modified"
    fi

    if [[ "$CHECK_ONLY" == true ]]; then
        log "Checking for missing headers..."
    else
        log "Applying company headers to source files..."
    fi

    process_files "$TARGET_PATH"
}

main
