# Refactor: agent-skills.io Standard Directory Structure (v2)

## Motivation

The project root IS the skill. `npx skills` expects `skills/<name>/SKILL.md`.
The spec says `name` must match parent directory name. Root-level SKILL.md with
`name: swain-search` violates spec (parent dir is `swain-search-skill`).

## Current trunk layout

```
swain-search-skill/
├── SKILL.md            # Skill at root — wrong per spec/CLI
├── spokes/             # 10 procedure docs (need to go under skill)
├── references/         # 5 ref docs (manifest-schema, normalization-formats, etc.)
├── scripts/            # Shell and Python scripts
├── evals/              # Eval test suites
├── docs/               # Project docs (adr, plans, musings, architecture, etc.)
├── troves/             # Research troves
├── AGENTS.md           # Project-level agent instructions
├── PURPOSE.md          # Project purpose statement
├── README.md, LICENSE, CHANGELOG.md
├── ARCHITECTURE.md, UBIQUITOUS-LANGUAGE.md, TECH-STACK.md, DEVELOPER-WORKFLOWS.md, USER-EXPERIENCE.md
├── .worktrees/, .githooks/, .gitignore
└── markup/             # Empty directory
```

## Target layout

```
swain-search-skill/
├── skills/
│   └── swain-search/           # <-- the actual skill (name matches parent dir)
│       ├── SKILL.md            # Moved from root
│       ├── references/         # spokes/ + references/ merged
│       ├── scripts/            # Moved from root
│       ├── evals/              # Moved from root
│       └── assets/             # New (empty, .gitkeep)
├── docs/                       # Project docs (hub files moved in too)
│   ├── architecture/
│   ├── ubiquitous-language/
│   ├── tech-stack/
│   ├── developer-workflows/
│   ├── user-experience/
│   ├── PURPOSE.md
├── troves/
├── AGENTS.md
├── README.md, LICENSE, CHANGELOG.md
└── .worktrees/, .githooks/, .gitignore
```

After this, `npx skills add https://github.com/cristoslc/swain-search-skill --list`
will discover `skills/swain-search/SKILL.md` with `name: swain-search`.

## Steps (execute in order)

### 1. Remove `markup/` (empty)
```
git rm -r markup/
```

### 2. Move hub files to `docs/` subdirs
```
git mv ARCHITECTURE.md docs/architecture/ARCHITECTURE.md
git mv UBIQUITOUS-LANGUAGE.md docs/ubiquitous-language/UBIQUITOUS-LANGUAGE.md
git mv TECH-STACK.md docs/tech-stack/TECH-STACK.md
git mv DEVELOPER-WORKFLOWS.md docs/developer-workflows/DEVELOPER-WORKFLOWS.md
git mv USER-EXPERIENCE.md docs/user-experience/USER-EXPERIENCE.md
git mv PURPOSE.md docs/PURPOSE.md
```

### 3. Create skill directory structure
```
mkdir -p skills/swain-search
mkdir -p skills/swain-search/assets
```

### 4. Move skill components into skills/swain-search/
```
git mv SKILL.md skills/swain-search/SKILL.md
git mv spokes/ skills/swain-search/references/
git mv references/ skills/swain-search/references/  # merges into same dir
git mv scripts/ skills/swain-search/scripts/
git mv evals/ skills/swain-search/evals/
```

Handle any conflicts if `git mv references/` fails because references/ already exists
under skills/swain-search/. If so, manually move files:
```
mkdir -p skills/swain-search/references
git mv references/* skills/swain-search/references/
git rmdir references/
```

### 5. Create assets/.gitkeep
```
touch skills/swain-search/assets/.gitkeep
```

### 6. Update SKILL.md
- `name: swain-search` — keep (now matches `skills/swain-search/`)
- Remove `user-invocable: true` if present
- Add `compatibility: Designed for opencode and Claude Code (or similar agent products)`
- Fix `allowed-tools` to space-separated format (remove commas)
- Update all relative links:
  - `spokes/` → `references/` (for the moved spoke files)
  - `references/` → `references/` (already correct path-wise, verify)
  - Scripts path: `scripts/` → `scripts/` (relative to SKILL.md location, still `scripts/`)
  - `SKILL_DIR` convention: update to reference `skills/swain-search/`

### 7. Update AGENTS.md
Update references from `spokes/` → `references/` and adjust SKILL.md path.

### 8. Update .githooks/pre-commit
Fix any `spokes/` references.

### 9. Update internal spoke cross-references
Read each file in `skills/swain-search/references/` and fix any `spokes/` links.

## Verification
```bash
# Test the CLI discovery:
git push && npx skills add https://github.com/cristoslc/swain-search-skill --list
# Should show: swain-search
```