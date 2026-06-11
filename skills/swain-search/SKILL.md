---
name: swain-search
description: "Trove collection and normalization for swain-design artifacts. Collects sources from the web, local files, and media (video/audio), normalizes them to markdown, and caches them in reusable troves. Use when researching a topic for a spike, ADR, vision, or any artifact that needs structured research. Also use to refresh stale troves or extend existing ones with new sources. Triggers on: 'research X', 'gather sources for', 'compile research on', 'search for sources about', 'refresh the trove', 'find existing research on X', or when swain-design needs research inputs for a spike or ADR."
user-invocable: true
license: MIT
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Skill, WebSearch, WebFetch, AskUserQuestion
metadata:
  short-description: Trove collection and normalization
  version: 1.2.0
  author: cristos
  source: swain
---
<!-- swain-model-hint: opus, effort: high -->

# swain-search

Collect, normalize, and cache source materials into reusable troves that swain-design artifacts can reference.

## Script invocation convention

Scripts live under the `scripts/` directory. Use the `<SKILL_DIR>` placeholder to mean the folder holding this SKILL.md. Resolve it at run time. In an installed skill, that is `.claude/skills/swain-search/`. In the standalone repo, it is the project root.

Run the bootstrap once per session before the media or X-thread flows:

```bash
bash "<SKILL_DIR>/scripts/bootstrap.sh"
```

The script checks that `uv` is on `PATH`. After the first run, a marker file at `~/.local/share/swain-search/.bootstrapped` short-circuits later runs. If it exits non-zero, stop and tell the operator what is missing.

## Mode detection

| Signal | Mode |
|--------|------|
| No trove exists for the topic, or user says "research X" / "gather sources" | **Create** — [spokes/create-mode.md](spokes/create-mode.md) |
| Trove exists and user provides new sources or says "add to" / "extend" | **Extend** — [spokes/extend-mode.md](spokes/extend-mode.md) |
| Trove exists and user says "refresh" or sources are past TTL | **Refresh** — [spokes/refresh-mode.md](spokes/refresh-mode.md) |
| User asks "what troves do we have" or "find sources about X" | **Discover** — [spokes/discover-mode.md](spokes/discover-mode.md) |

## Core policies

- **Verbatim mandate** — Sources are evidence, not summaries. See [spokes/verbatim-mandate.md](spokes/verbatim-mandate.md).
- **Snapshot evidence gate (SPEC-220)** — Remote sources require raw snapshot + metadata verification before normalization. See [spokes/snapshot-evidence-gate.md](spokes/snapshot-evidence-gate.md).
- **Prior art check** — Always scan existing troves before creating new ones. See [spokes/prior-art-check.md](spokes/prior-art-check.md).
- **Capability detection** — Check available tools before collecting. See [spokes/capability-detection.md](spokes/capability-detection.md).

## Source collection

Every source type (web, media, X-threads, CLI, local files, etc.) has its own collection procedure. See [spokes/source-collection.md](spokes/source-collection.md) for the full reference.

Normalization formats per source type are in [references/normalization-formats.md](references/normalization-formats.md).

## Commit and linking

All trove-modifying operations follow the dual-commit pattern and produce artifact links of the form `trove: <trove-id>@<hash>`. See [spokes/linking-from-artifacts.md](spokes/linking-from-artifacts.md) for the full workflow.