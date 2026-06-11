# Agent Skills Open Standard — Synthesis

The Agent Skills format, originally developed by Anthropic, is a lightweight open standard for packaging specialized agent capabilities into portable, version-controlled directories. Any skills-compatible agent (Claude Code, GitHub Copilot, OpenAI Codex, etc.) can load and execute them.

## Directory Structure

```
skill-name/
├── SKILL.md          # Required: YAML frontmatter + Markdown instructions
├── scripts/          # Optional: executable code (Python, Bash, JS, etc.)
├── references/       # Optional: supporting documentation loaded on demand
├── assets/           # Optional: templates, images, data files
└── evals/            # Optional: eval test cases in evals.json
```

## SKILL.md Frontmatter Fields

| Field           | Required | Purpose |
|-----------------|----------|---------|
| `name`          | Yes      | 1-64 chars, lowercase alphanumeric + hyphens, matches parent dir name. |
| `description`   | Yes      | 1-1024 chars. Describes what the skill does and when to use it. Primary trigger mechanism. |
| `license`       | No       | License reference (name or bundled file). |
| `compatibility` | No       | 1-500 chars. Environment requirements (product, system packages, network access). |
| `metadata`      | No       | Arbitrary key-value map for custom metadata. |
| `allowed-tools` | No       | Experimental. Space-separated pre-approved tool list. |

## Body Content Conventions

The Markdown body after frontmatter contains instructions. Recommended patterns:
- **Step-by-step instructions** with clear action sequences
- **Gotchas sections** — environment-specific corrections that defy reasonable assumptions
- **Output format templates** — concrete structures for the agent to pattern-match against
- **Checklists** for multi-step workflows with validation gates
- **Plan-validate-execute** loops for destructive operations
- **Validation loops** — do the work, validate, fix, repeat

## Progressive Disclosure Model

Three tiers of loading to minimize context usage:
1. **Catalog** (~100 tokens/skill): name + description loaded at session start
2. **Instructions** (<5000 tokens): full SKILL.md body loaded on activation
3. **Resources** (as needed): scripts, references, assets loaded on demand

## Validation

Use `skills-ref validate ./my-skill` to check frontmatter validity and naming conventions. The tool is available at [github.com/agentskills/agentskills](https://github.com/agentskills/agentskills/tree/main/skills-ref).

## Discovery Conventions

Agents scan `.agents/skills/` (project and user level) plus client-specific directories. Project-level skills override user-level. The specification does not mandate specific search paths — `.agents/skills/` is a widely-adopted convention.

## Eval-Driven Iteration

Skills should be refined through structured evaluation: write test cases (prompt + expected output + assertions), run with and without the skill, grade assertions, aggregate benchmarks, and iterate. The `skill-creator` skill automates this loop.