---
title: "Test Agent Skills (Promptfoo Docs)"
source: "Promptfoo Documentation"
url: "https://www.promptfoo.dev/docs/guides/test-agent-skills/"
fetched: "2026-06-09"
type: web
---

# Test Agent Skills (Promptfoo, updated Jun 2026)

## Core questions

For two versions of same skill:
1. Does agent use the skill when task calls for it?
2. Does that skill version lead to better work?

For bundles with neighboring skills:
3. Does agent avoid nearby skill when task belongs elsewhere?

## Approach

Keep model, task files, and permissions same. Swap only SKILL.md. Compare results side by side.

### Fixture structure

```
skill-eval/
├── promptfooconfig.yaml
└── fixtures/
    ├── v1/
    │   └── .claude/skills/review-standards/SKILL.md (or .agents/skills/)
    └── v2/
        └── .claude/skills/review-standards/SKILL.md
```

### Provider support

- **Claude Agent SDK**: `setting_sources: ['project']` discovers SKILL.md; `skills:` filter narrows to single skill; `output_format` for structured JSON
- **Codex/OpenAI SDK**: `.agents/skills/` for project skills; `output_schema` for structured output; `skill-used` inferred from successful SKILL.md reads
- **OpenCode SDK**: `.agents/skills/` discovery; native `skill` tool; `format: json_schema` for structured output; `skill-used` normalized from first-class tool calls

## Assertion types

- `skill-used`: confirms agent invoked the skill (first-class on Claude SDK and OpenCode SDK; inferred on Codex)
- `not-skill-used`: confirms agent avoided a sibling skill (routing boundary test)
- `javascript` assertions for custom scoring (e.g., issue recall against expected list)
- `cost`, `latency` as secondary signals
- `max-score` for weighted aggregate combining multiple assertion types
- `trajectory:step-count` for trace-level evidence (Codex deep tracing)

## Routing boundary tests (bundles)

Three-layer bundle eval:
1. Positive prompts that should trigger each skill
2. Near-miss prompts that should trigger a sibling instead
3. Output checks proving chosen skill changed the work (not just routing trace)

## Running

```bash
npx promptfoo@latest eval -c promptfooconfig.yaml
npx promptfoo@latest view  # side-by-side web comparison
```

Options: `--repeat 3` for non-determinism sampling, `--no-cache` for fresh runs