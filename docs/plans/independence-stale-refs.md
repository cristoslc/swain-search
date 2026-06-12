# Plan: Strip stale swain-design references

## Motivation

swain-search is now a standalone repo. Five files still describe it as "for swain-design artifacts" or as being "invoked by swain-design." These references create confusion about the skill's scope and ownership.

## Files to edit

### 1. `README.md`

**Line 1, subtitle:**
- Old: `Trove collection and normalization for swain-design artifacts.`
- New: `Trove collection and normalization. Collects sources from the web, local files, X/Twitter threads, and video/audio media, normalizes them to markdown, and caches them in reusable troves with provenance, freshness tracking, and thematic synthesis.`

**Line 3:** Remove `See [SKILL.md](SKILL.md) for the full workflow.` — the line already has the self-contained description; the SKILL.md link is redundant here.

**Lines 97-98 (Usage paragraph 1):**
- Old: The skill is invoked by swain-design during research-phase transitions (Spike Proposed → Active, ADR Proposed → Active, Vision/Epic creation) and directly by the operator for targeted collection:
- New: The skill is invoked directly by the operator for targeted collection:

### 2. `docs/PURPOSE.md`

- Old: `Trove collection and normalization for swain-design artifacts.`
- New: `Trove collection and normalization. Collects sources from the web, local files, and media (video/audio), normalizes them to markdown, and caches them in reusable troves — structured research collections with provenance, freshness tracking, and thematic synthesis.`

### 3. `skills/swain-search/SKILL.md`

**Frontmatter `description` (line 3):**
- Old: `Trove collection and normalization for swain-design artifacts. Collects sources from the web, local files, and media (video/audio), normalizes them to markdown, and caches them in reusable troves.`
- New: `Trove collection and normalization. Collects sources from the web, local files, and media (video/audio), normalizes them to markdown, and caches them in reusable troves.`

**Line 17 (section header sentence):**
- Old: `Collect, normalize, and cache source materials into reusable troves that swain-design artifacts can reference.`
- New: `Collect, normalize, and cache source materials into reusable troves.`

### 4. `skills/swain-search/references/create-mode.md`

**Line 18:**
- Old: `If invoked from swain-design (e.g., spike entering Active), the artifact context provides the topic, tags, and sometimes initial sources.`
- New: `If the caller has artifact context (e.g., from a spike or ADR), it can provide the topic, tags, and sometimes initial sources.`

## Verification

After each file edit, run `rg -i "swain-design"` to confirm no stale references remain.

## Post-edit steps

1. Commit and push to GitHub (`git add -A && git commit -m "strip stale swain-design references from docs"`)
2. Reinstall everywhere: `npx skills add -y -g cristoslc/swain-search-skill`
3. Verify the installed SKILL.md at `~/.config/opencode/skills/swain-search/SKILL.md` no longer contains "swain-design"