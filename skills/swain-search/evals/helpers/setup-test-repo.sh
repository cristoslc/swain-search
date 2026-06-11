#!/usr/bin/env bash
# setup-test-repo.sh — Create a test git repo with known state for eval fixtures
# Usage: bash evals/helpers/setup-test-repo.sh <target-dir> [--with-trove]

set -euo pipefail

TARGET="${1:?Usage: setup-test-repo.sh <target-dir> [--with-trove]}"
WITH_TROVE=false
if [ "${2:-}" = "--with-trove" ]; then WITH_TROVE=true; fi

mkdir -p "$TARGET"
cd "$TARGET"

# Init git repo if not already one
if [ ! -d .git ]; then
  git init
  git config user.email "test@swain-search"
  git config user.name "Test Runner"
fi

# Create a basic project structure
mkdir -p docs src

# Create a README
cat > README.md <<'EOF'
# Test Repo
Used for swain-search eval fixtures.
EOF

git add README.md
git commit -m "initial commit" --allow-empty 2>/dev/null || true

# Optionally create a trove fixture
if $WITH_TROVE; then
  FIXTURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../fixtures/trove-with-sources" && pwd)"
  mkdir -p docs/troves/test-fixture
  cp -r "$FIXTURE_DIR"/* docs/troves/test-fixture/
  git add docs/troves/test-fixture/
  git commit -m "test fixture trove" 2>/dev/null || true
fi

echo "Test repo ready at $TARGET"
