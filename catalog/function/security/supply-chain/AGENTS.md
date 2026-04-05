<!-- BEGIN pack: function/security/supply-chain -->

## Supply chain security conventions

### GitHub Actions: pin to full commit SHA

Pin every GitHub Actions `uses:` reference to a full 40-character commit SHA, not a mutable tag or branch name.

**Do this:**
```yaml
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4.2.2
```

**Do not do this:**
```yaml
- uses: actions/checkout@v4
- uses: actions/checkout@main
- uses: actions/checkout@v4.2.2
```

Include the version tag as a comment so humans can verify the pin.

### Why

Mutable tags can be moved by the action author (deliberately or via compromise). Pinning to a SHA guarantees the exact code that was reviewed is what runs in CI. This is a required control in SBP Lab271 security standards.

### Finding the SHA for a tag

```bash
# Look up the SHA for a specific tag
gh api repos/<owner>/<repo>/git/ref/tags/<tag> --jq '.object.sha'

# Or browse the action's releases on GitHub and copy the SHA from the tag commit
```

For actions that use annotated tags (most do), you need the dereferenced SHA:
```bash
gh api repos/<owner>/<repo>/git/ref/tags/<tag> --jq '.object.sha' | \
  xargs -I{} gh api repos/<owner>/<repo>/git/tags/{} --jq '.object.sha'
```

### Scope

Apply this rule to:
- All `uses:` lines in `.github/workflows/*.yml`
- All reusable workflow calls

Do not apply to `run:` steps (those execute shell commands, not third-party actions).

### Acceptance criteria

- [ ] All `uses:` references in `.github/workflows/` are pinned to a full 40-character SHA
- [ ] Each pinned SHA has a comment with the human-readable version (e.g. `# v4.2.2`)
- [ ] No `uses:` references point to a branch name or mutable tag

<!-- END pack: function/security/supply-chain -->
