# Musing: Snapshot/Summary Split, Naming Convention, and Compliance Testing

## Pass 1 — The Core Problem: One File, Two Purposes

### Current state

Every source in a trove lives at `sources/<source-id>/<source-id>.md`. That single file is supposed to be a **verbatim reproduction** of the original (per the verbatim mandate), but in practice agents routinely produce summaries instead. The test fixture at `evals/fixtures/trove-with-sources/sources/mdn-websocket/mdn-websocket.md` is a perfect example — it's a 27-line summary of the MDN WebSocket API page, not a verbatim reproduction. The real MDN page is thousands of words with code examples, constructor parameters, event handler tables, browser compatibility data, etc.

The verbatim mandate is clear: "A normalized source file MUST be a faithful, verbatim reproduction of the original document." But there's no structural enforcement. The file is named `<slug>.md` regardless of whether it's a snapshot or a summary. Downstream consumers (other packages, artifacts) have no way to tell which they're looking at without reading the content.

### Why agents produce summaries

The root cause is that the agent is being asked to do two contradictory things in one step: (1) fetch and preserve the source verbatim, and (2) understand and synthesize it. The agent's default behavior is to understand — to compress, to extract meaning. Fighting that default requires structural forcing functions, not just instructions.

### The proposed fix: two files per source

Option A: `sources/<source-id>/snapshot.md` + `sources/<source-id>/summary.md`
Option B: `sources/<source-id>/<source-id>-snapshot.md` + `sources/<source-id>/<source-id>-summary.md`

**Analysis of Option A (bare `snapshot.md` / `summary.md`):**

Pros:
- Shorter, cleaner filenames
- Easy to glob: `**/snapshot.md` finds all snapshots
- The directory name already carries the source identity

Cons:
- Collision with the existing convention where `<source-id>.md` is the primary file
- Migration: every existing trove has `<source-id>.md` — what does that become?
- If `<source-id>.md` stays as the "primary" file, what is it? A snapshot? A summary? The ambiguity persists.
- Harder to distinguish in flat listings (two files named `snapshot.md` in different dirs look identical in tree output)

**Analysis of Option B (`<source-id>-snapshot.md` / `<source-id>-summary.md`):**

Pros:
- Self-documenting filenames — the role is in the name
- No ambiguity about which file is which
- Glob patterns like `**/*-snapshot.md` work across the whole trove
- Downstream consumers can explicitly reference `trove:foo@abc:sources/bar/bar-snapshot.md`
- Migration path: existing `<source-id>.md` files can be renamed to `<source-id>-snapshot.md` (they were *supposed* to be snapshots)

Cons:
- Longer filenames (redundant with directory name)
- Breaks every existing reference to `<source-id>.md`
- The `-snapshot` suffix is 9 chars of noise in the directory context

**Verdict on naming:** Option B is better for the long term. The redundancy is a feature, not a bug — it makes the file's role unambiguous when the file is detached from its directory context (e.g., in a diff view, a search result, or when excerpted into another package). The migration cost is one-time and mechanical.

### The `request-origin.md` proposal

A file at `docs/troves/<trove-id>/request-origin.md` that records:
- The user's original request that triggered trove creation
- Any follow-up prompts or refinements
- The model/agent that created it
- The date and context

This is valuable provenance. It answers "why does this trove exist?" and "what was the agent asked to do?" — which is essential for debugging compliance failures. If a source turns out to be a summary instead of a snapshot, the request-origin tells you whether the agent was given ambiguous instructions.

However, this information is partially already in the `history` field of `manifest.yaml`. The difference is that `history` records *events* (created, extended, refreshed) while `request-origin` would record *intent* (the prompts that drove those events). These are complementary.

**Risk:** `request-origin.md` could become a dumping ground for every prompt fragment. It needs a strict schema: one entry per history event, with the exact prompt text, the model used, and the date. No freeform notes.

---

## Pass 2 — Structural Implications and Migration

### What changes in the directory layout

Current:
```
docs/troves/<trove-id>/
├── manifest.yaml
├── synthesis.md
└── sources/
    └── <source-id>/
        └── <source-id>.md
```

Proposed:
```
docs/troves/<trove-id>/
├── manifest.yaml
├── synthesis.md
├── request-origin.md          # NEW
└── sources/
    └── <source-id>/
        ├── <source-id>-snapshot.md   # verbatim reproduction (REQUIRED for remote sources)
        └── <source-id>-summary.md    # optional commentary (OPTIONAL)
```

### What this means for the manifest schema

The `has-summary` field already exists in the manifest schema. We'd add:
- `has-snapshot: true` (always true for remote sources, implied for local)
- The `hash` field should hash the snapshot file, not the summary
- The `snapshot-verified` field stays as-is

### What this means for the verbatim mandate

The verbatim mandate now applies to `<source-id>-snapshot.md`. The `<source-id>-summary.md` is explicitly *allowed* to be a summary. This is cleaner than the current situation where the single `<source-id>.md` is supposed to be verbatim but often isn't.

The key rule: **a source is not complete until it has a snapshot file.** The summary is always optional. An agent that creates only a summary file (without a snapshot) has failed to collect the source.

### What this means for the snapshot evidence gate (SPEC-220)

The snapshot evidence gate currently produces a raw `.html` file and then normalizes it to `<source-id>.md`. Under the new scheme:
1. Raw snapshot → `.agents/search-snapshots/raw/<source-id>.html`
2. Normalize → `sources/<source-id>/<source-id>-snapshot.md`
3. Optionally summarize → `sources/<source-id>/<source-id>-summary.md`
4. Log metadata (unchanged)
5. Verify (unchanged)

The normalization step now has a clear target file. The summary step is separate and optional — it can be done by a different agent or at a different time.

### Migration path for existing troves

1. Rename `<source-id>.md` → `<source-id>-snapshot.md` (mechanical, safe — these were supposed to be snapshots)
2. Add `has-snapshot: true` to each source entry in manifest
3. If a `<source-id>.md` is clearly a summary (like the test fixtures), flag it as `snapshot-verified: false` and add a `notes: "needs re-fetch — current file is a summary, not verbatim"`
4. Update `trovewatch.sh` to check for snapshot files instead of `<source-id>.md`
5. Update `assert-trove.sh` similarly
6. Update all spoke files that reference `<source-id>.md`

### Impact on downstream excerpting

This is the key win. Currently, excerpting content from a trove into another package requires reading `<source-id>.md` and guessing whether it's a snapshot or a summary. With the split:
- `**/*-snapshot.md` = verbatim evidence (safe to cite, safe to excerpt as-is)
- `**/*-summary.md` = commentary (useful for context, but not evidence)
- `**/synthesis.md` = trove-level distillation

A downstream package can explicitly declare: "I reference `trove:foo@abc:sources/bar/bar-snapshot.md`" and know exactly what it's getting.

---

## Pass 3 — Non-Deterministic Compliance Testing

### The challenge

The verbatim mandate is a *semantic* property, not a structural one. You can't check "is this a summary or a verbatim reproduction?" with a simple file existence test or a regex. The question is: does the content of `*-snapshot.md` faithfully reproduce the original source? This requires understanding the content, which is inherently non-deterministic when done by an LLM.

### Approach: statistical compliance testing

Instead of a binary pass/fail, we use a **compliance score** based on multiple independent assessments. This is the same paradigm as AgentAssay's stochastic test semantics — we accept that any single assessment may be wrong, but with enough trials we can bound the error.

**Test design:**

For each source in a trove:
1. Take the source URL and the `*-snapshot.md` file
2. Have N independent evaluators (could be N calls to the same model, or calls to different models) assess whether the snapshot is a faithful verbatim reproduction
3. Each evaluator returns a verdict: `Pass` (verbatim), `Fail` (summary/condensed), or `Inconclusive` (can't determine)
4. Aggregate using Wilson score confidence interval
5. If `CI_lower >= threshold` (e.g., 0.8), the source passes compliance

**Key insight:** This is the same statistical framework already described in the AgentAssay paper in the trove. We can reference it directly.

### Implementation as a Promptfoo eval suite

The existing `trove-creation.yaml` eval suite tests *knowledge* of the rules. We need a new suite that tests *compliance* of actual trove content.

```
evals/suites/verbatim-compliance.yaml
```

Structure:
- Provider: an LLM that reads the source URL and the snapshot file
- Test cases: one per source in the trove
- Assertion: JavaScript that checks the LLM's verdict

The non-determinism comes from:
1. The LLM evaluator itself (different runs may give different verdicts)
2. The sampling of sources (we may not check every source every time)
3. The threshold for pass/fail

**Handling non-determinism in the test suite:**

```yaml
tests:
  - description: "agent-skill-evals/anthropic-demystifying-evals snapshot is verbatim"
    vars:
      source_url: "https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents"
      snapshot_path: "docs/troves/agent-skill-evals/sources/anthropic-demystifying-evals/anthropic-demystifying-evals-snapshot.md"
    assert:
      - type: javascript
        threshold: 0.7  # 70% of evaluator runs must pass
        value: |
          // Evaluator reads the URL and snapshot, returns {verdict: "pass"|"fail"|"inconclusive"}
          // Run with --repeat 5 to get multiple samples
```

But this is expensive — each test case requires fetching the URL and comparing. A better approach:

### Tiered compliance checking

**Tier 1 — Structural checks (deterministic, fast):**
- Does `*-snapshot.md` exist for every source? (trovewatch.sh)
- Is `*-snapshot.md` non-empty?
- Does `*-snapshot.md` have frontmatter with `source-id`, `url`, `fetched`?
- Is the file size within expected bounds (not suspiciously small)?
- Does the manifest have `has-snapshot: true` for every source?

**Tier 2 — Statistical spot-checks (non-deterministic, periodic):**
- Randomly sample N sources from the trove
- For each, fetch the original URL and compare with the snapshot using an LLM evaluator
- Report compliance score with confidence intervals
- Run on a schedule (e.g., weekly) or on demand

**Tier 3 — Full audit (expensive, on-demand):**
- Check every source in the trove
- Used before publishing or when compliance concerns are raised

### The compliance score as a manifest field

Add a `compliance-score` field to the manifest:
```yaml
compliance:
  last-checked: 2026-07-02
  sources-checked: 5
  sources-passed: 3
  sources-failed: 2
  confidence: 0.95
  method: "llm-evaluator-v1"
```

This makes compliance visible and trackable over time. A trove with a low compliance score is flagged before it's used downstream.

### The `request-origin.md` as a compliance tool

`request-origin.md` helps diagnose *why* compliance failed. If a source is a summary instead of a snapshot, the request-origin tells you:
- What the agent was asked to do (was the prompt ambiguous?)
- What model was used (some models are more prone to summarizing)
- What context was available

This turns compliance failures from "the agent did it wrong" into actionable data for improving the skill instructions.

### Summary of the testing approach

| Check | Type | Frequency | Tool |
|-------|------|-----------|------|
| Snapshot file exists | Deterministic | Every commit | trovewatch.sh |
| Snapshot has frontmatter | Deterministic | Every commit | trovewatch.sh |
| Snapshot not suspiciously small | Deterministic (heuristic) | Every commit | trovewatch.sh |
| Snapshot is verbatim (spot-check) | Non-deterministic | Weekly / on-demand | Promptfoo eval |
| Full compliance audit | Non-deterministic | On-demand | Promptfoo eval |
| Request-origin matches history | Deterministic | Every commit | trovewatch.sh |

### The `request-origin.md` schema

```yaml
---
trove: "agent-skill-evals"
created: 2026-06-09
events:
  - event: created
    date: 2026-06-09
    model: "claude-sonnet-4-20250514"
    prompt: |
      Research agent evaluation frameworks. Find sources on:
      - Anthropic's demystifying evals post
      - OpenAI's eval skills post
      - AgentAssay paper on arXiv
      - Promptfoo's test agent skills guide
      - Braintrust's AI agent evaluation framework
    context: "Spike on agent skill evaluation approaches"
  - event: extended
    date: 2026-06-15
    model: "claude-sonnet-4-20250514"
    prompt: |
      Add the new AgentBench paper to the trove
    context: "Follow-up from review"
---
```

This is YAML frontmatter with a list of events, each containing the exact prompt and context. No freeform prose below the frontmatter — the schema is the structure.

### Open questions for parley

1. **Naming:** Is `{slug}-snapshot.md` / `{slug}-summary.md` the right convention, or should we use `snapshot.md` / `summary.md` (bare, relying on directory context)?

2. **Snapshot requirement:** Should snapshots be *required* for all remote sources and *optional* for local files? Or required for everything?

3. **Compliance threshold:** What's the minimum acceptable compliance score? 0.8? 0.9? Should it vary by source type?

4. **Request-origin scope:** One file per trove, or one per event? The proposed schema handles both (multiple events in one file).

5. **Migration:** Should we migrate existing troves immediately, or let them coexist with the old convention?

6. **Test fixture:** The test fixtures at `evals/fixtures/trove-with-sources/` are clearly summaries. Should we replace them with proper snapshots, or keep them as "known-bad" fixtures for compliance testing?
