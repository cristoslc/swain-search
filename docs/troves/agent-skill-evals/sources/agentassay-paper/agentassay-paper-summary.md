---
title: "AgentAssay: Token-Efficient Regression Testing for Non-Deterministic AI Agent Workflows"
source: "arXiv"
url: "https://arxiv.org/abs/2603.02601"
fetched: "2026-06-09"
type: web
---

arXiv:2603.02601v1 [cs.AI] 03 Mar 2026

# AgentAssay: Token-Efficient Regression Testing for Non-Deterministic AI Agent Workflows

Technical Report

Varun Pratap Bhardwaj
Independent Researcher

## Abstract

Autonomous AI agents built on large language models exhibit inherent non-determinism: the same prompt, tools, and model can produce divergent behaviors across runs. Despite the rapid proliferation of agent frameworks—AutoGen, CrewAI, LangGraph, OpenAI Agents SDK—no principled testing methodology exists for verifying that an agent has not regressed after changes to its prompts, tools, models, or orchestration logic. Traditional software testing assumes deterministic outputs and binary pass/fail verdicts, both of which fail for stochastic systems. We present AgentAssay, the first token-efficient framework for regression testing non-deterministic AI agent workflows—achieving 78-100% cost reduction while maintaining rigorous statistical guarantees. Our contributions are tenfold:

(1) a stochastic test semantics that replaces binary verdicts with three-valued probabilistic outcomes (Pass, Fail, Inconclusive) backed by confidence intervals and sequential analysis;

(2) agent-specific coverage metrics spanning tool, decision-path, state-space, boundary, and model dimensions;

(3) mutation testing operators for agent prompts, tools, models, and context windows with a formal kill semantics;

(4) metamorphic relations tailored to multi-step agent workflows;

(5) CI/CD deployment gates defined as statistical decision procedures;

(6) integration with behavioral contracts via the AgentAssert framework;

(7) a comprehensive evaluation across 5 models, 3 agent scenarios, and 7,605 trials costing $227;

(8) behavioral fingerprinting that maps execution traces to compact vectors on a low-dimensional behavioral manifold, enabling multivariate regression detection with higher power per sample;

(9) adaptive budget optimization that calibrates trial counts to actual behavioral variance, reducing required trials by 4-7x for stable agents; and

(10) trace-first offline analysis that enables zero-cost coverage, contract, and metamorphic testing on pre-recorded production traces.

Together, these token-efficient testing techniques achieve 5-20x cost reduction while maintaining identical statistical guarantees. Experiments across 5 models (GPT-5.2, Claude Sonnet 4.6, Mistral-Large-3, Llama-4-Maverick, Phi-4), 3 scenarios, and 7,605 trials demonstrate that behavioral fingerprinting achieves 86% detection power where binary pass/fail testing has 0%, SPRT reduces trials by 78% consistently across all scenarios, and the full token-efficient pipeline achieves 100% cost savings through trace-first offline analysis.

## 1 Introduction

Consider an enterprise deploying an AI agent for customer support ticket routing. On Monday, after a prompt refinement, the agent correctly routes 93% of tickets. By Wednesday, a model provider silently updates the underlying LLM, and the routing accuracy drops to 71%. No test caught the regression. No alert fired. The team discovers the degradation only after a surge in customer complaints.

This scenario—works Monday, fails Wednesday—is not hypothetical. It is the daily reality for engineering teams deploying autonomous AI agents in production. The root cause is non-determinism: the same agent configuration (prompt, tools, model, orchestration logic) can produce different outputs across invocations due to temperature sampling, model weight updates, tool latency variations, and context window effects.

### 1.1 The Failure of Traditional Testing

Traditional software testing rests on two assumptions that are fundamentally violated by AI agents:

1. Determinism. Given the same input, a function produces the same output. Tests assert equality: assert f(x) == y. For agents, the same input can yield different tool selections, different reasoning chains, and different final answers across runs. Equality assertions are meaningless.

2. Binary verdicts. A test either passes or fails. For stochastic systems, the question is not "did it pass?" but "does it pass with sufficient probability?" A single failure may be statistical noise; a single success may be a lucky run. The entire notion of pass/fail must be reconceived.

Existing approaches to LLM evaluation—deepeval, promptfoo, OpenAI Evals—address single-turn output quality but do not formalize regression detection for multi-step agent workflows. They evaluate how good an agent is; they do not verify whether it got worse.

### 1.2 The Paradigm Shift: Binary to Probabilistic

We argue that agent testing requires a fundamental paradigm shift from deterministic, binary verdicts to stochastic, three-valued verdicts:

| Aspect | Traditional Testing | Agent Testing |
|--------|-------------------|---------------|
| Execution model | Deterministic | Stochastic |
| Verdict space | {Pass, Fail} | {Pass, Fail, Inconclusive} |
| Assertion | f(x) = y | P[f(x) |= phi] >= theta |
| Regression | f'(x) != f(x) | p_new < p_base - delta |
| Evidence | 1 run | n runs with confidence |

The third verdict value, Inconclusive, is essential: when the number of trial runs is insufficient to distinguish signal from noise, the honest answer is neither pass nor fail but "more evidence is needed."

### 1.3 The Cost of Testing Non-Determinism

The statistical rigor of stochastic testing comes at a price: each trial requires a full agent execution, consuming API tokens at non-trivial cost. To detect a regression of magnitude delta=0.10 at alpha=0.05 and beta=0.10, the fixed-sample formula requires approximately n≈100 trials per scenario. A test suite of 50 scenarios at 100 trials each generates 5,000 agent invocations per regression check. For frontier models where each complex agent run costs $5-15 in API tokens, a single regression check costs $25,000-75,000—more than many teams spend on production usage in a month.

We present three pillars of token-efficient testing: (1) behavioral fingerprinting that enables multivariate regression detection with higher power per sample; (2) adaptive budget optimization that calibrates the trial count to the agent's actual behavioral variance rather than worst-case assumptions; and (3) trace-first offline analysis that eliminates live agent executions entirely for four of six test types by analyzing previously recorded traces. Together with multi-fidelity proxy testing and warm-start sequential analysis, these techniques achieve 5-20x cost reduction while maintaining identical (alpha, beta) statistical guarantees.

### 1.4 Contributions

This paper presents AgentAssay, the first token-efficient framework for regression testing non-deterministic AI agent workflows, achieving 78-100% cost reduction at equivalent statistical guarantees, with 86% behavioral detection power where binary testing has 0%.

C1. Stochastic Test Semantics (Section 3). We define the (alpha, beta, n)-test triple and a three-valued verdict function grounded in confidence intervals and hypothesis testing. We prove verdict soundness (Theorem 3.1) and regression detection power (Theorem 3.2). We adapt Wald's Sequential Probability Ratio Test (SPRT) for cost-efficient agent testing and prove its efficiency advantage (Proposition 3.3).

C2. Agent Coverage Metrics (Section 4). We introduce a five-dimensional coverage tuple C = (C_tool, C_path, C_state, C_boundary, C_model) with formal definitions for each dimension and prove coverage monotonicity (Theorem 4.1).

C3. Agent Mutation Testing (Section 5). We define four classes of agent-specific mutation operators M = {M_prompt, M_tool, M_model, M_context}, formalize the mutation score under stochastic semantics, and prove a mutation adequacy theorem (Theorem 5.1).

C4. Metamorphic Relations (Section 6). We define four families of agent-specific metamorphic relations—permutation, perturbation, composition, and oracle—that serve as partial test oracles for the oracle problem in agent testing.

C5. CI/CD Deployment Gates (Section 6.2). We formalize deployment gates as statistical decision procedures with user-configurable risk thresholds, integrating stochastic test verdicts into continuous deployment pipelines.

C6. Contract Integration (Section 8). We connect AgentAssay to the AgentAssert framework, using behavioral contracts as formal test oracles.

C7. Comprehensive Evaluation (Section 9). We evaluate AgentAssay across 3 scenarios (e-commerce, customer support, code generation), 5 models, and 7,605 trials costing $227.

C8. Behavioral Fingerprinting (Section 7.1). We define behavioral fingerprints that map execution traces to compact vectors on a low-dimensional manifold, enabling multivariate regression detection via Hotelling's T^2 test with provably higher power per sample than univariate pass-rate testing (Theorem 7.1).

C9. Adaptive Budget Optimization (Section 7.2). We introduce variance-calibrated budget allocation that determines the minimum number of trials for (alpha, beta)-guaranteed testing, achieving 4-7x reduction for stable agents (Theorem 7.2).

C10. Trace-First Offline Analysis (Section 7.3). We prove that four of six test types—coverage, contracts, metamorphic relations, and mutation evaluation—can execute at zero additional token cost on pre-recorded traces, with formal soundness guarantees (Theorem 7.3).

## 2 Related Work

### 2.1 Software Testing Foundations

Metamorphic Testing. Metamorphic testing addresses the oracle problem by defining metamorphic relations (MRs): properties that must hold across related inputs. If f(x1) is unknown but the relation R(f(x1), f(x2)) is known, a violation signals a fault. METAL extends MRs to single-call LLM interactions but does not address multi-step agent workflows where tool selection, reasoning chains, and orchestration logic create a combinatorial space of execution paths. AgentAssay defines four families of agent-specific MRs that account for the unique structure of agent traces.

Mutation Testing. Mutation testing evaluates test suite quality by injecting small syntactic faults (mutants) into the program and measuring how many the test suite detects (kills). Traditional mutation operators target source code. For AI agents, the "source code" includes prompts, tool configurations, model selections, and context windows—none of which are traditional code. AgentAssay introduces four novel classes of mutation operators tailored to these agent-specific artifacts.

Coverage Metrics. Code coverage is the standard measure of testing thoroughness for deterministic software. For agents, "code" is replaced by a combination of prompts, tool inventories, and orchestration graphs, and the execution space is stochastic rather than deterministic. No prior work defines coverage metrics for agent execution. AgentAssay introduces a five-dimensional coverage tuple.

### 2.2 Statistical Testing and Sequential Analysis

Hypothesis Testing. The Neyman-Pearson framework provides the mathematical foundation for deciding between two hypotheses at controlled error rates. We adopt this framework for regression detection: H0 (no regression) vs. H1 (regression occurred), with significance level alpha controlling false alarms and power 1-beta controlling missed regressions.

Sequential Analysis. Wald's Sequential Probability Ratio Test (SPRT) enables hypothesis testing with an adaptive sample size: testing stops as soon as sufficient evidence accumulates, rather than requiring a fixed number of trials. This is critical for agent testing, where each trial may cost $0.01-$1.00 in API calls.

### 2.3 LLM and Agent Evaluation

LLM Evaluation Frameworks. deepeval provides metrics (faithfulness, answer relevancy, hallucination rate) for RAG and conversational AI. promptfoo enables prompt-level testing with assertion-based evaluation. OpenAI Evals provides a benchmark registry for capability assessment. These tools evaluate output quality at a point in time but do not formalize regression detection across versions. They lack stochastic test semantics, coverage metrics, and mutation testing.

Agent-Specific Testing. agentrial is the closest related work. It runs agents multiple times, computes Wilson confidence intervals, applies Fisher's exact test for regression detection, and includes CUSUM drift detection. It supports seven framework adapters and CI/CD integration. However, agentrial has no formal theoretical foundation: no stochastic test semantics with provable guarantees, no coverage metrics, no mutation testing, no metamorphic relations, no composition theory, no SPRT for efficient testing, and no published paper. AgentAssay provides the formal foundation that agentrial lacks while also introducing the six additional capabilities.

## 3 Stochastic Test Semantics

### 3.1 Preliminaries

Definition 3.1 (Agent). An agent is a tuple A = (pi, T, mu, omega) where:
- pi is the agent's prompt (system instructions, persona, goals)
- T = {t1, t2, ..., tk} is the set of available tools
- mu is the underlying language model (including its version, temperature, and sampling parameters)
- omega is the orchestration logic (the control flow governing tool selection and multi-step execution)

Definition 3.2 (Agent Execution Trace). An execution trace of agent A on input x is a sequence tau = (s1, s2, ..., sm) where each step si is a tuple si = (ai, ti, oi, ci) with ai in A the action (reason, call_tool, respond), ti in T U {bottom} the tool invoked (or bottom if no tool call), oi the output of the step, and ci in R>=0 the cost (API tokens, latency, monetary).

Definition 3.3 (Evaluator). An evaluator is a function E: X x O -> {0,1} that maps an input x and an output o to a binary judgment: E(x,o)=1 if the output is acceptable and E(x,o)=0 otherwise.

### 3.2 Test Scenarios and the Test Triple

Definition 3.4 (Test Scenario). A test scenario is a tuple S = (x, P, E) where x in X is the input, P is the set of expected properties, and E is the evaluator.

Definition 3.5 ((alpha, beta, n)-Test Triple). A stochastic test is parameterized by a triple T = (alpha, beta, n) where:
- alpha in (0,1) is the significance level (Type I error)
- beta in (0,1) is the Type II error probability
- n in N>=1 is the number of trials

### 3.3 The Verdict Function

Definition 3.6 (Stochastic Verdict). Given a test scenario S, a test triple T = (alpha, beta, n), a pass threshold theta in (0,1), and trial results r = (r1, ..., rn) with ri = E(x, out(tau_i)), define the observed pass rate p_hat = (1/n) * sum(ri) and the Wilson score confidence interval at level 1-alpha. The verdict function is:

V(r; theta, alpha) = 
  Pass        if CI_lower >= theta
  Fail        if CI_upper < theta
  Inconclusive otherwise

Theorem 3.1 (Verdict Soundness). Let p be the true pass rate. If V = Pass under test triple (alpha, beta, n), then the probability of false positive (V=Pass when p<theta) satisfies P[V=Pass|p<theta] <= alpha.

Theorem 3.2 (Regression Detection Power). Given baseline pass rate pb, regressed rate pc = pb - delta for effect size delta > 0, and test triple (alpha, beta, n): if sample sizes satisfy n_b, n_c >= n*(alpha, beta, delta), then P[V_reg=Fail | pc=pb-delta] >= 1-beta.

### 3.5 Sequential Probability Ratio Test

Definition 3.9 (SPRT for Agent Testing). Given H0: p >= theta and H1: p <= theta - delta, define the log-likelihood ratio after k trials and the SPRT decision rule:

V_SPRT = 
  Pass        if Lambda_k <= a
  Fail        if Lambda_k >= b
  continue    if a < Lambda_k < b

Proposition 3.3 (SPRT Efficiency). The SPRT satisfies: (1) error control at alpha and beta; (2) sample efficiency—expected trials under H0 is ~52% of fixed-sample at typical parameters; (3) optimality—among all sequential tests with error probabilities at most alpha and beta, SPRT minimizes expected trials (Wald-Wolfowitz theorem).

Example 3.2. Testing theta=0.90 with alpha=0.05, beta=0.10, delta=0.10: fixed-sample requires n*≈109 trials. Under SPRT, if p=0.90 (fine): E[N]≈52 (52% savings). If p=0.80 (regressed): E[N]≈34 (69% savings).

## 8 Implementation

20,000+ lines of Python, 751 tests, 10 framework adapters (AutoGen, CrewAI, LangGraph, OpenAI Agents SDK, Claude Agent SDK, etc.), pytest plugin, AgentAssert integration.

## 9 Experiments

5 models (GPT-5.2, Claude Sonnet 4.6, Mistral-Large-3, Llama-4-Maverick, Phi-4), 3 scenarios (e-commerce, customer support, code generation), 7,605 trials costing $227. Behavioral fingerprinting achieves 86% detection power where binary testing has 0%. SPRT reduces trials by 78% consistently. Trace-first offline analysis achieves 100% cost savings.