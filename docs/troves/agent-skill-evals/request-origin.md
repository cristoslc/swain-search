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
  - event: migrated
    date: 2026-07-02
    model: "deepseek-v4-flash:cloud"
    prompt: |
      Migrate trove to new snapshot/summary split convention.
      Classify existing source files, rename accordingly, fetch missing snapshots.
    context: "Snapshot/summary split implementation (parley 2026-07-02)"
---
