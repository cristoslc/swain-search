# swain-search Agent Guidance

See `docs/PURPOSE.md` for the project's intent.

## Starting points

- `skills/swain-search/SKILL.md` — Skill hub (frontmatter, mode table, core policies, links to spokes)
- `skills/swain-search/references/` — Detailed procedure docs linked from SKILL.md
- `skills/swain-search/scripts/` — Shell and Python scripts invoked by the skill
- `skills/swain-search/references/normalization-formats.md` — Per-source-type markdown format specs
- `skills/swain-search/references/manifest-schema.md` — Manifest YAML schema

## SKILL.md hub-and-spoke architecture

`SKILL.md` is the concise hub. It links to spoke files in `skills/swain-search/references/` for detailed procedures:

| Spoke | Purpose |
|-------|---------|
| `skills/swain-search/references/prior-art-check.md` | Scanning existing troves before creating new ones |
| `skills/swain-search/references/verbatim-mandate.md` | Sources are evidence, not summaries |
| `skills/swain-search/references/snapshot-evidence-gate.md` | SPEC-220 raw snapshot + verification flow |
| `skills/swain-search/references/source-collection.md` | Per-source-type collection procedures (web, media, X-thread, CLI, etc.) |
| `skills/swain-search/references/create-mode.md` | Create a new trove from scratch |
| `skills/swain-search/references/extend-mode.md` | Add sources to an existing trove |
| `skills/swain-search/references/refresh-mode.md` | Re-fetch stale sources |
| `skills/swain-search/references/discover-mode.md` | Find existing troves by topic |
| `skills/swain-search/references/capability-detection.md` | Tool availability checks and fallbacks |
| `skills/swain-search/references/linking-from-artifacts.md` | Dual-commit pattern and `trove: <id>@<hash>` linking |

## Key rules

1. **Verbatim mandate** — Never summarize or condense source content. Only `synthesis.md` may contain summaries.
2. **Snapshot-first** — Always export raw snapshot before normalizing remote sources (SPEC-220).
3. **Dual-commit pattern** — Commit A records content, Commit B stamps the hash into manifest and referencing artifacts.
4. **Graceful degradation** — Missing tools are skipped, not hard-failures.

## Hubs and spokes

- `docs/architecture/ARCHITECTURE.md`
- `docs/ubiquitous-language/UBIQUITOUS-LANGUAGE.md`
- `docs/tech-stack/TECH-STACK.md`
- `docs/developer-workflows/DEVELOPER-WORKFLOWS.md`
- `docs/user-experience/USER-EXPERIENCE.md`
- `docs/adr/` — Architecture decision records
- `docs/plans/` — Implementation plans
- `docs/musings/` — Pre-artifact thought capture

## Test command

Run the test suite from `skills/swain-search/`:

```bash
cd skills/swain-search
uv run --with pytest --with markdownify --with playwright --with beautifulsoup4 pytest
```