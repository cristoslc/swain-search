#!/usr/bin/env bash
# test-deep-mode-creation.sh — Deep behavioral test: actual swain-search skill invocation
# Creates a test repo, invokes opencode with the swain-search skill, verifies trove structure.
# Attaches to the local opencode server (port 4096) via --attach.
#
# Usage: bash tests/test-deep-mode-creation.sh
# Override model: MODEL=ollama/gemma4:26b bash tests/test-deep-mode-creation.sh

set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0
SKIP=0
pass() { echo "  PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "  FAIL: $1 — $2"; FAIL=$((FAIL + 1)); }
skip() { echo "  SKIP: $1 — $2"; SKIP=$((SKIP + 1)); }

echo "=== Deep Behavioral: Mode Creation ==="

# Load server environment for password
if [ -f "$HOME/.cache/opencode/serve.env" ]; then
  source "$HOME/.cache/opencode/serve.env"
else
  echo "  SKIP: serve.env not found — opencode server may not be running"
  for ac in setup AC1 AC2 AC3 AC4 AC5 AC6 AC7; do skip "$ac" "requires opencode server"; done
  echo ""
  echo "=== Results: $PASS passed, $FAIL failed, $SKIP skipped ==="
  exit 0
fi

MODEL="${MODEL:-ollama-cloud/deepseek-v4-flash:cloud}"

TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

cd "$TMPDIR"
git init -q
git config user.email "test@swain-search"
git config user.name "Test Runner"

mkdir -p .agents/skills/
SKILL_SRC="$HOME/.agents/skills/swain-search"
if [ -d "$ROOT_DIR/.agents/skills/swain-search" ]; then
  cp -r "$ROOT_DIR/.agents/skills/swain-search" .agents/skills/
elif [ -d "$SKILL_SRC" ]; then
  cp -r "$SKILL_SRC" .agents/skills/
else
  fail "setup" "swain-search skill not found"
  echo "=== Results: $PASS passed, $FAIL failed ==="
  exit 1
fi

if [ -f .agents/skills/swain-search/SKILL.md ]; then
  pass "skill installed at .agents/skills/swain-search/SKILL.md"
else
  fail "skill files" "SKILL.md missing after copy"
fi

echo "--- AC1: Invoke opencode to create a trove (model: $MODEL) ---"
echo "  (starting, streaming output below...)"
OUTFILE=$(mktemp)
opencode run \
  --model "$MODEL" \
  --attach http://localhost:4096 \
  --dir "$TMPDIR" \
  --dangerously-skip-permissions \
  "Use the swain-search skill to research 'testing LLM agent skills' for a spike. Create a trove with at least 2 sources." \
  2>&1 | tee "$OUTFILE"
status=$?
echo ""
echo "  (opencode exited with code $status)"
if [[ $status -eq 0 ]]; then
  pass "AC1: opencode exits 0"
else
  fail "AC1: exit code" "expected 0, got $status"
fi
rm -f "$OUTFILE"

echo "--- AC2: Trove directory created ---"
TROVES=$(ls docs/troves/ 2>/dev/null)
if [[ -n "$TROVES" ]]; then
  pass "AC2: trove directory created"
else
  fail "AC2: trove dir" "no troves found in docs/troves/"
fi

echo "--- AC3: manifest.yaml has required fields ---"
FIRST_TROVE=$(ls docs/troves/ 2>/dev/null | head -1)
if [[ -n "$FIRST_TROVE" && -f "docs/troves/$FIRST_TROVE/manifest.yaml" ]]; then
  MANIFEST="docs/troves/$FIRST_TROVE/manifest.yaml"
  AC3_OUT=$(python3 -c "
import yaml, sys
with open('$MANIFEST') as f:
    m = yaml.safe_load(f)
if m is None:
    print('FAIL: empty/none manifest')
    sys.exit(1)
required = ['trove', 'created', 'tags', 'sources']
for key in required:
    if key not in m:
        print(f'FAIL: missing {key}')
        sys.exit(1)
print('PASS: all required fields')
print('keys: ' + ', '.join(m.keys()))
" 2>&1)
  if echo "$AC3_OUT" | head -1 | grep -q "^PASS:"; then
    pass "AC3: manifest has required fields"
  else
    echo "  DEBUG manifest: $AC3_OUT"
    fail "AC3: manifest" "missing required fields"
  fi
else
  fail "AC3: manifest" "manifest.yaml not found"
fi

echo "--- AC4: sources/ directory exists ---"
if [[ -n "$FIRST_TROVE" && -d "docs/troves/$FIRST_TROVE/sources" ]]; then
  pass "AC4: sources/ directory exists"
else
  fail "AC4: sources/" "not found"
fi

echo "--- AC5: synthesis.md created ---"
if [[ -n "$FIRST_TROVE" && -f "docs/troves/$FIRST_TROVE/synthesis.md" ]]; then
  pass "AC5: synthesis.md exists"
else
  fail "AC5: synthesis.md" "not found"
fi

echo "--- AC6: At least one source file exists ---"
SOURCE_COUNT=$(find "docs/troves/$FIRST_TROVE/sources" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$SOURCE_COUNT" -ge 1 ]]; then
  pass "AC6: $SOURCE_COUNT source files"
else
  fail "AC6: sources" "no source .md files found"
fi

echo "--- AC7: Verbatim mandate — sources contain original content ---"
FIRST_SOURCE=$(find "docs/troves/$FIRST_TROVE/sources" -name "*.md" 2>/dev/null | head -1)
if [[ -n "$FIRST_SOURCE" ]]; then
  SIZE=$(wc -c < "$FIRST_SOURCE" | tr -d ' ')
  if [[ "$SIZE" -gt 100 ]]; then
    pass "AC7: source file has substantial content ($SIZE bytes)"
  else
    fail "AC7: source size" "only $SIZE bytes — may be summary not verbatim"
  fi
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed, $SKIP skipped ==="
[[ $FAIL -eq 0 ]] && exit 0 || exit 1