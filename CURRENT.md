# CURRENT.md - what agent files should contain (2026-Q2)

Mujtaba's working synthesis of how to author and organize the markdown files AI coding agents read every session: `CLAUDE.md`, `AGENTS.md`, `.claude/rules/`, `.cursor/rules/`, and the rest. Built from the upstream sources cached in `sources/` plus reconciliation across vendors.

- Last synthesized: 2026-05-29 (founding revision; see `CHANGELOG.md`).
- Sources of record: `sources/` (Anthropic, agents.md, Cursor, OpenAI Codex, GitHub Copilot).
- Read this before any significant agent-files change. The `agent-files-architect` skill (now living in this repo, `skills/agent-files-architect/`) is the tool that audits a real tree against this guidance.

---

## If you only read one page

The most actionable rules, ranked by impact for this user's Claude-first, multi-repo setup.

1. **Keep every CLAUDE.md under ~200 lines.** Anthropic's published target. Longer files consume more context and *reduce adherence*, so an over-long file is worse than a shorter one, not just heavier. This is the single highest-impact lever. (Open follow-up: `~/.claude/CLAUDE.md` is ~400 lines, ~3,940 tokens, loaded every session, every project. The documented fix is below.)
2. **Move topic blocks out of an over-long CLAUDE.md into `~/.claude/rules/<topic>.md`.** Rules with no `paths:` frontmatter load every session just like CLAUDE.md (so behavior is preserved); rules with `paths:` load only when Claude touches matching files (so you reclaim context). No rules files exist on this machine yet; this is the recommended next step.
3. **Be specific and verifiable.** "Use 2-space indentation" beats "format properly"; "API handlers live in src/api/handlers/" beats "keep files organized". Vague rules get picked arbitrarily.
4. **CLAUDE.md is context, not enforcement.** For a hard "always/never at point X" (pre-commit, post-edit), use a **hook**, not prose. The user already does this (CLAUDE.md edit gate, memory write gate).
5. **One topic per rules file; reference, don't copy.** Point at canonical files/skills instead of pasting their contents, so rules don't go stale. Cursor caps rules at 500 lines; the same instinct applies to `.claude/rules/`.
6. **Multi-step procedures belong in skills, not CLAUDE.md.** If an entry is a procedure or only matters for part of the tree, it is a skill or a path-scoped rule, not an always-loaded instruction.
7. **Avoid contradictions across the CLAUDE.md stack** (user / workspace / project). On conflict Claude may pick either. Keep lower tiers as pointer-up references or layer-specific applications, not restatements that can drift.
8. **Use `<!-- ... -->` HTML comments for human-only notes.** Anthropic strips block-level HTML comments before injection, so maintainer notes cost zero session tokens but stay visible when you open the file.
9. **One root `CLAUDE.md` can serve Claude + Copilot + Codex.** GitHub Copilot's coding agent and OpenAI Codex both honor a root `AGENTS.md`/`CLAUDE.md`. If a second agent ever enters the workflow, a root `AGENTS.md` with `@AGENTS.md` imported from `CLAUDE.md` is the convergence pattern. Not needed while Claude-only.
10. **LOG.md / INDEX.md are not loaded at session start.** They are read on demand. So their size is not a per-session context cost; do not over-trim them for token reasons (trim them for findability).

---

## Per-vendor reference

### Anthropic - Claude Code (`CLAUDE.md`, `.claude/rules/`, auto memory)

Full snapshot: `sources/anthropic-claude-code-memory-2026-05-29.md`.

- **Two systems**: CLAUDE.md (you write; loaded in full every session) and auto memory (Claude writes; `MEMORY.md` index, first 200 lines / 25 KB loaded). Both are context, not enforcement.
- **Locations, load order broad→specific**: managed policy → user `~/.claude/CLAUDE.md` → project `./CLAUDE.md` or `./.claude/CLAUDE.md` → local `./CLAUDE.local.md` (gitignore it). Ancestor files load in full at launch; subdirectory files load on demand.
- **Size target: under 200 lines per file.** Over that "consume more context and reduce adherence."
- **`.claude/rules/<topic>.md`**: one topic per file, discovered recursively. No `paths:` → loads at launch, same priority as `.claude/CLAUDE.md`. With `paths:` glob frontmatter → loads only when Claude reads matching files. Supports symlinks for sharing. User-level `~/.claude/rules/*.md` apply to every project (loaded before project rules).
- **Imports** (`@path`) expand at launch; good for organization, **do not save context**.
- **AGENTS.md**: Claude Code reads CLAUDE.md only, but `@AGENTS.md` import or `ln -s AGENTS.md CLAUDE.md` bridges. `/init` reads existing AGENTS.md / `.cursorrules` when generating.
- **HTML comments** (`<!-- -->`) stripped before injection (except inside code blocks). Zero-cost human notes.
- **Enforcement** lives in hooks and managed settings (`permissions.deny`, `sandbox`, etc.), not CLAUDE.md.
- **Debug**: `/memory` (what's loaded), `InstructionsLoaded` hook (log loads), `--append-system-prompt` (system-level), `claudeMdExcludes` (skip ancestor files in monorepos). Project-root CLAUDE.md survives `/compact`; nested ones reload on next read.

### agents.md - the open cross-vendor format

Full snapshot: `sources/agents-md-spec-2026-05-29.md`.

- Open Markdown format, 60k+ repos, 25+ tools. README is for humans; AGENTS.md is "a README for agents."
- No required fields. Recommended sections: project overview, build/test commands, code style, testing, security, commit/PR conventions, deploy steps. "Anything you'd tell a new teammate."
- Nested AGENTS.md per subproject; nearest file wins; explicit chat prompts override everything.
- Now stewarded by the Agentic AI Foundation under the Linux Foundation.

### Cursor - `.cursor/rules/*.mdc`

Full snapshot: `sources/cursor-rules-2026-05-29.md`.

- Four kinds: Project Rules (`.cursor/rules/*.mdc`, version-controlled), User Rules (global), Team Rules (dashboard, Team/Enterprise), and AGENTS.md (plain-markdown alternative).
- `.mdc` files only; a plain `.md` in `.cursor/rules` is ignored (no frontmatter). Frontmatter fields `alwaysApply` / `description` / `globs` select one of four application modes: Always, Apply Intelligently (by description), Apply to Specific Files (globs), Manual (`@`-mention).
- Best practice: under 500 lines, split large rules, reference files instead of copying, write like internal docs. "Add rules only when you notice the Agent making the same mistake repeatedly."
- Precedence: Team → Project → User (earlier wins on conflict). Remote rules importable from GitHub.

### OpenAI Codex - `AGENTS.md` + `AGENTS.override.md`

Full snapshot: `sources/openai-codex-agents-md-2026-05-29.md`.

- Instruction chain built at startup. Precedence: global (`~/.codex/AGENTS.override.md` else `AGENTS.md`) → project (root down to cwd, `AGENTS.override.md` then `AGENTS.md` then fallbacks, one file per directory) → merged root-down, closer-to-cwd wins.
- Size cap `project_doc_max_bytes` = **32 KiB** default. Stops once combined size hits the cap; raise it or split across nested dirs.
- `AGENTS.override.md` shadows a sibling `AGENTS.md`. `project_doc_fallback_filenames` lets other filenames count. `CODEX_HOME` selects a profile.
- Verify with `codex --ask-for-approval never "Summarize the current instructions."`; audit loads in `~/.codex/log/`.

### GitHub Copilot - `.github/copilot-instructions.md` + `AGENTS.md`/`CLAUDE.md`

Full snapshot: `sources/github-copilot-custom-instructions-2026-05-29.md`.

- Three types: repo-wide (`.github/copilot-instructions.md`), path-specific (`.github/instructions/<name>.instructions.md`, `applyTo` globs), and agent instructions (`AGENTS.md` anywhere, nearest wins; or a root `CLAUDE.md` / `GEMINI.md`).
- Repo-wide + matching path-specific instructions are both used.
- GitHub publishes a strong reusable "onboard this repo" prompt (cached in the snapshot) for generating an instructions file: 2-page cap, not task-specific, document build/validate/layout, end with "trust the instructions, only search if incomplete."

---

## Synthesis - cross-vendor reconciliation (Mujtaba's opinions)

### The pattern every vendor converged on

All five landed on the same three-part shape, with different names:

| Concept | Anthropic | Cursor | Codex | Copilot |
|---|---|---|---|---|
| Always-loaded baseline | `CLAUDE.md` | `alwaysApply: true` rule / AGENTS.md | `AGENTS.md` | `copilot-instructions.md` / `CLAUDE.md` |
| Path/glob-scoped rules | `.claude/rules/` + `paths:` | `.cursor/rules/` + `globs` | nested `AGENTS.md` / `*.override.md` | `.github/instructions/*.instructions.md` + `applyTo` |
| On-demand procedures | skills | `@`-mention manual rules | skills | prompt files / custom agents |

Takeaways that hold across all of them:
- **Smaller, scoped, specific beats large and general.** Size targets (200 lines / 500 lines / 32 KiB) all point the same way.
- **Reference, don't copy.** Pointers stay fresh; pasted content goes stale.
- **Instruction files are guidance, not enforcement.** Hard guarantees come from hooks/linters/CI.
- **Add a rule when you see a repeated mistake**, not preemptively.

### What this means for Mujtaba's setup specifically

1. **Top recommendation: slim `~/.claude/CLAUDE.md` toward 200 lines** by moving self-contained topic blocks into `~/.claude/rules/<topic>.md`. Candidates (each is a clean, mostly self-contained block today):
   - Em-dash rule → always-on rule file (no `paths:`); it must apply everywhere.
   - chrome-mcp / browser-automation guidance → always-on.
   - 1Password `op` how-to → always-on (or `paths:` scoped to `**/.env*`, `**/*.tf`, wrangler/plist files if you want to reclaim context).
   - Pencil design-tool default → `paths: '**/*.{pen,figma,tldraw}'`-scoped; it only matters for design work.
   This preserves behavior for the always-on rules and reclaims session context for the path-scoped ones. **Do not let a clone or sidequest apply this automatically; it is the main session's call.**
2. **Adopt `<!-- ... -->` for the maintainer notes** currently sitting as visible prose in CLAUDE.md files. Zero session cost, still visible on Read.
3. **Stay Claude-only for now; don't pre-build AGENTS.md.** It is lock-in risk tracking, not a today problem. The moment a second agent (Cursor, Codex, Copilot coding agent) enters a repo, add a root `AGENTS.md` and `@AGENTS.md` from that repo's `CLAUDE.md`. Because Copilot and Codex both honor a root `CLAUDE.md`, even that is optional until a vendor that needs AGENTS.md specifically shows up.
4. **The three-tier CLAUDE.md hierarchy is healthy** (user → workspace `~/dev/` → project). The last precedence audit found zero contradictions; keep lower tiers as pointer-up references, not restatements.
5. **Don't trim LOG.md / INDEX.md for token reasons.** They are not loaded at session start. Trim them only for human/agent findability.

### Open questions to revisit

- Does Claude Code honor a `description`-style "apply intelligently" mode like Cursor's, or only `paths:` vs always? As of this snapshot, Anthropic documents only `paths:` vs unconditional. If they add description-based selection, revisit recommendation #1 (some blocks could become description-scoped instead of path-scoped).
- Worth a `~/.claude/rules/` shared via symlink into specific `~/dev/` repos? Only if a rule is genuinely cross-repo but not universal. Probably premature.
