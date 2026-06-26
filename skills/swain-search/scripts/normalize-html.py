#!/usr/bin/env python3
"""normalize-html.py — Convert a raw HTML snapshot into a normalized markdown source.

Usage:
    uv run --with markdownify python3 "<SKILL_DIR>/scripts/normalize-html.py" \
        --raw <path-to-raw.html> \
        --url <source-url> \
        --out <path-to-output.md> \
        [--source-id <id>] \
        [--final-url <url>] \
        [--screenshot <path-to.png>] \
        [--capture-engine playwright]

Output: markdown file with YAML frontmatter and a verbatim markdown body.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

from bs4 import BeautifulSoup
from markdownify import markdownify as md


DYNAMIC_KEYS = frozenset({"capture-engine", "rendered-at", "raw-snapshot", "screenshot", "final-url"})


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Normalize a raw HTML snapshot to markdown with YAML frontmatter."
    )
    parser.add_argument("--raw", required=True, help="Path to the raw HTML file.")
    parser.add_argument("--url", required=True, help="Original source URL.")
    parser.add_argument("--out", required=True, help="Path to write the normalized markdown file.")
    parser.add_argument("--source-id", default=None, help="Source ID slug; derived from URL if omitted.")
    parser.add_argument("--final-url", default=None, help="Final URL after any redirects or JS navigation.")
    parser.add_argument("--screenshot", default=None, help="Path to supporting screenshot evidence.")
    parser.add_argument("--capture-engine", default=None, help="Capture engine used to produce the raw snapshot (e.g. playwright).")
    parser.add_argument("--rendered-at", dest="rendered_at", default=None, help="ISO timestamp when the browser rendered the page (for dynamic captures).")
    return parser.parse_args(argv)


def derive_source_id(url: str, title: str | None) -> str:
    """Create a URL-derived slug if no explicit source ID was supplied."""
    candidate = re.sub(r"^https?://", "", url)
    candidate = candidate.split("?")[0]
    candidate = re.sub(r"[^a-zA-Z0-9]+", "-", candidate)
    candidate = candidate.strip("-").lower()[:80]
    if candidate:
        return candidate
    if title:
        candidate = re.sub(r"[^a-zA-Z0-9]+", "-", title).strip("-").lower()[:80]
        if candidate:
            return candidate
    return "source"


def extract_title(html: str) -> str:
    soup = BeautifulSoup(html, "html.parser")
    if soup.title and soup.title.string:
        return soup.title.get_text(strip=True)
    h1 = soup.find("h1")
    if h1:
        return h1.get_text(strip=True)
    return ""


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def build_frontmatter(
    source_id: str,
    title: str,
    url: str,
    fetched: str,
    raw_hash: str,
    raw_path: Path,
    final_url: str | None,
    screenshot: str | None,
    capture_engine: str | None,
    rendered_at: str | None,
) -> dict[str, object]:
    frontmatter: dict[str, object] = {
        "source-id": source_id,
        "title": title,
        "type": "web",
        "url": url,
        "fetched": fetched,
        "hash": raw_hash,
    }

    if capture_engine:
        frontmatter["capture-engine"] = capture_engine
        frontmatter["rendered-at"] = rendered_at or fetched
        frontmatter["raw-snapshot"] = str(raw_path)
        if final_url:
            frontmatter["final-url"] = final_url
        if screenshot:
            frontmatter["screenshot"] = screenshot

    return frontmatter


def yaml_str(value: object) -> str:
    """Very small JSON-safe YAML-ish dumper for frontmatter values.

    Uses JSON-string quoting for any value that is not a plain scalar, so
    special characters (newlines, quotes, colons, leading digits) are handled
    safely without needing a full YAML library for this limited schema.
    """
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, list):
        return json.dumps(value)
    text = str(value)
    if not text:
        return '""'
    # Plain scalars are safe only when they contain no YAML-special characters
    # and do not look like booleans/null/numbers.
    if (
        re.search(r"[:#{}\[\],>&*|!%@`'\"\\\n\r\t]", text)
        or text in ("true", "false", "null", "yes", "no", "on", "off")
        or re.match(r"^[-+]?\d+(\.\d+)?$", text)
        or re.match(r"^\s", text)
        or re.match(r"\s$", text)
    ):
        return json.dumps(text)
    return text


def dump_frontmatter(frontmatter: dict[str, object]) -> str:
    lines = ["---"]
    for key, value in frontmatter.items():
        lines.append(f"{key}: {yaml_str(value)}")
    lines.append("---")
    return "\n".join(lines) + "\n"


def normalize(html: str) -> str:
    """Convert HTML to markdown while keeping the content as verbatim as possible."""
    return md(html, heading_style="ATX", bullets="-", strip=["script", "style"]).strip()


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    raw_path = Path(args.raw)
    out_path = Path(args.out)

    if not raw_path.exists():
        print(f"failed: raw-html-missing: {raw_path}", file=sys.stderr)
        return 1

    raw_bytes = raw_path.read_bytes()
    if not raw_bytes:
        print("failed: raw-html-empty", file=sys.stderr)
        return 1

    fetched = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    rendered_at = args.rendered_at or fetched
    raw_hash = sha256_hex(raw_bytes)
    html_text = raw_bytes.decode("utf-8", errors="replace")
    title = extract_title(html_text)
    source_id = args.source_id or derive_source_id(args.url, title)

    frontmatter = build_frontmatter(
        source_id=source_id,
        title=title,
        url=args.url,
        fetched=fetched,
        raw_hash=raw_hash,
        raw_path=raw_path,
        final_url=args.final_url,
        screenshot=args.screenshot,
        capture_engine=args.capture_engine,
        rendered_at=rendered_at,
    )

    body = normalize(html_text)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(dump_frontmatter(frontmatter) + "\n" + body + "\n", encoding="utf-8")

    print(json.dumps({
        "source-id": source_id,
        "normalized-path": str(out_path),
        "title": title,
        "hash": raw_hash,
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
