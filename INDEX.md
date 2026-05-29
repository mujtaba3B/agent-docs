# INDEX — agent-docs

Where to find things in this repo. Companion to `LOG.md` (chronological) and `CHANGELOG.md` (why each `CURRENT.md` revision happened).

## Core artifacts

| Artifact | Path | What |
|---|---|---|
| The synthesis | `CURRENT.md` | What agent files should contain in 2026-Q2. Ranked "if you only read one page" + per-vendor reference + cross-vendor reconciliation. Read this first. |
| Repo intro | `README.md` | Why this repo exists, layout, workflow. |
| Revision rationale | `CHANGELOG.md` | Why each `CURRENT.md` revision happened. |
| Project schema | `CLAUDE.md` | This repo's own schema (under the 200-line target it documents). |
| Decision log | `LOG.md` | Chronological why. |

## Upstream source snapshots

All under `sources/` (see `sources/README.md` for the inventory + refresh cadence).

| Vendor | File | URL |
|---|---|---|
| Anthropic (Claude Code) | `sources/anthropic-claude-code-memory-2026-05-29.md` | https://code.claude.com/docs/en/memory |
| agents.md | `sources/agents-md-spec-2026-05-29.md` | https://agents.md/ |
| Cursor | `sources/cursor-rules-2026-05-29.md` | https://cursor.com/docs/context/rules |
| OpenAI Codex | `sources/openai-codex-agents-md-2026-05-29.md` | https://developers.openai.com/codex/guides/agents-md |
| GitHub Copilot | `sources/github-copilot-custom-instructions-2026-05-29.md` | https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions |

## Skills

| Skill | Path | What |
|---|---|---|
| agent-files-architect | `skills/agent-files-architect/SKILL.md` | Audits and selectively improves a real CLAUDE.md / AGENTS.md / LOG.md / INDEX.md / MEMORY.md tree against the guidance in `CURRENT.md`. Symlinked into `~/.claude/skills/agent-files-architect`. Relocated here from `mutwo-skills` on 2026-05-29 (public to private). |

## External references

| Reference | Where | Why load-bearing |
|---|---|---|
| Cross-project schema | `~/dev/CLAUDE.md` | Three-file mandate, PR conventions, Codex review, PR assignee. |
| User-level rules | `~/.claude/CLAUDE.md` | The em-dash rule and other global rules; also the prime subject of `CURRENT.md`'s top recommendation (slim toward 200 lines). |
| Memory pointer | `~/.claude/projects/-Users-mujtaba-dev-agent-docs/memory/reference_agent_docs.md` | Tells future sessions to read `CURRENT.md` before significant agent-files edits. |
