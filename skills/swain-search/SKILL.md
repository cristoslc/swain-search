---
name: swain-search
description: "Trove collection and normalization. Collects sources from the web, local files, and media (video/audio), normalizes them to markdown, and caches them in reusable troves. Use when researching a topic for a spike, ADR, vision, or any artifact that needs structured research. Also use to refresh stale troves or extend existing ones with new sources. Triggers on: 'research X', 'gather sources for', 'compile research on', 'search for sources about', 'refresh the trove', 'find existing research on X', or when research inputs are needed for a spike or ADR."
license: MIT
compatibility: Designed for opencode and Claude Code (or similar agent products)
allowed-tools: Bash Read Write Edit Glob Grep Skill WebSearch WebFetch AskUserQuestion
metadata:
  short-description: Trove collection and normalization
  version: 1.2.0
  author: cristos
  source: swain
---
<!-- swain-model-hint: opus, effort: high -->

# swain-search

Collect, normalize, and cache source materials into reusable troves.

## Script invocation convention

Scripts live under the `scripts/` directory. Use the `<SKILL_DIR>` placeholder to mean the folder holding this SKILL.md. Resolve it at run time. In an installed skill, that is `.claude/skills/swain-search/`. In the standalone repo, it is `skills/swain-search/`.

Run the bootstrap once per session before the media or X-thread flows:

```bash
bash "<SKILL_DIR>/scripts/bootstrap.sh"
```

The script checks that `uv` is on `PATH`. After the first run, a marker file at `~/.local/share/swain-search/.bootstrapped` short-circuits later runs. If it exits non-zero, stop and tell the operator what is missing.

## Mode detection

| Signal | Mode |
|--------|------|
| No trove exists for the topic, or user says "research X" / "gather sources" | **Create** — [references/create-mode.md](references/create-mode.md) |
| Trove exists and user provides new sources or says "add to" / "extend" | **Extend** — [references/extend-mode.md](references/extend-mode.md) |
| Trove exists and user says "refresh" or sources are past TTL | **Refresh** — [references/refresh-mode.md](references/refresh-mode.md) |
| User asks "what troves do we have" or "find sources about X" | **Discover** — [references/discover-mode.md](references/discover-mode.md) |

## Core policies

- **Verbatim mandate** — Sources are evidence, not summaries. See [references/verbatim-mandate.md](references/verbatim-mandate.md).
- **Snapshot evidence gate (SPEC-220)** — Remote sources require raw snapshot + metadata verification before normalization. See [references/snapshot-evidence-gate.md](references/snapshot-evidence-gate.md).
- **Prior art check** — Always scan existing troves before creating new ones. See [references/prior-art-check.md](references/prior-art-check.md).
- **Capability detection** — Check available tools before collecting. See [references/capability-detection.md](references/capability-detection.md).

## Source collection

Every source type (web, media, X-threads, CLI, local files, etc.) has its own collection procedure. See [references/source-collection.md](references/source-collection.md) for the full reference.

Normalization formats per source type are in [references/normalization-formats.md](references/normalization-formats.md).

## Commit and linking

All trove-modifying operations follow the dual-commit pattern and produce artifact links of the form `trove: <trove-id>@<hash>`. See [references/linking-from-artifacts.md](references/linking-from-artifacts.md) for the full workflow.