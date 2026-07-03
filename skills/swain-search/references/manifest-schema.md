# Manifest Schema

Each trove has a `manifest.yaml` at its root that tracks trove metadata and source provenance. The manifest is a minimal registry — all content metadata lives in the files' own frontmatter.

## Top-level fields

```yaml
# Required
trove: <trove-id>                  # Slug identifier (matches directory name)
created: <ISO date>                # When the trove was first created
refreshed: <ISO date>              # When any source was last fetched or refreshed
tags:                              # For trove discovery by other artifacts
  - <tag>

# Optional
history:                           # Append-only event log (oldest first)
  - event: created                 # created | extended | refreshed
    date: <ISO date>               # When the event occurred
    commit: <short hash>           # Commit A hash from the dual-commit workflow
    sources: <N>                   # Total source count after this event
    sources-added: <N>             # Optional (extended) — how many new sources
    sources-changed: <N>           # Optional (refreshed) — how many sources had content changes
    notes: ""                      # Optional — e.g., "added 3 forum threads"

referenced-by:                     # Back-links to artifacts using this trove
  - artifact: SPIKE-001
    commit: abc1234                # Commit A hash from the dual-commit workflow
  - artifact: ADR-003
    commit: def5678

sources:                           # Ordered list of collected sources
  - <source entry>                 # See below
```

## Source entry fields

```yaml
# Required
slug: "mdn-websocket-api"          # Slug-based ID (used as directory name)
url: "https://..."                 # Original URL (or path for local sources)
fetched: <ISO datetime>            # When this source was last fetched
```

The manifest is intentionally minimal. All other metadata (title, type, duration, speakers, highlights, etc.) lives in the frontmatter of the source files themselves:
- `sources/<slug>/<slug>-snapshot.md` — verbatim reproduction
- `sources/<slug>/<slug>-summary.md` — structured commentary

## Source types

| Type | What it covers |
|------|---------------|
| `web` | Web pages, documentation, blog posts, API docs |
| `forum` | Forum threads, discussions, Q&A sites, GitHub issues |
| `document` | PDFs, DOCX, PPTX, XLSX, local markdown |
| `media` | Video, audio, podcasts (transcribed) |
| `local` | Local files already in markdown |
| `repository` | Git repositories — tree structure preserved |
| `documentation-site` | Documentation sites — section hierarchy preserved |
| `cli-manpage` | CLI tool manpage output |
| `cli-help` | CLI tool `--help` or `-h` output |
| `cli-subcommand-help` | CLI subcommand help output |

## CLI-specific source fields

For CLI source types, additional frontmatter fields apply in the snapshot file:

```yaml
tool-name: "git"              # The CLI tool name (required for all CLI types)
command: "remote"             # For cli-subcommand-help — the subcommand name
depth: 1                      # For cli-subcommand-help — nesting level (1 or 2)
failed: true                  # Optional — true if capture attempt failed
```

## Example manifest

```yaml
trove: websocket-vs-sse
created: 2026-07-02
refreshed: 2026-07-02
tags:
  - real-time
  - websocket
  - sse

history:
  - event: created
    date: 2026-07-02
    commit: abc1234
    sources: 2

referenced-by:
  - artifact: SPIKE-001
    commit: abc1234

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
