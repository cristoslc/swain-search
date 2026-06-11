# Refactor: agent-skills.io Standard Directory Structure (v2)

## Motivation

The project root IS the skill. `npx skills` expects `skills/<name>/SKILL.md`.
The spec says `name` must match parent directory name. Root-level SKILL.md with
`name: swain-search` violates spec (parent dir is `swain-search-skill`).

## Status — COMPLETED

The refactor is complete. The new layout:

```
swain-search-skill/
├── skills/
│   └── swain-search/           # Skill (name matches parent dir)
│       ├── SKILL.md            # Skill hub
│       ├── references/         # Procedure docs (spokes + references merged)
│       ├── scripts/            # Shell and Python scripts
│       ├── evals/              # Eval test suites
│       └── assets/             # Empty (assets/.gitkeep)
├── docs/                       # Project docs (hub files moved in)
│   ├── architecture/ARCHITECTURE.md
│   ├── ubiquitous-language/UBIQUITOUS-LANGUAGE.md
│   ├── tech-stack/TECH-STACK.md
│   ├── developer-workflows/DEVELOPER-WORKFLOWS.md
│   ├── user-experience/USER-EXPERIENCE.md
│   ├── PURPOSE.md
│   ├── plans/
│   ├── adr/
│   └── musings/
├── troves/
├── AGENTS.md
├── README.md, LICENSE, CHANGELOG.md
└── .worktrees/, .githooks/, .gitignore
```

Now `npx skills add https://github.com/cristoslc/swain-search-skill --list`
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
git mv --all spokes/ skills/swain-search/references/
git mv --all references/ skills/swain-search/references/  # merges into same dir
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
  - `references/` → `references/` (already correct path-wise, verify)
  - Scripts path: `scripts/` → `scripts/` (relative to SKILL.md location, still `scripts/`)
  - `SKILL_DIR` convention: update to reference `skills/swain-search/`

### 7. Update AGENTS.md
Update references from `spokes/` → `references/` and adjust SKILL.md path.

### 8. Update .githooks/pre-commit
Fix any `spokes/` references.

### 9. Update internal spoke cross-references ✓  
Already fixed — `spokes/` → bare filenames (sibling links, no prefix needed).

## Verification
```bash
# Test the CLI discovery:
git push && npx skills add https://github.com/cristoslc/swain-search-skill --list
# Should show: swain-search
```