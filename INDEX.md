# Convention Pack Index

Three packs, three design patterns. Each one illustrates a different dimension of what convention packs can do.

---

## Case 1 · `system/language/python` — The language pack

**Version:** 1.0.0 · **Enforcement:** L2 (agent instructions)

A `system/` pack covers the toolchain you build *with*. The Python pack is the canonical example: it encodes one opinionated stack (`uv` + `ruff` + `pyright` + `pytest`) as imperative agent instructions plus acceptance criteria the agent can verify before closing any task.

**What it installs:**
- `AGENTS.md` fragment — setup verification, package management rules, code style, type checking, testing conventions, project structure, acceptance checklist
- `CLAUDE.md` fragment — Claude Code-specific preferences (`uv run` prefixes, Makefile shortcuts)

**When to install:** Any Python project that uses this toolchain. Install it once; the agent follows the conventions automatically.

**Design pattern:** Language packs are L2. The conventions are about *how you write code*, which agents pick up from instructions. Hooks would be redundant — the agent checks `ruff` and `pyright` as part of its normal workflow.

```bash
sbp-agents add system/language/python
```

---

## Case 2 · `function/security/supply-chain` — The cross-cutting concern pack

**Version:** 1.0.0 · **Enforcement:** L2 (agent instructions)

A `function/` pack covers concerns that apply regardless of language or platform. Supply-chain security is the canonical example: pin every GitHub Actions `uses:` reference to a full 40-character commit SHA. This rule applies to every project that uses GitHub Actions, whether it's Python, Go, Terraform, or anything else.

**What it installs:**
- `AGENTS.md` fragment — the pinning rule, why it matters, how to find the correct SHA, scope, acceptance criteria

**No `CLAUDE.md`:** The convention is tool-agnostic. There's no Claude-specific behaviour to add.

**When to install:** Any project with `.github/workflows/`. Compose it alongside a language pack.

**Design pattern:** Function packs cross technology boundaries. They often have no `CLAUDE.md` because the rule is the same for every AI tool. The `function/` axis exists precisely for this — concerns that don't belong to any single language or platform.

```bash
sbp-agents add function/security/supply-chain
```

---

## Case 3 · `function/ai/convention-authoring` — The meta layer

**Version:** 0.1.0 · **Enforcement:** L4 (hooks + CI checks)

This pack teaches agents how to *write convention packs*. It is the system describing itself. Install it in the `agents.md` repository itself (or any repo where you're actively authoring new packs) to get scaffolding, validation, and CI enforcement of pack quality.

**What it installs:**
- `AGENTS.md` fragment — pack structure rules, manifest field constraints, writing style, hook/check patterns, `catalog/index.toml` registration requirement
- `CLAUDE.md` fragment — workflow steps, tool preferences, permissions required
- `commands/new-convention.md` — `/new-convention <taxonomy/name>` slash command to scaffold a new pack
- `hooks/validate-convention.sh` — pre-commit check: validates manifest fields, section markers, and file presence
- `checks/lint-convention.sh` — CI check: validates every pack in the catalog

**Why L4:** The quality of convention packs determines what every downstream project gets. Automated enforcement catches malformed packs before they reach the catalog.

**Why it has no `related` packs:** Intentionally self-contained. It must be possible to bootstrap the catalog from scratch using only this pack.

**Design pattern:** The meta layer closes the loop. A system that can describe itself using its own conventions is internally consistent. Any gap in the pack format would show up as a violation of this pack's own rules.

```bash
sbp-agents add function/ai/convention-authoring
```

---

## Composing packs

Packs are designed to be stacked. A typical Python project with CI and security requirements:

```bash
sbp-agents add system/language/python function/security/supply-chain
```

A project actively contributing new packs to this catalog:

```bash
sbp-agents add function/ai/convention-authoring
```

See [catalog/index.toml](catalog/index.toml) for the machine-readable registry and [README.md](README.md) for the full taxonomy.
