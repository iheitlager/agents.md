<!-- BEGIN pack: system/language/python -->

## Python conventions

### Setup

Verify the environment before starting work:

```bash
uv --version        # >= 0.5
python --version    # >= 3.12
ruff --version
pyright --version
```

Use `uv` for all package and runtime management. Do not use `pip`, `poetry`, or `pipenv` directly.

### Package management

- Add dependencies with `uv add <package>`.
- Add dev dependencies with `uv add --dev <package>`.
- Run scripts with `uv run <command>` to ensure the correct virtual environment.
- Do not activate the virtual environment manually.

### Code style

- Use Python 3.12+ type hints in all function signatures and class attributes.
- Run `uv run ruff check src/` before committing. Fix all errors before committing.
- Run `uv run ruff format src/` to format code. Do not commit unformatted code.
- Sort imports with `uv run ruff check --select I src/` (isort rules via ruff).
- Do not use `from __future__ import annotations` — use native type hints (Python 3.12+).

### Type checking

- Run `uv run pyright src/` before committing. Fix all type errors before committing.
- Do not use `type: ignore` comments unless unavoidable; document why if used.
- Annotate all public functions and methods with return types.

### Testing

- Write tests in `tests/unit/` for unit tests and `tests/integration/` for integration tests.
- Run tests with `uv run pytest tests/`.
- Aim for >80% coverage on changed code. Check with `uv run pytest --cov=src/`.
- Name test files `test_<module>.py` and test functions `test_<behavior>`.
- Do not mock at the database or network boundary unless absolutely necessary.

### Project structure

Follow the standard layout:

```
src/<project>/    # Main source
tests/
  unit/
  integration/
pyproject.toml
```

### Acceptance criteria

- [ ] `uv run ruff check src/` passes with no errors
- [ ] `uv run ruff format --check src/` passes
- [ ] `uv run pyright src/` passes with no errors
- [ ] `uv run pytest tests/` passes with all tests green
- [ ] No secrets or credentials in committed files

<!-- END pack: system/language/python -->
