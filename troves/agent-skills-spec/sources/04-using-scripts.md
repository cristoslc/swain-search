> ## Documentation Index
> Fetch the complete documentation index at: https://agentskills.io/llms.txt
> Use this file to discover all available pages before exploring further.

# Using scripts in skills

> How to run commands and bundle executable scripts in your skills.

Skills can instruct agents to run shell commands and bundle reusable scripts in a `scripts/` directory. This guide covers one-off commands, self-contained scripts with their own dependencies, and how to design script interfaces for agentic use.

## One-off commands

When an existing package already does what you need, you can reference it directly in your `SKILL.md` instructions without a `scripts/` directory. Many ecosystems provide tools that auto-resolve dependencies at runtime.

**uvx** — Runs Python packages in isolated environments with aggressive caching. Ships with [uv](https://docs.astral.sh/uv/).

```bash
uvx ruff@0.8.0 check .
uvx black@24.10.0 .
```

* Not bundled with Python — requires a separate install.
* Fast. Caches aggressively so repeat runs are near-instant.

**pipx** — Runs Python packages in isolated environments. Available via OS package managers (`apt install pipx`, `brew install pipx`).

```bash
pipx run 'black==24.10.0' .
pipx run 'ruff==0.8.0' check .
```

* Not bundled with Python — requires a separate install.
* A mature alternative to `uvx`. While `uvx` has become the standard recommendation, `pipx` remains a reliable option.

**npx** — Runs npm packages, downloading them on demand. Ships with npm (which ships with Node.js).

```bash
npx eslint@9 --fix .
npx create-vite@6 my-app
```

* Bundled with Node.js — no extra install needed.
* Downloads the package, runs it, and caches it for future use.
* Pin versions with `npx package@version` for reproducibility.

**bunx** — Bun's equivalent of `npx`. Ships with [Bun](https://bun.sh/).

```bash
bunx eslint@9 --fix .
bunx create-vite@6 my-app
```

* Drop-in replacement for `npx` in Bun-based environments.
* Only appropriate when the user's environment has Bun rather than Node.js.

**deno run** — Runs scripts directly from URLs or specifiers. Ships with [Deno](https://deno.com/).

```bash
deno run npm:create-vite@6 my-app
deno run --allow-read npm:eslint@9 -- --fix .
```

* Permission flags (`--allow-read`, etc.) are required for filesystem/network access.
* Use `--` to separate Deno flags from the tool's own flags.

**go run** — Compiles and runs Go packages directly. Built into the `go` command.

```bash
go run golang.org/x/tools/cmd/goimports@v0.28.0 .
go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.0 run
```

* Built into Go — no extra tooling needed.
* Pin versions or use `@latest` to make the command explicit.

**Tips for one-off commands in skills:**

* **Pin versions** (e.g., `npx eslint@9.0.0`) so the command behaves the same over time.
* **State prerequisites** in your `SKILL.md` (e.g., "Requires Node.js 18+") rather than assuming the agent's environment has them. For runtime-level requirements, use the `compatibility` frontmatter field.
* **Move complex commands into scripts.** A one-off command works well when you're invoking a tool with a few flags. When a command grows complex enough that it's hard to get right on the first try, a tested script in `scripts/` is more reliable.

## Referencing scripts from `SKILL.md`

Use **relative paths from the skill directory root** to reference bundled files. The agent resolves these paths automatically — no absolute paths needed.

List available scripts in your `SKILL.md` so the agent knows they exist:

```markdown
## Available scripts

- **`scripts/validate.sh`** — Validates configuration files
- **`scripts/process.py`** — Processes input data
```

Then instruct the agent to run them:

```markdown
## Workflow

1. Run the validation script:
   bash scripts/validate.sh "$INPUT_FILE"

2. Process the results:
   python3 scripts/process.py --input results.json
```

> The same relative-path convention works in support files like `references/*.md` — script execution paths (in code blocks) are relative to the **skill directory root**, because the agent runs commands from there.

## Self-contained scripts

When you need reusable logic, bundle a script in `scripts/` that declares its own dependencies inline. The agent can run the script with a single command — no separate manifest file or install step required.

Several languages support inline dependency declarations:

**Python** — [PEP 723](https://peps.python.org/pep-0723/) defines inline script metadata. Declare dependencies in a TOML block inside `# ///` markers:

```python
# /// script
# dependencies = [
#   "beautifulsoup4",
# ]
# ///

from bs4 import BeautifulSoup
# ...
```

Run with uv: `uv run scripts/extract.py`. `uv run` creates an isolated environment, installs the declared dependencies, and runs the script.

* Pin versions with PEP 508 specifiers: `"beautifulsoup4>=4.12,<5"`
* Use `requires-python` to constrain the Python version
* Use `uv lock --script` to create a lockfile for full reproducibility

**Deno** — `npm:` and `jsr:` import specifiers make every script self-contained:

```typescript
#!/usr/bin/env -S deno run
import * as cheerio from "npm:cheerio@1.0.0";
```

Run with: `deno run scripts/extract.ts`

* Use `npm:` for npm packages, `jsr:` for Deno-native packages
* Version specifiers follow semver
* Packages with native addons (node-gyp) may not work

**Bun** — Auto-installs missing packages at runtime when no `node_modules` directory is found:

```typescript
#!/usr/bin/env bun
import * as cheerio from "cheerio@1.0.0";
```

Run with: `bun run scripts/extract.ts`

* No `package.json` or `node_modules` needed. TypeScript works natively.
* If a `node_modules` directory exists anywhere up the directory tree, auto-install is disabled.

**Ruby** — Bundler ships with Ruby since 2.6. Use `bundler/inline`:

```ruby
require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'nokogiri'
end
```

Run with: `ruby scripts/extract.rb`

* Pin versions explicitly — there is no lockfile.
* An existing `Gemfile` or `BUNDLE_GEMFILE` env var can interfere.

## Designing scripts for agentic use

When an agent runs your script, it reads stdout and stderr to decide what to do next.

### Avoid interactive prompts

This is a hard requirement of the agent execution environment. Agents operate in non-interactive shells — they cannot respond to TTY prompts. Accept all input via command-line flags, environment variables, or stdin.

### Document usage with `--help`

`--help` output is the primary way an agent learns your script's interface. Include a brief description, available flags, and usage examples.

### Write helpful error messages

When an agent gets an error, the message directly shapes its next attempt. Say what went wrong, what was expected, and what to try:

```
Error: --format must be one of: json, csv, table.
       Received: "xml"
```

### Use structured output

Prefer structured formats — JSON, CSV, TSV — over free-form text.

**Separate data from diagnostics:** send structured data to stdout and progress messages, warnings, and other diagnostics to stderr.

### Further considerations

* **Idempotency.** Agents may retry commands. "Create if not exists" is safer than "create and fail on duplicate."
* **Input constraints.** Reject ambiguous input with a clear error rather than guessing.
* **Dry-run support.** For destructive or stateful operations, a `--dry-run` flag lets the agent preview what will happen.
* **Meaningful exit codes.** Use distinct exit codes for different failure types.
* **Safe defaults.** Consider whether destructive operations should require explicit confirmation flags.
* **Predictable output size.** If your script might produce large output, default to a summary or a reasonable limit, and support flags like `--offset` so the agent can request more information.