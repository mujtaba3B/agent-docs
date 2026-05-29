# OpenAI Codex: Custom instructions with AGENTS.md

- Source: https://developers.openai.com/codex/guides/agents-md
- Also: https://raw.githubusercontent.com/openai/codex/main/docs/agents_md.md
- Fetched: 2026-05-29 (via gstack `/browse`)
- Vendor: OpenAI (Codex CLI / Codex)

> Snapshot of the canonical Codex AGENTS.md guide as of the fetch date. Chrome stripped.

---

## How Codex discovers guidance

Codex reads AGENTS.md files before doing any work and builds an instruction chain at startup (once per run; in the TUI, once per launched session). Discovery precedence:

1. **Global scope**: in the Codex home dir (`~/.codex` by default, or `CODEX_HOME`), Codex reads `AGENTS.override.md` if it exists, otherwise `AGENTS.md`. Only the first non-empty file at this level is used.
2. **Project scope**: starting at the project root (typically the Git root), Codex walks down to cwd. In each directory along the path it checks `AGENTS.override.md`, then `AGENTS.md`, then any `project_doc_fallback_filenames`. At most one file per directory.
3. **Merge order**: files concatenated root-down, joined with blank lines. Files closer to cwd override earlier guidance (they appear later in the combined prompt).

Codex skips empty files and stops adding files once the combined size reaches `project_doc_max_bytes` (**32 KiB by default**). Raise the limit or split across nested directories when you hit the cap.

## Global guidance (`~/.codex/AGENTS.md`)

Persistent defaults every repo inherits:

```markdown
# ~/.codex/AGENTS.md
## Working agreements
- Always run `npm test` after modifying JavaScript files.
- Prefer `pnpm` when installing dependencies.
- Ask for confirmation before adding new production dependencies.
```

Use `~/.codex/AGENTS.override.md` for a temporary global override without deleting the base file; remove it to restore shared guidance.

## Project instructions + nested overrides

Repo-root `AGENTS.md` covers project norms while inheriting global defaults:

```markdown
# AGENTS.md
## Repository expectations
- Run `npm run lint` before opening a pull request.
```

Nested directories can override with `AGENTS.override.md`, e.g. `services/payments/AGENTS.override.md`. When an override exists in a directory, the sibling `AGENTS.md` is ignored. Place overrides as close to specialized work as possible; Codex stops searching once it reaches cwd.

## Fallback filenames

If your repo uses a different name (e.g. `TEAM_GUIDE.md`), add it to the fallback list in `~/.codex/config.toml`:

```toml
project_doc_fallback_filenames = ["TEAM_GUIDE.md", ".agents.md"]
project_doc_max_bytes = 65536
```

Then per directory Codex checks: `AGENTS.override.md`, `AGENTS.md`, `TEAM_GUIDE.md`, `.agents.md`. Filenames not on this list are ignored for instruction discovery.

Set `CODEX_HOME` for a different profile: `CODEX_HOME=$(pwd)/.codex codex exec "List active instruction sources"`.

## Verify / troubleshoot

- Verify: `codex --ask-for-approval never "Summarize the current instructions."` from a repo root; Codex echoes guidance in precedence order. Use `codex --cd subdir ...` to confirm nested overrides.
- Audit which files loaded: `~/.codex/log/codex-tui.log` (or the latest `session-*.jsonl` if session logging is on).
- Codex rebuilds the chain on every run; no cache to clear.
- Common issues: nothing loads (wrong repo, or empty files ignored); wrong guidance (an `AGENTS.override.md` higher up or in Codex home); fallbacks ignored (typo in `project_doc_fallback_filenames`, restart needed); truncation (raise `project_doc_max_bytes` or split); profile confusion (check `echo $CODEX_HOME`).

## Hierarchical-agents flag (from the repo doc)

When the `child_agents_md` feature flag is enabled (via `[features]` in `config.toml`), Codex appends extra guidance about AGENTS.md scope and precedence to the user-instructions message, and emits that message even when no AGENTS.md is present.

## Note

Codex uses the open AGENTS.md format (agents.md), so the same file works across many agents. Codex also accepts `CLAUDE.md` / `GEMINI.md` indirectly through the shared-format ecosystem, but its native instruction file is AGENTS.md.
