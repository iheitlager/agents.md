# ADR-0001 · Two-axis pack taxonomy: system/ and function/

**Status:** Accepted
**Date:** 2026-04-05

## Context

Convention packs need a catalog structure that scales. The naive approach is a flat list by topic (`python`, `security`, `testing`, `docker`). This breaks down as the catalog grows because:

- Topics are not mutually exclusive (`python` overlaps with `testing`, `docker` overlaps with `kubernetes`)
- Flat lists give no signal about where a new pack should go
- Consumers can't reason about which packs conflict or compose

The pre-2026 prompt system had exactly this problem — there was no taxonomy, just a bag of fragments.

## Decision

Organize packs along two orthogonal axes:

**`system/` — technology you build *with***
The platform, language, framework, or infrastructure your project depends on. Examples: `system/language/python`, `system/platform/terraform`, `system/data/postgresql`.

**`function/` — concerns that *cross* all technologies**
Engineering practices that apply regardless of what you build with. Examples: `function/security/supply-chain`, `function/testing/integration`, `function/observability/logging`.

A pack belongs to `system/` if it is meaningless without a specific technology. It belongs to `function/` if it applies to *any* project that needs the concern covered.

## Consequences

- Composing one `system/` pack with one or more `function/` packs is the idiomatic pattern
- Conflicts are predictable: two `system/language/` packs conflict; a `system/` and a `function/` pack almost never do
- New packs have a clear home — the taxonomy question reduces to "is this a technology or a practice?"
- `function/ai/` is a valid category: AI-specific practices (e.g. convention authoring) are cross-cutting concerns, not tied to any one language
