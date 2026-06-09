# Capability Detection and Graceful Degradation

Before collecting sources, check what's available. Look for tools matching these patterns — the exact tool names vary by installation:

- **Web search**: tools with "search" in the name (e.g., `brave_web_search`, `bing-search-to-markdown`)
- **Page fetching**: tools with "fetch", "webpage", "browser" in the name (e.g., `fetch_content`, `webpage-to-markdown`, `browser_navigate`)
- **Media transcription**: tools with "audio", "video", "youtube" in the name (e.g., `audio-to-markdown`, `youtube-to-markdown`)
- **Document conversion**: tools with "pdf", "docx", "pptx", "xlsx" in the name (e.g., `pdf-to-markdown`, `docx-to-markdown`)
- **CLI tool capture**: built-in bash capabilities (`man`, command execution) — always available on POSIX systems

Report available capabilities at the start of collection so the user knows what will and won't work.

## Graceful degradation

When a capability isn't available:

| Capability | Fallback |
|-----------|----------|
| Web search | Skip search-based sources. Tell user: "No web search capability available — provide URLs directly or add a search MCP." |
| Browser / page fetcher | Try basic URL fetch. If that fails: "Can't fetch this URL — paste the content or provide a local file." |
| Snapshot export for remote docs | If export fails and no helper exists: mark source unverified, do not publish downstream, report exact URL and failure mode. |
| Media transcription | "No transcription capability available — provide a pre-made transcript file, or add a media conversion tool." |
| Document conversion | "Can't convert this file type — provide a markdown version, or add a document conversion tool." |
| Paywall proxy | Keep truncated content. Note in manifest: "Paywalled; proxies exhausted." Suggest user provide content manually. |

Never fail the entire run because one capability is missing. Collect what you can, skip what you can't, and report clearly.