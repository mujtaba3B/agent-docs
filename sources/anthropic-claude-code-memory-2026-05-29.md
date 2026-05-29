# Anthropic: How Claude remembers your project (CLAUDE.md + auto memory)

- Source: https://code.claude.com/docs/en/memory
- Fetched: 2026-05-29 (via gstack `/browse`)
- Vendor: Anthropic (Claude Code)

> Snapshot of the canonical Anthropic memory docs as of the fetch date. Distilled
> from the live page; chrome/nav stripped. Treat the URL above as source of truth.

---

## Two memory mechanisms

Each session starts with a fresh context window. Two mechanisms carry knowledge across sessions:

- **CLAUDE.md files**: instructions you write to give Claude persistent context. Written by you. Contains instructions and rules. Loaded into every session.
- **Auto memory**: notes Claude writes itself based on your corrections and preferences. Written by Claude. Contains learnings and patterns. Per repository, shared across worktrees. Loaded into every session (first 200 lines or 25 KB of `MEMORY.md`).

Both are loaded at the start of every conversation. Claude treats them as **context, not enforced configuration**. To block an action regardless of what Claude decides, use a `PreToolUse` hook. The more specific and concise the instructions, the more consistently Claude follows them.

## When to add to CLAUDE.md

Treat CLAUDE.md as the place you write down what you'd otherwise re-explain. Add when:

- Claude makes the same mistake a second time.
- A code review catches something Claude should have known about this codebase.
- You type the same correction or clarification you typed last session.
- A new teammate would need the same context to be productive.

Keep it to facts Claude should hold in every session: build commands, conventions, project layout, "always do X" rules. If an entry is a multi-step procedure or only matters for one part of the codebase, move it to a **skill** or a **path-scoped rule** instead.

## Where CLAUDE.md files live (load order, broad to specific)

| Scope | Location | Shared with |
|---|---|---|
| Managed policy | macOS `/Library/Application Support/ClaudeCode/CLAUDE.md`; Linux/WSL `/etc/claude-code/CLAUDE.md`; Windows `C:\Program Files\ClaudeCode\CLAUDE.md` | All users in org |
| User instructions | `~/.claude/CLAUDE.md` | Just you (all projects) |
| Project instructions | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team via source control |
| Local instructions | `./CLAUDE.local.md` (gitignore it) | Just you (current project) |

Files in the directory hierarchy above cwd load in full at launch. Files in subdirectories load on demand when Claude reads files in those directories.

## Write effective instructions

- **Size: target under 200 lines per CLAUDE.md file.** Longer files consume more context and reduce adherence. If instructions grow large, use path-scoped rules so they load only when Claude works with matching files. `@path` imports help organization but do NOT reduce context (imported files still load at launch).
- **Structure**: markdown headers and bullets to group related instructions.
- **Specificity**: write instructions concrete enough to verify. "Use 2-space indentation" beats "Format code properly". "API handlers live in src/api/handlers/" beats "Keep files organized".
- **Consistency**: if two rules contradict, Claude may pick one arbitrarily. Review periodically; in monorepos use `claudeMdExcludes` to skip other teams' files.

## Imports (`@path/to/file`)

CLAUDE.md can import additional files with `@path/to/import`. Imported files expand and load into context at launch alongside the referencing file. Relative paths resolve relative to the importing file. Recursion allowed up to depth 4. Imports do not save context tokens; they are for organization.

`CLAUDE.local.md` at project root loads alongside CLAUDE.md, treated the same; gitignore it. To share personal instructions across worktrees, import from home: `@~/.claude/my-project-instructions.md`.

## AGENTS.md compatibility

Claude Code reads `CLAUDE.md`, NOT `AGENTS.md`. If your repo already uses AGENTS.md, create a CLAUDE.md that imports it so both tools read the same instructions:

```text
CLAUDE.md
@AGENTS.md

## Claude Code
Use plan mode for changes under `src/billing/`.
```

A symlink also works if you do not need Claude-specific content: `ln -s AGENTS.md CLAUDE.md`. On Windows, symlinks need admin/Developer Mode, so use the `@AGENTS.md` import. Running `/init` in a repo with AGENTS.md reads it (and `.cursorrules`, `.windsurfrules`) and incorporates relevant parts.

## How CLAUDE.md files load

Claude walks up the directory tree from cwd, checking each directory for `CLAUDE.md` and `CLAUDE.local.md`. All discovered files are concatenated (not overriding), ordered root-down so instructions closer to cwd are read last. Within a directory, `CLAUDE.local.md` is appended after `CLAUDE.md`. Subdirectory files load when Claude reads files there.

**Block-level HTML comments (`<!-- maintainer notes -->`) are stripped before injection** into context. Use them for human-only notes at zero context cost. Comments inside code blocks are preserved; they stay visible when you Read the file directly.

`--add-dir` does not load CLAUDE.md from extra dirs by default; set `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1` to load them.

## Organize rules with `.claude/rules/`

For larger projects, split instructions into `.claude/rules/*.md`, one topic per file (e.g. `code-style.md`, `testing.md`, `security.md`). All `.md` files discovered recursively, so you can nest `frontend/` or `backend/` subdirs.

- **Rules without `paths:` frontmatter** load at launch, same priority as `.claude/CLAUDE.md`.
- **Path-specific rules** scope via YAML frontmatter `paths:` field. They apply only when Claude works with matching files:

```yaml
---
paths:
- "src/api/**/*.ts"
---
# API Development Rules
- All API endpoints must include input validation
```

Glob patterns: `**/*.ts` (all TS), `src/**/*` (under src), `*.md` (root markdown), `src/components/*.tsx`. Brace expansion: `src/**/*.{ts,tsx}`. Path-scoped rules trigger when Claude reads matching files, not every tool use.

- **Share via symlinks**: `.claude/rules/` supports symlinks (resolved + loaded normally; circular ones handled). `ln -s ~/shared-claude-rules .claude/rules/shared`.
- **User-level rules**: `~/.claude/rules/*.md` apply to every project on your machine. Loaded before project rules (project rules win on conflict).

Rules load every session (or when matching files open). For task-specific instructions that should NOT always be in context, use **skills** (load only when invoked or judged relevant).

## Large teams

- **Org-wide managed CLAUDE.md**: deploy at the managed policy location via MDM/Group Policy/Ansible. Cannot be excluded by individual settings. Or put content in `managed-settings.json` under the `claudeMd` key (only honored in managed/policy settings).
- Use managed **settings** for technical enforcement (`permissions.deny`, `sandbox.enabled`, env, `forceLoginMethod`); use managed **CLAUDE.md** for behavioral guidance.
- **`claudeMdExcludes`**: skip specific ancestor CLAUDE.md by path/glob, e.g. in `.claude/settings.local.json`. Matched against absolute paths. Arrays merge across layers. Managed policy CLAUDE.md cannot be excluded.

## Auto memory

Claude accumulates knowledge across sessions without you writing anything: build commands, debugging insights, architecture notes, style preferences, workflow habits. It decides what is worth remembering. Requires Claude Code v2.1.59+. On by default; toggle via `/memory` or `autoMemoryEnabled: false` in project settings, or `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`.

- **Storage**: `~/.claude/projects/<project>/memory/`. `<project>` derived from the git repo, so all worktrees/subdirs of a repo share one memory dir. Outside a git repo, the project root is used. Redirect with `autoMemoryDirectory` (user settings only, must be absolute or `~/`; rejected from project/local settings for security).
- **`MEMORY.md`** is a concise index. First 200 lines or 25 KB loaded at session start; topic files (`debugging.md`, etc.) read on demand. (This limit applies only to MEMORY.md; CLAUDE.md loads in full regardless of length.)
- **Audit/edit** via `/memory`. All plain markdown; edit or delete freely.

## Troubleshooting

- **Claude isn't following CLAUDE.md**: content is delivered as a user message after the system prompt; no strict-compliance guarantee. Run `/memory` to verify files load; make instructions specific; remove conflicts; for "must run at point X" use a hook; for system-prompt level use `--append-system-prompt`; use the `InstructionsLoaded` hook to log which instruction files loaded.
- **CLAUDE.md too large**: files over 200 lines reduce adherence; use path-scoped rules or trim. `@path` imports help organization but not context size.
- **Instructions lost after `/compact`**: project-root CLAUDE.md survives (re-read from disk and re-injected). Nested subdirectory CLAUDE.md are not re-injected automatically; reload next time Claude reads a file there.
