<!-- BEGIN pack: system/language/python -->

## Tool use preferences

Always prefix Python commands with `uv run` to ensure the correct environment:

```bash
uv run pytest tests/
uv run ruff check src/
uv run pyright src/
uv run python script.py
```

Do not use bare `pytest`, `python`, `ruff`, or `pyright` — these may resolve to the wrong environment.

If a `Makefile` exists, check it for shortcuts (`make test`, `make lint`, `make format`) and prefer those.

## Permissions

Allow `uv run` commands in settings when working in Python projects using this pack.

<!-- END pack: system/language/python -->
