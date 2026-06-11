# Linking from Artifacts and Dual-Commit Workflow

Artifacts reference troves in frontmatter:

```yaml
trove: websocket-vs-sse@abc1234
```

The format is `<trove-id>@<commit-hash>`. The commit hash pins the trove to a specific version — troves evolve over time as sources are added or refreshed, and the hash ensures reproducibility.

## Dual-commit workflow

Every trove-modifying operation (Create, Extend, Refresh) follows this pattern:

**Before Commit A** — append a `history` entry to `manifest.yaml` with a `--` placeholder for the commit hash:

```yaml
history:
  - event: created
    date: 2026-03-09
    commit: "--"
    sources: 3
```

**Commit A** — commit the trove content:

```bash
git add docs/troves/<trove-id>/
git commit -m "research(<trove-id>): create trove with N sources

Co-Authored-By: <model-name-from-system-prompt> <noreply@unknown>"
TROVE_HASH=$(git rev-parse HEAD)
```

**Commit B** — back-fill the commit hash into the history entry, then update the referencing artifact's frontmatter (if one exists):

```bash
# Replace "--" with the real hash in the history entry
# Update artifact frontmatter: trove: <trove-id>@<TROVE_HASH>
git add docs/troves/<trove-id>/manifest.yaml
git add docs/<artifact-type>/<phase>/<artifact-dir>/   # if artifact exists
git commit -m "docs(<trove-id>): stamp history hash ${TROVE_HASH:0:7}

Co-Authored-By: <model-name-from-system-prompt> <noreply@unknown>"
```

If no referencing artifact exists yet (standalone research), Commit B still stamps the history entry — report the hash so it can be referenced later.

**Push** — after Commit B, ALWAYS push to `origin/trunk` so the trove is immediately available to other agents and sessions. This is mandatory, not optional:

```bash
git push origin trunk
```

**Derive synthesis URL** — construct a stable permalink to the synthesis file for the final report:

```bash
REMOTE_URL=$(git remote get-url origin | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
SYNTHESIS_URL="${REMOTE_URL}/blob/${TROVE_HASH}/docs/troves/<trove-id>/synthesis.md"
```