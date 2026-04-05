# Supply chain security convention pack

Encodes the Schuberg Philis Lab271 SOP for GitHub Actions supply chain hardening: pin every `uses:` reference to a full 40-character commit SHA rather than a mutable version tag. Extracted from active SBP pipeline standards.

## What this pack does

Instructs agents to replace mutable tag references (e.g. `actions/checkout@v4`) with pinned SHA references (e.g. `actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2`) in all GitHub Actions workflow files. The human-readable version is preserved as a comment.

## Requirements

- GitHub Actions workflows in `.github/workflows/`
- `gh` CLI (optional, for SHA lookup commands)

## What gets installed

| File | Destination | Purpose |
|------|-------------|---------|
| `AGENTS.md` fragment | `AGENTS.md` | Agent instructions for all AI tools |

## AAE level

**L2 — Soft enforce** (agent instructions only)

Agents are instructed to pin SHAs when writing or modifying workflow files. No automated check is installed at this level. Consider upgrading to L3/L4 if compliance is mandatory.

## Conflicts

None known.

## References

- [GitHub: Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [StepSecurity: Harden Runner](https://github.com/step-security/harden-runner)
- [actionlint](https://github.com/rhysd/actionlint) — static checker for workflow files
