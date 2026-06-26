"""Integration test for graceful Playwright degradation."""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "capture-playwright.py"


def test_capture_playwright_missing_degrades():
    """When Playwright is unavailable, capture-playwright.py fails gracefully."""
    # Force an environment where playwright cannot be imported and the CLI is absent.
    with tempfile.TemporaryDirectory() as tmp:
        no_playwright_dir = Path(tmp) / "no_playwright"
        no_playwright_dir.mkdir()
        out_dir = Path(tmp) / "out"
        out_dir.mkdir()

        # Build a fake python binary in a private bin dir that does not see
        # the test runner's site-packages. The subprocess then has no way to
        # import playwright and no `playwright` executable on PATH.
        fake_bin = Path(tmp) / "bin"
        fake_bin.mkdir()
        fake_python = fake_bin / "python3"
        real_python = shutil.which("python3") or sys.executable
        fake_python.symlink_to(real_python)

        env = dict(os.environ)
        env["PYTHONPATH"] = str(no_playwright_dir)
        env["UV_SYSTEM_PYTHON"] = "0"
        env["VIRTUAL_ENV"] = ""
        env["PATH"] = str(fake_bin)

        result = subprocess.run(
            [str(fake_python), str(SCRIPT), "--url", "https://example.com", "--source-id", "test", "--out-dir", str(out_dir)],
            capture_output=True,
            text=True,
            env=env,
        )
        assert result.returncode != 0
        assert "failed: playwright-unavailable" in result.stderr


if __name__ == "__main__":
    pytest.main([__file__, "-v"])

