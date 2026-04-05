<!-- BEGIN pack: function/ai/convention-authoring -->

## Convention authoring conventions

You are creating a convention pack for the sbp-agents catalog. Follow every rule below precisely — this pack is self-referential and its own validation hook will check your output.

### Structure

Every convention pack lives under `catalog/<taxonomy>/<name>/` and contains these files:

```
catalog/<taxonomy>/<name>/
├── manifest.toml       # required
├── AGENTS.md           # required
├── README.md           # required
├── CLAUDE.md           # optional — Claude Code-specific instructions
├── commands/           # optional — slash commands (.md files)
├── hooks/              # required for L3+
└── checks/             # required for L4+
```

Create every file listed in `[targets]` of manifest.toml. Do not leave required directories empty without at least a meaningful script or `.gitkeep`.

### manifest.toml rules

- Set `id` to exactly match the catalog path (e.g. `function/ai/convention-authoring`).
- Set `aae_level` consistently with file presence:
  - `L1`: AGENTS.md only, no hooks/, no checks/
  - `L2`: AGENTS.md + acceptance criteria, no hooks/, no checks/
  - `L3`: AGENTS.md + hooks/, no checks/
  - `L4`: AGENTS.md + hooks/ + checks/
- List every tool the hooks or checks call under `[requirements] tools`.
- Set every `[targets]` field to `true` when the corresponding file/directory is present.

### AGENTS.md fragment rules

- Wrap content with section markers using the pack id:
  ```
  <!-- BEGIN pack: function/ai/convention-authoring -->
  ...
  <!-- END pack: function/ai/convention-authoring -->
  ```
- Write instructions in imperative voice: "Run X." not "You should run X."
- Every instruction must be verifiable by the agent with a command or file check.
- Include an "Acceptance criteria" subsection with a checklist the agent runs before closing a task.

### Writing style

- Use "Do X." and "Do not do Y." — not "consider" or "try to".
- Refer to specific file paths, commands, and field names.
- Keep instructions short: one action per bullet.
- Do not add instructions that cannot be verified programmatically.

### Hooks

Hooks live in `hooks/` and run as pre-commit scripts. Follow this structure:

```bash
#!/usr/bin/env bash
set -euo pipefail
ERRORS=0
# ... checks, increment ERRORS on failure ...
[[ $ERRORS -gt 0 ]] && exit 1
exit 0
```

- Check only what the pack's manifest promises to enforce.
- Print `[pack-id] ERROR: <message>` for each failure.
- Print `[pack-id] OK` when all checks pass.
- Exit non-zero to block the commit when ERRORS > 0.

### CI checks

Checks live in `checks/` and run in CI pipelines. Follow the same structure as hooks but validate the entire catalog, not just staged files.

- Iterate over all packs in `catalog/`.
- Report all failures before exiting — do not stop at the first error.

### catalog/index.toml registration

After creating the pack, add an entry to `catalog/index.toml`:

```toml
[[pack]]
id = "function/ai/convention-authoring"
name = "Convention Authoring"
description = "Teaches AI agents how to author convention packs"
version = "0.1.0"
aae_level = "L4"
path = "catalog/function/ai/convention-authoring"
```

Do not create a PR without this entry.

### Acceptance criteria

- [ ] `catalog/<name>/manifest.toml` exists and all required fields are set
- [ ] `aae_level` matches file presence (L3 → hooks/ present, L4 → checks/ present)
- [ ] AGENTS.md has `<!-- BEGIN pack: <id> -->` and `<!-- END pack: <id> -->` markers
- [ ] `hooks/validate-convention.sh` exits 0 when run against this pack
- [ ] `checks/lint-convention.sh` exits 0 against the full catalog
- [ ] Pack is registered in `catalog/index.toml`
- [ ] `sbp-agents add <id>` would install without errors (manifest is valid)

<!-- END pack: function/ai/convention-authoring -->
