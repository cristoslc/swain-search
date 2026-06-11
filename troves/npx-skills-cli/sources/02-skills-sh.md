# skills.sh — The Agent Skills Directory

**URL:** https://skills.sh
**Collected:** 2026-06-11

---

## Overview

The Agent Skills Directory — discover and install agent skills.

**Tagline:** The Open Agent Skills Ecosystem

"Skills are reusable capabilities for AI agents. Install them with a single command to enhance your agents with access to procedural knowledge."

## Try it now

```
npx skills add <owner/repo>
```

## Available Agents (70+)

The following agents are supported (as shown on the site badges):

Claude Code, Cursor, Codex, GitHub Copilot, Windsurf, Gemini, Cline, AMP, Antigravity, ClawdBot, Droid, Goose, Kilo, Kiro CLI, Nous Research, OpenCode, Roo, Trae, VS Code, Zed

(and many more — the full list is maintained on the site.)

## Skills Leaderboard

The site features a skills leaderboard with tabs for:

- All Time (665,038 installs tracked)
- Trending (24h)
- Hot

Top skills by installs:

1. **find-skills** (vercel-labs/skills) — 2.0M
2. **frontend-design** (anthropics/skills) — 530.4K
3. **vercel-react-best-practices** (vercel-labs/agent-skills) — 467.9K
4. **agent-browser** (vercel-labs/agent-browser) — 439.7K
5. **microsoft-foundry** (microsoft/azure-skills) — 385.6K

## Site Navigation

- `/` — Home / Leaderboard
- `/topic` — Browse skills by topic
- `/official` — Official/verified skills
- `/audits` — Skill audits and reviews
- `/docs` — Documentation

## Observations

- The site displays SVG agent icons for each supported coding agent.
- The "Try it now" command uses the same syntax as the CLI: `npx skills add <owner/repo>`.
- Install counts are prominently displayed alongside each skill.
- Skills-sh appears to be the canonical registry/directory for the agent skills ecosystem, powered by the `npx skills` CLI.
- Each skill links to `/<owner>/<repo>/<skill-name>` on skills.sh.
- The `find-skills` skill from `vercel-labs/skills` repository is listed with the highest install count.
- Multi-skill repos (e.g. microsoft/azure-skills, anthropics/skills) show "+N more from <repo>" aggregates.
- The site is hosted/branded with Vercel ("Made with love by Vercel").