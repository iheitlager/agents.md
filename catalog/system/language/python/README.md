# Python convention pack

Encodes Schuberg Philis Python 3.12+ engineering standards: `uv` for package management, `ruff` for linting and formatting, `pyright` for static type analysis, and `pytest` for testing. Extracted from Lab271 active projects.

## What this pack does

Instructs agents to use `uv run` for all Python tool invocations, enforce `ruff` linting and formatting before every commit, run `pyright` for type correctness, and maintain test coverage above 80%. It enforces consistent project structure and modern Python type hint usage.

## Requirements

- `uv` >= 0.5
- `ruff` (installed via `uv`)
- `pyright` (installed via `uv`)
- Python >= 3.12

## What gets installed

| File | Destination | Purpose |
|------|-------------|---------|
| `AGENTS.md` fragment | `AGENTS.md` | Agent instructions for all AI tools |
| `CLAUDE.md` fragment | `CLAUDE.md` | Claude Code-specific `uv run` preferences |

## AAE level

**L2 — Soft enforce** (agent instructions only)

Agents are instructed to run linting and type checks before committing. No pre-commit hook is installed. Upgrade to L3 if you need blocking enforcement.

## Conflicts

None known.

## References

- [uv documentation](https://docs.astral.sh/uv/)
- [ruff documentation](https://docs.astral.sh/ruff/)
- [pyright documentation](https://github.com/microsoft/pyright)
- [pytest documentation](https://docs.pytest.org/)
