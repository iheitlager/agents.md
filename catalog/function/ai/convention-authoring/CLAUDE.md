<!-- BEGIN pack: function/ai/convention-authoring -->

## Slash commands

- `/new-convention <taxonomy/category/name>` — scaffolds a new convention pack at the given catalog path. Run this before authoring any new pack.

## Tool use preferences

- Use the `Write` tool to create new pack files — do not use `echo` redirects or heredocs in Bash.
- Use the `Read` tool to inspect `catalog/_template/` files before creating pack content.
- Use the `Edit` tool to update `catalog/index.toml` — append the new `[[pack]]` block precisely.

## Permissions

- This pack's hooks run `bash` and may call `tomlq` — allow both in settings.
- The `validate-convention.sh` hook reads files under `catalog/` — no network access required.

## Workflow

1. Run `/new-convention <path>` to scaffold the directory structure.
2. Fill in `manifest.toml` fields — start with `id`, `description`, and `aae_level`.
3. Write `AGENTS.md` last — it summarises what the other files enforce.
4. Run `hooks/validate-convention.sh <pack-path>` locally before committing.
5. Register the pack in `catalog/index.toml` before opening a PR.

<!-- END pack: function/ai/convention-authoring -->
