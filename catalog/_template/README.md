# Pack Name convention pack

<!-- Replace this file with a human-readable description of your convention pack. -->

## What this pack does

<!-- 1-3 sentences explaining the conventions this pack enforces and why. -->

## Requirements

<!-- Tools, runtimes, or services that must be present for this pack to work. -->

- `tool` >= 1.0.0

## What gets installed

<!-- List what the pack installs into the target project. -->

| File | Destination | Purpose |
|------|-------------|---------|
| `AGENTS.md` fragment | `AGENTS.md` | Agent instructions |
| `hooks/pre-commit` | `.git/hooks/pre-commit` | Enforce before commit |
| `checks/validate.sh` | `ci/checks/validate.sh` | CI enforcement |

## AAE level

**L2 — Soft enforce** (agent instructions only)

<!-- Change to match your manifest.toml aae_level:
     L1 = inform, L2 = soft enforce, L3 = hook enforce, L4 = CI enforce -->

## Conflicts

<!-- List any packs this one conflicts with, and how to resolve. -->

None known.

## References

<!-- Links to upstream documentation, style guides, or standards. -->
