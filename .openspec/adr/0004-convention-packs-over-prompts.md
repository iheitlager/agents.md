# ADR-0004 · Convention packs over monolithic prompt fragments

**Status:** Accepted
**Date:** 2026-04-05
**Supersedes:** The modular prompt system (pre-2026 architecture)

## Context

The original `agents.md` repository (Aug–Sep 2025) was a collection of reusable prompt fragments. Teams would copy the relevant fragments into their project's AGENTS.md manually. Over time this produced several problems:

- **No versioning:** There was no way to know which version of a fragment a project had or whether it was out of date.
- **No inventory:** No tooling to list what was installed, update it, or remove it.
- **No enforcement:** Fragments were documentation. Nothing checked whether the agent actually followed them.
- **No taxonomy:** Fragments were organized in a flat list by topic with no rules about where new ones should go.
- **Copy-paste drift:** Teams modified fragments locally, making it impossible to push improvements back upstream.

The pattern was "prompts as content" rather than "conventions as code".

## Decision

Replace the prompt fragment system with **installable convention packs**:

1. **Packs are versioned units** — each pack has a `version` in `manifest.toml`. Consumers can pin versions, upgrade, or roll back.
2. **Packs are installable by tooling** — the `sbp-agents` CLI installs, updates, and removes packs without manual editing.
3. **Packs declare their enforcement level** — the AAE ladder (ADR-0002) turns suggestions into enforceable controls at the appropriate level.
4. **Packs have a machine-readable schema** — `manifest.toml` describes what a pack installs, what tools it requires, and what other packs it relates to.
5. **Packs use section markers** — fragments in `AGENTS.md` are bounded so tooling can manage them (ADR-0003).
6. **The catalog has a taxonomy** — the two-axis structure (ADR-0001) makes the catalog navigable and consistent.

The key reframe: a convention pack is not a document. It is a deployable artifact that encodes a standard, enforces it, and can be versioned and distributed like a library.

## Consequences

- The repo is no longer a documentation store — it is a package registry for AI agent conventions
- Teams install packs the same way they install linting tools: once, from a registry, with tooling managing the lifecycle
- The format is more complex to author than writing a markdown fragment — this is addressed by the `convention-authoring` pack itself
- Backwards compatibility: the old prompt fragments are superseded; there is no migration path (the new format is a clean break)
- The self-referential property becomes possible: a convention pack can describe how to author convention packs
