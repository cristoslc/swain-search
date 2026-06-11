# Refresh Mode

Re-fetch stale sources and update changed content.

1. Read `manifest.yaml`
2. For each source, check if `fetched` date + `freshness-ttl` has elapsed
3. For stale sources:
   - Re-fetch the raw content
   - Re-normalize to markdown
   - Compute new content hash
   - If hash changed: replace the source file, update manifest entry
   - If hash unchanged: update only `fetched` date
4. Update `refreshed` date in manifest
5. If any content changed, regenerate `synthesis.md`
6. Append a `history` entry with `event: refreshed`, `sources-changed: M`, and `commit: "--"` placeholder
7. Commit and stamp (same dual-commit pattern as [references/linking-from-artifacts.md](references/linking-from-artifacts.md)):
   - **Commit A**: `git commit -m "research(<trove-id>): refresh N sources (M changed)

Co-Authored-By: <model-name-from-system-prompt> <noreply@unknown>"`
   - Capture `TROVE_HASH=$(git rev-parse HEAD)`
   - **Commit B**: back-fill hash in history entry, update referencing artifact(s) frontmatter — check `referenced-by` in manifest for all dependents
   - **Push** (mandatory): `git push origin trunk`
   - Derive `SYNTHESIS_URL` (same method as [references/linking-from-artifacts.md](references/linking-from-artifacts.md))
8. Report: "Refreshed N sources. M had changed content, K were unchanged. New hash: `<TROVE_HASH:0:7>`. Synthesis: <SYNTHESIS_URL>"

For sources with `freshness-ttl: never`, skip them during refresh.