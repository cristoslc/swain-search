#!/usr/bin/env bash
# migrate-trove.sh — Migrate a trove from old single-file convention to
# new snapshot/summary split. For each source, classify the existing file,
# rename accordingly, and fetch the missing counterpart.
#
# Usage:
#   bash migrate-trove.sh --trove-dir docs/troves/<trove-id> [--threshold 0.8]

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash migrate-trove.sh --trove-dir <path> [--threshold 0.8]

Migrates a trove from old {slug}.md convention to {slug}-snapshot.md + {slug}-summary.md.
USAGE
}

TROVE_DIR=""
THRESHOLD=0.8
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --trove-dir) TROVE_DIR="${2:-}"; shift 2 ;;
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
  echo "ERROR: no manifest.yaml found in $TROVE_DIR" >&2
  exit 1
fi

if [[ ! -d "$SOURCES_DIR" ]]; then
  echo "ERROR: no sources/ directory in $TROVE_DIR" >&2
  exit 1
fi

echo "Migrating trove: $TROVE_DIR"

# Process each source directory
for source_dir in "$SOURCES_DIR"/*/; do
  slug=$(basename "$source_dir")
  echo "  Source: $slug"

  # Find the old-style file(s)
  old_file=""
  snapshot_file="$source_dir/${slug}-snapshot.md"
  summary_file="$source_dir/${slug}-summary.md"

  # Check for old {slug}.md
  if [[ -f "$source_dir/${slug}.md" ]]; then
    old_file="$source_dir/${slug}.md"
  fi

  # Check for old {slug}-snapshot.md (already migrated)
  if [[ -f "$snapshot_file" && -f "$summary_file" ]]; then
    echo "    Already migrated (both files exist)"
    continue
  fi

  if [[ -z "$old_file" ]]; then
    echo "    No old-style file found, skipping"
    continue
  fi

  # Classify the old file
  url=$(grep -E '^url:' "$old_file" | head -1 | sed 's/^url: *//' | sed 's/^"//;s/"$//' || true)
  if [[ -z "$url" ]]; then
    # Try to find URL from manifest
    url=$(python3 -c "
import yaml
with open('$MANIFEST') as f:
    m = yaml.safe_load(f)
for s in m.get('sources', []):
    if s.get('slug') == '$slug' or s.get('source-id') == '$slug' or s.get('id') == '$slug':
        print(s.get('url', ''))
        break
" 2>/dev/null || true)
  fi

  if [[ -z "$url" ]]; then
    echo "    No URL found for $slug, renaming to -summary.md (conservative)"
    mv "$old_file" "$summary_file"
    echo "    WARNING: cannot fetch snapshot without URL"
    continue
  fi

  # Classify
  result=$(bash "$SCRIPT_DIR/classify-source.sh" --url "$url" --file "$old_file" --threshold "$THRESHOLD" 2>/dev/null || echo '{"verdict":"unknown","score":0}')
  verdict=$(echo "$result" | python3 -c "import json,sys;print(json.load(sys.stdin).get('verdict','unknown'))")

  if [[ "$verdict" == "snapshot" ]]; then
    echo "    Classified as SNAPSHOT (similarity >= $THRESHOLD)"
    mv "$old_file" "$snapshot_file"
    # Create summary from the snapshot using an LLM
    echo "    Creating summary..."
    # For now, create a minimal summary placeholder
    cat > "$summary_file" <<SUMMARY
---
slug: "$slug"
relevance: "Source collected during migration"
selected-because: "Migrated from old single-file convention"
aspects-covered:
  - "See snapshot for full content"
---
SUMMARY
  else
    echo "    Classified as SUMMARY (similarity < $THRESHOLD)"
    mv "$old_file" "$summary_file"
    # Fetch and create snapshot
    echo "    Fetching snapshot from URL..."
    SNAPSHOT_DIR=".agents/search-snapshots/raw"
    mkdir -p "$SNAPSHOT_DIR"
    if bash "$SCRIPT_DIR/export-snapshot.sh" --url "$url" --out-dir "$SNAPSHOT_DIR" 2>/dev/null; then
      raw_path=$(ls -t "$SNAPSHOT_DIR"/*-"$slug".* 2>/dev/null | head -1 || true)
      if [[ -n "$raw_path" && -f "$raw_path" ]]; then
        uv run --with markdownify python3 "$SCRIPT_DIR/normalize-html.py" \
          --raw "$raw_path" \
          --url "$url" \
          --out "$snapshot_file" \
          --source-id "$slug" 2>/dev/null || {
          echo "    WARNING: normalization failed, creating placeholder"
          echo "---" > "$snapshot_file"
          echo "slug: \"$slug\"" >> "$snapshot_file"
          echo "url: \"$url\"" >> "$snapshot_file"
          echo "---" >> "$snapshot_file"
        }
      fi
    else
      echo "    WARNING: fetch failed, creating placeholder snapshot"
      echo "---" > "$snapshot_file"
      echo "slug: \"$slug\"" >> "$snapshot_file"
      echo "url: \"$url\"" >> "$snapshot_file"
      echo "---" >> "$snapshot_file"
    fi
  fi
done

# Update manifest to use 'slug' field
python3 - "$MANIFEST" <<'PYEOF'
import yaml, sys

path = sys.argv[1]
with open(path) as f:
    m = yaml.safe_load(f)

changed = False
for s in m.get('sources', []):
    if 'source-id' in s and 'slug' not in s:
        s['slug'] = s.pop('source-id')
        changed = True
    elif 'id' in s and 'slug' not in s:
        s['slug'] = s.pop('id')
        changed = True
    # Remove fields that no longer belong in manifest
    for key in ['hash', 'snapshot-hash', 'summary-hash', 'has-summary', 'snapshot-verified',
                'snapshot-metadata-digest', 'duration', 'speakers', 'highlights', 'selective',
                'notes', 'proxy-used', 'freshness-ttl', 'type', 'title']:
        if key in s:
            del s[key]
            changed = True

if changed:
    with open(path, 'w') as f:
        yaml.dump(m, f, default_flow_style=False, sort_keys=False)
    print("Updated manifest")
else:
    print("Manifest already up to date")
PYEOF

echo "Migration complete for $TROVE_DIR"
