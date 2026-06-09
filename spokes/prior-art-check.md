# Prior Art Check

Before creating a new trove or running web searches, scan existing troves for relevant content. This avoids duplicating research and surfaces connections to prior work.

## Phase 1 — Literal keyword match

Search for the source name, URL fragments, and author name:

```bash
# Search trove manifests by tag
grep -rl "<keyword>" docs/troves/*/manifest.yaml 2>/dev/null

# Search trove source content
grep -rl "<keyword>" docs/troves/*/sources/**/*.md 2>/dev/null

# Search trove syntheses
grep -rl "<keyword>" docs/troves/*/synthesis.md 2>/dev/null
```

## Phase 2 — Semantic topic match

After fetching the source and understanding what it's about, extract 3-5 topic keywords from the source's *content* (not just its name or URL). Then search existing troves by topic:

```bash
# Search trove tags for topic keywords
grep -l "<topic-keyword-1>\|<topic-keyword-2>\|<topic-keyword-3>" docs/troves/*/manifest.yaml 2>/dev/null

# Search synthesis summaries for topic keywords
grep -l "<topic-keyword-1>\|<topic-keyword-2>\|<topic-keyword-3>" docs/troves/*/synthesis.md 2>/dev/null
```

Topic keywords should describe what the source *is about*, not what it's *called*. For example, a repo named "Cog" that implements a memory system for Claude Code should generate topic keywords like `agent-memory`, `memory-architecture`, `claude-code`, `persistent-memory` — not `cog` or `marciopuga`.

If the source has not been fetched yet (URL-only invocation), use whatever topic information is available from the URL or title and defer full topic matching until after the source is fetched.

## Decision gate

Before proceeding to Create or Extend mode, output a visible routing decision:

> **Prior art check:** Phase 1 found [N matches / no matches]. Phase 2 found [N matches / no matches]: [trove-id (tags: x, y), ...].
> **Decision:** Extending [trove-id] / Creating new trove [slug] because [reason].

This makes the trove routing decision auditable. If any trove matches on 2+ topic keywords, default to Extend mode unless the topic is genuinely distinct (adjacent but different subject matter).

## Action on matches

If existing troves contain relevant sources:
1. **Report what was found** — show the trove ID, matching source titles, and relevant excerpts
2. **Suggest extend over create** — if an existing trove covers the same topic, extend it rather than creating a parallel trove
3. **Cross-link** — if the topic is adjacent but distinct, create a new trove but note the related trove in synthesis.md

This step runs in all modes (Create, Extend, Discover) and before any web searches. Existing trove content is always checked first.