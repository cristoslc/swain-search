# Extend Mode

Add new sources to an existing trove.

1. Read the existing `manifest.yaml`
2. Collect and normalize new sources (same as [references/create-mode.md](references/create-mode.md) step 2)
3. Assign slug-based source IDs to new sources (following the same ID generation rules)
4. Append new entries to `manifest.yaml`
5. Update `refreshed` date
6. Regenerate `synthesis.md` incorporating all sources (old + new)
7. Append a `history` entry with `event: extended` and `commit: "--"` placeholder
8. Commit and stamp (same dual-commit pattern as [references/linking-from-artifacts.md](references/linking-from-artifacts.md)):
   - **Commit A**: `git commit -m "research(<trove-id>): extend with N new sources

Co-Authored-By: <model-name-from-system-prompt> <noreply@unknown>"`
   - Capture `TROVE_HASH=$(git rev-parse HEAD)`
   - **Commit B**: back-fill hash in history entry, update referencing artifact frontmatter (if artifact exists)
   - **Push** (mandatory): `git push origin trunk`
   - Derive `SYNTHESIS_URL` (same method as [references/linking-from-artifacts.md](references/linking-from-artifacts.md))
9. Report what was added, including the new commit hash and the synthesis file URL