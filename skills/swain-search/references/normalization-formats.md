# Normalization Formats

Every source in a trove produces two markdown files with YAML frontmatter: a verbatim snapshot and a summary. The frontmatter schema is consistent across types; the body structure varies by source type.

## Two-file convention

Each source directory contains exactly two files:

| File | Required | Content |
|------|----------|---------|
| `{slug}-snapshot.md` | Yes | Verbatim reproduction of the original — evidence |
| `{slug}-summary.md` | Yes | Structured commentary — what the source says, why selected, aspects covered |

The manifest is a minimal registry (slug, url, fetched). All metadata lives in the files' own frontmatter.

## Verbatim mandate: snapshots are evidence, not summaries

**A snapshot file MUST be a faithful, verbatim reproduction of the original document.** Condensing, paraphrasing, extracting "key points", or rewriting the original into an AI-generated summary is strictly forbidden. The snapshot must preserve the full content of the original — no truncation, no condensation, no AI rewrites.

Summarization belongs exclusively in `{slug}-summary.md` (per-source) and `synthesis.md` (trove-level). A snapshot file that reads as a summary is defective and must be regenerated from the raw snapshot.

## Snapshot-first normalization contract (SPEC-220)

For remote documents, normalization is not allowed until a raw snapshot is exported first.

Required sequence:
1. Export/download raw file:
   - `bash scripts/export-snapshot.sh --url "<source-url>" --out-dir ".agents/search-snapshots/raw"`
2. Normalize HTML snapshots via `normalize-html.py` using the downloaded file path. Output goes to `sources/<slug>/<slug>-snapshot.md`. For non-HTML exports (e.g. PDF, DOCX), use available document conversion capabilities.
3. Log the evidence record:
   - `bash scripts/log-snapshot-metadata.sh --source-url "<source-url>" --export-mode "<mode>" --raw-path "<raw-path>" --normalized-path "<normalized-path>" --normalization-skill "<writing-skills|skill-creator>"`
4. Verify source eligibility:
   - `bash scripts/verify-snapshot-evidence.sh --source-url "<source-url>"`

If step 4 fails, the source is unverified and must not be published into trove synthesis.

## Per-source summary.md (required)

Every source MUST include a `{slug}-summary.md` alongside the snapshot at `sources/<slug>/<slug>-summary.md`. This is structured commentary — it captures what the source says through the lens of the original search context, explains why the source was selected, or notes how it relates to the trove topic.

```yaml
---
slug: "mdn-websocket-api"
relates-to: "web-socket-vs-sse"
relevance: "Official specification — defines WebSocket protocol semantics"
selected-because: "Authoritative reference for the protocol comparison"
aspects-covered:
  - "Protocol handshake"
  - "Message framing"
  - "Connection lifecycle"
gaps:
  - "Does not compare with SSE"
  - "Does not discuss performance characteristics"
---
```

Key rules:
- Per-source summary is **required** — every source gets one.
- It MUST NOT replace or truncate the full snapshot content. The snapshot remains the primary artifact.
- The trove-level `synthesis.md` remains the authoritative distillation across all sources.
- Format: YAML-like structured notes (not prose markdown). Use the frontmatter fields above as a pattern; add freeform notes below as needed.

## Common frontmatter

All snapshot files share this frontmatter:

```yaml
---
slug: "mdn-websocket-api"
title: "Source Title"
type: web | forum | document | media | local | repository | documentation-site | x-thread
url: "https://..."           # or path for local sources
fetched: 2026-03-09T14:30:00Z
---
```

## Web pages

Convert raw HTML snapshots to markdown with `normalize-html.py`. The script uses `markdownify` for the body and adds YAML frontmatter from the HTML metadata.

### HTML-to-markdown normalization contract

- Input: a raw `.html` snapshot produced by `export-snapshot.sh`, `capture-playwright.py`, or any page-fetching tool.
- Output: `sources/<slug>/<slug>-snapshot.md` with YAML frontmatter and a verbatim markdown body.
- Title extraction: `<title>` tag, falling back to the first `<h1>`.
- Body conversion: `markdownify` in ATX heading style with bullet lists, stripping `<script>` and `<style>`.

### Common web frontmatter

```yaml
---
slug: "mdn-websocket-api"
title: "WebSocket API - MDN Web Docs"
type: web
url: "https://developer.mozilla.org/en-US/docs/Web/API/WebSocket"
fetched: 2026-03-09T14:30:00Z
---
```

### Playwright provenance extension

When the raw snapshot was produced by browser rendering, `normalize-html.py` records the dynamic-capture provenance:

```yaml
---
slug: "mdn-websocket-api"
title: "Realtime Dashboard"
type: web
url: "https://example.com/dashboard"
fetched: 2026-06-25T14:30:00Z
capture-engine: playwright
rendered-at: 2026-06-25T14:30:05Z
raw-snapshot: ".agents/search-snapshots/raw/dynamic-dashboard.html"
screenshot: ".agents/search-snapshots/raw/dynamic-dashboard.png"
final-url: "https://example.com/app"
---
```

These keys are added automatically when `--capture-engine playwright` is passed. They are omitted for static fetches.

### Body rules

Strip navigation, ads, sidebars, footers, and cookie banners. Preserve the main content area with its heading structure.

```markdown
---
slug: "mdn-websocket-api"
title: "WebSocket API - MDN Web Docs"
type: web
url: "https://developer.mozilla.org/en-US/docs/Web/API/WebSocket"
fetched: 2026-03-09T14:30:00Z
---

# WebSocket API - MDN Web Docs

[Main content with original heading hierarchy preserved]

[Code blocks preserved with language tags]

[Tables preserved in markdown format]
```

Key rules:
- Preserve heading hierarchy (h1-h6 -> # through ######)
- Preserve code blocks with language annotation
- Preserve tables
- Convert images to `![alt text](url)` — keep alt text, keep URL
- Remove inline scripts, styles, tracking pixels
- Remove "related articles", "see also" sections unless substantive

## Forum threads / discussions

Preserve chronological structure with author attribution and timestamps.

```markdown
---
slug: "hn-websocket-vs-sse-dashboards"
title: "WebSocket vs SSE for real-time dashboards"
type: forum
url: "https://news.ycombinator.com/item?id=12345"
fetched: 2026-03-09T14:35:00Z
participants:
  - "user_alpha"
  - "user_beta"
  - "user_gamma"
post-count: 15
---

# WebSocket vs SSE for real-time dashboards

## user_alpha — 2026-03-01 10:15 UTC

[Original post content]

## user_beta — 2026-03-01 10:42 UTC

> [quoted text from parent, as blockquote]

[Reply content]

## user_gamma — 2026-03-01 11:03 UTC

[Reply content]
```

Key rules:
- Each post is an h2 with `author — timestamp`
- Quoted/reply content uses blockquotes (`>`)
- Preserve code blocks within posts
- Omit deleted/removed posts (note their absence if the thread references them)
- For nested threads (Reddit-style), flatten to chronological with reply-to attribution

## X/Twitter threads

X threads are a source type of their own. Each one has an author, a post count, and a post-by-post order. Cited tweets appear inline. The `fetch_x_thread.py` script unrolls the thread via `api.fxtwitter.com`. It also resolves cited posts and self-replies. The output keeps every post verbatim.

```markdown
---
slug: "schlickw-us-foreign-policy-anthropic-mythos"
title: "US Foreign Policy and the Anthropic Mythos"
type: x-thread
url: "https://x.com/schlickw/status/1234567890"
fetched: 2026-04-13T14:30:00Z
author-handle: "schlickw"
author-name: "Example Author"
author-url: "https://x.com/schlickw"
published-date: "2026-04-12T18:00:00Z"
tweet-count: 14
---

# US Foreign Policy and the Anthropic Mythos

## Full Thread

1. [[1/14]](https://x.com/schlickw/status/1234567890) Opening post text, verbatim, with [@mentions](https://x.com/mention) and [#tags](https://x.com/hashtag/tag) hyperlinked inline.

2. [[2/14]](https://x.com/schlickw/status/1234567891) Second post text with a citation to another thread:

   > **[@other_author](https://x.com/other_author)** ([2026-04-10](https://x.com/other_author/status/9876543210)): Cited post text, verbatim.
   >
   > Continuation from the cited author's self-reply, appended as context.
   > _Linked: [article-title](https://example.com/article) — one-sentence synopsis._

3. [[3/14]](https://x.com/schlickw/status/1234567892) Third post text...
```

Key rules:
- Strip leading auto-mention chains. These are the `@handle` prefixes X adds to reply posts. They are threading artifacts, not the author's words.
- Hyperlink every `@mention` inline as `[@handle](https://x.com/handle)`. Hyperlink hashtags as `[#tag](https://x.com/hashtag/tag)`.
- Render cited posts as indented blockquotes under the citing post. Use this format: `> **[@handle](url)** ([date-link](tweet_url)): <verbatim text>`.
- Append up to 3 substantive self-replies from the cited author as blockquote continuation. Skip bare-URL self-replies. They already live in `external_links`. Link out if more than 3 exist.
- Resolve external links inside cited posts when the `article`, `external_links`, or `photos` fields point to longer content. Add a one-sentence synopsis as a sub-blockquote.
- No timestamps. X threads have no internal timeline.
- If the response is a single post on a known thread-opener, record the entry as `failed: true` and `reason: x-thread-unrollable`. Do not write a source file.

## Documents (PDF, DOCX, PPTX, XLSX)

Convert to markdown preserving structure. Use available document conversion capabilities.

```markdown
---
slug: "q4-2025-arch-review"
title: "Q4 2025 Architecture Review"
type: document
path: "docs/reviews/q4-2025-arch-review.pdf"
fetched: 2026-03-09T15:00:00Z
page-count: 12
---

# Q4 2025 Architecture Review

[Converted content with heading structure preserved]

[Tables preserved in markdown]

[Figures noted as: **[Figure 1: System architecture diagram]**]
```

Key rules:
- Preserve heading hierarchy from the document structure
- Preserve tables (convert to markdown tables)
- Note figures/images with descriptive captions: `**[Figure N: description]**`
- For spreadsheets: convert each sheet to a markdown table with the sheet name as heading
- For presentations: each slide becomes a section with the slide title as heading

## Media (video / audio transcripts)

Transcribe with timestamps and speaker labels when available.

```markdown
---
slug: "strangeloop-2025-realtime-patterns"
title: "Real-time Web Patterns - StrangeLoop 2025"
type: media
url: "https://youtube.com/watch?v=xyz"
fetched: 2026-03-09T15:30:00Z
duration: "42:15"
speakers:
  - "Jamie Zawinski"
transcript-source: vtt   # vtt | caption | vision-ocr | local-ocr
---

# Real-time Web Patterns - StrangeLoop 2025

**Duration:** 42:15
**Speaker(s):** Jamie Zawinski

## Transcript

**[00:00]** Jamie Zawinski: Welcome everyone. Today I want to talk about...

**[02:15]** So the first pattern we'll look at is long polling...

**[15:30]** Now, WebSockets solve many of these problems, but they introduce new ones...
```

Key rules:
- Timestamps in `[MM:SS]` or `[HH:MM:SS]` format — only when `transcript-source: vtt`.
- Speaker labels on every speaker change (or every few minutes for single-speaker).
- Do NOT add a "Key Points" section — that is summarization, which belongs in `{slug}-summary.md` or `synthesis.md` only.
- For podcasts with multiple speakers, clearly attribute each segment.
- The `transcript-source` field records which tier produced the text. Omit `duration` and `speakers` when caption, vision-ocr, or local-ocr was used (those tiers do not recover that metadata).

## Local files (already markdown)

Minimal transformation — add frontmatter, verify structure.

```markdown
---
slug: "internal-api-design-notes"
title: "Internal API Design Notes"
type: local
path: "docs/notes/api-design.md"
fetched: 2026-03-09T16:00:00Z
---

[Original file content, unchanged]
```

Key rules:
- Add frontmatter if missing
- Do not modify the content body

## Repositories

Mirror the repository tree structure under the source directory. Preserve directory hierarchy.

```
sources/express-framework/
  express-framework-snapshot.md    # Index file with frontmatter
  lib/
    router/
      index.js
      route.js
    application.js
  package.json
```

The index file (`{slug}-snapshot.md`) contains:

```markdown
---
slug: "express-framework"
title: "Express.js Framework"
type: repository
url: "https://github.com/expressjs/express"
fetched: 2026-03-09T16:30:00Z
highlights:
  - "lib/application.js"
  - "lib/router/index.js"
selective: true
---

# Express.js Framework

Repository overview and structure summary.
```

Key rules:
- Mirror directory tree faithfully
- For large repos, set `selective: true` and only ingest key files
- Populate `highlights` with the most important files
- The index file provides the frontmatter and a structural overview

## Documentation sites

Mirror the section hierarchy under the source directory. Preserve navigation structure.

```
sources/react-docs/
  react-docs-snapshot.md           # Index file with frontmatter
  getting-started/
    installation.md
    tutorial.md
  api-reference/
    hooks/
      useState.md
      useEffect.md
```

The index file (`{slug}-snapshot.md`) contains:

```markdown
---
slug: "react-docs"
title: "React Documentation"
type: documentation-site
url: "https://react.dev/learn"
fetched: 2026-03-09T17:00:00Z
highlights:
  - "api-reference/hooks/useState.md"
  - "getting-started/tutorial.md"
selective: true
---

# React Documentation

Site structure and section overview.
```

Key rules:
- Mirror section hierarchy from the site navigation
- Preserve internal links where possible (adjust to relative paths)
- For large sites, set `selective: true` and focus on relevant sections
- Populate `highlights` with the most important pages

## CLI tools

CLI captures use markdown with code fences. Help output stays in original format.

### Manpage capture

```markdown
---
slug: "git-manpage"
title: "git manpage"
type: cli-manpage
tool-name: "git"
fetched: 2026-04-07T16:00:00Z
---

# git manpage

```
[Raw manpage output here]
```
```

### Help output capture

```markdown
---
slug: "git-help-output"
title: "git --help output"
type: cli-help
tool-name: "git"
fetched: 2026-04-07T16:00:00Z
---

# git --help output

```
[Raw help output here]
```
```

### Subcommand help capture

```markdown
---
slug: "git-remote-help"
title: "git remote --help"
type: cli-subcommand-help
tool-name: "git"
command: "remote"
depth: 1
fetched: 2026-04-07T16:00:00Z
---

# git remote --help

```
[Raw subcommand help here]
```
```

Key rules:
- Keep exact formatting inside code fences.
- Use tool name in slug (like `git-manpage`, `git-help-output`).
- Add command path for subcommands (like `git-remote-help`).
- Set `depth: 1` for first-level subcommands, `depth: 2` for nested.
- Set `failed: true` in frontmatter if capture fails.
