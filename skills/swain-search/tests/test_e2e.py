"""E2E tests for swain-search snapshot/summary pipeline.

Tier 2 tests: full pipeline against real URLs with LLM judge for fidelity.
Non-deterministic methods used for semantic verification (within 70:30 ratio).

Requires: network access, llm CLI on PATH.
"""

from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

SCRIPTS = Path(__file__).resolve().parent.parent / "scripts"
SNAPSHOT_DIR = Path(tempfile.mkdtemp(prefix="swain-e2e-"))


def _has_llm() -> bool:
    """Check if llm CLI is available."""
    try:
        subprocess.run(["llm", "--version"], capture_output=True, text=True, timeout=5)
        return True
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False


def _llm_judge(snapshot_content: str, url: str) -> dict:
    """Use LLM to judge if snapshot is a verbatim reproduction."""
    # Truncate to avoid token limits
    if len(snapshot_content) > 6000:
        snapshot_content = snapshot_content[:6000] + "\n...[truncated]"

    prompt = f"""You are a fidelity auditor. Determine if the following text is a VERBATIM REPRODUCTION (snapshot) of the original content at {url}, or a SUMMARY/CONDENSATION.

A verbatim reproduction preserves the full content, structure, heading hierarchy, and detail of the original. It may have been converted from HTML to Markdown format, which is NOT summarization — format conversion preserves all content.

A summary condenses, paraphrases, or extracts only key points, losing most of the original detail, structure, and examples.

Key signals of a verbatim reproduction:
- Contains detailed API reference material (properties, methods, events with descriptions)
- Preserves code examples
- Has the full heading hierarchy of the original
- Is substantially long (many paragraphs, not just a few bullet points)

Key signals of a summary:
- Only a few bullet points or paragraphs
- Loses most technical detail
- Paraphrases instead of reproducing
- Omits code examples or tables

Respond with a JSON object: {{"result": "pass"|"fail", "reason": "..."}}

Text to evaluate:
{snapshot_content}"""

    result = subprocess.run(
        ["llm", "-m", "deepseek-v4-flash:cloud", prompt],
        capture_output=True, text=True, timeout=60,
    )
    output = result.stdout.strip()
    json_match = re.search(r'\{[^}]+\}', output)
    if json_match:
        return json.loads(json_match.group())
    return {"result": "fail", "reason": f"could not parse LLM output: {output[:200]}"}


@pytest.mark.skipif(not _has_llm(), reason="llm CLI not available")
def test_e2e_full_pipeline_against_real_url():
    """Full pipeline: export snapshot, normalize, verify both files exist, LLM judge fidelity.

    This is the primary E2E test — it proves swain-search produces verbatim snapshots.
    """
    url = "https://developer.mozilla.org/en-US/docs/Web/API/WebSocket"
    slug = "mdn-websocket-e2e"
    source_dir = SNAPSHOT_DIR / "sources" / slug
    source_dir.mkdir(parents=True, exist_ok=True)
    snapshot_file = source_dir / f"{slug}-snapshot.md"
    summary_file = source_dir / f"{slug}-summary.md"

    # Step 1: Export raw snapshot
    raw_dir = SNAPSHOT_DIR / "raw"
    raw_dir.mkdir(parents=True, exist_ok=True)
    export_result = subprocess.run(
        ["bash", str(SCRIPTS / "export-snapshot.sh"),
         "--url", url,
         "--out-dir", str(raw_dir)],
        capture_output=True, text=True, timeout=30,
    )
    assert export_result.returncode == 0, f"export failed: {export_result.stderr}"
    export_meta = json.loads(export_result.stdout)
    raw_path = Path(export_meta["raw_path"])
    assert raw_path.exists(), f"raw snapshot not found: {raw_path}"

    # Step 2: Normalize to snapshot (must use uv run for dependencies)
    norm_result = subprocess.run(
        ["uv", "run", "--with", "markdownify", "--with", "beautifulsoup4",
         "python3", str(SCRIPTS / "normalize-html.py"),
         "--raw", str(raw_path),
         "--url", url,
         "--out", str(snapshot_file),
         "--source-id", slug],
        capture_output=True, text=True, timeout=60,
    )
    assert norm_result.returncode == 0, f"normalize failed: {norm_result.stderr}"
    assert snapshot_file.exists(), f"snapshot not created: {snapshot_file}"

    # Step 3: Create summary
    summary_content = f"""---
slug: "{slug}"
relates-to: "websocket-api"
relevance: "Official MDN documentation for the WebSocket API"
selected-because: "Authoritative reference for WebSocket protocol"
aspects-covered:
  - "WebSocket constructor and options"
  - "Events and methods"
  - "Browser compatibility"
---
"""
    summary_file.write_text(summary_content, encoding="utf-8")
    assert summary_file.exists(), f"summary not created: {summary_file}"

    # Step 4: Verify snapshot structure
    content = snapshot_file.read_text(encoding="utf-8")
    assert content.startswith("---\n"), "snapshot missing frontmatter"
    assert f"slug: {slug}" in content or f'slug: "{slug}"' in content
    assert "url:" in content
    assert "fetched:" in content
    assert len(content) > 500, f"snapshot too small ({len(content)} bytes) — likely a summary"

    # Step 5: LLM judge (k=3, non-deterministic)
    trial_passes = 0
    k = 3
    for trial in range(k):
        verdict = _llm_judge(content, url)
        if verdict.get("result") == "pass":
            trial_passes += 1

    pass_k = (trial_passes / k) ** k
    assert trial_passes >= 2, (
        f"LLM judge: {trial_passes}/{k} passed (pass^k={pass_k:.3f}). "
        f"Snapshot may be a summary, not verbatim reproduction."
    )


def test_e2e_broken_url_graceful_degradation():
    """E2E inverse: a broken URL should fail gracefully without creating files."""
    url = "https://this-domain-does-not-exist-12345.com/nonexistent"
    slug = "broken-url-e2e"
    source_dir = SNAPSHOT_DIR / "sources" / slug
    source_dir.mkdir(parents=True, exist_ok=True)
    snapshot_file = source_dir / f"{slug}-snapshot.md"

    raw_dir = SNAPSHOT_DIR / "raw"
    raw_dir.mkdir(parents=True, exist_ok=True)

    # Export should fail
    export_result = subprocess.run(
        ["bash", str(SCRIPTS / "export-snapshot.sh"),
         "--url", url,
         "--out-dir", str(raw_dir)],
        capture_output=True, text=True, timeout=30,
    )
    # Should exit non-zero (curl failure)
    assert export_result.returncode != 0, "export should have failed for broken URL"
    # No snapshot file should be created
    assert not snapshot_file.exists(), f"snapshot should not exist for broken URL: {snapshot_file}"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
