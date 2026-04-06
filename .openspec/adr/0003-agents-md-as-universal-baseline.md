# ADR-0003 · AGENTS.md as universal baseline with section markers

**Status:** Accepted
**Date:** 2026-04-05

## Context

AI coding assistants read different instruction files. Claude Code reads `CLAUDE.md`; OpenCode and GitHub Copilot read `AGENTS.md`; Cursor reads `.cursor/rules/`. A convention pack needs to install instructions that work across all these tools without duplicating content.

Additionally, a project may install multiple convention packs, each contributing fragments to the same instruction file. Without clear boundaries, packs cannot be updated or removed without manual editing — fragile and error-prone.

## Decision

**`AGENTS.md` is the universal baseline.** Every pack writes its instructions to an `AGENTS.md` fragment. This file is the single source of truth for agent instructions, readable by all supported tools.

Tool-specific files (`CLAUDE.md`, `.cursor/rules/`) are optional supplements. They contain only tool-specific behaviour (permissions, slash command preferences, UI hints) that does not belong in the universal baseline. A pack that has nothing tool-specific omits the tool-specific file.

**Section markers make fragments machine-readable.** Every fragment is wrapped with:

```
<!-- BEGIN pack: <pack-id> -->
...content...
<!-- END pack: <pack-id> -->
```

The CLI uses these markers to:
- Install a fragment without overwriting other packs' content
- Update a fragment in place when a pack version bumps
- Remove a fragment cleanly when a pack is uninstalled

The `pack-id` inside the markers must exactly match the `id` field in `manifest.toml`. This is validated by the convention-authoring hook.

## Consequences

- A project with three installed packs has one `AGENTS.md` containing three clearly delimited sections
- `sbp-agents update` can refresh a single pack's fragment without touching others
- New AI tools that read `AGENTS.md` (or a compatible file) get full convention coverage without any pack changes
- Tool-specific files are additive — a project that only uses Claude Code gets both `AGENTS.md` and `CLAUDE.md`; a project using OpenCode gets only `AGENTS.md`
- The section marker convention is itself enforced by the convention-authoring pack (circular, intentional)
