# Parley: Playwright-based browser capture for swain-search

## Topic

Whether and how to add a Playwright-based browser engine to swain-search for JavaScript-heavy sources, choosing between:

- **A. playwright-cli** — a separate CLI helper invoked by swain-search scripts
- **B. playwright-via-uv** — a Python dependency managed by the existing `uv` bootstrap, used by an in-process script

## Opening position

I lean toward **B (playwright-via-uv)** integrated as an optional capability, not a hard dependency. swain-search already uses `uv run --with <dep> python3 "<SKILL_DIR>/scripts/..."` patterns for optional heavyweights like `opencv-python-headless` and `easyocr`. That keeps the bootstrap lightweight while allowing on-demand browser capture. But "optional" has a real tension with the snapshot evidence gate and graceful-degradation policy.

## Tension backlog

1. Required vs optional dependency model — **RESOLVED: optional capability; binary downloaded on first dynamic capture, not during bootstrap**
2. Snapshot evidence gate artifacts (what counts as "raw snapshot" for a Playwright capture?) — **RESOLVED: rendered DOM HTML is primary raw snapshot; full-page screenshot is supporting evidence; readable text extraction is secondary normalized artifact**
3. Offline / heavy-download behavior (Chromium binary) — **RESOLVED: bootstrap only probes availability; actual download happens on first capture; failure degrades with `failed: dynamic-render` and clear operator message**
4. CLI vs uv-integrated architecture — **RESOLVED: uv-integrated, internal only**
5. Capability-detection overlap with existing browser/page-fetch tools — **RESOLVED: static fetch first, then laddered heuristic (status, body length, DOM markers), then LLM fallback, then Playwright**
6. Trove normalization format for dynamic-page snapshots

## Resolutions

- **CLI vs uv-integrated**: uv-integrated Python script under `skills/swain-search/scripts/`, internal to swain-search for the foreseeable future. A separate CLI package is premature overhead.
- **Dependency model**: optional capability; Playwright browser binary installed on first dynamic capture, not during bootstrap.
- **Snapshot evidence gate**: rendered DOM HTML is the primary raw snapshot; full-page screenshot is supporting evidence; readable text extraction is the secondary normalized artifact. HAR/console logs are debugging aids only, not trove records.
- **Offline/heavy download**: bootstrap only probes availability; actual download happens on first capture; failure degrades with `failed: dynamic-render` and a clear operator message.
- **Capability overlap**: Playwright is the fallback of last resort. Collection order is (1) existing browser/page-fetch tools, (2) static fetch, (3) laddered heuristic for dynamic detection, (4) LLM fallback for ambiguous cases, (5) Playwright capture.
- **File layout and provenance**: no special subdirectories. Raw rendered HTML lives at `.agents/search-snapshots/raw/<source-id>.html`; supporting screenshot at `.agents/search-snapshots/raw/<source-id>.png`; normalized markdown at `sources/<source-id>/<source-id>.md` with extra frontmatter keys `capture-engine: playwright`, `rendered-at`, `raw-snapshot`, `screenshot`, `final-url`.
- **HTML normalization gap**: swain-search lacks a general-purpose HTML-to-markdown path. Existing references to `writing-skills`/`skill-creator` for normalization are inaccurate for HTML. The sashay must add a baseline HTML-to-markdown script using `markdownify` (via `uv run --with markdownify`), applicable to all HTML snapshots, not just Playwright captures.
- **Scope**: broaden the sashay from "add Playwright" to "establish a complete HTML capture and normalization pipeline in swain-search", with Playwright as the dynamic-capture branch.


## Resolutions

- **CLI vs uv-integrated**: uv-integrated Python script under `skills/swain-search/scripts/`, internal to swain-search for the foreseeable future. A separate CLI package is premature overhead.
