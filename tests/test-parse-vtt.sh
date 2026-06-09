#!/usr/bin/env bash
# test-parse-vtt.sh — Acceptance tests for parse_vtt.py

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PARSE_SCRIPT="$ROOT_DIR/scripts/parse_vtt.py"

PASS=0
FAIL=0
pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1 — $2"; FAIL=$((FAIL + 1)); }

echo "=== parse_vtt.py Tests ==="

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

# AC1: Parses valid VTT
echo "--- AC1: parses valid VTT ---"
printf 'WEBVTT\n\n00:00:01.000 --> 00:00:04.000\nHello world\n\n00:00:05.000 --> 00:00:10.000\nThis is a test transcript\n' > /tmp/swain_search_media.en.vtt
output=$(uv run "$PARSE_SCRIPT" 2>&1)
status=$?
if [[ $status -eq 0 ]]; then
  pass "AC1: exits 0"
else
  fail "AC1: exit code" "expected 0, got $status"
fi
if echo "$output" | grep -q "Saved"; then
  pass "AC1: output indicates success"
else
  fail "AC1: output" "expected 'Saved' in output, got: $output"
fi

# AC2: Handles empty input gracefully
echo "--- AC2: handles empty input ---"
output=$(echo "" | uv run "$PARSE_SCRIPT" 2>&1)
status=$?
if [[ $status -eq 0 ]]; then
  pass "AC2: exits 0 on empty input"
else
  fail "AC2: exit code" "expected 0, got $status"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
