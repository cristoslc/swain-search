# Musing: adding playwright-cli or playwright-via-uv to swain-search toolset?

## Context

swain-search currently performs web source collection using whatever page-fetching tools are present in the ambient environment (see [capability-detection.md](../../skills/swain-search/references/capability-detection.md)). The SKILL.md lists generic patterns: tools with "fetch", "webpage", "browser" in the name. It does **not** yet include a dedicated, local browser engine for JavaScript-heavy sites.

## Idea

Add a Playwright-based collection capability to the swain-search toolset. Two candidate forms:

1. **playwright-cli** — a separate CLI tool invoked by swain-search scripts (e.g., `swain-search-playwright fetch <url>`).
2. **playwright-via-uv** — a Python script managed by the existing `uv` bootstrap, importing `playwright` and running in-process.

## Why it matters

- Many modern pages fail simple HTTP fetches because content is rendered client-side.
- The current "Browser / page fetcher" fallback says: "Try basic URL fetch. If that fails, ask the user for content." That's a hard stop for dynamic sources.
- A local Playwright instance would let swain-search capture full-page DOM, screenshots, and HAR-like metadata as raw snapshots before normalization.

## Open questions (raw, unordered)

- Should this be an **optional dependency** (gracefully degrade when not installed) or a **required** addition to the bootstrap script?
- How does it fit the **snapshot evidence gate**? Playwright can produce raw HTML, screenshot, and network log; which artifacts become the "raw snapshot"?
- Should we prefer `uv add playwright` inside the bootstrap, or ship a small helper script that shells out to `playwright install` on first use?
- What about environments without browsers? Playwright's `chromium` download can be heavy; how do we behave offline?
- Should the new capability be exposed as a script under `skills/swain-search/scripts/` or as a standalone `tools/playwright-cli/` package?
- Does this overlap with or subsume any existing `browser_navigate` / `webpage-to-markdown` detection path?
- What's the trove normalization format for a Playwright snapshot? Add a new section to `normalization-formats.md`?

## Next step

Convert this musing into a planned sashay with a scope decision (cli vs. uv-integrated, required vs. optional) and a prototype path. Do not implement from the musing; follow worktree discipline and branch from trunk.
