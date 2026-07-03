# Plan: Snapshot/Summary Split Implementation

**Derived from parley:** `docs/plans/musing-parleys/2026-07-02-snapshot-summary-split.md`
**Status:** Planned — not yet started

## Scope

Implement the snapshot/summary file split across swain-search's spoke files, scripts, test fixtures, and existing troves. Add compliance testing infrastructure.

## Work packages

### WP1 — Update spoke files (the spec)

Update all reference docs to reflect the new naming convention and manifest schema.

| File | What changes |
|------|-------------|
| `references/normalization-formats.md` | All examples: `{slug}.md` → `{slug}-snapshot.md`. Add `{slug}-summary.md` as required (not optional). Update frontmatter examples. |
| `references/verbatim-mandate.md` | Verbatim mandate now applies to `-snapshot.md`. Summary is explicitly allowed in `-summary.md`. |
| `references/manifest-schema.md` | Strip to `slug`/`url`/`fetched`. Remove `hash`, `snapshot-verified`, `has-summary`, `duration`, `speakers`, `highlights`, `selective`, `notes`, `proxy-used`, `freshness-ttl`, `snapshot-metadata-digest`. |
| `references/snapshot-evidence-gate.md` | Normalize to `{slug}-snapshot.md` instead of `{slug}.md`. |
| `references/create-mode.md` | Step 2: create both `-snapshot.md` and `-summary.md`. Step 3: simplified manifest. |
| `references/extend-mode.md` | Same file creation pattern as create-mode. |
| `references/refresh-mode.md` | Hash comparison on `-snapshot.md` content. |
| `references/source-collection.md` | All output paths: `{slug}-snapshot.md`. |
| `references/linking-from-artifacts.md` | Reference `{slug}-snapshot.md` in artifact links. |
| `references/prior-art-check.md` | No structural changes — content-based, unaffected. |
| `SKILL.md` | Update hub references if any inline examples exist. |

### WP2 — Update scripts

| File | What changes |
|------|-------------|
| `scripts/trovewatch.sh` | Check for `{slug}-snapshot.md` instead of `{slug}.md`. Check for `{slug}-summary.md` too. |
| `scripts/normalize-html.py` | Output to `{slug}-snapshot.md`. |
| `scripts/export-snapshot.sh` | Verify output path naming. |
| `scripts/verify-snapshot-evidence.sh` | No change — checks metadata.jsonl, not file paths. |

### WP3 — New scripts

| File | Purpose |
|------|---------|
| `scripts/classify-source.sh` | Given a source URL and local file, fetch URL, strip code blocks from both, compute text similarity, classify as snapshot (≥0.8) or summary (<0.8). |
| `scripts/migrate-trove.sh` | For a given trove: run classify-source on each source, rename to `-snapshot.md` or `-summary.md` accordingly, fetch the missing counterpart, update manifest. |
| `scripts/audit-snapshot-fidelity.sh` | Non-deterministic audit: for each source, use `llm` CLI with structured output to judge snapshot fidelity against live URL. Reports pass^k. |

### WP4 — Update test fixtures

| File | What changes |
|------|-------------|
| `evals/fixtures/trove-with-sources/sources/mdn-websocket/` | Rename `mdn-websocket.md` → `mdn-websocket-summary.md`. Add `mdn-websocket-snapshot.md` with real verbatim content. |
| `evals/fixtures/trove-with-sources/sources/whatwg-sse/` | Same pattern. |
| `evals/fixtures/trove-with-sources/manifest.yaml` | Simplify to `slug`/`url`/`fetched`. |
| New: `evals/fixtures/known-bad-summaries/` | Copy old summary-only content here for inverse compliance tests. |

### WP5 — Update eval helpers and suites

| File | What changes |
|------|-------------|
| `evals/helpers/assert-trove.sh` | Check for `{slug}-snapshot.md` + `{slug}-summary.md`. |
| `evals/suites/trove-creation.yaml` | Update knowledge assertions to reflect new naming and manifest schema. |

### WP6 — Migrate existing troves

Run `scripts/migrate-trove.sh` on each existing trove:

| Trove | Sources | Style |
|-------|---------|-------|
| `docs/troves/agent-skill-evals/` | 5 | New-style (dir-per-source) |
| `troves/agent-skills-spec/` | 8 | Old-style (flat numbered) |
| `troves/npx-skills-cli/` | 4 | Old-style (flat numbered) |

Old-style troves also need structural migration to dir-per-source layout.

### WP7 — Add request-origin.md to existing troves

For each trove, create `request-origin.md` with the original creation prompt (reconstructed from context or commit history).

### WP8 — Add compliance tests

| Test | Tier | Type |
|------|------|------|
| Snapshot file exists for each source | 1 | Deterministic |
| Summary file exists for each source | 1 | Deterministic |
| Snapshot has frontmatter with slug/url/fetched | 1 | Deterministic |
| Snapshot not suspiciously small (>500 bytes) | 1 | Deterministic |
| Broken URL → `failed: true`, no files | 1 | Deterministic (inverse) |
| Known-bad summary is flagged as summary | 1 | Deterministic (inverse) |
| Full create mode against real URL → both files | 2 | E2E |
| LLM judge: snapshot is verbatim (k=3) | 2 | Non-deterministic |

## Execution order

1. WP1 (spoke files) — spec first, everything else references it
2. WP2 + WP3 (scripts) — tooling to support migration and testing
3. WP4 (fixtures) — test infrastructure
4. WP5 (eval helpers) — assertion logic
5. WP6 (migration) — run on existing troves
6. WP7 (request-origin) — provenance
7. WP8 (compliance tests) — verification

## Test command

```bash
cd skills/swain-search
uv run --with pytest --with markdownify --with playwright --with beautifulsoup4 pytest
```
