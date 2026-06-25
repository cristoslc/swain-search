#!/usr/bin/env python3
"""needs-browser.py — Decide whether a raw HTML snapshot needs browser rendering.

Usage:
    uv run python3 "<SKILL_DIR>/scripts/needs-browser.py" \
        --html <path-to-raw.html> \
        [--url <source-url>] \
        [--llm-fallback]

Output (stdout):
    JSON object with needs-browser (bool), reason, and confidence (heuristic|llm).
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Heuristic detector for whether a page needs browser rendering."
    )
    parser.add_argument("--html", required=True, help="Path to raw HTML file or a literal HTML string.")
    parser.add_argument("--url", default=None, help="Original URL (informational only).")
    parser.add_argument(
        "--llm-fallback",
        action="store_true",
        default=False,
        help="If heuristics are ambiguous, default to browser rendering. (LLM hook is not implemented; this flag is a conservative browser-on-ambiguous default.)",
    )
    parser.add_argument(
        "--word-threshold",
        type=int,
        default=80,
        help="Minimum visible-text word count to be considered non-skeletal (default 80).",
    )
    return parser.parse_args(argv)


def is_likely_html(text: str) -> bool:
    return bool(re.search(r"</html>|</body>|<head\b|<!DOCTYPE\s+html", text, re.IGNORECASE))


def read_input(value: str) -> tuple[str, bool]:
    """Return (html, is_path). If value is a path to a file, read it."""
    if not value:
        return "", False
    candidate = Path(value)
    if candidate.is_file():
        return candidate.read_text(encoding="utf-8", errors="replace"), True
    return value, False


def visible_text_word_count(html: str) -> int:
    """Strip script/style and count remaining words in visible text."""
    text = re.sub(r"<script\b[^>]*>.*?</script>", "", html, flags=re.IGNORECASE | re.DOTALL)
    text = re.sub(r"<style\b[^>]*>.*?</style>", "", text, flags=re.IGNORECASE | re.DOTALL)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return len(text.split()) if text else 0


def has_empty_skeleton(html: str) -> bool:
    """Detect common JS app mount points with little or no text inside."""
    for marker_id in ("root", "app", "__next", "__nuxt"):
        pattern = rf'<div[^>]*?\bid\s*=\s*["\']?{marker_id}["\']?\b[^>]*>(.*?)</div>'
        match = re.search(pattern, html, re.IGNORECASE | re.DOTALL)
        if match:
            inner_text = re.sub(r"<[^>]+>", " ", match.group(1))
            inner_text = re.sub(r"\s+", " ", inner_text).strip()
            if len(inner_text.split()) < 10:
                return True
    return False


def has_no_main_content(html: str) -> bool:
    """True if there is no main/article element and little body text."""
    has_main = bool(re.search(r"<(main|article)\b", html, re.IGNORECASE))
    if has_main:
        return False
    body_match = re.search(r"<body[^>]*>(.*)</body>", html, re.IGNORECASE | re.DOTALL)
    if body_match:
        body_text = body_match.group(1)
        word_count = visible_text_word_count(body_text)
        return word_count < 50
    return True


def http_status(html: str) -> int | None:
    """Try to infer an HTTP error from a very minimal status-ish document."""
    # This is a best-effort heuristic; in practice we rely on the caller to
    # pass status via the snapshot metadata. We do not have status here.
    return None


def heuristic_decide(html: str, word_threshold: int) -> tuple[bool, str, str | None]:
    """Return (needs_browser, reason, ambiguity_flag)."""
    word_count = visible_text_word_count(html)
    if word_count == 0:
        return True, "no visible text", None
    if word_count < word_threshold:
        return True, f"visible text under {word_threshold} words ({word_count})", None
    if has_empty_skeleton(html):
        return True, "empty JS app skeleton detected", None
    if has_no_main_content(html):
        return True, "no <main> / <article> and little body text", "sparse"
    return False, f"substantial static content ({word_count} words)", None


def llm_fallback_decide(html: str, url: str | None) -> tuple[bool, str]:
    """Placeholder for LLM-based dynamic detection.

    The actual implementation would call an LLM with the HTML and URL. This
    placeholder returns the conservative answer: if we are still uncertain,
    assume the page needs a browser so we do not miss dynamic content.

    The confidence returned to callers remains 'llm' so tooling can detect
    that the placeholder path was taken; a real implementation will keep the
    same contract.
    """
    return True, "LLM fallback: ambiguous markup, defaulting to browser rendering (LLM hook not implemented)"


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    html, was_path = read_input(args.html)

    if was_path and not html:
        print(f"failed: html-input-empty: {args.html}", file=sys.stderr)
        return 1

    if not html:
        print("failed: html-input-empty", file=sys.stderr)
        return 1

    needs, reason, ambiguity = heuristic_decide(html, args.word_threshold)
    confidence = "heuristic"

    if ambiguity and args.llm_fallback:
        needs, reason = llm_fallback_decide(html, args.url)
        confidence = "llm"

    print(json.dumps({
        "needs-browser": needs,
        "reason": reason,
        "confidence": confidence,
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
