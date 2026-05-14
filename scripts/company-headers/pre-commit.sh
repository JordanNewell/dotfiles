#!/usr/bin/env bash
#
# SPDX-License-Identifier: LicenseRef-AnythingXYZ-Proprietary
# Copyright (c) 2026 Anything XYZ
# Author: dev23xyz-oss
# Company: Anything XYZ
# Product: Company Headers Toolkit
#
# @file: pre-commit.sh
# @description: Pre-commit hook to check for company headers

set -euo pipefail

# Find company headers toolkit
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run header check
echo "🔍 Checking company headers..."
bash "$SCRIPT_DIR/apply-headers.sh" --check

# Exit with the result of the check
exit $?
