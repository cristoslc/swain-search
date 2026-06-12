# swain-search: Independence Awakening

swain-search is now its own standalone repo, no longer a subdirectory of a swain monorepo. Yet the docs still carry the old framing — "for swain-design artifacts," "invoked by swain-design." Time to clean that up.

## Files referencing swain-design as a consumer

| File | What it says | Fix |
|------|-------------|-----|
| `README.md:1,3` | "for swain-design artifacts" / "invoked by swain-design during research-phase transitions" | Rewrite: the skill is self-contained. Mention that troves can be referenced by **any** artifact (design doc, ADR, spike, whatever), not just swain-design ones. Drop the "invoked by swain-design" usage paragraph entirely — usage section already shows the `/swain-search` commands, which is the canonical interface. |
| `docs/PURPOSE.md:1` | "Trove collection and normalization for swain-design artifacts" | Same: s/for swain-design artifacts/as structured research collections/ or drop the qualifier. |
| `skills/swain-search/SKILL.md:3` (frontmatter `description`) | "Trove collection and normalization for swain-design artifacts" | Same treatment. The description field is scanned by skill loaders; it should say what this skill *does*, not who it *serves*. |
| `skills/swain-search/SKILL.md:17` | "Collect, normalize, and cache source materials into reusable troves that swain-design artifacts can reference." | "into reusable troves" is sufficient. Drop the "that swain-design artifacts can reference" clause, or generalize to "that any artifact can reference." |
| `references/create-mode.md:18` | "If invoked from swain-design (e.g., spike entering Active)..." | Drop the swain-design invocation framing. This procedure doc is about creating a trove, period. The "how you got here" is irrelevant. |

## What does NOT need changing

- `CHANGELOG.md` — historical record, leave as-is.
- `AGENTS.md` — no swain-design references.
- `docs/architecture/ARCHITECTURE.md` — already correctly describes itself as "a standalone skill."
- All other reference docs — none mention swain-design.
- References to `writing-skills` / `skill-creator` in `source-collection.md`, `snapshot-evidence-gate.md`, `normalization-formats.md` — those are external normalization skills, not swain components. Leave them.

## What the replacement language should say

The skill's identity should be self-contained:

> "Trove collection and normalization. Collects sources from the web, local files, X/Twitter threads, and video/audio media, normalizes them to markdown, and caches them in reusable troves with provenance, freshness tracking, and thematic synthesis."

No "for X," no "invoked by Y." It is a tool. Any project or agent can point at it.

## One more thing

Also check `~/.config/opencode/skills/swain-search/SKILL.md` — the installed copy under opencode's skill registry may carry the same stale language if it was copied from this repo before independence. Update that copy too.