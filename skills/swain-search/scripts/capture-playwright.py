#!/usr/bin/env python3
"""capture-playwright.py — Render a dynamic web page and capture DOM + screenshot.

Usage:
    uv run --with playwright python3 "<SKILL_DIR>/scripts/capture-playwright.py" \
        --url <source-url> \
        --source-id <id> \
        --out-dir <snapshot-dir> \
        [--timeout <milliseconds>]

Output (stdout):
    JSON object with source-id, raw-path, screenshot-path, final-url, rendered-at, status.
"""

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Render a page in headless Chromium and capture DOM HTML + full-page screenshot."
    )
    parser.add_argument("--url", required=True, help="URL to capture.")
    parser.add_argument("--source-id", required=True, help="Source ID for naming output files.")
    parser.add_argument("--out-dir", required=True, help="Directory to write raw HTML and screenshot.")
    parser.add_argument("--timeout", type=int, default=30000, help="Navigation timeout in ms (default 30000).")
    return parser.parse_args(argv)


def ensure_playwright() -> None:
    """Attempt to import playwright. If missing, try to install Chromium."""
    try:
        import playwright  # noqa: F401
        return
    except ImportError:
        pass

    try:
        subprocess.run(
            [sys.executable, "-m", "playwright", "install", "chromium"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except subprocess.CalledProcessError as exc:
        print("failed: playwright-unavailable", file=sys.stderr)
        print(f"Playwright Chromium install failed: {exc.stderr or exc.stdout}", file=sys.stderr)
        sys.exit(1)

    try:
        import playwright  # noqa: F401
    except ImportError:
        print("failed: playwright-unavailable", file=sys.stderr)
        sys.exit(1)


def capture(url: str, source_id: str, out_dir: Path, timeout_ms: int) -> dict[str, object]:
    from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeoutError, Error as PlaywrightError

    out_dir = Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    raw_path = out_dir / f"{source_id}.html"
    screenshot_path = out_dir / f"{source_id}.png"
    rendered_at = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    browser = None
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            context = browser.new_context(viewport={"width": 1280, "height": 720})
            page = context.new_page()
            try:
                page.goto(url, wait_until="networkidle", timeout=timeout_ms)
            except PlaywrightTimeoutError:
                # networkidle may be too strict on slow sites; fall back to load state
                page.goto(url, wait_until="load", timeout=timeout_ms)

            final_url = page.url
            rendered_html = page.content()
            raw_path.write_text(rendered_html, encoding="utf-8")
            page.screenshot(path=str(screenshot_path), full_page=True)
    except PlaywrightTimeoutError:
        print("failed: navigation-error", file=sys.stderr)
        print(f"Navigation timed out for {url}", file=sys.stderr)
        sys.exit(1)
    except PlaywrightError as exc:
        print("failed: navigation-error", file=sys.stderr)
        print(f"Playwright could not navigate {url}: {exc}", file=sys.stderr)
        sys.exit(1)
    finally:
        if browser:
            browser.close()

    return {
        "source-id": source_id,
        "raw-path": str(raw_path),
        "screenshot-path": str(screenshot_path),
        "final-url": final_url,
        "rendered-at": rendered_at,
        "status": "ok",
    }


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    ensure_playwright()
    result = capture(args.url, args.source_id, Path(args.out_dir), args.timeout)
    print(json.dumps(result))
    return 0


if __name__ == "__main__":
    sys.exit(main())
