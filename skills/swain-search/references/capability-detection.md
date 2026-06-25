# Capability Detection and Graceful Degradation

Before collecting sources, check what's available. Look for tools matching these patterns — the exact tool names vary by installation:

- **Web search**: tools with "search" in the name (e.g., `brave_web_search`, `bing-search-to-markdown`)
- **Page fetching**: tools with "fetch", "webpage", "browser" in the name (e.g., `fetch_content`, `webpage-to-markdown`, `browser_navigate`)
- **Browser rendering**: Playwright via `capture-playwright.py` (optional; detects and installs Chromium on first use)
- **Media transcription**: tools with "audio", "video", "youtube" in the name (e.g., `audio-to-markdown`, `youtube-to-markdown`)
- **Document conversion**: tools with "pdf", "docx", "pptx", "xlsx" in the name (e.g., `pdf-to-markdown`, `docx-to-markdown`)
- **CLI tool capture**: built-in bash capabilities (`man`, command execution) — always available on POSIX systems

## Playwright availability

`bootstrap.sh` performs a lightweight probe without downloading the browser binary:

```bash
uv run --with playwright python3 -c "import playwright" 2>/dev/null
```

- If the import succeeds, the skill reports `playwright: available`.
- If it fails, the skill reports `playwright: not installed` and tells the operator that dynamic captures require `uv run --with playwright python3 -m playwright install chromium`.

Do not install Chromium at bootstrap time; the binary is large and may fail in offline/locked-down environments.

Report available capabilities at the start of collection so the user knows what will and won't work.

## Graceful degradation

When a capability isn't available:

| Capability | Fallback |
|-----------|----------|
| Web search | Skip search-based sources. Tell user: "No web search capability available — provide URLs directly or add a search MCP." |
| Browser / page fetcher | Try basic URL fetch. If that fails: "Can't fetch this URL — paste the content or provide a local file." |
| Browser rendering (Playwright) | Mark dynamic source as `failed: playwright-unavailable`. Operator message: "Playwright is not installed. Run `uv run --with playwright python3 -m playwright install chromium` or add it to your environment." Static fallback: keep the original static snapshot and attempt `normalize-html.py` on it. |
| Snapshot export for remote docs | If export fails and no helper exists: mark source unverified, do not publish downstream, report exact URL and failure mode. |
| Media transcription | "No transcription capability available — provide a pre-made transcript file, or add a media conversion tool." |
| Document conversion | "Can't convert this file type — provide a markdown version, or add a document conversion tool." |
| Paywall proxy | Keep truncated content. Note in manifest: "Paywalled; proxies exhausted." Suggest user provide content manually. |

Never fail the entire run because one capability is missing. Collect what you can, skip what you can't, and report clearly.