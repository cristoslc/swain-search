#!/usr/bin/env bash
# test-fetch-x-thread.sh — Acceptance tests for fetch_x_thread.py

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FETCH_SCRIPT="$ROOT_DIR/scripts/fetch_x_thread.py"

PASS=0
FAIL=0
pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1 — $2"; FAIL=$((FAIL + 1)); }

echo "=== fetch_x_thread.py Tests ==="

# AC1: Exits non-zero with invalid input
echo "--- AC1: exits non-zero with invalid URL ---"
output=$(uv run "$FETCH_SCRIPT" "not-a-url" 2>&1)
status=$?
if [[ $status -ne 0 ]]; then
  pass "AC1: exits non-zero"
else
  fail "AC1: exit code" "expected non-zero, got $status"
fi

# AC2: Exits non-zero with empty string
echo "--- AC2: exits non-zero with empty string ---"
output=$(uv run "$FETCH_SCRIPT" "" 2>&1)
status=$?
if [[ $status -ne 0 ]]; then
  pass "AC2: exits non-zero"
else
  fail "AC2: exit code" "expected non-zero, got $status"
fi

# AC3: Exits non-zero with no arguments
echo "--- AC3: exits non-zero with no arguments ---"
output=$(uv run "$FETCH_SCRIPT" 2>&1)
status=$?
if [[ $status -ne 0 ]]; then
  pass "AC3: exits non-zero"
else
  fail "AC3: exit code" "expected non-zero, got $status"
fi

# AC4: Exits non-zero with too many arguments
echo "--- AC4: exits non-zero with too many arguments ---"
output=$(uv run "$FETCH_SCRIPT" "arg1" "arg2" 2>&1)
status=$?
if [[ $status -ne 0 ]]; then
  pass "AC4: exits non-zero"
else
  fail "AC4: exit code" "expected non-zero, got $status"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
