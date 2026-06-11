# Create Mode

Build a new trove from scratch.

## Step 1 — Gather inputs

Ask the user (or infer from context) for:

1. **Trove ID** — a slug for the topic (e.g., `websocket-vs-sse`). Suggest one if the context is clear.
2. **Tags** — keywords for discovery (e.g., `real-time`, `websocket`, `sse`)
3. **Sources** — any combination of:
   - Web search queries ("search for WebSocket vs SSE comparisons")
   - URLs (web pages, forum threads, docs)
   - Video/audio URLs
   - Local file paths
4. **Freshness TTL overrides** — optional, defaults are fine for most troves

If invoked from swain-design (e.g., spike entering Active), the artifact context provides the topic, tags, and sometimes initial sources.

## Step 2 — Collect and normalize

**Mandatory: every source must be a verbatim reproduction of the original document, not a summary.** The normalized source file is evidence — raw material for research. Condensing, paraphrasing, or extracting "key points" from the original is forbidden. Summarization belongs exclusively in `synthesis.md` (trove-level or per-source). See [references/verbatim-mandate.md](references/verbatim-mandate.md) for the full policy.

For each source, use the appropriate capability described in [references/source-collection.md](references/source-collection.md).

## Step 3 — Generate manifest

Create `manifest.yaml` following the schema in `references/manifest-schema.md`. Include:
- Trove metadata (id, created date, tags)
- Default freshness TTL per source type
- One entry per source with provenance (URL/path, fetch date, content hash, type)

Compute content hashes as bare hex SHA-256 digests (no prefix) of the normalized markdown content:

```bash
shasum -a 256 sources/mdn-websocket-api/mdn-websocket-api.md | cut -d' ' -f1
```

## Step 4 — Generate synthesis

Create `synthesis.md` — a structured distillation of key findings across all sources.

**Two levels of synthesis are permitted:**

1. **Trove-level synthesis.md (required, authoritative).** The single `synthesis.md` at the trove root looks across ALL sources and produces a thematic distillation. This is the canonical summary of what the trove as a whole says.

2. **Per-source synthesis.md (optional).** Individual sources MAY include their own `synthesis.md` alongside the normalized source file (e.g., `sources/<source-id>/synthesis.md`). These are useful for capturing what a source says through the lens of the original search context — e.g., commentary on why this source was selected, what aspect it illuminates, or how it relates to the trove topic. Per-source synthesis must NEVER replace or truncate the full normalized source content; the verbatim source file remains the primary artifact. Per-source synthesis is additive commentary, not a substitute for the original.

Structure the trove-level synthesis by **theme**, not by source. Group related findings together, cite sources by ID, and surface:
- **Key findings** — what the sources collectively say about the topic
- **Points of agreement** — where sources converge
- **Points of disagreement** — where sources conflict or present alternatives
- **Gaps** — what the sources don't cover that might matter

Keep it concise. The synthesis is a starting point, not a comprehensive report — the user or artifact author will refine it.

## Step 5 — Commit and stamp

Use the dual-commit pattern to give the trove a reachable commit hash. See [references/linking-from-artifacts.md](references/linking-from-artifacts.md) for the full commit workflow and artifact linking procedure.

## Step 6 — Report

Tell the user what was created:

> **Trove `<trove-id>` created** with N sources — committed as `<TROVE_HASH:0:7>`.
>
> - `docs/troves/<trove-id>/manifest.yaml` — provenance and metadata
> - `docs/troves/<trove-id>/sources/` — N normalized source files
> - `docs/troves/<trove-id>/synthesis.md` — thematic distillation: <SYNTHESIS_URL>
>
> Reference from artifacts with: `trove: <trove-id>@<TROVE_HASH:0:7>`

Always include the synthesis file URL in the report. For multiple troves created in a single run, list each synthesis URL.