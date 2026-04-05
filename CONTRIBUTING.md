# Contributing to agents.md

Welcome! This repository is a catalog of convention packs for AI-assisted engineering. Convention packs encode Schuberg Philis engineering standards as agent-readable instructions that can be installed into any project.

## Quick start

1. **Fork and clone** this repository
2. **Pick a taxonomy path** for your new convention pack (see below)
3. **Copy the template**: `cp -r catalog/_template/ catalog/<axis>/<category>/<name>/`
4. **Fill in the template** following the authoring standards
5. **Submit a pull request**

## Taxonomy

Packs live under one of two axes:

```
catalog/
├── system/          # WHERE (technology you build with)
│   ├── platform/    # terraform, docker, kubernetes, ansible
│   ├── language/    # python, rust, go, typescript
│   ├── data/        # postgresql, dbt, kafka
│   └── runtime/     # aws, azure, sbp-cloud
└── function/        # WHAT (cross-cutting concern)
    ├── security/    # supply-chain, secrets, hardening
    ├── testing/     # unit, integration, assurance
    ├── observability/ # logging, metrics, sbom
    ├── ci-cd/       # github-actions, release
    ├── documentation/ # adr, openspec
    └── ai/          # knowledge-base, agentic, prompting
```

If your pack belongs under both axes (e.g. Python testing), use the primary axis and reference the secondary in your `manifest.toml`.

## Convention pack format

Every pack contains:

| File | Required | Purpose |
|------|----------|---------|
| `manifest.toml` | Yes | Pack metadata, version, AAE level |
| `AGENTS.md` | Yes | Universal agent instruction fragment |
| `CLAUDE.md` | No | Claude Code-specific additions |
| `commands/` | No | `.claude/commands/` slash command files |
| `hooks/` | No | pre-commit / pre-push enforcement scripts |
| `checks/` | No | CI validation scripts |
| `README.md` | Yes | Human-readable description |

See `catalog/_template/` for the full template with inline documentation.

## Authoring standards

### Writing style

- **Imperative voice**: "Run `ruff check src/`." not "You should run ruff."
- **Be explicit**: "Do X. Do not do Y." over vague recommendations.
- **Be testable**: Every instruction should include a command agents can run to verify.
- **Short sentences**: Aim for clarity over cleverness.
- **Section markers**: Use `<!-- BEGIN pack: id -->` and `<!-- END pack: id -->` in `AGENTS.md` so fragments can be merged and updated automatically.

### Security requirements

- **No secrets**: Use placeholders like `<API_KEY>` or `${SECRET_FROM_VAULT}`.
- **Pin versions**: Specify minimum versions for tools and dependencies.
- **Secure defaults**: Least privilege, scanners enabled, safe configurations.
- **Document risks**: Call out security implications of choices.

### AAE enforcement level

Choose the right level for your pack:

| Level | When to use | What to include |
|-------|-------------|-----------------|
| L1 | Aspirational or informational | `AGENTS.md` fragment only |
| L2 | Standard conventions | `AGENTS.md` + acceptance criteria |
| L3 | Critical standards | `AGENTS.md` + `hooks/` scripts |
| L4 | Compliance requirements | `AGENTS.md` + `hooks/` + `checks/` |

## Pull request guidelines

### Branch naming

```
feat/catalog-system-language-rust
fix/catalog-function-security-secrets
docs/contributing-aae-levels
```

### Commit messages

Follow Conventional Commits:

```
feat(catalog/system/language/python): add Python 3.12 convention pack
fix(catalog/function/security/secrets): correct pre-commit hook path
docs(contributing): clarify AAE enforcement levels
```

### PR description template

```markdown
## What
Brief description of changes

## Why
Problem being solved or value being added

## Pack details
- Taxonomy path: `catalog/<axis>/<category>/<name>/`
- AAE level: L2 (soft enforce)
- Tools required: uv, ruff, pyright

## Testing
- [ ] AGENTS.md fragment is imperative and testable
- [ ] manifest.toml fields are complete and valid
- [ ] Hooks/checks are executable and exit cleanly on a fresh repo
- [ ] No secrets or sensitive data included

## Checklist
- [ ] Section markers present in AGENTS.md
- [ ] README.md explains what the pack does and what it installs
- [ ] manifest.toml `aae_level` matches the files included
```

## Review process

Reviewers look for:

- **Clarity**: Can an agent follow these instructions unambiguously?
- **Security**: Are defaults secure? Any missing security considerations?
- **Testability**: Are acceptance criteria objective and measurable?
- **Alignment**: Does this match the Schuberg Philis way of working?
- **Completeness**: Are all required template sections present?

## Community guidelines

- Be respectful in discussions and feedback.
- Assume good intent from contributors.
- Focus on technical merit over personal preferences.
- Help newcomers understand the standards.

**Questions?**
- General questions: Open a GitHub issue
- Security concerns: Contact @jverhoeks, @fbuters, or @iheitlager directly
- Complex contributions: Open a discussion first to align on approach

---

By contributing, you agree that your contributions will be licensed under the Apache 2.0 license.
