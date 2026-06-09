# Tech Stack

swain-search is a pure skill — shell scripts and Python with no runtime dependencies beyond `uv`.

## Core

- **Shell (bash 3.2+)** — Bootstrap, export, snapshot pipeline, proxy resolution, trove maintenance
- **Python 3 (stdlib-only)** — Cookie conversion, X-thread fetching, VTT parsing
- **uv** — Python package manager; runs transient dependencies (`yt-dlp`, `opencv-python-headless`, `easyocr`, `ruamel.yaml`) via `uv run --with`

## Transient dependencies (not installed globally)

| Package | Used by | Purpose |
|---------|---------|---------|
| `yt-dlp` | `yt-dlp.sh` | Video/audio download and subtitle extraction |
| `opencv-python-headless` | `extract_frames.py` | Scene-change frame extraction |
| `easyocr` | `ocr_frames.py` | Local OCR fallback for videos without subtitles |
| `ruamel.yaml` | `migrate-to-troves.sh` | YAML migration (legacy) |

See `docs/tech-stack/` for additional detail.