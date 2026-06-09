# Synthesis: Testing AI Agent Skills Behaviorally and for Regression

## Key findings

The current state-of-the-art for testing AI agent skills has converged on a **layered evaluation approach** combining deterministic checks, LLM-based judges, and trace analysis, with statistical methods emerging for handling non-determinism.

### The core problem

Skills are organized collections of prompts/instructions for LLMs (OpenAI). Evaluating them requires testing both *invocation* (does the agent activate the skill when appropriate?) and *output quality* (does the skill produce the intended result?). Traditional binary pass/fail testing fails because agent outputs are non-deterministic — the same input can produce different but equally valid outputs.

### The three-layer evaluation stack

All major approaches converge on three layers:

1. **Code-based/deterministic graders**: Fast, objective checks (did the skill run? was a file created? was npm install invoked?). These are the first line of defense. Promptfoo's `skill-used` assertion, OpenAI's `--json` event stream checks, and Braintrust's tool-correctness checks all serve this layer.

2. **LLM-as-judge/rubric graders**: For subjective quality dimensions — did the output follow conventions? is the interaction tone appropriate? Anthropic emphasizes structured rubrics with multiple isolated judge passes. OpenAI uses `--output-schema` for structured rubric scoring. Both stress calibration against human experts.

3. **Trace/transcript analysis**: Full recording of tool calls, reasoning steps, intermediate results. AgentAssay's behavioral fingerprinting maps traces to compact vectors for multivariate regression detection. Braintrust and LangSmith both provide trace-based component-level fault isolation.

### Handling non-determinism

Three key techniques have emerged:

- **pass@k / pass^k metrics** (Anthropic): pass@k measures "at least one success in k attempts"; pass^k measures "all k trials succeed". Different metrics for different product requirements.
- **Stochastic three-valued verdicts** (AgentAssay): PASS/FAIL/INCONCLUSIVE with confidence intervals, replacing binary outcomes. Sequential Probability Ratio Testing (SPRT) reduces trial counts by 78%.
- **Repeated runs** (Promptfoo, OpenAI): `--repeat 3` for sampling non-deterministic behavior; `repeat-min-pass` for requiring minimum passes.

### Capability vs. regression evals

A critical distinction from Anthropic:
- **Capability evals**: Start at low pass rate, target struggles, give team a hill to climb
- **Regression evals**: Nearly 100% pass rate target, protect against backsliding from changes
- As capability evals saturate, they "graduate" to regression suites

### Skill-specific evaluation workflow (OpenAI + Promptfoo convergence)

1. **Define success** before writing the skill: outcome, process, style, efficiency goals
2. **Small prompt set** (10-20 cases): explicit trigger, implicit trigger, contextual, negative controls
3. **Fixture-based comparison**: same task files, same model, swap only SKILL.md, compare side-by-side
4. **Deterministic checks first**: skill-used, file existence, command execution
5. **Rubric-based quality grading** via JSON Schema / structured output
6. **Routing boundary tests** for skill bundles: positive, near-miss (should trigger sibling), negative (should trigger none)

### Framework ecosystem

| Tool | Strength | Cost model |
|------|----------|------------|
| **Promptfoo** | YAML-config, multi-provider, skill-used assertions, side-by-side comparison, CI/CD | Open source (MIT), now OpenAI |
| **AgentAssay** | Statistical rigor, mutation testing, behavioral fingerprinting, SPRT | Research prototype |
| **Braintrust** | Production observability + eval, 25+ scorers, Loop AI for custom scorers, CI/CD GitHub Action | Free tier + paid |
| **Anthropic patterns** | Reference methodology — grader types, pass metrics, saturation monitoring | Methodology, not tool |
| **LangSmith** | Tracing + eval, LangChain ecosystem integration, production-to-dataset loop | Free tier + paid |
| **Arize Phoenix** | Open-source tracing + eval, OTel-native | Open source |

### AgentAssay's unique value

The most rigorous framework for regression testing specifically: behavioral fingerprinting (86% detection power where binary testing has 0%), mutation testing for agent components, and trace-first offline analysis achieving 100% cost savings. It is the only framework addressing all dimensions in a unified statistical framework.

## Points of agreement

All sources agree on:
- Start with 10-50 tasks from real failures — don't wait for large benchmark
- Combine deterministic + LLM-based + human grading
- Grade what the agent *produced*, not the path it took
- Calibrate LLM judges against human experts
- Read transcripts regularly — metrics alone are insufficient
- Use tracing to isolate which component caused failure
- Turn every production failure into a regression test

## Points of disagreement

- **AgentAssay** argues binary verdicts are fundamentally inadequate for non-deterministic agents; **Anthropic** and **OpenAI** both use binary pass/fail as primary verdicts supplemented by repeated trials
- **Anthropic** recommends keeping capability evals unsaturated for improvement signal; **OpenAI** focuses more on regression detection from the start
- **Promptfoo** emphasizes YAML/configuration-driven approach; **Braintrust** emphasizes SDK-based integration and production monitoring as primary workflow

## Gaps

- No source covers *automated generation* of evaluation criteria from skill descriptions — all require manual task authoring
- No empirical comparison of tools on the same skill-testing benchmark
- Mutation testing for agent skills (AgentAssay concept) not yet applied to skills specifically
- No treatment of multi-model evaluation (testing whether a skill works across different LLMs)
- Long-running agent skills (>100 turns) not addressed — all approaches assume relatively short interactions