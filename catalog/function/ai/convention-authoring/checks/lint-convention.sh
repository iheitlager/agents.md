#!/usr/bin/env bash
# lint-convention.sh — CI check: validates all convention packs in the catalog
#
# Usage:
#   lint-convention.sh [catalog-root]
#
# catalog-root defaults to catalog/ relative to the git root.
#
# Exit codes:
#   0 — all packs valid
#   1 — one or more packs have errors

set -euo pipefail

PACK_ID="function/ai/convention-authoring"
GIT_ROOT="$(git rev-parse --show-toplevel)"
CATALOG_ROOT="${1:-${GIT_ROOT}/catalog}"
TOTAL_ERRORS=0
TOTAL_PACKS=0

# ─── helpers ──────────────────────────────────────────────────────────────────

ok()  { echo "[${PACK_ID}] OK: $*"; }
err() { echo "[${PACK_ID}] ERROR: $*" >&2; }

toml_field_present() {
  local file="$1" field="$2"
  grep -qE "^${field}\s*=" "$file"
}

get_toml_string() {
  local file="$1" field="$2"
  grep -E "^${field}" "$file" | head -1 | sed 's/[^"]*"\([^"]*\)".*/\1/'
}

# ─── validate single pack ─────────────────────────────────────────────────────

validate_pack() {
  local pack_dir="$1"
  local pack_errors=0
  local manifest="${pack_dir}/manifest.toml"
  local agents_md="${pack_dir}/AGENTS.md"

  # 1. manifest.toml must exist
  if [[ ! -f "$manifest" ]]; then
    err "${pack_dir}: manifest.toml not found"
    return 1
  fi

  # 2. Required fields
  for field in id name description version aae_level; do
    if ! toml_field_present "$manifest" "$field"; then
      err "${pack_dir}: manifest.toml missing required field '${field}'"
      pack_errors=$((pack_errors + 1))
    fi
  done

  # 3. description must not be empty string
  local description
  description=$(get_toml_string "$manifest" "description")
  if [[ -z "$description" ]]; then
    err "${pack_dir}: manifest.toml description is empty"
    pack_errors=$((pack_errors + 1))
  fi

  # 4. AAE level valid
  local aae_level
  aae_level=$(get_toml_string "$manifest" "aae_level")
  if [[ ! "$aae_level" =~ ^L[1-4]$ ]]; then
    err "${pack_dir}: aae_level '${aae_level}' invalid (must be L1–L4)"
    pack_errors=$((pack_errors + 1))
  fi

  # 5. AAE level consistent with directory content
  local hooks_dir="${pack_dir}/hooks"
  local checks_dir="${pack_dir}/checks"

  case "$aae_level" in
    L3)
      if [[ ! -d "$hooks_dir" ]] || [[ -z "$(find "$hooks_dir" -type f ! -name '.gitkeep' 2>/dev/null)" ]]; then
        err "${pack_dir}: aae_level=L3 requires a non-empty hooks/ directory"
        pack_errors=$((pack_errors + 1))
      fi
      ;;
    L4)
      if [[ ! -d "$hooks_dir" ]] || [[ -z "$(find "$hooks_dir" -type f ! -name '.gitkeep' 2>/dev/null)" ]]; then
        err "${pack_dir}: aae_level=L4 requires a non-empty hooks/ directory"
        pack_errors=$((pack_errors + 1))
      fi
      if [[ ! -d "$checks_dir" ]] || [[ -z "$(find "$checks_dir" -type f ! -name '.gitkeep' 2>/dev/null)" ]]; then
        err "${pack_dir}: aae_level=L4 requires a non-empty checks/ directory"
        pack_errors=$((pack_errors + 1))
      fi
      ;;
  esac

  # 6. AGENTS.md exists
  if [[ ! -f "$agents_md" ]]; then
    err "${pack_dir}: AGENTS.md not found"
    pack_errors=$((pack_errors + 1))
  else
    local pack_id
    pack_id=$(get_toml_string "$manifest" "id")

    # 7. Section markers
    if ! grep -qF "<!-- BEGIN pack: ${pack_id} -->" "$agents_md"; then
      err "${pack_dir}: AGENTS.md missing <!-- BEGIN pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
    if ! grep -qF "<!-- END pack: ${pack_id} -->" "$agents_md"; then
      err "${pack_dir}: AGENTS.md missing <!-- END pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi

    # 8. Acceptance criteria section present
    if ! grep -q "### Acceptance criteria" "$agents_md"; then
      err "${pack_dir}: AGENTS.md missing '### Acceptance criteria' section"
      pack_errors=$((pack_errors + 1))
    fi
  fi

  # 9. CLAUDE.md markers (if present)
  local claude_md="${pack_dir}/CLAUDE.md"
  if [[ -f "$claude_md" ]]; then
    local pack_id
    pack_id=$(get_toml_string "$manifest" "id")
    if ! grep -qF "<!-- BEGIN pack: ${pack_id} -->" "$claude_md"; then
      err "${pack_dir}: CLAUDE.md missing <!-- BEGIN pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
    if ! grep -qF "<!-- END pack: ${pack_id} -->" "$claude_md"; then
      err "${pack_dir}: CLAUDE.md missing <!-- END pack: ${pack_id} --> marker"
      pack_errors=$((pack_errors + 1))
    fi
  fi

  # 10. Script files must be executable
  for script_dir in "$hooks_dir" "$checks_dir"; do
    if [[ -d "$script_dir" ]]; then
      while IFS= read -r script; do
        if [[ ! -x "$script" ]]; then
          err "${script}: not executable"
          pack_errors=$((pack_errors + 1))
        fi
      done < <(find "$script_dir" -type f ! -name '.gitkeep')
    fi
  done

  # 11. Pack is registered in catalog/index.toml
  local index="${CATALOG_ROOT}/index.toml"
  local pack_id
  pack_id=$(get_toml_string "$manifest" "id")
  if [[ -f "$index" ]] && ! grep -qF "id = \"${pack_id}\"" "$index"; then
    err "${pack_dir}: pack '${pack_id}' not registered in catalog/index.toml"
    pack_errors=$((pack_errors + 1))
  fi

  TOTAL_ERRORS=$((TOTAL_ERRORS + pack_errors))
  return $pack_errors
}

# ─── find and validate all packs ──────────────────────────────────────────────

echo "[${PACK_ID}] Linting convention packs in: ${CATALOG_ROOT}"
echo ""

while IFS= read -r manifest; do
  pack_dir="$(dirname "$manifest")"
  # Skip _template
  [[ "$(basename "$pack_dir")" == "_template" ]] && continue

  TOTAL_PACKS=$((TOTAL_PACKS + 1))
  if validate_pack "$pack_dir"; then
    ok "$pack_dir"
  fi
done < <(find "$CATALOG_ROOT" -name "manifest.toml" | sort)

echo ""
echo "[${PACK_ID}] Checked ${TOTAL_PACKS} pack(s)."

if [[ $TOTAL_ERRORS -gt 0 ]]; then
  echo "[${PACK_ID}] ${TOTAL_ERRORS} error(s) found."
  exit 1
fi

echo "[${PACK_ID}] All packs valid."
exit 0
