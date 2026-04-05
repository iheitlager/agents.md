# /new-convention

Scaffold a new convention pack at the given catalog path.

## Usage

```
/new-convention <taxonomy/category/name>
```

## Examples

```
/new-convention system/language/rust
/new-convention function/testing/contract
/new-convention system/platform/kubernetes
```

## What this command does

1. Validates the path follows the two-axis taxonomy (`system/` or `function/`).
2. Creates `catalog/<path>/` with all required files and directories.
3. Pre-fills `manifest.toml` with the correct `id` and placeholder values.
4. Adds `<!-- BEGIN pack: <id> -->` / `<!-- END pack: <id> -->` markers to AGENTS.md and CLAUDE.md.
5. Prints the next steps for filling in the pack content.

## Instructions

When this command is invoked with `<path>`:

1. **Validate the path:**
   - Must have exactly two `/` separators (three components).
   - First component must be `system` or `function`.
   - Reject paths that already exist in `catalog/`.

2. **Create the directory structure:**
   ```
   catalog/<path>/
   ├── manifest.toml
   ├── AGENTS.md
   ├── CLAUDE.md
   ├── README.md
   ├── commands/
   ├── hooks/
   └── checks/
   ```

3. **Write `manifest.toml`** with:
   - `id = "<path>"`
   - `name = "<Name>"` (derive from the last path component, title-cased)
   - `description = ""` (leave empty for the user to fill)
   - `version = "0.1.0"`
   - `aae_level = "L2"` (default; user upgrades when adding hooks/checks)
   - All `[targets]` fields set to `false` except `agents_md = true`

4. **Write `AGENTS.md`** with:
   ```markdown
   <!-- BEGIN pack: <path> -->

   ## <Name> conventions

   <!-- Write imperative instructions here. -->

   ### Acceptance criteria

   - [ ] <!-- Add verifiable checks here -->

   <!-- END pack: <path> -->
   ```

5. **Write `CLAUDE.md`** with:
   ```markdown
   <!-- BEGIN pack: <path> -->

   <!-- Claude Code-specific instructions here (optional). -->

   <!-- END pack: <path> -->
   ```

6. **Write `README.md`** with:
   ```markdown
   # <Name> convention pack

   <!-- 1-3 sentences explaining what conventions this pack enforces and why. -->

   ## What this pack does

   ## Requirements

   ## What gets installed

   ## AAE level

   **L2 — Soft enforce**
   ```

7. **Print next steps:**
   ```
   ✓ Scaffolded catalog/<path>/

   Next steps:
     1. Fill in manifest.toml — set description, aae_level, requirements
     2. Write AGENTS.md — imperative rules the agent must follow
     3. Add hooks/ scripts if aae_level is L3 or L4
     4. Add checks/ scripts if aae_level is L4
     5. Register in catalog/index.toml
     6. Run: hooks/validate-convention.sh catalog/<path>
   ```

Do not open a PR or commit until the user has filled in the pack content and validation passes.
