# Overnight Briefing — Three-Tier Testing for swain-search

## What was built

A comprehensive three-tier testing infrastructure for swain-search, with `evals/` directory (Promptfoo behavioral/adversarial suites), upgraded `tests/` directory (script-level), and `.githooks/pre-commit` gate.

### Tier 1: Script-level tests

| Test file | ACs | Status |
|-----------|-----|--------|
| `tests/test-bootstrap.sh` | 5 | All pass |
| `tests/test-export-snapshot.sh` | 7 | All pass (existing) |
| `tests/test-fetch-x-thread.sh` | 4 | All pass |
| `tests/test-log-snapshot-metadata.sh` | 3 | All pass |
| `tests/test-parse-vtt.sh` | 3 | All pass |
| `tests/test-resolve-proxy.sh` | 12 | All pass (existing) |
| `tests/test-convert-cookies.py` | — | Existing, not re-run (Python) |
| **Total** | **34** | **All pass** |

### Tier 2-3: Behavioral + Adversarial evals (Promptfoo)

5 eval suites created in `evals/suites/`:
- `mode-detection.yaml` — mode routing (create/extend/discover/negative)
- `trove-creation.yaml` — trove structure (manifest, sources/, synthesis.md)
- `prior-art.yaml` — prior art check behavior
- `graceful-degradation.yaml` — missing capability handling
- `adversarial.yaml` — boundary attacks

Root config: `evals/promptfooconfig.yaml` (imports all suites)

### Infrastructure

- `evals/fixtures/trove-with-sources/` — pre-built trove for extend/refresh tests
- `evals/helpers/setup-test-repo.sh` — idempotent test repo setup
- `evals/helpers/assert-trove.sh` — trove structure invariant checks
- `.githooks/pre-commit` — gates commits that change SKILL.md, spokes/, scripts/, references/
- `.gitignore` — added `evals/artifacts/`
- `git config core.hooksPath .githooks` applied

### Open items

1. **Promptfoo evals haven't been run yet** — they require an OpenCode SDK provider and actual skill invocation. The configs are written but need a full `npx promptfoo eval -c evals/promptfooconfig.yaml` run to validate. This was deferred because it requires API calls.
2. **10 more scripts still lack tests** — `yt-dlp.sh`, `extract_frames.py`, `ocr_frames.py`, `verify-snapshot-evidence.sh`, `trovewatch.sh`, `migrate-to-troves.sh` are untested.
3. **Regression baseline** — not yet captured. First `promptfoo eval` run should use `-o evals/baseline/results.json` to establish the baseline for `--compare` future runs.
4. **Snapshot-gate and source-collection** suites were designed but not fully implemented in YAML (the Promptfoo configs exist as minimal stubs).

### Recommendations

- Run `npx promptfoo eval -c evals/promptfooconfig.yaml --no-cache -o evals/artifacts/first-run.json` to shake out the behavioral suites
- Add remaining script tests (5 more files)
- Commit the baseline: `npx promptfoo eval -c evals/promptfooconfig.yaml -o evals/baseline/results.json`
- Add a GitHub Actions workflow in `.github/workflows/eval.yml`