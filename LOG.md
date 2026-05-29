# LOG - agent-docs

Chronological decision log. Why things were decided, not every commit. Date-headed sections; entries tagged `[topic][subtopic]`. Companion to `INDEX.md` (where things live) and `CHANGELOG.md` (why each `CURRENT.md` revision happened).

## 2026-05-29

### `[meta][founding]` Repo founded after sms-hero session

Stood up `~/dev/agent-docs/` as a personal reference for agent instruction files. Trigger: a `/agent-files-architect --research` run during an sms-hero session re-derived upstream guidance (Anthropic, agents.md, Cursor) with no durable home for the findings. This repo is that home: `CURRENT.md` is the synthesis a future session reads instead of re-researching per project.

### `[sources][fetch]` Cached five upstream sources via /browse

Fetched fresh snapshots of Anthropic Claude Code memory docs, agents.md, Cursor rules, OpenAI Codex AGENTS.md, and GitHub Copilot custom instructions. The prior research run had covered only the first three; Codex and Copilot were fetched for the first time. Notable freshness vs the prior run: Anthropic's page now documents auto memory, `claudeMdExcludes`, and the `InstructionsLoaded` hook; agents.md is now under the Linux Foundation; Cursor added Team Rules. All in `sources/`.

### `[current][synthesis]` Founding CURRENT.md

Wrote `CURRENT.md` with a ranked "if you only read one page" section, per-vendor reference, and a cross-vendor reconciliation with opinions. Top recommendation baked in: Anthropic's <200-line CLAUDE.md target vs `~/.claude/CLAUDE.md` at ~400 lines / ~3,940 tokens; documented fix is `~/.claude/rules/<topic>.md` (none exist yet). The slim refactor itself is deliberately deferred to the main session, not applied from this sidequest.

### `[skill][relocate]` Moved agent-files-architect into this repo

`git mv` of `skills/agent-files-architect/` out of the public `mutwo-skills` repo into `agent-docs/skills/`. Re-pointed `~/.claude/skills/agent-files-architect` to the new location. Removal from `mutwo-skills` goes via a separate PR (its `main` is branch-protected). This deliberately flips the skill from public to private; agent-docs is now both the reference data and the skill's home.
