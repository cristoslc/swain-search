# swain-search Agent Guidance

See `PURPOSE.md` for the project's intent.

## Starting points

- `SKILL.md` — Skill hub (frontmatter, mode table, core policies, links to spokes)
- `spokes/` — Detailed procedure docs linked from SKILL.md
- `scripts/` — Shell and Python scripts invoked by the skill
- `references/normalization-formats.md` — Per-source-type markdown format specs
- `references/manifest-schema.md` — Manifest YAML schema

## SKILL.md hub-and-spoke architecture

`SKILL.md` is the concise hub. It links to spoke files in `spokes/` for detailed procedures:

| Spoke | Purpose |
|-------|---------|
| `spokes/prior-art-check.md` | Scanning existing troves before creating new ones |
| `spokes/verbatim-mandate.md` | Sources are evidence, not summaries |
| `spokes/snapshot-evidence-gate.md` | SPEC-220 raw snapshot + verification flow |
| `spokes/source-collection.md` | Per-source-type collection procedures (web, media, X-thread, CLI, etc.) |
| `spokes/create-mode.md` | Create a new trove from scratch |
| `spokes/extend-mode.md` | Add sources to an existing trove |
| `spokes/refresh-mode.md` | Re-fetch stale sources |
| `spokes/discover-mode.md` | Find existing troves by topic |
| `spokes/capability-detection.md` | Tool availability checks and fallbacks |
| `spokes/linking-from-artifacts.md` | Dual-commit pattern and `trove: <id>@<hash>` linking |

## Key rules

1. **Verbatim mandate** — Never summarize or condense source content. Only `synthesis.md` may contain summaries.
2. **Snapshot-first** — Always export raw snapshot before normalizing remote sources (SPEC-220).
3. **Dual-commit pattern** — Commit A records content, Commit B stamps the hash into manifest and referencing artifacts.
4. **Graceful degradation** — Missing tools are skipped, not hard-failures.

## Hubs and spokes

- `ARCHITECTURE.md` → `docs/architecture/`
- `UBIQUITOUS-LANGUAGE.md` → `docs/ubiquitous-language/`
- `TECH-STACK.md` → `docs/tech-stack/`
- `DEVELOPER-WORKFLOWS.md` → `docs/developer-workflows/`
- `USER-EXPERIENCE.md` → `docs/user-experience/`
- `docs/adr/` — Architecture decision records
- `docs/plans/` — Implementation plans
- `docs/musings/` — Pre-artifact thought capture