# agent-docs

Mujtaba's personal best-practices reference for **agent instruction files** (CLAUDE.md, AGENTS.md, `.claude/rules/`, `.cursor/rules/`, Copilot custom instructions).

It exists so any future agent session consults one synthesized page (`CURRENT.md`) instead of re-running upstream research per project. When a session is about to do something nontrivial to an agent file (slim a CLAUDE.md, adopt `.claude/rules/`, write a first AGENTS.md, bootstrap a new repo), it reads `CURRENT.md` first.

Private repo. Single-maintainer.

## Layout

| Path | What |
|---|---|
| `CURRENT.md` | The synthesis you read: what agent files should contain in 2026-Q2, with a ranked "if you only read one page" section. |
| `sources/` | Date-stamped, chrome-stripped snapshots of upstream guidance (Anthropic, agents.md, Cursor, OpenAI Codex, GitHub Copilot) + a refresh-cadence note. |
| `skills/agent-files-architect/` | The skill that audits a real CLAUDE.md / AGENTS.md / LOG.md / INDEX.md / MEMORY.md tree against the guidance in `CURRENT.md`. Symlinked into `~/.claude/skills/`. |
| `CHANGELOG.md` | Why each revision of `CURRENT.md` happened. |
| `CLAUDE.md` / `LOG.md` / `INDEX.md` | The `~/dev/` three-file schema, applied to this repo (it eats its own dog food). |

## Workflow

- **Reading**: open `CURRENT.md`. Drop into `sources/` only when you need the primary text.
- **Updating**: when upstream guidance shifts, re-fetch via `/browse`, add a date-stamped `sources/` file, revise `CURRENT.md`, and record why in `CHANGELOG.md` + `LOG.md`.
- **Auditing a repo**: run `/agent-files-architect` (the skill in `skills/`). `--research` re-pulls upstream and surfaces drift against these snapshots.
