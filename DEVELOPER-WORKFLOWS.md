# Developer Workflows

## Install

```bash
# No install needed — scripts run in place
# Bootstrap checks for uv on first use
bash scripts/bootstrap.sh
```

## Test

```bash
# Cookie conversion tests (no dependencies)
python3 tests/test-convert-cookies.py

# Snapshot pipeline tests (needs uv)
bash tests/test-export-snapshot.sh

# Proxy resolution tests (no dependencies)
bash tests/test-resolve-proxy.sh
```

## Lint

No linter configured yet. Shell scripts pass `shellcheck`. Python scripts pass `pyright` (stdlib-only, no type stubs needed).

## Commit convention

```
research(<trove-id>): create trove with N sources
research(<trove-id>): extend with N new sources
research(<trove-id>): refresh N sources (M changed)
```

## Trove lifecycle

1. **Create** — New trove from gathered sources
2. **Extend** — Add sources to existing trove
3. **Refresh** — Re-fetch stale sources, update changed content
4. **Discover** — Find existing troves matching a topic

Each mode follows the dual-commit pattern: Commit A records content, Commit B stamps the hash.

See `docs/developer-workflows/` for additional detail.