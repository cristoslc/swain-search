#!/usr/bin/env bash
# audit-snapshot-fidelity.sh — Non-deterministic audit of snapshot fidelity.
# For each source in a trove, uses an LLM judge to assess whether the snapshot
# faithfully reproduces the original URL content.
#
# Usage:
#   bash audit-snapshot-fidelity.sh --trove-dir <path> [--k 3] [--threshold 0.7]

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash audit-snapshot-fidelity.sh --trove-dir <path> [--k 3] [--threshold 0.7]

Output: JSONL with per-source verdicts and aggregate pass^k.
USAGE
}

TROVE_DIR=""
K=3
THRESHOLD=0.7

while [[ $# -gt 0 ]]; do
  case "$1" in
    --trove-dir) TROVE_DIR="${2:-}"; shift 2 ;;
    --k) K="${2:-}"; shift 2 ;;
    --threshold) THRESHOLD="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ -z "$TROVE_DIR" ]]; then
  echo "ERROR: --trove-dir is required" >&2
  usage >&2
  exit 1
fi

MANIFEST="$TROVE_DIR/manifest.yaml"
SOURCES_DIR="$TROVE_DIR/sources"

if [[ ! -f "$MANIFEST" ]]; then
  echo "ERROR: no manifest.yaml found" >&2
  exit 1
fi

echo "Auditing snapshot fidelity for $TROVE_DIR (k=$K, threshold=$THRESHOLD)"
echo ""

total_sources=0
total_pass=0

# Read sources from manifest
python3 - "$MANIFEST" "$SOURCES_DIR" "$K" "$THRESHOLD" <<'PYEOF'
import json, os, sys, subprocess, tempfile, re
from pathlib import Path

manifest_path = sys.argv[1]
sources_dir = sys.argv[2]
k = int(sys.argv[3])
threshold = float(sys.argv[4])

with open(manifest_path) as f:
    import yaml
    m = yaml.safe_load(f)

sources = m.get('sources', [])
total = len(sources)
pass_count = 0

for src in sources:
    slug = src.get('slug', '')
    url = src.get('url', '')
    snapshot_path = os.path.join(sources_dir, slug, f"{slug}-snapshot.md")

    if not os.path.isfile(snapshot_path):
        print(json.dumps({"slug": slug, "verdict": "skip", "reason": "no snapshot file", "pass": False}))
        continue

    # Read snapshot content (strip frontmatter)
    with open(snapshot_path) as f:
        content = f.read()
    content = re.sub(r'^---\n.*?\n---\n', '', content, count=1, flags=re.DOTALL)

    # Truncate to avoid token limits
    if len(content) > 8000:
        content = content[:8000] + "\n...[truncated]"

    # Run k trials with LLM judge
    trial_passes = 0
    for trial in range(k):
        prompt = f"""You are a fidelity auditor. Determine if the following text is a VERBATIM REPRODUCTION (snapshot) of the original content at {url}, or a SUMMARY/CONDENSATION.

A verbatim reproduction preserves the full content, structure, heading hierarchy, and detail of the original. A summary condenses, paraphrases, or extracts key points.

Respond with a JSON object: {{"result": "pass"|"fail", "reason": "..."}}

Text to evaluate:
{content}"""
        try:
            result = subprocess.run(
                ["llm", "-m", "deepseek-v4-flash:cloud", prompt],
                capture_output=True, text=True, timeout=60
            )
            output = result.stdout.strip()
            # Extract JSON from response
            import re as re2
            json_match = re2.search(r'\{[^}]+\}', output)
            if json_match:
                verdict = json.loads(json_match.group())
                if verdict.get("result") == "pass":
                    trial_passes += 1
        except Exception:
            pass

    trial_pass = trial_passes >= (k * threshold)
    if trial_pass:
        pass_count += 1

    print(json.dumps({
        "slug": slug,
        "url": url,
        "k": k,
        "trial_passes": trial_passes,
        "pass": trial_pass,
        "pass^k": round((trial_passes / k) ** k, 3) if k > 0 else 0,
    }))

# Summary
pass_k = round((pass_count / total) ** k, 3) if total > 0 else 0
print(json.dumps({
    "type": "summary",
    "total": total,
    "pass": pass_count,
    "pass^k": pass_k,
    "k": k,
    "threshold": threshold,
}))
PYEOF
