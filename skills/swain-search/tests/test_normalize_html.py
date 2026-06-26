"""Tests for normalize-html.py."""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "normalize-html.py"
FIXTURES = Path(__file__).resolve().parent / "fixtures"


def run_normalize(argv: list[str]) -> tuple[int, str, str]:
    """Run normalize-html.py with the given CLI arguments."""
    cmd = [sys.executable, str(SCRIPT)] + argv
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode, result.stdout, result.stderr


def test_normalize_fixture():
    """normalize-html.py produces valid markdown with correct frontmatter."""
    raw = FIXTURES / "sample-article.html"
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp) / "output.md"
        code, stdout, stderr = run_normalize([
            "--raw", str(raw),
            "--url", "https://example.com/sample-article",
            "--out", str(out),
            "--source-id", "sample-article",
            "--capture-engine", "playwright",
            "--final-url", "https://example.com/app",
            "--screenshot", ".agents/search-snapshots/raw/sample-article.png",
        ])
        assert code == 0, stderr

        meta = json.loads(stdout)
        assert meta["source-id"] == "sample-article"
        assert meta["title"] == "Sample Article"
        assert meta["normalized-path"] == str(out)
        assert "hash" in meta

        content = out.read_text(encoding="utf-8")
        assert content.startswith("---\n")
        assert "source-id: sample-article" in content
        assert 'title: "Sample Article"' in content or 'title: Sample Article' in content
        assert "type: web" in content
        assert 'url: "https://example.com/sample-article"' in content
        assert "capture-engine: playwright" in content
        assert 'final-url: "https://example.com/app"' in content
        assert 'screenshot: ".agents/search-snapshots/raw/sample-article.png"' in content or 'screenshot: .agents/search-snapshots/raw/sample-article.png' in content
        assert "rendered-at:" in content

        # Verbatim body checks
        assert "# Sample Article" in content
        assert "## Code section" in content
        assert '```python' in content or '```' in content
        assert "def hello():" in content
        assert "## Table section" in content
        assert "| Name | Value |" in content or "|Name|Value|" in content
        assert "alpha" in content
        assert "![A diagram](https://example.com/diagram.png)" in content


def test_rendered_at_provenance():
    """rendered-at must equal the --rendered-at value, not normalization-time fetched."""
    raw = FIXTURES / "sample-article.html"
    rendered = "2024-01-15T09:30:00Z"
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp) / "output.md"
        code, stdout, stderr = run_normalize([
            "--raw", str(raw),
            "--url", "https://example.com/sample-article",
            "--out", str(out),
            "--source-id", "sample-article",
            "--capture-engine", "playwright",
            "--rendered-at", rendered,
        ])
        assert code == 0, stderr

        content = out.read_text(encoding="utf-8")
        assert f'rendered-at: "{rendered}"' in content
        # fetched is generated at runtime, so just ensure rendered-at is the user value
        # and not an empty/quoted placeholder.
        assert 'rendered-at: "2024-01-15T09:30:00Z"' in content


def test_rendered_at_defaults_to_fetched_when_omitted():
    """Without --rendered-at, rendered-at falls back to fetched."""
    raw = FIXTURES / "sample-article.html"
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp) / "output.md"
        code, stdout, stderr = run_normalize([
            "--raw", str(raw),
            "--url", "https://example.com/sample-article",
            "--out", str(out),
            "--source-id", "sample-article",
            "--capture-engine", "playwright",
        ])
        assert code == 0, stderr

        content = out.read_text(encoding="utf-8")
        lines = [line for line in content.splitlines() if line.startswith("rendered-at:")]
        assert len(lines) == 1
        rendered_value = lines[0].split(":", 1)[1].strip().strip('"')
        fetched_lines = [line for line in content.splitlines() if line.startswith("fetched:")]
        assert len(fetched_lines) == 1
        fetched_value = fetched_lines[0].split(":", 1)[1].strip().strip('"')
        assert rendered_value == fetched_value


def test_missing_raw_file():
    """Expected failure: normalize-html.py errors when the raw HTML file is missing."""
    with tempfile.TemporaryDirectory() as tmp:
        missing = Path(tmp) / "missing.html"
        out = Path(tmp) / "output.md"
        code, stdout, stderr = run_normalize([
            "--raw", str(missing),
            "--url", "https://example.com",
            "--out", str(out),
        ])
        assert code != 0
        assert "failed: raw-html-missing" in stderr
        assert not out.exists()


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
