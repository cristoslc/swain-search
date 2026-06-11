> ## Documentation Index
> Fetch the complete documentation index at: https://agentskills.io/llms.txt
> Use this file to discover all available pages before exploring further.

# Optimizing skill descriptions

> How to improve your skill's description so it triggers reliably on relevant prompts.

A skill only helps if it gets activated. The `description` field in your `SKILL.md` frontmatter is the primary mechanism agents use to decide whether to load a skill for a given task. An under-specified description means the skill won't trigger when it should; an over-broad description means it triggers when it shouldn't.

## How skill triggering works

Agents use [progressive disclosure](/specification#progressive-disclosure) to manage context. At startup, they load only the `name` and `description` of each available skill. When a user's task matches a description, the agent reads the full `SKILL.md` into context and follows its instructions.

The description carries the entire burden of triggering. Agents typically only consult skills for tasks that require knowledge or capabilities beyond what they can handle alone. Tasks involving specialized knowledge — an unfamiliar API, a domain-specific workflow, or an uncommon format — are where a well-written description makes the difference.

## Writing effective descriptions

* **Use imperative phrasing.** Frame the description as an instruction to the agent: "Use this skill when..." rather than "This skill does..."
* **Focus on user intent, not implementation.** Describe what the user is trying to achieve, not the skill's internal mechanics.
* **Err on the side of being pushy.** Explicitly list contexts where the skill applies, including cases where the user doesn't name the domain directly.
* **Keep it concise.** A few sentences to a short paragraph. The spec enforces a hard limit of 1024 characters.

## Designing trigger eval queries

You need a set of eval queries — realistic user prompts labeled with whether they should or shouldn't trigger your skill.

```json
[
  { "query": "I've got a spreadsheet in ~/data/q4_results.xlsx with revenue in col C...", "should_trigger": true },
  { "query": "whats the quickest way to convert this json file to yaml", "should_trigger": false }
]
```

Aim for about 20 queries: 8-10 should-trigger and 8-10 should-not-trigger.

### Should-trigger queries

Vary along several axes: phrasing (formal to casual with typos), explicitness (some name the domain directly, others describe the need), detail (terse vs context-heavy), and complexity (single-step vs multi-step).

### Should-not-trigger queries

The most valuable negative test cases are **near-misses** — queries that share keywords or concepts with your skill but actually need something different. These test whether the description is precise, not just broad.

## Testing whether a description triggers

Run each query through your agent with the skill installed and observe whether the agent invokes it. A query passes if should_trigger matches actual behavior.

### Running multiple times

Run each query multiple times (3 is reasonable) and compute a **trigger rate**. A should-trigger query passes if its trigger rate is above 0.5; a should-not-trigger query passes if below 0.5.

### Avoiding overfitting with train/validation splits

* **Train set (~60%)**: queries you use to identify failures and guide improvements.
* **Validation set (~40%)**: queries you set aside to check whether improvements generalize.

## The optimization loop

1. **Evaluate** the current description on both train and validation sets.
2. **Identify failures** in the train set only.
3. **Revise the description.** Broaden if should-trigger queries fail; add specificity if should-not-trigger queries false-trigger. Avoid adding specific keywords from failed queries — generalize.
4. **Repeat** until all train set queries pass or improvement plateaus.
5. **Select the best iteration** by validation pass rate.

## Applying the result

Update the `description` field, verify the 1024-character limit, and sanity-check with fresh queries.

Before and after:

```yaml
# Before
description: Process CSV files.

# After
description: >
  Analyze CSV and tabular data files — compute summary statistics,
  add derived columns, generate charts, and clean messy data. Use this
  skill when the user has a CSV, TSV, or Excel file and wants to
  explore, transform, or visualize the data, even if they don't
  explicitly mention "CSV" or "analysis."
```