# Snapshot Evidence Gate (SPEC-220)

Before a remote source can be treated as collected evidence, the run must produce a raw snapshot and a metadata ledger entry in `.agents/search-snapshots/metadata.jsonl`.

Required flow for remote sources:
1. Export/download the raw snapshot first:
   - `bash "<SKILL_DIR>/scripts/export-snapshot.sh" --url "<source-url>" --out-dir ".agents/search-snapshots/raw"`
2. Normalize the downloaded file using `writing-skills` or `skill-creator` (never summary-only browser notes). The normalized output MUST preserve the full content of the original — no truncation, no condensation, no AI rewrites. Output goes to `sources/<slug>/<slug>-snapshot.md`.
3. Log metadata:
   - `bash "<SKILL_DIR>/scripts/log-snapshot-metadata.sh" --source-url "<source-url>" --export-mode "<mode>" --raw-path "<raw-path>" --normalized-path "<normalized-path>" --normalization-skill "<writing-skills|skill-creator>"`
4. Verify before publication:
   - `bash "<SKILL_DIR>/scripts/verify-snapshot-evidence.sh" --source-url "<source-url>"`

If verification fails, mark the source unverified, do not publish it downstream, and report the warning to the operator.