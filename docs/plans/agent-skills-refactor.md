# Refactor: agent-skills.io Standard Directory Structure

## Motivation

This project predates the Agent Skills open standard. Its directory structure
uses non-standard names (`spokes/`, `markup/`, `.agents/agents-md-detail/`,
top-level hub files) that don't match the spec at
https://agentskills.io/specification. This refactor aligns everything to the
standard so the skill works in any agentskills-compatible client.

## Standard Layout (from agentskills.io spec)

```
skill-name/
├── SKILL.md           # Required: YAML frontmatter + Markdown instructions
├── scripts/           # Optional: executable code
├── references/        # Optional: on-demand documentation
├── assets/            # Optional: templates, resources
└── evals/             # Optional: eval test cases
```

## Changes

### 1. SKILL.md frontmatter — remove non-standard fields

Current frontmatter includes:
- `user-invocable: true` (non-standard)
- `allowed-tools: Bash, Read, Write, ...` (non-standard format — spec says
  space-separated string; also not how the spec intends it)

Remove `user-invocable`. Convert `allowed-tools` to spec-compliant format
(space-separated tool name with optional qualifier). Add `compatibility`
field indicating the skill is designed for opencode/Claude Code.

### 2. Flatten `spokes/` into `references/`

The `spokes/` directory contains reference procedure docs that are never
loaded unless the agent follows a specific mode. In the spec, these are
`references/` files. Move all content from `spokes/*.md` to `references/*.md`.

Each spoke file that is referenced in SKILL.md must have its path updated
in the SKILL.md links.

### 3. Update SKILL.md relative links

Every `spokes/` link in SKILL.md becomes `references/`.

### 4. Remove non-standard top-level files

The spec doesn't define hub files. These project-docs files should move
under `docs/`:
- `ARCHITECTURE.md` → `docs/architecture/ARCHITECTURE.md`
- `UBIQUITOUS-LANGUAGE.md` → `docs/ubiquitous-language/UBIQUITOUS-LANGUAGE.md`
- `TECH-STACK.md` → `docs/tech-stack/TECH-STACK.md`
- `DEVELOPER-WORKFLOWS.md` → `docs/developer-workflows/DEVELOPER-WORKFLOWS.md`
- `USER-EXPERIENCE.md` → `docs/user-experience/USER-EXPERIENCE.md`

### 5. Move `PURPOSE.md` to `docs/`

`PURPOSE.md` is project documentation, not a skill component. Move to `docs/`.

### 6. Remove or move `.agents/agents-md-detail/`

These are per-project agent instructions (the project-level AGENTS.md
references them). The spec doesn't define a `.agents/` directory. These
should move to a more conventional location or be removed.

Since the AGENTS.md at project root references them, they either stay as a
non-standard convenience or get absorbed into the skill. For now, keep them
but they are outside the spec.

### 7. Move `evals/` to standard location

The `evals/` directory already exists — no change needed as it's recognized
by the spec.

### 8. Remove empty `markup/` directory

Empty directories serve no purpose. Delete.

## Non-goals

- The `.worktrees/` directory is infrastructure, not part of the skill —
  leave it.
- The `.githooks/` directory is infrastructure — leave it.
- `CHANGELOG.md`, `LICENSE`, `README.md` are project-level — leave at root.
- `scripts/` already at root — no change needed (it's already a standard dir).
- `.gitignore` — no change.
- `AGENTS.md` — project-level agent instructions, leave at root.
- `.agents/agents-md-detail/` — non-standard but left in place for
  compatibility with the existing AGENTS.md.

## Implementation Order

1. Delete empty `markup/` directory
2. Move top-level hub files to `docs/` subdirectories
3. Move `PURPOSE.md` to `docs/`
4. Rename `spokes/` to `references/` via git mv
5. Update SKILL.md frontmatter (remove user-invocable, fix allowed-tools, add compatibility)
6. Update all relative links in SKILL.md from `spokes/` to `references/`