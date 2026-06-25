"""Tests for needs-browser.py."""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "needs-browser.py"
FIXTURES = Path(__file__).resolve().parent / "fixtures"


def run_needs_browser(argv: list[str]) -> tuple[int, dict, str]:
    """Run needs-browser.py and parse its JSON output."""
    cmd = [sys.executable, str(SCRIPT)] + argv
    result = subprocess.run(cmd, capture_output=True, text=True)
    parsed = json.loads(result.stdout) if result.returncode == 0 and result.stdout.strip() else {}
    return result.returncode, parsed, result.stderr


def test_empty_skeleton_needs_browser():
    """Empty JS app skeleton is flagged as needing a browser."""
    code, parsed, stderr = run_needs_browser([
        "--html", str(FIXTURES / "empty-skeleton.html"),
        "--url", "https://example.com/app",
    ])
    assert code == 0, stderr
    assert parsed["needs-browser"] is True
    assert "skeleton" in parsed["reason"].lower() or "word" in parsed["reason"].lower()
    assert parsed["confidence"] == "heuristic"


def test_static_article_does_not_need_browser():
    """Static article with <article> and substantial text does not need a browser."""
    code, parsed, stderr = run_needs_browser([
        "--html", str(FIXTURES / "static-article.html"),
        "--url", "https://example.com/article",
    ])
    assert code == 0, stderr
    assert parsed["needs-browser"] is False
    assert parsed["confidence"] == "heuristic"


def test_missing_input_errors():
    """Expected failure: missing/empty HTML input causes an error."""
    code, parsed, stderr = run_needs_browser([
        "--html", "",
    ])
    assert code != 0
    assert "failed: html-input-empty" in stderr


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
