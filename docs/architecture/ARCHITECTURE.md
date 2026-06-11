# Architecture

swain-search is a standalone skill for trove collection and normalization. It collects sources from the web, local files, and media, normalizes them to markdown, and caches them in reusable troves.

## Architecture detail

See `docs/architecture/` for detailed architecture documentation.

## Key components

- **SKILL.md** — Agent-facing skill definition (invocation, modes, workflows)
- **scripts/** — Shell and Python scripts for media ingestion, snapshot export, proxy resolution, and trove maintenance
- **references/** — Schemas, normalization formats, and configuration data
- **tests/** — Acceptance tests for scripts (cookie conversion, snapshot pipeline, proxy resolution)

## Data flow

1. Agent invokes swain-search in Create / Extend / Refresh / Discover mode
2. Scripts collect raw source material (web pages, video transcripts, X threads)
3. Agent normalizes sources to markdown per `references/normalization-formats.md`
4. Manifest and synthesis are generated and committed via dual-commit pattern
5. Troves are referenced by `trove: <id>@<hash>` from artifacts

## Design principles

- **Verbatim mandate** — Sources are evidence, not summaries
- **Snapshot-first** (SPEC-220) — Remote documents require raw snapshot + verification before normalization
- **Idempotent scripts** — Safe to re-run; marker files and content hashes prevent duplicate work
- **Graceful degradation** — Missing capabilities are skipped with clear user feedback