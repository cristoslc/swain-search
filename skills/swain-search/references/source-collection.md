# Source Collection

For each source, use the appropriate capability. Read `normalization-formats.md` for the exact markdown structure per source type.

Every source must be a verbatim reproduction of the original. See [verbatim-mandate.md](verbatim-mandate.md) for the full policy. For remote sources, also follow the [snapshot-evidence-gate.md](snapshot-evidence-gate.md) flow.

## Web search queries

1. Use a web search capability to find relevant results
2. Select the top 3-5 most relevant results
3. For each: fetch the page, normalize to markdown per the web page format
4. If no web search capability is available, tell the user and skip

## Web page URLs

1. Fetch the page using a browser or page-fetching capability
2. Strip boilerplate (nav, ads, sidebars, cookie banners)
3. Normalize to markdown per the web page format
4. If fetch fails, record the URL in manifest with a `failed: true` flag and move on

## Sites needing authentication (cookie support)

When a target site requires authentication or subscription access, supply browser-exported cookies:

1. Export cookies from a browser where you are logged in to the target site:
   - Firefox: use the "cookies.txt" extension, or export from DevTools → Storage → Cookies → right-click → "Export All".
   - Chrome: use the "EditThisCookie" extension or DevTools → Application → Cookies → right-click → "Export".
   - Any tool that produces a JSON array of cookie objects with `Host raw`, `Name raw`, `Content raw`, `Path raw`, `Expires raw`, `Send for raw`, and `This domain only raw` fields.

2. Pass the exported JSON file to `export-snapshot.sh`:
   ```bash
   bash "<SKILL_DIR>/scripts/export-snapshot.sh" \
     --url "<source-url>" \
     --out-dir ".agents/search-snapshots/raw" \
     --cookies "path/to/cookies.json"
   ```
   The `--cookies` flag triggers conversion to Netscape format via `convert-cookies.py` and attaches the cookie jar to the curl request. The export mode is recorded as `<mode>-with-cookies`.

3. If no cookies are provided, the fetch proceeds without authentication (same behaviour as before).

4. For the browser-based page-fetching path (MCP browser tools), cookies from the browser's own session are available automatically — no explicit cookies file is needed. This flag is useful for curl-based snapshot export.

## Google Docs / Drive-like documents

1. Export raw content first (required):
   - `bash "<SKILL_DIR>/scripts/export-snapshot.sh" --url "<source-url>" --out-dir ".agents/search-snapshots/raw"`
2. Prefer API export modes (`google-doc-export`, `google-slides-export`, `google-drive-download`).
3. If API export fails, use a browser helper fallback only when available.
4. Normalize the exported file with `writing-skills` or `skill-creator`.
5. Log metadata in `.agents/search-snapshots/metadata.jsonl`.
6. Verify with `verify-snapshot-evidence.sh` before including the source in trove outputs.

## Paywall proxy fallback

After fetching a web page, check if a paywall proxy is available for the URL's domain:

1. Run `bash "<SKILL_DIR>/scripts/resolve-proxy.sh" <url>`
   - **Exit 1**: no proxy configured — use the direct fetch content as-is
   - **Exit 0**: outputs `PROXY:<name>:<proxy-url>` and `SIGNAL:<text>` lines
2. If exit 0, check the fetched content for each `SIGNAL` text (case-sensitive literal match)
3. If any signal matches (or the article body is under ~200 words):
   - Log: "Paywall detected for `<url>` — trying proxy fallback"
   - Try each `PROXY` URL in order, fetching via the same page-fetching capability used for web pages
   - First proxy that returns substantive content (more than the truncated original) wins
   - Set `proxy-used: <name>` and `notes: "Full article retrieved via <name> proxy"` in the manifest entry
4. If no signals match: use the direct fetch content as-is (no proxy needed)
5. If all proxies fail: keep the original truncated content, set `notes: "Paywalled; proxies exhausted — content from direct fetch only"`

The registry lives at `paywall-proxies.yaml`. Add new domains or proxies there — no skill file changes needed.

## Video/audio URLs (YouTube, Instagram, podcasts)

Follow the tiered chain below. Each tier writes `/tmp/swain_search_media_transcript.txt`. That file is then normalized per the media format in `normalization-formats.md`. The output goes to `sources/<source-id>/<source-id>.md`.

1. **Fetch subs and metadata** via a single yt-dlp call:
   ```bash
   bash "<SKILL_DIR>/scripts/yt-dlp.sh" --write-auto-sub --sub-lang en --write-info-json --skip-download --sub-format vtt -o "/tmp/swain_search_media" "<URL>"
   ```
   For Instagram URLs, add `--cookies-from-browser <browser>` (chrome/safari/firefox/brave). For podcast or conference URLs not already on YouTube, resolve the title to a YouTube link first via a web-search capability.

2. **VTT path (preferred)**. If `/tmp/swain_search_media.en.vtt` exists and is non-empty:
   ```bash
   test -s /tmp/swain_search_media.en.vtt && uv run "<SKILL_DIR>/scripts/parse_vtt.py"
   ```
   The script writes `[HH:MM:SS] line` segments. Set `transcript-source: vtt` in the source frontmatter.

3. **Caption fallback**. If no VTT, read `/tmp/swain_search_media.info.json` and take the `description` field. Strip `#\w+` tags. Strip leading and trailing whitespace. If the remaining text is over 100 characters, write it to `/tmp/swain_search_media_transcript.txt` (one paragraph per line). Set `transcript-source: caption`. Omit timestamps.

4. **Frame-extraction fallback (needs operator approval)**. If the caption is too short (100 chars or fewer), stop and ask:
   > No subtitles or usable caption found. I can extract frames and read on-screen text to build a transcript. This needs `opencv-python-headless` (~30MB, via uv). Proceed?

   On approval:
   - Download the video: `bash "<SKILL_DIR>/scripts/yt-dlp.sh" -o "/tmp/swain_search_video.mp4" "<URL>"`. Add `--cookies-from-browser <browser>` for Instagram.
   - Extract frames: `uv run --with opencv-python-headless python3 "<SKILL_DIR>/scripts/extract_frames.py" /tmp/swain_search_video.mp4`. Saves `/tmp/swain_search_frame_000.png` and up, via scene-change detection.
   - **Probe vision**. Use the Read tool on `/tmp/swain_search_frame_000.png`. Try to read the visible text. If that works, go to step 5. If not, go to step 6.

5. **Vision OCR (preferred)**. Use the Read tool on each remaining frame. Extract all visible text. Dedupe adjacent-frame repeats. Write the text to `/tmp/swain_search_media_transcript.txt`. Set `transcript-source: vision-ocr`. No timestamps.

6. **Local OCR fallback**. If vision fails, ask:
   > Vision not available. Falling back to local OCR via EasyOCR (~400MB first-run download). Proceed?

   On approval:
   ```bash
   uv run --with "easyocr,opencv-python-headless" python3 "<SKILL_DIR>/scripts/ocr_frames.py"
   ```
   Set `transcript-source: local-ocr`. No timestamps.

7. **Normalize and write the source**. Derive the source ID slug from the video title. Use lowercase, numbers, and hyphens only. Write `sources/<source-id>/<source-id>.md` per the media format. Add `transcript-source` to the frontmatter. Add `duration`, `speakers`, and YouTube deep-links only when step 2 ran.

If no tier succeeds, record the source in the manifest with `failed: true` and `reason: <tier>`.

## X/Twitter threads

URL pattern: `(x|twitter|fxtwitter|fixupx).com/.+/status/\d+`. Unrolled via the public fxtwitter API. No auth needed.

1. Fetch the thread:
   ```bash
   uv run "<SKILL_DIR>/scripts/fetch_x_thread.py" "<URL>"
   ```
   The script writes two files: `/tmp/swain_search_thread.json` holds the raw response, and `/tmp/swain_search_thread_transcript.txt` holds the stitched transcript with cited-post blockquotes. It also prints a metadata JSON object to stdout. Capture these fields: `author_name`, `author_handle`, `author_url`, `published_date`, `tweet_count`, `title_guess`, `source_url`, `post_urls`, `cited_posts`.

2. **Unrollable thread**. If the script exits with "only 1 post returned" on a thread-opener, the upstream deployment lacks an account proxy. Record the entry with `failed: true` and `reason: x-thread-unrollable`. Move on.

3. Derive the source ID as `<author_handle>-<first-few-title-words>`. Sanitize to lowercase, numbers, and hyphens only. Strip any `@`.

4. Normalize per the x-thread format in `normalization-formats.md`:
   - Frontmatter: add `author-handle`, `author-name`, `published-date`, and `tweet-count` to the common fields.
   - Body: render every post verbatim as a numbered list. Hyperlink each number back to its tweet URL. Strip leading auto-mention chains. These are the `@handle` prefixes X adds to replies. Hyperlink inline `@mentions` as `[@handle](https://x.com/handle)`. Hyperlink hashtags as `[#tag](https://x.com/hashtag/tag)`.
   - Cited posts: render each `cited_posts` entry as an indented blockquote under the citing post. Append up to 3 substantive self-replies as continuation. Skip bare-URL self-replies; they already appear in `external_links`. Link out if more than 3 self-replies exist.

5. Save to `sources/<source-id>/<source-id>.md`.

## Local files

1. Use a document conversion capability (PDF, DOCX, etc.) or read directly if already markdown
2. Normalize per the document format using `writing-skills` or `skill-creator`
3. For markdown files: add frontmatter only, preserve content

## Forum threads / discussions

1. Fetch and normalize per the forum format (chronological, author-attributed)
2. Flatten nested threads to chronological order with reply-to context

## Repositories

1. Clone or read the repository contents
2. Mirror the original directory tree under `sources/<source-id>/`
3. Default: mirror the full tree. For large repositories (thousands of files), ingest selectively and set `selective: true` in the manifest entry
4. Populate the `highlights` array with paths to the most important files (relative to the source-id directory)

## Documentation sites

1. Crawl or fetch the documentation site
2. Mirror the section hierarchy under `sources/<source-id>/`
3. Default: mirror the full site. For large sites, ingest selectively and set `selective: true`
4. Populate the `highlights` array with paths to the most important pages
5. Preserve internal link structure where possible

## CLI tools

First, detect if the target is a CLI tool. Check these criteria:
- The target exists in `PATH` (run `command -v <tool-name>`)
- The name matches CLI patterns (lowercase, hyphens, no spaces)
- The context indicates a command-line tool

If the target is a CLI tool, run the capture sequence:

1. **Manpage capture:**
   - Run `man <tool-name>`
   - If successful, save as `cli-manpage` type
   - If no manpage, skip to help capture

2. **Primary help capture:**
   - Run `<tool-name> --help`
   - If that fails, try `<tool-name> -h`
   - Save as `cli-help` type

3. **Subcommand discovery:**
   - Look for these patterns in help output:
     - "Commands:" or "Subcommands:" headings
     - Indented command lists under "Usage:" sections
     - Command patterns like `<tool> <command> [options]`
   - Filter out non-commands:
     - Keep single words or hyphenated strings
     - Keep positional arguments from usage lines
     - Skip anything starting with `-` (those are flags)

4. **Recursive subcommand capture:**
   - For each subcommand, run `<tool-name> <subcommand> --help`
   - Save as `cli-subcommand-help` with `depth: 1`
   - If subcommand has its own subcommands, go one level deeper
   - Maximum depth: 2 levels

5. **Failure handling:**
   - No manpage? Use help capture only
   - Both `--help` and `-h` fail? Note in manifest
   - All captures fail? Mark as `failed: true` and continue

Each capture becomes a separate source:
- `sources/<tool>-manpage/<tool>-manpage.md` (type: `cli-manpage`)
- `sources/<tool>-help/<tool>-help.md` (type: `cli-help`)
- `sources/<tool>-<subcommand>-help/<tool>-<subcommand>-help.md` (type: `cli-subcommand-help`)

## Source ID generation

Each normalized source gets a **slug-based source ID** and lives in a directory-per-source layout:
- **Flat sources** (web, forum, media, document, local): `sources/<source-id>/<source-id>.md`
- **Hierarchical sources** (repository, documentation-site): `sources/<source-id>/` with the original tree mirrored inside

Derive the source ID as a slug from the source title or URL (e.g., `mdn-websocket-api`, `strangeloop-2025-realtime`). When a slug collides with an existing source ID: append `__word1-word2` using two random words from `wordlist.txt`. If the wordlist is missing, append `__` followed by 4 hex characters (e.g., `__a3f8`) as a fallback.