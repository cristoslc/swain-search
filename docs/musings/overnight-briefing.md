# Overnight Briefing — Three-Tier Testing for swain-search (Final)

## What was built

Full three-tier eval infrastructure. Ollama-wired knowledge suites running at 100%. Deep behavioral test created (credit-gated). Pre-commit hook installed. Baseline captured.

## Tier 1: Script-level (deterministic)

| Test file | ACs | Status |
|-----------|-----|--------|
| `test-bootstrap.sh` | 5 | All pass |
| `test-export-snapshot.sh` | 7 | All pass |
| `test-fetch-x-thread.sh` | 4 | All pass |
| `test-log-snapshot-metadata.sh` | 3 | All pass |
| `test-parse-vtt.sh` | 3 | All pass |
| `test-resolve-proxy.sh` | 12 | All pass |
| `test-deep-mode-creation.sh` | 7 | SKIP (needs API credits) |
| **Total** | **34/41** | **All enabled pass** |

## Tier 2: Ollama knowledge evals (38 tests, 100% pass, ~$0)

| Suite | Tests | Tokens | What it covers |
|-------|-------|--------|----------------|
| `mode-detection` | 10 | 2,850 | Create/Extend/Refresh/Discover/None routing |
| `trove-creation` | 8 | 2,464 | Verbatim mandate, file structure, hashes, dual-commit, snapshot gate |
| `prior-art` | 6 | 1,601 | Phases 1+2, decision gate, adjacent topic |
| `graceful-degradation` | 6 | 1,809 | Missing caps, failed snapshots, synthesis |
| `adversarial` | 8 | 2,957 | Injection, gibberish, empty, unicode, multi-mode |

## Tier 3: Deep behavioral (credit-gated)

`tests/test-deep-mode-creation.sh` — invokes the actual swain-search skill via `claude` CLI in an isolated temp repo, verifies:
- Trove directory created
- manifest.yaml has required fields (trove-id, created, tags, sources)
- sources/ directory exists
- synthesis.md created
- Source files have substantial content (verbatim mandate)
- Dual-commit pattern

Skipped in CI/pre-commit when credits are low. Run manually: `bash tests/test-deep-mode-creation.sh`

## Infrastructure

- `evals/suites/*.yaml` — 5 Promptfoo suites using `ollama:chat:deepseek-v4-flash:cloud`
- `evals/baseline/` — captured results for regression comparison
- `evals/fixtures/` — pre-built test trove, git repos
- `evals/helpers/` — setup/assert scripts
- `.githooks/pre-commit` — runs script tests + Ollama evals on skill-relevant changes
- `tests/test-deep-mode-creation.sh` — real skill invocation test

## How to run

```bash
# Tier 1: Script tests
for f in tests/test-*.sh; do bash "$f"; done

# Tier 2: Ollama evals
for f in evals/suites/*.yaml; do npx promptfoo eval -c "$f"; done

# Tier 3: Deep behavioral (needs API credits)
bash tests/test-deep-mode-creation.sh

# Regression check
npx promptfoo eval -c evals/suites/mode-detection.yaml --compare evals/baseline/mode-detection.json
```

## Commits

`dd96f2e` — Ollama-wired evals, all 5 suites at 100%, baseline captured
`0b0c691` — Initial test infrastructure, fixtures, pre-commit hook