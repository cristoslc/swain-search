# User Experience

## Onboarding

1. Ensure `uv` is on PATH
2. Run `bash scripts/bootstrap.sh` (or let the skill invoke it automatically)
3. No other setup required

## Design principles

- **No global dependencies** — All Python packages run transiently via `uv run --with`
- **Idempotent** — Bootstrap short-circuits after first run; scripts are safe to re-run
- **Graceful degradation** — Missing capabilities (web search, browser, media transcription) are skipped with clear feedback, not hard errors

## Key interactions

- **Create**: `/swain-search research <topic>` → gather sources, normalize, generate trove
- **Extend**: `/swain-search add <url> to <trove-id>` → add sources to existing trove
- **Refresh**: `/swain-search refresh <trove-id>` → re-fetch stale sources
- **Discover**: Find existing troves by tag or keyword

## Accessibility

- All output is markdown-based (screen-reader friendly)
- CLI-first — no GUI required
- Temp files use predictable `/tmp/swain_search_*` naming for auditability

See `docs/user-experience/` for additional detail.