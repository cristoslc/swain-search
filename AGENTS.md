# swain-search Agent Guidance

See `PURPOSE.md` for the project's intent.

## Starting points

- `SKILL.md` — Full skill definition (modes, workflows, normalization rules)
- `scripts/` — Shell and Python scripts invoked by the skill
- `references/normalization-formats.md` — Per-source-type markdown format specs
- `references/manifest-schema.md` — Manifest YAML schema

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