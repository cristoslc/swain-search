---
title: "Testing Agent Skills Systematically with Evals"
source: "OpenAI Developers Blog"
url: "https://developers.openai.com/blog/eval-skills"
fetched: "2026-06-09"
type: web
---

# Testing Agent Skills Systematically with Evals (OpenAI, Jan 2026)

## Core insight

A skill is an organized collection of prompts and instructions for an LLM. Evaluate it the same way as any other LLM prompt.

Eval = a prompt → a captured run (trace + artifacts) → a small set of checks → a score comparable over time.

## Step 1: Define success before writing the skill

Split checks into categories:
- **Outcome goals**: Did task complete? Does app run?
- **Process goals**: Did agent invoke skill and follow intended steps?
- **Style goals**: Does output follow requested conventions?
- **Efficiency goals**: Did it avoid thrashing (unnecessary commands, excessive tokens)?

Keep list small, focus on must-pass checks.

## Step 2: Manual trigger to expose hidden assumptions

Check if skill triggers when expected. Surface:
- **Triggering assumptions**: prompts that should invoke skill but don't, or generic prompts that unintentionally trigger it
- **Environment assumptions**: empty directory, available tooling
- **Execution assumptions**: agent skips steps, wrong ordering

Every manual fix is a candidate for a future eval.

## Step 3: Small targeted prompt set (10-20 prompts)

Start with CSV: each row tests whether skill should/should-not activate.

- **Explicit invocation**: names skill directly
- **Implicit invocation**: describes scenario without naming skill
- **Contextual invocation**: adds domain context but needs same setup
- **Negative control**: should NOT invoke skill (tests false positives)

Grow dataset over time from real failures.

## Step 4: Lightweight deterministic graders

Run agent with `--json` output for structured events. Write deterministic checks:
- Did it run `npm install`?
- Did it create `package.json`?
- Did it invoke expected commands in expected order?

Everything is deterministic and debuggable. Every command execution appears as an event in order.

## Step 5: Qualitative checks with rubric schema

Define JSON Schema for qualitative assessment:
- `overall_pass` (boolean)
- `score` (integer 0-100)
- `checks` (array of {id, pass, notes})

Run read-only style check against resulting repository using `--output-schema` to get structured judgment.

## Extending evals as skill matures

- Command count and thrashing
- Token budget tracking
- Build checks (npm run build)
- Runtime smoke checks (curl dev server)
- Repository cleanliness (git status --porcelain)
- Sandbox and permission regressions (least-privilege defaults)

Pattern: begin with fast checks that explain behavior, add slower heavier checks only when they reduce risk.