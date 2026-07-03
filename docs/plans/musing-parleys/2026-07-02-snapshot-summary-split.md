# Parley: Snapshot/Summary Split and Compliance

**Date:** 2026-07-02
**Topic:** Snapshot/summary file split, naming convention, compliance testing, request-origin.md

## Opening position (from musing)

Proposal: split each source into `{slug}-snapshot.md` (required, verbatim) + `{slug}-summary.md` (optional, commentary). Add `request-origin.md` per trove. Three-tier compliance testing (structural, statistical spot-check, full audit).

## Resolved

1. **Naming:** `{slug}-snapshot.md` / `{slug}-summary.md`. Redundancy is worth the detachment survival.
2. **Snapshot scope:** Required for ALL sources (remote and local). Uniform convention.
3. **Summary required too:** Every source gets BOTH `{slug}-snapshot.md` AND `{slug}-summary.md`. Two files per source is the expected norm.
4. **Compliance testing:** Three-tier — Tier 0 (unit, 100:0), Tier 1 (integration, ~95:5, one LLM spot-check per run), Tier 2 (E2E, ~70:30, full create mode against real URLs with LLM judge k=3). Inverse test required (broken URL → `failed: true`, no files).
5. **Migration heuristic:** Fetch original URL, strip code blocks from both sides, compute text similarity. ≥0.8 → snapshot, <0.8 → summary. Tune threshold as needed.
6. **Request-origin:** One file per trove (`request-origin.md`). One entry per distinct prompt that produced a change. No cap.
7. **Test fixtures:** Migrate primary fixtures to new two-file convention. Move old summary-only content to `evals/fixtures/known-bad-summaries/` for inverse compliance tests.

## Ponytail: manifest.yaml with snapshot/summary split

```yaml
trove: websocket-vs-sse
created: 2026-07-02
refreshed: 2026-07-02
tags:
  - real-time
  - websocket
  - sse

sources:
  - slug: mdn-websocket-api
    url: "https://developer.mozilla.org/en-US/docs/Web/API/WebSocket"
    fetched: 2026-07-02T14:30:00Z

  - slug: whatwg-sse-spec
    url: "https://html.spec.whatwg.org/multipage/server-sent-events.html"
    fetched: 2026-07-02T14:31:00Z

  - slug: strangeloop-2025-realtime-patterns
    url: "https://youtube.com/watch?v=xyz"
    fetched: 2026-07-02T15:00:00Z
```

### Manifest is now just a registry

Source URI + date fetched. Everything else (hashes, verification, duration, speakers, highlights) lives in the files' own frontmatter or is derivable. The manifest's job is to answer "what sources does this trove contain and when were they collected?" — nothing more.

### Directory layout

```
docs/troves/websocket-vs-sse/
├── manifest.yaml
├── synthesis.md
├── request-origin.md
└── sources/
    └── mdn-websocket-api/
        ├── mdn-websocket-api-snapshot.md
        └── mdn-websocket-api-summary.md
```

## Tension backlog
8. Prompt injection resistance (sidebar — deferred to future musing)

## Status

**Parley complete.** All tensions resolved. Aligned on snapshot/summary split, naming, manifest simplification, three-tier compliance testing, migration heuristic, request-origin, and fixture strategy.
