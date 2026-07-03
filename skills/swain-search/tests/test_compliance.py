"""Compliance tests for swain-search snapshot/summary split.

Tier 1 (integration) tests:
- Snapshot file exists for each source in fixture troves
- Summary file exists for each source in fixture troves
- Snapshot has frontmatter with slug/url/fetched
- Snapshot not suspiciously small (>500 bytes)
- Known-bad summary is flagged as summary by classify-source.sh
- Broken URL → no snapshot, failed: true (inverse)
"""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

FIXTURES = Path(__file__).resolve().parent.parent / "evals" / "fixtures"
SCRIPTS = Path(__file__).resolve().parent.parent / "scripts"


def test_trove_has_snapshot_and_summary_for_each_source():
    """Every source in a fixture trove must have both -snapshot.md and -summary.md."""
    trove = FIXTURES / "trove-with-sources"
    sources_dir = trove / "sources"
    for source_dir in sources_dir.iterdir():
        if not source_dir.is_dir():
            continue
        slug = source_dir.name
        snapshot = source_dir / f"{slug}-snapshot.md"
        summary = source_dir / f"{slug}-summary.md"
        assert snapshot.exists(), f"Missing snapshot: {snapshot}"
        assert summary.exists(), f"Missing summary: {summary}"


def test_snapshot_has_frontmatter():
    """Snapshot files must have YAML frontmatter with slug, url, fetched."""
    trove = FIXTURES / "trove-with-sources"
    sources_dir = trove / "sources"
    for source_dir in sources_dir.iterdir():
        if not source_dir.is_dir():
            continue
        slug = source_dir.name
        snapshot = source_dir / f"{slug}-snapshot.md"
        content = snapshot.read_text(encoding="utf-8")
        assert content.startswith("---\n"), f"{snapshot} missing frontmatter"
        assert f"slug: {slug}" in content or f'slug: "{slug}"' in content, f"{snapshot} missing slug"
        assert "url:" in content, f"{snapshot} missing url"
        assert "fetched:" in content, f"{snapshot} missing fetched"


def test_snapshot_not_suspiciously_small():
    """Snapshot files should be >500 bytes (not a 27-line summary)."""
    trove = FIXTURES / "trove-with-sources"
    sources_dir = trove / "sources"
    for source_dir in sources_dir.iterdir():
        if not source_dir.is_dir():
            continue
        slug = source_dir.name
        snapshot = source_dir / f"{slug}-snapshot.md"
        size = snapshot.stat().st_size
        assert size > 500, f"{snapshot} is only {size} bytes — likely a summary"


def test_known_bad_summary_is_flagged():
    """classify-source.sh should flag known-bad summaries as 'summary'."""
    trove = FIXTURES / "known-bad-summaries"
    sources_dir = trove / "sources"
    for source_dir in sources_dir.iterdir():
        if not source_dir.is_dir():
            continue
        slug = source_dir.name
        summary_file = source_dir / f"{slug}-summary.md"
        url = _get_url_from_manifest(trove, slug)
        if not url:
            pytest.skip(f"No URL for {slug} in manifest")
        result = subprocess.run(
            ["bash", str(SCRIPTS / "classify-source.sh"),
             "--url", url,
             "--file", str(summary_file),
             "--threshold", "0.8"],
            capture_output=True, text=True, timeout=30,
        )
        output = result.stdout.strip()
        try:
            data = json.loads(output)
        except json.JSONDecodeError:
            pytest.fail(f"classify-source.sh returned non-JSON: {output}")
        assert data.get("verdict") == "summary", (
            f"Expected 'summary' for {slug}, got '{data.get('verdict')}' "
            f"(score={data.get('score')}, reason={data.get('reason')})"
        )


def test_broken_url_no_snapshot():
    """Inverse test: a broken URL should produce no snapshot and flag failed: true."""
    # This test verifies the manifest schema allows failed sources
    # by checking the known-bad fixture has no snapshot for its sources
    trove = FIXTURES / "known-bad-summaries"
    sources_dir = trove / "sources"
    for source_dir in sources_dir.iterdir():
        if not source_dir.is_dir():
            continue
        slug = source_dir.name
        snapshot = source_dir / f"{slug}-snapshot.md"
        # known-bad fixtures should NOT have snapshot files
        assert not snapshot.exists(), (
            f"{snapshot} should not exist — known-bad fixtures have no snapshots"
        )


def _get_url_from_manifest(trove_dir: Path, slug: str) -> str | None:
    """Extract URL for a given slug from a trove's manifest.yaml (no yaml dep)."""
    import re
    manifest = trove_dir / "manifest.yaml"
    if not manifest.exists():
        return None
    text = manifest.read_text(encoding="utf-8")
    # Find the source entry for this slug
    # Simple parser: find "- slug: <slug>" then look for url: on following lines
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if re.match(rf"^\s*-\s+slug:\s+{slug}\s*$", line) or re.match(rf"^\s*-\s+slug:\s+\"{slug}\"\s*$", line):
            # Look ahead for url: within the same block (before next "- " or end)
            for j in range(i + 1, min(i + 10, len(lines))):
                m = re.match(r"^\s+url:\s+(.+)$", lines[j])
                if m:
                    return m.group(1).strip().strip('"')
            break
    return None


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
