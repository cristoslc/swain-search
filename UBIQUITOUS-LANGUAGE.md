# Ubiquitous Language

Bounded context: **swain-search** — Trove collection and normalization.

## Terms

- **Trove** — A structured collection of normalized sources on a topic, stored at `docs/troves/<trove-id>/`
- **Source** — A single normalized document (web page, transcript, thread, etc.) within a trove
- **Manifest** — `manifest.yaml` at trove root; tracks provenance, freshness TTLs, content hashes, and source metadata
- **Synthesis** — `synthesis.md` at trove root; thematic distillation across all sources (the only place summarization is allowed)
- **Per-source synthesis** — Optional `sources/<id>/synthesis.md`; additive commentary, never a replacement for the verbatim source
- **Normalization** — Converting raw source material to structured markdown with YAML frontmatter per `references/normalization-formats.md`
- **Freshness TTL** — How long a source is considered current before needing re-fetch (e.g., `7d`, `never`)
- **Source ID** — Slug-based identifier for a source, derived from title or URL (e.g., `mdn-websocket-api`)
- **Snapshot** — Raw downloaded/exported content before normalization (stored in `.agents/search-snapshots/`)
- **Evidence gate** (SPEC-220) — Verification pipeline: export raw → normalize → log metadata → verify before publication
- **Paywall proxy** — Alternative URL that may provide full content when a direct fetch is truncated by a paywall
- **Prior art check** — Scanning existing troves before creating a new one, to avoid duplicating research
- **Dual-commit pattern** — Commit A records content, Commit B stamps the commit hash into manifest history and artifact frontmatter

See `docs/ubiquitous-language/` for additional detail.