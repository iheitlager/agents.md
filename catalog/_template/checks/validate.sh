#!/usr/bin/env bash
# CI validation script template for convention packs (AAE L4)
# Run this in your pipeline to enforce pack standards.

set -euo pipefail

ERRORS=0

echo "[pack] Running CI validation checks..."

# Add your checks here. Set ERRORS=$((ERRORS + 1)) for each failure.

# Example: verify tool version
# if ! tool --version &>/dev/null; then
#   echo "ERROR: 'tool' is not installed or not on PATH"
#   ERRORS=$((ERRORS + 1))
# fi

if [[ $ERRORS -gt 0 ]]; then
  echo "[pack] $ERRORS check(s) failed."
  exit 1
fi

echo "[pack] All CI checks passed."
