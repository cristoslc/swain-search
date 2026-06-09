---
title: "AgentAssay: Token-Efficient Regression Testing for Non-Deterministic AI Agent Workflows"
source: "arXiv"
url: "https://arxiv.org/abs/2603.02601"
fetched: "2026-06-09"
type: web
---

# AgentAssay (Bhardwaj, Mar 2026)

First principled framework for regression testing non-deterministic AI agent workflows. 78-100% cost reduction with rigorous statistical guarantees.

## Eight contributions

1. **Stochastic three-valued verdicts**: PASS/FAIL/INCONCLUSIVE backed by confidence intervals and sequential analysis. Replaces binary pass/fail with probabilistic outcomes.
2. **Five-dimensional agent coverage metrics**: tool, decision-path, state-space, boundary, model dimensions
3. **Agent-specific mutation testing operators**: for prompts, tools, models, context windows with formal kill semantics
4. **Metamorphic relations**: tailored to multi-step agent workflows
5. **CI/CD deployment gates**: defined as statistical decision procedures
6. **Behavioral fingerprinting**: maps execution traces to compact vectors, enabling multivariate regression detection. Achieves 86% detection power where binary testing has 0%.
7. **Adaptive budget optimization**: calibrates trial counts to behavioral variance. SPRT reduces trials by 78%.
8. **Trace-first offline analysis**: zero-cost testing on production traces. 100% cost savings through trace-first analysis.

## Empirical results

- 5 models: GPT-5.2, Claude Sonnet 4.6, Mistral-Large-3, Llama-4-Maverick, Phi-4
- 3 scenarios, 7,605 trials
- Implementation: 20,000+ lines of Python, 751 tests, 10 framework adapters

## Key insight

No prior work in software engineering, AI/ML evaluation, or formal methods addresses all these concerns in a unified framework for agent regression testing.