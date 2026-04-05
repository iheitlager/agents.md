# agents.md

> Installable convention packs for AI-assisted engineering — the Schuberg Philis way.

Convention packs encode engineering standards as agent-readable instructions. Install them into any project to give your AI coding assistant the context it needs to follow your conventions.

---

## What this is

Each convention pack is a self-contained bundle of:
- **Instructions** (`AGENTS.md` / `CLAUDE.md` fragments) — what the agent must do
- **Commands** — reusable slash commands for your AI assistant
- **Hooks** — pre-commit and pre-push enforcement scripts
- **Checks** — CI validation scripts

Packs are composable. Stack a language pack on top of a testing pack on top of an observability pack.

---

## Two-axis taxonomy

Packs are organized along two axes:

### `system/` — What you build **with** (technology)

| Category | Examples |
|----------|---------|
| `system/platform/` | terraform, docker, kubernetes, ansible |
| `system/language/` | python, rust, go, typescript |
| `system/data/` | postgresql, dbt, kafka |
| `system/runtime/` | aws, azure, sbp-cloud |

### `function/` — What **concerns** apply (cross-cutting)

| Category | Examples |
|----------|---------|
| `function/security/` | supply-chain, secrets, hardening |
| `function/testing/` | unit, integration, assurance |
| `function/observability/` | logging, metrics, sbom |
| `function/ci-cd/` | github-actions, release |
| `function/documentation/` | adr, openspec |
| `function/ai/` | knowledge-base, agentic, prompting |

---

## How to install

```bash
# Add a single convention pack
sbp-agents add system/language/python

# Add multiple packs
sbp-agents add system/language/python function/testing/assurance

# List available packs
sbp-agents list

# Show what a pack installs
sbp-agents show system/language/python
```

Packs install fragments into your project's `AGENTS.md`, commands into `.claude/commands/`, and hooks into `.git/hooks/` or your CI pipeline.

---

## Convention pack format

Each pack lives under `catalog/` at its taxonomy path and contains:

```
catalog/system/language/python/
├── manifest.toml    # metadata, version, AAE level, requirements, targets
├── AGENTS.md        # agent instruction fragment (section markers required)
├── CLAUDE.md        # Claude Code-specific fragment (optional)
├── commands/        # .claude/commands/ slash command files (optional)
├── hooks/           # pre-commit, pre-push scripts (optional)
├── checks/          # CI validation scripts (optional)
└── README.md        # human-readable description
```

### manifest.toml schema

```toml
[pack]
id = "system/language/python"
name = "Python"
description = "Python 3.12+ conventions: uv, ruff, pyright, pytest"
version = "1.0.0"
aae_level = 3          # AAE enforcement level (1-4)
authors = ["Schuberg Philis"]

[requirements]
tools = ["uv", "ruff", "pyright"]
min_python = "3.12"

[targets]
agents_md = true        # installs AGENTS.md fragment
claude_md = false       # installs CLAUDE.md fragment
commands = true         # installs commands/
hooks = true            # installs hooks/
checks = true           # installs checks/

[compatibility]
tools = ["claude-code", "opencode", "github-copilot", "cursor"]
```

---

## AAE enforcement ladder

Agents-as-Enforcers (AAE) defines how strictly a pack enforces its conventions:

| Level | Name | Mechanism | When to use |
|-------|------|-----------|-------------|
| L1 | Inform | Documentation only | Aspirational guidelines |
| L2 | Soft enforce | Agent instructions | Standard conventions |
| L3 | Hook enforce | pre-commit / pre-push | Critical standards |
| L4 | CI enforce | Pipeline checks | Compliance requirements |

Packs declare their `aae_level` in `manifest.toml`. Higher levels override lower ones when packs conflict.

---

## Multi-tool support

Convention packs target these AI coding assistants:

| Tool | Fragment file | Commands dir |
|------|--------------|--------------|
| Claude Code | `AGENTS.md`, `CLAUDE.md` | `.claude/commands/` |
| OpenCode | `AGENTS.md` | — |
| GitHub Copilot | `AGENTS.md` | — |
| Cursor | `AGENTS.md` | `.cursor/rules/` |

The `AGENTS.md` fragment is the universal baseline. Tool-specific fragments layer on top.

---

## Contributing a new convention

1. Copy `catalog/_template/` to the appropriate taxonomy path
2. Fill in `manifest.toml` with your pack's metadata
3. Write the `AGENTS.md` fragment — imperative, testable, unambiguous
4. Add hooks and checks if your pack is L3 or L4
5. Write a `README.md` for humans
6. Open a PR following the [contributing guide](CONTRIBUTING.md)

See [catalog/_template/](catalog/_template/) for the full template with inline documentation.

---

## License

Apache 2.0 — see [LICENSE](LICENSE).
