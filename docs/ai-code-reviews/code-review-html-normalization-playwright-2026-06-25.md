# Code Review: trunk..feat/html-normalization-playwright

**Refs:** trunk..feat/html-normalization-playwright (commit 77c5efc)
**Platform:** local
**Diff method:** git-ref-diff
**Dispatch:** manual single-orchestrator review (all six lenses applied directly)
**Date:** 2026-06-25T15:06:36Z

---

## Models

**Report author (orchestrator):** kimi-k2.7-code:cloud

**Review subagents:**

| Role | Model |
|------|-------|
| security | manual/orchestrator |
| style | manual/orchestrator |
| logic | manual/orchestrator |
| docs | manual/orchestrator |
| memory | manual/orchestrator |
| project-memory-conformance | manual/orchestrator |
| synthesis | manual/orchestrator |

---

## Recommendation: needs_changes

The implementation is well-scoped, cleanly structured, and all six declared tests pass. It successfully establishes the HTML normalization pipeline and the Playwright dynamic-capture branch with graceful degradation. However, one high-severity provenance bug and several medium-severity documentation/UX inconsistencies should be resolved before the PR is marked ready for merge.

---

### Security — passed

No critical security defects found. The scripts do not execute user-provided HTML, do not shell-out with untrusted input, and do not load remote resources during normalization. `capture-playwright.py` navigates only to the operator-supplied URL and writes snapshots to the configured output directory. The bootstrap permissions audit remains intact.

One defensive note: `normalize-html.py` uses a hand-rolled YAML frontmatter dumper. While current inputs are unlikely to contain YAML-special characters, a title with embedded newlines or control characters could produce malformed frontmatter. This is captured as a low-severity logic/style finding below, not a security issue.

### Style — passed with low findings

The Python scripts follow a consistent style, use type hints, and have clear docstrings and CLI help. Minor issues:

- `normalize-html.py` decodes `raw_bytes` twice (once for title extraction, once for body). This is harmless but could be streamlined.
- `capture-playwright.py` hardcodes the viewport size (`1280x720`) and does not expose it as a CLI option. Acceptable for the first iteration, but consider making it configurable if the skill later targets mobile-first pages.
- Test subprocesses invoke scripts with the test runner's Python interpreter. This works because `pytest` is launched through `uv run --with ...`, but the tests are not self-bootstrapping if run outside that exact invocation.

### Logic — needs_changes

**High — `rendered-at` is not sourced from the dynamic capture.**

`capture-playwright.py` emits a `rendered-at` timestamp that records when the browser actually rendered the page. `normalize-html.py` ignores this value and instead computes `fetched` at normalization time, then sets `rendered-at = fetched`. For dynamic captures this is incorrect provenance: the normalization step may run minutes or hours after rendering, and the rendered DOM snapshot already carries its own timestamp.

Fix: add a `--rendered-at` CLI argument to `normalize-html.py`. When `--capture-engine playwright` is present, use the supplied `rendered-at`; fall back to `fetched` only when it is absent. Update `source-collection.md` to pass `rendered-at` from `capture-playwright.py`'s JSON output into `normalize-html.py`.

**Medium — `needs-browser.py` `--llm-fallback` flag is documented as an LLM call but is actually a conservative hard-coded default.**

The help text says “If heuristics are ambiguous, fall back to an LLM to decide. (Not implemented in this environment.)” and `llm_fallback_decide()` unconditionally returns `True`. The `source-collection.md` procedure says “For ambiguous pages, add `--llm-fallback` to ask an LLM (conservative default).” This is misleading: the flag does not ask an LLM, it just forces the conservative answer.

Fix options (operator choice):
1. Rename the flag to `--force-browser-on-ambiguous` and update docs to match the actual behavior.
2. Keep `--llm-fallback` as a future hook but clearly document it as “unimplemented — currently defaults to browser rendering.”
3. Implement a real LLM call in a follow-up sashay.

**Low — hand-rolled YAML dumper in `normalize-html.py`.**

`yaml_str()` is sufficient for current test fixtures but is not a robust YAML emitter. Values such as titles containing newlines, leading/trailing quotes, or ambiguous numeric strings could break frontmatter parsing. Consider using `PyYAML` or `ruamel.yaml` (added via `uv --with`) for frontmatter serialization, or at least tighten quoting rules.

**Low — `capture-playwright.py` browser cleanup on exception.**

If an exception occurs after `browser.launch()` but before `browser.close()`, the Chromium process may not be terminated because `browser.close()` is only called on the success path. Wrap the navigation/rendering block in `try/finally` and call `browser.close()` in the finally block.

### Docs — needs_changes

**Medium — `source-collection.md` still references removed tooling.**

The Google Docs section still says: “Normalize the exported file with `normalize-html.py` (preferred) or with `writing-skills` / `skill-creator`.” The parley explicitly removed `writing-skills`/`skill-creator` from the HTML normalization path; only `normalize-html.py` remains. Update this line to remove the inaccurate alternatives.

**Medium — Playwright install command mismatch.**

`bootstrap.sh` and `capability-detection.md` tell the operator to run:

```bash
uv run --with playwright python3 -m playwright install chromium
```

`capture-playwright.py` tries to run the `playwright` executable:

```python
subprocess.run(["playwright", "install", "chromium"], ...)
```

In many `uv run` environments the entry-point script is available, but the mismatch creates support friction. Align the script's install attempt with the documented command, or make the script try `python3 -m playwright install chromium` as a fallback if the bare `playwright` executable is not on PATH.

**Low — `normalization-formats.md` example shows `rendered-at` as a distinct value from `fetched`.**

The example already implies `rendered-at` should differ from `fetched`. This reinforces the high finding above: the implementation currently cannot satisfy the documented contract because it does not accept a separate render timestamp.

### Memory — passed

No new long-term memory surfaced. The implementation follows the existing swain-search conventions (verbatim mandate, snapshot-first evidence gate, directory-per-source layout) and adds only the new dynamic-capture provenance keys. The `DYNAMIC_KEYS` frozenset in `normalize-html.py` is a useful but minimal internal guard, not a memory surface.

### Project-memory-conformance — needs_changes

**Medium — plan contract mismatch on LLM fallback.**

The sashay plan (`docs/plans/html-normalization-playwright.md`) specified the capability order as: existing browser/page-fetch tools, static fetch, heuristic, LLM fallback for ambiguous cases, then Playwright. The implementation provides the heuristic and Playwright steps but leaves LLM fallback as a non-functional placeholder. This is a scope gap from the plan.

Recommended resolution: either implement a minimal LLM fallback (e.g., call the orchestrator model with a tiny prompt) or update the plan to record that LLM fallback is deferred to a future iteration. Do not leave a documented-but-unimplemented feature in the shipped procedure.

---

## Finding Counts

| Lens | Critical | High | Medium | Low | Total |
|---|---|---|---|---|---|
| security | 0 | 0 | 0 | 0 | 0 |
| style | 0 | 0 | 0 | 3 | 3 |
| logic | 0 | 1 | 1 | 2 | 4 |
| docs | 0 | 0 | 2 | 1 | 3 |
| memory | 0 | 0 | 0 | 0 | 0 |
| project-memory-conformance | 0 | 0 | 1 | 0 | 1 |
| **Total** | **0** | **1** | **5** | **6** | **12** |

---

*Generated by code-review — multi-agent code review system*
