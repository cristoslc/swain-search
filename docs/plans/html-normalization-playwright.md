# Sashay Plan: HTML Normalization Pipeline + Playwright Dynamic Capture

## Context

swain-search collects remote web sources but currently has no dedicated HTML-to-markdown normalization path. The `normalization-formats.md` and `source-collection.md` docs reference `writing-skills` / `skill-creator` for normalization, but those skills are not HTML normalizers. At the same time, swain-search lacks a local browser engine for JavaScript-heavy sites. This plan addresses both gaps as one pipeline: a general HTML normalization script plus an optional Playwright-based dynamic capture branch.

## Goals

1. Add a standalone HTML-to-markdown normalization script using `markdownify` (via `uv run --with markdownify`).
2. Add an optional Playwright-based dynamic capture script for JavaScript-rendered pages.
3. Wire both into the existing source-collection and snapshot-evidence-gate flow without special-casing dynamic sources.
4. Update reference documentation (`normalization-formats.md`, `source-collection.md`, `capability-detection.md`) to reflect the real pipeline.
5. Add or extend eval tests for graceful degradation and HTML source handling.

## Non-goals

- A separate `playwright-cli` package. The implementation stays inside `skills/swain-search/scripts/`.
- HAR / console log capture as trove records. These are debugging aids only.
- Making Playwright a hard dependency. It remains optional, installed on first dynamic capture.
- Paywall bypass or authentication beyond existing cookie support.

## Decisions from parley (2026-06-24)

- **Architecture**: uv-integrated Python scripts, internal to swain-search.
- **Dependency model**: optional; browser binary downloaded on first dynamic capture.
- **Snapshot evidence gate**:
  - Primary raw snapshot: rendered DOM HTML at `.agents/search-snapshots/raw/<source-id>.html`.
  - Supporting evidence: full-page screenshot at `.agents/search-snapshots/raw/<source-id>.png`.
  - Normalized artifact: markdown at `sources/<source-id>/<source-id>.md`.
- **Capability order**: existing browser/page-fetch tools → static fetch → laddered heuristic for dynamic detection → LLM fallback for ambiguous cases → Playwright.
- **HTML normalization**: `markdownify` as the baseline converter, used for all HTML snapshots, not just Playwright captures.
- **File layout**: no special subdirectories for dynamic sources.

## Work breakdown

### 1. Add `normalize-html.py`

- Location: `skills/swain-search/scripts/normalize-html.py`
- Input: path to raw HTML file, original URL, optional final URL, optional screenshot path.
- Output: markdown file with YAML frontmatter.
- Behavior:
  - Read HTML.
  - Convert to markdown with `markdownify`.
  - Extract `<title>` for frontmatter.
  - Write frontmatter: `source-id`, `title`, `type: web`, `url`, `fetched`, `hash` (hash of raw HTML), plus dynamic-only keys when applicable (`capture-engine: playwright`, `rendered-at`, `raw-snapshot`, `screenshot`, `final-url`).
- Usage pattern:
  ```bash
  uv run --with markdownify python3 "<SKILL_DIR>/scripts/normalize-html.py" \
    --raw ".agents/search-snapshots/raw/<source-id>.html" \
    --url "<original-url>" \
    --out "sources/<source-id>/<source-id>.md"
  ```

### 2. Add `capture-playwright.py`

- Location: `skills/swain-search/scripts/capture-playwright.py`
- Input: URL, output directory for raw snapshots, source ID.
- Output: rendered HTML and screenshot files.
- Behavior:
  - Attempt to import `playwright`. If missing, run `playwright install chromium` via subprocess on first invocation.
  - Launch headless Chromium, navigate to URL, wait for `networkidle`.
  - Capture final URL, rendered DOM HTML, full-page screenshot.
  - Write `.agents/search-snapshots/raw/<source-id>.html` and `.agents/search-snapshots/raw/<source-id>.png`.
  - Print JSON to stdout with `source-id`, `raw-path`, `screenshot-path`, `final-url`, `rendered-at`, `status`.
- Failure modes:
  - Import/install failure → exit non-zero with `failed: playwright-unavailable`.
  - Navigation timeout/error → exit non-zero with `failed: navigation-error`.
- Usage pattern:
  ```bash
  uv run --with playwright python3 "<SKILL_DIR>/scripts/capture-playwright.py" \
    --url "<url>" \
    --source-id "<source-id>" \
    --out-dir ".agents/search-snapshots/raw"
  ```

### 3. Add `needs-browser.py`

- Location: `skills/swain-search/scripts/needs-browser.py`
- Input: raw HTML file path or HTML string, original URL.
- Output: JSON decision: `needs-browser: true|false`, `reason`, `confidence: heuristic|llm`.
- Behavior:
  - Heuristic ladder:
    1. HTTP status not 2xx → true.
    2. Visible text word count under threshold (e.g., 200 words) → true.
    3. DOM markers of empty skeleton (`<div id="root"></div>`, `<div id="app"></div>` with no text children) → true.
    4. No `<main>`, `<article>`, or substantial `<body>` text → true.
  - If ambiguous after heuristics, call an LLM to decide.
- Usage pattern:
  ```bash
  uv run python3 "<SKILL_DIR>/scripts/needs-browser.py" --html ".agents/search-snapshots/raw/<source-id>.html"
  ```

### 4. Update `source-collection.md`

- Rewrite the "Web page URLs" section to use the new pipeline:
  1. Static fetch with `export-snapshot.sh`.
  2. Run `needs-browser.py` on the raw HTML.
  3. If dynamic: run `capture-playwright.py` to overwrite the raw HTML (and produce screenshot).
  4. Run `normalize-html.py` to produce the markdown source.
- Remove or correct references to `writing-skills` / `skill-creator` for HTML normalization.
- Document the `capture-engine: playwright` provenance keys.

### 5. Update `normalization-formats.md`

- Add a section for the HTML-to-markdown normalization contract.
- Document the common frontmatter extension for Playwright-captured sources.
- Clarify that verbatim reproduction applies to the normalized markdown, not the raw HTML noise.

### 6. Update `capability-detection.md`

- Add Playwright to the browser/page-fetcher detection list.
- Document the probe for Playwright availability in bootstrap.
- Add graceful-degradation message for missing Playwright on dynamic sources.

### 7. Update `bootstrap.sh`

- Add a lightweight probe: check if `uv run --with playwright python3 -c "import playwright"` succeeds.
- Do **not** install the browser binary at bootstrap time.
- Report availability status so capability detection can use it.

### 8. Tests

Per project standards, this sashay must include tests that expect failure before the fix and pass after.

- **Unit tests for `normalize-html.py`**:
  - A fixture HTML file with headings, paragraphs, code blocks, tables, images.
  - Expected markdown output after normalization.
  - A failure test that expects an error when the raw HTML file is missing.
- **Unit tests for `needs-browser.py`**:
  - Fixture: empty skeleton HTML → expects `needs-browser: true`.
  - Fixture: static article HTML → expects `needs-browser: false`.
  - Failure test: missing input → expects error.
- **Integration test for graceful degradation**:
  - When Playwright is unavailable, a dynamic source is marked `failed: playwright-unavailable` and the operator message is emitted.

Test location and runner are not yet declared in `AGENTS.md`. This sashay must add a `## Test command` section to the project-root `AGENTS.md` and choose a runner. Since the scripts are Python, use `pytest` invoked via `uv run --with pytest --with markdownify --with playwright pytest` from `skills/swain-search/`.

### 9. Evals

- Extend `skills/swain-search/evals/suites/graceful-degradation.yaml` with a case for missing Playwright.
- Add an eval suite or cases for HTML normalization if promptfoo supports tool/script assertions.

## Acceptance criteria

- [ ] `normalize-html.py` produces valid markdown from a fixture HTML file with correct frontmatter.
- [ ] `capture-playwright.py` captures rendered HTML and screenshot for a known dynamic site (or a local test server).
- [ ] `needs-browser.py` correctly flags a skeleton HTML file as dynamic and a static article as not dynamic.
- [ ] Missing Playwright degrades gracefully with a clear operator message and a `failed` manifest entry.
- [ ] `source-collection.md`, `normalization-formats.md`, and `capability-detection.md` describe the new pipeline accurately.
- [ ] `AGENTS.md` declares the test command.
- [ ] All tests pass.

## Deferred work

- Boilerplate stripping before or after `markdownify` (ads, nav, cookie banners). The current plan relies on `markdownify` verbatim conversion; targeted stripping can be added in a follow-up sashay if real sources show noise.
- Readability/main-content extraction if `markdownify` output is too noisy.
- Caching / reusing browser contexts across multiple sources in one session.

## Risks

- `playwright` browser binary download may be slow or fail in offline/locked-down environments. Mitigation: optional capability, clear degradation message.
- `markdownify` may produce noisy markdown from complex modern HTML. Mitigation: prototype with real fixtures; defer stripping to follow-up.
- Existing references to `writing-skills` / `skill-creator` may be load-bearing in some flow not yet inspected. Mitigation: grep the full repo and evals for these references during implementation.
