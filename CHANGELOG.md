# Changelog

Why each revision of `CURRENT.md` (and the repo) happened. Newest first.

## 2026-06-07 - Architect fires on a required-file gap

Added Trigger 4 to `agent-files-architect`'s `/close-out` gate. The gate previously fired only on TTL/activity signals (7 days, 10 sessions, 3 files touched), so the architect stayed silent in the exact case it is most useful: a project folder missing its agent files entirely. Trigger 4 is a cheap structural scan (one `git rev-parse` plus three `test -e`) that runs on every close-out and fires when the current project folder is missing one of `CLAUDE.md` / `LOG.md` / `INDEX.md`. "Project folder" is any git repo, OR any folder under the `~/dev/` workspace (caught even before `git init`, so a freshly-created `~/dev/newproj` is detected; because `~/dev` is itself a git repo, the resolver prefers a nested repo toplevel and otherwise falls back to the immediate child of `~/dev`). Stays silent at `~`, in `Downloads`, `/tmp`, and other non-`~/dev` non-repo dirs; honors `.agent-doctor-ignore`; never bootstraps placeholder files.

## 2026-05-29 - Founded

Founded after an sms-hero session in which `/agent-files-architect --research` re-ran upstream research (Anthropic, agents.md, Cursor) and produced findings that had nowhere durable to live. Standing up this repo so the synthesis is consulted once, not re-derived per project.

- Wrote the founding `CURRENT.md` synthesizing five upstream sources (Anthropic, agents.md, Cursor, OpenAI Codex, GitHub Copilot) with a ranked "if you only read one page" section.
- Cached fresh `/browse` snapshots of all five sources in `sources/` (Codex AGENTS.md and GitHub Copilot custom instructions were fetched for the first time this session; the prior research run had only covered Anthropic, agents.md, Cursor).
- Top finding baked in: Anthropic's <200-line-per-CLAUDE.md target vs `~/.claude/CLAUDE.md` at ~400 lines / ~3,940 tokens, with the `.claude/rules/<topic>.md` escape hatch as the recommended fix. The slim refactor itself is deliberately left to the main session, not applied here.
- Relocated the `agent-files-architect` skill into this repo (`skills/agent-files-architect/`) from the public `mutwo-skills` repo, deliberately flipping it from public to private. agent-docs is now both the reference data and the skill's home.
