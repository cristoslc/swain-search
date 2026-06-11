> ## Documentation Index
> Fetch the complete documentation index at: https://agentskills.io/llms.txt
> Use this file to discover all available pages before exploring further.

# How to add skills support to your agent

> A guide for adding Agent Skills support to an AI agent or development tool.

This guide covers the full lifecycle: discovering skills, telling the model about them, loading their content into context, and keeping that content effective over time.

The core integration is the same regardless of your agent's architecture. Implementation details vary based on where skills live (filesystem vs cloud) and how the model accesses skill content (file-reading vs dedicated tool).

## The core principle: progressive disclosure

Every skills-compatible agent follows the same three-tier loading strategy:

| Tier            | What's loaded               | When                              | Token cost                  |
| --------------- | --------------------------- | --------------------------------- | --------------------------- |
| 1. Catalog      | Name + description          | Session start                     | ~50-100 tokens per skill    |
| 2. Instructions | Full `SKILL.md` body        | When the skill is activated       | <5000 tokens (recommended)  |
| 3. Resources    | Scripts, references, assets | When instructions reference them  | Varies                      |

The model sees the catalog from the start. When it decides a skill is relevant, it loads the full instructions.

## Step 1: Discover skills

At session startup, find all available skills and load their metadata.

### Where to scan

Scan at least two scopes: project-level (relative to working directory) and user-level (relative to home directory). Within each scope, scan both a client-specific directory and the `.agents/skills/` convention:

| Scope   | Path                                | Purpose                        |
| ------- | ----------------------------------- | ------------------------------ |
| Project | `<project>/.<your-client>/skills/`  | Your client's native location  |
| Project | `<project>/.agents/skills/`         | Cross-client interoperability  |
| User    | `~/.<your-client>/skills/`          | Your client's native location  |
| User    | `~/.agents/skills/`                 | Cross-client interoperability  |

The `.agents/skills/` paths are a widely-adopted convention for cross-client skill sharing.

### What to scan for

Look for subdirectories containing a file named exactly `SKILL.md`. Skip `.git/`, `node_modules/`, and set reasonable bounds (max depth 4-6, max 2000 directories).

### Handling name collisions

Project-level skills override user-level skills. Within the same scope, consistent first-found or last-found is acceptable.

### Trust considerations

Consider gating project-level skill loading on a trust check to prevent untrusted repositories from injecting instructions.

### Cloud-hosted and sandboxed agents

Project-level skills travel with cloned repos. User-level skills need provisioning from an external source. Built-in skills can be packaged as static assets.

## Step 2: Parse SKILL.md files

Extract YAML frontmatter (between `---` delimiters) and markdown body. Handle malformed YAML gracefully (e.g., unquoted colons in values). Warn on issues but load when possible. Skip only when description is missing or YAML is completely unparseable.

Store: `name`, `description`, `location` (absolute path to SKILL.md). Optionally store the body at discovery or read it at activation time.

## Step 3: Disclose available skills to the model

Build a catalog including `name`, `description`, and optionally `location` for each skill. Place it either as a system prompt section or embedded in a dedicated activation tool's description.

Include behavioral instructions telling the model how and when to use skills. Filter out disabled or permission-denied skills entirely. Omit the catalog if no skills are available.

## Step 4: Activate skills

Two patterns:

* **File-read activation**: The model calls its standard file-read tool with the SKILL.md path. Simplest approach when the model has file access.
* **Dedicated tool activation**: Register a tool (e.g., `activate_skill`) that takes a skill name and returns content. Advantages: control returned content, wrap in structured tags, list bundled resources, enforce permissions, track analytics.

Constrain the `name` parameter to valid skill names (e.g., enum). Don't register the tool if no skills exist.

Also support **user-explicit activation** via slash commands or mention syntax.

## Step 5: Manage skill context over time

Exempt skill content from context compaction/pruning. Track which skills are already activated to avoid duplicates. Optionally support subagent delegation for complex workflows.