> ## Documentation Index
> Fetch the complete documentation index at: https://agentskills.io/llms.txt
> Use this file to discover all available pages before exploring further.

# Evaluating skill output quality

> How to test whether your skill produces good outputs using eval-driven iteration.

You wrote a skill, tried it on a prompt, and it seemed to work. But does it work reliably — across varied prompts, in edge cases, better than no skill at all? Running structured evaluations (evals) answers these questions and gives you a feedback loop for improving the skill systematically.

## Designing test cases

A test case has three parts:

* **Prompt**: a realistic user message — the kind of thing someone would actually type.
* **Expected output**: a human-readable description of what success looks like.
* **Input files** (optional): files the skill needs to work with.

Store test cases in `evals/evals.json` inside your skill directory:

```json
{
  "skill_name": "csv-analyzer",
  "evals": [
    {
      "id": 1,
      "prompt": "I have a CSV of monthly sales data in data/sales_2025.csv. Can you find the top 3 months by revenue and make a bar chart?",
      "expected_output": "A bar chart image showing the top 3 months by revenue, with labeled axes and values.",
      "files": ["evals/files/sales_2025.csv"]
    },
    {
      "id": 2,
      "prompt": "there's a csv in my downloads called customers.csv, some rows have missing emails — can you clean it up and tell me how many were missing?",
      "expected_output": "A cleaned CSV with missing emails handled, plus a count of how many were missing.",
      "files": ["evals/files/customers.csv"]
    }
  ]
}
```

**Tips for writing good test prompts:**

* **Start with 2-3 test cases.** Don't over-invest before you've seen your first round of results.
* **Vary the prompts.** Use different phrasings, levels of detail, and formality.
* **Cover edge cases.** Include at least one prompt that tests a boundary condition.
* **Use realistic context.** Real users mention file paths, column names, and personal context.

## Running evals

The core pattern is to run each test case twice: once **with the skill** and once **without it** (or with a previous version). This gives you a baseline to compare against.

### Workspace structure

Organize eval results in a workspace directory alongside your skill directory. Each pass gets its own `iteration-N/` directory. Within that, each test case gets an eval directory with `with_skill/` and `without_skill/` subdirectories.

The main file you author by hand is `evals/evals.json`. Other JSON files (`grading.json`, `timing.json`, `benchmark.json`) are produced during the eval process.

### Spawning runs

Each eval run should start with a clean context. In environments that support subagents, this isolation comes naturally. Without subagents, use a separate session for each run.

For each run, provide: the skill path (or no skill for the baseline), the test prompt, any input files, and the output directory.

### Capturing timing data

When each run completes, record the token count and duration:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332
}
```

## Writing assertions

Assertions are verifiable statements about what the output should contain or achieve.

Good assertions:
* `"The output file is valid JSON"` — programmatically verifiable.
* `"The bar chart has labeled axes"` — specific and observable.
* `"The report includes at least 3 recommendations"` — countable.

Weak assertions: `"The output is good"` (too vague), or too brittle (exact phrasing checks).

Add assertions to each test case in `evals/evals.json`:

```json
{
  "assertions": [
    "The output includes a bar chart image file",
    "The chart shows exactly 3 months",
    "Both axes are labeled",
    "The chart title or caption mentions revenue"
  ]
}
```

## Grading outputs

Grading means evaluating each assertion against the actual outputs and recording PASS or FAIL with specific evidence.

```json
{
  "assertion_results": [
    {"text": "...", "passed": true, "evidence": "Found chart.png (45KB)"}
  ],
  "summary": {"passed": 3, "failed": 1, "total": 4, "pass_rate": 0.75}
}
```

**Grading principles:**

* Require concrete evidence for a PASS.
* Review the assertions themselves, not just the results.
* For comparing two skill versions, try blind comparison with an LLM judge.

## Aggregating results

Compute summary statistics per configuration in `benchmark.json`:

```json
{
  "run_summary": {
    "with_skill": {
      "pass_rate": { "mean": 0.83, "stddev": 0.06 },
      "time_seconds": { "mean": 45.0, "stddev": 12.0 },
      "tokens": { "mean": 3800, "stddev": 400 }
    },
    "without_skill": {
      "pass_rate": { "mean": 0.33, "stddev": 0.10 },
      "time_seconds": { "mean": 32.0, "stddev": 8.0 },
      "tokens": { "mean": 2100, "stddev": 300 }
    },
    "delta": {
      "pass_rate": 0.50,
      "time_seconds": 13.0,
      "tokens": 1700
    }
  }
}
```

## Analyzing patterns

* Remove or replace assertions that always pass in both configurations.
* Investigate assertions that always fail in both configurations.
* Study assertions that pass with the skill but fail without — this is where the skill adds value.
* Tighten instructions when results are inconsistent across runs.
* Check time and token outliers.

## Reviewing results with a human

Review actual outputs alongside the grades. Record specific, actionable feedback for each test case.

## Iterating on the skill

After grading and reviewing, you have three sources of signal:

* **Failed assertions** point to specific gaps.
* **Human feedback** points to broader quality issues.
* **Execution transcripts** reveal why things went wrong.

**The loop:**

1. Give the eval signals and current `SKILL.md` to an LLM and ask it to propose improvements.
2. Review and apply the changes.
3. Rerun all test cases in a new `iteration-<N+1>/` directory.
4. Grade and aggregate the new results.
5. Review with a human. Repeat.

Stop when results are satisfactory, feedback is consistently empty, or improvement plateaus.

> The `skill-creator` Skill automates much of this workflow — running evals, grading assertions, aggregating benchmarks.