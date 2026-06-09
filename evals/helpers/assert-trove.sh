#!/usr/bin/env bash
# assert-trove.sh — Verify trove structure invariants
# Usage: source evals/helpers/assert-trove.sh; assert_trove_valid <trove-dir>

assert_trove_valid() {
  local dir="$1"
  local errors=0

  # manifest.yaml must exist and be valid YAML
  if [ ! -f "$dir/manifest.yaml" ]; then
    echo "FAIL: manifest.yaml missing in $dir"
    errors=$((errors + 1))
  else
    python3 -c "import yaml; yaml.safe_load(open('$dir/manifest.yaml'))" 2>/dev/null || {
      echo "FAIL: manifest.yaml is not valid YAML"
      errors=$((errors + 1))
    }
  fi

  # sources/ directory must exist
  if [ ! -d "$dir/sources" ]; then
    echo "FAIL: sources/ directory missing"
    errors=$((errors + 1))
  fi

  # synthesis.md must exist
  if [ ! -f "$dir/synthesis.md" ]; then
    echo "FAIL: synthesis.md missing"
    errors=$((errors + 1))
  fi

  # Each source entry in manifest must have a corresponding file
  if [ -f "$dir/manifest.yaml" ]; then
    python3 -c "
import yaml, os, sys
with open('$dir/manifest.yaml') as f:
    m = yaml.safe_load(f)
for s in m.get('sources', []):
    sid = s.get('id', s.get('source-id', ''))
    spath = os.path.join('$dir', 'sources', sid, sid + '.md')
    if not os.path.exists(spath):
        print(f'FAIL: source file missing: {spath}')
        sys.exit(1)
" 2>/dev/null || errors=$((errors + 1))
  fi

  return $errors
}

assert_trove_not_created() {
  local dir="$1"
  if [ -d "$dir" ]; then
    echo "FAIL: trove dir $dir should not exist"
    return 1
  fi
  return 0
}
