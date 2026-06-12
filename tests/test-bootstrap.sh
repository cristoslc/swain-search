#!/usr/bin/env bash
# test-bootstrap.sh — Acceptance tests for bootstrap.sh

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_DIR="${SKILL_DIR:-$HOME/.config/opencode/skills/swain-search}"
BOOTSTRAP="$SKILL_DIR/scripts/bootstrap.sh"

PASS=0
FAIL=0
pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1 — $2"; FAIL=$((FAIL + 1)); }

echo "=== bootstrap.sh Tests ==="

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

# AC1: Exits 0 when uv is on PATH
echo "--- AC1: exits 0 when uv is on PATH ---"
MARKER_DIR="$TMPDIR/marker"
XDG_DATA_HOME="$MARKER_DIR" bash "$BOOTSTRAP" 2>/dev/null
status=$?
if [[ $status -eq 0 ]]; then
  pass "AC1: exits 0"
else
  fail "AC1: exit code" "expected 0, got $status"
fi

# AC2: Creates marker file
echo "--- AC2: creates marker file ---"
if [[ -f "$MARKER_DIR/swain-search/.bootstrapped" ]]; then
  pass "AC2: marker file created"
else
  fail "AC2: marker file" "not found at $MARKER_DIR/swain-search/.bootstrapped"
fi

# AC3: Idempotent on re-run
echo "--- AC3: idempotent on re-run ---"
output=$(XDG_DATA_HOME="$MARKER_DIR" bash "$BOOTSTRAP" 2>&1)
status=$?
if [[ $status -eq 0 ]]; then
  pass "AC3: re-run exits 0"
else
  fail "AC3: re-run exit code" "expected 0, got $status"
fi

# AC4: Exits 1 when uv is missing
echo "--- AC4: exits 1 when uv is missing ---"
# PATH with standard tools but no uv
output=$(MARKER_DIR="$TMPDIR/marker2" XDG_DATA_HOME="$TMPDIR/marker2" PATH="/usr/bin:/bin" bash "$BOOTSTRAP" 2>&1)
status=$?
if [[ $status -eq 1 ]]; then
  pass "AC4: exits 1"
else
  fail "AC4: exit code" "expected 1, got $status"
fi
if echo "$output" | grep -q "ERROR: uv is required"; then
  pass "AC4: error message printed"
else
  fail "AC4: error message" "expected 'ERROR: uv is required'"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
