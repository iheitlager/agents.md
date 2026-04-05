# Convention Authoring convention pack

Engelbart's bootstrapping principle applied to sbp-agents: the first skill in the catalog is the skill to make more skills.

This pack teaches AI agents how to author, validate, and publish convention packs. Install it once; from then on your agent knows the format, the rules, and how to self-validate new packs before committing them.

## What this pack does

- Gives agents precise, imperative instructions for structuring and writing convention packs.
- Provides a `/new-convention` command that scaffolds a complete pack skeleton in one step.
- Installs a pre-commit hook that validates any modified pack against the catalog schema.
- Installs a CI check that lints the entire catalog on every push.

## Requirements

- `bash` >= 5.0
- `tomlq` — for parsing TOML in shell scripts (`brew install yq` provides `tomlq` on macOS, or install `python-toml-query`)

## What gets installed

| File | Destination | Purpose |
|------|-------------|---------|
| `AGENTS.md` fragment | `AGENTS.md` | Agent instructions for authoring packs |
| `CLAUDE.md` fragment | `CLAUDE.md` | Claude Code slash command and tool hints |
| `commands/new-convention.md` | `.claude/commands/new-convention.md` | `/new-convention` scaffold command |
| `hooks/validate-convention.sh` | `.git/hooks/pre-commit` (merged) | Block commits with invalid packs |
| `checks/lint-convention.sh` | `ci/checks/lint-convention.sh` | CI validation of full catalog |

## AAE level

**L4 — CI enforce**

Conventions are enforced at three levels:
1. Agent instructions (AGENTS.md) — the agent follows the rules
2. Pre-commit hook — blocks malformed packs from being committed
3. CI check — validates the full catalog on every push

## Usage

```bash
# Install this pack into your project
sbp-agents add function/ai/convention-authoring

# Scaffold a new convention pack
/new-convention system/language/rust

# Validate a specific pack manually
.git/hooks/validate-convention.sh catalog/system/language/rust

# Run the full catalog lint
ci/checks/lint-convention.sh
```

## The `/new-convention` command

Running `/new-convention <taxonomy/category/name>` creates:

```
catalog/<taxonomy>/<category>/<name>/
├── manifest.toml      # pre-filled with id, empty required fields
├── AGENTS.md          # template with section markers
├── CLAUDE.md          # template
├── README.md          # template with prompts to fill in
├── commands/          # empty, ready for slash commands
├── hooks/             # empty, ready for pre-commit scripts
└── checks/            # empty, ready for CI scripts
```

The agent then fills in the pack content following the rules in AGENTS.md.

## Self-referential design

This pack is authored using its own conventions. Running `validate-convention.sh` against itself should always pass. If it does not, that is a bug in the pack.

## References

- [sbp-agents catalog README](../../../../README.md)
- [Convention pack template](../../../_template/)
- [CONTRIBUTING.md](../../../../CONTRIBUTING.md)
