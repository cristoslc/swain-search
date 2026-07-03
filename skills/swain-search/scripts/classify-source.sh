#!/usr/bin/env bash
# classify-source.sh — Classify a local source file as snapshot or summary
# by comparing it to the original URL content (code-stripped text similarity).
#
# Usage:
#   bash classify-source.sh --url <source-url> --file <local-file> [--threshold 0.8]
#
# Output: JSON with verdict, similarity score, and reason.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash classify-source.sh --url <source-url> --file <local-file> [--threshold 0.8]

Output:
  {"verdict":"snapshot"|"summary","score":0.85,"reason":"..."}
USAGE
}

SOURCE_URL=""
LOCAL_FILE=""
THRESHOLD=0.8

while [[ $# -gt 0 ]]; do
  case "$1" in
    --url) SOURCE_URL="${2:-}"; shift 2 ;;
    --file) LOCAL_FILE="${2:-}"; shift 2 ;;
    --threshold) THRESHOLD="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$SOURCE_URL" || -z "$LOCAL_FILE" ]]; then
  echo "ERROR: --url and --file are required" >&2
  usage >&2
  exit 1
fi

if [[ ! -f "$LOCAL_FILE" ]]; then
  echo "ERROR: file not found: $LOCAL_FILE" >&2
  exit 1
fi

# Fetch the original URL content
FETCHED=$(mktemp -t swain-classify-fetch.XXXXXX)
trap "rm -f \"$FETCHED\"" EXIT

if ! curl -fLsS --retry 3 --max-time 30 "$SOURCE_URL" -o "$FETCHED" 2>/dev/null; then
  echo '{"verdict":"unknown","score":0,"reason":"failed to fetch source URL"}'
  exit 0
fi

if [[ ! -s "$FETCHED" ]]; then
  echo '{"verdict":"unknown","score":0,"reason":"fetched content is empty"}'
  exit 0
fi

# Strip code blocks from both files, then compute word-level Jaccard similarity
python3 - "$FETCHED" "$LOCAL_FILE" "$THRESHOLD" <<'PYEOF'
import json, re, sys
from pathlib import Path

def strip_code(text: str) -> str:
    """Remove fenced code blocks (```...```) and inline backticks."""
    text = re.sub(r'```.*?```', '', text, flags=re.DOTALL)
    text = re.sub(r'`[^`]+`', '', text)
    return text

def words(text: str) -> set:
    """Extract lowercase word set from text."""
    return set(re.findall(r'[a-zA-Z0-9_]+', text.lower()))

fetched_path, local_path, threshold = sys.argv[1], sys.argv[2], float(sys.argv[3])

fetched_text = Path(fetched_path).read_text(encoding='utf-8', errors='replace')
local_text = Path(local_path).read_text(encoding='utf-8', errors='replace')

# Strip YAML frontmatter from local file
local_text = re.sub(r'^---\n.*?\n---\n', '', local_text, count=1, flags=re.DOTALL)

fetched_clean = strip_code(fetched_text)
local_clean = strip_code(local_text)

fetched_words = words(fetched_clean)
local_words = words(local_clean)

if not fetched_words or not local_words:
    print(json.dumps({"verdict": "unknown", "score": 0, "reason": "no words extracted from one or both texts"}))
    sys.exit(0)

intersection = fetched_words & local_words
union = fetched_words | local_words
score = len(intersection) / len(union)

if score >= threshold:
    verdict = "snapshot"
    reason = f"similarity {score:.3f} >= {threshold}"
else:
    verdict = "summary"
    reason = f"similarity {score:.3f} < {threshold}"

print(json.dumps({"verdict": verdict, "score": round(score, 3), "reason": reason}))
PYEOF
