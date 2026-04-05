# <!-- BEGIN pack: system/category/name -->

<!-- Replace the section title above and below with your pack ID. -->
<!-- Keep section markers so fragments can be merged/updated automatically. -->

## Pack Name conventions

<!-- Write imperative instructions the agent must follow.
     - Use "Do X." and "Do not do Y." over vague recommendations.
     - Every instruction should be testable or verifiable by the agent.
     - Reference specific tools, commands, or file paths where possible.
-->

### Setup

<!-- Commands to verify the environment is correctly set up. -->

```bash
# Verify required tools
tool --version
```

### Code style

<!-- Linting, formatting, naming conventions. -->

- Run `tool check src/` before committing.
- Do not commit with linting errors.

### Testing

<!-- Test framework, coverage targets, test location conventions. -->

- Write tests in `tests/`.
- Run `tool test` before marking work complete.
- Aim for >80% coverage on changed code.

### Acceptance criteria

<!-- Checkable conditions an agent can verify before closing a task. -->

- [ ] `tool check` passes with no errors
- [ ] `tool test` passes with all tests green
- [ ] No secrets or credentials in committed files

# <!-- END pack: system/category/name -->
