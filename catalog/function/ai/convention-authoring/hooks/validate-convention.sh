#!/usr/bin/env bash
# validate-convention.sh — pre-commit hook for convention pack validation (AAE L3/L4)
#
# Usage:
#   validate-convention.sh [pack-path]
#
# When called with a path argument, validates that specific pack.
# When called with no arguments (as a pre-commit hook), validates all
# convention packs that have staged changes.
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more checks failed

set -euo pipefail

PACK_ID="function/ai/convention-authoring"
CATALOG_ROOT="$(git rev-parse --show-toplevel)/catalog"
ERRORS=0

# ─── helpers ──────────────────────────────────────────────────────────────────

ok()  { echo "[${PACK_ID}] OK: $*"; }
err() { echo "[${PACK_ID}] ERROR: $*" >&2; ERRORS=$((ERRORS + 1)); }

# Check if a TOML field exists and is non-empty using grep (no tomlq dependency)
toml_field_present() {
  local file="$1" field="$2"
  grep -qE "^${field}\s*=" "$file"
}

# ─── determine which packs to validate ────────────────────────────────────────

PACKS_TO_CHECK=()

if [[ $# -ge 1 ]]; then
  # Explicit path argument
  PACKS_TO_CHECK=("$1")
else
  # Pre-commit mode: find packs with staged changes
  while IFS= read -r staged_file; do
    # Extract pack path: catalog/<taxonomy>/<category>/<name>/...
    if [[ "$staged_file" =~ ^catalog/([^/]+/[^/]+/[^/]+)/ ]]; then
      pack_path="catalog/${BASH_REMATCH[1]}"
      # Skip _template
      [[ "$pack_path" == "catalog/_template" ]] && continue
      # Add to list if not already present
      if [[ ! " ${PACKS_TO_CHECK[*]:-} " =~ " ${pack_path} " ]]; then
        PACKS_TO_CHECK+=("$pack_path")
      fi
    fi
  done < <(git diff --cached --name-only)
fi

if [[ ${#PACKS_TO_CHECK[@]} -eq 0 ]]; then
  exit 0
fi

# ─── validation ───────────────────────────────────────────────────────────────

validate_pack() {
  local pack_dir="$1"
  local pack_errors=0

  # Normalise: strip trailing slash, make absolute if relative
  pack_dir="${pack_dir%/}"
  [[ "$pack_dir" != /* ]] && pack_dir="${CATALOG_ROOT}/../${pack_dir}"

  local manifest="${pack_dir}/manifest.toml"
  local agents_md="${pack_dir}/AGENTS.md"

  echo ""
  echo "[${PACK_ID}] Validating: ${pack_dir}"

  # 1. manifest.toml must exist
  if [[ ! -f "$manifest" ]]; then
    err "${pack_dir}: manifest.toml not found"
    return 1
  fi

  # 2. Required manifest fields
  for field in id name description version aae_level; do
    if ! toml_field_present "$manifest" "$field"; then
      err "${pack_dir}: manifest.toml missing required field '${field}'"
      pack_errors=$((pack_errors + 1))
    fi
  done

  # 3. AAE level value is valid
  local aae_level
  aae_level=$(grep -E '^aae_level' "$manifest" | head -1 | sed 's/[^"]*"\([^"]*\)".*/\1/')
  if [[ ! "$aae_level" =~ ^L[1-4]$ ]]; then
    err "${pack_dir}: aae_level '${aae_level}' is not valid (must be L1, L2, L3, or L4)"
    pack_errors=$((pack_errors + 1))
  fi

  # 4. AAE level consistency with file presence
  local hooks_dir="${pack_dir}/hooks"
  local checks_dir="${pack_dir}/checks"

  case "$aae_level" in
    L3)
      if [[ ! -d "$hooks_dir" ]] || [[ -z "$(ls -A "$hooks_dir" 2>/dev/null)" ]]; then
        err "${pack_dir}: aae_level is L3 but hooks/ is missing or empty"
        pack_errors=$((pack_errors + 1))
      fi
      ;;
    L4)
      if [[ ! -d "$hooks_dir" ]] || [[ -z "$(ls -A "$hooks_dir" 2>/dev/null)" ]]; then
        err "${pack_dir}: aae_level is L4 but hooks/ is missing or empty"
        pack_errors=$((pack_errors + 1))
      fi
      if [[ ! -d "$checks_dir" ]] || [[ -z "$(ls -A "$checks_dir" 2>/dev/null)" ]]; then
        err "${pack_dir}: aae_level is L4 but checks/ is missing or empty"
        pack_errors=$((pack_errors + 1))
      fi
      ;;
  esac

  # 5. AGENTS.md must exist
  if [[ ! -f "$agents_md" ]]; then
    err "${pack_dir}: AGENTS.md not found"
    pack_errors=$((pack_errors + 1))
  else
    # 6. AGENTS.md must have section markers
    local pack_id
    pack_id=$(grep -E '^id' "$manifest" | head -1 | sed 's/[^"]*"\([^"]*\)".*/\1/')

    if ! grep -qF "<!-- BEGIN pack: ${pack_id} -->" "$agents_md"; then
      err "${pack_dir}: AGENTS.md missing <!-- BEGIN pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
    if ! grep -qF "<!-- END pack: ${pack_id} -->" "$agents_md"; then
      err "${pack_dir}: AGENTS.md missing <!-- END pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
  fi

  # 7. CLAUDE.md section markers (if file exists)
  local claude_md="${pack_dir}/CLAUDE.md"
  if [[ -f "$claude_md" ]]; then
    local pack_id
    pack_id=$(grep -E '^id' "$manifest" | head -1 | sed 's/[^"]*"\([^"]*\)".*/\1/')
    if ! grep -qF "<!-- BEGIN pack: ${pack_id} -->" "$claude_md"; then
      err "${pack_dir}: CLAUDE.md missing <!-- BEGIN pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
    if ! grep -qF "<!-- END pack: ${pack_id} -->" "$claude_md"; then
      err "${pack_dir}: CLAUDE.md missing <!-- END pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
  fi

  # 8. Hook scripts must be executable
  if [[ -d "$hooks_dir" ]]; then
    while IFS= read -r hook_file; do
      if [[ ! -x "$hook_file" ]]; then
        err "${pack_dir}: ${hook_file} is not executable (run: chmod +x ${hook_file})"
        pack_errors=$((pack_errors + 1))
      fi
    done < <(find "$hooks_dir" -type f ! -name '.gitkeep')
  fi

  # 9. CI check scripts must be executable
  if [[ -d "$checks_dir" ]]; then
    while IFS= read -r check_file; do
      if [[ ! -x "$check_file" ]]; then
        err "${pack_dir}: ${check_file} is not executable (run: chmod +x ${check_file})"
        pack_errors=$((pack_errors + 1))
      fi
    done < <(find "$checks_dir" -type f ! -name '.gitkeep')
  fi

  if [[ $pack_errors -eq 0 ]]; then
    ok "${pack_dir}: all checks passed"
  fi

  ERRORS=$((ERRORS + pack_errors))
}

# ─── run ──────────────────────────────────────────────────────────────────────

for pack in "${PACKS_TO_CHECK[@]}"; do
  validate_pack "$pack"
done

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "[${PACK_ID}] ${ERRORS} error(s) found. Fix them before committing."
  exit 1
fi

echo "[${PACK_ID}] All convention packs valid."
exit 0
