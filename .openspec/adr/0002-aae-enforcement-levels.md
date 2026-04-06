# ADR-0002 · AAE enforcement ladder: L1–L4

**Status:** Accepted
**Date:** 2026-04-05

## Context

Not all conventions carry the same weight. Suggesting a naming style is different from blocking a commit that misses a security control. A system that treats all rules equally will either over-enforce (frustrating developers for minor style preferences) or under-enforce (letting critical security gaps through as suggestions).

Conventions also need to declare *how* they enforce so that:
- Consumers can choose whether to adopt a pack based on its cost
- Conflicts between packs can be resolved (higher enforcement wins)
- The tooling knows what artifacts to install

## Decision

Define four levels of enforcement under the name **AAE (Agents-as-Enforcers)**:

| Level | Name | Mechanism | Appropriate for |
|-------|------|-----------|-----------------|
| L1 | Inform | AGENTS.md documentation only | Style preferences, aspirational goals |
| L2 | Soft enforce | Agent instructions + acceptance criteria | Standard conventions the agent verifies |
| L3 | Hook enforce | Pre-commit / pre-push scripts | Critical standards, breaking changes |
| L4 | CI enforce | Pipeline checks across full codebase | Compliance, security, catalog integrity |

Each pack declares its level in `manifest.toml` as `aae_level`. The level must be consistent with file presence:
- L1: AGENTS.md only, no hooks/, no checks/
- L2: AGENTS.md + acceptance criteria, no hooks/, no checks/
- L3: AGENTS.md + hooks/, no checks/
- L4: AGENTS.md + hooks/ + checks/

## Consequences

- Consumers can filter the catalog by `aae_level` to understand cost before adopting a pack
- The convention-authoring pack (L4) validates this invariant in its lint check — a pack claiming L3 without a hooks/ directory fails CI
- Teams can start at L2 and escalate to L3/L4 as conventions mature — the level is in manifest.toml, so bumping it is a deliberate versioned change
- L4 is reserved for rules where violations have systemic consequences (security, catalog correctness). Using L4 for style rules would be a misuse of the ladder.
