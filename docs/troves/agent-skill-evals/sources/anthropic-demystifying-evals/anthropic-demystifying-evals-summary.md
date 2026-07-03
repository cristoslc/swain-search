---
title: "Demystifying Evals for AI Agents"
source: "Anthropic Engineering Blog"
url: "https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents"
fetched: "2026-06-09"
type: web
---

# Demystifying Evals for AI Agents (Anthropic, Jan 2026)

## Core definitions

- **Task/problem/test case**: Single test with defined inputs and success criteria
- **Trial**: One attempt at a task; multiple trials produce consistent results
- **Grader**: Logic scoring some aspect of agent performance; can contain multiple assertions/checks
- **Transcript/trace/trajectory**: Complete record of a trial (outputs, tool calls, reasoning, intermediate results)
- **Outcome**: Final state in environment at end of trial (e.g., reservation exists in SQL DB vs. agent saying "booked")
- **Evaluation harness**: Infrastructure running evals end-to-end: instructions, tools, concurrent tasks, recording, grading, aggregation
- **Agent harness/scaffold**: System enabling model to act as agent; evals evaluate harness + model together
- **Evaluation suite**: Collection of tasks measuring specific capabilities/behaviors

## Why build evals

Breaking point: users report agent feels worse after changes and team is "flying blind." Without evals, debugging is reactive: wait for complaints, reproduce manually, fix bug, hope nothing else regressed.

**Compounding value**: costs are visible upfront, benefits accumulate later. Evals shape how quickly teams adopt new models.

## Grader types

### Code-based graders
- Methods: string match (exact, regex, fuzzy), binary tests (fail-to-pass, pass-to-pass), static analysis, outcome verification, tool call verification, transcript analysis (turns, tokens)
- Strengths: fast, cheap, objective, reproducible, easy to debug
- Weaknesses: brittle to valid variations, lacking nuance, limited for subjective tasks

### Model-based graders
- Methods: rubric-based scoring, natural language assertions, pairwise comparison, reference-based evaluation, multi-judge consensus
- Strengths: flexible, scalable, captures nuance, handles open-ended tasks
- Weaknesses: non-deterministic, expensive, requires calibration with human graders

### Human graders
- Methods: SME review, crowdsourced judgment, spot-check sampling, A/B testing, inter-annotator agreement
- Strengths: gold standard, matches expert user judgment, calibrates model-based graders
- Weaknesses: expensive, slow, requires access to human experts

## Capability vs. regression evals

- **Capability/quality evals**: "What can this agent do well?" Start at low pass rate, target struggles, give teams a hill to climb
- **Regression evals**: "Does it still handle all the tasks it used to?" Nearly 100% pass rate target. Protect against backsliding.
- After launch, capability evals with high pass rates can "graduate" to regression suites

## Key techniques by agent type

### Coding agents
- Deterministic graders natural fit (unit tests)
- SWE-bench Verified & Terminal-Bench as canonical examples
- Once outcome tests pass, also grade the transcript (code quality rules, model-based rubrics)

### Conversational agents
- Quality of interaction itself is part of evaluation
- Require verifiable end-state outcomes + rubrics for task completion and interaction quality
- Often need second LLM to simulate user
- τ-Bench and τ²-Bench as canonical benchmarks

### Research agents
- Groundedness checks (claims supported by sources), coverage checks (key facts), source quality checks
- For objectively correct answers: exact match. LLM flags unsupported claims and coverage gaps.
- LLM-based rubrics should be frequently calibrated against expert human judgment

### Computer use agents
- Run in real or sandboxed environment; check whether intended outcome achieved
- WebArena: browser-based tasks with URL/page state checks + backend state verification
- OSWorld: full OS control with file system, app configs, database, UI property inspection

## Non-determinism handling

- **pass@k**: likelihood agent gets at least one correct in k attempts. Rises with k.
- **pass^k**: probability all k trials succeed. Falls with k (harder bar).
- Both useful depending on product requirements

## Roadmap from zero to evals

1. **Start early**: 20-50 simple tasks from real failures is great start
2. **Start with what you test manually**: manual checks, bug tracker, support queue
3. **Write unambiguous tasks**: two domain experts should independently reach same pass/fail. Create reference solution proving task is solvable.
4. **Build balanced problem sets**: test both should-occur and should-not-occur cases
5. **Build robust eval harness with stable environment**: isolate trials, no shared state
6. **Design graders thoughtfully**: grade what agent produced, not path it took. Build in partial credit. LLM-as-judge should be calibrated with human experts.
7. **Check the transcripts**: read transcripts and grades from many trials. Failures should seem fair.
8. **Monitor for saturation**: eval at 100% tracks regressions but provides no improvement signal
9. **Keep suites healthy**: dedicated evals teams own core infrastructure; domain experts/product teams contribute tasks. Eval-driven development.

## Eval frameworks mentioned

- Harbor (containerized environments, trials at scale)
- Braintrust (offline eval + production observability + experiment tracking; autoevals library)
- LangSmith (tracing, offline/online evals, dataset management)
- Langfuse (self-hosted open-source alternative)
- Arize/Phoenix (open-source tracing + eval platform)
- Many teams combine multiple tools or roll their own

## Fit with other methods

- **Automated evals**: faster iteration, reproducible, no user impact, runs on every commit
- **Production monitoring**: real user behavior, catches issues synthetic evals miss
- **A/B testing**: measures actual user outcomes
- **User feedback**: surfaces unanticipated problems
- **Manual transcript review**: builds intuition for failure modes
- **Systematic human studies**: gold-standard quality judgments