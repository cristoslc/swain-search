#!/usr/bin/env bash
# test-log-snapshot-metadata.sh — Acceptance tests for log-snapshot-metadata.sh

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_SCRIPT="$ROOT_DIR/skills/swain-search/scripts/log-snapshot-metadata.sh"

PASS=0
FAIL=0
pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1 — $2"; FAIL=$((FAIL + 1)); }

echo "=== log-snapshot-metadata.sh Tests ==="

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

RAW_PATH="$TMPDIR/raw.txt"
NORMALIZED_PATH="$TMPDIR/normalized.md"
METADATA_FILE="$TMPDIR/metadata.jsonl"
echo "raw content" > "$RAW_PATH"
echo "---\ntitle: Test\n---\n# Test" > "$NORMALIZED_PATH"

# AC1: Writes valid JSONL with required fields
echo "--- AC1: writes valid JSONL with required fields ---"
output=$(bash "$LOG_SCRIPT" \
  --source-url "https://example.com/doc" \
  --export-mode "google-doc-export" \
  --raw-path "$RAW_PATH" \
  --normalized-path "$NORMALIZED_PATH" \
  --normalization-skill "writing-skills" \
  --metadata-file "$METADATA_FILE" 2>&1)
status=$?
if [[ $status -eq 0 ]]; then
  pass "AC1: exits 0"
else
  fail "AC1: exit code" "expected 0, got $status"
fi

python3 -c "
import json
with open('$METADATA_FILE') as f:
    item = json.loads(f.readline())
required = ['source_url', 'export_mode', 'export_timestamp', 'normalization_skill', 'normalized_path', 'digest']
ok = all(item.get(k) for k in required)
print('ok' if ok else 'bad')
" 2>/dev/null | grep -q "ok" && pass "AC1: required fields present" || fail "AC1: required fields" "missing fields"

# AC2: Handles missing args gracefully
echo "--- AC2: handles missing args ---"
output=$(bash "$LOG_SCRIPT" 2>&1)
status=$?
if [[ $status -ne 0 ]]; then
  pass "AC2: exits non-zero with missing args"
else
  fail "AC2: exit code" "expected non-zero, got $status"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
