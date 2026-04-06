# Changelog

This changelog records not just what changed but *how the thinking evolved* — the design decisions, the pivots, and the reasoning behind each milestone.

---

## [Unreleased]

---

## [0.1.0] — 2026-04-05 · The architecture takes shape

### The pivot: from prompts to convention packs

The original repo (Aug–Sep 2025) was a "modular prompt system" — a collection of reusable prompt fragments you could drop into an AGENTS.md manually. It worked, but it had no structure: no taxonomy, no enforcement, no way to know what was installed or at what version.

In April 2026 the repo was rebuilt from scratch around a different idea: **convention packs as installable units**. The key insight was that AI agents don't need better prompts — they need *conventions*, and conventions need to be:

- **Composable** — stack a language pack on a testing pack on a security pack
- **Versioned** — know what's installed, update it, remove it
- **Enforceable** — not just instructions, but hooks and CI checks

This release establishes the foundation: the two-axis taxonomy, the pack format, the AAE enforcement ladder, and the CLI.

### Added

- `catalog/` — the convention pack catalog with two-axis taxonomy (`system/` × `function/`)
- `catalog/index.toml` — machine-readable registry, the source of truth for `sbp-agents list`
- `catalog/_template/` — a fully annotated template for authoring new packs
- `catalog/function/ai/convention-authoring` — the meta-pack: teaches agents how to author and validate convention packs; the system describing itself (L4: hooks + CI checks)
- `sbp-agents` — bash CLI for installing/removing/updating packs locally and globally
- `CONTRIBUTING.md` — authoring guide for new convention packs

### Design decisions

- **Two-axis taxonomy** (`system/` vs `function/`): technology you build *with* vs concerns that *cross* all technologies. Avoids the monolithic `topics/` flat list from the old system.
- **AAE enforcement levels (L1–L4)**: levels model the cost/benefit of enforcement. L1 is documentation; L4 is pipeline gate. The level is declared in `manifest.toml` so consumers can choose how strictly to enforce.
- **AGENTS.md as universal baseline**: every AI tool reads AGENTS.md. Tool-specific fragments (CLAUDE.md, etc.) layer on top. Single source of truth for multi-tool projects.
- **Section markers** (`<!-- BEGIN pack: id -->`): make pack boundaries machine-readable so the CLI can install, update, and remove fragments without manual editing.
- **Self-bootstrapping**: `convention-authoring` is itself a convention pack installed from the same catalog. The system can extend itself using itself.

---

## [1.0.0] — 2026-04-05 · First real conventions

### First production-grade packs

With the format proven by `convention-authoring`, the first user-facing packs land. These validate the taxonomy and show what a well-formed pack looks like at each axis.

### Added

- `catalog/system/language/python` — Python 3.12+ conventions: `uv`, `ruff`, `pyright`, `pytest` (L2: agent instructions + acceptance criteria)
- `catalog/function/security/supply-chain` — GitHub Actions SHA pinning: pin every `uses:` to a full commit SHA, not a mutable tag (L2: agent instructions + acceptance criteria)

### Design decisions

- **Python pack as the canonical `system/` example**: a language pack covers toolchain, style, type safety, and testing in one unit. It does *not* include hooks — the agent instruction level (L2) is sufficient for style rules that developers catch in review.
- **Supply-chain pack as the canonical `function/` example**: cross-cutting concerns don't belong to any one language or platform. SHA pinning applies regardless of what language the project is written in. It also demonstrates why `function/` packs sometimes have no `CLAUDE.md` — the convention is tool-agnostic.
- **L2 for both initial packs**: we deliberately started at L2 (soft enforce via agent instructions) rather than L3/L4. The goal is to change agent behaviour first, then escalate enforcement to hooks and CI once teams are familiar with the convention.

---

## [pre-history] — Aug–Sep 2025 · Modular prompt system

The original incarnation was a collection of prompt fragments organized by topic. Lessons learned that shaped the 2026 redesign:

- Prompts without structure drift — no versioning, no composability, no inventory
- Agents need *conventions*, not just suggestions — imperative voice, verifiable criteria
- Installation needs tooling — copy-pasting fragments doesn't scale across teams
- The taxonomy problem — flat topics become unmaintainable; a two-axis structure forces cleaner separation

---

[Unreleased]: https://github.com/schubergphilis/agents.md/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/schubergphilis/agents.md/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/schubergphilis/agents.md/releases/tag/v0.1.0
