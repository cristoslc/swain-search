# Synthesis: `npx skills` CLI — The Open Agent Skills Tool

## What It Is

`npx skills` is a CLI tool by Vercel Labs that installs and manages agent skills — reusable instruction sets that extend coding agent capabilities. It is the primary distribution mechanism for the open agent skills ecosystem, backed by the skills.sh directory and the agentskills.io specification.

The binary is published as the `skills` npm package (latest: v1.5.11) and invoked via `npx skills`.

## Installation & Syntax

The core command is:

```
npx skills add <owner/repo>
```

Sources can be specified as GitHub shorthand (`owner/repo`), full GitHub URLs, GitLab URLs, any git URL, or local paths. The `--list` flag previews available skills without installing.

Key commands:
- `npx skills list` / `npx skills ls` — list installed skills
- `npx skills find [query]` — search skills interactively or by keyword
- `npx skills remove [skills]` — remove installed skills
- `npx skills update [skills]` — update skills to latest versions
- `npx skills init [name]` — create a new SKILL.md template
- `npx skills use <source>` — generate a prompt without installing

### Scope

Skills install at two scopes:
- **Project** (default): `./<agent>/skills/` — committed with the project
- **Global** (`-g`): `~/<agent>/skills/` — available across all projects

Agents can be targeted with `-a <agent>` and specific skills with `-s <skill>`. Use `--all` to install everything non-interactively.

## Skill Discovery in a Repository

When you run `npx skills add <repo>`, the CLI searches for SKILL.md files in these locations:

1. **Root directory** (if it contains `SKILL.md` directly)
2. **`skills/`** — the canonical skills container
3. **`skills/.curated/`**, **`skills/.experimental/`**, **`skills/.system/`** — categorized subdirectories
4. **Agent-specific paths** (`.claude/skills/`, `.agents/skills/`, `.windsurf/skills/`, `.roo/skills/`, and ~50 more agent-specific directories)
5. **Plugin manifests** — `.claude-plugin/marketplace.json` or `.claude-plugin/plugin.json`

Each container directory is walked one level deep (`skills/<name>/SKILL.md`) for flat layouts, and two levels deep (`skills/<category>/<name>/SKILL.md`) for catalog layouts. A shallower SKILL.md shadows nested ones. Use `--full-depth` to also discover SKILL.md files outside these container directories.

## The Skill Directory Structure

For a single-skill repo, the standard layout is:

```
skills/<name>/SKILL.md
```

Where `name` in the YAML frontmatter must match the parent directory name. For multi-skill repos:

```
skills/skill-a/SKILL.md
skills/skill-b/SKILL.md
skills/.curated/skill-c/SKILL.md
```

The `npx skills init` command creates this scaffold automatically.

## How `npx skills add` Works

1. Resolves the source (GitHub, GitLab, local path, etc.)
2. Clones or reads the repository
3. Searches the repo for SKILL.md files in the discovery locations
4. Presents available skills interactively (or uses `--skill` selection)
5. Installs via symlink (default) or copy (`--copy`)
6. Writes to the appropriate agent path based on scope

## Relationship Between Spec and CLI

The **Agent Skills specification** (agentskills.io) defines the SKILL.md format — required frontmatter (name, description), optional fields (license, compatibility, metadata, allowed-tools), and directory structure conventions. The **`npx skills` CLI** is the reference implementation for distributing and installing skills built to that spec. The **skills.sh directory** is the public registry/search index.

The spec mandates that `name` must match the parent directory name — this is the key structural constraint that the CLI relies on for discovery.

## Key Insight

For a single-skill repository, the canonical layout is:
- `skills/<name>/SKILL.md` where `name` in frontmatter matches the parent directory

This is the pattern used by most popular skill repos (anthropics/skills, vercel-labs/agent-skills, mattpocock/skills, etc.). The CLI discovers skills by walking these container directories to the appropriate depth.