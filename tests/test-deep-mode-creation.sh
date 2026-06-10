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

echo "--- AC7: Verbatim mandate — source derived from raw snapshot, not AI summary ---"
# Compares normalized source against the raw snapshot created during this test run.
# Snapshot is an ephemeral intermediate artifact — only needed for verification.
METADATA=".agents/search-snapshots/metadata.jsonl"

if [[ -n "$FIRST_TROVE" && -f "$MANIFEST" && -f "$METADATA" ]]; then
  AC7_OUT=$(python3 -c "
import json, os, re, sys, yaml
from difflib import SequenceMatcher

with open('$MANIFEST') as f: manifest = yaml.safe_load(f)
sources = manifest.get('sources', [])
if not sources:
    print('NO_SOURCES')
    sys.exit(0)

source_url = sources[0].get('url', '')
if not source_url:
    print('NO_URL')
    sys.exit(0)

# Look up the source URL in metadata.jsonl
meta_path = '$METADATA'
if not os.path.exists(meta_path):
    print('NO_METADATA')
    sys.exit(0)

raw_path = None
with open(meta_path) as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            entry = json.loads(line)
        except json.JSONDecodeError:
            continue
        if entry.get('source_url') == source_url:
            raw_path = entry.get('raw_path')
            break

if not raw_path or not os.path.exists(raw_path):
    print(f'NO_RAW: {raw_path}')
    sys.exit(0)

# Read the normalized source file
source_dir = 'docs/troves/$FIRST_TROVE/sources'
src_id = sources[0].get('source-id', '')
src_files = [os.path.join(source_dir, f) for f in os.listdir(source_dir) if f.endswith('.md')]
if not src_files:
    print('NO_SOURCE_FILE')
    sys.exit(0)

with open(src_files[0], encoding='utf-8', errors='replace') as f: src_content = f.read()
if len(src_content) < 50:
    print('SHORT')
    sys.exit(0)

# Read raw snapshot: strip HTML tags if it looks like HTML
with open(raw_path, encoding='utf-8', errors='replace') as f: raw = f.read()
if re.search(r'<\s*html|<body|<div|<p\b', raw, re.IGNORECASE):
    raw_text = re.sub(r'<[^>]+>', ' ', raw)
    raw_text = re.sub(r'\s+', ' ', raw_text)
else:
    raw_text = raw

if len(raw_text) < 50:
    print('RAW_SHORT')
    sys.exit(0)

# Check for substantial shared content via longest matching block
# A faithful normalization should share a long contiguous sequence with the raw snapshot
matcher = SequenceMatcher(None, src_content, raw_text)
match = matcher.find_longest_match(0, len(src_content), 0, len(raw_text))
match_len = match.size
match_ratio = match_len / max(len(src_content), 1)

if match_len >= 100:
    # Strong signal: a long verbatim block from the original survived normalization
    print(f'PASS:{match_len}:{match_ratio:.3f}')
elif match_ratio >= 0.3:
    # ~30%+ character overlap — likely faithful even without a single 100-char block
    print(f'PASS:{match_len}:{match_ratio:.3f}')
else:
    print(f'FAIL:{match_len}:{match_ratio:.3f}')
" 2>&1)
  AC7_STATUS=$(echo "$AC7_OUT" | cut -d: -f1)
  AC7_MATCH=$(echo "$AC7_OUT" | cut -d: -f2)
  AC7_RATIO=$(echo "$AC7_OUT" | cut -d: -f3)
  if [[ "$AC7_STATUS" == "PASS" ]]; then
    pass "AC7: source matches raw snapshot (longest=$AC7_MATCH, ratio=$AC7_RATIO)"
  elif [[ "$AC7_STATUS" == "NO_SOURCES" || "$AC7_STATUS" == "NO_URL" ]]; then
    fail "AC7: manifest has no source entries"
  elif [[ "$AC7_STATUS" == "NO_METADATA" ]]; then
    fail "AC7: snapshot evidence gate not engaged — no metadata ledger"
  elif [[ "$AC7_STATUS" == "NO_RAW" ]]; then
    fail "AC7: snapshot raw file listed in metadata but not found ($AC7_MATCH)"
  elif [[ "$AC7_STATUS" == "SHORT" ]]; then
    fail "AC7: source too short for similarity analysis"
  elif [[ "$AC7_STATUS" == "RAW_SHORT" ]]; then
    fail "AC7: raw snapshot too short for similarity analysis"
  else
    fail "AC7: source doesn't match raw snapshot" "longest_match=$AC7_MATCH chars, ratio=$AC7_RATIO"
  fi
elif [[ -n "$FIRST_TROVE" && -f "$MANIFEST" ]]; then
  fail "AC7: snapshot evidence gate not engaged — skill must use export-snapshot pipeline"
else
  fail "AC7: trove manifest not available for verification"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed, $SKIP skipped ==="
[[ $FAIL -eq 0 ]] && exit 0 || exit 1